'use strict';

angular.module('UrbanOutdoorApp')
  .controller('ItemCtrl', ['$scope', function ($scope) {
    $scope.init = function(pictures){
      $scope.pictures = JSON.parse(pictures);
      $scope.thumbnail = $scope.pictures[0].image.url;
    };
    $scope.selectThumbnail = function(index) {
      $scope.thumbnail = $scope.pictures[index].image.url;
    };
  }]);
