// https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}

interface ERC721 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);
}


interface ERC721TokenReceiver {
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )  
  external returns(bytes4);
}

contract ERC721Token is ERC721 {
    using Address for address;
    mapping(address => uint256) private ownerToTokenCount;
    mapping(uint256 => address) private idToOwner;
    bytes internal constant MAGIC_ON_ECR721_RECEIVE = 0x150b7a02;
    string public name;
    string public symbol;
    string public tokenURIBase;

    constructor(string memory _name, string memory _symbol, string memory _tokenURIBase) public {
        name = _name;
        symbol = _symbol;
        tokenURIBase = _tokenURIBase;
    }

    function _mint(address _owner, uint256 _tokenId ) internal {
        require(idToOwner[_tokenId] == address(0), "This token already exist");
        idToOwner[_tokenId] = _owner;
        ownerToTokenCount[_owner] += 1;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory){
        return string(abi.encodePacked(tokenURIBase, _tokenId));
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerToTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return idToOwner[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(msg.sender == _from, "Can not auth transaction");
        require(_from == idToOwner[_tokenId], "Can not auth transaction");

        ownerToTokenCount[_from] -= 1;
        ownerToTokenCount[_to] += 1;
        idToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable {
        _safeTransferFrom(_from, _to, _tokenId, data);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }

    function _safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) internal {
        require(msg.sender == _from, "Can't auth the trnsfer token");
        require(_from == idToOwner[_tokenId], "Can't auth the trnsfer token");

        ownerToTokenCount[_from] -= 1;
        ownerToTokenCount[_to] += 1;
        idToOwner[_tokenId] = _to;
        emit(_from, _to, _tokenId);

        if(_to.isContract()){
            ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
            require(retval = MAGIC_ON_ECR721_RECEIVE, "This is SC, so can't transfer token." );
        }
    }

    function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )  external returns(bytes4){

  }
}
