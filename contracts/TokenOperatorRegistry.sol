pragma solidity ^0.4.23;

contract TokenOperatorRegistry {

    event AuthorizeOperator(address indexed owner, address indexed operator);
    event RevokeOperator(address indexed owner, address indexed operator);

    mapping (address => mapping (address => bool)) private approvals;
    mapping (address => address[]) private operators;
    mapping (address => mapping (address => uint)) private indexInOperators;

    function authorizeOperator(address operator) external {
        require(!approvals[msg.sender][operator]);
        approvals[msg.sender][operator] = true;
        uint length = operators[msg.sender].push(operator);
        indexInOperators[msg.sender][operator] = length - 1;
        emit AuthorizeOperator(msg.sender, operator);
    }

    function revokeOperator(address operator) external {
        require(approvals[msg.sender][operator]);
        approvals[msg.sender][operator] = false;
        uint index = indexInOperators[msg.sender][operator];
        uint lastIndex = operators[msg.sender].length - 1;
        if (index < lastIndex) {
            address lastOperator = operators[msg.sender][lastIndex];
            operators[msg.sender][index] = lastOperator;
            indexInOperators[msg.sender][lastOperator] = index;
        }
        operators[msg.sender].length--;
        delete indexInOperators[msg.sender][operator];
        emit RevokeOperator(msg.sender, operator);
    }

    function isApprovedOperator(address owner, address operator) external view returns (bool) {
        return approvals[owner][operator];
    }

    function operatorsCount(address owner) external view returns (uint) {
        return operators[owner].length;
    }

    function operatorByIndex(address owner, uint index) external view returns (address) {
        return operators[owner][index];
    }

    function operatorsRange(address owner, uint from, uint to) external view returns (address[]) {
        address[] memory range = new address[](to - from);
        for (uint i = from; i < to; i++) {
            range[i - from] = operators[owner][i];
        }
        return range;
    }

    function allOperators(address owner) external view returns (address[]) {
        return operators[owner];
    }
}
