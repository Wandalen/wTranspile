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

function _performAct( single )
{
  let self = this;
  let sys = self.sys;
  let result = '';
  let files = _.mapVals( single.dataMap );

  _.assert( _.arrayIs( files ) );
  _.assert( arguments.length === 1 );
  _.assert( single instanceof sys.Single );

  files = files.map( ( file ) =>
  {
    let splits = _.strSplitFast( file, /^\s*\#\![^\n]*\n/ );
    if( splits.length > 1 )
    return '// ' + splits[ 1 ] + splits[ 2 ];
    else
    return file;
  });

  if( files.length > 1 )
  result += self.prefix + files.join( self.postfix + self.prefix ) + self.postfix;
  else
  result += files[ 0 ];

  return result;
}

// --
// relationships
// --

let Composes =
{
  ext : _.define.own([ 'js', 's', 'ss', '' ]),
  prefix : '// ======================================\n( function() {\n',
  postfix : '\n})();\n',
  entry : null,
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

  _performAct,

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
