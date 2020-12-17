( function _TranspilerPrepack_s_()
{

'use strict';

let Prepack = require( 'prepack' );

//

let _ = _global_.wTools;
let Parent = _.trs.transpiler.Abstract;
let Self = wTsTranspilerPrepack;
function wTsTranspilerPrepack( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Prepack';

// --
//
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

  if( !stage.settings )
  stage.settings = Object.create( null );
  let set = stage.settings;

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

  debugger;
  stage.rawData = Prepack.prepackSources( [ { fileContents : stage.input.data } ], stage.settings );
  debugger;

  if( stage.rawData.error )
  throw stage.errorHandle( stage.rawData.error );

  _.assert( _.strIs( stage.rawData.code ) );

  stage.data = stage.rawData.code;

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
