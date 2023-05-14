
  var Module = typeof Module !== 'undefined' ? Module : {};
  
  if (!Module.expectedDataFileDownloads) {
    Module.expectedDataFileDownloads = 0;
  }
  Module.expectedDataFileDownloads++;
  (function() {
   var loadPackage = function(metadata) {
  
      var PACKAGE_PATH;
      if (typeof window === 'object') {
        PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
      } else if (typeof location !== 'undefined') {
        // worker
        PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
      } else {
        throw 'using preloaded data can only be done on a web page or in a web worker';
      }
      var PACKAGE_NAME = 'pythonhome.data';
      var REMOTE_PACKAGE_BASE = 'pythonhome.data';
      if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
        Module['locateFile'] = Module['locateFilePackage'];
        err('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
      }
      var REMOTE_PACKAGE_NAME = Module['locateFile'] ? Module['locateFile'](REMOTE_PACKAGE_BASE, '') : REMOTE_PACKAGE_BASE;
    
      var REMOTE_PACKAGE_SIZE = metadata['remote_package_size'];
      var PACKAGE_UUID = metadata['package_uuid'];
    
      function fetchRemotePackage(packageName, packageSize, callback, errback) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', packageName, true);
        xhr.responseType = 'arraybuffer';
        xhr.onprogress = function(event) {
          var url = packageName;
          var size = packageSize;
          if (event.total) size = event.total;
          if (event.loaded) {
            if (!xhr.addedTotal) {
              xhr.addedTotal = true;
              if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
              Module.dataFileDownloads[url] = {
                loaded: event.loaded,
                total: size
              };
            } else {
              Module.dataFileDownloads[url].loaded = event.loaded;
            }
            var total = 0;
            var loaded = 0;
            var num = 0;
            for (var download in Module.dataFileDownloads) {
            var data = Module.dataFileDownloads[download];
              total += data.total;
              loaded += data.loaded;
              num++;
            }
            total = Math.ceil(total * Module.expectedDataFileDownloads/num);
            if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
          } else if (!Module.dataFileDownloads) {
            if (Module['setStatus']) Module['setStatus']('Downloading data...');
          }
        };
        xhr.onerror = function(event) {
          throw new Error("NetworkError for: " + packageName);
        }
        xhr.onload = function(event) {
          if (xhr.status == 200 || xhr.status == 304 || xhr.status == 206 || (xhr.status == 0 && xhr.response)) { // file URLs can return 0
            var packageData = xhr.response;
            callback(packageData);
          } else {
            throw new Error(xhr.statusText + " : " + xhr.responseURL);
          }
        };
        xhr.send(null);
      };

      function handleError(error) {
        console.error('package error:', error);
      };
    
    function runWithFS() {
  
      function assert(check, msg) {
        if (!check) throw msg + new Error().stack;
      }
  Module['FS_createPath']("/", "lib", true, true);
Module['FS_createPath']("/lib", "python2.7", true, true);
Module['FS_createPath']("/lib/python2.7", "logging", true, true);
Module['FS_createPath']("/lib/python2.7", "importlib", true, true);
Module['FS_createPath']("/lib/python2.7", "xml", true, true);
Module['FS_createPath']("/lib/python2.7/xml", "etree", true, true);
Module['FS_createPath']("/lib/python2.7/xml", "parsers", true, true);
Module['FS_createPath']("/lib/python2.7", "email", true, true);
Module['FS_createPath']("/lib/python2.7", "json", true, true);
Module['FS_createPath']("/lib/python2.7", "encodings", true, true);

          /** @constructor */
          function DataRequest(start, end, audio) {
            this.start = start;
            this.end = end;
            this.audio = audio;
          }
          DataRequest.prototype = {
            requests: {},
            open: function(mode, name) {
              this.name = name;
              this.requests[name] = this;
              Module['addRunDependency']('fp ' + this.name);
            },
            send: function() {},
            onload: function() {
              var byteArray = this.byteArray.subarray(this.start, this.end);
              this.finish(byteArray);
            },
            finish: function(byteArray) {
              var that = this;
      
          Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
          Module['removeRunDependency']('fp ' + that.name);
  
              this.requests[this.name] = null;
            }
          };
      
              var files = metadata['files'];
              for (var i = 0; i < files.length; ++i) {
                new DataRequest(files[i]['start'], files[i]['end'], files[i]['audio']).open('GET', files[i]['filename']);
              }
      
        
        var indexedDB;
        if (typeof window === 'object') {
          indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
        } else if (typeof location !== 'undefined') {
          // worker
          indexedDB = self.indexedDB;
        } else {
          throw 'using IndexedDB to cache data can only be done on a web page or in a web worker';
        }
        var IDB_RO = "readonly";
        var IDB_RW = "readwrite";
        var DB_NAME = "EM_PRELOAD_CACHE";
        var DB_VERSION = 1;
        var METADATA_STORE_NAME = 'METADATA';
        var PACKAGE_STORE_NAME = 'PACKAGES';
        function openDatabase(callback, errback) {
          try {
            var openRequest = indexedDB.open(DB_NAME, DB_VERSION);
          } catch (e) {
            return errback(e);
          }
          openRequest.onupgradeneeded = function(event) {
            var db = event.target.result;

            if(db.objectStoreNames.contains(PACKAGE_STORE_NAME)) {
              db.deleteObjectStore(PACKAGE_STORE_NAME);
            }
            var packages = db.createObjectStore(PACKAGE_STORE_NAME);

            if(db.objectStoreNames.contains(METADATA_STORE_NAME)) {
              db.deleteObjectStore(METADATA_STORE_NAME);
            }
            var metadata = db.createObjectStore(METADATA_STORE_NAME);
          };
          openRequest.onsuccess = function(event) {
            var db = event.target.result;
            callback(db);
          };
          openRequest.onerror = function(error) {
            errback(error);
          };
        };

        // This is needed as chromium has a limit on per-entry files in IndexedDB
        // https://cs.chromium.org/chromium/src/content/renderer/indexed_db/webidbdatabase_impl.cc?type=cs&sq=package:chromium&g=0&l=177
        // https://cs.chromium.org/chromium/src/out/Debug/gen/third_party/blink/public/mojom/indexeddb/indexeddb.mojom.h?type=cs&sq=package:chromium&g=0&l=60
        // We set the chunk size to 64MB to stay well-below the limit
        var CHUNK_SIZE = 64 * 1024 * 1024;

        function cacheRemotePackage(
          db,
          packageName,
          packageData,
          packageMeta,
          callback,
          errback
        ) {
          var transactionPackages = db.transaction([PACKAGE_STORE_NAME], IDB_RW);
          var packages = transactionPackages.objectStore(PACKAGE_STORE_NAME);
          var chunkSliceStart = 0;
          var nextChunkSliceStart = 0;
          var chunkCount = Math.ceil(packageData.byteLength / CHUNK_SIZE);
          var finishedChunks = 0;
          for (var chunkId = 0; chunkId < chunkCount; chunkId++) {
            nextChunkSliceStart += CHUNK_SIZE;
            var putPackageRequest = packages.put(
              packageData.slice(chunkSliceStart, nextChunkSliceStart),
              'package/' + packageName + '/' + chunkId
            );
            chunkSliceStart = nextChunkSliceStart;
            putPackageRequest.onsuccess = function(event) {
              finishedChunks++;
              if (finishedChunks == chunkCount) {
                var transaction_metadata = db.transaction(
                  [METADATA_STORE_NAME],
                  IDB_RW
                );
                var metadata = transaction_metadata.objectStore(METADATA_STORE_NAME);
                var putMetadataRequest = metadata.put(
                  {
                    'uuid': packageMeta.uuid,
                    'chunkCount': chunkCount
                  },
                  'metadata/' + packageName
                );
                putMetadataRequest.onsuccess = function(event) {
                  callback(packageData);
                };
                putMetadataRequest.onerror = function(error) {
                  errback(error);
                };
              }
            };
            putPackageRequest.onerror = function(error) {
              errback(error);
            };
          }
        }

        /* Check if there's a cached package, and if so whether it's the latest available */
        function checkCachedPackage(db, packageName, callback, errback) {
          var transaction = db.transaction([METADATA_STORE_NAME], IDB_RO);
          var metadata = transaction.objectStore(METADATA_STORE_NAME);
          var getRequest = metadata.get('metadata/' + packageName);
          getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (!result) {
              return callback(false, null);
            } else {
              return callback(PACKAGE_UUID === result['uuid'], result);
            }
          };
          getRequest.onerror = function(error) {
            errback(error);
          };
        }

        function fetchCachedPackage(db, packageName, metadata, callback, errback) {
          var transaction = db.transaction([PACKAGE_STORE_NAME], IDB_RO);
          var packages = transaction.objectStore(PACKAGE_STORE_NAME);

          var chunksDone = 0;
          var totalSize = 0;
          var chunkCount = metadata['chunkCount'];
          var chunks = new Array(chunkCount);

          for (var chunkId = 0; chunkId < chunkCount; chunkId++) {
            var getRequest = packages.get('package/' + packageName + '/' + chunkId);
            getRequest.onsuccess = function(event) {
              // If there's only 1 chunk, there's nothing to concatenate it with so we can just return it now
              if (chunkCount == 1) {
                callback(event.target.result);
              } else {
                chunksDone++;
                totalSize += event.target.result.byteLength;
                chunks.push(event.target.result);
                if (chunksDone == chunkCount) {
                  if (chunksDone == 1) {
                    callback(event.target.result);
                  } else {
                    var tempTyped = new Uint8Array(totalSize);
                    var byteOffset = 0;
                    for (var chunkId in chunks) {
                      var buffer = chunks[chunkId];
                      tempTyped.set(new Uint8Array(buffer), byteOffset);
                      byteOffset += buffer.byteLength;
                      buffer = undefined;
                    }
                    chunks = undefined;
                    callback(tempTyped.buffer);
                    tempTyped = undefined;
                  }
                }
              }
            };
            getRequest.onerror = function(error) {
              errback(error);
            };
          }
        }
      
      function processPackageData(arrayBuffer) {
        assert(arrayBuffer, 'Loading data file failed.');
        assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
        var byteArray = new Uint8Array(arrayBuffer);
        var curr;
        
          // Reuse the bytearray from the XHR as the source for file reads.
          DataRequest.prototype.byteArray = byteArray;
    
            var files = metadata['files'];
            for (var i = 0; i < files.length; ++i) {
              DataRequest.prototype.requests[files[i].filename].onload();
            }
                Module['removeRunDependency']('datafile_pythonhome.data');

      };
      Module['addRunDependency']('datafile_pythonhome.data');
    
      if (!Module.preloadResults) Module.preloadResults = {};
    
        function preloadFallback(error) {
          console.error(error);
          console.error('falling back to default preload behavior');
          fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, processPackageData, handleError);
        };

        openDatabase(
          function(db) {
            checkCachedPackage(db, PACKAGE_PATH + PACKAGE_NAME,
              function(useCached, metadata) {
                Module.preloadResults[PACKAGE_NAME] = {fromCache: useCached};
                if (useCached) {
                  fetchCachedPackage(db, PACKAGE_PATH + PACKAGE_NAME, metadata, processPackageData, preloadFallback);
                } else {
                  fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE,
                    function(packageData) {
                      cacheRemotePackage(db, PACKAGE_PATH + PACKAGE_NAME, packageData, {uuid:PACKAGE_UUID}, processPackageData,
                        function(error) {
                          console.error(error);
                          processPackageData(packageData);
                        });
                    }
                  , preloadFallback);
                }
              }
            , preloadFallback);
          }
        , preloadFallback);

        if (Module['setStatus']) Module['setStatus']('Downloading...');
      
    }
    if (Module['calledRun']) {
      runWithFS();
    } else {
      if (!Module['preRun']) Module['preRun'] = [];
      Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
    }
  
   }
   loadPackage({"files": [{"filename": "/lib/python2.7/zipfile.pyo", "start": 0, "end": 36622, "audio": 0}, {"filename": "/lib/python2.7/genericpath.pyo", "start": 36622, "end": 39218, "audio": 0}, {"filename": "/lib/python2.7/quopri.pyo", "start": 39218, "end": 44628, "audio": 0}, {"filename": "/lib/python2.7/atexit.pyo", "start": 44628, "end": 46195, "audio": 0}, {"filename": "/lib/python2.7/repr.pyo", "start": 46195, "end": 51382, "audio": 0}, {"filename": "/lib/python2.7/getopt.pyo", "start": 51382, "end": 55374, "audio": 0}, {"filename": "/lib/python2.7/UserDict.pyo", "start": 55374, "end": 64719, "audio": 0}, {"filename": "/lib/python2.7/UserList.pyo", "start": 64719, "end": 71002, "audio": 0}, {"filename": "/lib/python2.7/tempfile.pyo", "start": 71002, "end": 85930, "audio": 0}, {"filename": "/lib/python2.7/optparse.pyo", "start": 85930, "end": 126465, "audio": 0}, {"filename": "/lib/python2.7/sre_compile.pyo", "start": 126465, "end": 138723, "audio": 0}, {"filename": "/lib/python2.7/chunk.pyo", "start": 138723, "end": 142093, "audio": 0}, {"filename": "/lib/python2.7/fnmatch.pyo", "start": 142093, "end": 144440, "audio": 0}, {"filename": "/lib/python2.7/keyword.pyo", "start": 144440, "end": 146257, "audio": 0}, {"filename": "/lib/python2.7/Cookie.pyo", "start": 146257, "end": 161468, "audio": 0}, {"filename": "/lib/python2.7/mimetypes.pyo", "start": 161468, "end": 173832, "audio": 0}, {"filename": "/lib/python2.7/pstats.pyo", "start": 173832, "end": 196095, "audio": 0}, {"filename": "/lib/python2.7/dummy_threading.pyo", "start": 196095, "end": 196997, "audio": 0}, {"filename": "/lib/python2.7/re.pyo", "start": 196997, "end": 203568, "audio": 0}, {"filename": "/lib/python2.7/platform.pyo", "start": 203568, "end": 231338, "audio": 0}, {"filename": "/lib/python2.7/shutil.pyo", "start": 231338, "end": 244799, "audio": 0}, {"filename": "/lib/python2.7/gettext.pyo", "start": 244799, "end": 261827, "audio": 0}, {"filename": "/lib/python2.7/inspect.pyo", "start": 261827, "end": 286737, "audio": 0}, {"filename": "/lib/python2.7/traceback.pyo", "start": 286737, "end": 294167, "audio": 0}, {"filename": "/lib/python2.7/webbrowser.pyo", "start": 294167, "end": 312143, "audio": 0}, {"filename": "/lib/python2.7/_abcoll.pyo", "start": 312143, "end": 332337, "audio": 0}, {"filename": "/lib/python2.7/StringIO.pyo", "start": 332337, "end": 338631, "audio": 0}, {"filename": "/lib/python2.7/shlex.pyo", "start": 338631, "end": 345619, "audio": 0}, {"filename": "/lib/python2.7/tarfile.pyo", "start": 345619, "end": 406213, "audio": 0}, {"filename": "/lib/python2.7/sysconfig.pyo", "start": 406213, "end": 421097, "audio": 0}, {"filename": "/lib/python2.7/linecache.pyo", "start": 421097, "end": 423734, "audio": 0}, {"filename": "/lib/python2.7/nturl2path.pyo", "start": 423734, "end": 425199, "audio": 0}, {"filename": "/lib/python2.7/copy.pyo", "start": 425199, "end": 434794, "audio": 0}, {"filename": "/lib/python2.7/hmac.pyo", "start": 434794, "end": 437685, "audio": 0}, {"filename": "/lib/python2.7/tokenize.pyo", "start": 437685, "end": 448932, "audio": 0}, {"filename": "/lib/python2.7/rfc822.pyo", "start": 448932, "end": 469941, "audio": 0}, {"filename": "/lib/python2.7/colorsys.pyo", "start": 469941, "end": 473273, "audio": 0}, {"filename": "/lib/python2.7/commands.pyo", "start": 473273, "end": 474952, "audio": 0}, {"filename": "/lib/python2.7/__future__.pyo", "start": 474952, "end": 477152, "audio": 0}, {"filename": "/lib/python2.7/stat.pyo", "start": 477152, "end": 479707, "audio": 0}, {"filename": "/lib/python2.7/sunau.pyo", "start": 479707, "end": 493224, "audio": 0}, {"filename": "/lib/python2.7/gzip.pyo", "start": 493224, "end": 505528, "audio": 0}, {"filename": "/lib/python2.7/struct.pyo", "start": 505528, "end": 505761, "audio": 0}, {"filename": "/lib/python2.7/cookielib.pyo", "start": 505761, "end": 546043, "audio": 0}, {"filename": "/lib/python2.7/functools.pyo", "start": 546043, "end": 551378, "audio": 0}, {"filename": "/lib/python2.7/heapq.pyo", "start": 551378, "end": 562864, "audio": 0}, {"filename": "/lib/python2.7/cProfile.pyo", "start": 562864, "end": 567988, "audio": 0}, {"filename": "/lib/python2.7/stringprep.pyo", "start": 567988, "end": 582057, "audio": 0}, {"filename": "/lib/python2.7/argparse.pyo", "start": 582057, "end": 636665, "audio": 0}, {"filename": "/lib/python2.7/types.pyo", "start": 636665, "end": 639184, "audio": 0}, {"filename": "/lib/python2.7/hashlib.pyo", "start": 639184, "end": 645534, "audio": 0}, {"filename": "/lib/python2.7/_sysconfigdata.pyo", "start": 645534, "end": 645678, "audio": 0}, {"filename": "/lib/python2.7/textwrap.pyo", "start": 645678, "end": 651270, "audio": 0}, {"filename": "/lib/python2.7/numbers.pyo", "start": 651270, "end": 660816, "audio": 0}, {"filename": "/lib/python2.7/sre_constants.pyo", "start": 660816, "end": 666925, "audio": 0}, {"filename": "/lib/python2.7/Queue.pyo", "start": 666925, "end": 673031, "audio": 0}, {"filename": "/lib/python2.7/codecs.pyo", "start": 673031, "end": 693165, "audio": 0}, {"filename": "/lib/python2.7/warnings.pyo", "start": 693165, "end": 703368, "audio": 0}, {"filename": "/lib/python2.7/string.pyo", "start": 703368, "end": 716056, "audio": 0}, {"filename": "/lib/python2.7/ast.pyo", "start": 716056, "end": 723241, "audio": 0}, {"filename": "/lib/python2.7/base64.pyo", "start": 723241, "end": 730863, "audio": 0}, {"filename": "/lib/python2.7/urlparse.pyo", "start": 730863, "end": 741843, "audio": 0}, {"filename": "/lib/python2.7/compileall.pyo", "start": 741843, "end": 747165, "audio": 0}, {"filename": "/lib/python2.7/os.pyo", "start": 747165, "end": 762164, "audio": 0}, {"filename": "/lib/python2.7/opcode.pyo", "start": 762164, "end": 768133, "audio": 0}, {"filename": "/lib/python2.7/collections.pyo", "start": 768133, "end": 785638, "audio": 0}, {"filename": "/lib/python2.7/mimetools.pyo", "start": 785638, "end": 792953, "audio": 0}, {"filename": "/lib/python2.7/difflib.pyo", "start": 792953, "end": 820586, "audio": 0}, {"filename": "/lib/python2.7/UserString.pyo", "start": 820586, "end": 834189, "audio": 0}, {"filename": "/lib/python2.7/socket.pyo", "start": 834189, "end": 846990, "audio": 0}, {"filename": "/lib/python2.7/calendar.pyo", "start": 846990, "end": 869778, "audio": 0}, {"filename": "/lib/python2.7/uu.pyo", "start": 869778, "end": 873903, "audio": 0}, {"filename": "/lib/python2.7/cmd.pyo", "start": 873903, "end": 882186, "audio": 0}, {"filename": "/lib/python2.7/random.pyo", "start": 882186, "end": 899089, "audio": 0}, {"filename": "/lib/python2.7/dummy_thread.pyo", "start": 899089, "end": 902166, "audio": 0}, {"filename": "/lib/python2.7/dis.pyo", "start": 902166, "end": 907772, "audio": 0}, {"filename": "/lib/python2.7/copy_reg.pyo", "start": 907772, "end": 912131, "audio": 0}, {"filename": "/lib/python2.7/weakref.pyo", "start": 912131, "end": 925583, "audio": 0}, {"filename": "/lib/python2.7/decimal.pyo", "start": 925583, "end": 1017471, "audio": 0}, {"filename": "/lib/python2.7/site.pyo", "start": 1017471, "end": 1030958, "audio": 0}, {"filename": "/lib/python2.7/bisect.pyo", "start": 1030958, "end": 1032689, "audio": 0}, {"filename": "/lib/python2.7/ntpath.pyo", "start": 1032689, "end": 1042689, "audio": 0}, {"filename": "/lib/python2.7/sre_parse.pyo", "start": 1042689, "end": 1063573, "audio": 0}, {"filename": "/lib/python2.7/urllib.pyo", "start": 1063573, "end": 1106728, "audio": 0}, {"filename": "/lib/python2.7/_strptime.pyo", "start": 1106728, "end": 1118472, "audio": 0}, {"filename": "/lib/python2.7/locale.pyo", "start": 1118472, "end": 1170276, "audio": 0}, {"filename": "/lib/python2.7/io.pyo", "start": 1170276, "end": 1172344, "audio": 0}, {"filename": "/lib/python2.7/pickle.pyo", "start": 1172344, "end": 1205571, "audio": 0}, {"filename": "/lib/python2.7/token.pyo", "start": 1205571, "end": 1209299, "audio": 0}, {"filename": "/lib/python2.7/urllib2.pyo", "start": 1209299, "end": 1248743, "audio": 0}, {"filename": "/lib/python2.7/cgi.pyo", "start": 1248743, "end": 1271928, "audio": 0}, {"filename": "/lib/python2.7/wave.pyo", "start": 1271928, "end": 1285497, "audio": 0}, {"filename": "/lib/python2.7/uuid.pyo", "start": 1285497, "end": 1301685, "audio": 0}, {"filename": "/lib/python2.7/abc.pyo", "start": 1301685, "end": 1305489, "audio": 0}, {"filename": "/lib/python2.7/py_compile.pyo", "start": 1305489, "end": 1308681, "audio": 0}, {"filename": "/lib/python2.7/posixpath.pyo", "start": 1308681, "end": 1317285, "audio": 0}, {"filename": "/lib/python2.7/glob.pyo", "start": 1317285, "end": 1319581, "audio": 0}, {"filename": "/lib/python2.7/imghdr.pyo", "start": 1319581, "end": 1323952, "audio": 0}, {"filename": "/lib/python2.7/_weakrefset.pyo", "start": 1323952, "end": 1333342, "audio": 0}, {"filename": "/lib/python2.7/contextlib.pyo", "start": 1333342, "end": 1336346, "audio": 0}, {"filename": "/lib/python2.7/logging/__init__.pyo", "start": 1336346, "end": 1368501, "audio": 0}, {"filename": "/lib/python2.7/importlib/__init__.pyo", "start": 1368501, "end": 1369631, "audio": 0}, {"filename": "/lib/python2.7/xml/__init__.pyo", "start": 1369631, "end": 1370175, "audio": 0}, {"filename": "/lib/python2.7/xml/etree/__init__.pyo", "start": 1370175, "end": 1370298, "audio": 0}, {"filename": "/lib/python2.7/xml/etree/ElementTree.pyo", "start": 1370298, "end": 1404405, "audio": 0}, {"filename": "/lib/python2.7/xml/etree/ElementPath.pyo", "start": 1404405, "end": 1411873, "audio": 0}, {"filename": "/lib/python2.7/xml/parsers/__init__.pyo", "start": 1411873, "end": 1412000, "audio": 0}, {"filename": "/lib/python2.7/xml/parsers/expat.pyo", "start": 1412000, "end": 1412207, "audio": 0}, {"filename": "/lib/python2.7/email/base64mime.pyo", "start": 1412207, "end": 1414436, "audio": 0}, {"filename": "/lib/python2.7/json/encoder.pyo", "start": 1414436, "end": 1423239, "audio": 0}, {"filename": "/lib/python2.7/json/__init__.pyo", "start": 1423239, "end": 1426015, "audio": 0}, {"filename": "/lib/python2.7/json/decoder.pyo", "start": 1426015, "end": 1433670, "audio": 0}, {"filename": "/lib/python2.7/json/scanner.pyo", "start": 1433670, "end": 1435837, "audio": 0}, {"filename": "/lib/python2.7/encodings/raw_unicode_escape.pyo", "start": 1435837, "end": 1437844, "audio": 0}, {"filename": "/lib/python2.7/encodings/zlib_codec.pyo", "start": 1437844, "end": 1441289, "audio": 0}, {"filename": "/lib/python2.7/encodings/ascii.pyo", "start": 1441289, "end": 1443356, "audio": 0}, {"filename": "/lib/python2.7/encodings/__init__.pyo", "start": 1443356, "end": 1446177, "audio": 0}, {"filename": "/lib/python2.7/encodings/utf_32_be.pyo", "start": 1446177, "end": 1447985, "audio": 0}, {"filename": "/lib/python2.7/encodings/latin_1.pyo", "start": 1447985, "end": 1450080, "audio": 0}, {"filename": "/lib/python2.7/encodings/hex_codec.pyo", "start": 1450080, "end": 1452654, "audio": 0}, {"filename": "/lib/python2.7/encodings/aliases.pyo", "start": 1452654, "end": 1460821, "audio": 0}, {"filename": "/lib/python2.7/encodings/unicode_escape.pyo", "start": 1460821, "end": 1462780, "audio": 0}, {"filename": "/lib/python2.7/encodings/utf_16_be.pyo", "start": 1462780, "end": 1464588, "audio": 0}, {"filename": "/lib/python2.7/encodings/utf_8.pyo", "start": 1464588, "end": 1466352, "audio": 0}, {"filename": "/lib/python2.7/encodings/cp437.pyo", "start": 1466352, "end": 1474253, "audio": 0}, {"filename": "/lib/python2.7/encodings/string_escape.pyo", "start": 1474253, "end": 1476186, "audio": 0}, {"filename": "/lib/python2.7/encodings/utf_16_le.pyo", "start": 1476186, "end": 1477994, "audio": 0}, {"filename": "/lib/python2.7/encodings/utf_16.pyo", "start": 1477994, "end": 1482927, "audio": 0}, {"filename": "/lib/python2.7/encodings/mbcs.pyo", "start": 1482927, "end": 1484681, "audio": 0}, {"filename": "/lib/python2.7/encodings/base64_codec.pyo", "start": 1484681, "end": 1487305, "audio": 0}, {"filename": "/lib/python2.7/encodings/idna.pyo", "start": 1487305, "end": 1493625, "audio": 0}], "remote_package_size": 1493625, "package_uuid": "096c2b05-3076-430e-a184-a50934179666"});
  
  })();
  