pragma solidity 0.4.24;

contract Bank {
    address public owner;
    uint16 public APY;
    uint public lenght;
    
    struct creditClient{
        address addressClient;
        uint amountCredit;
        uint16 thenAPY; // We will keep the profitability at the time of the application
    }
    
    creditClient [] public requestCredit;
    
    function Bank() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function setAPY(uint16 _APY) onlyOwner public{
        APY = _APY;
    }
    
    function withdraw(uint16 _nEth) onlyOwner public{
        owner.transfer(_nEth);
    }
    
    function addRequestCredit(address _addressClient, uint _amountCredit) public{
        requestCredit.push(creditClient({addressClient: _addressClient, amountCredit: _amountCredit, thenAPY: APY}));
    }
    
    function refuseRequestCredit(uint id) onlyOwner public{
        delete requestCredit[id];
    }
}