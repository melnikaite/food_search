app.controller 'MainController', ['$scope', 'DataService', '$filter', ($scope, DataService, $filter) ->
  $scope.data =
    comparedFoods: []
  $scope.options =
    without_components: []
  $scope.component_search =
    title: ''
  $scope.food_search =
    title: ''
  $scope.loading =
    foods: false
    components: false
    comparison: false
  $scope.show_same_components = false

  $scope.loading.components = true
  DataService.components().then (data) ->
    $scope.data.components = data.plain()
    $scope.loading.components = false

  # exclude one component
  $scope.filterByComponent = (component) ->
    if component.exclude && _.indexOf($scope.options.without_components) == -1
      $scope.options.without_components.push(component.id)
    else
      _.pull($scope.options.without_components, component.id)

  $scope.$watch (-> [
      $scope.options.food_types,
      $scope.options.without_harmful,
      $scope.options.without_allergen,
      $scope.options.without_components
    ]), ->
    $scope.loading.foods = true
    DataService.foods($scope.options).then (data) ->
      $scope.data.foods = data.plain()
      $scope.loading.foods = false
  , true

  # exclude all filtered components
  $scope.selectComponents = (exclude) ->
    components = $filter('filter')($scope.data.components, $scope.component_search)
    _.each components, (component) ->
      component.exclude = exclude
      true

    $scope.options.without_components = _.map _.filter($scope.data.components, 'exclude'), (component) ->
      component.id

  # add all foods to the comparison list
  $scope.selectFoods = (compare) ->
    foods = $filter('filter')($scope.data.foods, $scope.food_search)
    _.each foods, (food) ->
      food.compare = compare
      _.remove $scope.data.comparedFoods, (comparedFood) ->
        comparedFood.id == food.id
      true

    if compare
      $scope.loading.comparison = true
      DataService.foods(ids: _.pluck(foods, 'id')).then (data) ->
        _.each data.plain(), (comparedFood) ->
          $scope.data.comparedFoods.push(comparedFood)
        $scope.loading.comparison = false

  # add one food to the comparison list
  $scope.compare = (food) ->
    if food.compare
      $scope.loading.comparison = true
      DataService.foods(ids: [food.id]).then (data) ->
        _.each data.plain(), (comparedFood) ->
          $scope.data.comparedFoods.push(comparedFood)
        $scope.loading.comparison = false
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

  # remove one food from comparison
  $scope.removeFromComparison = (food) ->
    foodItem = _.find $scope.data.foods, {id: food.id}
    foodItem.compare = false if foodItem

    _.remove $scope.data.comparedFoods, (comparedFood) ->
      comparedFood.id == food.id

  # remove all foods from comparison
  $scope.clearComparison = ->
    $scope.data.comparedFoods = []
    $scope.data.foods = _.map _.find $scope.data.foods, (food) ->
      food.compare = false
]
