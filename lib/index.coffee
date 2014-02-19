


module.exports = (opts={}) ->
  addTableNav opts.table
  b = buildVisibilityButtons opts
  return b

addTableNav = (table) ->
  rows = table.querySelectorAll('tr')
  for row, r in rows
    cells = row.querySelectorAll('th')
    if cells.length < 1
      cells = row.querySelectorAll('td')
    for cell, c in cells
      cell.classList.add('c'+c)
      cell.classList.add('r'+r)

buildVisibilityButtons = (opts) ->
  table = opts.table
  default_columns = []
  if opts.default_columns?
    default_columns = opts.default_columns

  bc = ''
  if opts.button_class?
    bc = ' '+opts.button_class

  first = table.querySelector('tr')
  headers = first.querySelectorAll('th') ? first.querySelectorAll('td')
  bholder = document.createElement('div')
  bholder.className = 'column_buttons'
  for cell, i in headers
    b = document.createElement('button')

    title = cell.innerHTML

    if default_columns.length > 0
      active = false
      for item in default_columns
        if item == title.trim()
          active = true
      if active
        b.className = 'active'
      else
        col = table.querySelectorAll('.c'+i)
        for cell, c in col
          cell.classList.add('hide')
    else
      b.className = 'active'

    b.id = 'c'+i
    b.className += bc
    b.innerHTML = title
    b.onclick = (e) ->
      target = e.target.id
      col = table.querySelectorAll('.'+target)
      for cell, c in col
        if _.contains cell.classList, 'hide'
          cell.classList.remove('hide')
          e.target.classList.add('active')
        else
          cell.classList.add('hide')
          e.target.classList.remove('active')

    bholder.appendChild b

  return bholder
