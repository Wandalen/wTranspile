( function _MainBase_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

}

//

let _ = wTools;
let Parent = null;
let Self = function wTranspilingStrategy( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'TranspilingStrategy';

// --
// inter
// --

function finit()
{
  if( this.formed )
  this.unform();
  return _.Copyable.prototype.finit.apply( this, arguments );
}

//

function init( o )
{
  let ts = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.instanceInit( ts );
  Object.preventExtensions( ts );

  if( o )
  ts.copy( o );

}

//

function unform()
{
  let ts = this;

  _.assert( arguments.length === 0 );
  _.assert( !!ts.formed );

  /* begin */

  /* end */

  ts.formed = 0;
  return ts;
}

//

function form()
{
  let ts = this;

  ts.formAssociates();

  _.assert( arguments.length === 0 );
  _.assert( !ts.formed );

  /* begin */

  /* end */

  ts.formed = 1;
  return ts;
}

//

function formAssociates()
{
  let ts = this;
  let logger = ts.logger;

  _.assert( arguments.length === 0 );
  _.assert( !ts.formed );

  if( !ts.logger )
  logger = ts.logger = new _.Logger({ output : _global_.logger });

  if( !ts.fileProvider )
  ts.fileProvider = _.FileProvider.Default();

}

// --
// relations
// --

let Composes =
{
  verbosity : 3,
}

let Aggregates =
{
}

let Associates =
{

  fileProvider : null,
  logger : null,

}

let Restricts =
{
  formed : 0,
}

let Statics =
{
  Strategies : Object.create( null ),
}

let Forbids =
{
}

// --
// declare
// --

let Proto =
{

  // inter

  finit : finit,
  init : init,
  unform : unform,
  form : form,
  formAssociates : formAssociates,

  // ident

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = wTools;
_global_[ Self.name ] = wTools[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
require( './IncludeTop.s' );

})();
