# fir.generic.emit.tests

An emitter that works with a [GenericAST](/generic/parser.md#GenericAST) and turns it into runnable tests.

## API

This is the API provided to work with the test emitter.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [emit](#emit) | Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes. |

### emit

**Type:** `ast:GenericAST, options:table -> lua:string`  

Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes.


