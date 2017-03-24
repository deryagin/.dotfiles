EDITOR="/usr/bin/vim";
DBQuery.shellBatchSize = 10;

prompt = function() {
    var host = db.serverStatus().host;
    var user = db.runCommand({connectionStatus : 1}).authInfo.authenticatedUsers[0];
    user = (user ? user : "none");
    return "mongo://" + user + "@" + host + "/" + db + "> ";
}
