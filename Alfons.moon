tasks:
  make:    => sh "rockbuild -m --delete #{@v}" if @v
  release: => sh "rockbuild -m -t #{@v} u"     if @v
  docs:    => sh "docsify serve docs"          if uses "serve"
  -- compile everything
  compile: => sh "moonp . -t build"
  -- clean everything
  clean: =>
    show "Cleaning files"
    fs.delete "build"
    for file in wildcard "**.lua"
      fs.delete file
  produce: =>
    tasks.compile!
    tasks.pack!
    tasks.clean!