

pragma solidity ^0.5.0;
import './TransxitToken.sol';
//import './Ownable.sol';
import './SafeMath.sol';


contract TransxitVesting is Ownable {
    using SafeMath for uint256;

    event Released(uint256 amount);

 
    address public beneficiary;
    KryllToken public token;

    uint256 public startTime;
    uint256 public cliff;
    uint256 public released;


    uint256 constant public   VESTING_DURATION    =  536000; 
    uint256 constant public   CLIFF_DURATION      =   60000; 

   
    function setup(address _beneficiary,address _token) public onlyOwner{
        require(startTime == 0); // Vesting not started
        require(_beneficiary != address(0));
        // Basic init
        changeBeneficiary(_beneficiary);
        token = KryllToken(_token);
    }

   
    function start() public onlyOwner{
        require(token != address(0));
        require(startTime == 0); // Vesting not started
        startTime = now;
        cliff = startTime.add(CLIFF_DURATION);
    }

    
    function isStarted() public view returns (bool) {
        return (startTime > 0);
    }


 
    function changeBeneficiary(address _beneficiary) public onlyOwner{
        beneficiary = _beneficiary;
    }


    
    function release() public {
        require(startTime != 0);
        require(beneficiary != address(0));
        
        uint256 unreleased = releasableAmount();
        require(unreleased > 0);

        released = released.add(unreleased);
        token.transfer(beneficiary, unreleased);
        emit Released(unreleased);
    }

    
    function releasableAmount() public view returns (uint256) {
        return vestedAmount().sub(released);
    }

   
    function vestedAmount() public view returns (uint256) {
        uint256 currentBalance = token.balanceOf(this);
        uint256 totalBalance = currentBalance.add(released);

        if (now < cliff) {
            return 0;
        } else if (now >= startTime.add(VESTING_DURATION)) {
            return totalBalance;
        } else {
            return totalBalance.mul(now.sub(startTime)).div(VESTING_DURATION);
        }
    }
}