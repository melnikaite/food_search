app.controller 'MainController', ($scope, DataService) ->
  $scope.data = {}

  DataService.foods().then (data) ->
    $scope.data.foods = data

  DataService.components().then (data) ->
    $scope.data.components = data

  $scope.updateComponent = (component) ->
    excludedComponents = _.filter $scope.data.components, (component) ->
      component.exclude

    ids = _.map excludedComponents, (component) ->
      component.id

    DataService.foods(without_components: ids).then (data) ->
      $scope.data.foods = data
