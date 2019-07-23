( function _StarterMaker_s_() {

'use strict';

//

let StarterWare = require( './StarterWare.s' );
let _ = wTools;
let Parent = null
let Self = function wStarterMaker2( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'StarterMaker2';

// --
// routines
// --

function filesFixesGet( o )
{
  let self = this;
  let r = Object.create( null );
  r.prefix = '';
  r.ware = '';
  r.externalBefore = '';
  r.entry = '';
  r.externalAfter = '';
  r.postfix = '';
  Object.preventExtensions( r );

  _.routineOptions( filesFixesGet, arguments );

  if( o.entryPath )
  {
    _.assert( _.strIs( o.basePath ) );
    _.assert( _.strIs( o.entryPath ) || _.arrayIs( o.entryPath ) )
    o.entryPath = _.arrayAs( o.entryPath );
    o.entryPath = _.path.s.join( o.basePath, o.entryPath );
  }

  r.prefix =
`
( function _library_() { // begin of library
`

  r.ware =
`
( function _StarterWare_() { // begin of starterware

  // --
  // own
  // --

  ${_.routineParse( StarterWare.begin ).bodyUnwrapped};

  // --
  // imported
  // --

  ${gr( 'strIs' )}
  ${gr( '_strBeginOf' )}
  ${gr( '_strEndOf' )}
  ${gr( '_strRemovedBegin' )}
  ${gr( '_strRemovedEnd' )}
  ${gr( 'strBegins' )}
  ${gr( 'strEnds' )}
  ${gr( 'strRemoveBegin' )}
  ${gr( 'strRemoveEnd' )}
  ${gr( 'regexpIs' )}
  ${gr( 'longIs' )}
  ${gr( 'primitiveIs' )}
  ${pr( 'refine' )}
  ${pr( '_normalize' )}
  ${pr( 'canonizeTolerant' )}

  ${pfs()}

  // --
  // declare
  // --

  ${_.routineParse( StarterWare.end ).bodyUnwrapped};

})(); // end of starterware

let _libraryFilePath_ = _starter_.path.canonizeTolerant( __filename );
let _libraryDirPath_ = _starter_.path.canonizeTolerant( __dirname );

`

  r.postfix =
`
})() // == end of library
`

  /* entry */

  r.entry = '\n';
  if( o.entryPath )
  o.entryPath.forEach( ( entryPath ) =>
  {
    entryPath = _.path.relative( o.basePath, entryPath );
    r.entry += `module.exports = _starter_._fileInclude( _libraryDirPath_, './${entryPath}' );\n`;
  });

  /* external */

  r.externalBefore = '\n';
  if( o.externalBeforePath )
  o.externalBeforePath.forEach( ( externalPath ) =>
  {
    if( _.path.isAbsolute( externalPath ) )
    externalPath = _.path.dot( _.path.relative( _.path.dir( o.outputPath ), externalPath ) );
    r.externalBefore += `_starter_._fileInclude( _libraryDirPath_, '${externalPath}' );\n`;
  });

  r.externalAfter = '\n';
  if( o.externalAfterPath )
  o.externalAfterPath.forEach( ( externalPath ) =>
  {
    if( _.path.isAbsolute( externalPath ) )
    externalPath = _.path.dot( _.path.relative( _.path.dir( o.outputPath ), externalPath ) );
    r.externalAfter += `_starter_._fileInclude( _libraryDirPath_, '${externalPath}' );\n`;
  });

  /* */

  return r;

  function elementExport( srcContainer, dstContainerName, name )
  {
    let e = srcContainer[ name ];
    _.assert
    (
      _.routineIs( e ) || _.strIs( e ) || _.regexpIs( e ),
      () => 'Cant export ' + _.strQuote( name ) + ' is ' + _.strType( e )
    );
    let str = '';
    if( _.routineIs( e ) )
    str = e.toString();
    else
    str = _.toJs( e );
    let r = dstContainerName + '.' + name + ' = ' + _.strIndentation( str, '  ' ) + ';\n\n//\n';
    return r;
  }

  function gr( name )
  {
    return elementExport( _, '_', name );
  }

  function pr( name )
  {
    return elementExport( _.path, 'path', name );
  }

  function pfs( name )
  {
    let result = [];
    for( let f in _.path )
    {
      let e = _.path[ f ];
      if( _.strIs( e ) || _.regexpIs( e ) )
      result.push( pr( f ) );
    }
    return result.join( '  ' );
  }

}

filesFixesGet.defaults =
{
  basePath : null,
  entryPath : null,
  outputPath : null,
  externalBeforePath : null,
  externalAfterPath : null,
}

//

function fileFixesGet( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( fileFixesGet, arguments );

  let relativeFilePath = _.path.relative( o.basePath, o.filePath );
  let relativeDirPath = _.path.dir( relativeFilePath );
  let fileName = _.strVarNameFor( _.path.fullName( o.filePath ) );
  let fileNameNaked = fileName + '_naked';

  let prefix1 = `( function ${fileName}() { // == begin of file ${fileName}\n`;

  let prefix2 = `function ${fileNameNaked}() {\n`;

  let postfix2 = `};`;

  let ware =
`

  let _filePath_ = _starter_._pathResolve( _libraryDirPath_, '${relativeFilePath}' );
  let _dirPath_ = _starter_._pathResolve( _libraryDirPath_, '${relativeDirPath}' );
  let __filename = _filePath_;
  let __dirname = _dirPath_;
  let module = _starter_._fileCreate( _filePath_, _dirPath_, ${fileNameNaked} );
  let require = module.include;
  let include = module.include;
`

  let postfix1 =
`
})(); // == end of file ${fileName}
`

  let result = Object.create( null );
  result.prefix1 = prefix1;
  result.prefix2 = prefix2;
  result.ware = ware;
  result.postfix2 = postfix2;
  result.postfix1 = postfix1;
  return result;
}

fileFixesGet.defaults =
{
  filePath : null,
  basePath : null,
}

//

function fileWrap( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.routineOptions( fileWrap, arguments );
  let fixes = self.fileFixesGet({ filePath : o.filePath, basePath : o.basePath });
  let result = fixes.prefix1 + fixes.prefix2 + o.fileData + fixes.postfix2 + fixes.ware + fixes.postfix1;
  return result;
}

var defaults = fileWrap.defaults = Object.create( fileFixesGet.defaults );
defaults.fileData = null;

//

function fileWrapSimple( o )
{
  let self = this;

  _.routineOptions( fileWrapSimple, arguments );

  let fileName = _.strCamelize( _.path.fullName( o.filePath ) );

  let prefix = `( function ${fileName}() { // == begin of file ${fileName}\n`;

  let postfix =
`// == end of file ${fileName}
})();
`

  let result = prefix + o.fileData + postfix;

  return result;
}

fileWrapSimple.defaults =
{
  basePath : null,
  filePath : null,
  fileData : null,
}

//

function fileRemoveShellPrologue( filePath, fileData )
{
  let self = this;
  let splits = _.strSplitFast( fileData, /^\s*\#\![^\n]*\n/ );
  if( splits.length > 1 )
  return '// ' + splits[ 1 ] + splits[ 2 ];
  else
  return fileData;
}

// --
// relationships
// --

let Composes =
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

  filesFixesGet,
  fileFixesGet,
  fileWrap,
  fileWrapSimple,
  fileRemoveShellPrologue,

  /* */

  Composes,
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

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_[ Self.shortName ] = Self;

})();
