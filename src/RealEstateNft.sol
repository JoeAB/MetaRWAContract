// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract RealEstateNFT is ERC721Enumerable, Ownable {
    constructor() ERC721("RealEstateNFT", "RE") Ownable(msg.sender) {}

    function mint(address to, string memory tokenUrl) external onlyOwner {
        bytes32 hash = keccak256(bytes(tokenUrl));
        uint256 tokenId = uint256(hash);
        _mint(to, tokenId);
    }
}