var test = require('tape')

var cc = require('../')

var table = require('../example/table.js')
document.body.innerHTML = table

test('should append buttons', function(t) {
  var targetTable = document.querySelector('.target-table')
  var controls = document.querySelector('.table-controls')

  var buttons = cc({table:targetTable, button_class:'btn'})
  controls.appendChild(buttons)

  var activeCols = document.querySelector('.ch-active')
  t.equal(activeCols.childNodes.length, 6, 'should have 6 active columns')

  t.end()
})
