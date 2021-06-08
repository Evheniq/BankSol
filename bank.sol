pragma solidity 0.4.24;

contract Erc20 {
    string public name = 'MyBankToken';
    string public symbol = 'MBT';
    uint8 public decimals = 18;
    
    uint public totalSupply;
    
    mapping (address => uint) balances;
    
    mapping (address => mapping(address => uint)) allowed;
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _from, address indexed _to, uint _value);
    
    function mint(address to, uint value) public{
        require(totalSupply + value >= totalSupply && balances[to] + value >= balances[to]);
        balances[to] += value;
        totalSupply += value;
    }
    
    function balanceOf(address owner) public view returns(uint){
        return balances[owner];
    }
    
    function allowance(address _owner, address _spender) public view returns(uint){
        return allowed[_owner][_spender];
    }
    
    function transfer(address _to, uint _value) public {
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer (msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, uint _value) public {
        require(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer (_from, _to, _value);
    }
    
    function approve(address _spender, uint _value) public {
        allowed[msg.sender][_spender] = _value;
        emit Transfer (msg.sender, _spender, _value);
    }
}

contract Ownable {
    address public owner;
    
    function Ownable() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Bank is Erc20, Ownable {
    
    uint16 public APY;
    
    function removeFromArray() public{
        
    }
    
    function Bank() public {
        
    }

    function setAPY(uint16 _APY) onlyOwner public{
        APY = _APY;
    }
    
    function withdraw(uint16 _nEth) onlyOwner public{
        owner.transfer(_nEth);
    }
    
    // Credit
    
    struct creditClient{
        address addressClient;
        uint amountCredit;
        uint16 thenAPY; // We will keep the profitability at the time of the application
    }
    
    creditClient [] public requestCredit;
    creditClient [] public acceptedCredit;
    
    function addRequestCredit(address _addressClient, uint _amountCredit, uint16 _APY) public{
        requestCredit.push(creditClient({addressClient: _addressClient, amountCredit: _amountCredit, thenAPY: _APY}));
    }
    
    // in process
    function refuseRequestCredit(uint _id) onlyOwner public{  
        delete requestCredit[_id];
    }
    
    // in process
    function acceptRequestCredit(uint _id) onlyOwner public{
        acceptedCredit.push(requestCredit[_id]);
        delete requestCredit[_id];
    }
    
    // Deposit
    
    function () public payable{
        mint(msg.sender, msg.value); // mint 1 ETH = 1 MBT
    }

}