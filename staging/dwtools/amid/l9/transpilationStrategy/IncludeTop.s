( function IncludeTop_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

  require( './l3/SessionAbstract.s' );
  require( './l3/SessionPartial.s' );
  require( './l3/SessionTop.s' );
  require( './l3/StrategyAbstract.s' );

  require( './l5_strategy/Babel.s' );
  require( './l5_strategy/Closure.s' );
  require( './l5_strategy/Prepack.s' );
  require( './l5_strategy/Uglify.s' );

}

})();
