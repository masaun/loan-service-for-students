const StudentLoan = artifacts.require("./StudentLoan.sol");

contract("StudentLoan", accounts => {

    it("setBorrower", async () => {
        const accounts = await web3.eth.getAccounts();

        const borrowerId = 0;
        const _borrowerAddr = '0x46eE041Dc142117FD9a9D1011178Df5066e29d42';

        let student_loan = await new web3.eth.Contract(StudentLoan.abi, StudentLoan.address);

        let response = await student_loan.methods.setBorrower(0, accounts[1]).send({ from: accounts[0], gas:3000000 });
        //let response = await student_loan.methods.createLoan(_name, _description, _borrowerAddr, _lenderAddr).send({ from: accounts[0] });
        console.log('=== setBorrower function ===', response);   // Success
    });


    it("createLoan", async () => {
        const accounts = await web3.eth.getAccounts();

        const _name = 'test name';
        const _description = 'test description';
        const _borrowerAddr = '0xb4ce4aa17223b553b12abd9f865893c452273526'; 
        const _lenderAddr = '0x0e24d686a336afecfe654798dc01bf03ea2caeb4';

        let student_loan = await new web3.eth.Contract(StudentLoan.abi, StudentLoan.address);
        //console.log('=== student_loan ===', student_loan);   // Success

        //let response = await student_loan.methods.createLoan(_name, _description).send({ from: accounts[0] });
        let response = await student_loan.methods.createLoan(_name, _description, _borrowerAddr, _lenderAddr).send({ from: accounts[0], gas:3000000 });
        console.log('=== createLoan function ===', response);   // Success
    });

});
