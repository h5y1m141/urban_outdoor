'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:items
 * @items
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
angular.module('RiliApp')
  .directive("items",['$window','$q','$compile', function($window, $q, $compile) {
    return {
      restrict: 'E',
      template: '<div ng-repeat="item in items track by $index"><img class="article__contents__preview__thumb" ng-src="{{item.image.medium_thumb.url}}"/></div>',
      scope: {
        items: '=data'
      }
    };
  }]);
