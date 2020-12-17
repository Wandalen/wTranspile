( function _TranspilerBabel_s_()
{

'use strict';

let Babylon = require( 'babylon' );
let Babel = require( '@babel/core' );

//

let _ = _global_.wTools;
let Parent = _.trs.transpiler.Abstract;
let Self = wTsTranspilerBabel;
function wTsTranspilerBabel( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Babel';

// --
//
// --

/*
doc : https://babeljs.io/docs/usage/api/#options
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

  /* */

  if( !stage.settings )
  stage.settings = Object.create( null );
  let set = stage.settings;
  let plugins = [ 'transform-runtime' ]

  let presets = [ 'es2015-without-strict', 'stage-0', 'stage-1', 'stage-2', 'stage-3' ];
  if( multiple.isServerSide )//qqq Vova: check this field
  presets = [ 'node6-without-strict' ];
  presets = [];

  let parserOpts =
  {
    allowImportExportEverywhere : true,
    allowReturnOutsideFunction : true,
  }

  let defSettings =
  {
    sourceType : 'script',
    // filename : multiple.inputFilesPaths[ 0 ],
    filename : single.name,
    ast : false,
    compact : !!multiple.minification,
    minified : !!multiple.minification,
    comments : !multiple.minification || !!multiple.debug,
    presets,
    parserOpts,
    // loose : [ 'es6.modules' ],
    // blacklist : [ 'useStrict' ],
    // plugins : [ 'transform-class-properties' ],
    // plugins : plugins,
  }

  _.mapSupplement( set, defSettings );

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
  let result = null;

  _.assert( arguments.length === 1 );
  _.assert( stage instanceof _.trs.Stage );
  _.assert( stage.formed === 1 );

  try
  {
    stage.rawData = Babel.transform( stage.input.data, stage.settings );
  }
  catch( err )
  {

    debugger;
    stage.settings.sourceType = 'module';
    logger.log( 'failed, trying babel with { sourceType : "module" }' );
    logger.log( 'settings\n', stage.settings );
    stage.rawData = Babel.transform( stage.input.data, stage.settings );

  }

  _.assert( _.strIs( stage.rawData.code ), 'Output should be string' );

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
