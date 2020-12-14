( function _Include_s_( )
{

'use strict';

/**
 * Aggregator of strategies to transpile JS code. It provides unified programmatic and CL interfaces to transpile/optimize/minimize/beautify code by one or several transpilers in series. More strategies could be added as plugins. Default options of transpilation can be written into a config file to avoid retyping. Use the module to utilize the power of open source transpilation tools in single package.
  @module Tools/mid/TranspilationStrategy
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../include/Top.s' );
  module[ 'exports' ] = _global_.wTools;
  if( !module.parent )
  _global_.wTools.trs.Cui.Exec();
}

})();
