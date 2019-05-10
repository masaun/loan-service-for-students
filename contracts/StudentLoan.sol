pragma solidity ^0.5.0;

/**
 * [In progress] The Student Loan contract that has basic function of borrow and lend.
 */
contract StudentLoan {

    // struct User {
    //     uint userId;
    //     address addr;
    //     string role;  // Borrower（Student）or Lender
    // }
    
    struct Borrower {
        uint borrowerId;
        string borrowerName;
        address addr;
        uint balance; 
    }
    
    struct Lender {
        uint lenderId;
        string lenderName;
        address addr;
        uint balance; 
    }
    

    uint public loanId;     // A unique number that increments with every newly created loan

    struct LoanData {
        uint id;                                 // Loan ID
        string name;                             // Name of  the Loan
        mapping (uint => Borrower) borrowers;
        mapping (uint => Lender) lenders;        
        
        uint regTime;                           // UNIX Timestamp
        mapping (address => uint) userToId;     // Gets local user id belonging (mapped to) an address in loan
        uint[] loanAmounts;                     // corresponding to participants
        bool[] approvalStatus;                  // Array to store approvals
        //address[] userList;
        address[] userList;
        uint8 numOfUsers;
    }
    LoanData[] public loans;


    // Public array of all participants in dApp/Smart Contract (maybe unnecessary)
    userData[] public users;

    mapping (address => userData) addressToUserData;
    //mapping (address => mapping (uint => bool)) addressAssociated;
    mapping (uint => address) loanToRegistrar;
    mapping (address => uint) userLoanCount;



    function createLoan (string memory _name, string memory _dataString) public {

        loanToRegistrar[loanId] = msg.sender;   // Store the address of the user in mapping
        userLoanCount[msg.sender]++;            // necessary for array to count loans registered by user

        // create LoanData instance in memory, later populate array
        LoanData memory ln;
        ln.id = loanId;
        ln.name = _name;
        ln.regTime = now;

        loans.push(ln);

        // Add loan creator himself/herself
        addUserToLoan(loanId, msg.sender);
        loanId++; // Increment unique number
    }


    /*
    Function to add new users to a loan, checks if user has been added before
    */
    function addUserToLoan (uint _loanId, address _account) public onlyRegistrar(_loanId) returns (uint){

        // The following three lines check that the zero-address cant be added and prohibit double registration
        require(_account != address(0));
        require(addressAssociated[_account][_loanId] == false, "User already exists in loan");
        addressAssociated[_account][_loanId] = true;

        userLoanCount[_account]++;
        uint userNum = loans[_loanId].numOfUsers++;
        // Adds user to mapping of loan (analog to incremented numOfUsers)
        loans[_loanId].userToId[_account] = userNum;
        // Pushes address to userList array (to retrieve all users, iterate)
        loans[_loanId].userList.push(_account);

        // Let size of arrays that correspond with users grow in size
        loans[_loanId].approvalStatus.length++;
        loans[_loanId].loanAmounts.length++;
        return userNum;
    }


}
