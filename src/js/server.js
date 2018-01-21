'use strict';

const http = require('http');
const childproc = require('child_process');
const url = require('url');
const fs = require('fs');

const SERVER_PORT = 8080;

function fail(res) {
  res.writeHead(400);
  res.end();
}

let request_queue = [];
let waiting_response = null;
let output = "";

function handle_request_queue() {
  if (request_queue.length > 0 && waiting_response == null) {
    let req = request_queue.pop();
    waiting_response = req.res;
    prolog.stdin.write('find_all_dates(' + req.tz_offset + ', \"' + req.text + '\").\n');
  }
}

function on_data(incoming) {
  output += incoming;
  if (output.trim().endsWith('true.')) {
    // we're done
    waiting_response.writeHead(200, {"ContentType": "application/json"});
    let response = output.split('\n')[0];
    waiting_response.write(response.replace(/(\d{4}-\d{2}-\d{2})/g, "\"$1\""));
    waiting_response.end();
    output = "";
    waiting_response = null;
    handle_request_queue();
  }
}

let prolog = childproc.spawn('swipl', ['-q', '-f', '../prolog/parser.pl']);
prolog.stdout.on('data', on_data);

http.createServer((req, res) => {
  const static_paths = {
    "/demo.html": "demo.html",
    "/demo": "demo.html",
    "/client.js": "client.js"
  };

  const static_file = static_paths[req.url];
  if (static_file) {
    fs.readFile(static_file, function(error, content) {
      if (error) {
        res.writeHead(404);
        res.end("Meh, not the file you're looking for.");
      } else {
        const content_type = static_file.endsWith('.js') ? 'text/javascript' : 'text/html';
        res.writeHead(200, {'Content-Type': content_type});
        res.end(content, 'utf-8');
      }
    });
    return;
  }

  const query = url.parse(req.url).search;
  if (!query) {
    fail(res);
    return;
  }

  const text_match = query.match(/text=([^&]+)/);
  const timezone_offset_match = query.match(/tz_offset=([^&]+)/);

  if (!text_match || !timezone_offset_match) {
    fail(res);
    return;
  }

  const text = decodeURIComponent(text_match[1]);
  const timezone_offset = decodeURIComponent(timezone_offset_match[1]);
  if (!text || !timezone_offset) {
    fail(res);
    return;
  }

  request_queue.splice(0, 0, {res: res, text: text, tz_offset: timezone_offset});
  handle_request_queue();
}).listen(SERVER_PORT);

console.log("Server listening at " + SERVER_PORT);

