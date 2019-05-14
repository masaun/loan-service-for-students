pragma solidity ^0.5.0;


contract StudentCreditScore {

    uint creditScoreId;  // creditScoreId = 0

    struct CreditScore {
        address studentAddr;
        uint annualIncome;    // It is yearly salaly
        uint age;
        uint creditOfCourse;  // Number of being got credit of course in University where student has gone.
    }
    CreditScore[] public scores;
    

    constructor () public {
        // In progress
    }    


    function createCreditScore( 
        address _studentAddr,
        uint _annualIncome,
        uint _age,
        uint _creditOfCourse 
    ) public returns (address, uint, uint, uint) 
    {
        CreditScore storage score = scores[creditScoreId];
        score.studentAddr = _studentAddr;
        score.annualIncome = _annualIncome;
        score.age = _age;
        score.creditOfCourse = _creditOfCourse;

        return (_studentAddr, _annualIncome, _age, _creditOfCourse);
    }
    

}
