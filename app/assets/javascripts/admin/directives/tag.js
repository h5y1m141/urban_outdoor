'use strict';

angular.module('UrbanOutdoorApp')
  .directive('tag',['Item', function(Item) {
    return {
      restrict: "A",
      link: function($scope, $element, $attrs, $controllers) {
        $scope.$watch('tagName', function(html){
          var params = {
            item: {
              tags: $scope.tagName
            }          
          };
          var data = Item.search_by_tag(params);
          data.$promise.then(function(response){
            $scope.items = response.items;
          });
        });
      }
    };
  }]);
