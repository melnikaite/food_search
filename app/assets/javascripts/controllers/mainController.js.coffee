app.controller 'MainController', ['$scope', 'DataService', '$filter', ($scope, DataService, $filter) ->
  $scope.data = {}
  $scope.options =
    without_components: []
  $scope.loading = false

  $scope.loading = true
  DataService.components().then (data) ->
    $scope.data.components = data.plain()
    $scope.loading = false

  $scope.filterByComponent = (component) ->
    if component.exclude && _.indexOf($scope.options.without_components) == -1
      $scope.options.without_components.push(component.id)
    else
      _.pull($scope.options.without_components, component.id)

  $scope.$watch 'options', (options) ->
    $scope.loading = true
    DataService.foods(options).then (data) ->
      $scope.data.foods = data.plain()
      $scope.loading = false
  , true

  $scope.selectComponents = (exclude) ->
    components = if $scope.search
      $filter('filter')($scope.data.components, $scope.search, 'strict')
    else
      $scope.data.components

    _.each components, (component) ->
      component.exclude = exclude
      true

    $scope.options.without_components = _.map _.filter($scope.data.components, 'exclude'), (component) ->
      component.id

  $scope.selectFoods = (compare) ->
    $scope.data.foods = _.map $scope.data.foods, (food) ->
      food.compare = compare
      food

  $scope.addToComparison = (food) ->
    console.log food
]
