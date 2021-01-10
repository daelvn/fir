tasks:
  make:    => sh "rockbuild -m --delete #{@v}" if @v
  release: => sh "rockbuild -m -t #{@v} u"     if @v
  docs:    => sh "docsify serve docs"          if uses "serve"
  -- compile everything
  compile: =>
    sh "moonc #{file}" for file in wildcard "fir/**.moon"
    sh "moonp ."
  -- clean everything
  clean: =>
    show "Cleaning files"
    for file in wildcard "**.lua"
      continue if (file\match "alfons.lua") and not (file\match "bin")
      continue if (file\match "tasks")
      fs.delete file
  -- use amalg to pack Alfons
  pack: =>
    show "Packing using amalg.lua"
    @o    or= @output or "alfons.lua"
    @s    or= @entry or "bin/alfons.lua"
    modules = for file in wildcard "alfons/*.moon" do "alfons.#{filename file}" 
    sh "amalg.lua -o #{@o} -s #{@s} #{table.concat modules, ' '}"
  -- generate only alfons.lua
  produce: =>
    tasks.compile!
    tasks.pack!
    tasks.clean!