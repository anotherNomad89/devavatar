pragma solidity 0.4.24;

import "./ERC721.sol";  /* DONE */
import "./ERC721Receiver.sol";  /* DONE */
import "./SafeMath.sol";  /* DONE */
// import "./AddressUtils.sol";  /* DONE */
import "./SupportsInterfaceWithLookup.sol"; /* DONE */


/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic { /* DONE */

    bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;  /* DONE */
  /*
   * 0x80ac58cd ===
   *   bytes4(keccak256('balanceOf(address)')) ^
   *   bytes4(keccak256('ownerOf(uint256)')) ^
   *   bytes4(keccak256('approve(address,uint256)')) ^
   *   bytes4(keccak256('getApproved(uint256)')) ^
   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
   */

    bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79; /* DONE */
  /*
   * 0x4f558e79 ===
   *   bytes4(keccak256('exists(uint256)'))
   */

    using SafeMath for uint256; /* DONE */
    // using AddressUtils for address; /* DONE */

  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant ERC721_RECEIVED = 0x150b7a02; /* DONE */

  // Mapping from token ID to owner
    mapping (uint256 => address) internal tokenOwner; /* DONE */

  // Mapping from token ID to approved address
    mapping (uint256 => address) internal tokenApprovals; /* DONE */

  // Mapping from owner to number of owned token
    mapping (address => uint256) internal ownedTokensCount; /* DONE */

  // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) internal operatorApprovals; /* DONE */

  /**
   * @dev Guarantees msg.sender is owner of the given token
   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
   */
    modifier onlyOwnerOf(uint256 _tokenId) { /* DONE */
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }

  /**
   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
   * @param _tokenId uint256 ID of the token to validate
   */
    modifier canTransfer(uint256 _tokenId) { /* DONE */
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _;
    }

    function isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {size := extcodesize(_addr)}
        return size > 0;
    }

    constructor() public /* DONE */
    {
    // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(InterfaceId_ERC721); /* DONE */
        _registerInterface(InterfaceId_ERC721Exists); /* DONE */
    }

  /**
   * @dev Gets the balance of the specified address
   * @param _owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
    function balanceOf(address _owner) public view returns (uint256) { /* DONE */
        require(_owner != address(0));
        return ownedTokensCount[_owner];
    }

  /**
   * @dev Gets the owner of the specified token ID
   * @param _tokenId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
    function ownerOf(uint256 _tokenId) public view returns (address) { /* DONE */
        address owner = tokenOwner[_tokenId];
        require(owner != address(0));
        return owner;
    }

  /**
   * @dev Returns whether the specified token exists
   * @param _tokenId uint256 ID of the token to query the existence of
   * @return whether the token exists
   */
    function exists(uint256 _tokenId) public view returns (bool) { /* DONE */
        address owner = tokenOwner[_tokenId];
        return owner != address(0);
    }

  /**
   * @dev Approves another address to transfer the given token ID
   * The zero address indicates there is no approved address.
   * There can only be one approved address per token at a given time.
   * Can only be called by the token owner or an approved operator.
   * @param _to address to be approved for the given token ID
   * @param _tokenId uint256 ID of the token to be approved
   */
    function approve(address _to, uint256 _tokenId) public { /* DONE */
        address owner = ownerOf(_tokenId);
        require(_to != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

  /**
   * @dev Gets the approved address for a token ID, or zero if no address set
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return address currently approved for the given token ID
   */
    function getApproved(uint256 _tokenId) public view returns (address) { /* DONE */
        return tokenApprovals[_tokenId];
    }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param _to operator address to set the approval
   * @param _approved representing the status of the approval to be set
   */
    function setApprovalForAll(address _to, bool _approved) public { /* DONE */
        require(_to != msg.sender);
        operatorApprovals[msg.sender][_to] = _approved;
        emit ApprovalForAll(msg.sender, _to, _approved);
    }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
    function isApprovedForAll( /* DONE */
        address _owner,
        address _operator
    )
      public
      view
      returns (bool)
    {
        return operatorApprovals[_owner][_operator];
    }

  /**
   * @dev Transfers the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
    function transferFrom( /* DONE */
        address _from,
        address _to,
        uint256 _tokenId
  )
    public
    canTransfer(_tokenId)
  {
        require(_from != address(0));
        require(_to != address(0));

        clearApproval(_from, _tokenId);
        removeTokenFrom(_from, _tokenId);
        addTokenTo(_to, _tokenId);

        emit Transfer(_from, _to, _tokenId);
    }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   *
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
    function safeTransferFrom( /* DONE */
        address _from,
        address _to,
        uint256 _tokenId
    )
      public
      canTransfer(_tokenId)
    {
      // solium-disable-next-line arg-overflow
        safeTransferFrom(_from, _to, _tokenId, "");
    }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
   * @param _data bytes data to send along with a safe transfer check
   */
    function safeTransferFrom( /*  DONE */
        address _from,
        address _to,
        uint256 _tokenId,
        bytes _data
    )
      public
      canTransfer(_tokenId)
    {
        transferFrom(_from, _to, _tokenId);
        // solium-disable-next-line arg-overflow
        require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
    }

  /**
   * @dev Returns whether the given spender can transfer a given token ID
   * @param _spender address of the spender to query
   * @param _tokenId uint256 ID of the token to be transferred
   * @return bool whether the msg.sender is approved for the given token ID,
   *  is an operator of the owner, or is the owner of the token
   */
    function isApprovedOrOwner( /* DONE */
        address _spender,
        uint256 _tokenId
    )
      internal
      view
      returns (bool)
    {
        address owner = ownerOf(_tokenId);
        // Disable solium check because of
        // https://github.com/duaraghav8/Solium/issues/175
        // solium-disable-next-line operator-whitespace
        return (
          _spender == owner ||
          getApproved(_tokenId) == _spender ||
          isApprovedForAll(owner, _spender)
        );
    }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param _to The address that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   */
    function _mint(address _to, uint256 _tokenId) internal { /* DONE */
        require(_to != address(0));
        addTokenTo(_to, _tokenId);
        emit Transfer(address(0), _to, _tokenId);
    }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
    function _burn(address _owner, uint256 _tokenId) internal {
        clearApproval(_owner, _tokenId);
        removeTokenFrom(_owner, _tokenId);
        emit Transfer(_owner, address(0), _tokenId);
    }

  /**
   * @dev Internal function to clear current approval of a given token ID
   * Reverts if the given address is not indeed the owner of the token
   * @param _owner owner of the token
   * @param _tokenId uint256 ID of the token to be transferred
   */
    function clearApproval(address _owner, uint256 _tokenId) internal { /* DONE */
        require(ownerOf(_tokenId) == _owner);
        if (tokenApprovals[_tokenId] != address(0)) {
            tokenApprovals[_tokenId] = address(0);
        }
    }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
    function addTokenTo(address _to, uint256 _tokenId) internal { /* DONE */
        require(tokenOwner[_tokenId] == address(0));
        tokenOwner[_tokenId] = _to;
        ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
    }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
    function removeTokenFrom(address _from, uint256 _tokenId) internal { /* DONE */
        require(ownerOf(_tokenId) == _from);
        ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
        tokenOwner[_tokenId] = address(0);
    }

//   /**
//   * @dev Internal function to invoke `onERC721Received` on a target address
//   * The call is not executed if the target address is not a contract
//   * @param _from address representing the previous owner of the given token ID
//   * @param _to target address that will receive the tokens
//   * @param _tokenId uint256 ID of the token to be transferred
//   * @param _data bytes optional data to send along with the call
//   * @return whether the call correctly returned the expected magic value
//   */
    function checkAndCallSafeTransfer( /* DONE */
        address _from,
        address _to,
        uint256  _tokenId,
        bytes _data
    )
      internal
      returns (bool)
    {
        if (!isContract(_to)) {
            return true;
        }
        bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return (retval == ERC721_RECEIVED);
        // return true;
    }
}

/**
 * @title Full ERC721 Token
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Token is /*SupportsInterfaceWithLookup,*/ ERC721BasicToken, ERC721 {

    bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;/* DONE */
  /**
   * 0x780e9d63 ===
   *   bytes4(keccak256('totalSupply()')) ^
   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
   *   bytes4(keccak256('tokenByIndex(uint256)'))
   */

    bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;/* DONE */
  /**
   * 0x5b5e139f ===
   *   bytes4(keccak256('name()')) ^
   *   bytes4(keccak256('symbol()')) ^
   *   bytes4(keccak256('tokenURI(uint256)'))
   */

  // Token name
    string internal name_;  /* DONE */

  // Token symbol
    string internal symbol_;  /* DONE */

  // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) internal ownedTokens; /* DONE */

  // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) internal ownedTokensIndex; /* DONE */

  // Array with all token ids, used for enumeration
    uint256[] internal allTokens; /* DONE */
  // NFT[] internal allTokens

  // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) internal allTokensIndex; /* DONE */

  // Optional mapping for token URIs
    mapping(uint256 => string) internal tokenURIs; /* DONE */

  /**
   * @dev Constructor function
   */
    constructor(string _name, string _symbol) public { /* DONE */
        name_ = _name;
        symbol_ = _symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(InterfaceId_ERC721Enumerable);
        _registerInterface(InterfaceId_ERC721Metadata);
    }

  /**
   * @dev Gets the token name
   * @return string representing the token name
   */
    function name() external view returns (string) { /* DONE */
        return name_;
    }

  /**
   * @dev Gets the token symbol
   * @return string representing the token symbol
   */
    function symbol() external view returns (string) { /* DONE */
        return symbol_;
    }

  /**
   * @dev Returns an URI for a given token ID
   * Throws if the token ID does not exist. May return an empty string.
   * @param _tokenId uint256 ID of the token to query
   */
    function tokenURI(uint256 _tokenId) public view returns (string) { /* DONE */
        require(exists(_tokenId));
        return tokenURIs[_tokenId];
    }

  /**
   * @dev Gets the token ID at a given index of the tokens list of the requested owner
   * @param _owner address owning the tokens list to be accessed
   * @param _index uint256 representing the index to be accessed of the requested tokens list
   * @return uint256 token ID at the given index of the tokens list owned by the requested address
   */
    function tokenOfOwnerByIndex( /* DONE */
        address _owner,
        uint256 _index
    )
      public
      view
      returns (uint256)
    {
        require(_index < balanceOf(_owner));
        return ownedTokens[_owner][_index];
    }

  /**
   * @dev Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
    function totalSupply() public view returns (uint256) { /* DONE */
        return allTokens.length;
    }

  /**
   * @dev Gets the token ID at a given index of all the tokens in this contract
   * Reverts if the index is greater or equal to the total number of tokens
   * @param _index uint256 representing the index to be accessed of the tokens list
   * @return uint256 token ID at the given index of the tokens list
   */
    function tokenByIndex(uint256 _index) public view returns (uint256) { /* DONE */
        require(_index < totalSupply());
        return allTokens[_index];
    }

  /**
   * @dev Internal function to set the token URI for a given token
   * Reverts if the token ID does not exist
   * @param _tokenId uint256 ID of the token to set its URI
   * @param _uri string URI to assign
   */
    function _setTokenURI(uint256 _tokenId, string _uri) internal { /* DONE */
        require(exists(_tokenId));
        tokenURIs[_tokenId] = _uri;
    }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
    function addTokenTo(address _to, uint256 _tokenId) internal { /* DONE */
        super.addTokenTo(_to, _tokenId);
        uint256 length = ownedTokens[_to].length;
        ownedTokens[_to].push(_tokenId);
        ownedTokensIndex[_tokenId] = length;
    }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
    function removeTokenFrom(address _from, uint256 _tokenId) internal { /* DONE */
        super.removeTokenFrom(_from, _tokenId);

        uint256 tokenIndex = ownedTokensIndex[_tokenId];
        uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
        uint256 lastToken = ownedTokens[_from][lastTokenIndex];

        ownedTokens[_from][tokenIndex] = lastToken;
        ownedTokens[_from][lastTokenIndex] = 0;
        // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
        // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
        // the lastToken to the first position, and then dropping the element placed in the last position of the list

        ownedTokens[_from].length--;
        ownedTokensIndex[_tokenId] = 0;
        ownedTokensIndex[lastToken] = tokenIndex;
    }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param _to address the beneficiary that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   */
    function _mint(address _to, uint256 _tokenId) internal { /* DONE */
        super._mint(_to, _tokenId);

        allTokensIndex[_tokenId] = allTokens.length;
        allTokens.push(_tokenId);
    }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param _owner owner of the token to burn
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
    function _burn(address _owner, uint256 _tokenId) internal {
        super._burn(_owner, _tokenId);

        // Clear metadata (if any)
        if (bytes(tokenURIs[_tokenId]).length != 0) {
            delete tokenURIs[_tokenId];
      }

      // Reorg all tokens array
        uint256 tokenIndex = allTokensIndex[_tokenId];
        uint256 lastTokenIndex = allTokens.length.sub(1);
        uint256 lastToken = allTokens[lastTokenIndex];

        allTokens[tokenIndex] = lastToken;
        allTokens[lastTokenIndex] = 0;

        allTokens.length--;
        allTokensIndex[_tokenId] = 0;
        allTokensIndex[lastToken] = tokenIndex;
    }

}