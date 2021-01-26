--# alfons.tasks.fir #--
-- Fir integration with Alfons.
import "filekit" as fs

--# Internal #--
-- Functions defined internally to be used in the taskfile.
-- @internal


--# Tasks #--
-- The definition of the taskfile.
tasks:
  fir_generate: =>
    -- variables
    config = @config
    -- locals
    cwd   = fs.currentDir!
    files = {}
  fir: =>
    generate = (uses "generate") or (uses "gen") or (uses "g")
    dump     = (uses "dump") or (uses "d")
    silent   = @silent or @s
