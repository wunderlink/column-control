(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

//require('coffee-script');

module.exports = require('./lib/index.coffee');

},{"./lib/index.coffee":2}],2:[function(require,module,exports){
var addTableNav, buildVisibilityButtons;

module.exports = function(opts) {
  var b;
  if (opts == null) {
    opts = {};
  }
  addTableNav(opts.table);
  b = buildVisibilityButtons(opts);
  return b;
};

addTableNav = function(table) {
  var c, cell, cells, r, row, rows, _i, _len, _results;
  rows = table.querySelectorAll('tr');
  _results = [];
  for (r = _i = 0, _len = rows.length; _i < _len; r = ++_i) {
    row = rows[r];
    cells = row.querySelectorAll('th');
    if (cells.length < 1) {
      cells = row.querySelectorAll('td');
    }
    _results.push((function() {
      var _j, _len1, _results1;
      _results1 = [];
      for (c = _j = 0, _len1 = cells.length; _j < _len1; c = ++_j) {
        cell = cells[c];
        cell.classList.add('c' + c);
        _results1.push(cell.classList.add('r' + r));
      }
      return _results1;
    })());
  }
  return _results;
};

buildVisibilityButtons = function(opts) {
  var active, b, bc, bholder, c, cell, col, default_columns, first, headers, i, item, table, title, _i, _j, _k, _len, _len1, _len2, _ref;
  table = opts.table;
  default_columns = [];
  if (opts.default_columns != null) {
    default_columns = opts.default_columns;
  }
  bc = '';
  if (opts.button_class != null) {
    bc = ' ' + opts.button_class;
  }
  first = table.querySelector('tr');
  headers = (_ref = first.querySelectorAll('th')) != null ? _ref : first.querySelectorAll('td');
  bholder = document.createElement('div');
  bholder.className = 'column_buttons';
  for (i = _i = 0, _len = headers.length; _i < _len; i = ++_i) {
    cell = headers[i];
    b = document.createElement('button');
    title = cell.innerHTML;
    if (default_columns.length > 0) {
      active = false;
      for (_j = 0, _len1 = default_columns.length; _j < _len1; _j++) {
        item = default_columns[_j];
        if (item === title.trim()) {
          active = true;
        }
      }
      if (active) {
        b.className = 'active';
      } else {
        col = table.querySelectorAll('.c' + i);
        for (c = _k = 0, _len2 = col.length; _k < _len2; c = ++_k) {
          cell = col[c];
          cell.classList.add('hide');
        }
      }
    } else {
      b.className = 'active';
    }
    b.id = 'c' + i;
    b.className += bc;
    b.innerHTML = title;
    b.onclick = function(e) {
      var cl, hidden, target, _l, _len3, _len4, _m, _ref1, _results;
      target = e.target.id;
      col = table.querySelectorAll('.' + target);
      _results = [];
      for (c = _l = 0, _len3 = col.length; _l < _len3; c = ++_l) {
        cell = col[c];
        hidden = false;
        _ref1 = cell.classList;
        for (_m = 0, _len4 = _ref1.length; _m < _len4; _m++) {
          cl = _ref1[_m];
          if (cl === 'hide') {
            hidden = true;
          }
        }
        if (hidden) {
          cell.classList.remove('hide');
          _results.push(e.target.classList.add('active'));
        } else {
          cell.classList.add('hide');
          _results.push(e.target.classList.remove('active'));
        }
      }
      return _results;
    };
    bholder.appendChild(b);
  }
  return bholder;
};


},{}]},{},[1])