pragma solidity ^0.5.0;

/* @notice Using OpenZeppelin-solidity v2.0.0 */
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";



contract StudentLoanToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
    
    //ERC20 public token;

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 initSupply
    ) 
        public 
        ERC20Detailed(name, symbol, decimals)
        ERC20Mintable()
        ERC20Burnable()
    {
        _mint(msg.sender, initSupply);
    } 



    function mintToken(address to, uint256 value) public returns (bool) {
        mint(msg.sender, value);

        return true;
    }
    
    
    function burnToken(uint256 value) public returns (bool) {
        burn(value);

        return true;
    }
    
}
