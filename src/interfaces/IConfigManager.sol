// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IConfigManager {

  enum ConfigType {
    T_address,
    T_uint256
  }

  struct Config{
    ConfigType configType;
    string name;
    bytes32 value;
    bytes32 role;
    bytes4 validator;
  }
}