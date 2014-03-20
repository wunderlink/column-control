


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
    @getColumnHeaders ->
      _this.getDefaults opts
      controls = _this.buildCheckboxSelect _this.cols
    for data in @cols
      @updateActive data.index, data.default
      @toggleColumn data.index, data.default
    return controls

  getDefaults: (opts) ->
    for data in @cols
      if opts.default_columns?
        for title in opts.default_columns
          if data.title == title
            data.default = 1
          else
            data.default = 0
      data.default = 1

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
    @controlHolder.appendChild @buildSelectField()
    @controlHolder.appendChild @buildList list
    return @controlHolder

  buildSelectField: ->
    b = document.createElement('div')
    b.className = 'ch-active'
    b.style.border = '1px solid #666'
    b.style.minHeight = '20px'
    _this = @
    b.onclick = (e) ->
      target = _this.controlHolder.querySelector('.ch-list')
      console.log target
      if target.style.display == "none"
        target.style.display = ""
      else
        target.style.display = "none"
    return b

  buildList: (list) ->
    div = document.createElement('div')
    div.style.display = 'none'
    div.className = 'ch-list'
    ul = document.createElement('ul')
    ul.style.maxHeight = "300px"
    for data in list
      li = @buildOption data
      ul.appendChild li

      control = @buildControl data
      acts = @controlHolder.querySelector('.ch-active')
      acts.appendChild control
    div.appendChild ul
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
      make_visible = 0
      if _this.table.querySelector('.c'+index).style.display == 'none'
        make_visible = 1
      _this.updateActive index, make_visible
    ch = document.createElement('input')
    ch.type = 'checkbox'

    la = document.createElement('label')
    la.innerHTML = data.title

    li.appendChild ch
    li.appendChild la
    return li

  buildControl: (data) ->
    div = document.createElement('div')
    div.innerHTML = data.title
    div.className = 'o'+data.index
    div.setAttribute('data-index', data.index)

    x = document.createElement('div')
    x.innerHTML = 'X'
    _this = @
    x.onclick = (e) ->
      e.stopPropagation()
      index = @.parentNode.getAttribute('data-index')
      _this.updateActive index, 0
    div.appendChild x

    left = document.createElement('div')
    left.innerHTML = '>'
    left.onclick = (e) ->
      e.stopPropagation()
      index = @.parentNode.getAttribute('data-index')
      _this.moveColumn index, 'right'
    div.appendChild left

    left = document.createElement('div')
    left.innerHTML = '<'
    left.onclick = (e) ->
      e.stopPropagation()
      index = @.parentNode.getAttribute('data-index')
      _this.moveColumn index, 'left'
    div.appendChild left

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
    

  updateActive: (index, turn_on) ->
    input = @controlHolder.querySelector('.o'+index+' input[type="checkbox"]')
    control = @controlHolder.querySelector('.ch-active .o'+index)
    col = @table.querySelectorAll('.c'+index)
    if turn_on
      input.checked = true
      control.style.display = ''
    else
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
      console.log title
      @cols.push
        index: i
        title: title
    cb()

