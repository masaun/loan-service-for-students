pragma solidity 0.4.24;

import "../node_modules/chainlink/contracts/ChainlinkClient.sol";

contract MyContract is ChainlinkClient{
    uint256 private oraclePaymentAmount;
    bytes32 private jobId;

    bool public resultReceived;
    int256 public result;

    constructor(
        address _link,
        address _oracle,
        bytes32 _jobId,
        uint256 _oraclePaymentAmount
        )
    public
    {
        setChainlinkToken(_link);
        setChainlinkOracle(_oracle);
        jobId = _jobId;
        oraclePaymentAmount = _oraclePaymentAmount;
    }

    function makeRequest() external returns (bytes32 requestId)
    {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
        req.add("from", "EUR");
        req.add("to", "USD");
        req.add("amount", "1");
        req.addInt("times", 1000);
        req.add("copyPath", "info.rate");
        requestId = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePaymentAmount);
    }

    function resetResult() external
    {
        resultReceived = false;
        result = 0;
    }

    function fulfill(bytes32 _requestId, int256 _result)
    public
    recordChainlinkFulfillment(_requestId)
    {
        resultReceived = true;
        result = _result;
    }
}
