'use strict';

angular.module('UrbanOutdoorApp')
  .directive("layout", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { layout: '=layout'},
      template: '<hr />'
    };
  });
