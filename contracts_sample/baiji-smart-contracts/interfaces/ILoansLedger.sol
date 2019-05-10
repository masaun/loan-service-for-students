pragma solidity 0.4.24;

/*
 The LoansLedger stores the data of all the loans in the platform.
 Each loan agreement has a deposit smart contract associated, where the collateral, funds and 
 repayments are stored in the different states of the loan agreement.
*/

/**
* @title Interface of the LoansLedger
*/
interface ILoansLedger {
    /**
    * @dev Get the addresses of all the deposits
    * @return A list of deposits addresses
    */
    function getLoanRequests() external view 
        returns (address[]);

    /**
    * @dev Get the addresses of all the deposits filtered by borrower address
    * @param borrower - borrower address
    * @return A list of deposits addresses
    */
    function getLoanRequestsByBorrower(address borrower) external view 
        returns (address[]);

    /**
    * @dev Get the addresses of all the deposits filtered by lender address
    * @param lender - lender address
    * @return A list of deposits addresses
    */
    function getLoanRequestsByLender(address lender) external view 
        returns (address[]);

    /**
    * @dev Gets the pending repaid amount to withdraw by the lender
    * @param deposit - loan deposit address
    * @param lender - lender address
    */
    function getWithdrawAmount(address deposit, address lender) external view  
        returns (uint128);

    /**
    * @dev Checks if the amountToFund is multiple of 5% of the loan amount
    * @param deposit - loan deposit address
    * @param lender - lender address
    * @param amountToFund - Amount to fund
    */
    function isFundingContributionValid(address deposit, address lender, uint128 amountToFund) external view 
        returns (bool)

    /**
    * @dev Gets the data of a loan
    * @param deposit - loan deposit address
    */
    function getLoanData(address deposit) external view 
        returns (
            uint mediumAmount,
            uint premiumAmount,
            uint collateralAmount,
            uint fundedCapital,
            uint outstandingLoanAmount,
            address collateralToken,
            address mediumOfExchangeToken,
            uint8 mediumOfExchange,
            uint8 collateralType,
            uint8 currentState,
            uint8 installments_count,
            int8 peggedIndex,
            uint64 startTimeoutTime);

    /**
    * @dev Gets the repaid amount that a lender has available to withdraw
    * @param deposit - loan deposit address
    * @param lender - lender address
    */
    function getWithdrawAmount(address deposit, address lender) external view  returns (uint128);

    /**
    * @dev Gets data related with the repayments of a loan
    * @param deposit - loan deposit address
    */
    function getRepaymentData(address deposit) external view 
        returns (
            uint paybackReceived, 
            uint8 installments_count, 
            uint8 installment_paid);
}