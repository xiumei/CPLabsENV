/*global document, window, angular*/
(function () {
    "use strict";

    // Set this to the name of the application
    var id = 'labsdemoapprails';     // ### NOTE ### this must be set.

    // This pattern for a baseUrl should work for all applications
    window.require.config({
        baseUrl: '/labs/' + id + '/js'
    });

    // convert the module list Strings to 'app.' + String
    function getAngularModuleNames(list) {
        var paths = [];
        list.forEach(function (item) {
            paths.push('app.' + item);
        });
        return paths;
    }

	window.chrometwo_require(['angular128', 'jquery', 'cachebust'], function (angular, jq, cachebust) {

        // Change this to bust JS cache when you push
        cachebust.set('bust', '0.0.0');

        // List the modules you've written here.
        // By convention the file js/main.js has an angular module name of 'app.main'
        // If that convention is followed adding the name here should be all that is needed.
        var modules = [
            'main'
        ];

        // Fetch all the modules
        window.chrometwo_require(modules, function () {
            // bootstrap Angular with all the modules in the app
		    angular.bootstrap(document, getAngularModuleNames(modules));

            // unhide the div that has our markup
		    jq('#chromed-app-content').css('visibility', 'visible');
        });
	});
}());