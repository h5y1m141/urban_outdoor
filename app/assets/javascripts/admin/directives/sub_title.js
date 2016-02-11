'use strict';

angular.module('UrbanOutdoorApp')
  .directive("subtitle", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { subtitle: '=subtitle'},
      template: '<h2>{{value}}</h2>',
      link: function postLink(scope, element, attrs) {
        scope.$watch( 'subtitle' , function(html){
          element.html(html);
          $compile(element.contents())(scope);
        });
      }
    };
  });
