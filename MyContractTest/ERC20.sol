// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract ERC20 {
    // event logger
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    string public constant name = "MyTokenName";
    string public constant symbol = "MTN";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    // mapping of balances that allowed by address X to be used by address Y 
    mapping(address => mapping(address => uint256)) public allowance;

    // dummy function
    function giveMeOneToken() public {
        balanceOf[msg.sender] += 1e18;
    }

    // transfer from msg.sender into some address
    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "ERC20: Insufficient balance");

        return _transfer(msg.sender, to, value);
    }

    // transfer from address B into address C done by address A
    // Example:
    // 1. address B wants to transfer from address A to address C with value 100
    // 2. address A must `approve` address B with value 100
    // 3. now address B will have `allowance` of address A balance with value 100
    // 4. now address B can use `transferFrom(address A, address C, 100)`
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(
            allowance[from][msg.sender] >= value,
            "ERC20: Insufficient allowance"
        );

        emit Approval(from, msg.sender, allowance[from][msg.sender]);
        allowance[from][msg.sender] -= value;

        return _transfer(from, to, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private returns (bool) {
        require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");
        
        emit Transfer(from, to, value);

        // will tax fee 1% per transaction value into contract address
        uint256 fee = (value / 100);

        balanceOf[to] += (value - fee);
        balanceOf[from] -= value;
        balanceOf[address(this)] += fee;

        return true;
    }

    // give approval to the spender with such value
    function approve(address spender, uint256 value) external returns (bool) {
        emit Approval(msg.sender, spender, value);

        allowance[msg.sender][spender] += value;
        return true;
    }
}
