( function _StrategyAbstract_s_() {

'use strict';

let Zlib;

//

let _ = wTools;
let Parent = _.TranspilationStrategy.SessionAbstract;
let Self = function wTsSessionPartial( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'SessionPartial';

// --
// inter
// --

function finit()
{
  let session = this;
  session.input = null;
  session.output = null;
  Parent.prototype.finit.call( session );
}

//

function init( o )
{
  let session = this;
  Parent.prototype.init.apply( session, arguments );
  Object.preventExtensions( session );
}

//

function form()
{
  let session = this;

  /* verification */

  _.assert( arguments.length === 0 );
  _.assert( _.numberInRange( session.debug, [ 0, 9 ] ), 'Expects integer in range [ 0, 9 ] {-session.debug-}' );
  _.assert( _.numberInRange( session.optimization, [ 0, 9 ] ), 'Expects integer in range [ 0, 9 ] {-session.debug-}' );
  _.assert( _.numberInRange( session.minification, [ 0, 9 ] ), 'Expects integer in range [ 0, 9 ] {-session.debug-}' );
  _.assert( _.boolLike( session.beautifing ), 'Expects bool-like {-session.beautifing-}' );
  _.assert( _.strIs( session.outputFilePath ), 'Expects path {-session.outputFilePath-}' );

  /* parent */

  Parent.prototype.form.call( session );

  let fileProvider = session.fileProvider;
  let path = fileProvider.path;

  /* path temp */

  session.inputPath = path.resolve( session.inputPath );
  session.outputPath = path.resolve( session.outputPath );
  session.inputFilesPaths = path.s.resolve( session.inputPath, _.arrayFlatten( [], session.inputFilesPaths ) );
  session.outputFilePath = path.resolve( session.outputPath, session.outputFilePath );
  session.tempPath = path.resolve( session.tempPath );
  session.mapFilePath = path.resolve( session.mapFilePath );

  if( !session.name )
  session.name = path.name({ path : session.inputFilesPaths[ 0 ], withExtension : true });

  if( session.writingTempFiles && session.tempPath )
  fileProvider.directoryMake( session.tempPath );

  /* transpilation strategies */

  if( _.strIs( session.strategies ) )
  session.strategies = [ session.strategies ];
  else if( !session.strategies )
  session.strategies = [ 'Uglify' ];
  // session.strategies = [ 'Babel', 'Uglify', 'Babel' ];

  _.assert( _.arrayIs( session.strategies ) );

  for( let s = 0 ; s < session.strategies.length ; s++ )
  {
    let strategy = session.strategies[ s ];
    if( _.strIs( strategy ) )
    {
      _.sure( !!_.TranspilationStrategy.Strategies[ strategy ], 'Strategy not found', strategy )
      strategy = _.TranspilationStrategy.Strategies[ strategy ];
    }

    if( _.routineIs( strategy ) )
    strategy = strategy({ session : session });

    session.strategies[ s ] = strategy;
    _.assert( strategy instanceof _.TranspilationStrategy.Strategies.Abstract );
  }

  /* validation */

  _.assert( _.strDefined( session.name ) );
  _.assert( _.boolLike( session.reportingFileSize ) );
  _.assert( session.fileProvider instanceof _.FileProvider.Abstract );
  _.assert( _.routineIs( session.onBegin ) );
  _.assert( _.routineIs( session.onEnd ) );

  _.assert( _.strIs( session.inputPath ), 'Expects path {-session.inputPath-}' );
  _.assert( _.strIs( session.outputPath ), 'Expects path {-session.outputPath-}' );
  _.assert( _.strIs( session.inputFilesPaths ) || _.arrayIs( session.inputFilesPaths ), 'Expects path {-session.inputFilesPaths-}' );
  _.assert( _.strIs( session.outputFilePath ), 'Expects path {-session.outputFilePath-}' );

  return session;
}

//

function proceed()
{
  let session = this;
  let result = _.Consequence().give();
  let time = _.timeNow();

  session.read();

  result
  .ifNoErrorThen( function( arg )
  {
    return _.routinesCall( session, session.onBegin, [ session ] );
  })

  for( let s = 0 ; s < session.strategies.length ; s++ )
  result.ifNoErrorThen( function( arg )
  {
    return session.strategyProceed( session.strategies[ s ], s );
  });

  result
  .ifNoErrorThen( function( arg )
  {
    return _.routinesCall( session, session.onEnd, [ session ] );
  })
  .doThen( function( err,arg )
  {
    if( err )
    throw _.err( err );
    if( session.verbosity >= 2 )
    logger.log( ' # Transpiled ' + session.outputFilePath, 'in', _.timeSpent( time ) );
    return session.output;
  });

  return result;
}

//

function strategyProceed( strategy, index )
{
  let session = this;
  let result = _.Consequence().give();

  result
  .ifNoErrorThen( function()
  {
    strategy.input = _.mapExtend( null, session.output );
    return strategy.proceed({ session : session, index : index });
  })
  .ifNoErrorThen( function()
  {

    _.mapExtend( session.output, strategy.output );
    _.assert( _.strIs( session.output.code ) );

    if( session.output.error )
    throw _.err( session.output.error );

  })
  .ifNoErrorThen( function()
  {

    /* */

    session.fileProvider.fileWrite
    ({
      filePath : session.outputFilePath,
      data  : session.output.code,
      makingDirectory : 1,
      purging : 1,
    });

    /* */

    if( session.output.map && session.mapFilePath )
    session.fileProvider.fileWrite
    ({
      filePath : session.mapFilePath,
      data : _.strIs( session.output.map ) ? session.output.map : _.toJstruct( session.output.map ),
      makingDirectory : 1,
      purging : 1,
    });

    /* */

    _.assert( strategy.input !== strategy.output );
    _.assert( session.input !== session.output );
    _.assert( session.input !== strategy.input );
    _.assert( session.output !== strategy.input );
    _.assert( session.input !== strategy.output );
    _.assert( session.output !== strategy.output );

    return session.reportFileSize
    ({
      input : strategy.input.code,
      output : strategy.output.code,
    });

  })

  return result;
}

//

function read()
{
  let session = this;
  let ts = session.ts;
  let logger = session.logger;
  let fileProvider = session.fileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 0 );
  _.assert( session.inputFilesPaths.length >= 1, '' );
  _.assert( _.arrayIs( session.inputFilesPaths ) );
  _.assert( session.input === null );
  _.assert( session.output === null );

  session.input = Object.create( null );
  session.output = Object.create( null );

  /* */

  try
  {

    session.input.read = fileProvider.filesRead
    ({
      paths : session.inputFilesPaths,
      throwing : 1,
    }).data;

    session.output.code = session.input.code = session.codeJoin( session.input.read );

    if( session.writingTempFiles && session.tempPath )
    {
      _.sure( fileProvider.directoryIs( session.tempPath ) );
      let dstPath = path.join( session.tempPath, path.nameJoin( session.name, '-read' ) );
      fileProvider.fileWrite( dstPath, session.output.code );
    }

  }
  catch( err )
  {
    err = _.err( err );
    throw err;
  }

}

//

function codeJoin( files )
{
  let result = '';
  let prefix = '// ======================================\n( function() {\n';
  let postfix = '\n})();\n';

  _.assert( _.arrayIs( files ) );
  _.assert( arguments.length === 1 );

  if( files.length > 1 )
  result += prefix + files.join( postfix + prefix ) + postfix;
  else
  result += files[ 0 ];

  return result;
}

//

function tempWrite( o )
{
  let session = this;
  let fileProvider = session.fileProvider;
  let path = fileProvider.path;

  if( !session.writingTempFiles || !session.tempPath )
  return;

  if( arguments.length === 2 )
  {
    o = { name : arguments[ 0 ], data : arguments[ 1 ] }
  }

  o.verbosity = session.verbosity-2;

  _.assert( o.postfix === undefined || _.strIs( o.postfix ) );
  _.assert( arguments.length === 1 );

  o.filePath = path.join( session.tempPath, o.filePath )

  _.routineOptions( tempWrite, o );

  fileProvider.fileWrite( o );

}

tempWrite.defaults =
{
  data : null,
  makingDirectory : 1,
  purging : 1,
}

tempWrite.defaults.__proto__ = _.FileProvider.Partial.prototype.fileWrite.defaults;

//

function reportFileSize( o )
{
  let session = this;
  let ts = session.ts;
  let logger = session.logger;
  let fileProvider = session.fileProvider;
  let path = fileProvider.path;
  let con = _.Consequence();

  if( !_.objectIs( o ) )
  o = { output : o };

  _.routineOptions( reportFileSize, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !session.reportingFileSize || session.verbosity < 3 )
  return _.timeOut( 1 );

  let inputSize = 0;
  if( o.input )
  inputSize = o.input.length;
  else
  inputSize = fileProvider.filesSize( session.inputFilesPaths );

  function _format( size ){ return ( size / 1024 ).toFixed( 2 ); };
  let format = _.strMetricFormatBytes || _format;

  if( !Zlib )
  Zlib = require( 'zlib' );
  debugger;
  Zlib.gzip( o.output, function( err, buffer )
  {

    // let outputSize = _.entitySize( _.bufferNodeFrom( o.output ) );
    let outputSize = _.entitySize( o.output );
    let gzipSize = _.entitySize( buffer );

    if( session.reportingFileSize )
    logger.log( 'Compression factor :', format( inputSize ), '/' , format( outputSize ), '/', format( gzipSize ) );

    con.give();
  });

  return con;
}

reportFileSize.defaults =
{
  input : null,
  output : null,
}

// --
// relationships
// --

let Composes =
{

  debug : 0,
  optimization : 9,
  minification : 8,
  beautifing : 0,

  /* */

  writingTempFiles : 1,
  reportingFileSize : 1,

  /* */

  inputPath : null,
  outputPath : null,
  tempPath : 'temp.tmp',
  mapFilePath : null,
  inputFilesPaths : '.',
  outputFilePath : '.',

}

let Aggregates =
{
  input : null,
  output : null,
}

let Associates =
{
  ts : null,
  strategies : null,
}

let Restricts =
{
}

let Forbids =
{
}

let Accessors =
{
  strategies : { setter : _.accessor.setter.arrayCollection({ name : 'strategies' }) },
}

// --
// prototype
// --

let Proto =
{

  finit : finit,
  init : init,
  form : form,

  proceed : proceed,
  strategyProceed : strategyProceed,

  read : read,
  codeJoin : codeJoin,
  tempWrite : tempWrite,
  reportFileSize : reportFileSize,

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

_.staticDecalre
({
  prototype : _.TranspilationStrategy.prototype,
  name : Self.shortName,
  value : Self,
});

})();
