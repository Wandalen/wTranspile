( function _Base_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wPathTools' );
  _.include( 'wVerbal' );
  _.include( 'wFiles' );
  _.include( 'wStarter' );

  module[ 'exports' ] = _global_.wTools;
}

})();
