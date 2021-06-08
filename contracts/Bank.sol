pragma solidity 0.4.24;

contract Erc20 {
    string public constant name = 'MyBankToken';
    string public constant symbol = 'MBT';
    uint8 public constant decimals = 18;
    
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
    
    uint16 public APY = 20;
    uint8 public constant ownerProfit = 10; // spread
    
    
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
        uint amountCredit;
        uint16 thenAPY; // We will keep the profitability at the time of the application
        uint date;
    }
    
    mapping (address => creditClient) public requestCredits;
    mapping (address => creditClient) public acceptedCredits;
    
    function addRequestCredit(uint _amountCredit, uint16 _APY) public{
        requestCredits[msg.sender] = creditClient({amountCredit: _amountCredit, thenAPY: _APY, date: now});
    }
    
    function refuseRequestCredit(address _id) onlyOwner public{  
        delete(requestCredits[_id]);
    }
    
    function acceptRequestCredit(address _id) onlyOwner public{
        _id.transfer(requestCredits[_id].amountCredit);
        acceptedCredits[_id] = requestCredits[_id];
        delete requestCredits[_id];
    }
    
    function returnCredit() public payable{
        acceptedCredits[msg.sender].amountCredit = acceptedCredits[msg.sender].amountCredit - msg.value;
    }
    
    function showCredit() view public returns(uint){
        return acceptedCredits[msg.sender].amountCredit;
    }

    
    // Deposit
    
    struct depositClient{
        uint amountDeposit;
        uint16 thenAPY; // We will keep the profitability at the time of the application
        uint date;
    }
    
    mapping (address => depositClient) public acceptedDeposits;
    
    function deposit () public payable{
        mint(msg.sender, msg.value); // mint 1 ETH = 1 MBT
        acceptedDeposits[msg.sender] = depositClient(msg.value, APY, now); // Assume that 1 person 1 deposit
    }
    
    function returnDeposit(uint _value){
        msg.sender.transfer(_value);
        acceptedDeposits[msg.sender].amountDeposit = acceptedDeposits[msg.sender].amountDeposit - _value;
        transfer(0x0000000000000000000000000000000000000000, _value); // burn
    }
    
    function showDeposit() view public returns(uint){
        return acceptedDeposits[msg.sender].amountDeposit; // Not work profit calculate in all function. I`m trying: return acceptedDeposits[msg.sender].amountDeposit*(acceptedDeposits[msg.sender].thenAPY/100/((now-acceptedDeposits[msg.sender].date)/31579200))
    }
    
}