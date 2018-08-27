pragma solidity 0.4.24;

import "./modules/ComposableTopDown.sol";
import "./modules/ERC721.sol";
import "./modules/DevAvatarTopics.sol";

/** @title DevAvatar. 
    @dev an ERC998 Top Down Implementaion based on 
    https://github.com/mattlockyer/composables-998 and
    Moken smart contract: 
    https://etherscan.io/address/0xaaf401585b72c678afc09036510d3ef759bdaf7e#code */
contract DevAvatar is ComposableTopDown, ERC721 {
    address public owner;

    /// @dev DevAvatar struct stores anme and parent token if it exists */
    struct Developer {
        string name;
        uint256 parentTokenId;
    }
    /// @dev Mapping of tokken ID to Developer struct
    mapping(uint256 => Developer) internal dev;

    uint256 constant MAX_TOKENS = 4294967296; // maximum supply cap
    uint256 constant MAX_OWNER_TOKENS = 1; // only one DevAtar per user

    /// @dev ERC165 based interface ID signatures
    bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
    bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
    bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
    bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;

    bytes4 private constant InterfaceId_ERC998ERC721TopDown = 0x1efdf36a;
    bytes4 private constant InterfaceId_ERC998ERC721TopDownEnumerable = 0xa344afe4;
    bytes4 private constant InterfaceId_ERC998ERC20TopDown = 0x7294ffed;
    bytes4 private constant InterfaceId_ERC998ERC20TopDownEnumerable = 0xc5fd96cd;

    /// @dev Mapping from owner to list of owned token IDs
    mapping(address => uint32[]) internal ownedTokens;

    /// @dev parent address => (parent tokenId => array of child tokenIds)
    mapping(address => mapping(uint256 => uint32[])) internal parentToChildTokenIds;

    /// @dev parent tokenId => array of child tokenIds
    mapping(uint256 => uint32[]) internal parentTokenToChildTokenIds;
    
    /// @dev parent tokenId => array of child tokenIds
    mapping(uint256 => address[]) internal parentTokenToChildTokenContracts;    

    /// @dev tokenId => position in childTokens array
    mapping(uint256 => uint256) internal tokenIdToChildTokenIdsIndex;

    mapping(string => uint256) internal tokenByName_;

    /// @dev Child token contract - DevAvatar tokenswill be assigned 
    /// ERC721 children tokens from this contract
    DevAvatarTopics public _devAvatarTopics;

    /// @dev limits access to contract deployer
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be the contract owner.");
        _;
    }
    /// @dev constructor registers Interface IDs (see ./modules/SupportsInterfaceWithLookUp)
    /// deploys the DevAvatarTopics child contract
    constructor() public {

        owner = msg.sender;
        _registerInterface(InterfaceId_ERC721); 
        _registerInterface(InterfaceId_ERC721Exists); 
        _registerInterface(InterfaceId_ERC721Enumerable);
        _registerInterface(InterfaceId_ERC721Metadata);
        _registerInterface(ERC721_RECEIVED_NEW);
        _registerInterface(ERC721_RECEIVED_OLD);
        _registerInterface(InterfaceId_ERC998ERC721TopDown);
        _registerInterface(InterfaceId_ERC998ERC721TopDownEnumerable);
        _registerInterface(InterfaceId_ERC998ERC20TopDown);
        _registerInterface(InterfaceId_ERC998ERC20TopDownEnumerable);

        _devAvatarTopics = new DevAvatarTopics(address(this));

    }

    /// @dev method that mints and DevAvatarTopics Tpocs and assigns it to user's DevAvatar
    /// @param _topic the topic of discussion eg:Solidity, Web3, Python, React, etc, etc
    function getTopic(string _topic) external {

        address _from = msg.sender;
        uint256 _tokenId = ownedTokens[_from][0];

        uint256 _childTokenId = DevAvatarTopics(_devAvatarTopics).mint(_topic);
        receiveChild(_from, _tokenId, _devAvatarTopics, _childTokenId);
        require(_from == msg.sender ||
        ERC721(_devAvatarTopics).isApprovedForAll(_from, msg.sender) ||
        ERC721(_devAvatarTopics).getApproved(_childTokenId) == msg.sender);
        ERC721(_devAvatarTopics).transferFrom(_devAvatarTopics, this, _childTokenId);
        
        parentTokenToChildTokenIds[_tokenId].push(uint32(_childTokenId));
        parentTokenToChildTokenContracts[_tokenId].push(_devAvatarTopics);

    }

    /// @dev method to assign an arbitrary ERC721 child token to user's DevAvatar token
    /// @notice this contract must be approves as an operator in the child contract
    /// @notice Metamask underestimates the gas cost - so if the transaction fails try supplying a bit more gas
    function getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) public {
        super.getChild(_from, _tokenId, _childContract, _childTokenId);
        parentTokenToChildTokenIds[_tokenId].push(uint32(_childTokenId));
        parentTokenToChildTokenContracts[_tokenId].push(_childContract);
        receiveChild(_from, _tokenId, _childContract, _childTokenId);
        require(_from == msg.sender ||
        ERC721(_childContract).isApprovedForAll(_from, msg.sender) ||
        ERC721(_childContract).getApproved(_childTokenId) == msg.sender);
        ERC721(_childContract).transferFrom(_from, this, _childTokenId);

    }

    /// @dev lists the children tokens of the DevAvatar token
    function childTokensOfParent(uint256 _id) public view returns(uint32[]) {
        return parentTokenToChildTokenIds[_id];
    }
    
    /// @dev lists the children tokens contracts of the DevAvatar token
    function childContractsOfParent(uint256 _id) public view returns(address[]) {
        return parentTokenToChildTokenContracts[_id];
    }
    
    /// @dev lists the DevAvatars owned by a single user
    function tokenOfOwnerByIndex(address _tokenOwner, uint256 _index) public view returns (uint256 tokenId) {
        require(_index < ownedTokens[_tokenOwner].length, "_tokenOwner does not own a moken at this index.");
        return ownedTokens[_tokenOwner][_index];
    }

    /// @dev number of DevAvatars in existence
    function totalSupply() public view returns (uint256 totalMokens) {
        return tokenCount;
    }

    /// @dev internal index to DevAvatar ID
    /// @notice by construction the Index is the same as the token ID
    function tokenByIndex(uint256 _index) public view returns (uint256 tokenId) {
        require(_index < tokenCount, "A tokenId at index does not exist.");
        return _index;
    }

    /// @dev name of the Token
    function name() external view returns (string) {
        return "DevAvatar";
    }

    /// @dev symbol of the Token
    function symbol() external view returns (string) {
        return "DEV";
    }

    /// @dev token URI getter
    /// @notice it is not implemented, but remains as a reference
    function tokenURI(uint256 _tokenId) public view returns (string) {
        require(_tokenId < tokenCount, "Token does not exist");
        return "This is a very nice token";
    }

    /// @dev the DevAvatar token minting method
    /// @param _tokenName a unique identifier for the token
    /// @return tokenId the ID of the newly minted token
    function mint(string _tokenName) external payable returns (uint256 tokenId) {

        require(!isContract(msg.sender), "Only humans allowed");
        address _tokenOwner = msg.sender;

        tokenCount++;
        tokenId = tokenCount;

        require(tokenId < MAX_TOKENS, "Only 4,294,967,296 tokens can be created.");        
        tokenIdToTokenOwner[tokenId] = _tokenOwner;
        tokenOwnerToTokenCount[_tokenOwner]++;

        string memory lowerTokenName = validateAndLower(_tokenName);
        require(tokenByName_[lowerTokenName] == 0, "Token name already exists.");

        uint256 ownedTokensIndex = ownedTokens[_tokenOwner].length;

        require(ownedTokensIndex < MAX_OWNER_TOKENS, "Each user may have but one DevAtar associated with their Ethereum address");

        dev[tokenId].name = _tokenName;
        tokenByName_[lowerTokenName] = tokenId + 1;

        ownedTokens[_tokenOwner].push(uint32(tokenId));

        return tokenId;
    }

    /// @dev private method used to decompose user supplied strings into lowercase
    /// this allows the contract to reject conflicting token names
    /// sourced from Moken smart contract: https://etherscan.io/address/0xaaf401585b72c678afc09036510d3ef759bdaf7e#code
    function validateAndLower(string _s) private pure returns (string tokenName) {
        assembly {
        // get length of _s
            let len := mload(_s)
        // get position of _s
            let p := add(_s, 0x20)
        // _s cannot be 0 characters
            if eq(len, 0) {
                revert(0, 0)
            }
        // _s cannot be more than 100 characters
            if gt(len, 100) {
                revert(0, 0)
            }
        // get first character
            let b := byte(0, mload(add(_s, 0x20)))
        // first character cannot be whitespace/unprintable
            if lt(b, 0x21) {
                revert(0, 0)
            }
        // get last character
            b := byte(0, mload(add(p, sub(len, 1))))
        // last character cannot be whitespace/unprintable
            if lt(b, 0x21) {
                revert(0, 0)
            }
        // loop through _s and lowercase uppercase characters
            for {let end := add(p, len)}
            lt(p, end)
            {p := add(p, 1)}
            {
                b := byte(0, mload(p))
                if lt(b, 0x5b) {
                    if gt(b, 0x40) {
                        mstore8(p, add(b, 32))
                    }
                }
            }
        }
        return _s;
    }

    /// @dev method that checks if a supplied token name already exists
    function tokenNameExists(string _tokenName) external view returns (bool) {
        return tokenByName_[validateAndLower(_tokenName)] != 0;
    }

    /// @dev returns the token ID associated with the token name
    function tokenId(string _tokenName) external view returns (uint256 _tokenId) {
        _tokenId = tokenByName_[validateAndLower(_tokenName)];
        require(_tokenId != 0, "No moken exists with this name.");
        return _tokenId - 1;
    }

    /// @dev returns the token name associated with the token ID
    function tokenName(uint256 _tokenId) external view returns (string memory tokenName_) {
        tokenName_ = dev[_tokenId].name;
        require(bytes(tokenName_).length != 0, "The tokenId does not exist.");
        return tokenName_;
    }

}