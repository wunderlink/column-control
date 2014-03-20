


table = '<div class="table_controls"></div> <div class="table_hodler"><table class="target-table"> <thead> <tr> <th>Payment Period</th> <th>Net Terms</th> <th>Payment Method</th> <th>Due In</th> <th>Client Count</th> <th>Total Revenue</th> </tr> </thead> <tbody> <tr> <td>15</td> <td>check</td> <td>2014-02-26</td> <td>2</td> <td>5</td> <td>51309.27</td> </tr> <tr> <td>15</td> <td>ach</td> <td>2014-01-15</td> <td>-40</span></td> <td>5</td> <td>2861.20</td> </tr> <tr> <td>15</td> <td>ach</td> <td>2014-01-29</td> <td>-26</span></td> <td>6</td> <td>3881.49</td> </tr> <tr> <td>15</td> <td>ach</td> <td>2014-01-01</td> <td>-54</span></td> <td>6</td> <td>4039.00</td> </tr> </tbody> </table> </div>';
document.body.innerHTML = table;


var cc = require('../index.js');

target_table = document.querySelector('.target-table');
controls = document.querySelector('.table_controls');

buttons = cc({table:target_table, button_class:'btn'});
controls.appendChild(buttons);
