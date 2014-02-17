

module.exports = columnControl = (opts={}) ->
  table = opts.table
  b = @columnControl(table)
  return b

  columnControl: (table) ->
    rows = table.querySelectorAll('tr')
    for row, r in rows
      cells = row.querySelectorAll('th')
      if cells.length < 1
        cells = row.querySelectorAll('td')
      for cell, c in cells
        cell.classList.add('c'+c)
        cell.classList.add('r'+r)

    first = table.querySelector('tr')
    headers = first.querySelectorAll('th') ? first.querySelectorAll('td')
    buttons = []
    bholder = document.createElement('div')
    bholder.className = 'btn-group'
    for cell, i in headers
      b = document.createElement('button')
      b.className = 'btn btn-sm btn-default active'
      b.id = 'c'+i
      b.innerHTML = cell.innerHTML
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
