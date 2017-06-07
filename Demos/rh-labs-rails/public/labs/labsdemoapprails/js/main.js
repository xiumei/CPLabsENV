/*global document, window, angular, define*/

// Note: in this example main.js we include the some Labs/lib code
define(['angular128'], function (angular) {
    "use strict";

    // Define the module
    var module = angular.module('app.main', []);

    // Add some controllers
    module.controller('ExampleCtrl', function ($scope, $location, $http) {});

    // Returning the module is not really necessary, but its AMD
    return module;
});