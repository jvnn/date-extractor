'use strict';

const http = require('http');
const childproc = require('child_process');
const url = require('url');

const SERVER_PORT = 8080;

function fail(res) {
	res.writeHead(400);
	res.end();
}

let server = http.createServer((req, res) => {
	const query = url.parse(req.url).search;
	const match = query.match(/text=([^&]+)/);
	if (!match) {
		fail(res);
		return;
	}

	const text = match[1];
	if (!text) {
		fail(res);
		return;
	}

	let prolog = childproc.spawn('swipl', ['-q', '-f', '../prolog/parser.pl',
		'-t', 'find_dates.', '--', text]);
	prolog.stderr.on('data', output => console.log(output.toString()));
	prolog.stdout.on('data', output => {
		res.writeHead(200, {"ContentType": "application/json"});
		res.write(output.toString().trim());
		res.end();
	});
}).listen(SERVER_PORT);

console.log("Server listening at " + SERVER_PORT);

