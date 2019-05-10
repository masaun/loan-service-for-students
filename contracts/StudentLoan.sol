pragma solidity ^0.5.0;

/**
 * [In progress] The Student Loan contract that has basic function of borrow and lend.
 */
contract StudentLoan {

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
        address[] userList;
        uint8 numOfUsers;
    }
    LoanData[] public loans;

    struct userData {
        string name;
        string role;        // Borrower or Lender
        address account;
    }

    // Public array of all participants in dApp/Smart Contract (maybe unnecessary)
    userData[] public users;

    // Dictionary to find account data
    mapping (address => userData) addressToUserData;

    // Necessary to require user can only added to a loan once
    mapping (address => mapping (uint => bool)) addressAssociated;

    // Map a loan id to an account address of registrating user
    mapping (uint => address) loanToRegistrar;

    // counts the amount of loans belonging to the address
    mapping (address => uint) userLoanCount;

    /*
    Modifier to check that sender is the registrar of the loan
    */
    modifier onlyRegistrar(uint _loanId) {
      require(msg.sender == loanToRegistrar[_loanId], "Only the owner of the loan has permission for this action");
      _;
    }

    /*
    Modifier to check if sender is participant of a loan
    */
    modifier onlyParticipant (uint _loanId) {
      require(loans[_loanId].userToId[msg.sender] != 0 || loanToRegistrar[_loanId] == msg.sender, "You are not part of this loan");
      _;
    }


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


    /*
    Update Loan Data, increment version / revision number
    Here, all the other data like loan amount, start date and other conditions shall be filled
    */
    function updateLoan(uint _loanId, string memory _name, string memory _dataString, uint _loanAmount)
        public onlyParticipant(_loanId)
    {
        loans[_loanId].name = _name;
        loans[_loanId].dataString = _dataString;

        // Save specified loan amount in array corresponding to user index
        uint userId = loans[_loanId].userToId[msg.sender];
        loans[_loanId].loanAmounts[userId] = _loanAmount;

        loans[_loanId].revisionNumber++;
        resetApprovals(_loanId);
    }

    /*
    Functionality to delete loan
    */
    function deleteLoan(uint _id) public onlyRegistrar(_id) {
        delete loans[_id];
    }


    /*
    Approves Loan: each participant of Loan can give his approval
    */
    function approveLoan(uint _loanId, uint _revisionNumber) public  {
        uint userId = loans[_loanId].userToId[msg.sender];
        require(loans[_loanId].revisionNumber == _revisionNumber, "Versions of the loan do not match");
        loans[_loanId].approvalStatus[userId] = true;
    }

    /*
    Function to reset approvals called after loan has been updated
    */
    function resetApprovals(uint _loanId) internal {
        uint n = loans[_loanId].approvalStatus.length;
        for (uint i=0; i < n; i++) {
            loans[_loanId].approvalStatus[i] = false;
        }
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


    /*
    Self-Registration of a user account
     */
    function selfRegistration (string memory _name, string memory _role) public {

        // Conditions to ensure no ghost users are registered
        require(bytes (_name).length > 0, "Name must be specified");

        require(keccak256(abi.encode(_role)) == keccak256(abi.encode("lender")) || keccak256(abi.encode(_role)) == keccak256(abi.encode("borrower")), "Role must match 'lender' or 'borrower");
        require(bytes (addressToUserData[msg.sender].name).length == 0, "User has been registered before");


        // Consider if populating array is necessary
        userData memory u;
        u.name = _name;
        u.role = _role;
        u.account = msg.sender;
        users.push(u);

        // Self-registration: Mapping ---- (-1??)
        addressToUserData[msg.sender] = u;
    }

    /*
    Registration of a user account by _anyone_ (public)
     */
    function userRegistration (string memory _name, string memory _role, address _account) public {


        // Conditions to ensure no ghost users are registered
        require(bytes (_name).length > 0, "Name must be specified");

        require(keccak256(abi.encode(_role)) == keccak256(abi.encode("lender")) || keccak256(abi.encode(_role)) == keccak256(abi.encode("borrower")), "Role must match 'lender' or 'borrower");
        require(bytes (addressToUserData[_account].name).length == 0, "User has been registered before");


        // Consider if populating array is necessary
        userData memory u;
        u.name = _name;
        u.role = _role;
        u.account = _account;
        users.push(u);

        addressToUserData[_account] = u;
    }

    /*
    Function to let users change their data after it has been created
    */
    function editUserData(string memory _name, string memory _role) public {

        require(keccak256(abi.encode(_role)) == keccak256(abi.encode("lender")) || keccak256(abi.encode(_role)) == keccak256(abi.encode("borrower")), "Role must match 'lender' or 'borrower");
        addressToUserData[msg.sender].role = _role;
        addressToUserData[msg.sender].name = _name;
        // Array update necessary
        uint memory index;
        userData memory u;
        for (uint i = 0; i < users.length; i++) {
            if (users[i].address == msg.sender) {
                index = i;
            }
        }

    }


    /*
    Helper function to retrieve [mapping userLoanCount]
    */
    function getUserLoanCount(address _addr) public view returns(uint) {
        return userLoanCount[_addr];
    }

    /*
    Helper function to retrieve [mapping loanToRegistrar]
    */
    function getloanToRegistrar(uint _loanId) public view returns(address) {
        return loanToRegistrar[_loanId];
    }

    /*
    Helper function to retrieve UserId from mapping inside struct
    */
    function getUserToId(uint256 _loanId, address _address) public view returns (uint256) {
        return loans[_loanId].userToId[_address];
    }

    /*
    Helper function to retrieve data belonging to an address
    */
    function getUserDataByAddr(address _account) public view returns(userData memory) {
        return addressToUserData[_account];
    }

    /*
    Helper function to retrieve List of all registered Addresses in Loan
    */
    function getUsersInLoan (uint256 _loanId) public view returns (address[] memory, uint) {
        address[] memory addrArr = loans[_loanId].userList;
        uint userCount = loans[_loanId].numOfUsers;
        return (addrArr, userCount);
    }

    /*
    Helper function to retrieve approval status array
    */
    function getApprovalStatus(uint256 _loanId) public view returns (bool[] memory) {
        bool[] memory array = loans[_loanId].approvalStatus; // approvalStatus is a bool array in a struct array
        return array;
    }

    /*
    Helper function to retrieve the loan amounts of the users from struct
    */
    function getLoanAmounts(uint256 _loanId) public view returns (uint[] memory) {
        uint[] memory array = loans[_loanId].loanAmounts;
        return array;
    }

    /*
    Get the length of the loan array
    */
    function getArrLength() public view returns (uint256)
    {
        return (loans.length);
    }

    /*
    Get the length of the user array
    */
    function getUserArrLength() public view returns (uint256)
    {
        return (users.length);
    }

    /*
    The function should return an array with all the loans the user is involved in, disregarding any other permissioning like read-write requests
    Important to log all the loans by the user
    As of now, only the registrar mapping is applied, a loan belonging to multiple users cannot be created yet
    Info: mapping (uint => address) loanToRegistrar;
    */
    function getLoansByUser(address _user) external view returns(uint[] memory) {
        // Create a new array with as many entries as Loans belong to the user
        uint[] memory result = new uint[](userLoanCount[_user]);
        uint counter = 0;
        // Iterate through loanToRegistrar mapping and check if equals address, then sum up
        for (uint i = 0; i < loans.length; i++) {
            if (loanToRegistrar[i] == _user) {
                result[counter] = i;
                counter++;
            }
            // Check if user is part of the loan but not registrar
            else {
                address[] memory _userArr = loans[i].userList;

                for (uint c = 0; c < _userArr.length; c++ ) {
                    if (_userArr[c] == _user) {
                    result[counter] = i;
                    counter++;
                    }
                }

            }
        }
        return result;
    }

}
