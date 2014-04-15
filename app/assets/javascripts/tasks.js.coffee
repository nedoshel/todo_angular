FayeServerURL = "http://162.243.21.109:9293/faye"

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

app = angular.module('Todo', ['ngResource', 'faye', "xeditable"])

app.run (editableOptions) ->
  editableOptions.theme = 'bs3'

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
      $scope.tasks.push new Task(msg.task)

    if msg.action == 'destroy'
      $scope.tasks.splice(msg.index, 1)

    if msg.action == 'update'
      # find_by_id
      console.log "update: ", msg
      oldTask = ($scope.tasks.filter (t) ->
        t.id == msg.id)[0]
      for key of msg.task
        oldTask[key] = msg.task[key] unless oldTask[key] is msg.task[key]

  # создание таска
  $scope.addTask = ->
    task = Task.save $scope.newTask, ( (data, headers) ->
        errors = data.errors # format.json { render json: { errors: @task.errors.full_messages } }
        if errors?
          window.showFlashMessage errors, { type: 'danger' }
        else
          Faye.publish("/tasks", { action: 'create', task: task } )
          $scope.newTask = {}

      ), (response) ->
        errors = response.data
        window.showFlashMessage(errors, { type: 'danger' }) if errors

  $scope.delete = ($index) ->
    if confirm("Are you sure you want to delete this task?")
      $scope.tasks[$index].$delete()
      Faye.publish("/tasks", { action: 'destroy', index: $index })

  $scope.updateTask = (task, id) ->
    #$scope.task not updated yet
    #angular.extend data, {id: id}
    response = Task.update { id: id }, task, ( (data, headers) =>
        errors = data.errors
        if errors?
          window.showFlashMessage errors, { type: 'danger' }
        else
          Faye.publish("/tasks", { action: 'update', task: task, id: id } )
      ), (response) =>
        errors = response.data
        window.showFlashMessage(errors, { type: 'danger' }) if errors
]

window.initDateTimePicker = () ->
  $("input.datetimepicker").each (i) ->
    $(this).datetimepicker
      dateFormat: "dd.mm.yy"
      timeFormat: "HH:mm"
      # altDateFormat: "yy-mm-dd"
      # altTimeFormat: "HH-mm-ss z"
      # pickerTimeFormat: "HH-mm-ss z"

jQuery ->
  window.initDateTimePicker()

$(document).on "click", 'input.datetimepicker', (e) ->
  $(@).datetimepicker
    dateFormat: "dd.mm.yy"
    timeFormat: "HH:mm"
  $(@).datepicker "show"
