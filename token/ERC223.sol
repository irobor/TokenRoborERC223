 pragma solidity ^0.4.24;

contract ERC223Interface {
  string  name_;
  string  symbol_;
  uint8  decimals_;
  uint256 totalSupply_;
  
  function balanceOf(address who) constant public returns (uint);
  function transfer(address to, uint value)public returns (bool ok);
  function transfer(address to, uint value, bytes data)public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
