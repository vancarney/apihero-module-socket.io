'use strict';
global.app_root = __dirname;
// var engine    = require('apihero-module-browserify');
// var websock   = engine.browserify.browserify( null, {standalone:'Websock'});
var fs = require('fs');
var path = require('path');
var _ = require('lodash')._;
var pkg = require('./package.json');

// websock.add('apihero-socket.io-client.coffee');
// var p = fs.createWriteStream('src/built-js/websock.js');
// websock.bundle().pipe(p);
// 
// templates.add('build/templates.js');
// var p = fs.createWriteStream('src/built-js/templates.js');
// templates.bundle().pipe(p);

// fs.writeFileSync('src/built-js/jade.js', engine['jade-runtime']);

// files = fs.readdirSync(path.join( 'views' ));
// for (var i=0; i<files.length; i++) {
  // if ((stat = fs.statSync(_path = path.join( 'helpers', files[i] ))) != null) {
      // if (stat.isFile()) 
        // helpers.add(_path);
  // }
// }


/*
var processTemplate = function (fileName) {
    var options = {filename: fileName, };
  var inputString, result, refName, moduleBody;
    try {
      inputString = fs.readFileSync(fileName, 'utf8');
        result = jade.compileClientWithDependenciesTracked(inputString, options);
    } catch (e) {
        console.log("error", e);
        return;
    }

    result.dependencies.forEach(function (dep) {
        console.log("file", dep);
    });
    
  result.body = result.body.replace(/^(function)\stemplate/, '$1');
  refName = path.join(path.dirname(fileName), path.basename(fileName));
    moduleBody = "module.exports['"+refName+"'] = " + result.body + ";";
    return moduleBody;
};

var walkDir = function(dir) {
  var _path, stat, 
  files = fs.readdirSync( dir ),
  out = "var jade = require('../../scripts/jade-runtime.js')";
    
  for (var i=0; i<files.length; i++) {
    if ((stat = fs.statSync(_path = path.join( dir, files[i] ))) != null) {
        if (stat.isFile()) {
          out += "\n\n" + processTemplate( _path );
        }
        else {
          out += walkDir( path.join(dir, files[i]));
        }
    }
  }
  
  return out; 
};

var c_out = walkDir('views/_elements');
var p = fs.writeFileSync('src/built-js/tmp-templates.js', c_out);
*/

//templates.require('./views/_elements/typeahead-suggestion.jade');
//templates.require('./views/_elements/tag.jade');

// templates.transform( j ).bundle().pipe(p);

/*
templates.add('src/built-js/tmp-templates.js');
var p = fs.createWriteStream('src/built-js/templates.js');
templates.bundle().pipe(p);
*/

//
// Require some modules
//


var Mincer = require('mincer');


//
// Get Mincer environment
//


var environment = require('./environment');


//
// Create and compile Manifest
//


var manifest = new Mincer.Manifest(environment, './dist');


manifest.compile(['apihero-socket.io-client.js', 'apihero-socket.io-client.css'], function (err, assetsData) {
  if (err) {
    console.error("Failed compile assets: " + (err.message || err.toString()));
    process.exit(128);
  }

  console.info('\n\nAssets were successfully compiled.\n' +
               'Manifest data (a proper JSON) was written to:\n' +
               manifest.path + '\n\n');
  // console.dir(assetsData);
});