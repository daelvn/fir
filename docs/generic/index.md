# Generic module

The generic module comes with Fir by default to provide a standard backend for parsing and emitting. By default, it can emit Markdown documentation, as well as [luassert](https://github.com/lunarmodules/luassert) tests.

If you're looking for the tutorial to document your code using the default backend, it can be found [here](/fir/tutorial).

## The generic pipeline

- The comments are extracted through `fir.generic.backend`. [Documentation here](/fir/generic/backend).
- Then, they are parsed by `fir.generic.parser`. [Documentation here](/fir/generic/parser).
- Lastly, they are passed through a language emitter (`fir.generic.emit.*`). [Documentation here](/fir/generic/emit/markdown).

All the moving parts and data types are documented in their respective places.

## Integrating

By creating functions that work with the data types specified in the other parts of the documentation, you're able to replace parts of the generic pipeline with your own parts. This is:want useful, for example, if you want to change the way the comments get parsed.

!!! warning "About the CLI"
    The CLI was made to work only with the generic backend. You may have to roll your own CLI or adapt the existing one to use your own backend.
