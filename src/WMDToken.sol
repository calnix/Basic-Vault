// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "yield-utils-v2/contracts/mocks/ERC20Mock.sol";

contract WMDToken is ERC20Mock {
    
    ///@dev Inherited constructor from ERC20Mock.sol. 
    ///@dev No parameters need to be passed for top-level constructor.
    constructor() ERC20Mock("WoMiGawd", "WMD") {

    }
}
