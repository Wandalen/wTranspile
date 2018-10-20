( function _StrategyAbstract_s_() {

'use strict';

//

let _ = wTools;
let Parent = null;
let Self = function wTsStrategyAbstract( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Abstract';

// --
//
// --

function form()
{
  let self = this;

  _.assert( _.mapIs( self.input ) );

  if( !self.output )
  self.output = Object.create( null );

  let result = self._formAct();

  return result;
}

//

function proceed( o )
{
  let self = this;
  let session = self.session;
  let fileProvider = session.fileProvider;
  let path = fileProvider.path;
  let logger = session.logger;
  let time = _.timeNow();
  let result;

  /* verify */

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( self.input.code ) );
  _.assert( session.inputFilesPaths.length >= 1 );
  _.assertRoutineOptions( proceed, arguments );

  /* */

  self.form();
  _.routinesCall( self, session.onBegin, [ self ] );

  /* verbal */

  // if( session.verbosity >= 2 )
  // logger.log( ' # Transpiling ' + session.outputFilePath + ' with strategy ' + self.constructor.shortName );

  let Fields =
  {

    inputPath : null,
    inputPath : null,
    tempPath : null,
    mapFilePath : null,

    debug : null,
    optimization : null,
    minification : null,
    beautifing : null,

    writingTempFiles : null,
    reportingFileSize : null,
    strategies : null,

  }

  if( session.verbosity >= 4 )
  {
    let fields = _.mapOnly( session, Fields );
    logger.log( _.toStr( fields, { levels : 2, multiline : 1, wrap : 0 } ) );
  }

  if( session.verbosity >= 4 )
  {
    logger.log( 'Settings' );
    logger.log( _.toStr( self.settings, { levels : session.verbosity >= 5 ? 2 : 1, wrap : 0, multiline : 1 } ) );
  }

  if( session.verbosity >= 5 )
  logger.log( 'inputFilesPaths :', _.toStr( session.inputFilesPaths, { levels : 2, wrap : 0, multiline : 1 } ) );

  /* */

  try
  {
    result = _.Consequence.from( self._executeAct() );
  }
  catch( err )
  {
    return self.errorHandle( err );
  }

  /* result */

  result
  .ifNoErrorThen( function()
  {

    if( self.output.error )
    throw _.err( self.output.error );
    _.assert( _.strIs( self.input.code ) );
    _.assert( _.strIs( self.output.code ) );

  })
  .ifNoErrorThen( function()
  {

    if( session.writingTempFiles )
    session.tempWrite
    ({
      filePath : path.nameJoin( path.fullName( session.outputFilePath ), '-after-', String( o.index ), '-', self.constructor.shortName ),
      data : self.output.code,
    });

    if( session.verbosity >= 2 )
    logger.log( ' # Transpiled ' + session.outputFilePath + ' with strategy ' + self.constructor.shortName, 'in', _.timeSpent( time ) );

  })

  return result;
}

proceed.defaults =
{
  session : null,
  index : null,
}

//

function go()
{
  let self = this;

  self.form();
  self.proceed();

  return self;
}

//

function goThen()
{
  let self = this;

  self.form();
  return self.proceed();
}

//

function errorHandle( err )
{
  let self = this;
  let session = self.session;
  let result = null;

  debugger;
  let code = '';

  let line = err.line;
  if( err.location && line === undefined )
  line = err.location.line;
  if( _.numberIs( line ) && self.input.code )
  {
    debugger;

    code = _.strLinesSelect
    ({
      src : self.input.code,
      line : line,
      number : 1,
    });

    // code = _.strLinesNumber
    // ({
    //   src : _.strLinesSelect( self.input.code , line-3 , line+3 ),
    //   first : err.line-3,
    // });

  }

  err = _.errLogOnce( code + '\n',err );

  if( self.terminatingOnError )
  _.appExitWithBeep( -1 );

  throw err;
}

// --
// relationships
// --

let Composes =
{

  settings : null,
  terminatingOnError : 1,

}

let Aggregates =
{
  input : null,
  output : null,
}

let Associates =
{
  session : null,
}

let Restricts =
{
}

let Forbids =
{

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

  /* */

  mapFilePath : 'mapFilePath',
  writingTempFiles : 'writingTempFiles',
  off : 'off',
  verbosity : 'verbosity',
  command : 'command',
  fastest : 'fastest',
  debug : 'debug',
  pretty : 'pretty',
  tempPath : 'tempPath',
  outputFilePath : 'outputFilePath',
  inputFilesPaths : 'inputFilesPaths',
  onBegin : 'onBegin',
  onEnd : 'onEnd',
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
  strategy : 'strategy',

}

// --
// prototype
// --

let Proto =
{

  form : form,
  _formAct : null,

  proceed : proceed,
  _executeAct : null,

  go : go,
  goThen : goThen,

  errorHandle : errorHandle,

  /* */

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

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.TranspilationStrategy.Strategies[ Self.shortName ] = Self;

// _.TranspilationStrategy.Strategies = _.TranspilationStrategy.Strategies || Object.create( null );
// _.TranspilationStrategy.Strategies[ Self.shortName ] = Self;

})();
