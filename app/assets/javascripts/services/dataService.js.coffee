app.factory 'DataService', (Restangular) ->
  foods = (foodType) ->
    Restangular.all('main/foods').getList(food_type: foodType).$object

  components = (food) ->
    Restangular.all('main/components').getList(food: food).$object

  foods: foods
  components: components
