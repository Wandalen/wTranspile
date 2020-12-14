( function _TranspilerClosure_s_()
{

'use strict';

let Closure = require( 'google-closure-compiler-js' );

//

let _ = _global_.wTools;
let Parent = _.trs.transpiler.Abstract;
let Self = wTsTranspilerClosure;
function wTsTranspilerClosure( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Closure';

// --
//
// --

/*
doc : https://github.com/google/closure-compiler-js#flags
*/

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

  set.languageIn = 'ECMASCRIPT6';
  // set.languageOut = 'ECMASCRIPT6';
  // set.compilationLevel = session.optimization < 8 ? 'SIMPLE' : 'ADVANCED';
  set.compilationLevel = 'SIMPLE';
  set.warningLevel = 'DEFAULT';
  set.env = 'CUSTOM';
  set.assumeFunctionWrapper = false;
  // set.preserveTypeAnnotations = !!session.pretty;
  set.preserveTypeAnnotations = false;

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

  stage.settings.jsCode = [ { src : stage.input.data } ];
  stage.rawData = Closure( stage.settings );

  if( stage.rawData.error )
  throw stage.errorHandle( stage.rawData.error );
  if( stage.rawData.errors.length )
  throw stage.errorHandle( _.err( stage.rawData.errors[ stage.rawData.errors.length-1 ] ) );

  stage.data = stage.rawData.compiledCode;

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
