
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
      var PACKAGE_NAME = 'pyapp.data';
      var REMOTE_PACKAGE_BASE = 'pyapp.data';
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
  Module['FS_createPath']("/", "_dummy_thread", true, true);
Module['FS_createPath']("/", "http", true, true);
Module['FS_createPath']("/", "xmlrpc", true, true);
Module['FS_createPath']("/", "_thread", true, true);
Module['FS_createPath']("/", "libpasteurize", true, true);
Module['FS_createPath']("/libpasteurize", "fixes", true, true);
Module['FS_createPath']("/", "six-1.12.0.dist-info", true, true);
Module['FS_createPath']("/", "socketserver", true, true);
Module['FS_createPath']("/", "past", true, true);
Module['FS_createPath']("/past", "builtins", true, true);
Module['FS_createPath']("/past", "types", true, true);
Module['FS_createPath']("/past", "utils", true, true);
Module['FS_createPath']("/past", "translation", true, true);
Module['FS_createPath']("/", "builtins", true, true);
Module['FS_createPath']("/", "libfuturize", true, true);
Module['FS_createPath']("/libfuturize", "fixes", true, true);
Module['FS_createPath']("/", "bin", true, true);
Module['FS_createPath']("/", "html", true, true);
Module['FS_createPath']("/", "lib", true, true);
Module['FS_createPath']("/lib", "python2.7", true, true);
Module['FS_createPath']("/lib/python2.7", "site-packages", true, true);
Module['FS_createPath']("/lib/python2.7/site-packages", "pygame_sdl2", true, true);
Module['FS_createPath']("/lib/python2.7/site-packages/pygame_sdl2", "threads", true, true);
Module['FS_createPath']("/", "_markupbase", true, true);
Module['FS_createPath']("/", "future-0.18.2.dist-info", true, true);
Module['FS_createPath']("/", "future", true, true);
Module['FS_createPath']("/future", "builtins", true, true);
Module['FS_createPath']("/future", "backports", true, true);
Module['FS_createPath']("/future/backports", "http", true, true);
Module['FS_createPath']("/future/backports", "xmlrpc", true, true);
Module['FS_createPath']("/future/backports", "html", true, true);
Module['FS_createPath']("/future/backports", "email", true, true);
Module['FS_createPath']("/future/backports/email", "mime", true, true);
Module['FS_createPath']("/future/backports", "test", true, true);
Module['FS_createPath']("/future/backports", "urllib", true, true);
Module['FS_createPath']("/future", "standard_library", true, true);
Module['FS_createPath']("/future", "tests", true, true);
Module['FS_createPath']("/future", "moves", true, true);
Module['FS_createPath']("/future/moves", "dbm", true, true);
Module['FS_createPath']("/future/moves", "http", true, true);
Module['FS_createPath']("/future/moves", "xmlrpc", true, true);
Module['FS_createPath']("/future/moves", "html", true, true);
Module['FS_createPath']("/future/moves", "test", true, true);
Module['FS_createPath']("/future/moves", "urllib", true, true);
Module['FS_createPath']("/future/moves", "tkinter", true, true);
Module['FS_createPath']("/future", "types", true, true);
Module['FS_createPath']("/future", "utils", true, true);
Module['FS_createPath']("/", "copyreg", true, true);
Module['FS_createPath']("/", "winreg", true, true);
Module['FS_createPath']("/", "typing-3.10.0.0.dist-info", true, true);
Module['FS_createPath']("/", "queue", true, true);
Module['FS_createPath']("/", "tkinter", true, true);
Module['FS_createPath']("/", "reprlib", true, true);

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
                Module['removeRunDependency']('datafile_pyapp.data');

      };
      Module['addRunDependency']('datafile_pyapp.data');
    
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
   loadPackage({"files": [{"filename": "/web-presplash-default.jpg", "start": 0, "end": 224232, "audio": 0}, {"filename": "/six.pyo", "start": 224232, "end": 251851, "audio": 0}, {"filename": "/typing.pyo", "start": 251851, "end": 321357, "audio": 0}, {"filename": "/_dummy_thread/__init__.pyo", "start": 321357, "end": 321884, "audio": 0}, {"filename": "/http/cookies.pyo", "start": 321884, "end": 322149, "audio": 0}, {"filename": "/http/client.pyo", "start": 322149, "end": 324437, "audio": 0}, {"filename": "/http/__init__.pyo", "start": 324437, "end": 324878, "audio": 0}, {"filename": "/http/cookiejar.pyo", "start": 324878, "end": 325109, "audio": 0}, {"filename": "/http/server.pyo", "start": 325109, "end": 325587, "audio": 0}, {"filename": "/xmlrpc/client.pyo", "start": 325587, "end": 325817, "audio": 0}, {"filename": "/xmlrpc/__init__.pyo", "start": 325817, "end": 326260, "audio": 0}, {"filename": "/xmlrpc/server.pyo", "start": 326260, "end": 326490, "audio": 0}, {"filename": "/_thread/__init__.pyo", "start": 326490, "end": 327005, "audio": 0}, {"filename": "/libpasteurize/__init__.pyo", "start": 327005, "end": 327119, "audio": 0}, {"filename": "/libpasteurize/main.pyo", "start": 327119, "end": 332314, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_future_builtins.pyo", "start": 332314, "end": 333802, "audio": 0}, {"filename": "/libpasteurize/fixes/__init__.pyo", "start": 333802, "end": 334732, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_imports2.pyo", "start": 334732, "end": 344473, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_features.pyo", "start": 344473, "end": 347512, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_raise_.pyo", "start": 347512, "end": 349012, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_getcwd.pyo", "start": 349012, "end": 350098, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_newstyle.pyo", "start": 350098, "end": 351423, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_unpacking.pyo", "start": 351423, "end": 356603, "audio": 0}, {"filename": "/libpasteurize/fixes/feature_base.pyo", "start": 356603, "end": 358284, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_division.pyo", "start": 358284, "end": 359407, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_memoryview.pyo", "start": 359407, "end": 360283, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_throw.pyo", "start": 360283, "end": 361558, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_add_all_future_builtins.pyo", "start": 361558, "end": 362438, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_add_future_standard_library_import.pyo", "start": 362438, "end": 363310, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_next.pyo", "start": 363310, "end": 364948, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_imports.pyo", "start": 364948, "end": 368918, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_annotations.pyo", "start": 368918, "end": 370708, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_raise.pyo", "start": 370708, "end": 372189, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_printfunction.pyo", "start": 372189, "end": 372966, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_kwargs.pyo", "start": 372966, "end": 376670, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_fullargspec.pyo", "start": 376670, "end": 377536, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_add_all__future__imports.pyo", "start": 377536, "end": 378447, "audio": 0}, {"filename": "/libpasteurize/fixes/fix_metaclass.pyo", "start": 378447, "end": 380804, "audio": 0}, {"filename": "/six-1.12.0.dist-info/top_level.txt", "start": 380804, "end": 380808, "audio": 0}, {"filename": "/six-1.12.0.dist-info/METADATA", "start": 380808, "end": 382748, "audio": 0}, {"filename": "/six-1.12.0.dist-info/RECORD", "start": 382748, "end": 383285, "audio": 0}, {"filename": "/six-1.12.0.dist-info/INSTALLER", "start": 383285, "end": 383289, "audio": 0}, {"filename": "/six-1.12.0.dist-info/LICENSE", "start": 383289, "end": 384355, "audio": 0}, {"filename": "/six-1.12.0.dist-info/WHEEL", "start": 384355, "end": 384465, "audio": 0}, {"filename": "/socketserver/__init__.pyo", "start": 384465, "end": 384952, "audio": 0}, {"filename": "/past/__init__.pyo", "start": 384952, "end": 385242, "audio": 0}, {"filename": "/past/builtins/noniterators.pyo", "start": 385242, "end": 387365, "audio": 0}, {"filename": "/past/builtins/__init__.pyo", "start": 387365, "end": 388461, "audio": 0}, {"filename": "/past/builtins/misc.pyo", "start": 388461, "end": 390798, "audio": 0}, {"filename": "/past/types/__init__.pyo", "start": 390798, "end": 391323, "audio": 0}, {"filename": "/past/types/oldstr.pyo", "start": 391323, "end": 393889, "audio": 0}, {"filename": "/past/types/basestring.pyo", "start": 393889, "end": 394931, "audio": 0}, {"filename": "/past/types/olddict.pyo", "start": 394931, "end": 396693, "audio": 0}, {"filename": "/past/utils/__init__.pyo", "start": 396693, "end": 398172, "audio": 0}, {"filename": "/past/translation/__init__.pyo", "start": 398172, "end": 408046, "audio": 0}, {"filename": "/builtins/__init__.pyo", "start": 408046, "end": 408599, "audio": 0}, {"filename": "/libfuturize/__init__.pyo", "start": 408599, "end": 408711, "audio": 0}, {"filename": "/libfuturize/fixer_util.pyo", "start": 408711, "end": 419360, "audio": 0}, {"filename": "/libfuturize/main.pyo", "start": 419360, "end": 427452, "audio": 0}, {"filename": "/libfuturize/fixes/fix_future_builtins.pyo", "start": 427452, "end": 429034, "audio": 0}, {"filename": "/libfuturize/fixes/fix_object.pyo", "start": 429034, "end": 429772, "audio": 0}, {"filename": "/libfuturize/fixes/fix_print_with_import.pyo", "start": 429772, "end": 430548, "audio": 0}, {"filename": "/libfuturize/fixes/__init__.pyo", "start": 430548, "end": 432914, "audio": 0}, {"filename": "/libfuturize/fixes/fix_absolute_import.pyo", "start": 432914, "end": 434978, "audio": 0}, {"filename": "/libfuturize/fixes/fix_cmp.pyo", "start": 434978, "end": 435985, "audio": 0}, {"filename": "/libfuturize/fixes/fix_add__future__imports_except_unicode_literals.pyo", "start": 435985, "end": 436932, "audio": 0}, {"filename": "/libfuturize/fixes/fix_basestring.pyo", "start": 436932, "end": 437682, "audio": 0}, {"filename": "/libfuturize/fixes/fix_division.pyo", "start": 437682, "end": 437888, "audio": 0}, {"filename": "/libfuturize/fixes/fix_input.pyo", "start": 437888, "end": 438600, "audio": 0}, {"filename": "/libfuturize/fixes/fix_division_safe.pyo", "start": 438600, "end": 441448, "audio": 0}, {"filename": "/libfuturize/fixes/fix_execfile.pyo", "start": 441448, "end": 442480, "audio": 0}, {"filename": "/libfuturize/fixes/fix_unicode_literals_import.pyo", "start": 442480, "end": 443287, "audio": 0}, {"filename": "/libfuturize/fixes/fix_order___future__imports.pyo", "start": 443287, "end": 444052, "audio": 0}, {"filename": "/libfuturize/fixes/fix_bytes.pyo", "start": 444052, "end": 445006, "audio": 0}, {"filename": "/libfuturize/fixes/fix_raise.pyo", "start": 445006, "end": 447044, "audio": 0}, {"filename": "/libfuturize/fixes/fix_print.pyo", "start": 447044, "end": 449325, "audio": 0}, {"filename": "/libfuturize/fixes/fix_future_standard_library_urllib.pyo", "start": 449325, "end": 450222, "audio": 0}, {"filename": "/libfuturize/fixes/fix_UserDict.pyo", "start": 450222, "end": 452681, "audio": 0}, {"filename": "/libfuturize/fixes/fix_xrange_with_import.pyo", "start": 452681, "end": 453442, "audio": 0}, {"filename": "/libfuturize/fixes/fix_remove_old__future__imports.pyo", "start": 453442, "end": 454330, "audio": 0}, {"filename": "/libfuturize/fixes/fix_unicode_keep_u.pyo", "start": 454330, "end": 455214, "audio": 0}, {"filename": "/libfuturize/fixes/fix_oldstr_wrap.pyo", "start": 455214, "end": 456512, "audio": 0}, {"filename": "/libfuturize/fixes/fix_next_call.pyo", "start": 456512, "end": 459576, "audio": 0}, {"filename": "/libfuturize/fixes/fix_metaclass.pyo", "start": 459576, "end": 465138, "audio": 0}, {"filename": "/libfuturize/fixes/fix_future_standard_library.pyo", "start": 465138, "end": 465957, "audio": 0}, {"filename": "/bin/pasteurize", "start": 465957, "end": 466258, "audio": 0}, {"filename": "/bin/futurize", "start": 466258, "end": 466557, "audio": 0}, {"filename": "/html/__init__.pyo", "start": 466557, "end": 467041, "audio": 0}, {"filename": "/html/entities.pyo", "start": 467041, "end": 467360, "audio": 0}, {"filename": "/html/parser.pyo", "start": 467360, "end": 467776, "audio": 0}, {"filename": "/lib/python2.7/threading.pyo", "start": 467776, "end": 472214, "audio": 0}, {"filename": "/lib/python2.7/subprocess.pyo", "start": 472214, "end": 472330, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/__init__.pyo", "start": 472330, "end": 477236, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/compat.pyo", "start": 477236, "end": 480614, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/time.pyo", "start": 480614, "end": 480803, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/version.pyo", "start": 480803, "end": 481299, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/sysfont.pyo", "start": 481299, "end": 501405, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/sprite.pyo", "start": 501405, "end": 529626, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/threads/__init__.pyo", "start": 529626, "end": 535943, "audio": 0}, {"filename": "/lib/python2.7/site-packages/pygame_sdl2/threads/Py25Queue.pyo", "start": 535943, "end": 541494, "audio": 0}, {"filename": "/_markupbase/__init__.pyo", "start": 541494, "end": 542017, "audio": 0}, {"filename": "/future-0.18.2.dist-info/top_level.txt", "start": 542017, "end": 542165, "audio": 0}, {"filename": "/future-0.18.2.dist-info/entry_points.txt", "start": 542165, "end": 542254, "audio": 0}, {"filename": "/future-0.18.2.dist-info/DESCRIPTION.rst", "start": 542254, "end": 544917, "audio": 0}, {"filename": "/future-0.18.2.dist-info/METADATA", "start": 544917, "end": 548619, "audio": 0}, {"filename": "/future-0.18.2.dist-info/metadata.json", "start": 548619, "end": 550039, "audio": 0}, {"filename": "/future-0.18.2.dist-info/RECORD", "start": 550039, "end": 580185, "audio": 0}, {"filename": "/future-0.18.2.dist-info/LICENSE.txt", "start": 580185, "end": 581268, "audio": 0}, {"filename": "/future-0.18.2.dist-info/INSTALLER", "start": 581268, "end": 581272, "audio": 0}, {"filename": "/future-0.18.2.dist-info/WHEEL", "start": 581272, "end": 581365, "audio": 0}, {"filename": "/future/__init__.pyo", "start": 581365, "end": 581828, "audio": 0}, {"filename": "/future/builtins/__init__.pyo", "start": 581828, "end": 583071, "audio": 0}, {"filename": "/future/builtins/newsuper.pyo", "start": 583071, "end": 584874, "audio": 0}, {"filename": "/future/builtins/newnext.pyo", "start": 584874, "end": 585562, "audio": 0}, {"filename": "/future/builtins/newround.pyo", "start": 585562, "end": 587467, "audio": 0}, {"filename": "/future/builtins/iterators.pyo", "start": 587467, "end": 588092, "audio": 0}, {"filename": "/future/builtins/new_min_max.pyo", "start": 588092, "end": 589734, "audio": 0}, {"filename": "/future/builtins/misc.pyo", "start": 589734, "end": 591496, "audio": 0}, {"filename": "/future/builtins/disabled.pyo", "start": 591496, "end": 592521, "audio": 0}, {"filename": "/future/backports/_markupbase.pyo", "start": 592521, "end": 601133, "audio": 0}, {"filename": "/future/backports/__init__.pyo", "start": 601133, "end": 601778, "audio": 0}, {"filename": "/future/backports/socketserver.pyo", "start": 601778, "end": 615416, "audio": 0}, {"filename": "/future/backports/socket.pyo", "start": 615416, "end": 626035, "audio": 0}, {"filename": "/future/backports/misc.pyo", "start": 626035, "end": 647873, "audio": 0}, {"filename": "/future/backports/datetime.pyo", "start": 647873, "end": 698353, "audio": 0}, {"filename": "/future/backports/total_ordering.pyo", "start": 698353, "end": 700979, "audio": 0}, {"filename": "/future/backports/http/cookies.pyo", "start": 700979, "end": 716204, "audio": 0}, {"filename": "/future/backports/http/client.pyo", "start": 716204, "end": 745710, "audio": 0}, {"filename": "/future/backports/http/__init__.pyo", "start": 745710, "end": 745832, "audio": 0}, {"filename": "/future/backports/http/cookiejar.pyo", "start": 745832, "end": 794038, "audio": 0}, {"filename": "/future/backports/http/server.pyo", "start": 794038, "end": 824229, "audio": 0}, {"filename": "/future/backports/xmlrpc/client.pyo", "start": 824229, "end": 858911, "audio": 0}, {"filename": "/future/backports/xmlrpc/__init__.pyo", "start": 858911, "end": 859035, "audio": 0}, {"filename": "/future/backports/xmlrpc/server.pyo", "start": 859035, "end": 880885, "audio": 0}, {"filename": "/future/backports/html/__init__.pyo", "start": 880885, "end": 881535, "audio": 0}, {"filename": "/future/backports/html/entities.pyo", "start": 881535, "end": 946819, "audio": 0}, {"filename": "/future/backports/html/parser.pyo", "start": 946819, "end": 960586, "audio": 0}, {"filename": "/future/backports/email/base64mime.pyo", "start": 960586, "end": 962783, "audio": 0}, {"filename": "/future/backports/email/_encoded_words.pyo", "start": 962783, "end": 968337, "audio": 0}, {"filename": "/future/backports/email/feedparser.pyo", "start": 968337, "end": 979536, "audio": 0}, {"filename": "/future/backports/email/__init__.pyo", "start": 979536, "end": 981319, "audio": 0}, {"filename": "/future/backports/email/utils.pyo", "start": 981319, "end": 990906, "audio": 0}, {"filename": "/future/backports/email/_header_value_parser.pyo", "start": 990906, "end": 1071996, "audio": 0}, {"filename": "/future/backports/email/encoders.pyo", "start": 1071996, "end": 1074406, "audio": 0}, {"filename": "/future/backports/email/headerregistry.pyo", "start": 1074406, "end": 1093587, "audio": 0}, {"filename": "/future/backports/email/errors.pyo", "start": 1093587, "end": 1099079, "audio": 0}, {"filename": "/future/backports/email/iterators.pyo", "start": 1099079, "end": 1101078, "audio": 0}, {"filename": "/future/backports/email/parser.pyo", "start": 1101078, "end": 1104774, "audio": 0}, {"filename": "/future/backports/email/_policybase.pyo", "start": 1104774, "end": 1112308, "audio": 0}, {"filename": "/future/backports/email/_parseaddr.pyo", "start": 1112308, "end": 1124540, "audio": 0}, {"filename": "/future/backports/email/message.pyo", "start": 1124540, "end": 1141882, "audio": 0}, {"filename": "/future/backports/email/policy.pyo", "start": 1141882, "end": 1145939, "audio": 0}, {"filename": "/future/backports/email/charset.pyo", "start": 1145939, "end": 1152942, "audio": 0}, {"filename": "/future/backports/email/quoprimime.pyo", "start": 1152942, "end": 1160070, "audio": 0}, {"filename": "/future/backports/email/generator.pyo", "start": 1160070, "end": 1171452, "audio": 0}, {"filename": "/future/backports/email/header.pyo", "start": 1171452, "end": 1185273, "audio": 0}, {"filename": "/future/backports/email/mime/base.pyo", "start": 1185273, "end": 1186159, "audio": 0}, {"filename": "/future/backports/email/mime/__init__.pyo", "start": 1186159, "end": 1186287, "audio": 0}, {"filename": "/future/backports/email/mime/image.pyo", "start": 1186287, "end": 1187441, "audio": 0}, {"filename": "/future/backports/email/mime/text.pyo", "start": 1187441, "end": 1188554, "audio": 0}, {"filename": "/future/backports/email/mime/audio.pyo", "start": 1188554, "end": 1190195, "audio": 0}, {"filename": "/future/backports/email/mime/application.pyo", "start": 1190195, "end": 1191313, "audio": 0}, {"filename": "/future/backports/email/mime/multipart.pyo", "start": 1191313, "end": 1192312, "audio": 0}, {"filename": "/future/backports/email/mime/nonmultipart.pyo", "start": 1192312, "end": 1193254, "audio": 0}, {"filename": "/future/backports/email/mime/message.pyo", "start": 1193254, "end": 1194360, "audio": 0}, {"filename": "/future/backports/test/keycert.passwd.pem", "start": 1194360, "end": 1196190, "audio": 0}, {"filename": "/future/backports/test/nullbytecert.pem", "start": 1196190, "end": 1201625, "audio": 0}, {"filename": "/future/backports/test/__init__.pyo", "start": 1201625, "end": 1201749, "audio": 0}, {"filename": "/future/backports/test/ssl_key.pem", "start": 1201749, "end": 1202665, "audio": 0}, {"filename": "/future/backports/test/nokia.pem", "start": 1202665, "end": 1204588, "audio": 0}, {"filename": "/future/backports/test/keycert2.pem", "start": 1204588, "end": 1206383, "audio": 0}, {"filename": "/future/backports/test/badcert.pem", "start": 1206383, "end": 1208311, "audio": 0}, {"filename": "/future/backports/test/ssl_cert.pem", "start": 1208311, "end": 1209178, "audio": 0}, {"filename": "/future/backports/test/badkey.pem", "start": 1209178, "end": 1211340, "audio": 0}, {"filename": "/future/backports/test/dh512.pem", "start": 1211340, "end": 1211742, "audio": 0}, {"filename": "/future/backports/test/support.pyo", "start": 1211742, "end": 1260979, "audio": 0}, {"filename": "/future/backports/test/ssl_servers.pyo", "start": 1260979, "end": 1269093, "audio": 0}, {"filename": "/future/backports/test/sha256.pem", "start": 1269093, "end": 1277437, "audio": 0}, {"filename": "/future/backports/test/ssl_key.passwd.pem", "start": 1277437, "end": 1278400, "audio": 0}, {"filename": "/future/backports/test/nullcert.pem", "start": 1278400, "end": 1278400, "audio": 0}, {"filename": "/future/backports/test/pystone.pyo", "start": 1278400, "end": 1285137, "audio": 0}, {"filename": "/future/backports/test/keycert.pem", "start": 1285137, "end": 1286920, "audio": 0}, {"filename": "/future/backports/test/https_svn_python_org_root.pem", "start": 1286920, "end": 1289489, "audio": 0}, {"filename": "/future/backports/urllib/__init__.pyo", "start": 1289489, "end": 1289613, "audio": 0}, {"filename": "/future/backports/urllib/response.pyo", "start": 1289613, "end": 1293658, "audio": 0}, {"filename": "/future/backports/urllib/robotparser.pyo", "start": 1293658, "end": 1299788, "audio": 0}, {"filename": "/future/backports/urllib/parse.pyo", "start": 1299788, "end": 1325153, "audio": 0}, {"filename": "/future/backports/urllib/request.pyo", "start": 1325153, "end": 1397086, "audio": 0}, {"filename": "/future/backports/urllib/error.pyo", "start": 1397086, "end": 1399539, "audio": 0}, {"filename": "/future/standard_library/__init__.pyo", "start": 1399539, "end": 1413359, "audio": 0}, {"filename": "/future/tests/base.pyo", "start": 1413359, "end": 1426268, "audio": 0}, {"filename": "/future/tests/__init__.pyo", "start": 1426268, "end": 1426381, "audio": 0}, {"filename": "/future/moves/itertools.pyo", "start": 1426381, "end": 1426724, "audio": 0}, {"filename": "/future/moves/_markupbase.pyo", "start": 1426724, "end": 1427075, "audio": 0}, {"filename": "/future/moves/__init__.pyo", "start": 1427075, "end": 1427455, "audio": 0}, {"filename": "/future/moves/copyreg.pyo", "start": 1427455, "end": 1427870, "audio": 0}, {"filename": "/future/moves/socketserver.pyo", "start": 1427870, "end": 1428225, "audio": 0}, {"filename": "/future/moves/configparser.pyo", "start": 1428225, "end": 1428541, "audio": 0}, {"filename": "/future/moves/subprocess.pyo", "start": 1428541, "end": 1429051, "audio": 0}, {"filename": "/future/moves/reprlib.pyo", "start": 1429051, "end": 1429388, "audio": 0}, {"filename": "/future/moves/collections.pyo", "start": 1429388, "end": 1430112, "audio": 0}, {"filename": "/future/moves/builtins.pyo", "start": 1430112, "end": 1430490, "audio": 0}, {"filename": "/future/moves/winreg.pyo", "start": 1430490, "end": 1430828, "audio": 0}, {"filename": "/future/moves/_thread.pyo", "start": 1430828, "end": 1431167, "audio": 0}, {"filename": "/future/moves/queue.pyo", "start": 1431167, "end": 1431501, "audio": 0}, {"filename": "/future/moves/sys.pyo", "start": 1431501, "end": 1431825, "audio": 0}, {"filename": "/future/moves/pickle.pyo", "start": 1431825, "end": 1432219, "audio": 0}, {"filename": "/future/moves/_dummy_thread.pyo", "start": 1432219, "end": 1432576, "audio": 0}, {"filename": "/future/moves/dbm/__init__.pyo", "start": 1432576, "end": 1433088, "audio": 0}, {"filename": "/future/moves/dbm/ndbm.pyo", "start": 1433088, "end": 1433426, "audio": 0}, {"filename": "/future/moves/dbm/gnu.pyo", "start": 1433426, "end": 1433763, "audio": 0}, {"filename": "/future/moves/dbm/dumb.pyo", "start": 1433763, "end": 1434105, "audio": 0}, {"filename": "/future/moves/http/cookies.pyo", "start": 1434105, "end": 1434493, "audio": 0}, {"filename": "/future/moves/http/client.pyo", "start": 1434493, "end": 1434822, "audio": 0}, {"filename": "/future/moves/http/__init__.pyo", "start": 1434822, "end": 1435046, "audio": 0}, {"filename": "/future/moves/http/cookiejar.pyo", "start": 1435046, "end": 1435402, "audio": 0}, {"filename": "/future/moves/http/server.pyo", "start": 1435402, "end": 1436002, "audio": 0}, {"filename": "/future/moves/xmlrpc/client.pyo", "start": 1436002, "end": 1436317, "audio": 0}, {"filename": "/future/moves/xmlrpc/__init__.pyo", "start": 1436317, "end": 1436437, "audio": 0}, {"filename": "/future/moves/xmlrpc/server.pyo", "start": 1436437, "end": 1436752, "audio": 0}, {"filename": "/future/moves/html/__init__.pyo", "start": 1436752, "end": 1437447, "audio": 0}, {"filename": "/future/moves/html/entities.pyo", "start": 1437447, "end": 1437806, "audio": 0}, {"filename": "/future/moves/html/parser.pyo", "start": 1437806, "end": 1438157, "audio": 0}, {"filename": "/future/moves/test/__init__.pyo", "start": 1438157, "end": 1438444, "audio": 0}, {"filename": "/future/moves/test/support.pyo", "start": 1438444, "end": 1438896, "audio": 0}, {"filename": "/future/moves/urllib/__init__.pyo", "start": 1438896, "end": 1439185, "audio": 0}, {"filename": "/future/moves/urllib/response.pyo", "start": 1439185, "end": 1439681, "audio": 0}, {"filename": "/future/moves/urllib/robotparser.pyo", "start": 1439681, "end": 1440047, "audio": 0}, {"filename": "/future/moves/urllib/parse.pyo", "start": 1440047, "end": 1440910, "audio": 0}, {"filename": "/future/moves/urllib/request.pyo", "start": 1440910, "end": 1442143, "audio": 0}, {"filename": "/future/moves/urllib/error.pyo", "start": 1442143, "end": 1442703, "audio": 0}, {"filename": "/future/moves/tkinter/commondialog.pyo", "start": 1442703, "end": 1443181, "audio": 0}, {"filename": "/future/moves/tkinter/colorchooser.pyo", "start": 1443181, "end": 1443659, "audio": 0}, {"filename": "/future/moves/tkinter/messagebox.pyo", "start": 1443659, "end": 1444129, "audio": 0}, {"filename": "/future/moves/tkinter/__init__.pyo", "start": 1444129, "end": 1444907, "audio": 0}, {"filename": "/future/moves/tkinter/scrolledtext.pyo", "start": 1444907, "end": 1445381, "audio": 0}, {"filename": "/future/moves/tkinter/constants.pyo", "start": 1445381, "end": 1445847, "audio": 0}, {"filename": "/future/moves/tkinter/dialog.pyo", "start": 1445847, "end": 1446297, "audio": 0}, {"filename": "/future/moves/tkinter/ttk.pyo", "start": 1446297, "end": 1446735, "audio": 0}, {"filename": "/future/moves/tkinter/filedialog.pyo", "start": 1446735, "end": 1447201, "audio": 0}, {"filename": "/future/moves/tkinter/tix.pyo", "start": 1447201, "end": 1447639, "audio": 0}, {"filename": "/future/moves/tkinter/font.pyo", "start": 1447639, "end": 1448085, "audio": 0}, {"filename": "/future/moves/tkinter/simpledialog.pyo", "start": 1448085, "end": 1448559, "audio": 0}, {"filename": "/future/moves/tkinter/dnd.pyo", "start": 1448559, "end": 1449001, "audio": 0}, {"filename": "/future/types/__init__.pyo", "start": 1449001, "end": 1451598, "audio": 0}, {"filename": "/future/types/newobject.pyo", "start": 1451598, "end": 1453120, "audio": 0}, {"filename": "/future/types/newrange.pyo", "start": 1453120, "end": 1458372, "audio": 0}, {"filename": "/future/types/newopen.pyo", "start": 1458372, "end": 1459754, "audio": 0}, {"filename": "/future/types/newmemoryview.pyo", "start": 1459754, "end": 1460622, "audio": 0}, {"filename": "/future/types/newlist.pyo", "start": 1460622, "end": 1463142, "audio": 0}, {"filename": "/future/types/newdict.pyo", "start": 1463142, "end": 1465484, "audio": 0}, {"filename": "/future/types/newint.pyo", "start": 1465484, "end": 1476799, "audio": 0}, {"filename": "/future/types/newbytes.pyo", "start": 1476799, "end": 1489596, "audio": 0}, {"filename": "/future/types/newstr.pyo", "start": 1489596, "end": 1501268, "audio": 0}, {"filename": "/future/utils/surrogateescape.pyo", "start": 1501268, "end": 1505133, "audio": 0}, {"filename": "/future/utils/__init__.pyo", "start": 1505133, "end": 1520440, "audio": 0}, {"filename": "/copyreg/__init__.pyo", "start": 1520440, "end": 1520918, "audio": 0}, {"filename": "/winreg/__init__.pyo", "start": 1520918, "end": 1521433, "audio": 0}, {"filename": "/typing-3.10.0.0.dist-info/top_level.txt", "start": 1521433, "end": 1521440, "audio": 0}, {"filename": "/typing-3.10.0.0.dist-info/METADATA", "start": 1521440, "end": 1523705, "audio": 0}, {"filename": "/typing-3.10.0.0.dist-info/RECORD", "start": 1523705, "end": 1524278, "audio": 0}, {"filename": "/typing-3.10.0.0.dist-info/INSTALLER", "start": 1524278, "end": 1524282, "audio": 0}, {"filename": "/typing-3.10.0.0.dist-info/LICENSE", "start": 1524282, "end": 1537037, "audio": 0}, {"filename": "/typing-3.10.0.0.dist-info/WHEEL", "start": 1537037, "end": 1537129, "audio": 0}, {"filename": "/queue/__init__.pyo", "start": 1537129, "end": 1537641, "audio": 0}, {"filename": "/tkinter/commondialog.pyo", "start": 1537641, "end": 1538106, "audio": 0}, {"filename": "/tkinter/colorchooser.pyo", "start": 1538106, "end": 1538571, "audio": 0}, {"filename": "/tkinter/messagebox.pyo", "start": 1538571, "end": 1539028, "audio": 0}, {"filename": "/tkinter/__init__.pyo", "start": 1539028, "end": 1539918, "audio": 0}, {"filename": "/tkinter/scrolledtext.pyo", "start": 1539918, "end": 1540379, "audio": 0}, {"filename": "/tkinter/constants.pyo", "start": 1540379, "end": 1540832, "audio": 0}, {"filename": "/tkinter/dialog.pyo", "start": 1540832, "end": 1541269, "audio": 0}, {"filename": "/tkinter/ttk.pyo", "start": 1541269, "end": 1541694, "audio": 0}, {"filename": "/tkinter/filedialog.pyo", "start": 1541694, "end": 1542302, "audio": 0}, {"filename": "/tkinter/tix.pyo", "start": 1542302, "end": 1542727, "audio": 0}, {"filename": "/tkinter/font.pyo", "start": 1542727, "end": 1543160, "audio": 0}, {"filename": "/tkinter/simpledialog.pyo", "start": 1543160, "end": 1543621, "audio": 0}, {"filename": "/tkinter/dnd.pyo", "start": 1543621, "end": 1544050, "audio": 0}, {"filename": "/reprlib/__init__.pyo", "start": 1544050, "end": 1544524, "audio": 0}], "remote_package_size": 1544524, "package_uuid": "9a7142b7-9005-4ad3-a732-716358b213e0"});
  
  })();
  