// SPDX-License-Identifier: MIT

/* 
  Rewrite this smart contract in Yul
*/

pragma solidity 0.8.23;

contract Counter {
    uint256 private count;

    function increment() public {
        assembly {
            let _count := sload(count.slot)
            _count := add(_count, 1)
            sstore(count.slot, _count)
        }
        //count += 1;
    }

    function decrement() public {
        assembly {
            let _count := sload(count.slot)
                if lt(_count, 1) {
                    mstore(0x80, shl(229, 4594637)) 
                    mstore(0x84, 32) 
                    mstore(0xA4, 24)
                    mstore(0xC4, "Cannot decrement below 0")
                    revert(0x80, 0x64)
                }
            _count := sub(_count, 1)
            sstore(count.slot, _count)
        }
        //require(count > 0, "Counter: cannot decrement below 0");
        //count -= 1;
    }

    function reset() public {
        assembly {
            sstore(count.slot, 0)
        }
        //count = 0;
    }

    function getCount() public view returns (uint256 currentCount) {
        assembly {
            currentCount := sload(count.slot)
        }

        //return count;
    }
}