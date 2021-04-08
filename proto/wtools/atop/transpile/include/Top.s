( function _Top_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( './Mid.s' );

  _.include( 'wCommandsAggregator' );
  _.include( 'wCommandsConfig' );
  _.include( 'wStateStorage' ); /* xxx qqq : try to remove */
  _.include( 'wStateSession' ); /* xxx qqq : try to remove */

  require( '../l8/Cui.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();
