# Fir 2

![Discord](https://img.shields.io/discord/454435414044966913?style=for-the-badge&logo=discord)
![GitHub Repo stars](https://img.shields.io/github/stars/daelvn/fir?style=for-the-badge&logo=github)
![GitHub Tag](https://img.shields.io/github/v/tag/daelvn/fir?style=for-the-badge&logo=github)
![LuaRocks](https://img.shields.io/luarocks/v/daelvn/fir?style=for-the-badge&logo=lua)

![Fir Logo](/fir/fir-logo.png){ width=128 height=128 align=left }

Fir is a language-agnostic documentation generator framework. It is fully modular, which means you can mix a comment extractor with a different comment parser and emitter (but you aren't going to go through the hassle of writing anything). A set of generic modules for generating Markdown documentation is provided, don't expect much more (unless you press me to write more).

<br/>

!!! tip
    Check out the new Fir 2 update! Renewed, with symbol support, verbatim inputs, and a little more. [Changelog below](#2).

## Table of contents

<!--toc:start-->
- [Fir 2](#Fir-2)
  - [Table of contents](#Table-of-contents)
  - [Install](#Install)
    - [Compiling from source](#Compiling-from-source)
  - [Changelog](#Changelog)
  - [Documentation](#Documentation)
  - [Extra features](#Extra-features)
  - [License](#License)
<!--toc:end-->

## Install

You can install Fir via LuaRocks:

```
$ luarocks install fir
```

### Compiling from source

If you want to compile from source, you will need to install the following dependencies from LuaRocks:
- `argparse` (CLI)
- `ansikit` (CLI, optional if using CLI with `--silent`)
- `lpath` (Library, CLI)
- `lrexlib-pcre2` (Library, CLI)
- `yuescript` (Compiling)
- `alfons` (Compiling)
- `rockbuild` (Compiling)

Then, simply run `alfons compile make -v 1.0`. To clean the project, simply `alfons clean`.

## Changelog

### 2.x

- **2.0.0** (04.10.2024)

Fir 2 is being released! Out of the necessity to use a more modern documentation for my other, better project, [Alfons](https://github.com/daelvn/alfons), I decided to update this project. Here's the main changes:

- **Revamped test suite generator.** The `tests` format now actually works, and generates robust tests from your documentation that can check for many conditions. It's even [TAP](https://testanything.org/tap-version-14-specification.html) compliant for your CI needs!
- **Symbol linking.** Fir CLI using the Generic backend will now collect all symbols and let you link to them with `@@@` syntax.
- **Verbatim inputs.** Those inputs will be copied over directly to the output folder.
- **Alfons integration.** Fir automatically installs a loadable [Alfons](https://github.com/daelvn/alfons) task, so you can integrate it into your Alfons workflows. Use `load 'fir'` to load it.
- **Symbol summaries can now be longer than one line.** The summary ends on the first line that does not begin with a \<lead> character.
- **Aliases are deranked.** Now (under the Generic backend) aliases are not put beside the name.
- **Better error reporting.** No more unparsable errors.
- **Output for MkDocs.** The Generic Markdown emitter now has specific MkDocs options.
- **Updated documentation.** It's easier to understand how the fuck to use this.
- **Documentation now uses [Material for MkDocs](https://squidfunk.github.io/mkdocs-material).** For a more clean, updated and powerful look and feel.
- **Switched to more robust libraries.** [lpath](https://github.com/starwing/lpath) for FS operations, [lrexlib on PCRE2 backend](https://github.com/rrthomas/lrexlib) for symbol syntax.
- **Updated from MoonPlus to Yuescript.** MoonPlus has not been a thing for years and instead transitioned into being [Yuescript](https://yuescript.org).

## Documentation

Check out the documentation [here](//daelvn.github.io/fir/).

## Extra features

I kindly welcome new features that anyone wants to suggest or add! Feel free to open an issue or PR.

## License

This project is [Unlicensed](LICENSE.md), and released to the public domain. Do whatever you wish with it!
