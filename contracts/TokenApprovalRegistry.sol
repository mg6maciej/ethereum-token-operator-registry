pragma solidity ^0.4.23;

contract TokenApprovalRegistry {

    mapping (address => mapping (address => bool)) private approvals;

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return approvals[owner][operator];
    }

    function setApprovalForAll(address operator, bool value) external {
        approvals[msg.sender][operator] = value;
    }
}
