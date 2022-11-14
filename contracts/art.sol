// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArtToken is ERC721, Ownable{
    //==============================================
    //==============initial Statements==============
    //==============================================


    //Smart Contract Constructor
    constructor (string memory _name, string memory _symbol)
    ERC721(_name, _symbol){}

    // NFT token counter
    uint256 COUNTER;

    //Price of NFT tokens (price of the artwork)
    uint256 fee = 5 ether;

    // data structure with the properties of the artwork
    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    //storage structure for keeping artworks
    Art[] public art_works;

    //declaration of an event
    event NetArtWork (address indexed owner, uint256 id, uint256 dna);

    //================================================
    //===============Help functions===================
    //================================================



    //created of a random numbre (required fot NFT token properties)
    function _createRandomNum(uint256 _mod) internal view returns (uint256){
        bytes32 has_randomNum =keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randonNum = uint256(has_randomNum);
        return randonNum % _mod;

    }


    // NTF Creation (Artworks)
    function _crateArtWorks(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randDna = _createRandomNum(10**16);
        Art memory newArtWork = Art(_name, COUNTER, randDna, 1, randRarity);
        art_works.push(newArtWork);
        _safeMint(msg.sender, COUNTER);
        emit NetArtWork(msg.sender, COUNTER, randDna);
        COUNTER++;
    }



    // NFT token price update
    function updateFee (uint256 _fee) external onlyOwner {
        fee = _fee; 

    }

    // visualize the balnce of the smart contract (ethers)
    function infoSmartContract()public view returns (address, uint256) {
        address SC_address = address(this);
        uint256 SC_money = address(this).balance / 10**18;
        return (SC_address, SC_money);

    }



    //obtaining all created NFT tokens(artworks)
    function getArtWorks() public view returns (Art [] memory){
        return art_works;

    }



    // obtaining a user's NFT tokens
    function getOwnerArtWorks(address _owner) public view returns (Art[] memory){
        Art [] memory result = new Art[](balanceOf(_owner));
        uint256 counter_owner = 0;
        for (uint256 i = 0; i < art_works.length; i++){
            if (ownerOf(i) == _owner){
                result[counter_owner] = art_works[i];
                counter_owner++;

            }
        }
        return result;
    }


    //==================================================
    //=============NFT token development================
    //================================================== 


    // NFT token payment
    function createRandomArtWork(string memory _name) public payable{
        require(msg.value >= fee);
        _crateArtWorks(_name);
        

    }
    // extraction od ethers from the smart contracts to the owner
    function withdraw() external payable  onlyOwner{
        address payable _owner = payable (owner());
        _owner.transfer(address(this).balance);
     }

    // level up NFT tokens no payable 
    function levelUp(uint256 _artId) public{
        require(ownerOf(_artId)== msg.sender);
        Art storage art = art_works[_artId];
        art.level++;
    }

}