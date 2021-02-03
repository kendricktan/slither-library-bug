// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

library UnsafeMath64x64 {
  function us_mul (int128 x, int128 y) internal pure returns (int128) {
    int256 result = int256(x) * y >> 64;
    return int128 (result);
  }
}

contract Example {
  using UnsafeMath64x64 for int128;

  int128 private constant ONE = 0x10000000000000000;

  function fails(
        int128 _alpha,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals,
        int128[] memory _weights
    ) private pure {
        uint256 _length = _nBals.length;

        for (uint256 i = 0; i < _length; i++) {
            int128 _nIdeal = _nGLiq.us_mul(_weights[i]);

            if (_nBals[i] > _nIdeal) {
                int128 _upperAlpha = ONE + _alpha;

                int128 _nHalt = _nIdeal.us_mul(_upperAlpha);

                if (_nBals[i] > _nHalt) {
                    int128 _oHalt = _oGLiq.us_mul(_weights[i]).us_mul(_upperAlpha);

                    if (_oBals[i] < _oHalt) revert("upper-halt");
                    if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("upper-halt");
                }
            } else {
                int128 _lowerAlpha = ONE - _alpha;

                int128 _nHalt = _nIdeal.us_mul(_lowerAlpha);

                if (_nBals[i] < _nHalt) {
                    int128 _oHalt = _oGLiq.us_mul(_weights[i]).us_mul(_lowerAlpha);

                    if (_oBals[i] > _oHalt) revert("lower-halt");
                    if (_nHalt - _nBals[i] > _oHalt - _oBals[i]) revert("lower-halt");
                }
            }
        }
    }
}