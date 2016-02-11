'use strict';

angular.module('UrbanOutdoorApp')
  .factory('Article', ['$resource' ,function ($resource) {
    return $resource('/admin/articles/:id.json',{
      id: '@id'
    },{
      save: {
        method: 'POST',
        headers : {
          'Content-Type': 'application/json'
        }
      }
    });
  }]);
