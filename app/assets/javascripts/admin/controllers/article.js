'use strict';

angular.module('UrbanOutdoorApp')
  .controller('ArticleCtrl',['$scope' , function ($scope) {
    // 画面上部の入力項目のタブ用のscope
    $scope.tabs = [
      { title: '必須項目'},
      { title: '画像登録'}
    ];
    $scope.selectedTab = 0;
    $scope.selectTab = function(index){
      console.log(index);
      $scope.selectedTab = index;
    };
    // プレビューエリアの表示のために利用
    $scope.contentsArea = [];

    $scope.insertInstagram = function(){
      $scope.contentsArea.push({
        tagName: 'instagram',
        data: $scope.instagram
      });
      $scope.instagramURL = '';
    };

    $scope.selectItem = function(item){
      $scope.selectedItems.push(item);
    };

    $scope.selectedItems = [];
    $scope.insertItems = function(){
      if ($scope.selectedItems.length > 0){
        $scope.contentsArea.push({
          tagName: 'items',
          data: $scope.selectedItems
        });
        $scope.selectedItems = [];
      }
    };    
  }]);

