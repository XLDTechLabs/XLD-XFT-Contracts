// SPDX-License-Identifier:MIT
pragma solidity ^0.6.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NFT is ERC721, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    Counters.Counter private tokenIdTracker;

    constructor(string memory baseURI) public ERC721("XLoad NFT", "XFT") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());

        _setBaseURI(baseURI);

        for (uint i = 0; i < 10; i++) {
            mint(_msgSender());
        }
    }

    function mint(address _to) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "NFT-XFT: must have minter role to mint");

        _mint(_to, tokenIdTracker.current());
        tokenIdTracker.increment();
    }
    
    function setBaseURI(string memory baseURI) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NFT-XFT: must have admin role to set baseURL");
        _setBaseURI(baseURI);
    }
}