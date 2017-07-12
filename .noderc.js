const repl = require("repl");
const os = require("os");

let user = process.env.USER;
let hostname = os.hostname();
let prompt = "node://" + user + "@" + hostname + "> ";

let instance = repl.start({
  useGlobal: true,
  ignoreUndefined: false,
  prompt: prompt,
});

instance.context.lodash = require('/home/deryaginav/.nvm/versions/node/v6.9.1/bin/../lib/node_modules/lodash');

instance.context.getPrototypeChain = function getPrototypeChain(obj) {
  let chain = [obj];
  let prototype = obj;
  while (prototype = Object.getPrototypeOf(prototype)) {
    chain.push(prototype);
  }  
  return chain;
};
