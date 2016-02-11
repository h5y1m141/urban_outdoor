'use strict';

angular.module('UrbanOutdoorApp')
  .directive("titlePreview", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { title: '=titlePreview'},
      template: '<p>{{value}}</p>',
      link: function postLink(scope, element, attrs) {
        scope.$watch( 'title' , function(html){
          console.log(element);
          // console.log(element.contents());
          element.html(html);
          $compile(element.contents())(scope);
        });
      }
    };
  });
