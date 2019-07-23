( function _StarterWare_s_() {

'use strict';

let _ = wTools;

// debugger;
// let wasPrepareStackTrace = Error.prepareStackTrace;
// Error.prepareStackTrace = function( err, stack )
// {
//   debugger;
// }

// --
// routines
// --

function _StarterWareBegin_()
{

  let _global = undefined;
  if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
  if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
  if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
  if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
  let _realGlobal = _global._realGlobal_ = _global;
  let _wasGlobal = _global._global_ || _global;
  _global = _wasGlobal;
  _global._global_ = _wasGlobal;

  if( !_global_.Config )
  _global_.Config = {}
  if( _global_.Config.platform === undefined )
  _global_.Config.platform = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'nodejs' : 'browser';
  if( _global_.Config.isWorker === undefined )
  _global_.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

  if( _global._starter_ )
  return;

  let _nodejsInclude = require;
  let _nodejsResolve = require.resolve;
  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;
  let preloadedFilesMap = _starter_.preloadedFilesMap = _starter_.preloadedFilesMap || Object.create( null );
  let openedFilesMap = _starter_.openedFilesMap = _starter_.openedFilesMap || Object.create( null );
  let path = _starter_.path = _starter_.path || Object.create( null );

  //

  function ScriptFile( o )
  {
    if( !( this instanceof ScriptFile ) )
    return new ScriptFile( o );

    if( o.isScript === undefined )
    o.isScript = true;

    // o.filePath = _starter_._pathResolve( null, o.filePath );
    o.filePath = _starter_.path.canonizeTolerant( o.filePath );

    this.filePath = o.filePath;
    this.dirPath = o.dirPath;
    this.nakedCall = o.nakedCall;
    this.isScript = o.isScript;

    this.filename = o.filePath;
    this.exports = undefined;
    this.parent = null;
    this.error = null;
    this.state = o.nakedCall ? 'preloaded' : 'created';

    this.starter = _starter_;
    this.include = _starter_._fileInclude.bind( _starter_, this );
    this.resolve = _starter_._fileResolve.bind( _starter_, this );
    this.include.resolve = this.resolve;
    this.include.scriptFile = this;

    this._nodejsInclude = _nodejsInclude;
    this._nodejsResolve = _nodejsResolve;

    /* nodejs compatibility */

    this.path = [ '/' ];
    this.loaded = false;
    this.id = o.filePath;

    Object.preventExtensions( this );

    _starter_.preloadedFilesMap[ o.filePath ] = this;

    return this;
  }

  //

  function _pathResolve( scriptFile, filePath )
  {
    let basePath = null;
    if( _starter_.strIs( scriptFile ) )
    {
      basePath = scriptFile;
    }
    else if( scriptFile )
    {
      basePath = scriptFile.dirPath;
    }

    if( !basePath )
    {
      debugger;
      throw 'Base path is not specified';
    }

    filePath = _starter_.path.canonizeTolerant( filePath );
    if( filePath[ 0 ] !== '/' )
    filePath = _starter_.path.canonizeTolerant( basePath + '/' + filePath );
    return filePath;
  }

  //

  function _fileIncludeAct( parentScriptFile, childScriptFile )
  {
    try
    {

      if( childScriptFile.state === 'opened' )
      return childScriptFile.exports;

      childScriptFile.parent = parentScriptFile || null;
      childScriptFile.nakedCall.call( childScriptFile );
      childScriptFile.loaded = true;
      childScriptFile.state = 'opened';
      _starter_.openedFilesMap[ childScriptFile.filePath ] = childScriptFile;
    }
    catch( err )
    {
      err.message += '\nError including ' + childScriptFile.filePath;
      childScriptFile.error = err;
      childScriptFile.state = 'errored';
      throw err;
    }
    return childScriptFile.exports;
  }

  //

  function _fileInclude( parentScriptFile, filePath )
  {
    let childScriptFile = _starter_._fileGet.apply( this, arguments );

    let _nodejsInclude;
    if( _starter_.strIs( parentScriptFile ) )
    {
      _nodejsInclude = _starter_._nodejsInclude;
      parentScriptFile = null;
    }
    else if( parentScriptFile )
    {
      _nodejsInclude = parentScriptFile._nodejsInclude;
    }
    else
    {
      _nodejsInclude = _starter_._nodejsInclude;
    }

    if( !childScriptFile )
    return _nodejsInclude( filePath );
    if( _starter_.strIs( parentScriptFile ) )
    parentScriptFile = null;
    return _starter_._fileIncludeAct( parentScriptFile, childScriptFile );
  }

  //

  function _fileResolve( parentScriptFile, filePath )
  {
    let childScriptFile = _starter_._fileGet.apply( this, arguments );

    let _nodejsResolve;
    if( _starter_.strIs( parentScriptFile ) )
    {
      _nodejsResolve = _starter_._nodejsResolve;
      parentScriptFile = null;
    }
    else if( parentScriptFile )
    {
      _nodejsResolve = parentScriptFile._nodejsResolve;
    }
    else
    {
      _nodejsResolve = _starter_._nodejsResolve;
    }

    if( !childScriptFile )
    return _nodejsResolve( filePath );
    return childScriptFile.filePath;
  }

  //

  function _fileGet( parentScriptFile, filePath )
  {

    let basePath = null;
    if( _starter_.strIs( parentScriptFile ) )
    {
      basePath = parentScriptFile;
    }
    else if( parentScriptFile )
    {
      basePath = parentScriptFile.dirPath;
    }

    if( filePath[ 0 ] !== '.' )
    return null;

    resolvedFilePath = _starter_._pathResolve( basePath, filePath );
    let childScriptFile = _starter_.preloadedFilesMap[ resolvedFilePath ];
    if( childScriptFile )
    return childScriptFile;

    return null;
  }

  //

  function _fileCreate( filePath, dirPath, nakedCall )
  {
    let r = ScriptFile({ filePath, dirPath, nakedCall });
    return r;
  }

  //

  function assert()
  {
  }

  //

  function assertRoutineOptions()
  {
  }

}

// --
//
// --

function _StarterWareEnd_()
{

  //

  let Extend =
  {

    ScriptFile,

    _pathResolve,
    _nodejsInclude,

    _fileIncludeAct,
    _fileInclude,
    _fileResolve,
    _fileGet,
    _fileCreate,

    assert,
    assertRoutineOptions,

    path,

  }

  Object.assign( _starter_, Extend );

}

// --
//
// --

let Self =
{
  begin : _StarterWareBegin_,
  end : _StarterWareEnd_,
}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
