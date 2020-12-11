// SPDX-License-Identifier:MIT
pragma solidity ^0.6.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "@opengsn/gsn/contracts/BaseRelayRecipient.sol";
import "@opengsn/gsn/contracts/interfaces/IKnowForwarderAddress.sol";

contract Token is ERC20, AccessControl, BaseRelayRecipient, IKnowForwarderAddress {
    using SafeMath for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    bytes32 public DOMAIN_SEPARATOR;
    bytes public constant EIP712_REVISION = bytes("1");
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    mapping (address => uint) public _nonces;

    constructor(uint256 supply, address forwarder) public ERC20("XLoad", "XLD") {
        _mint(_msgSender(), supply);
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(BURNER_ROLE, _msgSender());

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name())),
                keccak256(EIP712_REVISION),
                chainId(),
                address(this)
            )
        );

        trustedForwarder = forwarder;
    }

    function mintTo(address account, uint256 amount) external returns (bool) {
        require(hasRole(MINTER_ROLE, _msgSender()), 'Token: must have minter role to mint.');
        _mint(account, amount);
        return true;
    }

    function burn(uint256 amount) external {
        require(hasRole(BURNER_ROLE, _msgSender()), 'Token: must have burner role to burn.');
        _burn(_msgSender(), amount);
    }

    function versionRecipient() external override view returns (string memory) {
        return "2.0.0";
    }

    function getTrustedForwarder() public override view returns (address) {
        return trustedForwarder;
    }

    function _msgSender() internal view override(Context, BaseRelayRecipient) returns (address payable) {
        return BaseRelayRecipient._msgSender();
    }

    function _msgData() internal view override(Context, BaseRelayRecipient) returns (bytes memory) {
        return BaseRelayRecipient._msgData();
    } 

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, 'XLD: PERMIT_EXPIRED');
        uint256 currentValidNonce = _nonces[owner];
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
            )
        );

        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'XLD: INVALID_SIGNATURE');

        _nonces[owner] = currentValidNonce.add(1);
        _approve(owner, spender, value);
    }

    function chainId() public pure returns (uint _chainId) {
        assembly {
            _chainId := chainid()
        }
    }

}