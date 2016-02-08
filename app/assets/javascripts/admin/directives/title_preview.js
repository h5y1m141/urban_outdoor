'use strict';

/**
 * @ngdoc function
 * @name UrbanOutdoorApp.directive:titlePreview
 * @description
 * # 記事投稿画面で記事データーに付与されてるタグ情報を読み取って動的に
 * HTMLタグを割り当てるためのDirective
 */
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
          element.html(html);
          $compile(element.contents())(scope);
        });
      }
    };
  });
