FayeServerURL = "http://162.243.21.109/faye"

# =============== faye init ===================
angular.module "faye", []

angular.module("faye").factory "$faye", ["$q", "$rootScope", ($q, $rootScope) ->
  (url, fun) ->
    scope = $rootScope
    client = new Faye.Client(url)
    fun?(client)


    client: client
    publish: (channel, data) ->
      @client.publish channel, data

    subscribe: (channel, callback) ->
      @client.subscribe channel, (data) ->
        scope.$apply ->
          callback(data)

    get: (channel) ->
      deferred = $q.defer()
      sub = @client.subscribe(channel, (data) ->
        scope.$apply ->
          deferred.resolve data
        sub.cancel()
      )
      deferred.promise
]
# =============== faye init ===================

app = angular.module('Todo', ['ngResource', 'faye'])

app.factory "Task", ["$resource", ( $resource ) ->
  $resource("/tasks/:id.json", { id: "@id" }, { update: { method: 'PUT' } })
]

app.factory 'Faye', ['$faye', ($faye) ->
  $faye(FayeServerURL)
]

@TodosCtrl = [ "$scope", "Task", "$http", "Faye", ($scope, Task, $http, Faye) ->

  $scope.tasks = Task.query()

  Faye.subscribe "/tasks", (msg) ->
    # console.log "faye", msg

    if msg.action == 'create'
      $scope.tasks.push msg.task

    if msg.action == 'destroy'
      $scope.tasks.splice(msg.index, 1)

  $scope.addTask = ->
    task = new Task($scope.newTask)
    task.$save ((data, headers) ->
        Faye.publish("/tasks", { action: 'create', task: task } )
        $scope.newTask = {}
      ), (response) ->
        errors = response.data
        window.showFlashMessage(errors, { type: 'danger' }) if errors


  $scope.delete = ($index) ->
    if confirm("Are you sure you want to delete this task?")
      $scope.tasks[$index].$delete()
      Faye.publish("/tasks", { action: 'destroy', index: $index })
]

jQuery ->
  $("input.datetimepicker").each (i) ->
    $(this).datetimepicker
      dateFormat: "dd.mm.yy"
      timeFormat: "HH:mm"
