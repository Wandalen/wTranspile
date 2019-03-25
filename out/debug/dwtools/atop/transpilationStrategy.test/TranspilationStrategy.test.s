( function _TranspilationStrategy_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../transpilationStrategy/MainBase.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.tempDir = _.path.dirTempOpen( _.path.join( __dirname, '../..'  ), 'TransiplationStrategy' );

  self.find1 = _.fileProvider.filesFinder
  ({
    recursive : 2,
    includingTerminals : 1,
    includingDirs : 1,
    includingTransient : 1,
    allowingMissed : 1,
    outputFormat : 'relative',
  });

}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, '/tmp.tmp' ) )
  _.fileProvider.filesDelete( self.tempDir );
}

//

function find2( fileProvider, filePath )
{
  let self = this;
  return fileProvider.filesFindRecursive
  ({
    filePath : filePath,
    outputFormat : 'relative',
    recursive : 2,
  })
}

// --
// tests
// --

function singleFileInputTerminal( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );

  test.description = 'single input terminal';

  let outputPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.TranspilationStrategy().form();
  let multiple = ts.multiple
  ({
    inputPath : __filename,
    outputPath : outputPath,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    test.is( _.fileProvider.fileExists( outputPath ) );
    let expected = [ '.', './Output.js' ];
    test.is( _.fileProvider.fileSize( outputPath ) > 100 );
    let found = self.find1( routinePath );
    test.identical( found, expected );
    if( err )
    throw _.errLogOnce( err );
    return true;
  });

}

//

function singleFileInputDir( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );

  test.description = 'single input dir';

  let outputPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.TranspilationStrategy().form();
  let multiple = ts.multiple
  ({
    inputPath : __dirname,
    outputPath : outputPath,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    test.is( _.fileProvider.fileExists( outputPath ) );
    test.is( _.fileProvider.fileSize( outputPath ) > 100 );
    let expected = [ '.', './Output.js' ];
    let found = self.find1( routinePath );
    test.identical( found, expected );
    if( err )
    throw _.errLogOnce( err );
    return true;
  });

}

//

function singleDst( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let originalDirPath = _.path.join( __dirname, '../transpilationStrategy' );

  test.case = 'single destination';

  let outputPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.TranspilationStrategy().form();
  let multiple = ts.multiple
  ({
    inputPath : originalDirPath,
    outputPath : outputPath,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    test.is( _.fileProvider.fileExists( outputPath ) );
    test.is( _.fileProvider.fileSize( outputPath ) > 5000 );
    let expected = [ '.', './Output.js' ];
    let found = self.find1( routinePath );
    test.identical( found, expected );
    if( err )
    throw _.errLogOnce( err );
    return true;
  });

}

//

function severalDst( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );

  test.case = 'trivial';

  var filesTree =
  {
    'File1.js' : `console.log( 'File1.js' );`,
    'File2.js' : `console.log( 'File2.js' );`,
    'File1.s' : `console.log( 'File1.s' );`,
    'File2.s' : `console.log( 'File2.s' );`,
  }
  var fileProvider = _.FileProvider.Extract({ filesTree : filesTree });

  var inputPath = { filePath : { '**.js' : 'All.js', '**.s' : 'All.s' } }
  var ts = new _.TranspilationStrategy({ fileProvider : fileProvider }).form();
  var multiple = ts.multiple
  ({
    inputPath : inputPath,
    outputPath : null,
    diagnosing : 1,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    var expected = [ '.', './All.js', './All.s', './File1.js', './File1.s', './File2.js', './File2.s' ];
    var found = self.find2( fileProvider, '/' );
    test.identical( found, expected );
    test.is( _.strHas( fileProvider.fileRead( '/All.js' ), 'File1.js' ) );
    test.is( _.strHas( fileProvider.fileRead( '/All.js' ), 'File2.js' ) );
    test.is( _.strHas( fileProvider.fileRead( '/All.s' ), 'File1.s' ) );
    test.is( _.strHas( fileProvider.fileRead( '/All.s' ), 'File2.s' ) );
    if( err )
    throw _.errLogOnce( err );
    return true;
  });

}

//

function complexMask( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );

  test.case = 'trivial';

  var filesTree =
  {
    'File1.js' : `console.log( 'File1.js' );`,
    'File2.js' : `console.log( 'File2.js' );`,
    'File1.s' : `console.log( 'File1.s' );`,
    'File2.s' : `console.log( 'File2.s' );`,
  }
  var fileProvider = _.FileProvider.Extract({ filesTree : filesTree });

  var inputPath = { filePath : { '**.js' : 'All.js', '**.s' : 'All.s' } }
  var ts = new _.TranspilationStrategy({ fileProvider : fileProvider }).form();
  var multiple = ts.multiple
  ({
    inputPath : inputPath,
    outputPath : { prefixPath : '/dst' },
    splittingStrategy : 'ManyToOne',
    diagnosing : 1,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    var expected = [ '.', './File1.js', './File1.s', './File2.js', './File2.s', './dst', './dst/All.js', './dst/All.s' ];
    var found = self.find2( fileProvider, '/' );
    test.identical( found, expected );
    test.is( _.strHas( fileProvider.fileRead( '/dst/All.js' ), 'File1.js' ) );
    test.is( _.strHas( fileProvider.fileRead( '/dst/All.js' ), 'File2.js' ) );
    test.is( _.strHas( fileProvider.fileRead( '/dst/All.s' ), 'File1.s' ) );
    test.is( _.strHas( fileProvider.fileRead( '/dst/All.s' ), 'File2.s' ) );
    if( err )
    throw _.errLogOnce( err );
    return true;
  });

}

//

function oneToOne( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );

  test.case = 'trivial';

  var filesTree =
  {
    'File1.js' : `console.log( './File1.js' );`,
    'File2.js' : `console.log( './File2.js' );`,
    'File1.s' : `console.log( './File1.s' );`,
    'File2.s' : `console.log( './File2.s' );`,

    dir :
    {
      'File1.js' : `console.log( './dir/File1.js' );`,
      'File2.js' : `console.log( './dir/File2.js' );`,
      'File1.s' : `console.log( './dir/File1.s' );`,
      'File2.s' : `console.log( './dir/File2.s' );`,
    }

  }
  var fileProvider = _.FileProvider.Extract({ filesTree : filesTree });

  var inputPath = { filePath : { '/' : null, '**.js' : true } }
  var ts = new _.TranspilationStrategy({ fileProvider : fileProvider }).form();
  var multiple = ts.multiple
  ({
    inputPath : inputPath,
    outputPath : { prefixPath : '/dst' },
    splittingStrategy : 'OneToOne',
    transpilingStrategies : [ 'Nop' ],
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {

    var expected = [ '.', './File1.js', './File1.s', './File2.js', './File2.s', './dir', './dir/File1.js', './dir/File1.s', './dir/File2.js', './dir/File2.s', './dst', './dst/File1.js', './dst/File2.js', './dst/dir', './dst/dir/File1.js', './dst/dir/File2.js' ];
    var found = self.find2( fileProvider, '/' );
    test.identical( found, expected );

    var src = fileProvider.fileRead( '/File1.js' );
    var dst = fileProvider.fileRead( '/dst/File1.js' );
    test.is( _.strHas( dst, src ) );

    var src = fileProvider.fileRead( '/dir/File2.js' );
    var dst = fileProvider.fileRead( '/dst/dir/File2.js' );
    test.is( _.strHas( dst, src ) );

    if( err )
    throw _.errLogOnce( err );
    return true;

  });

}

//

function shell( test )
{
  let self = this;
  let originalDirPath = _.path.join( __dirname, '../transpilationStrategy' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let outPath = _.path.join( routinePath, 'out.js' );
  let execRelativePath = '../transpilationStrategy/Exec';
  let srcPath = _.path.normalize( __dirname );
  let execPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), execRelativePath ) );
  let ready = new _.Consequence().take( null );
  let shell = _.sheller
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
  });

  /* - */

  ready
  .thenKeep( ( got ) =>
  {
    test.case = '.transpile';

    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.dirMake( routinePath );
    // _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } });

    return null;
  })

  shell({ args : [ '.transpile inputPath:' + srcPath + ' outputPath:' + outPath + ' writingTempFiles:0' ] })
  .thenKeep( ( got ) =>
  {

    var files = self.find1( routinePath );
    test.identical( files, [ '.', './out.js' ] );
    test.identical( got.exitCode, 0 );
    test.is( _.fileProvider.isTerminal( outPath ) );

    return null;
  })
  .thenKeep( ( got ) =>
  {
    _.fileProvider.filesDelete( routinePath );
    return null;
  })

  return ready;
}

// --
// define
// --

var Self =
{

  name : 'Tools/top/TranspilationStrategy',
  silencing : 1,
  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  context :
  {
    tempDir : null,
    find1 : null,
    find2 : find2,
  },

  tests :
  {

    singleFileInputTerminal,
    singleFileInputDir,
    singleDst,
    severalDst,
    complexMask,
    oneToOne,
    shell,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
