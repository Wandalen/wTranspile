( function _MainTop_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './MainBase.s' );

}

let _ = wTools;

_.include( 'wCommandsAggregator' );
_.include( 'wCommandsConfig' );
_.include( 'wStateStorage' );
_.include( 'wStateSession' );

//

let Parent = null;
let Self = _.TranspilationStrategy;

_.assert( _.routineIs( _.TranspilationStrategy ) );

// --
//
// --

let ConfigProperties =
{

  inputPath : 'Path to terminal file or dirrectory with files to transpile.',
  inputPath : 'Path to terminal file to store.',
  tempPath : 'Path to temporary directory to store intermediate results. Default : temp.tmp.',
  mapFilePath : 'Path to store map-file. Default : null.',

  debug : 'Level of debug, should be in range [ 0 .. 9 ]. Default : 0.',
  optimization : 'Level of optimization, should be in range [ 0 .. 9 ]. Default : 9.',
  minification : 'Level of minification, should be in range [ 0 .. 9 ]. Default : 5.',
  beautifing : 'Make output code readable. Default : 0',

  writingTempFiles : 'Switch on/off writing intermediate results of transpiling as temporary file. Default : 1.',
  reportingFileSize : 'Switch on/off reporting of input/output/compressed size of file. Takes some extra time because of compressing. Default : 1.',
  verbosity : 'Set verbosity of the session.',
  v : 'Set verbosity of the session.',
  strategies : 'One or several strategies to use. Use .strategies.list to get list of available strategies.',

}

// --
// exec
// --

function Exec()
{
  let ts = new this.Self();
  return ts.exec();
}

//

function exec()
{
  let ts = this;

  if( !ts.formed )
  ts.form();

  _.assert( _.instanceIs( ts ) );
  _.assert( arguments.length === 0 );

  let logger = ts.logger;
  let fileProvider = ts.fileProvider;
  let appArgs = _.appArgs();
  let ca = ts.commandsMake();

  return ca.proceedApplicationArguments({ appArgs : appArgs });
}

//

function commandsMake()
{
  let ts = this;
  let logger = ts.logger;
  let fileProvider = ts.fileProvider;
  let appArgs = _.appArgs();

  _.assert( _.instanceIs( ts ) );
  _.assert( arguments.length === 0 );

  let commands =
  {
    'help' :              { e : _.routineJoin( ts, ts.commandHelp ),                h : 'Get help' },
    'strategies list' :   { e : _.routineJoin( ts, ts.commandStrategiesList ),      h : 'List available strategies of transpilation' },
    'transpile' :    { e : _.routineJoin( ts, ts.commandTranspile ),                h : 'Transpile inputPath file and store result at inputPath' },
  }

  let ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands : commands,
    commandPrefix : 'node ',
  })

  ts._commandsConfigAdd( ca );

  ca.form();

  return ca;
}

//

function commandHelp( e )
{
  let ts = this;
  let ca = e.ca;
  let fileProvider = ts.fileProvider;
  let logger = ts.logger;

  ca._commandHelp( e );

  if( !e.subject )
  logger.log( 'Use ' + logger.colorFormat( '"ts .help"', 'code' ) + ' to get help' );

  return ts;
}

//

function commandStrategiesList( e )
{
  let ts = this;
  let fileProvider = ts.fileProvider;
  let logger = ts.logger;

  debugger;
  logger.log( 'Available strategies' );
  logger.up();
  for( let s in ts.Strategies )
  {
    let strategy = ts.Strategies[ s ];
    logger.log( s, '-', strategy.name );
  }
  logger.down();

  return ts;
}

//

function commandTranspile( e )
{
  let ts = this;
  let fileProvider = ts.fileProvider;
  let logger = ts.logger;

  _.sureMapHasOnly( e.propertiesMap, commandTranspile.commandProperties );
  _.sureBriefly( _.strIs( e.propertiesMap.inputPath ), 'Expects path to file to transpile {-inputPath-}' );
  _.sureBriefly( _.strIs( e.propertiesMap.inputPath ), 'Expects path to file to save transpiled {-inputPath-}' );

  if( ts.verbosity >= 3 )
  logger.log( ' # Transpiling', e.propertiesMap.inputPath, '<-', e.propertiesMap.inputPath );

  logger.up();

  let session = ts.Session
  ({
    ts : ts,
    inputPath : e.propertiesMap.inputPath,
    outputPath : e.propertiesMap.inputPath,
  });

  ts.storageLoad();

  _.appArgsReadTo
  ({
    dst : ts,
    only : 0,
    removing : 0,
    propertiesMap : ts.storage,
    namesMap :
    {
      'verbosity' : 'verbosity',
      'v' : 'verbosity',
    },
  });

  _.appArgsReadTo
  ({
    dst : ts,
    only : 0,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'verbosity' : 'verbosity',
      'v' : 'verbosity',
    },
  });

  _.appArgsReadTo
  ({
    dst : session,
    only : 0,
    removing : 0,
    propertiesMap : ts.storage,
    namesMap :
    {
      'inputPath' : 'inputPath',
      'inputPath' : 'outputPath',
      'strategies' : 'strategies',
      'debug' : 'debug',
      'optimization' : 'optimization',
      'minification' : 'minification',
      'beautifing' : 'beautifing',
      'writingTempFiles' : 'writingTempFiles',
      'reportingFileSize' : 'reportingFileSize',
    },
  });

  _.appArgsReadTo
  ({
    dst : session,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'inputPath' : 'inputPath',
      'inputPath' : 'outputPath',
      'strategies' : 'strategies',
      'debug' : 'debug',
      'optimization' : 'optimization',
      'minification' : 'minification',
      'beautifing' : 'beautifing',
      'writingTempFiles' : 'writingTempFiles',
      'reportingFileSize' : 'reportingFileSize',
    },
  });

  session.verbosity = ts.verbosity;

  session.form();

  return session.proceed()
  .doThen( ( err ) =>
  {
    if( err )
    _.errLogOnce( err );
    logger.down();
    session.finit();
  });

}

commandTranspile.commandProperties = ConfigProperties

//

function storageIs( storage )
{
  let session = this;
  _.assert( arguments.length === 1 );
  if( !_.objectIs( storage ) )
  return false;
  if( !_.mapHasOnly( storage, session.ConfigProperties ) )
  return false;
  return true;
}

//

function storageDefaultGet()
{
  let session = this;
  debugger;
  return { storage : Object.create( null ) };
}

// --
// relations
// --

let Composes =
{
  storageFileName : '.wTranspStrat',
  storage : _.define.own({}),
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  opened : 0,
}

let Statics =
{
  Exec : Exec,
  ConfigProperties : ConfigProperties,
}

let Forbids =
{
}

// --
// declare
// --

let Extend =
{

  // exec

  Exec : Exec,
  exec : exec,

  commandsMake : commandsMake,
  commandHelp : commandHelp,
  commandStrategiesList : commandStrategiesList,
  commandTranspile : commandTranspile,

  storageIs,
  storageDefaultGet,

  // relations

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,

}

//

_.classExtend( Self, Extend );
_.StateStorage.mixin( Self );
_.StateSession.mixin( Self );
_.CommandsConfig.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.shortName ] = Self;

if( !module.parent )
Self.Exec();

})();
