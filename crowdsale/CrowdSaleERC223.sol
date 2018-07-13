pragma solidity ^0.4.21;

import "./libary/SafeMath.sol" ;

interface token {
    function mint(address receiver, uint amount)external;
}

contract Crowdsales {
    using SafeMath for uint256;
    address public multisig; // кошелёк куда отправляется эфир от инвестора
    uint public amountRaised;// общее колличество собранного эфира
    uint public price; // цена за эфир
    token public tokenReward ; // интерфейс для контракта токена, функции mint()
    
    mapping(address => uint256) public balanceOf;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = true;
   /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary,uint256 value,uint256 amount);
    event FundTransfer(address backer, uint amount, bool isContribution);

     constructor (
        address _adressToken,
        address _Multisig,
        uint etherCostOfEachToken
    )public {
        multisig = _Multisig;// адрес куда будет скидиываться эфир
        tokenReward = token(_adressToken);
        price = etherCostOfEachToken * 0.000033805151837529 ether ;// стоимость одного токена в эфирах     
    }

    function ()external payable {
        buyTokens(msg.sender); 
    }
    /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
    function buyTokens(address _beneficiary) public payable {    
        
        require(crowdsaleClosed);
        
        uint256 amount = msg.value;
        _preValidatePurchase(_beneficiary, amount);// проверяем на существование адреса и эфир
        uint256 tokens = _getTokenAmount(amount); // получаем к-во токенов для чеканки 
        balanceOf[_beneficiary] += amount;
        amountRaised = amountRaised.add(amount);
        _processPurchase(_beneficiary, tokens);// запускаем mint
       emit TokenPurchase(msg.sender, _beneficiary, amount, tokens);
        emit FundTransfer(_beneficiary, amount, true);
        _forwardFunds();// отправляет ETH на кошелёк miltisig
    }
    /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(address _beneficiary,uint256 _weiAmount)internal pure{
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
    
  }
   /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount)
    internal view returns (uint256)
  {
    return _weiAmount.div(price);
  }
   /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
      tokenReward.mint(_beneficiary, _tokenAmount);
    
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    _deliverTokens(_beneficiary, _tokenAmount);
  }
    /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    multisig.transfer(msg.value);
  }
    
}
