'use strict';

angular.module('UrbanOutdoorApp')
  .directive('item',['$window','$q','$compile', function($window, $q, $compile) {
    return {
      restrict: 'E',
      template: '<div ng-repeat="item in items track by $index"><img class="article__contents__preview__thumb" ng-src="{{item.image.medium_thumb.url}}"/></div>',
      scope: {
        items: '=data'
      }
    };
  }]);
