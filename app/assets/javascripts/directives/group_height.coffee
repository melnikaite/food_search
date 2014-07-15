app.directive 'groupHeight', ['$timeout', ($timeout) ->
  scope: false
  link: (scope, element) ->
    scope.$watchCollection '[data.comparedFoods.length, options.show_same_components]', ->
      $timeout ->
        _.each element.find('.group'), (group) ->
          $(group).height('auto')

        groupsList = _.groupBy element.find('.group'), (group) ->
          $(group).data('group')

        _.each groupsList, (groupElements) ->
          max = _.max _.map groupElements, (groupElement) ->
            $(groupElement).height()
          console.log max

          _.each groupElements, (groupElement) ->
            $(groupElement).height(max)
      , 100
]
