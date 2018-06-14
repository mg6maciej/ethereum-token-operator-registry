pragma solidity ^0.4.23;

contract TokenApprovalRegistry {

    mapping (address => mapping (address => bool)) approvals;

    function isApproved(address owner, address spender) external view returns (bool) {
        return approvals[owner][spender];
    }

    function approve(address spender, bool value) external {
        approvals[msg.sender][spender] = value;
    }
}
