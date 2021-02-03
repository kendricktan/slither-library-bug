# Slither Library Bug

MVP to demonstrate Slither bug when composing library calls in a very specific format.

```bash
# slither --version
# 0.7.0

slither .

ERROR:root:Error:
ERROR:root:Function not found on TMP_22(None) = HIGH_LEVEL_CALL, dest:TMP_21(None), function:us_mul, arguments:['_lowerAlpha']  . Please try compiling with a recent Solidity version. 'NoneType' object has no attribute 'type
```

## Related Issues

https://github.com/crytic/slither/issues/667

https://github.com/crytic/slither/issues/709