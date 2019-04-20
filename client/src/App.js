import React, { Component } from "react";
import getWeb3, { getGanacheWeb3, Web3 } from "./utils/getWeb3";
import Header from "./components/Header/index.js";
import Footer from "./components/Footer/index.js";
import Hero from "./components/Hero/index.js";
import Web3Info from "./components/Web3Info/index.js";
import CounterUI from "./components/Counter/index.js";
import Wallet from "./components/Wallet/index.js";
import Instructions from "./components/Instructions/index.js";
import { Loader, Button, Card, Input } from 'rimble-ui';

import { zeppelinSolidityHotLoaderOptions } from '../config/webpack';

import styles from './App.module.scss';

class App extends Component {

    constructor(props) {
    super(props);

    this.state = {
      /////// Default state
      storageValue: 0,
      web3: null,
      accounts: null,
      contract: null,
      route: window.location.pathname.replace("/",""),

      /////// Added state
      valueOfMintBy: '',
      valueOfMintToken: '',
      value_of_mint_by: '',
      value_of_mint_token: ''
    };

    /////// Bind something
    //this.handleInput = this.handleInput.bind(this);
    this.handleInputMintBy = this.handleInputMintBy.bind(this);
    this.handleInputMintToken = this.handleInputMintToken.bind(this);
  }


  getTotalSupply = async () => {
    const { student_loan_token } = this.state;
    const response = await student_loan_token.methods.totalSupply().call();
    console.log('=== response of totalSupply function ===', response);

    // Update state with the result.
    this.setState({ total_supply: response });
  };


  getBalanceOf = async () => {
    const { student_loan_token } = this.state;

    ///// Import Web3 from /utils/getWeb3.js
    const web3 = new Web3(window.ethereum);
    const accounts = await web3.eth.getAccounts();
    const _ownerAddress = accounts[0]

    ///// Temporary (Constant)
    //const _ownerAddress = '0x8Fc9d07b1B9542A71C4ba1702Cd230E160af6EB3'

    const response = await student_loan_token.methods.balanceOf(_ownerAddress).call();
    console.log('=== response of balanceOf function ===', response);

    // Update state with the result.
    this.setState({ balance_of: response });
  };


  ////// Send MintToken function
  handleInputMintBy({ target: { value } }) {
    this.setState({ valueOfMintBy: value });
    console.log("=== [handleInputMintBy]： value ===", value); 
  }

  handleInputMintToken({ target: { value } }) {
    this.setState({ valueOfMintToken: value });
    console.log("=== [handleInputMintToken]： value ===", value); 
  }

  sendMintToken = async (to, value) => {
    const { student_loan_token, accounts, valueOfMintBy, valueOfMintToken } = this.state;

    const response = await student_loan_token.methods.mintToken(valueOfMintBy, valueOfMintToken).send({ from: accounts[0] })
    console.log('=== response of mintToken function ===', response);

    /////// Update state with the result.
    this.setState({
      valueOfMintBy: '',
      valueOfMintToken: '',
      value_of_mint_by: valueOfMintBy,
      value_of_mint_token: valueOfMintToken
    });
  }



  //////////////////////////////////// 
  ///// Ganache
  ////////////////////////////////////
  getGanacheAddresses = async () => {
    if (!this.ganacheProvider) {
      this.ganacheProvider = getGanacheWeb3();
    }
    if (this.ganacheProvider) {
      return await this.ganacheProvider.eth.getAccounts();
    }
    return [];
  }

  componentDidMount = async () => {
    const hotLoaderDisabled = zeppelinSolidityHotLoaderOptions.disabled;
    let Counter = {};
    let Wallet = {};
    let StudentLoanToken = {};
    try {
      // Counter = require("../../contracts/Counter.sol");
      // Wallet = require("../../contracts/Wallet.sol");
      // StudentLoanToken = require("../../contracts/StudentLoanToken.sol");
      Counter = require("../../build/contracts/Counter.json");
      Wallet = require("../../build/contracts/Wallet.json");
      StudentLoanToken = require("../../build/contracts/StudentLoanToken.json");  // Load ABI of contract of StudentLoanToken
    } catch (e) {
      console.log(e);
    }
    try {
      const isProd = process.env.NODE_ENV === 'production';
      if (!isProd) {
        // Get network provider and web3 instance.
        const web3 = await getWeb3();
        let ganacheAccounts = [];
        try {
          ganacheAccounts = await this.getGanacheAddresses();
        } catch (e) {
          console.log('Ganache is not running');
        }
        // Use web3 to get the user's accounts.
        const accounts = await web3.eth.getAccounts();
        // Get the contract instance.
        const networkId = await web3.eth.net.getId();
        const networkType = await web3.eth.net.getNetworkType();
        const isMetaMask = web3.currentProvider.isMetaMask;
        let balance = accounts.length > 0 ? await web3.eth.getBalance(accounts[0]): web3.utils.toWei('0');
        balance = web3.utils.fromWei(balance, 'ether');
        let instance = null;
        let instanceWallet = null;
        let instanceStudentLoanToken = null;
        let deployedNetwork = null;
        if (Counter.networks) {
          deployedNetwork = Counter.networks[networkId.toString()];
          if (deployedNetwork) {
            instance = new web3.eth.Contract(
              Counter.abi,
              deployedNetwork && deployedNetwork.address,
            );
          }
        }
        if (Wallet.networks) {
          deployedNetwork = Wallet.networks[networkId.toString()];
          if (deployedNetwork) {
            instanceWallet = new web3.eth.Contract(
              Wallet.abi,
              deployedNetwork && deployedNetwork.address,
            );
          }
        }
        if (StudentLoanToken.networks) {
          deployedNetwork = StudentLoanToken.networks[networkId.toString()];
          if (deployedNetwork) {
            instanceStudentLoanToken = new web3.eth.Contract(
              StudentLoanToken.abi,
              deployedNetwork && deployedNetwork.address,
            );
            console.log('=== instanceStudentLoanToken ===', instanceStudentLoanToken);
          }
        }
        if (instance || instanceWallet || instanceStudentLoanToken) {
          // Set web3, accounts, and contract to the state, and then proceed with an
          // example of interacting with the contract's methods.
          this.setState({ web3, ganacheAccounts, accounts, balance, networkId, networkType, hotLoaderDisabled,
            isMetaMask, contract: instance, wallet: instanceWallet, student_loan_token: instanceStudentLoanToken }, () => {
              this.refreshValues(instance, instanceWallet, instanceStudentLoanToken);
              setInterval(() => {
                this.refreshValues(instance, instanceWallet, instanceStudentLoanToken);
              }, 5000);
            });
        }
        else {
          this.setState({ web3, ganacheAccounts, accounts, balance, networkId, networkType, hotLoaderDisabled, isMetaMask });
        }
      }
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  componentWillUnmount() {
    if (this.interval) {
      clearInterval(this.interval);
    }
  }

  refreshValues = (instance, instanceWallet, instanceStudentLoanToken) => {
    if (instance) {
      this.getCount();
    }
    if (instanceWallet) {
      this.updateTokenOwner();
    }
    if (instanceStudentLoanToken) {
      console.log('refreshValues of instanceStudentLoanToken');
    }
  }

  getCount = async () => {
    const { contract } = this.state;
    // Get the value from the contract to prove it worked.
    const response = await contract.methods.getCounter().call();
    // Update state with the result.
    this.setState({ count: response });
  };

  updateTokenOwner = async () => {
    const { wallet, accounts } = this.state;
    // Get the value from the contract to prove it worked.
    const response = await wallet.methods.owner().call();
    // Update state with the result.
    this.setState({ tokenOwner: response.toString() === accounts[0].toString() });
  };

  increaseCount = async (number) => {
    const { accounts, contract } = this.state;
    await contract.methods.increaseCounter(number).send({ from: accounts[0] });
    this.getCount();
  };

  decreaseCount = async (number) => {
    const { accounts, contract } = this.state;
    await contract.methods.decreaseCounter(number).send({ from: accounts[0] });
    this.getCount();
  };

  renounceOwnership = async (number) => {
    const { accounts, wallet } = this.state;
    await wallet.methods.renounceOwnership().send({ from: accounts[0] });
    this.updateTokenOwner();
  };

  renderLoader() {
    return (
      <div className={styles.loader}>
        <Loader size="80px" color="red" />
        <h3> Loading Web3, accounts, and contract...</h3>
        <p> Unlock your metamask </p>
      </div>
    );
  }

  renderDeployCheck(instructionsKey) {
    return (
      <div className={styles.setup}>
        <div className={styles.notice}>
          Your <b> contracts are not deployed</b> in this network. Two potential reasons: <br />
          <p>
            Maybe you are in the wrong network? Point Metamask to localhost.<br />
            You contract is not deployed. Follow the instructions below.
          </p>
        </div>
        <Instructions
          ganacheAccounts={this.state.ganacheAccounts}
          name={instructionsKey} accounts={this.state.accounts} />
      </div>
    );
  }

  renderBody() {
    const { hotLoaderDisabled, networkType, accounts, ganacheAccounts } = this.state;
    const updgradeCommand = (networkType === 'private' && !hotLoaderDisabled) ? "upgrade-auto" : "upgrade";
    return (
      <div className={styles.wrapper}>
        {!this.state.web3 && this.renderLoader()}
        {this.state.web3 && !this.state.contract && (
          this.renderDeployCheck('counter')
        )}
        {this.state.web3 && this.state.contract && (
          <div className={styles.contracts}>
            <h1>Counter Contract is good to Go!</h1>
            <p>Interact with your contract on the right.</p>
            <p> You can see your account onfo on the left </p>
            <div className={styles.widgets}>
              <Web3Info {...this.state} />
              <CounterUI
                decrease={this.decreaseCount}
                increase={this.increaseCount}
                {...this.state} />
            </div>
            {this.state.balance < 0.1 && (
              <Instructions
                ganacheAccounts={ganacheAccounts}
                name="metamask"
                accounts={accounts} />
            )}
            {this.state.balance >= 0.1 && (
              <Instructions
                ganacheAccounts={this.state.ganacheAccounts}
                name={updgradeCommand}
                accounts={accounts} />
            )}
          </div>
        )}
      </div>
    );
  }

  renderInstructions() {
    return (
      <div className={styles.wrapper}>
        <Hero />
        <Instructions
          ganacheAccounts={this.state.ganacheAccounts}
          name="setup" accounts={this.state.accounts} />
      </div>
    );
  }

  renderEVM() {
    return (
      <div className={styles.wrapper}>
      {!this.state.web3 && this.renderLoader()}
      {this.state.web3 && !this.state.wallet && (
        this.renderDeployCheck('evm')
      )}
      {this.state.web3 && this.state.wallet && (
        <div className={styles.contracts}>
          <h1>Wallet Contract is good to Go!</h1>
          <p>Interact with your contract on the right.</p>
          <p> You can see your account onfo on the left </p>
          <div className={styles.widgets}>
            <Web3Info {...this.state} />
            <Wallet
              renounce={this.renounceOwnership}
              {...this.state} />
          </div>
          <Instructions
            ganacheAccounts={this.state.ganacheAccounts}
            name="evm" accounts={this.state.accounts} />
        </div>
      )}
      </div>
    );
  }

  renderStudentLoanToken() {
    const { total_supply, balance_of } = this.state;

    return (
      <div className={styles.wrapper}>
      {!this.state.web3 && this.renderLoader()}
      {this.state.web3 && !this.state.student_loan_token && (
        this.renderDeployCheck('student_loan_token')
      )}
      {this.state.web3 && this.state.student_loan_token && (
        <div className={styles.contracts}>
          <h1>Manager of Student Loan Token</h1>

          <div className={styles.widgets}>
            <Card width={'420px'} bg="primary">
              <div className={styles.widgets}>
                <p>Total Supply</p>

                <Button onClick={this.getTotalSupply}>Get Total Supply</Button>

                <br />

                {total_supply}
              </div>
            </Card>

            <Card width={'420px'} bg="primary">
              <div className={styles.widgets}>
                <p>Balance</p>

                <Button onClick={this.getBalanceOf}>Get Balance</Button>

                {balance_of}
              </div>
            </Card>

            <Card width={'420px'} bg="primary">
              <div className={styles.widgets}>
                <p>Mint Token</p> 

                <p>To</p>
                <Input type="text" value={this.state.valueOfMintBy} onChange={this.handleInputMintBy} />

                <p>Value of minting token</p>
                <Input type="text" value={this.state.valueOfMintToken} onChange={this.handleInputMintToken} />

                <Button onClick={this.sendMintToken}>Mint Token</Button>
              </div>
            </Card>

            <Card width={'420px'} bg="primary">
              <div className={styles.widgets}>
                <p>Burn Token</p>

                <Button onClick={this.sendCreateProposal}>Burn Token</Button>
              </div>
            </Card>
          </div>
        </div>
      )}
      </div>
    );
  }

  render() {
    return (
      <div className={styles.App}>
        <Header />
          {this.state.route === '' && this.renderInstructions()}
          {this.state.route === 'counter' && this.renderBody()}
          {this.state.route === 'evm' && this.renderEVM()}
          {this.state.route === 'student_loan_token' && this.renderStudentLoanToken()}
        <Footer />
      </div>
    );
  }
}

export default App;
