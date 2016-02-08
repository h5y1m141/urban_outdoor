'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:title
 * @description
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
angular.module('RiliApp')
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
