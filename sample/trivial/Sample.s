
require( 'wtranspile' );
let _ = wTools;

let ts = new _.trs.System().form();

let outDir = _.path.join( __dirname, '../temp.tmp/' );
let outPath = _.path.join( outDir, 'Sample.s' );

_.fileProvider.filesDelete( outDir );

let multiple = ts.multiple
({
  inPath : __filename,
  outPath,
});

return multiple.form().perform()
.finally( ( err, got ) =>
{
  _.fileProvider.filesDelete( outDir );
  if( err )
  _.errLogOnce( err );
  return got;
});
