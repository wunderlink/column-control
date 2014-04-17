require('cssify').byUrl('//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css')

var cc = require('../index.js');
var table = require('./table.js')

document.body.innerHTML = table;
document.body.style.margin = '20px';

var targetTable = document.querySelector('.target-table');
var controls = document.querySelector('.table-controls');

var buttons = cc({table:targetTable});
controls.appendChild(buttons);



// Example using the columns option

columns = [
  {title: 'Payment Frequency', default: 1},
  {title: 'Net Terms', default: 1},
  {title: 'Payment Method', default: 1},
  {title: 'Due In', default: 0},
  {title: 'Client Count', default: 0},
  {title: 'Revenue', default: 1}
];

var buttons = cc({table:targetTable, columns:columns});
controls.appendChild(buttons);
