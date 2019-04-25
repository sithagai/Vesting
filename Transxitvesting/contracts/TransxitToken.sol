

pragma solidity ^0.5.0;

import './TransferableToken.sol';
import './SafeMath.sol';




contract TransxitToken is TransferableToken {


    string  public symbol = "Transxit";
    string public name = "Transxit";
    uint8 public decimals = 18;
  

    uint256 constant internal DECIMAL_CASES    = (10 ** uint256(decimals));
    uint256 constant public   SALE             =  17737348 * DECIMAL_CASES; 
    uint256 constant public   TEAM             =   8640000 * DECIMAL_CASES; 
    uint256 constant public   ADVISORS         =   2880000 * DECIMAL_CASES; 
    uint256 constant public   SECURITY         =   4320000 * DECIMAL_CASES; 
    uint256 constant public   PRESS_MARKETING  =   5040000 * DECIMAL_CASES; 
    uint256 constant public   USER_ACQUISITION =  10080000 * DECIMAL_CASES; 
    uint256 constant public   BOUNTY           =    720000 * DECIMAL_CASES; 

    address public sale_address     = 0x0;
    address public team_address     = 0x0;
    address public advisors_address = 0x0;
    address public security_address = 0x0;
    address public press_address    = 0x0;
    address public user_acq_address = 0x0;
    address public bounty_address   = 0x0;
    bool public initialDistributionDone = false;

   
    function reset(address _saleAddrss, address _teamAddrss, address _advisorsAddrss, address _securityAddrss, address _pressAddrss, address _usrAcqAddrss, address _bountyAddrss) public onlyOwner{
        require(!initialDistributionDone);
        team_address = _teamAddrss;
        advisors_address = _advisorsAddrss;
        security_address = _securityAddrss;
        press_address = _pressAddrss;
        user_acq_address = _usrAcqAddrss;
        bounty_address = _bountyAddrss;
        sale_address = _saleAddrss;
    }

 
    function distribute() public onlyOwner {
        
        require(!initialDistributionDone);
        require(sale_address != 0x0 && team_address != 0x0 && advisors_address != 0x0 && security_address != 0x0 && press_address != 0x0 && user_acq_address != 0 && bounty_address != 0x0);      

     
        totalSupply_ = SALE.add(TEAM).add(ADVISORS).add(SECURITY).add(PRESS_MARKETING).add(USER_ACQUISITION).add(BOUNTY);

      
        balances[owner] = totalSupply_;
        emit Transfer(0x0, owner, totalSupply_);

        transfer(team_address, TEAM);
        transfer(advisors_address, ADVISORS);
        transfer(security_address, SECURITY);
        transfer(press_address, PRESS_MARKETING);
        transfer(user_acq_address, USER_ACQUISITION);
        transfer(bounty_address, BOUNTY);
        transfer(sale_address, SALE);
        initialDistributionDone = true;
        whitelist(sale_address); 
        whitelist(team_address); 
    }

   
    function setName(string  _name) onlyOwner public {
        name = _name;
    }

}