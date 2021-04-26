( function _JavaScript_s_()
{

'use strict';

//

const _ = _global_.wTools;
const Parent = _.trs.concatenator.Abstract;
const Self = wTsConcatenatorJavaScript;
function wTsConcatenatorJavaScript( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'JavaScript';

// --
// implementation
// --

function init()
{
  let self = Parent.prototype.init.apply( this, arguments );
  self.starter = new _.starter.Maker();
  return self;
}

//

function _performAct( single )
{
  let self = this;
  let sys = self.sys;
  let result = '';
  let filesMap = single.dataMap;
  let starter = self.starter;
  let multiple = single.multiple;
  let basePath = multiple.inPath.basePaths[ 0 ];
  let entryPath = multiple.entryPath;
  let externalBeforePath = multiple.externalBeforePath;
  let externalAfterPath = multiple.externalAfterPath;

  _.assert( _.mapIs( filesMap ) );
  _.assert( arguments.length === 1 );
  _.assert( single instanceof _.trs.Single );

  /* wrap */

  if( multiple.simpleConcatenator || multiple.splittingStrategy === 'OneToOne' )
  {

    filesMap = _.map_( null, filesMap, ( fileData, filePath ) =>
    {
      return starter.sourceWrapSimple
      ({
        filePath,
        fileData,
        removingShellPrologue : self.removingShellPrologue,
      });
    });

    result = _.props.vals( filesMap ).join( '\n' );

  }
  else
  {

    debugger;
    result = starter.sourcesJoin
    ({
      outPath : single.outPath,
      entryPath,
      basePath,
      externalBeforePath,
      externalAfterPath,
      filesMap,
      removingShellPrologue : self.removingShellPrologue,
      withServer : 0,
    });

  }

  /* */

  return result;
}

//

function sourceWrapSimple( o )
{
  let self = this;

  _.routine.options_( sourceWrapSimple, arguments );

  let fileName = _.strVarNameFor( _.path.fullName( o.filePath ) );

  let prefix = `( function ${fileName}() { // == begin of file ${fileName}\n`;

  let postfix =
`// == end of file ${fileName}
})();
`

  let result = prefix + o.fileData + postfix;

  return result;
}

sourceWrapSimple.defaults =
{
  basePath : null,
  filePath : null,
  fileData : null,
}

// --
// relations
// --

let Composes =
{
  ext : _.define.own([ 'js', 's', 'ss' ]),
  removingShellPrologue : 1,
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

  sourceWrapSimple,

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

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_.trs.concatenator[ Self.shortName ] = Self;

})();
