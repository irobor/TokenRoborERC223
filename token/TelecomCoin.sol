pragma solidity ^0.4.24;
import "github.com/irobor/TokenRoborERC223/token/Mintable.sol";
import "github.com/irobor/TokenRoborERC223/token/Burn.sol";
 
contract SimpleTokenCoin is MintableToken, BurnableToken {
    
   constructor(string _name, string _symbol) public {     
        name_ = _name;                                   
        symbol_ = _symbol;                              
    }    
}
