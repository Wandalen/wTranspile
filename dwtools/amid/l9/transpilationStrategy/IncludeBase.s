( function IncludeBase_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  let _ = _global_.wTools;

  _.include( 'wCopyable' );
  // _.include( 'wTimeMarker' );
  _.include( 'wPathFundamentals' );
  _.include( 'wVerbal' );
  _.include( 'wFiles' );

  // let Gzip = require( 'zlib' ).gzip;

}

})();
