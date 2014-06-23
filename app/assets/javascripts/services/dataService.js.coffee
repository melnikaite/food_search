app.factory 'DataService', (Restangular) ->
  foods = (params) ->
    Restangular.all('foods').customPOST(params)

  components = ->
    Restangular.all('components').getList()

  foods: foods
  components: components
