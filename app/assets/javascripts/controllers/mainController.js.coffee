app.controller 'MainController', ($scope, DataService, $filter) ->
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

  $scope.selectComponents = (exclude) ->
    components = $filter('filter')($scope.data.components, $scope.search.title, 'search:strict')
    _.each components, (component) ->
      component.exclude = exclude
    $scope.options.without_components = _.map _.filter($scope.data.components, 'exclude'), (component) ->
      component.id

  $scope.selectFoods = (compare) ->
    $scope.data.foods = _.map $scope.data.foods, (food) ->
      food.compare = compare
      food

  $scope.addToComparison = (food) ->
    console.log food
