pragma solidity ^0.5.0;

/**
 * [In progress] The Student Loan contract that has basic function of borrow and lend.
 */
contract StudentLoan {

    uint public borrowerId;

    struct Borrower {
        uint id;
        string name;
        address addr;
        uint balance; 
    }
    Borrower[] public borrowers;
    

    uint public lenderId;

    struct Lender {
        uint id;
        string name;
        address addr;
        uint balance; 
    }
    Lender[] public lenders;
    

    uint public loanId;

    struct LoanData {
        uint id;                                 // Id of Loan
        string name;                             // Name ofLoan
        mapping (uint => Borrower) borrowers;
        mapping (uint => Lender) lenders;
        uint term;                               // Term of Repay of Loan
        uint rate;                               // Rate of Loan
        uint recordTime;                         // timestamp from UNIX
    }
    LoanData[] public loans;


    event SetBorrower(uint indexed borrowerId, address indexed _borrowerAddr);
    event SetLender(uint indexed lenderId, address indexed _lenderAddr);
    

    constructor () public {
        string memory name = 'first user';

        LoanData memory ln = LoanData({
            id: loanId,
            name: name,
            recordTime: now
        });
        loans.push(ln);
 

        string memory nameOfFirstBorrower = 'first borrower';
        address addressOfFirstBorrower;

        Borrower memory borrower = Borrower({
            id: borrowerId,
            name: nameOfFirstBorrower,
            addr: addressOfFirstBorrower,
            balance: 150
        });


        string memory nameOfFirstLender = 'first lender';
        address addressOfFirstLender;

        Lender memory lender = Lender({
            id: lenderId,
            name: nameOfFirstLender,
            addr: addressOfFirstLender,
            balance: 150
        });
    }


    function createLoan (
        string memory _name, 
        string memory _description,
        address _borrowerAddr,
        address _lenderAddr
    ) public returns (string memory, string memory, address, address)
    {
        LoanData storage ln = loans[loanId];
        ln.id = loanId;
        ln.name = _name;
        ln.recordTime = now;

        loans.push(ln);


        // Set infomation of borrower
        setBorrower(borrowerId, _borrowerAddr);
        borrowerId++;

        // Set infomation of lender
        setLender(lenderId, _lenderAddr);
        lenderId++;

        return (_name, _description, _borrowerAddr, _lenderAddr);
    }


    function setBorrower(uint borrowerId, address _borrowerAddr) public returns (uint, address) {
        Borrower memory borrower = borrowers[borrowerId];
        borrower.id = borrowerId;
        borrower.name = 'Test Borrower'; // Note that it is constant value of test
        borrower.addr = _borrowerAddr;
        borrower.balance = 5000;         // Note that it is constant value of test

        emit SetBorrower(borrowerId, _borrowerAddr);

        return (borrowerId, _borrowerAddr);
    }


    function setLender(uint lenderId, address _lenderAddr) public returns (uint, address) {
        Lender memory lender = lenders[lenderId];
        lender.id = lenderId;
        lender.name = 'Test Lender'; // Note that it is constant value of test
        lender.addr = _lenderAddr;
        lender.balance = 10000;      // Note that it is constant value of test

        emit SetLender(lenderId, _lenderAddr);

        return (lenderId, _lenderAddr);
    }
    
}
