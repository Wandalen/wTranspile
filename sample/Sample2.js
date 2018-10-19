
let _ = require( 'wTools' );
let Ts = require( 'wtranspilationstrategy' );
let ts = new Ts().form();

let session = ts.session
({
  inputPath : __filename,
  outputPath : _.path.join( __dirname, '../temp.tmp/Sample.js' ),
  debug : 5,
  minification : 0,
  optimization : 0,
});

session.form().proceed()
.doThen( ( err ) =>
{
  if( err )
  _.errLogOnce( err );
});
