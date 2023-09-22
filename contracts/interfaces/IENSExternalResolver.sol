// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/IMulticallable.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/IExtendedResolver.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/IAddrResolver.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/IAddressResolver.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/INameResolver.sol";
import "./IDNSEncodedNameResolver.sol";

interface IENSExternalResolver is
    IERC165,
    IExtendedResolver,
    IAddrResolver,
    IAddressResolver,
    INameResolver,
    IDNSEncodedNameResolver
{
    function addrFromDnsName(
        bytes calldata dnsName
    ) external view returns (address payable);

    function nameFromDnsName(
        bytes calldata dnsName
    ) external view returns (string memory);

    function register(
        bytes calldata dnsName
    ) external payable returns (address);
}
