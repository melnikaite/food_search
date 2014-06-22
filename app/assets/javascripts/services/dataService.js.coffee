app.factory 'DataService', (Restangular) ->
  foods = (params) ->
    Restangular.all('main/foods').customPOST(params)

  components = (food) ->
    Restangular.all('main/components').getList(food: food)

  foods: foods
  components: components
