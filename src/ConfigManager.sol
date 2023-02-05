// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {IConfigManager} from "./interfaces/IConfigManager.sol";
contract ConfigManager is IConfigManager,AccessControl {
   bytes32 public constant ROLE_ADMIN = keccak256("ROLE_ADMIN");

   mapping(bytes32 => Config) configMapping;
   constructor() {
     grantRole(ROLE_ADMIN, msg.sender);
   }
   function setConfig(Config calldata config) onlyRole(config.role) external {
      bytes memory nameBytes = bytes(config.name);
      bytes32 roleHash = keccak256(nameBytes);
      if(bytes(configMapping[roleHash].name).length > 0) revert();
      if(config.validator.length > 0){
        (bool checked,) = address(this).call(abi.encode(config.validator,config.value));
        if(!checked) revert();
      }
      configMapping[roleHash] = config;
   }
   function getConfig(string memory name) public returns(bytes32) {
      
   }
}
