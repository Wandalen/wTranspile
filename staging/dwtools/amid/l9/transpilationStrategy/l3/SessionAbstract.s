( function _SessionAbstract_s_() {

'use strict';

let Gzip = require( 'zlib' ).gzip;
let _ = _global_.wTools;

//

let Parent = null;
let Self = function wTsSessionAbstract( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'SessionAbstract';

// --
// inter
// --

function init( o )
{
  let session = this;
  _.Copyable.prototype.init.call( session, o );
  Object.preventExtensions( session );
}

//

function form()
{
  let session = this;

  _.assert( session.formed === 0 );
  _.assert( _.objectIs( session.ts ) );
  _.assert( arguments.length === 0 );

  session.onBegin = _.routinesCompose( session.onBegin );
  session.onEnd = _.routinesCompose( session.onEnd );

  if( !session.fileProvider )
  session.fileProvider = session.ts.fileProvider || _.FileProvider.Default();

  if( !session.logger )
  session.logger = new _.Logger({ output : session.ts.logger });

  _.assert( _.boolLike( session.reportingFileSize ) );
  _.assert( session.fileProvider instanceof _.FileProvider.Abstract );
  _.assert( _.routineIs( session.onBegin ) );
  _.assert( _.routineIs( session.onEnd ) );

  session.formed = 1;
  return session;
}

//

function go()
{
  let session = this;
  session.form();
  session.proceed();
  return session;
}

//

function goThen()
{
  let session = this;
  session.form();
  return session.proceed();
}

// --
// relations
// --

let Composes =
{

  name : null,
  verbosity : 3,

  onBegin : null,
  onEnd : null,

}

let Aggregates =
{
}

let Associates =
{
  ts : null,
  fileProvider : null,
  logger : null,
}

let Restricts =
{
  formed : 0,
}

let Forbids =
{

  command : 'command',
  fileReport : 'fileReport',
  separateProcess : 'separateProcess',
  silent : 'silent',
  fastest : 'fastest',
  pretty : 'pretty',
  _options : '_options',
  outputFilesPath : 'outputFilesPath',
  infoEnabled : 'infoEnabled',
  off : 'off',
  settings : 'settings',
  minimization : 'minimization',

  usingBabel : 'usingBabel',
  settingsOfBabel : 'settingsOfBabel',
  usingButternut : 'usingButternut',
  settingsOfButternut : 'settingsOfButternut',
  usingBabili : 'usingBabili',
  settingsOfBabili : 'settingsOfBabili',
  usingPrepack : 'usingPrepack',
  settingsOfPrepack : 'settingsOfPrepack',
  usingClosure : 'usingClosure',
  settingsOfClosure : 'settingsOfClosure',
  usingUglify : 'usingUglify',
  settingsOfUglify : 'settingsOfUglify',
  transpiler : 'transpiler',

}

// --
// declare
// --

let Proto =
{

  init : init,
  form : form,
  go : go,
  goThen : goThen,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
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
// _.Instancing.mixin( Self );
// _.TimeMarker.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.staticDecalre
({
  prototype : _.TranspilingStrategy.prototype,
  name : Self.shortName,
  value : Self,
});

})();
