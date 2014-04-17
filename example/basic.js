require('cssify').byUrl('//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css')

var cc = require('../index.js');
var table = require('./table.js')

document.body.innerHTML = table;
document.body.style.margin = '20px';

var targetTable = document.querySelector('.target-table');
var controls = document.querySelector('.table-controls');

var buttons = cc({table:targetTable});
controls.appendChild(buttons);
