( function _Nop_s_() {

'use strict';

//

let _ = _global_.wTools;
let Parent = _.trs.transpiler.Abstract;
let Self = wTsTranspilerNop;
function wTsTranspilerNop( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Nop';

// --
// routine
// --

function _formAct( stage )
{
  let self = this;
  let sys = stage.sys;
  let single = stage.single;
  let multiple = stage.multiple;

  _.assert( arguments.length === 1 );
  _.assert( stage instanceof _.trs.Stage );
  _.assert( stage.formed === 0 );

  stage.formed = 1;
  return stage;
}

//

function _performAct( stage )
{
  let self = this;
  let sys = stage.sys;
  let single = stage.single;
  let multiple = stage.multiple;

  _.assert( arguments.length === 1 );
  _.assert( stage instanceof _.trs.Stage );
  _.assert( stage.formed === 1 );

  stage.rawData = stage.input.data;
  stage.data = stage.rawData;

  stage.formed = 2;
  return stage;
}

// --
// relations
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

  _formAct,
  _performAct,

  /* */

  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_.trs.transpiler[ Self.shortName ] = Self;

})();
