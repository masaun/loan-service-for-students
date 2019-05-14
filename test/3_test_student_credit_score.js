const StudentCreditScore = artifacts.require("./StudentCreditScore.sol");

contract("StudentCreditScore", accounts => {

    it("createCreditScore", async () => {
        const accounts = await web3.eth.getAccounts();

        const _studentAddr = '0x5e70db85663e1a4132da942065c315d966d73503';
        const _annualIncome = 1000;
        const _age = 21;
        const _creditOfCourse = 15; 

        let student_credit_score = await new web3.eth.Contract(StudentCreditScore.abi, StudentCreditScore.address);

        let response = await student_credit_score.methods.createCreditScore(_studentAddr, _annualIncome, _age, _creditOfCourse).send({ from: accounts[0] });
        console.log('=== createCreditScore function ===', response);   // Success
    });


});
