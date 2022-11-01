// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract NFT is ERC721,Ownable {

    uint256 constant public MAX = 4;
    uint256 public id = 1;
    uint256 public price = 0 ether;
    string public url;
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {

    }

    function mint() external payable {
        require(price == msg.value ,"Insufficient value");
        require(id <= MAX ,"Out of stock");
        _safeMint(msg.sender, id);
        ++id;
    }


    function tokenURI(uint256 tokenId) public view  override returns (string memory) {
        _requireMinted(tokenId);
        return bytes(url).length > 0 ? string(abi.encodePacked(url,"/",Strings.toString(tokenId),".json")) : "";
    }
    //https://ipfs.io/ipfs/QmdDdUDYrK5pJXM4x3yK6pe8Yzy74NAarQARRuJPLdkqiB/1.json
    //ipfs://QmdDdUDYrK5pJXM4x3yK6pe8Yzy74NAarQARRuJPLdkqiB
    function setURL(string calldata _url) external onlyOwner(){
        require(bytes(url).length==0 ,"No more than twice");
        url = _url;
    }

    function setPrice(uint256 _price) external onlyOwner(){
        price =_price;
    }

    function withdraw() external onlyOwner(){
        (bool _result, ) = msg.sender.call{value:address(this).balance}("");
        require(_result ,"Failed to withdraw");
   }
}
