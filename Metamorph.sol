// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractX {
    // Function to destruct the contract, sending all remaining funds to address 0 (burning them).
    function kill() public {
        selfdestruct(payable(address(0)));
    }
}

contract ContractY {
    uint256 private y; // Private variable to store some data.

    // Constructor to initialize ContractY with a value for y.
    constructor(uint256 _y) {
        y = _y;
    }
    // ContractY implementation
}

contract Metamorph {
    // Internal function to create a contract using create2 opcode, allowing for deterministic deployment.
    function create2(uint256 value, bytes32 salt, bytes memory bytecode) internal returns (address) {
        address created;
        assembly {
            created := create2(value, add(bytecode, 0x20), mload(bytecode), salt)
            if iszero(extcodesize(created)) {
                revert(0, 0) // Revert if the creation failed (no code deployed at the address).
            }
        }
        return created;
    }
    
    // Function to create an instance of ContractX using create2.
    function createContractX(bytes32 salt) public returns (address) {
        bytes memory bytecode = type(ContractX).creationCode;
        return create2(0, salt, bytecode); // Deploy ContractX with create2.
    }

    // Function to create an instance of ContractY using create2.
    function createContractY(bytes32 salt) public returns (address) {
        bytes memory bytecode = type(ContractY).creationCode;
        return create2(0, salt, bytecode); // Deploy ContractY with create2.
    }

    // Function to destruct the factory contract, sending all remaining funds to address 0 (burning them).
    function destroy() public {
        selfdestruct(payable(address(0)));
    }
}
