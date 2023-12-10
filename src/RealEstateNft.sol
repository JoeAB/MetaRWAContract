// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstateNFT is ERC721Enumerable, Ownable {
    constructor() ERC721("RealEstateNFT", "RE") {}

    function mint(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
    }
}