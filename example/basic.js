require('cssify').byUrl('//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css')

var cc = require('../index.js');
var table = require('./table.js')

document.body.innerHTML = table;

var targetTable = document.querySelector('.target-table');
var controls = document.querySelector('.table-controls');

var buttons = cc({table:targetTable, button_class:'btn'});
controls.appendChild(buttons);
