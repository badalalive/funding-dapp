//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract DaiToken is ERC20 {
    // Permit Type Hash
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
    // domain separator
    bytes32 internal domainSeparator;
    // EIP712_DOMAIN_TYPEHASH
    bytes32 EIP712_DOMAIN_TYPEHASH = keccak256(
        "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
    );
    // total supply
    uint constant TOTAL_SUPPLY = 300000000; // 300M
    // nonces
    mapping(address => uint256) nonces;

    constructor () ERC20('(PoS) Dai Stablecoin','1') {
        _mint(msg.sender, TOTAL_SUPPLY * (10 ** 18));
        _setDomainSeparator('(PoS) Dai Stablecoin','1');
    }

    function _setDomainSeparator(string memory name, string memory version) internal {
        domainSeparator = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                address(this),
                bytes32(getChainId())
            )
        );
    }

    function getNonce(address user) public view returns (uint256 nonce) {
        nonce = nonces[user];
    }

    function getDomainSeperator() public view returns (bytes32) {
        return domainSeparator;
    }

    function getChainId() public view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }
    function getChainIdByt() public view returns (bytes32) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return bytes32(id);
    }

    // --- Approve by signature ---
    function permit(
        address holder,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                getDomainSeperator(),
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        holder,
                        spender,
                        nonce,
                        expiry,
                        allowed
                    )
                )
            ));
        require(holder == ecrecover(digest, v, r, s), "UChildDAI: INVALID-PERMIT");
        require(expiry == 0 || block.timestamp <= expiry, "UChildDAI: PERMIT-EXPIRED");
        require(nonce == nonces[holder]++, "UChildDAI: INVALID-NONCE");
        uint wad = allowed ? type(uint).max : 0;
        _approve(holder, spender, wad);
    }
}
