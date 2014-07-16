app.controller 'NavigationController', ['$scope', '$location', '$anchorScroll', ($scope, $location, $anchorScroll) ->
  $scope.scrollTo = (anchor) ->
    $location.hash(anchor)
    $anchorScroll()
]
