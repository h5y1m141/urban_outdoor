'use strict';

angular.module('UrbanOutdoorApp')
  .directive('previewText', function($compile) {
    var selectTemplate = function(tag){
      var templateHTML;
      if(tag === 'sub_head'){
        templateHTML = '<h3>{{ contents }}</h3>';
      } else {
        templateHTML = '<h4>{{ contents }}</h4>';
      }
      return templateHTML;
    };
    return {
      restrict: 'E',
      scope: {
        tag: '=tag',
        contents: '=data'
      },
      link: function (scope, element, attrs) {
        var template;
        template = selectTemplate(scope.tag);
        element.html(template);
        $compile(element.contents())(scope);
      }
    };
  });
