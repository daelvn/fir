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

| **Argument** | **Type** | **Meaning** |
|--|--|--|
| `generate` | Boolean | Equivalent to CLI `generate` command |
| `dump` | Boolean | Equivalent to CLI `dump` command |
| `config` | Table | A configuration as described for `Fir.moon`/`Fir.lua` |

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
