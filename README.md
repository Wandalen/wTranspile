
# wTranspilationStrategy [![Build Status](https://travis-ci.org/Wandalen/wTranspilationStrategy.svg?branch=master)](https://travis-ci.org/Wandalen/wTranspilationStrategy)

Aggregator of strategies to transpile JS code. It provides unified programmatic and CL interfaces to transpile/optimize/minimize/beautify code by one or several transpilers in series. More strategies could be added as plugins. Default options of transpilation can be written into a config file to avoid retyping. Use the module to utilize the power of open source transpilation tools in single package.

## Supports such tranpilation strategies

- Uglify
- Babel
- Prepack
- Closure

## Try out
```
npm install
node sample/Sample.s
```

## Try out
```
npm -g install wtranspilationstrategy
ts .
ts .config.define debug:0 minification:0 optimization:9
ts .config.read
```

## Try out
```
npm -g install wtranspilationstrategy
ts .config.define debug:0 minification:7 optimization:9
ts .config.define strategies:[ Babel, Uglify, Babel ]
ts .transpile inputPath:sample/Sample.js outputPath:temp.tmp/Sample.js
ts .config.define verbosity:3
ts .transpile inputPath:sample/Sample2.js outputPath:temp.tmp/Sample2.js debug:1
```





















