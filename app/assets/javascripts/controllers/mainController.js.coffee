app.controller 'MainController', ['$scope', 'DataService', '$filter', ($scope, DataService, $filter) ->
  $scope.data =
    comparedFoods: []
  $scope.options =
    without_components: []
  $scope.component_search =
    title: ''
  $scope.food_search =
    title: ''
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
    components = $filter('filter')($scope.data.components, $scope.component_search, 'strict')
    _.each components, (component) ->
      component.exclude = exclude
      true

    $scope.options.without_components = _.map _.filter($scope.data.components, 'exclude'), (component) ->
      component.id

  # add all foods to the comparison list
  $scope.selectFoods = (compare) ->
    $scope.data.comparedFoods = []

    foods = $filter('filter')($scope.data.foods, $scope.food_search, 'strict')
    _.each foods, (food) ->
      food.compare = compare
      true

    if compare
      $scope.loading = true
      DataService.foods(ids: _.pluck(foods, 'id')).then (data) ->
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
      $scope.removeFromComparison(food)

  # hide same components
  $scope.sameComponentExists = (component) ->
    if $scope.options.show_same_components || $scope.data.comparedFoods.length < 2
      return false

    groups = _.map $scope.data.comparedFoods, (food) ->
      _.flatten _.map food.components, (group) ->
        _.pluck group.components_in_group, 'id'

    _.all groups, (component_ids) ->
      _.include component_ids, component.id

  $scope.removeFromComparison = (food) ->
    foodItem = _.find $scope.data.foods, {id: food.id}
    foodItem.compare = false if foodItem

    _.remove $scope.data.comparedFoods, (comparedFood) ->
      comparedFood.id == food.id
]
