// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ENS} from "@ensdomains/ens-contracts/contracts/registry/ENS.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/Multicallable.sol";
import "./interfaces/IENSExternalResolver.sol";
import "./utils/NameTldSplit.sol";

error InvalidTld();
error NameNotFound();
error CoinTypeNotSupported();

uint256 constant COIN_TYPE_ETH = 60;

abstract contract ENSExternalResolver is Multicallable, IENSExternalResolver {
    ENS public immutable registry;
    mapping(bytes32 => string) internal _name;
    mapping(bytes32 => bytes) internal _dnsEncodedName;

    event ENSExternalRegistered(
        address indexed owner,
        bytes32 indexed nameHash,
        bytes32 indexed tldNameHash,
        bytes dnsName
    );

    constructor(ENS _registry) {
        registry = _registry;
    }

    function resolveAddress(
        string memory name,
        string memory tld,
        bytes32 tldNameHash
    ) internal view virtual returns (address);

    function afterRegister(
        bytes calldata dnsName,
        string memory domainName,
        string memory tldName,
        bytes32 nameHash,
        bytes32 tldNameHash,
        bytes32 labelHash
    ) internal virtual {}

    function register(
        bytes calldata dnsName
    ) public payable virtual returns (address domainOwner) {
        // Extract name and tld from dnsName
        (
            string memory domainName,
            string memory tldName,
            bytes32 nameHash,
            bytes32 tldNameHash,
            bytes32 labelHash
        ) = NameTldSplit.decodeNameAndTld(dnsName);

        // Check if tld is registered to this registry contract
        if (
            registry.owner(tldNameHash) != address(this) ||
            registry.resolver(tldNameHash) != address(this)
        ) {
            revert InvalidTld();
        }

        domainOwner = resolveAddress(domainName, tldName, tldNameHash);

        // Domain can't be resolved
        if (domainOwner == address(0)) {
            revert NameNotFound();
        }

        registry.setSubnodeRecord(
            tldNameHash,
            labelHash,
            domainOwner,
            address(this),
            0
        );

        _name[nameHash] = string.concat(domainName, ".", tldName);
        _dnsEncodedName[nameHash] = dnsName;

        afterRegister(
            dnsName,
            domainName,
            tldName,
            nameHash,
            tldNameHash,
            labelHash
        );

        emit ENSExternalRegistered(domainOwner, nameHash, tldNameHash, dnsName);
        emit AddressChanged(
            nameHash,
            COIN_TYPE_ETH,
            addressToBytes(domainOwner)
        );
        emit AddrChanged(nameHash, domainOwner);
        emit NameChanged(nameHash, domainName);
    }

    function name(bytes32 node) public view returns (string memory) {
        return _name[node];
    }

    function dnsEncodedName(bytes32 node) public view returns (bytes memory) {
        return _dnsEncodedName[node];
    }

    function addrFromDnsName(
        bytes calldata dnsName
    ) public view virtual returns (address payable) {
        // Extract name and tld from dnsName
        (
            string memory domainName,
            string memory tldName,
            ,
            bytes32 tldNameHash,

        ) = NameTldSplit.decodeNameAndTld(dnsName);

        return payable(resolveAddress(domainName, tldName, tldNameHash));
    }

    function nameFromDnsName(
        bytes calldata dnsName
    ) public view virtual returns (string memory) {
        // Extract name and tld from dnsName
        (string memory domainName, string memory tldName, , , ) = NameTldSplit
            .decodeNameAndTld(dnsName);

        return string.concat(domainName, ".", tldName);
    }

    // TODO: Handling better for addr coinType != 60 case
    function resolve(
        bytes memory dnsName,
        bytes memory data
    ) public view virtual returns (bytes memory) {
        bytes4 selector;

        // Extract function selector
        assembly {
            // First 32 bytes is the length in dynamic bytes array
            selector := mload(add(data, 32))
        }

        // Use dnsName instead of namehash for addr and name resolve
        if (selector == 0x3b3b57de || selector == 0xf1cb7e06) {
            data = abi.encodeWithSelector(
                this.addrFromDnsName.selector,
                dnsName
            );
        } else if (selector == 0x691f3431) {
            data = abi.encodeWithSelector(
                this.nameFromDnsName.selector,
                dnsName
            );
        }

        (bool success, bytes memory result) = address(this).staticcall(data);
        if (success) {
            return result;
        } else {
            // Revert with the reason provided by the call
            assembly {
                revert(add(result, 0x20), mload(result))
            }
        }
    }

    // Note: not optimized please override and optimize if possible
    function addr(bytes32 node) public view virtual returns (address payable) {
        bytes memory dnsName = _dnsEncodedName[node];

        if (dnsName.length > 0) {
            (bool success, bytes memory result) = address(this).staticcall(
                abi.encodeWithSelector(this.addrFromDnsName.selector, dnsName)
            );
            if (success) {
                return abi.decode(result, (address));
            } else {
                // Revert with the reason provided by the call
                assembly {
                    revert(add(result, 0x20), mload(result))
                }
            }
        }

        return payable(address(0));
    }

    function addr(
        bytes32 node,
        uint256 coinType
    ) public view virtual returns (bytes memory) {
        if (coinType == COIN_TYPE_ETH) {
            return addressToBytes(addr(node));
        } else {
            revert CoinTypeNotSupported();
        }
    }

    function supportsInterface(
        bytes4 interfaceID
    ) public view virtual override(IERC165, Multicallable) returns (bool) {
        return
            super.supportsInterface(interfaceID) ||
            interfaceID == type(IENSExternalResolver).interfaceId ||
            interfaceID == type(IExtendedResolver).interfaceId ||
            interfaceID == type(IAddrResolver).interfaceId ||
            interfaceID == type(IAddressResolver).interfaceId ||
            interfaceID == type(INameResolver).interfaceId ||
            interfaceID == type(IDNSEncodedNameResolver).interfaceId;
    }

    function addressToBytes(address a) internal pure returns (bytes memory b) {
        b = new bytes(20);
        assembly {
            mstore(add(b, 32), mul(a, exp(256, 12)))
        }
    }
}
