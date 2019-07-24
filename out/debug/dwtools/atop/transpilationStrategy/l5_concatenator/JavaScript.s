( function _JavaScript_s_() {

'use strict';

//

let _ = wTools;
let Parent = _.TranspilationStrategy.Concatenator.Abstract;
let Self = function wTsTranspilerJavaScript( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'JavaScript';

// --
// routines
// --

function init()
{
  let self = Parent.prototype.init.apply( this, arguments );

  self.starter = new _.StarterMaker2();

  return self;
}

//

function _performAct( single )
{
  let self = this;
  let sys = self.sys;
  let result = '';
  let files = single.dataMap;
  let starter = self.starter;
  let multiple = single.multiple;
  let basePath = multiple.inputPath.basePaths[ 0 ];
  let entryPath = multiple.entryPath;
  let externalBeforePath = multiple.externalBeforePath;
  let externalAfterPath = multiple.externalAfterPath;

  _.assert( _.mapIs( files ) );
  _.assert( arguments.length === 1 );
  _.assert( single instanceof sys.Single );

  /* remove #! ... */

  if( self.removingShellPrologue )
  files = _.map( files, ( fileData, filePath ) =>
  {
    return starter.fileRemoveShellPrologue( filePath, fileData );
  });

  /* wrap */

  if( self.wrapping )
  files = _.map( files, ( fileData, filePath ) =>
  {
    if( multiple.simpleConcatenator || multiple.splittingStrategy === 'OneToOne' )
    return starter.fileWrapSimple
    ({
      filePath,
      basePath,
      fileData,
    });
    else
    return starter.fileWrap
    ({
      filePath,
      basePath,
      fileData,
    });
  });

  /* */

  result = _.mapVals( files ).join( '\n' );

  if( !multiple.simpleConcatenator && multiple.splittingStrategy !== 'OneToOne' )
  {
    let fixes = starter.filesFixesGet
    ({
      entryPath,
      basePath,
      externalBeforePath,
      externalAfterPath,
      outputPath : single.outputPath,
    });
    result = fixes.prefix + fixes.ware + result + fixes.externalBefore + fixes.entry + fixes.externalAfter + fixes.postfix;
  }

  return result;
}

//

function fileWrapSimple( o )
{
  let self = this;

  _.routineOptions( fileWrapSimple, arguments );

  let fileName = _.strVarNameFor( _.path.fullName( o.filePath ) );

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

// --
// relationships
// --

let Composes =
{
  ext : _.define.own([ 'js', 's', 'ss', '' ]),
  removingShellPrologue : 1,
  wrapping : 1,
  entryFilePath : null,
}

let Associates =
{
  starter : null,
}

let Restricts =
{
}

// --
// prototype
// --

let Proto =
{

  init,

  _performAct,

  fileWrapSimple,

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

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.TranspilationStrategy.Concatenator[ Self.shortName ] = Self;

})();
