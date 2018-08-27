pragma solidity 0.4.24;

import "./SafeMath.sol";
import "./ERC721Token.sol";
import "./Ownable.sol";

/** @title DevAvatarTopics. 
    @dev a vanilla ERC721 implementation*/
contract DevAvatarTopics is ERC721Token, Ownable {
    using SafeMath for uint256;

    struct Topic {
        string _topic;

    }

    Topic[] topics;

    constructor(address _contract) public ERC721Token("DevAtarTopics","TOPIC"){
        /// @dev we approve the parent smart contract as an operator
        /// this allows for transfer of child tokens without manually approving each one
        operatorApprovals[address(this)][_contract] = true;

    }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   */
    function mint(string topic_) public onlyOwner returns(uint256 _tokenId) {

        Topic memory _new = Topic({
            _topic: topic_
        });

        _tokenId = topics.push(_new);
        _mint(address(this), _tokenId);
    }    
}    