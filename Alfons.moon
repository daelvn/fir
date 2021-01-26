tasks:
  make:    => sh "rockbuild -f rock-local.yml -m --delete #{@v}" if @v
  release: => sh "rockbuild -f rock-local.yml -m -t #{@v} u"     if @v
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