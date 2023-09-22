# ENS Universal Registry

## Specification for enabling ENS Compatibility Interface for any kind of domain such as .lens

We have developed the first draft of our specification for enabling ENS Compatibility for any kind of domain such as .lens using **a minimal change to the ENS codebase**.

**Zero-interaction required from users to support resolving .lens (and others) address using our ENS Compatibility interface!**

**Incorporating this specification will significantly enhance the robustness of the ENS standard. Furthermore, it will streamline the development process, enabling developers to integrate solely with the unified ENS standard, thereby simplifying integration efforts.**

## Pain point

Currently, .lens domain is not ENS compatible. Although they have implemented off-chain resolver support, it needs to add .xyz to the suffix. For example, if you want to resolve scripteth.lens through ENS off-chain resolver you must resolve scripteth.lens.xyz instead.

![image](https://user-images.githubusercontent.com/4103490/270031835-a8cc4acd-86ec-4c14-a651-4e7b5b146163.png)

Moreover, .lens names resolving process isn't implemented on-chain although it can be through this specification. There is a question on this concern on the twitter: https://twitter.com/0xAllen_/status/1577309050781548544.

<img width="446" alt="image" src="https://user-images.githubusercontent.com/4103490/270032066-c9ed9494-edfa-4a90-8e60-87ee127253ea.png">

## Benefit

With "Specification for enabling ENS Compatibility Interface for any kind of domain such as .lens" being implemented, we can natively resolve .lens domain on the Polygon chain without an extra .xyz suffix in a fully on-chain manner.

![image](https://user-images.githubusercontent.com/4103490/270032561-e75e3916-4f73-4c71-9c3d-a62c9fc5efd1.png)

It will be natively resolvable on the Polygon chain. Integrating with interoperability protocols, we may be able to have .lens domains resolvable on other chains in a fully on-chain manner.

Lens Protocol greatly benefits from this specification as .lens will be supported on many wallets and SDKs natively. Moreover, .lens profile owner can also access ENS features such as subdomains.

This specification drives the ENS ecosystems one step ahead for implementing support for third-party ENS registries on other EVM chains.

**Incorporating this specification will significantly enhance the robustness of the ENS standard. Furthermore, it will streamline the development process, enabling developers to integrate solely with the unified ENS standard, thereby simplifying integration efforts.**

## Solution

### Overall Process

To begin with, the registry owner must set the owner and resolver of the TLD node to the external resolver address respective to each protocol.

![ensuniversalregistry1](https://user-images.githubusercontent.com/4103490/270030232-71344997-b2e7-4de3-9d28-f7897aa58aef.png)

### External Resolver Interfaces

An external resolver such as ENSLensResolver implements these interfaces
* IExtendedResolver
* IAddrResolver
* IAddressResolver
* INameResolver

And we have more functions to
* dnsEncodedName: To resolve DNS encoded name from namehash.
* addrFromDnsName: To resolve address from DNS encoded name.
* nameFromDnsName: To resolve name string (xxx.lens) from DNS encoded name.
* register: To register domain name on the registry for additional ENS features support such as subdomains.

### Address Resolving Process

![ensuniversalregistry2](https://user-images.githubusercontent.com/4103490/270030328-dd1cd743-2dd8-4553-92b2-d90e25becb99.png)

With this process, any wallet, SDK, and application can resolve any .lens domains without needing any user interaction.

### Supporting additional ENS features

In order to use ENS features such as subdomains, domain owners are required to explicitly register on our ENS registry through the resolver. **However, this process is optional.**

![ensuniversalregistry3](https://user-images.githubusercontent.com/4103490/270030781-d9e52930-ff2e-4bfb-b721-985156408369.png)

## Deployments

### Polygon Mainnet
* ENSRegistry: [0x8D690aAF26Cf2f48BC1879aF42CB121D80F893c8](https://polygonscan.com/address/0x8D690aAF26Cf2f48BC1879aF42CB121D80F893c8)
* ENSLensResolver: [0xf066dD9DacDE103A111002306f92ca699bB0599C](https://polygonscan.com/address/0xf066dD9DacDE103A111002306f92ca699bB0599C)
* UniversalResolver: [0xB938d136Bf886c2cFc2f0fb24C9A16E389fb3178](https://polygonscan.com/address/0xB938d136Bf886c2cFc2f0fb24C9A16E389fb3178)

### Polygon Mumbai Testnet
* ENSRegistry: [0x2B941Bd3B9D6Af704DE7408Cb903A29850EfEb3e](https://mumbai.polygonscan.com/address/0x2B941Bd3B9D6Af704DE7408Cb903A29850EfEb3e)
* ENSLensResolver: [0x5052A316D1A7E1923C41852439A823b1d43b8560](https://mumbai.polygonscan.com/address/0x5052A316D1A7E1923C41852439A823b1d43b8560)
* UniversalResolver: [0x8D690aAF26Cf2f48BC1879aF42CB121D80F893c8](https://mumbai.polygonscan.com/address/0x8D690aAF26Cf2f48BC1879aF42CB121D80F893c8)

## Source Code
Github: https://github.com/Opti-domains/ens-universal-registry

## Proof of Working
Successfully resolve stani.lens through Universal Resolver without any interaction from him.

DNS Encoded: 0x057374616e69046c656e7300
Namehash: 0xc11002d5bfb7dd5df5f26f02cfaa67e7d8e9589a6da5ce4b0adac6d4a7c2b8d4
Calldata: 0x3b3b57dec11002d5bfb7dd5df5f26f02cfaa67e7d8e9589a6da5ce4b0adac6d4a7c2b8d4

![image](https://user-images.githubusercontent.com/4103490/270042264-c370012b-66b7-4e79-bd6c-556a717c679b.png)

On the other way, we can use the addrFromDNSName method in ENSLensResolver to resolve his address as well

![image](https://user-images.githubusercontent.com/4103490/270042460-d124117d-2fd6-428e-940f-be760c255384.png)

## Future Plan

If possible, we would like to get further grants to research and implement this specification for enabling ENS Compatibility Interface for any kind of domain such as .lens in collaboration with ENS DAO.

We are also interested in implementing support for resolving external ENS registries on other EVM chains such as Optimism. Hope this ENS small grant will be a good start.