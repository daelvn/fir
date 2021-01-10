# fir.generic.backend

A generic implementation of a [backend](#/backend.md) for the Fir
documentation generator.

This specific implementation uses a `language` module (defaults to `fir.generic.languages`) to
parse comments from any file.

Check out an example output of this backend [here](/examples/generic-backend.html).

## API

This is the API provided to work with the generic backend.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [extract](#extract) | Extracts comment from a string separated by newlines. |
| **Types** |  |
| [GenericComment](#GenericComment) | Comment returned by [`extract`](#extract). |
| [Language](#Language) | Language type accepted by [`extract`](#extract). |

### extract

**Type:** `input:string, language?:Language, options?:table -> comments:[GenericComment]`  

Extracts comment from a string separated by newlines.


#### Available options

- `patterns:boolean` (`false`): Whether to use patterns for the language fields and ignore string or not.
- `ignore:string` (`"///"`): String used to determine when to start or stop ignoring comments.
- `merge:boolean` (`true`): Whether to merge adjacent single-line comments.
- `paragraphs:boolean` (`true`): Whether to split multi-line comments by empty strings (`""`).

### GenericComment

Comment returned by [`extract`](#extract).

```moon
GenericComment {
  start   :: number
  end     :: number
  content :: [string]
}
```

### Language

Language type accepted by [`extract`](#extract).

```moon
Language {
  single     :: string
  multi      :: [string]
  extensions :: [string]
}
```
