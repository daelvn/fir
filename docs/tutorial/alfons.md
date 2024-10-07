# Using from Alfons

As of Fir 2, you can use Fir directly from Alfons without having to go through a shell interface or have a separate configuration file.
The integration is installed automatically when you install the `fir` LuaRocks package.

## Loading

It is recommended that you load external tasks in the `always` task. In rare cases (using the Alfons API) this might be disabled.

=== "Lua"
    ```lua
    function always()
      load "fir"
    end
    ```

=== "MoonScript"
    ```moon
    tasks:
      always: => load 'fir'
    ```

## Using

You can use Fir from Alfons by calling `tasks.fir` once it is loaded (which should be always). The task takes the following arguments:

| **Argument** | **Type** | **Default** | **Meaning** |
|--|--|--|--|
| `generate` | Boolean | None | Equivalent to CLI `generate` command |
| `dump` | Boolean | None | Equivalent to CLI `dump` command |
| `reader` | `path:string -> content:string` | Alfons `readfile` | Function that reads the content of a file |
| `writer` | `path:string, content:string -> void` | Alfons `writefile` | Function that writes the content of a file |
| `config` | Table | None | A configuration as described for `Fir.moon`/`Fir.lua` |

If you have a Firfile that looks like the following:

=== "Lua"
    ```lua
    name = "Fir"
    format = "markdown"
    ```

=== "MoonScript"
    ```moon
    config:
      name: 'Fir'
      format: 'markdown'
    ```

Then you would call Fir in Alfons as such:

=== "Lua"
    ```lua
    function use_fir()
      tasks.fir {
        generate = true,
        config = {
          name = "Fir",
          format = "markdown"
        }
      }
    end
    ```

=== "MoonScript"
    ```moon
    tasks:
      use_fir: =>
        tasks.fir generate: true, config:
          name: 'Fir'
          format: 'markdown'
    ```

### `reader`/`writer`

It is possible to configure `reader` and `writer` so that you can apply transformations to the files being read or written. For example, if you are copying over your `README.md` to an `index.md` like Fir does, you might want to change the syntax of some components like admonitions. This is how you could do that:

=== "Lua"
    ```lua
    function generate_docs()
      tasks.fir {
        generate = true,
        writer = function(path, content)
          if path == "README.md" then
            writefile(path, content:gsub('> [!TIP]\n> ', '!!! tip\n    '))
          else
            writefile(path, content)
          end
        end,
        config = {
          name = "Fir",
          format = "markdown"
        }
      }
    end
    ```

=== "MoonScript"
    ```moon
    tasks:
      generate_docs: =>
        tasks.fir generate: true,
          writer: (path, content) =>
            if path == 'README.md'
              writefile path, content\gsub '> [!TIP]\n> ', '!!! tip\n    '
            else
              writefile path, content
          config:
            name: 'Fir'
            format: 'markdown'
    ```
