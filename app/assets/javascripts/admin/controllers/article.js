'use strict';

angular.module('UrbanOutdoorApp')
  .controller('ArticleCtrl', ['$scope','Article', '$http', function ($scope, Article, $http) {
    // 画面上部の入力項目のタブ用のscope
    $scope.tabs = [
      { title: '記事の基本情報'},
      { title: '文章登録'},
      { title: '画像登録'}
    ];
    $scope.selectedTab = 0;
    $scope.selectTab = function(index){
      $scope.selectedTab = index;
    };
    // プレビューエリアの表示のために利用
    $scope.contentsArea = [];

    $scope.saveArticle = function(){
      Article.save({
        title: $scope.mainTitle,
        publish_status: 0,
        elements_attributes: $scope.contentsArea
      });
    };
    $scope.insertInstagram = function(){
      $scope.contentsArea.push({
        tag_name: 'instagram',
        element_data: $scope.instagram
      });
    },
    $scope.loadElements = function(article){
      var query,
          elements;
      $scope.mainTitle = article.title;
      query = Article.loadElements({id: article.id});
      query.$promise.then(function(response){
        angular.forEach(response.elements,function(element, key) {
          $scope.contentsArea.push(element);
        });        
      });
    };
  }]);

