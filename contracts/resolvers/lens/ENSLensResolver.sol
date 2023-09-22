// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../../ENSExternalResolver.sol";
import "./ILensHub.sol";

bytes32 constant LENS_TLD_NAMEHASH = 0xdff8d56a3d2dc14c157b8864a1a7ac5eb8aa5c3312a6b79698ed0c1777c6308b;
bytes32 constant TEST_TLD_NAMEHASH = 0x04f740db81dc36c853ab4205bddd785f46e79ccedca351fc6dfcbd8cc9a33dd6;

contract ENSLensResolver is ENSExternalResolver {
    ILensHub public immutable lensHub;

    constructor(
        ENS _registry,
        ILensHub _lensHub
    ) ENSExternalResolver(_registry) {
        lensHub = _lensHub;
    }

    function resolveAddress(
        string memory name,
        string memory tld,
        bytes32 tldNameHash
    ) internal view virtual override returns (address) {
        if (
            tldNameHash != LENS_TLD_NAMEHASH && tldNameHash != TEST_TLD_NAMEHASH
        ) {
            revert InvalidTld();
        }

        uint256 profileId = lensHub.getProfileIdByHandle(
            string.concat(name, ".", tld)
        );

        if (profileId == 0) {
            return address(0);
        }

        return IERC721(address(lensHub)).ownerOf(profileId);
    }

    // to optimize speed of resolving address
    function addr(
        bytes32 node
    ) public view virtual override returns (address payable) {
        uint256 profileId = lensHub.getProfileIdByHandle(_name[node]);

        if (profileId == 0) {
            return payable(address(0));
        }

        return payable(IERC721(address(lensHub)).ownerOf(profileId));
    }
}
