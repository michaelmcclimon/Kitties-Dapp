// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0; 

import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./Ownable.sol";

contract Kittycontract is IERC721, Ownable { 
     
    // Gen 0 Creation Limit
    uint256 public constant CREATION_LIMIT_GEN0 = 10;

    // Token name
    string public constant override name = "MickeyKitties";

    
    // Token symbol
    string public constant override symbol = "GG";
    
    // Checking for ERC721 on other end of transfer.
    bytes4 internal constant MAGIC_ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    bytes4 private constant _INTERFACE_ID_ERC721 =  0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC165 =  0x01ffc9a7;

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
    mapping(uint256 => address) public kittyIndexToApproved; // Giving ownership rights to another address
    mapping(address => mapping (address => bool)) private _operatorApprovals; // Takes address of another owner and then operator address and returns T/F
    
    uint256 public gen0Counter;


    function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
        return ( _interfaceId == _INTERFACE_ID_ERC721 || _interfaceId == _INTERFACE_ID_ERC165);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public override {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public override  {
    require(_to != address(0),"Receiver cannot have address(0)");
    require(msg.sender == _from || _approvedFor(msg.sender, _tokenId) || isApprovedForAll(_from, msg.sender));
    require(_owns(_from, _tokenId));
    require(_tokenId < kitties.length);

    _safeTransfer(_from, _to, _tokenId, _data);
}

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal {
        _transfer(_from, _to, _tokenId);
        require(_checkERC721Support(_from, _to, _tokenId, _data) );
    }

    function approve(address _to, uint256 _tokenId) public {
        require(_owns(msg.sender, _tokenId),"Not Token Owner!");
        

        _approve(_tokenId, _to);
        emit Approval(msg.sender, _to, _tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender);

        _operatorApprovals[msg.sender][operator] = approved;
        emit _setApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(tokenId < kitties.length); //Token must exist

        return kittyIndexToApproved[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool){
        return _operatorApprovals[owner][operator];
    }

function transferFrom(address _from, address _to, uint256 _tokenId) public override payable {
    require(_to != address(0),"Receiver cannot have address(0)");
    require(msg.sender == _from || _approvedFor(msg.sender, _tokenId) || isApprovedForAll(_from, msg.sender));
    require(_owns(_from, _tokenId));
    require(_tokenId < kitties.length);

    _transfer(_from, _to, _tokenId);
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
        Kitty storage kitty = kitties[_id]; // using storage not memory, no need to make a local copy.

        birthTime = uint256(kitty.birthTime);
        momId = uint256(kitty.momId);
        dadId = uint256(kitty.dadId);
        generation = uint256(kitty.generation);
        genes = kitty.genes;
    }
    
    //Miting Gen0 NFT
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

    function breed(uint _dadId, uint _momId) public returns(uint){
        require(_dadId != _momId,'DadID and momID cannot be the same');
        require(_owns(msg.sender,_dadId),'Dad token does not belong to the owner');
        require(_owns(msg.sender,_momId),'Mom token does not belong to the owner');

        Kitty memory dad = kitties[_dadId];
        Kitty memory mom = kitties[_momId];
        uint babyDNA = _mixDNA(dad.genes,mom.genes);
        uint babyGEN = (_dadId >= _momId) ? (_dadId + 1):( _momId + 1);

        return _createKitty(_momId,_dadId,babyDNA,babyGEN,msg.sender);
    }


     //Returns the number of tokens in ``owner``'s account.
    function balanceOf(address owner) external view override returns (uint256) {
        return ownershipTokenCount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() external view override returns (uint256){
        return kitties.length; // length of []kitties
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
        require(_owns(msg.sender, _tokenId));
    }


    function _transfer(address _from, address _to, uint256 tokenId) internal {
        ownershipTokenCount[_to]++; // Increase token count for recipient.

        kittyIndexToOwner[tokenId] = _to;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--; // Decrease token count from sender.
            delete kittyIndexToApproved[tokenId];
        }

        // Emit the transfer event
        emit Transfer(_from, _to, tokenId);

    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return kittyIndexToOwner[_tokenId] == _claimant; // For multiple use with _owns
    }
    function _approve(uint256 _tokenId, address _approved) internal {
        kittyIndexToApproved[_tokenId] = _approved;
    }

    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return kittyIndexToApproved[_tokenId] == _claimant;
    }

    function _checkERC721Support(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if(!_isContract(_to) ){
            return true;
        }

        bytes4 returnData = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return returnData == MAGIC_ERC721_RECEIVED;
    }

    function _isContract(address _to) view internal returns (bool){
        uint32 size;
        assembly{
            size := extcodesize(_to)
        }
        return size > 0;
    }

    function _mixDNA(uint dadDNA,uint momDNA) pure internal returns(uint){
        uint firstHalf = dadDNA / 100000000; // Dad DNA half
        uint secondHalf = momDNA % 100000000; // Mom DNA half

        uint newDNA = firstHalf * 100000000 + secondHalf; // New DNA from parents
        return newDNA;
    }


    }

