# Rails+AngularJS demo labs application

This is the template for Labs Rails applications.
You need to edit somethings before you get started.


If you have an app name **"foobar"**

In config/initializers/labs.rb
```ruby
$lab_id = 'foobar'
$lab_name = 'Foobar Cool App'
```

In public/labs/labsdemoapprails/js/loader.js
```javascript
// Set this to the name of the application
var id = 'foobar';     // ### NOTE ### this must be set.
```

Also rename the public/labs/labsdemoapprails to match your new lab name
```bash
$ mv public/labs/labsdemoapprails public/labs/foobar
```

