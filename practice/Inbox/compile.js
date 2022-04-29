const path = require('path'); 
const fs = require('fs'); 
const solc = require('solc');

const infoPath = path.resolve(__dirname, 'contracts', 'Inbox.sol'); 
const source = fs.readFileSync(infoPath, 'utf8');

//console.log(solc.compile(source, 1));
module.exports = solc.compile(source, 1).contracts[':Inbox'];