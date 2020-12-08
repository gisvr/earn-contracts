pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/SafeERC20.sol";

interface IAToken {
   function redeem(uint256 amount) external;
   function transfer(address recipient, uint256 amount) external;
   function transferFrom(address from, address to, uint256 amount) external;
   function balanceOf(address _user) external view returns (uint);
   function principalBalanceOf(address _user) external view returns (uint);
}

interface IAave {
   function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable;
}

library AaveLib { 
    struct Aave { 
        address lendingPool; 
        address core;  
    }
 
    bytes32 internal constant Name = keccak256(abi.encodePacked("Aave"));
   
    function suply(Aave memory aave,address _token,uint256 _amount)  internal {  
        IAave _aave = IAave(aave.lendingPool);
        if(_token == address(0)){ 
           _aave.deposit{value:_amount}(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,_amount,0);
        }else{
           _aave.deposit(_token, _amount, 0);
        } 
    }
    
    function balanceOf(address _lpToken, address _account) internal view returns (uint) {
        return IERC20(_lpToken).balanceOf(_account);  
    }
    
    function aTokenBalance(address _lpToken, address _account) internal view returns (uint) {
        return IAToken(_lpToken).balanceOf(_account);  
    }

    function withdraw(address _lpToken, uint256 _balance) internal  { 
        IAToken(_lpToken).redeem(_balance);
        
    }
}

contract StrategyLenderETH { 
    using SafeERC20 for IERC20;
    
    address lendingPool = 0x9E5C7835E4b13368fd628196C4f1c6cEc89673Fa;
    address core = 0x4295Ee704716950A4dE7438086d6f0FBC0BA9472;
    address ethAtoken = 0x2433A1b6FcF156956599280C3Eb1863247CFE675;
    
    event log (string message);
    
    
    
    
    function suply() public {
        // address(this).transfer(msg.value);
        uint256 _bal = address(this).balance;
        AaveLib.Aave memory _aave = AaveLib.Aave(lendingPool,lendingPool);  
        AaveLib.suply(_aave,address(0),_bal);  
    }
 
    
    function suplyETH() public payable{
        address(this).transfer(msg.value);
        AaveLib.Aave memory _aave = AaveLib.Aave(lendingPool,lendingPool);  
        AaveLib.suply(_aave,address(0),msg.value);  
    }
    
     event Received(address, uint);
     receive() external payable {
        emit Received(msg.sender, msg.value);
     }
    
     function ethBalance() public view  returns (uint256) {  
         return address(this).balance;
    }
    
    function inCaseETHGetsStuck()  public {
        uint256 _bal = address(this).balance;
        (bool result,) =  msg.sender.call{value:_bal}("");
        require(result, "transfer of ETH failed");
    }
    
    function balance() public view returns(uint256){
       return  AaveLib.balanceOf(ethAtoken,msg.sender); 
    }
    
    function aTokenBalance() public view returns(uint256){
      
       return  AaveLib.aTokenBalance(ethAtoken,address(this)); 
    }
    
    function approve(uint256 _amount) public{
        IERC20(ethAtoken).safeApprove(address(this), _amount);
        // IAToken(ethAtoken).redeem(_amount);
        // IAToken(ethAtoken).transfer(msg.sender, _amount);
        // AaveLib.withdraw(ethAtoken,_amount); 
    }
    
    function send(uint256 _amount) public{
        IERC20(ethAtoken).transferFrom(address(this),msg.sender, _amount);
        // IAToken(ethAtoken).redeem(_amount);
        // IAToken(ethAtoken).transfer(msg.sender, _amount);
        // AaveLib.withdraw(ethAtoken,_amount); 
    }
    
    function redeemDelegate(uint256 _amount) public{  
        // keccak256(abi.encodePacked(a, b, c))
        //  bytes  memory _redeem =keccak256(abi.encodePacked("redeem(uint256 amount)",_amount));
         bytes memory _redeem =abi.encodeWithSelector(bytes4(keccak256("redeem(uint256 amount)")),_amount);
         (bool success, bytes memory result) = address(ethAtoken).delegatecall(_redeem);  
         
          (uint256 returnCode, string memory returnMessage) = abi.decode(result, (uint256, string));
          
          emit log(returnMessage);
         require(success, "redeemDelegate call failed");
         
         
    }
    
    function redeemCall(uint256 _amount) public{ 
         
         bytes memory _redeem =abi.encodeWithSignature("redeem(uint256 amount)",_amount);
             
         address(ethAtoken).call(_redeem);  
    }
 
    
   function redeem(uint256 _amount) public{   
    //   aToken aTokenInstance = AToken("/*aToken_address*/");
        IAToken(ethAtoken).redeem(_amount);  
    }
    
    function withdraw(uint256 _amount) public{
        // IERC20(ethAtoken).approve(address(this), _amount);
        // IAToken(ethAtoken).redeem(_amount);
        IAToken(ethAtoken).transfer(msg.sender, _amount);
        // AaveLib.withdraw(ethAtoken,_amount); 
    }
    
    function transfer(uint256 _amount) public{
        // IERC20(ethAtoken).approve(address(this), _amount);
        // IAToken(ethAtoken).redeem(_amount);
        IAToken(ethAtoken).transfer(address(this), _amount);
        // AaveLib.withdraw(ethAtoken,_amount); 
    }
    
    function transferFrom(uint256 _amount) public{
        // IERC20(ethAtoken).approve(address(this), _amount);
        // IAToken(ethAtoken).redeem(_amount);
        IERC20(ethAtoken).safeTransferFrom(msg.sender, address(this),_amount);
        // AaveLib.withdraw(ethAtoken,_amount); 
    }
    
    
}