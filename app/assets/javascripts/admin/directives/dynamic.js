'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:dynamic
 * @description
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
angular.module('RiliApp')
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
