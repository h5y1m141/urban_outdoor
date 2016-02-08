'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:layout
 * @description
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
angular.module('RiliApp')
  .directive("layout", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { layout: '=layout'},
      template: '<hr />'
    };
  });
