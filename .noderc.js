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

// instance.context.lodash = require(`${process.env.NODE_PATH}/lodash`);
// instance.context.fp = require(`${process.env.NODE_PATH}/lodash/fp`);

instance.context.getPrototypeChain = function getPrototypeChain(obj) {
  let chain = [obj];
  let prototype = obj;
  while (prototype = Object.getPrototypeOf(prototype)) {
    chain.push(prototype);
  }  
  return chain;
};
