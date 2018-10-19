
# wTranspilationStrategy [![Build Status](https://travis-ci.org/Wandalen/wTranspilationStrategy.svg?branch=master)](https://travis-ci.org/Wandalen/wTranspilationStrategy)

___

## Try out
```
npm install
node sample/Sample.s
```

## Try out
```
npm -g install
tc .config.define debug:0 minification:0 optimization:9
tc .config.read
tc .transpile inPath:sample/Sample.js outPath:temp.tmp/Sample.js
tc .transpile inPath:sample/Sample2.js outPath:temp.tmp/Sample2.js
```
