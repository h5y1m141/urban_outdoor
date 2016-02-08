'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:description
 * @description
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
angular.module('RiliApp')
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
