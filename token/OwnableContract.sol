pragma solidity ^0.4.21;

import "browser/ownable.sol" ;

contract OwnableContract is  Ownable {
    
    mapping (address => bool) AddressOwner;
    
     modifier onlyOwnerOrContract() { 
        require (AddressOwnerOf(msg.sender));
        _;
   }
  
  // Видимая функция добавления адреса контракта ,только owner
    function AddOnwerAdress (address _addOwner, bool _bool) onlyOwner public  returns (bool){
        require(_addOwner != address(0));  
        AddressOwner[_addOwner] = _bool ;
        return true ;
    }
    // Проверяет адрес в карте и булевое значение адреса
    function AddressOwnerOf(address _adr) public view returns (bool) {
    return AddressOwner[_adr];
    }
}