'use strict';

angular.module('UrbanOutdoorApp')
  .controller('ArticleCtrl',['$scope', '$http', '$timeout', 'Trendword','Segmenter','lodash' , function ($scope, $http, $timeout, Trendword, segmenter, lodash) {
    // define scope
    $scope.trendwordName = '';
    $scope.items = [];
    $scope.mainTitle = '';
    $scope.subTitle = '';
    $scope.description = '';
    $scope.currentPage = 1;
    $scope.totalPages = 1;
    $scope.lastPage = false;
    $scope.contentElements = [
      { tagName: 'description', data: '説明'},
      { tagName: 'hr', data: 'ページ区切り'}
    ];
    $scope.contentsHeaderArea = [];
    $scope.contentsArea = [];
    $scope.progressStaus = null;
    $scope.tabs = [
      { title: '必須項目'},
      { title: '中見出し'},
      { title: 'テキスト登録'},
      { title: '画像登録'},
      { title: 'リンクボタン'},
      { title: 'レイアウト編集'}
    ];
    $scope.selectedTab = 0;
    $scope.thumbnailText = '';
    $scope.instagram = '';
    $scope.trendwords = [];
    $scope.requiredElementsFlag = false;
    $scope.titleImageFlag = false;
    $scope.colors = [
      {name: '黒', value: 0},
      {name: '白', value: 1}
    ];
    $scope.theme = $scope.colors[0];
    $scope.articleID = 0;
    $scope.storeID = 0;
    $scope.selectedItems = [];
    $scope.brandID = 0;
    $scope.storeName = '';

    var query = Trendword.list();
    query.$promise.then(function(response){
      $scope.trendwordsDictionary = response.trendwords;
    });
    $scope.selectTab = function(index){
      $scope.selectedTab = index;
    };

    $scope.dropValidateHandler = function($drop, $event, $data) {
      if ($drop.element[0] === $event.srcElement.parentNode) {
        // Don't allow moving to same container
        return false;
      }
      return true;
    };

    $scope.dropSuccessHandler = function($event, index, array) {
      array.splice(index, 1);
    };

    $scope.onDrop = function($event, $data, array, index) {
      if (index !== undefined) {
        array.splice(index, 0, $data);
      } else {
        array.push($data);
      }
    };
    $scope.regist = function(publishStatus) {
      var params,
          postURL = '/admin/articles/elements',
          status = {
            draft: 0 ,
            published: 1
          };
      params = {
        article :{
          data: $scope.contentsArea,
          id: $scope.articleID,
          status: status[publishStatus]
        }
      };
      $scope.progressStaus = 'width:30%;';
      $http.post(postURL, params).
        then(function(response) {
          $scope.progressStaus = 'width:100%;';
          $timeout( function(){
            $scope.message = response.data.message;
            $scope.reset();            
          }, 2000 );
        }, function(response){          
          $scope.progressStaus = null;
          $timeout( function(){
            $scope.message = '入力内容に誤りがあったため登録失敗しました';
            $scope.reset();
          }, 2000 );
        });
    };
    $scope.selectItem = function(item){
      $scope.selectedItems.push(item);
    };
    $scope.insertItems = function(){
      if ($scope.selectedItems.length > 0){
        $scope.contentsArea.push({
          tagName: 'items',
          data: $scope.selectedItems
        });
        $scope.selectedItems = [];
      }
    };
    $scope.readMore = function(){
      var items, query, params = {
        trendword_name: $scope.trendwordName,
        page: $scope.currentPage
      };
      query = Trendword.by_name(params);
      query.$promise.then(function(response){
        $scope.lastPage  = response.last_page;
        if(response.last_page === false){
          $scope.currentPage++;
        }
        items = JSON.parse(response.items);
        angular.forEach(items, function(item) {
          $scope.items.push(item);
        });
      });
    };
    $scope.requiredElements = function(){
      var formData = new FormData();
      formData.append('file',$scope.mainVisualImageFileSrc);
      formData.append('title',$scope.mainTitle);
      if(typeof $scope.titleImageFileSrc !== 'undefined' && $scope.titleImageFileSrc !== ''){
        formData.append('title_image',$scope.titleImageFileSrc);
      }
      formData.append('sub_title',$scope.subTitle);
      formData.append('theme',$scope.theme.value);
      formData.append('leading_sentence', $scope.leadingSentence);
      formData.append('editor_id', $( "#editor_name" ).val());
      formData.append('trendwords', lodash.map($scope.trendwordsForArticle,function(trendword){ return trendword.text;}));
      formData.append('searchword', $scope.searchwordForArticle);
      $http.post('/admin/articles',formData,{
        transformRequest: angular.identity,
        headers: {'Content-type':undefined}
      }).success(function(res){
        console.log(res);
        var title, subTitle, leadingSentence;
        title = {
          tagName: 'title',
          data: res.article.title
        };
        subTitle = {
          tagName: 'sub_title',
          data: res.article.sub_title
        };
        leadingSentence = {
          tagName: 'leading_sentence',
          data: res.article.leading_sentence
        };
        $scope.contentsHeaderArea.push({
          tagName: 'main_visual_image',
          data: res.article.main_visual_image,
          imagePath: res.article.main_visual_image.medium_thumb.url
        });
        if (res.article.title_image){
          $scope.contentsHeaderArea.push({
            tagName: 'title_image',
            data: res.article.title_image,
            imagePath: res.article.title_image.medium_thumb.url
          });
        }
        $scope.contentsHeaderArea.push(title);
        $scope.contentsHeaderArea.push(subTitle);
        $scope.contentsHeaderArea.push(leadingSentence);
        $scope.requiredElementsFlag = true;
        $scope.titleImageFlag = true;
        $scope.mainVisualImageFileSrc = null;
        $('.imageFile').val('');
        $scope.articleID = res.article.id;

      }).error(function(res){
        console.log(error);
      });
    };
    $scope.insertMainTitle = function(){
      $scope.contentsArea.push({
        tagName: 'title',
        data: $scope.mainTitle
      });
    };
    $scope.insertSubTitle = function(){
      $scope.contentsArea.push({
        tagName: 'sub_title',
        data: $scope.subTitle
      });
    };
    $scope.insertSubhead = function(){
      $scope.contentsArea.push({
        tagName: 'sub_head',
        data: $scope.description
      });
      $scope.description = '';
    };
    $scope.insertHeading = function(){
      console.log($scope.headingFileSrc);
      if (typeof $scope.headingFileSrc === 'undefined' || $scope.headingFileSrc === null || $scope.headingFileSrc === ''){
        $scope.contentsArea.push({
          tagName: 'heading',
          data: {
            description: $scope.heading,
            image: null
          }
        });
        $scope.heading = '';
      } else {
        var formData = new FormData();
        formData.append('file',$scope.headingFileSrc);
        formData.append('description',$scope.heading);
        formData.append('tag_name','heading');
        $http.post('/admin/articles/image_upload',formData,{
          transformRequest: angular.identity,
          headers: {'Content-type':undefined}
        }).success(function(res){
          var image = JSON.parse(res.image);
          $scope.contentsArea.push({
            tagName: 'heading',
            data: {
              description: $scope.heading,
              image: image
            }
          });
          $('.imageFile').val('');
          $scope.headingFileSrc = null;
          $scope.heading = '';
        }).error(function(res){
          console.log(res);
          $('.imageFile').val('');
          $scope.headingFileSrc = null;
          $scope.heading = '';
        });
      }
    };
    $scope.insertDescription = function(){
      $scope.contentsArea.push({
        tagName: 'description',
        data: $scope.description,
        trendwords: $scope.trendwords
      });
      $scope.description = '';
    };
    $scope.insertInstagram = function(){
      $scope.contentsArea.push({
        tagName: 'instagram',
        data: $scope.instagram
      });
      $scope.instagramURL = '';
    };
    $scope.insertPageBreak = function(){
      $scope.contentsArea.push({
        tagName: 'hr',
        data: 'hr'
      });
    };
    $scope.removeElement = function(index){
      $scope.contentsArea.splice(index, 1);
    };
    $scope.reset = function(){
      $scope.mainTitle = '';
      $scope.subTitle = '';
      $scope.contentsArea = [];
      return $scope.progressStaus = null;
    };
    // watch section
    $scope.$watch('trendwordName', function(newVal, oldVal) {
      if (newVal !== oldVal && typeof oldVal !== "undefined") {
        $scope.items = [];
      }
    });

    var watchImageFile = function(fileSrc, thumbnailFile){
      fileSrc = undefined;
      if (!thumbnailFile || !thumbnailFile.type.match("image.*")) {
        return;
      }
      var reader = new FileReader();
      reader.onload = function () {
        $scope.$apply(function () {
          fileSrc = reader.result;
        });
      };
      reader.readAsDataURL(thumbnailFile);
    };
    $scope.$watch("imageFile", function (imageFile) {
      watchImageFile($scope.imageFileSrc,imageFile);
    });
    $scope.$watch("thumbnailFile", function (thumbnailFile) {
      watchImageFile($scope.thumbnailFileSrc,thumbnailFile);
    });
    $scope.$watch("titleFile", function (titleFile) {
      watchImageFile($scope.titleFileSrc,titleFile);
    });
    $scope.$watch("subtitleFile", function (subtitleFile) {
      $scope.subtitleFileSrc = undefined;
      if (!subtitleFile || !subtitleFile.type.match("image.*")) {
        return;
      }
      var reader = new FileReader();
      reader.onload = function () {
        $scope.$apply(function () {
          $scope.subtitleFileSrc = reader.result;
        });
      };
      reader.readAsDataURL(subtitleFile);
    });
    $scope.$watch("mainVisualImageFile", function (mainVisualImageFile) {
      $scope.mainVisualImageFileSrc = undefined;
      if (!mainVisualImageFile || !mainVisualImageFile.type.match("image.*")) {
        return;
      }
      var reader = new FileReader();
      reader.onload = function () {
        $scope.$apply(function () {
          $scope.mainVisualImageFileSrc = reader.result;
        });
      };
      reader.readAsDataURL(mainVisualImageFile);
    });
    $scope.$watch("headingFile", function (headingFile) {
      $scope.headingFileSrc = undefined;
      if (!headingFile || !headingFile.type.match("image.*")) {
        return;
      }
      var reader = new FileReader();
      reader.onload = function () {
        $scope.$apply(function () {
          $scope.headingFileSrc = reader.result;
        });
      };
      reader.readAsDataURL(headingFile);
    });
    $scope.$watch("titleImageFile", function (titleImageFile) {
      $scope.titleImageFileSrc = undefined;
      if (!titleImageFile || !titleImageFile.type.match("image.*")) {
        return;
      }
      var reader = new FileReader();
      reader.onload = function () {
        $scope.$apply(function () {
          $scope.titleImageFileSrc = reader.result;
        });
      };
      reader.readAsDataURL(titleImageFile);
    });
    $scope.$watch("description", function(newVal, oldVal) {
      var segs, result;
      if (newVal !== oldVal) {
        segs = segmenter.segment(newVal);
        result = lodash.intersection(segs,$scope.trendwordsDictionary);
        $scope.trendwords = result;
      }
    });
  }]);

