
require( 'wtranspile' );
let _ = wTools;

let ts = new _.trs.System().form();

let outPath = _.path.join( __dirname, '../temp.tmp/Sample.s' );

_.fileProvider.filesDelete( outPath );

let multiple = ts.multiple
({
  inPath : __filename,
  outPath,
});

return multiple.form().perform()
.finally( ( err, got ) =>
{
  _.fileProvider.filesDelete( outPath );
  if( err )
  _.errLogOnce( err );
  return got;
});
