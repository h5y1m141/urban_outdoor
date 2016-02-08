'use strict';

angular.module('UrbanOutdoorApp')
  .directive("dynamic", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { dynamic: '=dynamic'},
      template: '<img src="{{ value }}" >',
      link: function postLink(scope, element, attrs) {
        scope.$watch( 'dynamic' , function(html){
          console.log(element);
          // console.log(element.contents());
          element.html(html);
          $compile(element.contents())(scope);
        });
      }
    };
  });
