//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract UsdToken is ERC20Permit {

    uint constant TOTAL_SUPPLY = 300000000; // 300M

    constructor() ERC20('USD Coin (PoS)', 'USDC') ERC20Permit('USD Coin (PoS)'){
        _mint(msg.sender, TOTAL_SUPPLY * (10 ** 18));
    }

}
