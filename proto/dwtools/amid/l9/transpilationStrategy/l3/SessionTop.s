( function _Strategy_s_() {

'use strict';

//

let _ = wTools;
let Parent = _.TranspilationStrategy.SessionPartial;
let Self = function wTsSession( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Session';

// --
// relationships
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

// --
// prototype
// --

let Proto =
{

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.staticDecalre
({
  prototype : _.TranspilationStrategy.prototype,
  name : Self.shortName,
  value : Self,
});

})();
