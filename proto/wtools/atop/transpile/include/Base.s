( function _Base_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wPathTools' );
  _.include( 'wVerbal' );
  _.include( 'wFiles' );
  _.include( 'wStarter' );

  module[ 'exports' ] = _global_.wTools;
}

})();
