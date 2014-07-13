app.controller 'MainController', ['$scope', 'DataService', '$filter', ($scope, DataService, $filter) ->
  $scope.data =
    comparedFoods: []
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

  # add all foods to the comparison list
  $scope.selectFoods = (compare) ->
    $scope.data.comparedFoods = []

    $scope.data.foods = _.map $scope.data.foods, (food) ->
      food.compare = compare
      food

    if compare
      $scope.loading = true
      DataService.foods(ids: _.pluck($scope.data.foods, 'id')).then (data) ->
        _.each data.plain(), (comparedFood) ->
          $scope.data.comparedFoods.push(comparedFood)
        $scope.loading = false

  # add one food to the comparison list
  $scope.compare = (food) ->
    if food.compare
      $scope.loading = true
      DataService.foods(ids: [food.id]).then (data) ->
        _.each data.plain(), (comparedFood) ->
          $scope.data.comparedFoods.push(comparedFood)
        $scope.loading = false
    else
      _.remove $scope.data.comparedFoods, (comparedFood) ->
        comparedFood.id == food.id
]
