pragma solidity 0.4.24;

/**
* @title Interface of smart contract accepting the funding functionality
* Implemented by LoanRequestsController and LoanOffersController
*/
interface IFundableController {
    /**
    * @dev Funds a loan with an amount. In the case of ETH, it receives the value too.
    * In the case of ERC20, the amountToFund needs to be approved in advance
    * @param deposit - loan deposit address
    * @param stakingFee - Microstaking fee https://github.com/ETHLend/Microstaking. 0 is allowed
    * @param amountToFund - Amount to fund
    */            
    function fund(address deposit, uint stakingFee, uint128 amountToFund) external payable;

    /**
    * @dev Forward the pending repaid amount to withdraw to the lender
    * @param deposit - loan deposit address
    */  
    function withdrawLenderPendingAmount(address deposit) external;
}