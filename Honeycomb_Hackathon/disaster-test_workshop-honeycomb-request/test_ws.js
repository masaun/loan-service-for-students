const MyContract = artifacts.require("MyContract");

module.exports = async function() {
  const myContract = await MyContract.deployed();
  await myContract.resetResult();

  resultReceived = await myContract.resultReceived();
  result = await myContract.result();
  console.log(`Received result: ${resultReceived}`);
  console.log(`Initial result: ${result.toString()}`);

  console.log("Making a Chainlink request using a Honeycomb job...");
  requestId = await myContract.makeRequest.call();
  await myContract.makeRequest();
  console.log(`Request ID: ${requestId}`);

  console.log("Waiting for the request to be fulfilled...");
  await myContract.once("ChainlinkFulfilled", { filter: { id: requestId } });
  console.log("Request fulfilled!");
  
  resultReceived = await myContract.resultReceived();
  result = await myContract.result();
  console.log(`Received result: ${resultReceived}`);
  console.log(`Final result: ${result.toString()}`);

  process.exit();
};
