// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {IConfigManager} from "./interfaces/IConfigManager.sol";
contract ConfigManager is IConfigManager,AccessControl {
  //  bytes32 public constant ROLE_ADMIN = keccak256("ROLE_ADMIN");

   mapping(bytes32 => Config) configMapping;
   constructor() {
      _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
   }
   function setConfig(Config calldata config) onlyRole(config.role) external {
      bytes memory nameBytes = bytes(config.name);
      bytes32 nameHash = keccak256(nameBytes);
      if(config.configType != ConfigType.T_empty) revert();
      if(config.validator.length > 0){
        (bool checked,) = address(this).call(abi.encode(config.validator,config.value));
        if(!checked) revert();
      }
      
      configMapping[nameHash] = config;

   }
   function getConfig(string memory name) public view returns(bytes32) {
      bytes32 nameHash = _getNameHash(name);
      Config storage config = configMapping[nameHash];
      ConfigType configType = config.configType;
      if(configType == ConfigType.T_empty) revert();
      if(configType == ConfigType.T_address) return _parseT_address(config.value);
      if(configType == ConfigType.T_uint256) return _parseT_uint256(config.value);
   }
   function _getNameHash(string memory name) internal pure returns(bytes32 nameHash) {
     nameHash = keccak256(bytes(name));
     return nameHash;
   }
   function _parseT_uint256(bytes32 value) internal pure returns(uint256) {
     return uint256(value);
   }
   function _parseT_address(bytes32 value) internal pure returns(address) {
      return address(uint160(_parseT_uint256(value)));
   }
}
