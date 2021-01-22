# Roadmap

## General

- Alfons taskfiles.

## Backend

- `source` backend.
  - Backend that just returns all the source.

- `generic+` backend (iterative).
  - Reads using `io.lines()`.

## Parser

- ~~`generic` parser.~~
  - ~~Add `@table`~~
  - ~~Add `@field`~~
  - ~~Add `@variable`~~
  - ~~Add `@test`~~

- `generic+` backend (iterative).
  - Reads using an iterator and is an iterator itself.
  - Parses line-by-line for efficiency (can hold on to lines).

- `passthrough` parser.
  - `parse` = `id`

- `source` parser.
  - Haddock can lex, highlight and link source files and do static type analysis on them. This will probably never get added to Fir but I would love to see it.

## Emitters

- `highlight` emitter.
  - Highlights source code.

- `json` emitter.
  - Emits documentation as JSON.

- `haddock` emitter.
  - Emits HTML styled like the modern haddock.

## Frontends

- `docsify` frontend.
  - Included by default.