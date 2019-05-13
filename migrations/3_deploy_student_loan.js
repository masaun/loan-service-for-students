const StudentLoan = artifacts.require("./StudentLoan.sol");

module.exports = function(deployer, network, accounts) {
    return deployer.then(()=>{
        return deployer.deploy(
            StudentLoan,
        );
    });
}
