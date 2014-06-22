app.controller 'MainController', ($scope, DataService) ->
  $scope.data =
    foods: DataService.foods()
    components: DataService.components()
