const StudentLoan = artifacts.require("./StudentLoan.sol");

contract("StudentLoan", accounts => {

    it("createLoan", async () => {
        const accounts = await web3.eth.getAccounts();

        const _name = 'test name';
        const _description = 'test description';
        const _borrowerAddr = '0xb4ce4aa17223b553b12abd9f865893c452273526'; 
        const _lenderAddr = '0x0e24d686a336afecfe654798dc01bf03ea2caeb4';

        let student_loan = await new web3.eth.Contract(StudentLoan.abi, StudentLoan.address);

        let response = await student_loan.methods.createLoan(_name, _description, _borrowerAddr, _lenderAddr).send({ from: accounts[0] });
        console.log('=== createLoan function ===', response);   // Success
    });

});
