pragma solidity ^0.5.0;


contract StudentCreditScore {

    address private admin;
    uint creditScoreId;  // creditScoreId = 0

    struct CreditScore {
        address studentAddr;
        uint annualIncome;    // It is yearly salaly
        uint age;
        uint creditOfCourse;  // Number of being got credit of course in University where student has gone.
    }
    CreditScore[] public scores;


    event CreateCreditScore(address _studentAddr, uint _annualIncome, uint _age, uint _creditOfCourse, uint creditScoreId);
    event GetCreditScore(address _studentAddr, uint _annualIncome, uint _age, uint _creditOfCourse);
    

    constructor () public {
        //admin == msg.sender;
    }    


    // function createCreditScore(
    //     address _studentAddr,
    //     uint _annualIncome,
    //     uint _age,
    //     uint _creditOfCourse 
    // ) public returns (address, uint, uint, uint) 
    // {
    //     //CreditScore memory score = scores[creditScoreId];
    //     CreditScore storage score = scores[creditScoreId];
    //     score.studentAddr = _studentAddr;
    //     score.annualIncome = _annualIncome;
    //     score.age = _age;
    //     score.creditOfCourse = _creditOfCourse;

    //     scores.push(score);

    //     return (_studentAddr, _annualIncome, _age, _creditOfCourse);
    // }
    

    function createCreditScore(
        address _studentAddr,
        uint _annualIncome,
        uint _age,
        uint _creditOfCourse 
    ) public returns (address, uint, uint, uint, uint)
    {
        //require (admin == msg.sender, "You are not admin !!");
    
        CreditScore memory score = CreditScore({
            studentAddr: _studentAddr,
            annualIncome: _annualIncome,
            age: _age,
            creditOfCourse: _creditOfCourse
        });
        scores.push(score);

        emit CreateCreditScore(_studentAddr, _annualIncome, _age, _creditOfCourse, creditScoreId);
    
        return (_studentAddr, _annualIncome, _age, _creditOfCourse, creditScoreId);
    }
    
    
    function saveCreditScore(uint creditScoreId) public {
        CreditScore storage score = scores[creditScoreId];
        score.studentAddr = scores[creditScoreId].studentAddr;
        score.annualIncome = scores[creditScoreId].annualIncome;
        score.age = scores[creditScoreId].age;
        score.creditOfCourse = scores[creditScoreId].creditOfCourse;

        creditScoreId++;
    }


    function getCreditScore(uint id) public returns (address, uint, uint, uint) {
        CreditScore storage score = scores[id];

        emit GetCreditScore(score.studentAddr, score.annualIncome, score.age, score.creditOfCourse);

        return (score.studentAddr, score.annualIncome, score.age, score.creditOfCourse);
    }
    

}
