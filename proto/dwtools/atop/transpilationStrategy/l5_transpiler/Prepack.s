( function _TranspilerPrepack_s_() {

'use strict';

let Prepack = require( 'prepack' );

//

let _ = _global_.wTools;
let Parent = _.trs.transpiler.Abstract;
let Self = function wTsTranspilerPrepack( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Prepack';

// --
//
// --

function _formAct()
{
  let self = this;
  let session = self.session;

  if( !self.settings )
  self.settings = {};
  let set = self.settings;

  return set;
}

//

function _performAct()
{
  let self = this;
  let session = self.session;
  let result = null;

  debugger;
  result = Prepack.prepackSources( [{ fileContents : self.input.code }], self.settings );
  debugger;

  if( result.error )
  throw _.err( result.error );

  _.assert( _.strIs( result.code ) );
  _.mapExtend( self.output,result );

  return result;
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
