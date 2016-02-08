'use strict';

/**
 * @ngdoc overview
 * @name UrbanOutdoorApp
 * @description
 * # UrbanOutdoorApp
 *
 * Main module of the application.
 */
angular
  .module('UrbanOutdoorApp', [
    'ngResource',
    'ngTagsInput',
    'ang-drag-drop',
    'ngLodash'
  ])
  .config(["$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]);

