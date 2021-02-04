
require( 'wtranspile' );

let _ = wTools;

/* */

let outPath = _.path.join( __dirname, './temp.tmp/Sample3.s' );
_.fileProvider.filesDelete( outPath )

let ts = new _.trs.System().form();
let multiple = ts.multiple
({
  inPath : __filename,
  outPath,
  transpilingStrategy : [ 'Uglify' ],
});

return multiple.form().perform()
.finally( ( err, got ) =>
{
  _.fileProvider.filesDelete( _.path.dir( outPath ) );
  if( err )
  _.errLogOnce( err );
  return got;
});
