( function _TranspilationStrategy_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wTesting' );

  require( '../transpile/entry/Include.s' );

}

let _global = _global_;
let _ = _global_.wTools;

/* qqq : normalize. use assetFor here please */

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'TransiplationStrategy' );
  self.assetsOriginalPath = _.path.join( __dirname, '_asset' );

  self.find = _.fileProvider.filesFinder
  ({
    withTerminals : 1,
    withDirs : 1,
    withTransient : 1,
    allowingMissed : 1,
    outputFormat : 'relative',
  });

  self.findIn = function findIn( fileProvider, filePath )
  {
    let self = this;
    return fileProvider.filesFindRecursive
    ({
      filePath,
      outputFormat : 'relative',
    })
  }

}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, '/TransiplationStrategy' ) )
  _.fileProvider.filesDelete( self.suiteTempPath );
}


// --
// tests
// --

function singleFileInputTerminal( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let con = new _.Consequence().take( null );

  /* - */

  con.then( () =>
  {

    test.description = 'single input terminal';

    let outPath = _.path.join( routinePath, 'Output.js' );
    let ts = new _.trs.System().form();
    let multiple = ts.multiple
    ({
      inPath : __filename,
      outPath,
    });

    return multiple.form().perform()
    .finally( ( err, got ) =>
    {
      if( err )
      throw _.err( err );

      test.true( _.fileProvider.fileExists( outPath ) );
      let expected = [ '.', './Output.js' ];
      test.true( _.fileProvider.fileSize( outPath ) > 100 );
      let found = self.find( routinePath );
      test.identical( found, expected );

      test.identical( multiple.dstCounter, 1 );
      test.identical( multiple.srcCounter, 1 );

      return true;
    });

  })

  /* - */

  con.then( () =>
  {

    test.description = 'repeat, should do nothing';

    let outPath = _.path.join( routinePath, 'Output.js' );
    let ts = new _.trs.System().form();
    let multiple = ts.multiple
    ({
      inPath : __filename,
      outPath,
    });

    return multiple.form().perform()
    .finally( ( err, got ) =>
    {
      if( err )
      throw _.err( err );

      test.true( _.fileProvider.fileExists( outPath ) );
      let expected = [ '.', './Output.js' ];
      test.true( _.fileProvider.fileSize( outPath ) > 100 );
      let found = self.find( routinePath );
      test.identical( found, expected );

      test.identical( multiple.dstCounter, 0 );
      test.identical( multiple.srcCounter, 0 );

      return true;
    });

  })

  /* - */

  return con;
}

//

function singleFileInputDir( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  /* - */

  test.case = 'single input dir with glob';

  let outPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.trs.System().form();
  let multiple = ts.multiple
  ({
    inPath : __dirname + '/**',
    outPath,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err );

    test.true( _.fileProvider.fileExists( outPath ) );
    test.true( _.fileProvider.fileSize( outPath ) > 100 );
    let expected = [ '.', './Output.js' ];
    let found = self.find( routinePath );
    test.identical( found, expected );
    return true;
  });

}

//

function singleFileInputDirThrowing( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  /* - */

  test.case = 'single input dir without glob';

  let outPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.trs.System().form();
  let multiple = ts.multiple
  ({
    inPath : __dirname + '',
    outPath,
  });

  return test.shouldThrowErrorAsync( multiple.form().perform() );

  /* - */

}

//

function singleDst( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let originalAssetPath = _.path.join( __dirname, '../transpile' );

  test.case = 'single destination';

  let outPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.trs.System().form();
  let multiple = ts.multiple
  ({
    inPath :
    {
      filePath :
      {
        [ originalAssetPath + '/**/*.(s|js)' ] : '',
      }
    },
    outPath,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err );

    test.true( _.fileProvider.fileExists( outPath ) );
    test.true( _.fileProvider.fileSize( outPath ) > 5000 );
    let expected = [ '.', './Output.js' ];
    let found = self.find( routinePath );
    test.identical( found, expected );

    return true;
  });

}

//

function severalDst( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  test.case = 'trivial';

  var filesTree =
  {
    'File1.js' : `console.log( 'File1.js' );`,
    'File2.js' : `console.log( 'File2.js' );`,
    'File1.s' : `console.log( 'File1.s' );`,
    'File2.s' : `console.log( 'File2.s' );`,
  }

  var fileProvider = _.FileProvider.Extract({ filesTree });
  var inPath = { filePath : { '**.js' : 'All.js', '**.s' : 'All.s' } }
  var ts = new _.trs.System({ fileProvider }).form();
  var multiple = ts.multiple
  ({
    inPath,
    outPath : null,
    diagnosing : 1,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err );

    var expected = [ '.', './All.js', './All.s', './File1.js', './File1.s', './File2.js', './File2.s' ];
    var found = self.findIn( fileProvider, '/' );
    test.identical( found, expected );
    test.true( _.strHas( fileProvider.fileRead( '/All.js' ), 'File1.js' ) );
    test.true( _.strHas( fileProvider.fileRead( '/All.js' ), 'File2.js' ) );
    test.true( _.strHas( fileProvider.fileRead( '/All.s' ), 'File1.s' ) );
    test.true( _.strHas( fileProvider.fileRead( '/All.s' ), 'File2.s' ) );

    return true;
  });

}

//

function complexMask( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  test.case = 'trivial';

  var filesTree =
  {
    'File1.js' : `console.log( 'File1.js' );`,
    'File2.js' : `console.log( 'File2.js' );`,
    'File1.s' : `console.log( 'File1.s' );`,
    'File2.s' : `console.log( 'File2.s' );`,
  }
  var fileProvider = _.FileProvider.Extract({ filesTree });

  var inPath = { filePath : { '**.js' : 'All.js', '**.s' : 'All.s' } }
  var ts = new _.trs.System({ fileProvider }).form();
  var multiple = ts.multiple
  ({
    inPath,
    outPath : { prefixPath : '/dst' },
    splittingStrategy : 'ManyToOne',
    diagnosing : 1,
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err );

    var expected = [ '.', './File1.js', './File1.s', './File2.js', './File2.s', './dst', './dst/All.js', './dst/All.s' ];
    var found = self.findIn( fileProvider, '/' );
    test.identical( found, expected );
    test.true( _.strHas( fileProvider.fileRead( '/dst/All.js' ), 'File1.js' ) );
    test.true( _.strHas( fileProvider.fileRead( '/dst/All.js' ), 'File2.js' ) );
    test.true( _.strHas( fileProvider.fileRead( '/dst/All.s' ), 'File1.s' ) );
    test.true( _.strHas( fileProvider.fileRead( '/dst/All.s' ), 'File2.s' ) );

    return true;
  });

}

//

function oneToOne( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  test.case = 'trivial';

  var filesTree =
  {
    'File1.js' : `console.log( './File1.js' );`,
    'File2.js' : `console.log( './File2.js' );`,
    'File1.s' : `console.log( './File1.s' );`,
    'File2.s' : `console.log( './File2.s' );`,

    'dir' :
    {
      'File1.js' : `console.log( './dir/File1.js' );`,
      'File2.js' : `console.log( './dir/File2.js' );`,
      'File1.s' : `console.log( './dir/File1.s' );`,
      'File2.s' : `console.log( './dir/File2.s' );`,
    }

  }

  var fileProvider = _.FileProvider.Extract({ filesTree });

  var inPath = { filePath : { '/' : null, '**.js' : true } }
  var ts = new _.trs.System({ fileProvider }).form();
  var multiple = ts.multiple
  ({
    inPath,
    outPath : { prefixPath : '/dst' },
    splittingStrategy : 'OneToOne',
    transpilingStrategy : [ 'Nop' ],
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {

    if( err )
    throw _.err( err );

    var expected = [ '.', './File1.js', './File1.s', './File2.js', './File2.s', './dir', './dir/File1.js', './dir/File1.s', './dir/File2.js', './dir/File2.s', './dst', './dst/File1.js', './dst/File2.js', './dst/dir', './dst/dir/File1.js', './dst/dir/File2.js' ];
    var found = self.findIn( fileProvider, '/' );
    test.identical( found, expected );

    var src = fileProvider.fileRead( '/File1.js' );
    var dst = fileProvider.fileRead( '/dst/File1.js' );
    test.true( _.strHas( dst, src ) );

    var src = fileProvider.fileRead( '/dir/File2.js' );
    var dst = fileProvider.fileRead( '/dst/dir/File2.js' );
    test.true( _.strHas( dst, src ) );

    return true;

  });

}

//

function nothingFoundOneToOne( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  /* */

  test.case = 'OneToOne';

  var filesTree =
  {
    'File1.js' : `console.log( './File1.js' );`,
    'File2.js' : `console.log( './File2.js' );`,
    'File1.s' : `console.log( './File1.s' );`,
    'File2.s' : `console.log( './File2.s' );`,
    'dir' :
    {
      'File1.js' : `console.log( './dir/File1.js' );`,
      'File2.js' : `console.log( './dir/File2.js' );`,
      'File1.s' : `console.log( './dir/File1.s' );`,
      'File2.s' : `console.log( './dir/File2.s' );`,
    }
  }
  var fileProvider = _.FileProvider.Extract({ filesTree });

  var inPath = { filePath : { '**.test*' : true, '/' : '/dst' } }
  var outPath = { filePath : { '**.test*' : true, '/' : '/dst' } }
  var ts = new _.trs.System({ fileProvider }).form();
  var multiple = ts.multiple
  ({
    inPath,
    outPath,
    splittingStrategy : 'OneToOne',
    transpilingStrategy : [ 'Nop' ],
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    test.true( !!err );
    var expected = [ '.', './File1.js', './File1.s', './File2.js', './File2.s', './dir', './dir/File1.js', './dir/File1.s', './dir/File2.js', './dir/File2.s' ];
    var found = self.findIn( fileProvider, '/' );
    test.identical( found, expected );
    if( err )
    _.errLogOnce( err );
    return null;
  });

}

//

function nothingFoundManyToOne( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );

  /* */

  test.case = 'ManyToOne';

  var filesTree =
  {
    'File1.js' : `console.log( './File1.js' );`,
    'File2.js' : `console.log( './File2.js' );`,
    'File1.s' : `console.log( './File1.s' );`,
    'File2.s' : `console.log( './File2.s' );`,
    'dir' :
    {
      'File1.js' : `console.log( './dir/File1.js' );`,
      'File2.js' : `console.log( './dir/File2.js' );`,
      'File1.s' : `console.log( './dir/File1.s' );`,
      'File2.s' : `console.log( './dir/File2.s' );`,
    }
  }
  var fileProvider = _.FileProvider.Extract({ filesTree });

  var inPath = { filePath : { '**.test*' : true, '/' : '/dst' } }
  var outPath = { filePath : { '**.test*' : true, '/' : '/dst' } }
  var ts = new _.trs.System({ fileProvider }).form();
  var multiple = ts.multiple
  ({
    inPath,
    outPath,
    splittingStrategy : 'ManyToOne',
    transpilingStrategy : [ 'Nop' ],
  });

  return multiple.form().perform()
  .finally( ( err, got ) =>
  {
    test.true( !!err );
    var expected = [ '.', './File1.js', './File1.s', './File2.js', './File2.s', './dir', './dir/File1.js', './dir/File1.s', './dir/File2.js', './dir/File2.s' ];
    var found = self.findIn( fileProvider, '/' );
    test.identical( found, expected );
    test.true( !fileProvider.fileExists( '/dst' ) );
    // test.true( fileProvider.fileRead( '/dst' ) === '' );
    if( err )
    _.errLogOnce( err );
    return null;
  });

  /* */

}

//

function transpileManyToOne( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let con = new _.Consequence().take( null );

  /* */

  con.then( () =>
  {

    test.case = 'ManyToOne';

    var filesTree =
    {
      src :
      {
        dir1 : {},
        dir2 :
        {
          '-Excluded.js' : `console.log( 'dir2/-Ecluded.js' );`,
          'File.js' : `console.log( 'dir2/File.js' );`,
          'File.test.js' : `console.log( 'dir2/File.test.js' );`,
          'File1.debug.js' : `console.log( 'dir2/File1.debug.js' );`,
          'File1.release.js' : `console.log( 'dir2/File1.release.js' );`,
          'File2.debug.js' : `console.log( 'dir2/File2.debug.js' );`,
          'File2.release.js' : `console.log( 'dir2/File2.release.js' );`,
        },
        dir3 :
        {
          'File.js' : `console.log( 'dir3/File.js' );`,
          'File.test.js' : `console.log( 'dir3/File.test.js' );`,
        },
      }
    }
    var fileProvider = _.FileProvider.Extract({ filesTree });

    var inPath =
    {
      filePath : { '**.test*' : false, '**.test/**' : false, '.' : '.' },
      prefixPath : '/src',
      maskAll : { excludeAny : [ /(^|\/)-/, /\.release($|\.|\/)/i ] }
    }
    var outPath =
    {
      filePath : { '**.test*' : false, '**.test/**' : false, '.' : '.' },
      prefixPath : '/dst/Main.s',
    }
    var ts = new _.trs.System({ fileProvider }).form();
    var multiple = ts.multiple
    ({
      inPath,
      outPath,
      totalReporting : 0,
      transpilingStrategy : [ 'Nop' ],
      splittingStrategy : 'ManyToOne',
      writingTerminalUnderDirectory : 1,
      upToDate : 'preserve',
      verbosity : 2,
      optimization : 9,
      minification : 8,
      diagnosing : 1,
      beautifing : 0,
    });

    return multiple.form().perform()
    .finally( ( err, got ) =>
    {
      if( err )
      throw _.err( err );

      var expected = [ '.', './dst', './dst/Main.s', './src', './src/dir1', './src/dir2', './src/dir2/File.js', './src/dir2/File.test.js', './src/dir2/File1.debug.js', './src/dir2/File1.release.js', './src/dir2/File2.debug.js', './src/dir2/File2.release.js', './src/dir3', './src/dir3/File.js', './src/dir3/File.test.js' ];
      var found = self.findIn( fileProvider, '/' );
      test.identical( found, expected );

      var read = fileProvider.fileRead( '/dst/Main.s' );
      test.true( !_.strHas( read, 'dir2/-Ecluded.js' ) );
      test.true( _.strHas( read, 'dir2/File.js' ) );
      test.true( !_.strHas( read, 'dir2/File.test.js' ) );
      test.true( _.strHas( read, 'dir2/File1.debug.js' ) );
      test.true( !_.strHas( read, 'dir2/File1.release.js' ) );
      test.true( _.strHas( read, 'dir2/File2.debug.js' ) );
      test.true( !_.strHas( read, 'dir2/File2.release.js' ) );

      return true;
    });

  })

  /* */

  con.then( () =>
  {

    test.case = 'ManyToOne';

    var filesTree =
    {
      src :
      {
        dir1 : {},
        dir2 :
        {
          '-Excluded.js' : `console.log( 'dir2/-Ecluded.js' );`,
          'File.js' : `console.log( 'dir2/File.js' );`,
          'File.test.js' : `console.log( 'dir2/File.test.js' );`,
          'File1.debug.js' : `console.log( 'dir2/File1.debug.js' );`,
          'File1.release.js' : `console.log( 'dir2/File1.release.js' );`,
          'File2.debug.js' : `console.log( 'dir2/File2.debug.js' );`,
          'File2.release.js' : `console.log( 'dir2/File2.release.js' );`,
        },
        dir3 :
        {
          'File.js' : `console.log( 'dir3/File.js' );`,
          'File.test.js' : `console.log( 'dir3/File.test.js' );`,
        },
      }
    }
    var fileProvider = _.FileProvider.Extract({ filesTree });

    var inPath =
    {
      filePath : { '**.test*' : true, '.' : '.' },
      prefixPath : '/src',
      maskAll : { excludeAny : [ /(^|\/)-/, /\.release($|\.|\/)/i ] },
    }
    var outPath =
    {
      filePath : { '**.test*' : true, '.' : '.' },
      prefixPath : '/dst/Tests.s',
    }
    var ts = new _.trs.System({ fileProvider }).form();
    var multiple = ts.multiple
    ({
      inPath,
      outPath,
      totalReporting : 0,
      transpilingStrategy : [ 'Nop' ],
      splittingStrategy : 'ManyToOne',
      writingTerminalUnderDirectory : 1,
      upToDate : 'preserve',
      verbosity : 2,
      optimization : 9,
      minification : 8,
      diagnosing : 1,
      beautifing : 0,
    });

    return multiple.form().perform()
    .finally( ( err, got ) =>
    {
      if( err )
      throw _.err( err );

      var expected = [ '.', './dst', './dst/Tests.s', './src', './src/dir1', './src/dir2', './src/dir2/File.js', './src/dir2/File.test.js', './src/dir2/File1.debug.js', './src/dir2/File1.release.js', './src/dir2/File2.debug.js', './src/dir2/File2.release.js', './src/dir3', './src/dir3/File.js', './src/dir3/File.test.js' ];
      var found = self.findIn( fileProvider, '/' );
      test.identical( found, expected );

      var read = fileProvider.fileRead( '/dst/Tests.s' );
      test.true( !_.strHas( read, 'dir2/-Ecluded.js' ) );
      test.true( !_.strHas( read, 'dir2/File.js' ) );
      test.true( _.strHas( read, 'dir2/File.test.js' ) );
      test.true( !_.strHas( read, 'dir2/File1.debug.js' ) );
      test.true( !_.strHas( read, 'dir2/File1.release.js' ) );
      test.true( !_.strHas( read, 'dir2/File2.debug.js' ) );
      test.true( !_.strHas( read, 'dir2/File2.release.js' ) );

      return true;
    });

  })

  /* */

  return con;
}

//

function shell( test )
{
  let self = this;
  let originalAssetPath = _.path.join( __dirname, '../transpile' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let inPath = _.path.normalize( __dirname ) + '/**';
  let outPath = _.path.join( routinePath, 'out.js' );
  let execRelativePath = '../transpile/entry/Exec';
  let execPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), execRelativePath ) );
  let ready = new _.Consequence().take( null );
  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    ready,
  });

  /* - */

  ready
  .then( ( got ) =>
  {
    test.case = '.transpile';

    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.dirMake( routinePath );
    // _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });

    return null;
  })

  shell({ args : [ '.transpile inPath:' + inPath + ' outPath:' + outPath + ' writingTempFiles:0' ] })
  .then( ( got ) =>
  {

    var files = self.find( routinePath );
    test.identical( files, [ '.', './out.js' ] );
    test.identical( got.exitCode, 0 );
    test.true( _.fileProvider.isTerminal( outPath ) );

    return null;
  })
  .then( ( got ) =>
  {
    _.fileProvider.filesDelete( routinePath );
    return null;
  })

  return ready;
}

//

function combinedShell( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalPath, 'combined' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let execRelativePath = '../transpile/entry/Exec';
  let execPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), execRelativePath ) );
  let inPath = 'main/**';
  let outPath = 'out/Main.s';
  let entryPath = 'main/File1.s';
  let outMainPath = _.path.join( routinePath, './out/Main.s' );
  let externalBeforePath = 'External.s';
  let ready = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    ready,
  });

  let shell2 = _.process.starter
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    ready,
  });

  /* - */

  ready
  .then( ( got ) =>
  {
    test.case = '.transpile';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.dirMake( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });
    return null;
  })

  var command =
  `.transpile inPath:${inPath} outPath:${outPath} entryPath:${entryPath} externalBeforePath:${externalBeforePath} `
  + `splittingStrategy:ManyToOne transpilingStrategy:Nop`;
  shell({ args : command })
  /* node ../../../transpile/entry/Exec .transpile inPath:main/** outPath:out/Main.s entryPath:main/File1.s externalBeforePath:External.s splittingStrategy:ManyToOne transpilingStrategy:Nop */

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /# Transpiled 2 file\(s\) to .*out\/Main\.s.* in/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './External.s', './main', './main/File1.s', './main/File2.s', './out', './out/Main.s' ] );

    var read = _.fileProvider.fileRead( outMainPath );
    test.identical( _.strCount( read, `console.log( 'main/File1.s' );` ), 1 );
    test.identical( _.strCount( read, `console.log( 'external', external );` ), 1 );
    test.identical( _.strCount( read, `console.log( 'main/File2.s' );` ), 1 );
    test.identical( _.strCount( read, `_starter_._sourceInclude( null, _libraryDirPath_, '../External.s' );` ), 1 );
    test.identical
    (
      _.strCount( read, `module.exports = _starter_._sourceInclude( null, _libraryFilePath_, './main/File1.s' );` ),
      1
    ); /* qqq : update data, please */
    test.identical( _.strCount( read, `_starter_._sourceInclude(` ), 2 );
    test.identical( _.strCount( read, `module.exports = _starter_._sourceInclude` ), 1 );

    return null;
  })

  shell2({ execPath : 'node ' + _.path.nativize( outMainPath ) })

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `External.s` ), 1 );
    test.identical( _.strCount( got.output, `main/File1.s` ), 1 );
    test.identical( _.strCount( got.output, `external 13` ), 1 );

    return null;
  })

  /* - */

  ready
  .then( ( got ) =>
  {
    test.case = 'repeat';
    return null;
  })

  /*
    qqq xxx : why does it thow error???
    aaa : because test removes routinePath directory few lines above, routinePath is used in shell as currentPath
  */
  var command =
  `.transpile inPath:${inPath} outPath:${outPath} entryPath:${entryPath} externalBeforePath:${externalBeforePath} `
  + `splittingStrategy:ManyToOne transpilingStrategy:Nop`;
  shell({ args : command })
  /* node ../../../transpile/entry/Exec .transpile inPath:main/** outPath:out/Main.s entryPath:main/File1.s externalBeforePath:External.s splittingStrategy:ManyToOne transpilingStrategy:Nop */

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /# Transpiled/ ), 0 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './External.s', './main', './main/File1.s', './main/File2.s', './out', './out/Main.s' ] );

    var read = _.fileProvider.fileRead( outMainPath );
    test.identical( _.strCount( read, `console.log( 'main/File1.s' );` ), 1 );
    test.identical( _.strCount( read, `console.log( 'external', external );` ), 1 );
    test.identical( _.strCount( read, `console.log( 'main/File2.s' );` ), 1 );
    test.identical( _.strCount( read, `_starter_._sourceInclude( null, _libraryDirPath_, '../External.s' );` ), 1 );
    test.identical
    (
      _.strCount( read, `module.exports = _starter_._sourceInclude( null, _libraryFilePath_, './main/File1.s' );` ),
      1
    );
    test.identical( _.strCount( read, `_starter_._sourceInclude(` ), 2 );
    test.identical( _.strCount( read, `module.exports = _starter_._sourceInclude` ), 1 );

    return null;
  })

  shell2({ execPath : 'node ' + _.path.nativize( outMainPath ) })

  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `External.s` ), 1 );
    test.identical( _.strCount( got.output, `main/File1.s` ), 1 );
    test.identical( _.strCount( got.output, `external 13` ), 1 );

    return null;
  })

  .then( ( got ) =>
  {
    _.fileProvider.filesDelete( routinePath );
    return null;
  })

  /* - */

  // ready
  // .then( ( got ) =>
  // {
  //   test.case = 'throwing';
  //   _.fileProvider.filesDelete( routinePath );
  //   _.fileProvider.dirMake( routinePath );
  //   _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });
  //   return null;
  // })
  //
  // shell({ currentPath : routinePath + '/..', args : `.transpile inPath:${inPath} outPath:${outPath} entryPath:${entryPath} externalBeforePath:${externalBeforePath} splittingStrategy:ManyToOne transpilingStrategy:Nop` })
  // /* node ../../transpile/entry/Exec .transpile inPath:main/** outPath:out/Main.s entryPath:main/File1.s externalBeforePath:External.s splittingStrategy:ManyToOne transpilingStrategy:Nop */
  //
  // .then( ( got ) =>
  // {
  //   test.notIdentical( got.exitCode, 0 );
  //
  //   test.identical( _.strCount( got.output, /Nothing found. Stem file .*main.* does not exist!/ ), 1 );
  //
  //   var files = self.find( routinePath );
  //   test.identical( files, [ '.', './External.s', './main', './main/File1.s', './main/File2.s' ] );
  //
  //   return null;
  // })
  // .then( ( got ) =>
  // {
  //   _.fileProvider.filesDelete( routinePath );
  //   return null;
  // })

  /* - */

  return ready;
}

combinedShell.timeOut = 150000;

//

function combinedProgramatic( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalPath, 'combined' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let execRelativePath = '../transpile/entry/Exec';
  let execPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), execRelativePath ) );
  let inPath = _.path.join( routinePath, 'main/**' );
  let outPath = _.path.join( routinePath, 'out/Main.s' );
  let entryPath = 'main/File1.s';
  let externalBeforePath = 'External.s';
  let ready = new _.Consequence().take( null );
  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    ready,
  });

  /* - */

  ready
  .then( ( got ) =>
  {
    test.case = '.transpile';

    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.dirMake( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });

    let ts = new _.trs.System({}).form();
    let multiple = ts.multiple
    ({

      inPath,
      outPath,
      entryPath,
      externalBeforePath,
      totalReporting : 0,
      transpilingStrategy : [ 'Nop' ],
      splittingStrategy : 'ManyToOne',
      writingTerminalUnderDirectory : 1,
      simpleConcatenator : 0,
      upToDate : 'preserve',
      verbosity : 2,

      optimization : 9,
      minification : 8,
      diagnosing : 1,
      beautifing : 0,

    });

    return multiple.form().perform()
    .finally( ( err, arg ) =>
    {
      if( err )
      throw _.err( err );
      return arg;
    });

  })

  .then( ( got ) =>
  {

    var files = self.find( routinePath );
    test.identical( files, [ '.', './External.s', './main', './main/File1.s', './main/File2.s', './out', './out/Main.s' ] );

    return null;
  })
  .then( ( got ) =>
  {
    _.fileProvider.filesDelete( routinePath );
    return null;
  })

  /* - */

  return ready;
}

combinedProgramatic.timeOut = 150000;

//

function beautifing( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let con = _.Consequence().take( null )

  /* - */

  con.then( () =>
  {
    test.case = 'Uglify,beautifing off'
    let outPath = _.path.join( routinePath, 'Output.js' );
    let ts = new _.trs.System().form();
    let multiple = ts.multiple
    ({
      inPath : __filename,
      outPath,
      transpilingStrategy : [ 'Uglify' ],
      beautifing : 0,
    });

    _.fileProvider.filesDelete( outPath );

    return multiple.form().perform()
    .then( () =>
    {
      let read = _.fileProvider.fileRead( outPath );
      let lines = _.strLinesCount( read );
      test.identical( lines, 2 );
      return null;
    })
  })

  /* - */

  con.then( () =>
  {
    test.case = 'Uglify,beautifing on'
    let outPath = _.path.join( routinePath, 'Output.js' );
    let ts = new _.trs.System().form();
    let multiple = ts.multiple
    ({
      inPath : __filename,
      outPath,
      transpilingStrategy : [ 'Uglify' ],
      beautifing : 1,
    });

    _.fileProvider.filesDelete( outPath );

    return multiple.form().perform()
    .then( () =>
    {
      let read = _.fileProvider.fileRead( outPath );
      let lines = _.strLinesCount( read );
      test.gt( lines, 100 );
      return null;
    })
  })

  /* - */

  con.then( () =>
  {
    test.case = 'Uglify, drop debugger'
    let outPath = _.path.join( routinePath, 'Output.js' );
    let ts = new _.trs.System().form();
    let multiple = ts.multiple
    ({
      inPath : __filename,
      outPath,
      transpilingStrategy : [ 'Uglify' ],
      minification : 9,
      diagnosing : 0,
      beautifing : 0,
    });

    _.fileProvider.filesDelete( outPath );

    return multiple.form().perform()
    .then( () =>
    {
      let read = _.fileProvider.fileRead( outPath );
      test.true( _.strHas( read, 'debugger' ) );
      return null;
    })
  })

  return con;
}

//

function severalStrategies( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let con = _.Consequence().take( null )

  /* - */

  con.then( () =>
  {
    test.case = 'each strategy has own stage and settings'
    let ready = _.Consequence();
    let outPath = _.path.join( routinePath, 'Output.js' );
    let ts = new _.trs.System().form();
    let multiple = ts.multiple
    ({
      inPath : __filename,
      outPath,
      transpilingStrategy : [ 'Babel', 'Uglify' ],
      onEnd : ( multiple, output ) => ready.take( output )
    });

    multiple.form();
    multiple.perform();

    ready.then( ( single ) =>
    {
      let stage2 = single.output;
      let stage1 = stage2.input;
      test.identical( stage2.index, 2 );
      test.identical( stage1.index, 1 );
      test.true( stage2.strategy instanceof _.trs.transpiler.Uglify );
      test.true( stage1.strategy instanceof _.trs.transpiler.Babel );
      test.true( _.mapIsPopulated( stage2.settings ) )
      test.true( _.mapIsPopulated( stage1.settings ) );
      test.notIdentical( stage2.settings, stage1.settings );
      return null;
    })

    return ready;
  })

  return con;
}

//

function strategyProceed( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let ready = _.Consequence().take( null );

  /* - */

  let outPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.trs.System().form();
  let multiple = ts.multiple
  ({
    inPath : __filename,
    outPath,
    transpilingStrategy : [ 'Nop' ],
  });

  multiple.form();

  /* - */

  test.case = 'returned consequence gives stage instance'
  multiple.singleEach( ( single ) =>
  {
    test.identical( multiple.transpilingStrategy.length, 1 );

    let stage = single.input;
    let strategy = multiple.transpilingStrategy[ 0 ];
    let output = stage.outputMake
    ({
      strategy,
      isFirst : false,
      isLast : true
    });

    ready.then( () => single.strategyProceed( output ) );
    ready.then( ( got ) =>
    {
      test.identical( got, output );
      test.notIdentical( got, stage );
      test.true( got instanceof _.trs.Stage );
      test.identical( got.input, stage );

      return got;
    })
  });

  /* - */

  test.case = 'consequence resolves when strategy work is done'
  multiple.singleEach( ( single ) =>
  {
    test.identical( multiple.transpilingStrategy.length, 1 );

    let stage = single.input;
    let strategy = multiple.transpilingStrategy[ 0 ];
    let output = stage.outputMake
    ({
      strategy,
      isFirst : false,
      isLast : true
    });
    test.identical( output.formed, 0 );

    ready.then( () => single.strategyProceed( output ) );
    ready.then( ( got ) =>
    {
      test.identical( output.formed, 2 );
      test.identical( output.rawData, stage.data )
      test.identical( output.data, output.rawData )

      return got;
    })
  });

  return ready;
}

//

function outputMake( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let con = new _.Consequence().take( null );

  /* - */

  let outPath = _.path.join( routinePath, 'Output.js' );
  let ts = new _.trs.System().form();
  let multiple = ts.multiple
  ({
    inPath : __filename,
    outPath,
  });

  multiple.form();

  /* - */

  test.case = 'trivial'
  multiple.singleEach( ( single ) =>
  {
    let stage = single.input;
    test.true( stage instanceof _.trs.Stage );
    test.identical( stage.settings, null );
    test.identical( stage.output, null );
    test.identical( stage.isFirst, true );

    let output = stage.outputMake();

    test.identical( stage.output, output );
    test.true( output instanceof _.trs.Stage );
    test.notIdentical( stage, output );
    test.identical( output.data, null );
    test.identical( output.rawData, null );
    test.identical( output.index, 1 );
    test.identical( output.input, stage );
    test.identical( output.isFirst, false );
    test.identical( output.settings, null );
  })

  /* - */

  test.case = 'settings map is formed'
  multiple.singleEach( ( single ) =>
  {
    let stage = single.input;
    test.true( stage instanceof _.trs.Stage );
    test.identical( stage.settings, null );

    stage.settings = { someSetting : 1 }

    let output = stage.outputMake();

    test.identical( stage.output, output );
    test.true( output instanceof _.trs.Stage );
    test.notIdentical( stage, output );
    test.identical( output.settings, null );
    test.identical( output.index, 1 );
  })

  /* - */

  test.case = 'prev stage becomes input for next stage'
  multiple.singleEach( ( single ) =>
  {
    let prevStage = single.input;
    let nextStage = prevStage.outputMake();
    test.identical( prevStage.output, nextStage );
    test.identical( nextStage.input, prevStage );
  })

}

// --
// define
// --

let Self =
{

  name : 'Tools.top.TranspilationStrategy',
  silencing : 1,
  routineTimeOut : 60000,
  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    assetsOriginalPath : null,
    suiteTempPath : null,
    find : null,
    findIn : null,
  },

  tests :
  {

    singleFileInputTerminal,
    singleFileInputDir,
    singleFileInputDirThrowing,
    singleDst,
    severalDst,
    complexMask,
    oneToOne,
    nothingFoundOneToOne,
    nothingFoundManyToOne,
    transpileManyToOne,
    // shell, /* qqq : problem because js file to transpile is beyond base path. create test assets with js file and copy it to tmp path to avoid that */

    combinedShell,
    combinedProgramatic,

    beautifing,

    severalStrategies,

    //strategy

    strategyProceed,

    //stage

    outputMake,

  }

}

/* qqq : use assetFor here */

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
