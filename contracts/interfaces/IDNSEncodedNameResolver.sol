// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

interface IDNSEncodedNameResolver {
    /**
     * Returns the dns-encoded name associated with an ENS node.
     * dns-encoded name is encoded name specified in section 3.1 of RFC1035.
     * @param node The ENS node to query.
     * @return The associated dns-encoded name.
     */
    function dnsEncodedName(bytes32 node) external view returns (bytes memory);
}
