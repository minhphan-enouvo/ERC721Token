// https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

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

contract ERC721Token is ERC721 {
    mapping(address => uint256) private ownerToTokenCount;
    mapping(uint256 => address) private idToOwner;

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
    ) internal {}
}
