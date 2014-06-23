app.controller 'MainController', ($scope, DataService) ->
  $scope.data = {}
  $scope.options =
    without_components: []
  $scope.loading = false

  $scope.loading = true
  DataService.components().then (data) ->
    $scope.data.components = data
    $scope.loading = false

  $scope.filterByComponent = (component) ->
    if component.exclude && _.indexOf($scope.options.without_components) == -1
      $scope.options.without_components.push(component.id)
    else
      _.pull($scope.options.without_components, component.id)

  $scope.$watch 'options', (options) ->
    $scope.loading = true
    DataService.foods(options).then (data) ->
      $scope.data.foods = data
      $scope.loading = false
  , true

  $scope.addToComparison = (food) ->
    console.log food
