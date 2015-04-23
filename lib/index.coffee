


module.exports = (opts={}) ->
  controls = new ColumnControl opts
  return controls

class ColumnControl
  table: ''
  style: true

  controlHolder: ''

  constructor: (opts) ->
    @table = opts.table
    @addTableNav @table

    @name = false
    if opts.name?
      @name = opts.name

    if opts.style?
      @style = opts.style

    if @style
      require('./style.css')

    @opts = opts
    if opts.columns?
      @cols = opts.columns
    else
      @getColumnHeaders()

    @elements = {}
    @elements.cols = []

    @controls = @getControls opts, @cols

  getControls: (opts, cols) ->
    userDefaults = []
    if @name and localStorage['cc:'+@name]
      userDefaults = JSON.parse localStorage['cc:'+@name]
    @getDefaults opts, cols, userDefaults
    controls = @buildCheckboxSelect cols

    for data in cols
      @updateActive data.index, data.default
      @toggleColumn data.index, data.default

    tmp = userDefaults.reverse()
    for ud, i in tmp
      if i > 0
        @moveColumnBefore ud, tmp[i-1]
    return controls

  getDefaults: (opts, cols, userDefaults) ->
    d = true
    for col in cols
      if col.default?
        d = false

    for i, col of cols
      col.index = i unless col.index?

      if userDefaults.length > 0
        if userDefaults.indexOf(Number(i)) > -1
          col.default = 1
        else
          col.default = 0
      else
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

    listHolder = document.createElement 'div'
    listHolder.className = 'cc-list-holder'
    listHolder.appendChild downArrow

    activeField = @buildSelectField()

    list = @buildList list, activeField
    listHolder.appendChild list
    @elements.fieldList = list

    @controlHolder.appendChild listHolder
    @controlHolder.appendChild activeField

    downArrow.onclick = (e) ->
      target = self.elements.fieldList
      console.log "TART", target
      if target.style.display is 'none'
        target.style.display = 'block'
      else
        target.style.display = 'none'

    @elements.columnsButton = downArrow


    return @controlHolder

  buildSelectField: ->
    b = document.createElement 'div'
    b.className = 'cc-active'
    return b

  buildList: (list, activeField) ->
    ###
    div = document.createElement 'div'
    div.style.display = 'none'
    div.className = 'cc-list'
    ###
    ul = document.createElement 'ul'
    ul.className = 'cc-list'

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

    #div.appendChild ul

    return ul

  buildOption: (data) ->
    li = document.createElement 'li'
    li.setAttribute 'data-index', data.index
    li.className = 'cc-o'+data.index

    self = this
    li.onclick = (e) ->
      if this.classList.contains('active')
        this.classList.remove 'active'
      else
        this.classList.add 'active'
      index = @getAttribute 'data-index'
      self.selectOption index

    ###
    ch = document.createElement 'input'
    ch.type = 'checkbox'
    ch.checked = true if data.default
    ###

    la = document.createElement 'a'
    la.innerHTML = data.title

    #li.appendChild ch
    li.appendChild la

    return li

  buildControl: (data) ->
    self = this

    obs = {}

    div = document.createElement 'div'
    div.className = 'cc-o'+data.index
    div.className += ' cc-control'
    div.setAttribute 'data-index', data.index

    left = document.createElement 'div'
    left.className = 'cc-mini-btn'
    left.setAttribute 'data-index', data.index
    left.innerHTML = '<'
    left.onclick = (e) ->
      e.stopPropagation()
      index = this.getAttribute 'data-index'
      self.moveColumn index, 'left'
      self.saveState()
    div.appendChild left

    obs.left = left

    title = document.createElement 'div'
    title.className = 'cc-title'
    if !@opts.noTitle
      title.innerHTML = data.title
    div.appendChild title

    x = document.createElement('div')
    x.className = 'cc-mini-btn'
    x.setAttribute 'data-index', data.index
    x.innerHTML = 'x'
    x.onclick = (e) ->
      e.stopPropagation()
      index = this.getAttribute 'data-index'
      self.updateActive index, 0
      self.saveState()
    div.appendChild x

    obs.close = x

    right = document.createElement 'div'
    right.className = 'cc-mini-btn'
    right.setAttribute 'data-index', data.index
    right.innerHTML = '>'
    right.onclick = (e) ->
      e.stopPropagation()
      index = this.getAttribute 'data-index'
      self.moveColumn index, 'right'
      self.saveState()
    div.appendChild right

    obs.right = right

    if data.additionalControl?
      d = document.createElement 'br'
      div.appendChild d
      div.appendChild data.additionalControl
      obs.additional = data.additionalControl

    @elements.cols.push obs

    return div

  moveColumn: (index, dir) ->
    control = @controlHolder.querySelector '.cc-active .cc-o' + index
    activeControls = @controlHolder.querySelectorAll '.cc-active-col'

    console.log 'CNTS', control
    console.log 'IN', index
    console.log 'AC', activeControls
    for control, i in activeControls
      cIndex = control.getAttribute 'data-index'
      console.log "Con", cIndex
      if cIndex is index
        if dir is 'left'
          mod = -1
          if activeControls[i+mod]?
            newIndex = activeControls[i+mod].getAttribute 'data-index'
            console.log "ENW INDEX", newIndex
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
      input = @elements.fieldList.querySelector ".cc-o#{index}"
      turnOn = false
      if input.classList.contains('active')
        turnOn = true
      for item in @cols
        @updateActive item.index, turnOn
    else
      turnOn = 0
      if @table.querySelector('.cc-c' + index).style.display is 'none'
        turnOn = 1
      @updateActive index, turnOn
    @saveState()

  updateActive: (index, turnOn) ->
    input = @elements.fieldList.querySelector ".cc-o#{index}"
    control = @controlHolder.querySelector ".cc-active .cc-o#{index}"
    col = @table.querySelectorAll '.cc-c' + index
    if turnOn
      input.classList.add 'active'
      control.style.display = ''
      control.classList.add 'cc-active-col'
    else
      sa = @elements.fieldList.querySelector '.cc-osa'
      sa.classList.remove 'active'
      input.classList.remove 'active'
      control.style.display = 'none'
      control.classList.remove 'cc-active-col'

    @toggleColumn index, turnOn

  saveState: ->
    if !@name
      return
    cols = @controlHolder.querySelectorAll ".cc-active-col"
    activeSet = []
    for col in cols
      activeSet.push Number(col.getAttribute 'data-index')
    localStorage['cc:'+@name] = JSON.stringify activeSet
    console.log 'Save State', activeSet

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

