( function _Single_s_()
{

'use strict';

let Zlib;

//

const _ = _global_.wTools;
const Parent = null;
const Self = wTsSingle;
function wTsSingle( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Single';

// --
// inter
// --

function finit()
{
  let single = this;
  Parent.prototype.finit.call( single );
}

//

function init( o )
{
  let single = this;
  _.Copyable.prototype.init.call( single, o );
  Object.preventExtensions( single );
}

//

function form()
{
  let single = this;
  let multiple = single.multiple;
  let sys = single.sys;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;

  _.assert( multiple instanceof _.trs.Multiple );
  _.assert( single.input === null );
  _.assert( single.output === null );
  _.assert( single.formed === 0 );

  single.errors = [];

  if( !single.name )
  single.name = path.name({ path : single.outPath, full : true })

  if( !single.sourceMapPath )
  single.sourceMapPath = single.outPath + '.map';

  single.input = _.trs.Stage
  ({
    single,
    multiple,
    sys,
    index : 0,
    isFirst : true,
  });

  single.input.data = single.concatenate();

  if( multiple.writingTempFiles && multiple.tempPath )
  {
    _.sure( fileProvider.isDir( multiple.tempPath ) );
    let tmpPath = single.tempPathFor( '-read' );
    fileProvider.fileWrite( tmpPath, single.input.data );
  }

  single.formed = 1;
}

//

function perform()
{
  let single = this;
  let multiple = single.multiple;
  let sys = single.sys;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;
  let con = new _.Consequence().take( null );
  let time = _.time.now();
  let logger = multiple.logger;

  _.assert( multiple instanceof _.trs.Multiple );
  _.assert( single.input instanceof _.trs.Stage );
  _.assert( single.output === null );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  multiple.dstCounter += 1;
  multiple.srcCounter += _.props.keys( single.dataMap ).length;

  con.thenKeep( ( arg ) =>
  {
    return single.input;
  });

  for( let s = 0 ; s < multiple.transpilingStrategy.length ; s++ ) (function()
  {
    let index = s;
    let strategy = multiple.transpilingStrategy[ s ];
    let isLast = index === multiple.transpilingStrategy.length - 1;
    con.thenKeep( function( input )
    {
      let output = input.outputMake
      ({
        strategy,
        isLast,
        isFirst : false
      });
      if( output.isLast )
      single.output = output;
      return single.strategyProceed( output );
    });
  }());

  /* */

  con
  .thenKeep( function( arg )
  {

    let outPath = single.outPath;

    if( multiple.fileProvider.isDir( outPath ) )
    if( multiple.writingTerminalUnderDirectory )
    {
      _.assert( !!single.concatenator );
      _.assert( _.strIs( single.concatenator.ext[ 0 ] ) );
      outPath = single.outPath = path.join( outPath, single.name + '.' + single.concatenator.ext[ 0 ] );
    }

    if( multiple.fileProvider.isDir( outPath ) )
    {
      throw _.err( outPath, 'is directory, not safe to purge it!' );
    }

    multiple.fileProvider.fileWrite
    ({
      filePath : outPath,
      data  : single.output.data,
      makingDirectory : 1,
      purging : 1,
    });

    /* */

    if( multiple.writingSourceMap && single.sourceMapPath && single.output.sourceMap )
    multiple.fileProvider.fileWrite
    ({
      filePath : single.sourceMapPath,
      data : _.strIs( single.output.sourceMap ) ? single.output.sourceMap : _.entity.exportJstruct( single.output.sourceMap ),
      makingDirectory : 1,
      purging : 1,
    });

    /* */

    _.assert( single.input !== single.output );

    return single.sizeReport
    ({
      input : single.input.data,
      output : single.output.data,
    });

  })
  .finally( function( err, arg )
  {

    if( err )
    _.arrayAppendOnce( multiple.errors, err );
    if( err )
    _.arrayAppendOnce( single.errors, err );

    if( single.errors.length )
    {
      if( multiple.verbosity >= 1 )
      logger.log( ' ! Failed to transpile ' + single.outPath );
    }
    else
    {
      if( multiple.verbosity >= 3 )
      logger.log( ' # Transpiled ' + _.props.keys( single.dataMap ).length + ' file(s) to ' + _.color.strFormat( single.outPath, 'path' ) + ' in', _.time.spent( time ) );
      if( multiple.verbosity >= 4 )
      logger.log( ' # ' + single.sizeReportLast );
    }

    // if( !single.errors.length )
    // {
    //   if( multiple.verbosity >= 3 )
    //   logger.log( ' # Transpiled ' + _.props.keys( single.dataMap ).length + ' file(s) to ' + _.color.strFormat( single.outPath, 'path' ) + ' in', _.time.spent( time ) );
    //   if( multiple.verbosity >= 4 )
    //   logger.log( ' # ' + single.sizeReportLast );
    // }
    // else
    // {
    //   if( multiple.verbosity >= 1 )
    //   logger.log( ' ! Failed to transpile ' + single.outPath );
    // }

    return single;
  });

  return con;
}

//

function strategyProceed( stage )
{
  let single = this;
  let multiple = single.multiple;
  let sys = single.sys;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;
  let result = _.Consequence().take( null );

  _.assert( !!stage.strategy );
  _.assert( _.numberIs( stage.index ) );
  _.assert( arguments.length === 1 );

  result
  .thenKeep( function( arg )
  {
    _.assert( stage.output === null )
    return stage.strategy.proceedThen( stage );
  })
  .thenKeep( function( arg )
  {
    _.assert( _.strIs( stage.data ) );
    _.assert( stage.error === null );
    _.assert( stage.output === null );
    return stage;
  })

  return result;
}

strategyProceed.defaults =
{
  input : null,
  output : null,
  strategy : null,
  strategyIndex : null,
}

//

function sizeReport( o )
{
  let single = this;
  let multiple = single.multiple;
  let sys = multiple.sys;
  let logger = multiple.logger;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;
  let con = _.Consequence();

  if( !_.object.isBasic( o ) )
  o = { output : o };

  _.routine.options_( sizeReport, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !multiple.sizeReporting || multiple.verbosity < 4 )
  return _.time.out( 1 );

  let inputSize = 0;
  if( o.input )
  inputSize = o.input.length;
  else
  inputSize = fileProvider.filesSize( multiple.inPath );

  function _format( size ){ return ( size / 1024 ).toFixed( 2 ); };
  let format = _.strMetricFormatBytes || _format;

  if( !Zlib )
  Zlib = require( 'zlib' );
  Zlib.gzip( o.output, function( err, buffer )
  {

    let outputSize = _.entity.sizeOf( o.output );
    let gzipSize = _.entity.sizeOf( buffer );

    single.sizeReportLast = 'Compression factor : ' + format( inputSize ) + ' / ' + format( outputSize ) + ' / ' + format( gzipSize );

    con.take( null );
  });

  return con;
}

sizeReport.defaults =
{
  input : null,
  output : null,
}

//

function tempPathFor( name )
{
  let single = this;
  let multiple = single.multiple;
  let sys = single.sys;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;

  let result = path.join( multiple.tempPath, path.joinNames( single.name, name ) );

  return result;
}

//

function tempWrite( o )
{
  let single = this;
  let multiple = single.multiple;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;

  if( !multiple.writingTempFiles || !multiple.tempPath )
  return;

  if( arguments.length === 2 )
  {
    o = { name : arguments[ 0 ], data : arguments[ 1 ] }
  }

  o.verbosity = multiple.verbosity-4;

  _.assert( o.postfix === undefined || _.strIs( o.postfix ) );
  _.assert( arguments.length === 1 );

  o.filePath = path.join( multiple.tempPath, o.filePath )

  _.routine.options_( tempWrite, o );

  fileProvider.fileWrite( o );

}

var defaults = tempWrite.defaults = Object.create( _.FileProvider.Partial.prototype.fileWrite.defaults );

defaults.data = null;
defaults.makingDirectory = 1;
defaults.purging = 1;

//

function concatenatorFor()
{
  let single = this;
  let sys = single.sys;
  let multiple = single.multiple;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;
  let concatenator = null;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !_.props.keys( single.dataMap ).length )
  return concatenator;

  let prevPath;
  for( let inPath in single.dataMap )
  {
    let ext = path.ext( inPath );
    let concatenator2 = sys.extToConcatenatorMap[ ext ];
    _.assert( !!concatenator2, () => 'No concatenator for extension ' + _.strQuote( ext ) );
    _.assert
    (
      concatenator === null || concatenator === concatenator2,
      () => 'Found more than single concatenator\n'
            + concatenator.qualifiedName + ' for ' + prevPath + '\n'
            + concatenator2.qualifiedName + ' for ' + inPath + '\n'
    );
    concatenator = concatenator2;
    prevPath = inPath;
  }

  _.assert( concatenator instanceof _.trs.concatenator.Abstract, 'Found none concatenator' );

  return concatenator;
}

//

function concatenate()
{
  let single = this;
  let sys = single.sys;
  let multiple = single.multiple;
  const fileProvider = multiple.fileProvider;
  const path = fileProvider.path;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !single.concatenator )
  single.concatenator = single.concatenatorFor();

  if( single.concatenator )
  {
    let result = single.concatenator.perform( single );
    return result;
  }

  return '';
}

// //
//
// function codeJoin( files )
// {
//   let result = '';
//   let prefix = '// ======================================\n( function() {\n';
//   let postfix = '\n})();\n';
//
//   _.assert( _.arrayIs( files ) );
//   _.assert( arguments.length === 1 );
//
//   if( files.length > 1 )
//   result += prefix + files.join( postfix + prefix ) + postfix;
//   else
//   result += files[ 0 ];
//
//   return result;
// }

// --
// relations
// --

let Composes =
{

  name : null,
  outPath : null,
  sourceMapPath : null,

}

let Aggregates =
{
}

let Associates =
{
  sys : null,
  multiple : null,
  dataMap : null,
  input : null,
  output : null,
  concatenator : null,
}

let Restricts =
{
  formed : 0,
  errors : null,
  sizeReportLast : '',
}

let Forbids =
{

  inputFilesPaths : 'inputFilesPaths',
  outputFilePath : 'outputFilePath',
  input : 'input',
  output : 'output',
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
  strategies : 'strategies',
  fileProvider : 'fileProvider',
  logger : 'logger',
  debug : 'debug',
  optimization : 'optimization',
  minification : 'minification',
  beautifing : 'beautifing',
  writingTempFiles : 'writingTempFiles',
  sizeReporting : 'sizeReporting',
  inPath : 'inPath',
  outPath : 'outPath',
  tempPath : 'temp.tmp',
  mapFilePath : 'mapFilePath',
  dstPath : 'dstPath',
  session : 'session',
  verbosity : 'verbosity',
  onBegin : 'onBegin',
  onEnd : 'onEnd',

}

let Accessors =
{
}

// --
// prototype
// --

let Proto =
{

  finit,
  init,

  form,
  perform,
  strategyProceed,
  sizeReport,

  tempPathFor,
  tempWrite,

  concatenatorFor,
  concatenate,

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

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_.trs[ Self.shortName ] = Self;

// _.staticDeclare
// ({
//   prototype : _.trs.System.prototype,
//   name : Self.shortName,
//   value : Self,
// });

})();
