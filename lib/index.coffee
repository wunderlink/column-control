
require('./style.css')


module.exports = (opts={}) ->
  controls = new ColumnControl opts
  return controls

class ColumnControl
  table: ''
  controlHolder: ''
  constructor: (opts) ->
    @table = opts.table
    @addTableNav @table

    controls = ''
    _this = @
    if opts.columns?
      @cols = opts.columns
      console.log @cols
      controls = @getControls opts, @cols
    else
      @getColumnHeaders ->
        controls = _this.getControls opts, _this.cols
    return controls

  getControls: (opts, cols) ->
    @getDefaults opts, cols
    controls = @buildCheckboxSelect cols
    for data in cols
      @updateActive data.index, data.default
      @toggleColumn data.index, data.default
    return controls

  getDefaults: (opts, cols) ->
    for i, col of cols
      if !col.index?
        col.index = i
      if !col.default?
        if opts.default_columns?
          col.default = 0
          for title in opts.default_columns
            if col.title == title
              col.default = 1
        else
          @selectAll = 1
          col.default = 1

  addTableNav: (table) ->
    rows = table.querySelectorAll('tr')
    for row, r in rows
      cells = row.querySelectorAll('th')
      if cells.length < 1
        cells = row.querySelectorAll('td')
      for cell, c in cells
        cell.classList.add('c'+c)
        cell.classList.add('r'+r)

  buildCheckboxSelect: (list) ->
    @controlHolder = document.createElement('div')
    @controlHolder.className = 'ch-holder'
    downArrow = document.createElement('div')
    downArrow.className = 'ch-down-arrow'
    downArrow.innerHTML = '+'

    _this = @
    downArrow.onclick = (e) ->
      target = _this.controlHolder.querySelector('.ch-list')
      if target.style.display == "none"
        target.style.display = ""
      else
        target.style.display = "none"
    listHolder = document.createElement('div')
    listHolder.className = 'ch-list-holder'
    listHolder.appendChild downArrow

    activeField = @buildSelectField()

    listHolder.appendChild @buildList list, activeField
    @controlHolder.appendChild listHolder
    @controlHolder.appendChild activeField
    return @controlHolder

  buildSelectField: ->
    b = document.createElement('div')
    b.className = 'ch-active'
    return b

  buildList: (list, activeField) ->
    div = document.createElement('div')
    div.style.display = 'none'
    div.className = 'ch-list'
    ul = document.createElement('ul')

    selectAll =
      index: 'sa'
      title: 'Select All'
      default: @selectAll
    sa = @buildOption selectAll
    ul.appendChild sa

    for data in list
      li = @buildOption data
      ul.appendChild li
      control = @buildControl data
      activeField.appendChild control
    div.appendChild ul
    console.log div
    return div

  buildOption: (data) ->
    li = document.createElement('li')
    li.setAttribute('data-index', data.index)
    li.className = 'o'+data.index
    _this = @
    li.onclick = (e) ->
      if e.target.type != 'checkbox'
        target = @querySelector('input')
        if target.checked == true
          target.checked = false
        else
          target.checked = true
      else
        target = e.target
      index = @getAttribute('data-index')
      _this.selectOption index
    ch = document.createElement('input')
    ch.type = 'checkbox'
    if data.default
      ch.checked = true

    la = document.createElement('label')
    la.innerHTML = data.title

    li.appendChild ch
    li.appendChild la
    return li

  buildControl: (data) ->
    div = document.createElement('div')
    div.className = 'o'+data.index
    div.className += ' ch-control'
    div.setAttribute('data-index', data.index)

    left = document.createElement('div')
    left.className = 'ch-mini-btn'
    left.innerHTML = '<'
    left.onclick = (e) ->
      e.stopPropagation()
      index = @.parentNode.getAttribute('data-index')
      _this.moveColumn index, 'left'
    div.appendChild left

    title = document.createElement('div')
    title.innerHTML = data.title
    div.appendChild title

    x = document.createElement('div')
    x.className = 'ch-mini-btn'
    x.innerHTML = 'x'
    _this = @
    x.onclick = (e) ->
      e.stopPropagation()
      index = @.parentNode.getAttribute('data-index')
      _this.updateActive index, 0
    div.appendChild x

    right = document.createElement('div')
    right.className = 'ch-mini-btn'
    right.innerHTML = '>'
    right.onclick = (e) ->
      e.stopPropagation()
      index = @.parentNode.getAttribute('data-index')
      _this.moveColumn index, 'right'
    div.appendChild right

    if data.additional_control?
      d = document.createElement('br')
      div.appendChild d
      div.appendChild data.additional_control

    return div

  moveColumn: (index, dir) ->
    control = @controlHolder.querySelector('.ch-active .o'+index)
    if dir == 'left'
      target = 'previousElementSibling'
      control.parentNode.insertBefore( control, control[target] )
      col = @table.querySelectorAll('.c'+index)
      for cell in col
        cell.parentNode.insertBefore( cell, cell[target] )
    else
      target = 'nextElementSibling'
      next = control[target]
      control.parentNode.insertBefore( control, next[target] )
      col = @table.querySelectorAll('.c'+index)
      for cell in col
        next = cell[target]
        cell.parentNode.insertBefore( cell, next[target] )
    
  selectOption: (index) ->
    if index == 'sa'
      input = @controlHolder.querySelector('.o'+index+' input[type="checkbox"]')
      turn_on = false
      if input.checked == true
        turn_on = true
      for item in @cols
        @updateActive item.index, turn_on
    else
      turn_on = 0
      if @table.querySelector('.c'+index).style.display == 'none'
        turn_on = 1
      @updateActive index, turn_on

  updateActive: (index, turn_on) ->
    input = @controlHolder.querySelector('.o'+index+' input[type="checkbox"]')
    control = @controlHolder.querySelector('.ch-active .o'+index)
    col = @table.querySelectorAll('.c'+index)
    if turn_on
      input.checked = true
      control.style.display = ''
    else
      sa = @controlHolder.querySelector('.osa input[type="checkbox"]')
      sa.checked = false
      input.checked = false
      control.style.display = 'none'
    @toggleColumn(index, turn_on)

  toggleColumn: (index, is_on) ->
    col = @table.querySelectorAll('.c'+index)
    for cell, c in col
      if is_on
        cell.style.display = ""
      else
        cell.style.display = "none"

  getColumnHeaders: (cb) ->
    first = @table.querySelector('tr')
    headers = first.querySelectorAll('th') ? first.querySelectorAll('td')
    @cols = []
    for cell, i in headers
      title = cell.innerHTML.trim()
      @cols.push
        index: i
        title: title
    cb()

