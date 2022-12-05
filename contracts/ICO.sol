//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ICO {

    // ICO TYPE HASH
    bytes32 private constant _ICO_TYPEHASH =
    keccak256("Swap(address owner,address spender,uint256 value,address token,uint256 nonce,uint256 deadline)");

    // domain separator
    bytes32 internal domainSeparator;

    // EIP712_DOMAIN_TYPEHASH
    bytes32 EIP712_DOMAIN_TYPEHASH = keccak256(
        "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
    );

    mapping(address => uint256) nonces; // nonces for signatures

    constructor()  {
        _setDomainSeparator('ICO','1');
    }

    /**
     * @dev set Domain Separator.
     * Internal function without access restriction.
     */
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

    /* @dev get current domain separator*/
    function getDomainSeparator() public view returns (bytes32) {
        return domainSeparator;
    }

    // @dev get Chain id
    function getChainId() public view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    /* @dev swap function to validate signature for buy token
    @param owner :- owner address
    @param spender :- spender address
    @param value :- amount to swap
    @param token :- base token address to exchange
    @param deadline :- uint deadline
    @param v :- bytes32 v
    @param r :- bytes32 r
    @param s :- bytes32 s
  */
    function swap(
        address owner,
        address spender,
        uint256 value,
        address token,
        uint256 nonce,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                getDomainSeparator(),
                keccak256(
                    abi.encode(
                        _ICO_TYPEHASH,
                        owner,
                        spender,
                        value,
                        token,
                        nonce,
                        deadline
                    )
                )
            ));
        require(owner == ecrecover(digest, v, r, s), "INVALID-SWAP");
        require(deadline == 0 || block.timestamp <= deadline, "PERMIT-EXPIRED");
        require(nonce == nonces[owner]++, "INVALID-NONCE");
    }

}
