# Tests

This page explains how to use the `tests` Generic emitter to generate tests. The emitter generates a Lua file that is, re-parsable by Fir to generate Markdown information about the test. So, if desired, a test pipeline can be run twice, once to generate the tests, and another to generate the test documentation.

A lot more functionality can be enabled if using the [`luassert`](https://github.com/lunarmodules/luassert) module.

## Configuring test emitting

Below is the configuration for test emitting. Format must be set to `"emit"` for these options to apply.

| **Option** | **Type** | **Default** | **Meaning** |
|--|--|--|--|
| `module` | String | [GenericAST](/fir/generic/parser#GenericAST).title | Name of the module to `require` |
| `header` | String | None | Code or comments to append to the comment header |
| `subheader` | String | `'General'` | Name of the documentation section for tests |
| `trim` | Boolean | `true` | Whether to trim spaces on test lines |
| `newline` | String | `\n` | Newline character |   
| `luassert` | Boolean | `true` | Whether to use `luassert` or not |
| `print` | `'pretty'`\|`'plain'`\|`'plain-verbose'`\|`'tap'`\|`false` | `'pretty'` | Whether to print test parts and results |
| `testHeaders` | Boolean | `true` | Whether to emit documentation headers for each test |
| `docs` | Boolean | `true` | Whether to add comments to the tests at all |
| `auto_unpack` | Boolean | `false` | Whether to unpack each symbol automatically |
| `unpack` | \[String\] | None | List of symbols to unpack, making them accessible directly without prefixing with `M` |
| `snippet` | String | None | Snippet of code to add before all the tests |
| `all` | Boolean | None | Whether to set all tags to `true` (Execute all tests) |

### Printing modes

Fir now offers different printing modes depending on your needs.

- `pretty` will print pending and failed tests, as well as results, using colors.
- `plain` does exactly the same with no color.
- The `-verbose` variants will also print successes.
- `tap` tries to output according to the [TAP protocol](https://testanything.org/tap-version-14-specification.html)
- Setting it to `false` will not print anything


## Structure of a test

- Header
- `option.header`
- Imports (`luassert` and your module)
- Unpack `options.unpack`
- `options.snippet`
- Parse arguments (`{...}`) into a tag list (`tags`)
- `options.all` setup
- Insert docs description and `options.subheader` as its header
- Iterate sections
    - Emit each test

## How unpacking works

There are two kinds of unpacking: through `options.unpack` or by setting `options.auto_unpack`.

### Explicit unpacking

All the symbols listed in `options.unpack` will be unpacked in the form `(local) <symbol> = M['<symbol>']` where `M` is your required module.

### Automatic unpacking

The metatable of the environment is set so that `M` is a fallback table. This way, all functions and symbols can be accessed automatically without the need to list them in an unpack.

## Test lines

### Test configuration

These configuration comments should go before the test you want to mark.

Mark a test as pending: `?$ pending`                                                  

### Verbatim tests

These kinds of tests are pasted into the code verbatim.

=== "Lua"
    ```lua
    -- ?! print(VALUE)
    ```

### Verbatim setup

These comments will embed code lines directly into the output, as to setup tests.

=== "Lua"
    ```lua
    -- !! array = {1, 2, 3}
    ```

### Truthy tests

These kinds of tests check for a truthy result. The contents are placed inside `assert`, or `assert.truthy` in the case of using `luassert`.


=== "Lua"
    ```lua
    -- ?? VALUE
    ```

### Tagged tests

Tagged tests are tests that are only run if a certain tag is passed to the runner file. Otherwise equivalent to [Truthy tests](#Truthy-tests)

=== "Lua"
    ```lua
    -- ?? tag: VALUE
    ```

### `luassert` tests

These tests directly leverage `luassert` to check for different conditions. The error message `err` is always optional.

| **Letter** | **`luassert`** | **Meaning** |
|--------|----------|---------|
| `T` | `is_true(value, err)` | Check for `true` |
| `t` | `truthy(value, err)` | Check for a truthy value |
| `F` | `is_false(value, err)` | Check for `false` |
| `f` | `falsy(value, err)` | Check for a falsy value |
| `E` | `has_no.errors(fn, err)` | Check that a function has no errors |
| `e` | `errors(fn, expected_err, err)` | Checks that a function errors |
| `n` | `near(num, expected_num, tolerance)` | Checks that a number is within tolerance of expectation |
| `u` | `unique(list, err, deep?)` | Checks that every value in a list is unique |
| `:` | `matches(value, pattern, err)` | Checks that a value matches a Lua pattern |
| `=` | `equals(value, expected, err)` | Checks that two values are equal (`==`) |
| `~` | `same(value, expected, err)` | Checks that two values are similar through a deep compare |
| `#` | type | Using the tag, checks if the passed expression is (type) |

You can negate the test result by putting a caret (`^`) between the two interrogation signs.

=== "Lua"
    ```lua
    -- ??t truthy_value, "Not truthy"
    -- ?^?= value, expected, "They are, but shouldn't be equal"
    -- ??# string: stringy_value, "Not a string"
    ```

### `luassert` tagged tests

Equivalent to [`luassert` tests](#luassert-tests), but with tags as in [Tagged test](#Tagged-tests) syntax.

!!! warning
    The type `luassert` test (`??#`) does not work with tagged tests because they use the tag as the type to test for.
