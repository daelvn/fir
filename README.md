# Fir

<a href="https://discord.gg/Y75ZXrD"><img src="https://img.shields.io/static/v1?label=discord&message=chat&color=brightgreen&style=flat-square"></a> 
![GitHub stars](https://img.shields.io/github/stars/daelvn/fir?style=flat-square)
![GitHub tag (latest SemVer pre-release)](https://img.shields.io/github/v/tag/daelvn/fir?include_prereleases&label=release&style=flat-square)
![LuaRocks](https://img.shields.io/luarocks/v/daelvn/fir?style=flat-square)

Fir is a language-agnostic documentation generator framework. It is fully modular, which means you can mix a comment extractor with a different comment parser and emitter (but you aren't going to go through the hassle of writing anything). A set of generic modules for generating Markdown documentation is provided, don't expect much more (unless you press me to write more).

## Install

You can install Fir via LuaRocks:

```
$ luarocks install fir
```

### Compiling from source

If you want to compile from source, you will need to install the following dependencies from LuaRocks:
- `argparse` (CLI)
- `ansikit` (CLI, optional if using CLI with `--silent`)
- `filekit` (Library, CLI)
- `moonplus` (Compiling)
- `alfons` (Compiling)
- `rockbuild` (Compiling)

Then, simply run `alfons compile make -v 1.0`. To clean the project, simply `alfons clean`.

## Documentation

Check out the documentation [here](//git.daelvn.com/fir/).

## Extra features

I kindly welcome new features that anyone wants to suggest or add! Feel free to open an issue or PR.

## License

This project is [Unlicensed](LICENSE.md), and released to the public domain. Do whatever you wish with it!