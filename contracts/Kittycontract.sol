pragma solidity >=0.4.22 <0.9.0;

import "./IERC721.sol";

abstract contract Kittycontract is IERC721 {

    uint256 private _totalSupply;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {

        name_ = "Gigi";
        symbol_ = "GG";
        _name = name_;
        _symbol = symbol_;
        }

    mapping (uint256 => address) public kittyIndexToOwner; // tokenId => kitty owner
    mapping (address => uint) ownershipTokenCount; //count of how many kitties each owner has
    mapping (uint256 => address) kittyIndexToApproved;

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
    function name() external view override returns (string memory){
        return _name;
    }
    /*
     * @dev Returns the symbol of the token.
     */
    function symbol() external view override returns (string memory) {
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

    function transfer(address to, uint256 tokenId) external override {

        //check that 'to' address is not contract address or zero address
        require(to != address(0) && to != address(this));

        //requiring tokenId is owned by msg.sender
        require(kittyIndexToOwner[tokenId] == msg.sender);

        //updating counts
        ownershipTokenCount[msg.sender]--;
        ownershipTokenCount[to]++;

        //making transfer to 'to'
        kittyIndexToOwner[tokenId] = to;

        //emit event
        emit Transfer(msg.sender,to,tokenId);
    }

 }   
