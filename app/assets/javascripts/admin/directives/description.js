'use strict';

angular.module('UrbanOutdoorApp')
  .directive("description", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { description: '=description'},
      template: '<p>{{value}}</p>',
      link: function postLink(scope, element, attrs) {
        scope.$watch( 'description' , function(html){
          element.html(html.replace(/[\n\r]/g, "<br />"));
          $compile(element.contents())(scope);
        });
      }
    };
  });
