# fir.generic.emit.tests

An emitter that works with a [GenericAST](/generic/parser.md#GenericAST) and turns it into runnable tests.

## API

This is the API provided to work with the test emitter.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [emit](#emit) | Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes. |
| [emitInternal](#emitInternal) | Emits tests, as an internal function to be used in several parts. |
| [emitTestHeader](#emitTestHeader) | Emits test headers. |

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emit</strong>&nbsp;
<span class='annotate'>:: ast:GenericAST, options:table -> lua:string</span>
</div>


Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes.

- Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes.

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitInternal</strong>&nbsp;
<span class='annotate'>:: description:[DescriptionLine], options:table, append:function, prepend:function, placement:string -> nil</span>
</div>


Emits tests, as an internal function to be used in several parts.



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitTestHeader</strong>&nbsp;
<span class='annotate'>:: node:table, count:number, options:table, append:function, prepend:function, placement:string -> nil</span>
</div>


Emits test headers.


