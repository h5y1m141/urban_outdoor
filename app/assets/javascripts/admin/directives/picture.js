'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:picture
 * @description
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
angular.module('RiliApp')
  .directive("picture", function($compile) {
    return {
      restrict: 'A',
      replace: true,
      scope: { picture: '=picture'},
      template: '<img ng-src="{{value}}" >',
      link: function postLink(scope, element, attrs) {
        scope.$watch('picture' , function(html){
          attrs.$set('src',scope.picture);
        });
      }
    };
  });

