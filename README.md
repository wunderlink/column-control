# Column-Control

Input an html table. Output controls to hide / show / move columns of that table.

Controls:
<img src="http://i.imgur.com/pUqHKqE.png" />

With drop down open:
<img src="http://i.imgur.com/E0Zr974.png" />

To play with an example, download and run:
npm run-script example


# Usage

A basic implementation:
```
var cc = require('column-control');

var targetTable = document.querySelector('.target-table');

var opts = {
  table: targetTable
  };

var controls = cc(opts);
```

If you do not use the "columns" option (detailed below), then column-control will use the data in the first row of the target table as titles for the controls.

Options:
```
table - (required) this is a reference to the table you are making controls for.

defaultColumns - an array of the column titles you want shown upon load. Use this only if you are not using the "columns" option.

- OR -

columns - this is an array of objects. each object holds options for that column and may contain:

  title - (string) what is displayed as the label in the drop down and button control
  default - (boolean) show/hide on load
  additionalControl - (DOM element) use this is you'd like to drop some additional html into the button control for each column. Example coming soon.
```
