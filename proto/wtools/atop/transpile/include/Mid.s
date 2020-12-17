( function _Mid_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  require( '../l3/Concatenator.s' );
  require( '../l3/Multiple.s' );
  require( '../l3/Single.s' );
  require( '../l3/Stage.s' );
  require( '../l3/Transpiler.s' );

  require( '../l5_concatenator/JavaScript.s' );
  require( '../l5_concatenator/Text.s' );

  require( '../l5_transpiler/Babel.s' );
  require( '../l5_transpiler/Closure.s' );
  require( '../l5_transpiler/Nop.s' );
  // require( '../l5_transpiler/Prepack.s' );
  require( '../l5_transpiler/Uglify.s' );

  require( '../l7/System.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();
