// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "../owner/Auth.sol";

contract VoucherNft is ERC721, Auth {
  using SafeMath for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  struct NftInfo {
    uint256 nftId;
    string nftName;
    address user;
    address ido;
    address token;
    uint256 premium;
    uint256 time;
    uint256 investedAmount;
  }

  NftInfo[] public userNftAll;

  mapping(uint256 => NftInfo) public nftInfo;

  mapping(address => NftInfo[]) public userNftInfo;

  constructor(string memory _uri) public ERC721("NFTReceipt", "PROOF") {
    _setBaseURI(_uri);
  }

  function setNftUri(string memory _uri) public onlyOperator {
    _setBaseURI(_uri);
  }

  function mintNft(
    string memory _name,
    address _user,
    address _ido,
    address _token,
    uint256 _num,
    uint256 _investedAmount
  ) public onlyOperator {
    require(_user != address(0), "User address cannot be zero!");
    require(_ido != address(0), "Ido address cannot be zero!");
    require(_token != address(0), "Token address cannot be zero!");
    require(_num > 0, "Quantity cannot be less than zero!");

    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();

    NftInfo memory obj = NftInfo({nftId: newTokenId, nftName: _name, user: _user, ido: _ido, token: _token, premium: _num, time: block.timestamp, investedAmount: _investedAmount});

    nftInfo[newTokenId] = obj;

    userNftAll.push(obj);
    userNftInfo[_user].push(obj);

    _mint(_user, newTokenId);
  }

  function queryUserNftArray(address _user) public view returns (NftInfo[] memory) {
    return userNftInfo[_user];
  }

  function queryUserNftAll() public view returns (NftInfo[] memory) {
    return userNftAll;
  }

  function queryUserAllNft(uint256[] memory _ids) public view returns (NftInfo[] memory nftArray) {
    nftArray = new NftInfo[](_ids.length);
    for (uint256 i = 0; i < _ids.length; i++) {
      nftArray[i] = nftInfo[_ids[i]];
    }
    return nftArray;
  }
}
