const StudentCreditScore = artifacts.require("./StudentCreditScore.sol");

module.exports = function(deployer, network, accounts) {
    return deployer.then(()=>{
        return deployer.deploy(
            StudentCreditScore,
        );
    });
}
