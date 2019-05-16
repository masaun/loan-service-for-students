pragma solidity ^0.5.0;


contract StudentCreditScore {

    address private admin;
    //uint creditScoreId;  // creditScoreId = 0
    uint studentId;        // studentId = 0

    struct CreditScore {
        //address studentAddr;
        uint annualIncome;    // It is yearly salaly
        uint age;
        uint creditOfCourse;  // Number of being got credit of course in University where student has gone.
        uint reputation;
        uint borrowLimit;
    }
    //CreditScore[] public scores;


    // When Student who is a borrower login, register infomation below 
    struct StudentProfile {
        address studentAddress;
        string studentName;
        string universityName;
        uint grade;
        mapping (address => CreditScore) scores;
    }
    StudentProfile[] public profiles;

    event CreateCreditScore(uint _annualIncome, uint _age, uint _creditOfCourse);
    //event CreateCreditScore(address _studentAddr, uint _annualIncome, uint _age, uint _creditOfCourse, uint creditScoreId);
    event GetCreditScore(uint _annualIncome, uint _age, uint _creditOfCourse);
    //event GetCreditScore(address _studentAddr, uint _annualIncome, uint _age, uint _creditOfCourse);
    

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
    

    // function createCreditScore(
    //     address _studentAddr,
    //     uint _annualIncome,
    //     uint _age,
    //     uint _creditOfCourse 
    // ) public returns (address, uint, uint, uint, uint)
    // {
    //     //require (admin == msg.sender, "You are not admin !!");

    //     CreditScore memory score = CreditScore({
    //         studentAddr: _studentAddr,
    //         annualIncome: _annualIncome,
    //         age: _age,
    //         creditOfCourse: _creditOfCourse
    //     });
    //     scores.push(score);

    //     emit CreateCreditScore(_studentAddr, _annualIncome, _age, _creditOfCourse, creditScoreId);
    
    //     return (_studentAddr, _annualIncome, _age, _creditOfCourse, creditScoreId);
    // }
    
    
    function saveCreditScore(
        uint _studentId, 
        address _studentAddress,
        uint _annualIncome,
        uint _age,
        uint _creditOfCourse 
    ) public returns (uint, uint, uint)
    {
    //function saveCreditScore(uint creditScoreId) public {
        CreditScore storage score = profiles[_studentId].scores[_studentAddress];
        //CreditScore storage score = scores[creditScoreId];

        score.annualIncome = profiles[_studentId].scores[_studentAddress].annualIncome;
        score.age = profiles[_studentId].scores[_studentAddress].age;
        score.creditOfCourse = profiles[_studentId].scores[_studentAddress].creditOfCourse;
        // score.studentAddr = scores[creditScoreId].studentAddr;
        // score.annualIncome = scores[creditScoreId].annualIncome;
        // score.age = scores[creditScoreId].age;
        // score.creditOfCourse = scores[creditScoreId].creditOfCourse;
        score.reputation = getReputation(_studentAddress);
        score.borrowLimit = getBorrowLimit(_studentAddress);

        // creditScoreId++;

        emit CreateCreditScore(_annualIncome, _age, _creditOfCourse);
    
        return (_annualIncome, _age, _creditOfCourse);
    }

    function getReputation(address _studentAddress) private returns (uint) {
        uint _reputation = 100;  // [In progress] It mean score of reputation. It assign figure of constant so far.
        return _reputation;
    }
    
    function getBorrowLimit(address _studentAddress) private returns (uint) {
        uint _borrowLimit = 100;  // [In progress] It mean amount of limit of borrow. It assign figure of constant so far.
        return _borrowLimit;
    }




    function getCreditScore(uint _studentId, address _studentAddress) public returns (uint, uint, uint) {
    //function getCreditScore(uint id) public returns (address, uint, uint, uint) {
        CreditScore storage score = profiles[_studentId].scores[_studentAddress];
        //CreditScore storage score = scores[id];

        emit GetCreditScore(score.annualIncome, score.age, score.creditOfCourse);
        //emit GetCreditScore(score.studentAddr, score.annualIncome, score.age, score.creditOfCourse);

        return (score.annualIncome, score.age, score.creditOfCourse);
        //return (score.studentAddr, score.annualIncome, score.age, score.creditOfCourse);
    }
    





}
