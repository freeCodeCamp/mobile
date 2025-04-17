console.log("Debugging test runner");
// runs in a worker, just echoing messages
onmessage = function (e) {
  // echo the message back
  postMessage(e.data);
}
