pragma solidity >=0.4.22 <0.9.0;

import "./IERC721.sol";

 contract Kittycontract is IERC721 {
   
    // Token name
    string public constant name = "MickeyKitties";

    // Token symbol
    string public constant symbol = "GG";

    event Birth(address owner, uint256 kittenId, uint256 momId, uint256 dadId, uint256 genes);


    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 momId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kittes;

    mapping (uint256 => address) public kittyIndexToOwner; // tokenId => kitty owner
    mapping (address => uint) ownershipTokenCount; //count of how many kitties each owner has
    
    function createKittyGen0(uint256 _genes) public onlyOwner {

    }

    function _createKitty(
        uint256 _momId,
        uint256 _dadId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    )  private returns (uint256) {
        Kitty memory _kitty = Kitty({
            genes: _gene,
            birthTime: uint64(now),
            momId: uint32(_momId),
            dadId: uint32(_dadId),
            generation: uint16(_generation)
        });

        uint256 newKittenId = kitties.push(_kitty) - 1;

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
        return _totalSupply;
    }
    /*
     * @dev Returns the name of the token.
     */
    function catName() external view override returns (string memory){
        return _name;
    }
    /*
     * @dev Returns the symbol of the token.
     */
    function catSymbol() external view override returns (string memory) {
        return _symbol;
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

    function transfer(address _to,uint256 _toeknId) external {

        require(_to != address(0));
        require(_to != address(this));
        require(_owns(msg.sender, _to, _tokenId));
    }


    function _transfer(address _from, address _to, uint256 tokenId) internal {
        ownershipTokenCount[_to]++;

        kittyIndexToOwner[_tokenId] = _to;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
        }

        // Emit the transfer event
        emit Transfer(_from, _to, _tokenId);

    }

 }   
