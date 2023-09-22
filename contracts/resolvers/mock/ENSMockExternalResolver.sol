// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../ENSExternalResolver.sol";

contract ENSMockExternalResolver is ENSExternalResolver {
    mapping(bytes32 => address) public mockOwner;

    constructor(ENS _registry) ENSExternalResolver(_registry) {}

    function resolveAddress(
        string memory name,
        string memory tld,
        bytes32 tldNameHash
    ) internal view virtual override returns (address) {
        if (tldNameHash == 0) {
            revert InvalidTld();
        }

        return mockOwner[keccak256(bytes(string.concat(name, ".", tld)))];
    }

    function setOwner(string calldata name, address owner) public {
        mockOwner[keccak256(bytes(name))] = owner;
    }
}
