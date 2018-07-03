# ethereum-token-operator-registry
Ethereum Token Operator Registry

Singleton registry for use in ERC20, ERC721, ERC777 and any future token standard that allows users to approve contracts and addresses they trust of all tokens with single transaction.

```solidity
pragma solidity ^0.4.24;

contract GlobalOpearatorRegistry {
    
    function isApprovedOperator(address owner, address operator) external view returns (bool);
}

contract ERC20 {
    
    GlobalOpearatorRegistry public operatorRegistry = 0x0102030405...;
    
    function allowance(address owner, address spender) external view returns (uint) {
        if (operatorRegistry.isApprovedOperator(owner, spender)) {
            return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        }
        // the rest of ERC20 logic
    }
    
    function approve(address spender, uint amount) external view returns (bool) {
        require(!operatorRegistry.isApprovedOperator(msg.sender, spender), "This spender is approved globally via 0x0102030405.... Changing it locally has no effect");
        // the rest of ERC20 logic
    }
    
    function transferFrom(address from, address to, uint amount) external view returns (bool) {
        if (!operatorRegistry.isApprovedOperator(from, msg.sender)) {
            allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
        }
        // the rest of ERC20 logic
    }
}

contract ERC721 {
    
    function approve(address spender, uint tokenId) external {
        require(!operatorRegistry.isApprovedOperator(msg.sender, spender), "This spender is approved globally via 0x0102030405.... Setting it locally has no effect");
        // the reset of ERC721 logic
    }
    
    function setApprovalForAll(address operator, bool value) external {
        require(!operatorRegistry.isApprovedOperator(msg.sender, spender), "This opearator is approved globally via 0x0102030405.... Changing it locally has no effect");
        // the reset of ERC721 logic
    }
    
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        if (operatorRegistry.isApprovedOperator(owner, operator)) {
            return true;
        }
        // the reset of ERC721 logic
    }
    
    function transferFrom(address from, address to, uint tokenId) external {
        uint owner = ownerOf(tokenId);
        require(from == owner);
        require(msg.sender == owner || operatorRegistry.isApprovedOperator(owner, msg.sender) || ...);
        // the reset of ERC721 logic
    }
}
```
