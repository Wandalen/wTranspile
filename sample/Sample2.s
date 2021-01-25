
let _ = require( 'wTools' );
require( 'wtranspile' );
let ts = new _.trs.System().form();

let outPath = _.path.join( __dirname, '../temp.tmp/Sample2.s' );

_.fileProvider.filesDelete( outPath )

let multiple = ts.multiple
({
  inPath : __filename,
  outPath,
  diagnosing : 5,
  minification : 0,
  optimization : 0,
  transpilingStrategy : [ 'Babel', 'Uglify', 'Babel' ],
});

return multiple.form().perform()
.finally( ( err, got ) =>
{
  _.fileProvider.filesDelete( outPath );
  if( err )
  _.errLogOnce( err );
  return got;
});
