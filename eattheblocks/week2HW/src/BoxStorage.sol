// SPDX-License-Identifier: UNLICENSED
//Finish missing tests.

// src/BoxStorage.sol

pragma solidity ^0.8.13;

contract BoxStorage {
    struct Box {
        uint256 width;
        uint256 length;
        uint256 height;
    }
        
    uint256 public minimumSizeInCm;
    Box[] public boxes;

    error WrongWidth(uint256 providedWidth, uint256 requiredMinWidth);
    error WrongLength(uint256 providedLength, uint256 requiredMinLength);
    error WrongHeight(uint256 providedHeight, uint256 requiredMinHeight);

    constructor(uint256 _minimumSizeInCm) {
        minimumSizeInCm = _minimumSizeInCm;
    }

    function createBox(uint256 _width, uint256 _length, uint256 _height) external {
        if (_length < minimumSizeInCm) {
            revert WrongLength(_length, minimumSizeInCm);
        }
        if (_height < minimumSizeInCm) {
            revert WrongHeight(_height, minimumSizeInCm);
        }
        if (_width < minimumSizeInCm) {
            revert WrongWidth(_width, minimumSizeInCm);
        }

        boxes.push(Box(_width, _length, _height));
    }
}


