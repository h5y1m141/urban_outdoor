'use strict';

/**
 * @ngdoc function
 * @name RiliApp.directive:filemodel
 * @description
 * # ファイルアップロード
 * Directive
 */
angular.module('RiliApp')
  .directive("fileModel", ["$parse", function ($parse) {
    return {
      restrict: "A",
      link: function (scope, element, attrs) {
        var model = $parse(attrs.fileModel);
        element.bind("change", function () {
          scope.$apply(function () {
            model.assign(scope, element[0].files[0]);
          });
        });
      }
    };
  }]);
