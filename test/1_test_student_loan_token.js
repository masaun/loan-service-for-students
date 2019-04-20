const StudentLoanToken = artifacts.require("./StudentLoanToken.sol");

contract("StudentLoanToken", accounts => {
    it("...should put 100FNL in the first account.", async () => {
        // Get instance of StudentLoanToken contract
        const studentLoanTokenInstance = await StudentLoanToken.deployed();

        // Get balance of account[0]
        let balance = await studentLoanTokenInstance.balanceOf(accounts[0]);
        console.log('=== balance of accounts[0] ===', balance);

        // Convert unit from wei to ether
        balance = web3.utils.fromWei(balance, "ether");
        console.log('=== balance of accounts[0] (Convert unit from wei to ether) ===', balance);

        // Compare between balance and 100
        // If both is same, it is successful
        assert.equal(balance, 100, "First account don't have 100 FNL.");
    });


    it("Get name of studentLoanTokenInstance", async () => {
        const instance = await StudentLoanToken.deployed()
        //console.log('=== name of studentLoanToken ===', instance.name())
        instance.name().then((result) => {
          console.log('=== name of studentLoanToken ===', result);  // Success（"StudentLoanToken"）
        });
    });


    it("Get name of totalSupply", async () => {

        const instance = await StudentLoanToken.deployed()

        /*** Display totalSupply by uint of Wei ***/
        instance.totalSupply().then((result) => {
          console.log('=== totalSupply of studentLoanToken (unit of Wei) ===', result);  // Success（"<BN: 56bc75e2d63100000>"）
        });

        /*** Display totalSupply by uint of Ether ***/
        instance.totalSupply().then((result) => {
          const b = web3.utils.fromWei(result, 'ether')
          console.log('=== totalSupply of studentLoanToken (unit of Ehter) ===', b);  // Success（"100"）
        });
    });


    it("Mint token", async () => {
        const accounts = await web3.eth.getAccounts();
        //console.log('=== accounts ===', accounts);  // Success

        const _to = accounts[0];
        const _value = 10;

        let student_loan_token = await new web3.eth.Contract(StudentLoanToken.abi, StudentLoanToken.address);
        //console.log('=== student_loan_token ===', student_loan_token);

        let response_mintToken = await student_loan_token.methods.mintToken(_to, _value).send({from: accounts[0]});
        console.log('=== mintToken function ===', response_mintToken);   // Success (be able to check log of Tx)
    });


    it("Burn token", async () => {
        const accounts = await web3.eth.getAccounts();
        const _value = 10;

        let student_loan_token = await new web3.eth.Contract(StudentLoanToken.abi, StudentLoanToken.address);

        let response_burnToken = await student_loan_token.methods.burnToken(_value).send({from: accounts[0]});
        console.log('=== burnToken function ===', response_burnToken);   // Success (be able to check log of Tx)
    });


    it("totalSupply", async () => {
        const accounts = await web3.eth.getAccounts();

        let student_loan_token = await new web3.eth.Contract(StudentLoanToken.abi, StudentLoanToken.address);

        let totalSupply_ERC20 = await student_loan_token.methods.totalSupply().call();
        console.log('=== totalSupply function ===', totalSupply_ERC20);   // Success
    });


    it("Maker.create test of Dai.js", async () => {
        const maker = Maker.create('test');
        await maker.authenticate();

        transferDai(address, amount) {
          const dai = maker.service('token').getToken('DAI');
          return dai.transfer(address, amount);
        }
        console.log('=== dai ===', dai);   // Success
    });
});
