app.directive 'foodWidth', [ ->
  scope: false
  link: (scope, element) ->
    scope.$watch 'data.comparedFoods.length', (length) ->
      foodWidth = element.find('.food').width()
      element.width(foodWidth * length)
]
