// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Necesito que el proyecto estén los siguientes
import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./ERC165.sol";
import "./Context.sol";

contract ERC721 is ERC165, IERC721, IERC721Metadata, Context {
    
    // VARIABLES:
    
    // Nombre y símbolo de la colección de NFTs
    string private _name;
    string private _symbol;

    mapping(uint256=>address) private _owners;
    mapping(address=>uint256) private _balances;
    mapping(uint256=>address) private _tokenApprovals;
    mapping(address=>mapping(address=>bool)) private _operatorApprovals;

    // FUNCIONES:
    
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virutal override (ERC165, IERC165) retuns (bool) {
        return 
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns(uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns(address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function name() public view virtual override returns(string memory) {
        return _name;
    }

    function symbol() public view virtual override returns(string memory) {
        return _symbol;
    }

    function approve(address to, uint256 tokenId) public view virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        
        require(_msgSender == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not token owner or approved for all");

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns(address) {
        _requireMinted(tokenId);
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);

    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns(bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: callers is not token owner or approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokneId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safetransfer(from, to, tokenId, data);
    }

    // FUNCIONES INTERNAS

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns(address) {
        return _owners[tokenId];
    }

    function _exists(uint256 tokenId) internal view virtual returns(bool) {
        return _ownerOf(tokenId)!=address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual retuns(bool) {
        address owner = ownerOf(tokenId);
        return(spender == owner || isApprovedForAll(owner,spender) || getApproved(tokenId)==spender);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, data), "ERC721: transfer to non ERC72Receiver implementer");
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exist(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId, 1);
        require(!_exist(tokenId), "ERC721: token already minted");

        unchecked {
            _balances[to]+=1;
        }

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);

    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        _beforeTokenTransfer(owner, address(0), tokenId, 1);

        owner = ownerOf(tokenId);

        delete _tokenApprovals[tokenId];

        unchecked {
            _balance[owner] -= 1;
        }

        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
        _afterTokenTransfer(owner, address(0), tokenId, 1);


    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId)==from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);
        require(ownerOf(tokenId)==from, "ERC721: transfer from incorrect owner");

        delete _tokenApprovals[tokenId];

        unchecked {
            _balances[from]-= 1;
            _balances[to]+=1;
        }

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);

    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "ERC721: approve to caller");

        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exist(tokenId), "ERC721: invalid tokenID");
    }



    


}