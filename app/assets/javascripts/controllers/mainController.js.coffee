app.controller 'MainController', ($scope, DataService) ->
  $scope.data = {}
  $scope.options =
    without_components: []

  DataService.components().then (data) ->
    $scope.data.components = data

  $scope.filterByComponent = (component) ->
    if component.exclude && _.indexOf($scope.options.without_components) == -1
      $scope.options.without_components.push(component.id)
    else
      _.pull($scope.options.without_components, component.id)

  $scope.$watch 'options', (options) ->
    DataService.foods(options).then (data) ->
      $scope.data.foods = data
  , true

  $scope.addToComparison = (food) ->
    console.log food
