# fir.generic.backend

A generic implementation of a backend for the Fir
documentation generator.

This specific implementation uses a `language` module (defaults to `fir.generic.languages`) to
parse comments from any file.

Check out an example output of this backend [here](/fir/examples/generic-backend.html).

## API

This is the API provided to work with the generic backend.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [extract](#extract) | Extracts comment from a string separated by newlines. |
| **Types** |  |
| [GenericComment](#GenericComment) | Comment returned by [`extract`](#extract). |
| [Language](#Language) | Language type accepted by [`extract`](#extract). |

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>extract</strong>&nbsp;
<span class='annotate'>:: input:string, language?:Language, options?:table -> comments:[[GenericComment](/fir/generic/backend#GenericComment)]</span>
</div>


Extracts comment from a string separated by newlines.

- `patterns:boolean` (`false`): Whether to use patterns for the language fields and ignore string or not.
- `ignore:string` (`"///"`): String used to determine when to start or stop ignoring comments.
- `merge:boolean` (`true`): Whether to merge adjacent single-line comments.
- `paragraphs:boolean` (`true`): Whether to split multi-line comments by empty strings (`""`).

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>GenericComment</strong>&nbsp;
</div>

Comment returned by [`extract`](#extract).


=== "Format"

    ```moon
    GenericComment {
      start   :: number
      end     :: number
      content :: [string]
    }
    ```


<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>Language</strong>&nbsp;
</div>

Language type accepted by [`extract`](#extract).


=== "Format"

    ```moon
    Language {
      single     :: string
      multi      :: [string]
      extensions :: [string]
    }
    ```

