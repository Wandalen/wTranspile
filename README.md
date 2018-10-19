
# wTranspilationStrategy [![Build Status](https://travis-ci.org/Wandalen/wTranspilationStrategy.svg?branch=master)](https://travis-ci.org/Wandalen/wTranspilationStrategy)

Aggregator of strategies to transpile JS code. It provides unified programmatic and CL interfaces to transpile/optimize/minimize code by one or several transpilers in series. Default options of transpilation can be written into a config file to avoid retyping. Use the module to utilize the power of open source transpilation tools.

## Try out
```
npm install
node sample/Sample.s
```

## Try out
```
npm -g install wtranspilationstrategy
tc .config.define debug:0 minification:0 optimization:9
tc .config.read
tc .transpile inPath:sample/Sample.js outPath:temp.tmp/Sample.js
tc .transpile inPath:sample/Sample2.js outPath:temp.tmp/Sample2.js
```
