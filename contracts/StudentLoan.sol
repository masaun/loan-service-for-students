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
        address addr;
        uint balance; 

    }
    
    struct Lender {
        uint lenderId;
        address addr;
        uint balance; 
    }
    

    uint public loanId;     // A unique number that increments with every newly created loan

    struct LoanData {
        uint id;                                // Loan ID
        string name;                            // Name of  the Loan
        uint revisionNumber;                    // Shall increment with every update to the loan
        address registeringParty;               // Party who registered the loan. Possible unnecessary because of mapping  loanToRegistrar
        string dataString;                      // formerly "purpose", now general data string
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
    mapping (address => mapping (uint => bool)) addressAssociated;
    mapping (uint => address) loanToRegistrar;
    mapping (address => uint) userLoanCount;



    function createLoan (string memory _name, string memory _dataString) public {

        loanToRegistrar[loanId] = msg.sender;   // Store the address of the user in mapping
        userLoanCount[msg.sender]++;            // necessary for array to count loans registered by user

        // create LoanData instance in memory, later populate array
        LoanData memory ln;
        ln.id = loanId;
        ln.name = _name;
        ln.revisionNumber = 0;
        ln.registeringParty = msg.sender;
        ln.dataString = _dataString;
        ln.regTime = now;

        loans.push(ln);

        // Add loan creator himself/herself
        addUserToLoan(loanId, msg.sender);
        loanId++; // Increment unique number
    }


}
