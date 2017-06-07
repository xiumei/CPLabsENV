/*global angular*/

angular.module('rhlabsangularApp').controller('NavbarCtrl', function ($scope, $location) {
    'use strict';
    $scope.menu = [
        {
            'title': 'Home',
            'link': ''
        },
        {
            'title': 'About',
            'link': 'about'
        }
    ];

    $scope.isActive = function (route) {
        return ('/' + route) === $location.path();
    };
});
