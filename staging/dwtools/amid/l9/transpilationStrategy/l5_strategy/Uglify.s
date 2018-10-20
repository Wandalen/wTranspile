( function _StrategyUglify_s_() {

'use strict';

let Uglify = require( 'uglify-es' );

//

let _ = wTools;
let Parent = _.TranspilingStrategy.Strategies.Abstract;
let Self = function wTsStrategyUglify( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Uglify';

// --
//
// --

/*
doc : https://github.com/mishoo/UglifyJS2/tree/harmony
*/

function _formAct()
{
  let self = this;
  let session = self.session;

  if( !self.settings )
  self.settings = Object.create( null );
  let set = self.settings;

  if( set.sourceMap === undefined )
  {
    set.sourceMap = Object.create( null );
    set.sourceMap.filename = _.path.join( session.outputPath , session.outputFilePath + '.map' );
    session.mapFilePath = set.sourceMap.filename; // xxx
  }

  set.sourceMap = false;

  if( set.warnings === undefined ) set.warnings = !!session.verbosity;
  set.warnings = false;

  // set.toplevel = false;

  /* parse */

  set.parse = Object.create( null );
  set.parse.ecma = 8;
  set.parse.shebang = true;

  /* mangle */

  let defMangle =
  {
    ie8         : false,
    toplevel    : false,
    eval        : false,
    keep_fnames : true,
    keep_classnames : true,
  }

  let mangle = set.mangle = set.mangle || Object.create( null );
  _.mapSupplement( mangle, defMangle );

  set.mangle.toplevel = session.minification >= 8;

  if( session.minification === 0 )
  {
    set.mangle = false;
  }
  else
  {
    // set.mangle.toplevel = true;
    // intrusive !
    // let properties = set.mangle.properties = set.mangle.properties || Object.create( null );
    // properties.keep_quoted = true;
  }

  /* compress */

/*
ie8           : false, // ie8 unsafe
sequences     : true,  // join consecutive statemets with the “comma operator”
properties    : true,  // optimize property access : a["foo"] → a.foo
dead_code     : true,  // discard unreachable code
drop_debugger : true,  // discard "debugger" statements
drop_console  : true,  // discard "console" statements
unsafe        : false, // some unsafe optimizations (see below)
conditionals  : true,  // optimize if-s and conditional expressions
comparisons   : true,  // optimize comparisons
evaluate      : true,  // evaluate constant expressions
booleans      : true,  // optimize boolean expressions
loops         : true,  // optimize loops
unused        : true,  // drop unused variables/functions
hoist_funs    : true,  // hoist function declarations
hoist_vars    : false, // hoist variable declarations
if_return     : true,  // optimize if-s followed by return/continue
join_vars     : true,  // join let declarations
cascade       : true,  // try to cascade `right` into `left` in sequences
side_effects  : true,  // drop side-effect-free statements
warnings      : true,  // warn about potentially dangerous optimizations/code
global_defs   : {}     // global definitions

*/

  let defCompress =
  {
    ie8 : false,
    sequences : true,
    dead_code : true,
    drop_console : false,
    drop_debugger : false,
    comparisons : false,
    evaluate : false,
    arrows : false,
    booleans : false,
    loops : true,
    unused : true,
    unsafe : false,
    hoist_funs : false,
    join_vars : false,
    // cascade : true, /* removed? */
    keep_fnames : true,
    keep_infinity : true,
    negate_iife : false,
    toplevel : false,
    passes : 1,
    // ecma : 6, /* problematic */
  }

  if( set.compress === undefined )
  set.compress = Object.create( null );
  let compress = set.compress;

  if( compress )
  {

    if( compress.passes === undefined ) compress.passes = ( session.optimization > 7 || session.minification > 7 ) ? 2 : 1;
    if( compress.unused === undefined ) compress.unused = !!session.optimization;

    if( compress.booleans === undefined ) compress.booleans = !!session.minification;
    if( compress.reduce_vars === undefined ) compress.reduce_vars = session.optimization > 4;
    if( compress.collapse_vars === undefined ) compress.collapse_vars = session.optimization > 7;
    if( compress.hoist_funs === undefined ) compress.hoist_funs = !!session.minification;
    if( compress.join_vars === undefined ) compress.join_vars = !!session.minification;
    if( compress.inline === undefined ) compress.inline = _.numberClamp( Math.floor( session.optimization / 3 ), [ 0,3 ] );
    if( compress.if_return === undefined ) compress.if_return = !!session.optimization;
    if( compress.conditionals === undefined ) compress.conditionals = !!session.optimization;
    if( compress.comparisons === undefined ) compress.comparisons = !!session.optimization;
    // if( compress.top_retain === undefined ) compress.top_retain = session.minification < 5; /* it should be function or string */
    if( compress.evaluate === undefined ) compress.evaluate = !!session.optimization;
    if( compress.negate_iife === undefined ) compress.negate_iife = !!session.optimization;

    // if( compress.arrows === undefined ) compress.arrows = !!session.optimization;
    if( compress.toplevel === undefined ) compress.toplevel = session.optimization > 7;
    if( compress.drop_debugger === undefined ) compress.drop_debugger = !!session.minification && !session.debug;
    if( compress.drop_console === undefined ) compress.drop_console = !!session.minification && !session.debug;

    if( compress.global_defs === undefined ) compress.global_defs =
    {
      'DEBUG' : !!session.debug,
      'Config.debug' : !!session.debug,
      'Config.release' : !session.debug,
    }

    _.mapSupplement( compress,defCompress );

    // if( compress.top_retain )
    // compress.top_retain = function( a,b,c )
    // {
    //   debugger;
    //   console.log( a,b,c )
    // }

  }

  /* output */

  if( set.output === undefined ) set.output = Object.create( null );
  let output = set.output;
  let defOutput =
  {
    beautify : !session.minification,
    comments : !session.minification,
    indent_level : !session.minification ? 2 : undefined,
    keep_quoted_props : !session.minification ? true : false,
    max_line_len : !session.minification ? 160 : 65535,
    source_map : null,
    // ecma : 6, /* problematic */
  }

  _.mapSupplement( output,defOutput );

  return set;
}

//

function _executeAct()
{
  let self = this;
  let session = self.session;

  let result = Uglify.minify( self.input.code, self.settings );
  _.mapExtend( self.output, result );

  return result;
}

// --
// relationships
// --

let Composes =
{
  fileProvider : _.define.own( new _.FileProvider.HardDrive({ encoding : 'utf8' }) )
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

  _formAct : _formAct,
  _executeAct : _executeAct,

  /* */

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

_.TranspilingStrategy.Strategies[ Self.shortName ] = Self;
if( !_.TranspilingStrategy.Strategies.Default )
_.TranspilingStrategy.Strategies.Default = Self;

})();
