// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC721.sol";
import "./Ownable.sol";

 contract Kittycontract is IERC721, Ownable {
    
    // Gen 0 Creation Limit
    uint256 public constant CREATION_LIMIT_GEN0 = 10;

    // Token name
    string public constant override name = "MickeyKitties";

    // Token symbol
    string public constant override symbol = "GG";

    event Birth(
        address owner, 
        uint256 kittenId, 
        uint256 momId, 
        uint256 dadId, 
        uint256 genes);


    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 momId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;

    mapping (uint256 => address) public kittyIndexToOwner; // tokenId => kitty owner
    mapping (address => uint) ownershipTokenCount; //count of how many kitties each owner has
    
    mapping(uint256 => address) public kittyIndexToApproved;
    mapping(address => mapping (address => bool)) private _operatorApprovals;
    
    uint256 public gen0Counter;

    function approve(address _to, uint256 _tokenId) public {
        require(kittyIndexToOwner[_tokenId] == msg.sender, "not token owner");

        

        approve(_to, _tokenId);
        emit Approval(msg.sender, _to, _tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender);

        _operatorApprovals[msg.sender][operator] = approved;
        emit SetApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(tokenId < kitties.length); //Token must exist

        return kittyIndexToApproved[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool){
        return _operatorApprovals[owner][operator];
    }

    function getKittyByOwner(address _owner) external view returns(uint [] memory) {
        uint [] memory result = new uint [] (ownershipTokenCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < kitties.length; i++) {
            if (kittyIndexToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }


    function getKitty(uint256 _id) external view returns (
        uint256 genes,
        uint256 birthTime,
        uint256 momId,
        uint256 dadId,
        uint256 generation
    )
    {
        Kitty storage kitty = kitties[_id];

        birthTime = uint256(kitty.birthTime);
        momId = uint256(kitty.momId);
        dadId = uint256(kitty.dadId);
        generation = uint256(kitty.generation);
        genes = kitty.genes;
    }
    
    function createKittyGen0(uint256 _genes) public onlyOwner returns (uint256) {
        require(gen0Counter < CREATION_LIMIT_GEN0);

        gen0Counter++;

        return _createKitty(0, 0, 0, _genes, msg.sender);
    }

    function _createKitty(
        uint256 _momId,
        uint256 _dadId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    )  private returns (uint256) {
        Kitty memory _kitty = Kitty({
            genes: _genes,
            birthTime: uint64(block.timestamp),
            momId: uint32(_momId),
            dadId: uint32(_dadId),
            generation: uint16(_generation)
        });

         kitties.push(_kitty); 
       uint256 newKittenId = kitties.length - 1;

        emit Birth(_owner, newKittenId, _momId, _dadId, _genes);

        _transfer(address(0), _owner, newKittenId);

        return newKittenId;
    }

     //Returns the number of tokens in ``owner``'s account.
    function balanceOf(address owner) external view override returns (uint256) {
        return ownershipTokenCount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() external view override returns (uint256){
        return kitties.length;
    }
    /*
     * @dev Returns the name of the token.
     */
    function catName() external pure returns (string memory){
        return name;
    }
    /*
     * @dev Returns the symbol of the token.
     */
    function catSymbol()  external pure returns (string memory) {
        return symbol;
    }
    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view override returns (address){
        require(kittyIndexToOwner[tokenId] != address(0));
        return kittyIndexToOwner[tokenId];
    }

    function transfer(address _to,uint256 _tokenId) external override view {

        require(_to != address(0), "_to cant be a zero address");
        require(_to != address(this), "not the same address as _to");
        require(kittyIndexToOwner[_tokenId] == msg.sender);
    }


    function _transfer(address _from, address _to, uint256 tokenId) internal {
        ownershipTokenCount[_to]++;

        kittyIndexToOwner[tokenId] = _to;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
        }

        // Emit the transfer event
        emit Transfer(_from, _to, tokenId);

    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return kittyIndexToOwner[_tokenId] == _claimant;
    }
    function _approve(uint256 _tokenId, address _approved) internal {
        kittyIndexToApproved[_tokenId] = _approved;
    }

 }   
