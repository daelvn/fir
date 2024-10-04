# Tests for examples/tests.lua

This test suite was automatically generated from documentation comments,
the tests are embedded in the code itself. Do not edit this file.
**Unpacked methods**
- [`test`](#test)
- [`field`](#field)
## General

Tests for the whole file are placed here.

| Element | Summary |
|---------|---------|

## Section

Tests for Section.


### `field`


| Element | Summary |
|---------|---------|
| **Tests** |  |
| [field#1](#field#1) | Test for element field #1 |
| [field#2](#field#2) | Test for element field #2 |
| [field#3](#field#3) | Test for element field #3 |
| [field#4](#field#4) | Test for element field #4 |

### field#1

Test for element field #1

- **Type:** `test`
```lua
 field == 5
```

### field#2

Test for element field #2

- **Type:** `tagged-test`
- **Tag:** ` Fail`
```lua
 field == 4
```

### field#3

Test for element field #3

- **Type:** `luassert-test` (True)
```lua
 true
```

### field#4

Test for element field #4

- **Type:** `verbatim-test`
```lua
 print "lmao"
```