( function _TranspilationStrategy_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    var toolsPath = '../../../dwtools/Base.s';
    var toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );

  require( '../l9/transpilationStrategy/MainBase.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
//
// --

function trivial( test )
{
  let tempPath = _.path.dirTempOpen( 'TranspliationStrategy_Trivial' );

  try
  {

    let outputPath = _.path.join( tempPath, 'Sample.js' );
    let ts = new _.TranspilationStrategy().form();

    let session = ts.session
    ({
      inputPath : __filename,
      outputPath : outputPath,
    });

    return session.form().proceed()
    .doThen( ( err ) =>
    {
      test.is( _.fileProvider.fileExists( outputPath ) );
      end();
      if( err )
      throw _.errLogOnce( err );
    });

  }
  catch( err )
  {
    end();
    throw err;
  }

  function end()
  {
    _.path.dirTempClose( tempPath );
  }

}

// --
//
// --

var Self =
{

  name : 'Tools/mid/TranspilationStrategy',
  silencing : 1,

  tests :
  {
    trivial : trivial,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
/*_.*/wTester.test( Self.name );

})();
