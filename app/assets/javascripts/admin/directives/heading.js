'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:heading
 * @description
 * # 記事投稿画面で記事の中見出しの表示用のDirective
 */
angular.module('RiliApp')
  .directive("heading", function($compile) {
    return {
      restrict: 'E',
      template: '<div ng-hide="heading.image"><h3>{{ heading.description }}</h3></div><img ng-src="{{heading.image.image.url}}"/>',
      scope: {
        heading: '=data'
      },
      link: function (scope, element, attrs) {
        scope.$watch( 'heading' , function(html){
          $compile(element.contents())(scope);
        });
      }
    };
  });
