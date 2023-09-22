// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

error InvalidName();

library NameTldSplit {
    function decodeNameAndTld(
        bytes calldata dnsName
    )
        internal
        pure
        returns (
            string memory name,
            string memory tld,
            bytes32 nameHash,
            bytes32 tldNameHash,
            bytes32 labelHash
        )
    {
        // Extract name and tld and check if dnsName is in the format of <name>.<id>
        uint256 nameLength = uint256(uint8(dnsName[0]));
        if (nameLength == 0) {
            revert InvalidName();
        }

        uint256 tldOffset = nameLength + 1;
        uint256 tldLength = uint256(uint8(dnsName[tldOffset]));
        if (tldLength == 0) {
            revert InvalidName();
        }

        uint256 stopOffset = tldOffset + tldLength + 1;

        // dnsName is 3+ level domains
        if (dnsName[stopOffset] > 0) {
            revert InvalidName();
        }

        // Extract name and tld from dnsName
        name = string(dnsName[1:tldOffset]);
        tld = string(dnsName[tldOffset + 1:stopOffset]);
        bytes32 tldLabelHash = keccak256(dnsName[tldOffset + 1:stopOffset]);
        tldNameHash = keccak256(abi.encodePacked(bytes32(0), tldLabelHash));

        labelHash = keccak256(dnsName[1:tldOffset]);
        nameHash = keccak256(abi.encodePacked(tldNameHash, labelHash));
    }
}
