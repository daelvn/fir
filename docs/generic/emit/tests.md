# fir.generic.emit.tests

An emitter that works with a [GenericAST](/generic/parser.md#GenericAST) and turns it into runnable tests.

## API

This is the API provided to work with the test emitter.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [emit](#emit) | Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes. |
| [emitFunctionCall](#emitFunctionCall) | Emits a function call across languages |
| [emitIfStatement](#emitIfStatement) | Emits an if statement across languages |
| [emitInlineFunctionDefinition](#emitInlineFunctionDefinition) | Emits an inline function declaration across languages |
| [emitInternal](#emitInternal) | Emits tests, as an internal function to be used in several parts. |
| [emitLocalDeclaration](#emitLocalDeclaration) | Emits a local declaration across languages |
| [emitPairsForStatement](#emitPairsForStatement) | Emits a for statement across languages |
| [emitParentheses](#emitParentheses) | Emits an expression in parentheses across langauges |
| [emitString](#emitString) | Emits a string across languages |
| [emitTableIndex](#emitTableIndex) | Emits a table index across languages |
| [emitTableLiteral](#emitTableLiteral) | Emits a table literal across languages |
| [emitTestHeader](#emitTestHeader) | Emits test headers. |
| [emitTestWrapper](#emitTestWrapper) | Wraps a test line in counters and error protectors |

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emit</strong>&nbsp;
<span class='annotate'>:: ast:GenericAST, options:table -> code:string</span>
</div>


Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes.

- Emits Lua tests from a `GenericAST` using `test` and `tagged-test` nodes.

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitFunctionCall</strong>&nbsp;
<span class='annotate'>:: fn:string, args:[string], options:table</span>
</div>

**Aliases:** `efn`

Emits a function call across languages



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitIfStatement</strong>&nbsp;
<span class='annotate'>:: condition:string, block:[string], options:table</span>
</div>

**Aliases:** `eif`

Emits an if statement across languages

- Emits an if statement across languages

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitInlineFunctionDefinition</strong>&nbsp;
<span class='annotate'>:: args:[string], body:string, options:table</span>
</div>

**Aliases:** `eidef`

Emits an inline function declaration across languages



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitInternal</strong>&nbsp;
<span class='annotate'>:: description:[DescriptionLine], options:table, append:function, prepend:function, placement:string -> nil</span>
</div>


Emits tests, as an internal function to be used in several parts.



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitLocalDeclaration</strong>&nbsp;
<span class='annotate'>:: name:string, lhs:string, options:table</span>
</div>

**Aliases:** `elocal`

Emits a local declaration across languages



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitPairsForStatement</strong>&nbsp;
<span class='annotate'>:: k:string, v:string, iterator:string, body:string, options:string</span>
</div>

**Aliases:** `eforp`

Emits a for statement across languages

- Emits a for statement across languages

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitParentheses</strong>&nbsp;
<span class='annotate'>:: content:string</span>
</div>

**Aliases:** `eparen`

Emits an expression in parentheses across langauges



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitString</strong>&nbsp;
<span class='annotate'>:: content:string</span>
</div>

**Aliases:** `estring`

Emits a string across languages



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitTableIndex</strong>&nbsp;
<span class='annotate'>:: table:string, index:string</span>
</div>

**Aliases:** `eindex`

Emits a table index across languages

- Emits a table index across languages

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitTableLiteral</strong>&nbsp;
<span class='annotate'>:: tbl:table, options:table</span>
</div>

**Aliases:** `etable`

Emits a table literal across languages



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitTestHeader</strong>&nbsp;
<span class='annotate'>:: node:table, count:number, options:table, append:function, prepend:function, placement:string -> nil</span>
</div>


Emits test headers.



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitTestWrapper</strong>&nbsp;
<span class='annotate'>:: name:string, count:number, body:string, options:table -> code:string</span>
</div>

**Aliases:** `ewrap`

Wraps a test line in counters and error protectors

- Wraps a test line in counters and error protectors
