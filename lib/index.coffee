
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

    @opts = opts
    if opts.columns?
      @cols = opts.columns
    else
      @getColumnHeaders()

    controls = @getControls opts, @cols
    return controls

  getControls: (opts, cols) ->
    @getDefaults opts, cols
    controls = @buildCheckboxSelect cols

    for data in cols
      @updateActive data.index, data.default
      @toggleColumn data.index, data.default

    return controls

  getDefaults: (opts, cols) ->
    d = true
    for col in cols
      if col.default?
        d = false

    for i, col of cols
      col.index = i unless col.index?

      unless col.default?
        if opts.defaultColumns?
          col.default = 0
          for title in opts.defaultColumns
            if col.title is title
              col.default = 1
        else
          @selectAll = 1
          col.default = d

  addTableNav: (table) ->
    rows = table.querySelectorAll 'tr'
    for row, r in rows
      cells = row.querySelectorAll 'th'
      if cells.length < 1
        cells = row.querySelectorAll 'td'
      for cell, c in cells
        cell.classList.add 'cc-c'+c
        cell.classList.add 'cc-r'+r

  buildCheckboxSelect: (list) ->
    @controlHolder = document.createElement 'div'
    @controlHolder.className = 'cc-holder'

    downArrow = document.createElement 'div'
    downArrow.className = 'cc-down-arrow'
    downArrow.innerHTML = '+'

    self = this
    downArrow.onclick = (e) ->
      target = self.controlHolder.querySelector '.cc-list'
      if target.style.display is 'none'
        target.style.display = ''
      else
        target.style.display = 'none'

    listHolder = document.createElement 'div'
    listHolder.className = 'cc-list-holder'
    listHolder.appendChild downArrow

    activeField = @buildSelectField()

    listHolder.appendChild @buildList list, activeField
    @controlHolder.appendChild listHolder
    @controlHolder.appendChild activeField

    return @controlHolder

  buildSelectField: ->
    b = document.createElement 'div'
    b.className = 'cc-active'
    return b

  buildList: (list, activeField) ->
    div = document.createElement 'div'
    div.style.display = 'none'
    div.className = 'cc-list'
    ul = document.createElement 'ul'

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

    return div

  buildOption: (data) ->
    li = document.createElement 'li'
    li.setAttribute 'data-index', data.index
    li.className = 'cc-o'+data.index

    self = this
    li.onclick = (e) ->
      if e.target.type isnt 'checkbox'
        target = @querySelector 'input'
        if target.checked is true
          target.checked = false
        else
          target.checked = true
      else
        target = e.target
      index = @getAttribute 'data-index'
      self.selectOption index

    ch = document.createElement 'input'
    ch.type = 'checkbox'
    ch.checked = true if data.default

    la = document.createElement 'label'
    la.innerHTML = data.title

    li.appendChild ch
    li.appendChild la

    return li

  buildControl: (data) ->
    self = this

    div = document.createElement 'div'
    div.className = 'cc-o'+data.index
    div.className += ' cc-control'
    div.setAttribute 'data-index', data.index

    left = document.createElement 'div'
    left.className = 'cc-mini-btn'
    left.innerHTML = '<'
    left.onclick = (e) ->
      e.stopPropagation()
      index = @parentNode.getAttribute 'data-index'
      self.moveColumn index, 'left'
    div.appendChild left

    title = document.createElement 'div'
    title.className = 'cc-title'
    if !@opts.noTitle
      title.innerHTML = data.title
    div.appendChild title

    x = document.createElement('div')
    x.className = 'cc-mini-btn'
    x.innerHTML = 'x'
    x.onclick = (e) ->
      e.stopPropagation()
      index = @parentNode.getAttribute 'data-index'
      self.updateActive index, 0
    div.appendChild x

    right = document.createElement 'div'
    right.className = 'cc-mini-btn'
    right.innerHTML = '>'
    right.onclick = (e) ->
      e.stopPropagation()
      index = @parentNode.getAttribute 'data-index'
      self.moveColumn index, 'right'
    div.appendChild right

    if data.additionalControl?
      d = document.createElement 'br'
      div.appendChild d
      div.appendChild data.additionalControl

    return div

  moveColumn: (index, dir) ->
    control = @controlHolder.querySelector '.cc-active .cc-o' + index
    activeControls = @controlHolder.querySelectorAll '.cc-active-col'

    for control, i in activeControls
      cIndex = control.getAttribute 'data-index'
      if cIndex is index
        if dir is 'left'
          mod = -1
          if activeControls[i+mod]?
            newIndex = activeControls[i+mod].getAttribute 'data-index'
            @moveColumnBefore index, newIndex
          else
            # wrap to far right
            ref = null
            control.parentNode.insertBefore control, ref
            col = @table.querySelectorAll '.cc-c' + index
            for cell, i in col
              cell.parentNode.insertBefore cell, null
        else
          mod = 1
          if activeControls[i+mod]?
            newIndex = activeControls[i+mod].getAttribute 'data-index'
            @moveColumnBefore index, newIndex, true
          else
            newIndex = activeControls[0].getAttribute 'data-index'
            @moveColumnBefore index, newIndex


  moveColumnBefore: (index, newIndex, after = false) ->
    control = @controlHolder.querySelector '.cc-active .cc-o' + index
    ref = @controlHolder.querySelector '.cc-active .cc-o' + newIndex
    if after
      ref.parentNode.insertBefore ref, control
    else
      control.parentNode.insertBefore control, ref
    col = @table.querySelectorAll '.cc-c' + index
    nCol = @table.querySelectorAll '.cc-c' + newIndex
    for cell, i in col
      cRef = nCol[i]
      if after
        cRef.parentNode.insertBefore cRef, cell
      else
        cell.parentNode.insertBefore cell, cRef


  selectOption: (index) ->
    if index is 'sa'
      input = @controlHolder.querySelector ".cc-o#{index} input[type='checkbox']"
      turnOn = false
      if input.checked is true
        turnOn = true
      for item in @cols
        @updateActive item.index, turnOn
    else
      turnOn = 0
      if @table.querySelector('.cc-c' + index).style.display is 'none'
        turnOn = 1
      @updateActive index, turnOn

  updateActive: (index, turnOn) ->
    input = @controlHolder.querySelector ".cc-o#{index} input[type='checkbox']"
    control = @controlHolder.querySelector ".cc-active .cc-o#{index}"
    col = @table.querySelectorAll '.cc-c' + index
    if turnOn
      input.checked = true
      control.style.display = ''
      control.classList.add 'cc-active-col'
    else
      sa = @controlHolder.querySelector '.cc-osa input[type="checkbox"]'
      sa.checked = false
      input.checked = false
      control.style.display = 'none'
      control.classList.remove 'cc-active-col'

    @toggleColumn index, turnOn

  toggleColumn: (index, isOn) ->
    col = @table.querySelectorAll '.cc-c'+index

    for cell, c in col
      if isOn
        cell.style.display = ""
      else
        cell.style.display = "none"

  getColumnHeaders: ->
    first = @table.querySelector 'tr'
    headers = first.querySelectorAll('th') ? first.querySelectorAll('td')
    @cols = []

    for cell, i in headers
      title = cell.innerHTML.trim()
      @cols.push
        index: i
        title: title

