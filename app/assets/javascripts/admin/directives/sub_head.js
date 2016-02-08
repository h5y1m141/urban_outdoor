'use strict';

angular.module('UrbanOutdoorApp')
  .directive("subhead", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { subhead: '=subhead'},
      template: '<h3>{{value}}</h3>',
      link: function postLink(scope, element, attrs) {
        scope.$watch( 'subhead' , function(html){
          element.html(html);
          $compile(element.contents())(scope);
        });
      }
    };
  });
