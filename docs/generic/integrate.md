# Integrating with the generic pipeline

If you want to roll out your own comment extractor, parser or emitter, you don't have to recreate the whole pipeline. The generic pipeline is fully [documented](/#/), and you can always import it from your projects. This means you can mix and match however you wish, as long as you produce an input, or accept an output that the other pieces recognize.

## CLI tool

You will need to roll your own CLI tool for this, because the included tool uses the generic pipeline by default. However, this should be fairly trivial to do, as you only need to change the `require` modules. (Or you know, don't, but at this point you might as well want to roll your own project?)