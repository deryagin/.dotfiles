var repl = require("repl");
var os = require("os");

var user = process.env.USER;
var hostname = os.hostname();
var prompt = "node://" + user + "@" + hostname + "> ";

var console = repl.start({
  prompt: prompt,
  ignoreUndefined: true
});

console.context.getPrototypeChain = function getPrototypeChain(obj) {
  var chain = [obj];
  var prototype = obj;
  while (prototype = Object.getPrototypeOf(prototype)) {
    chain.push(prototype);
  }  
  return chain;
};
