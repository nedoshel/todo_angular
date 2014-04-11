window.hideFlashMessages = () ->
  if $(".alert.fade.in").length
    window.setTimeout (->
      $(".alert.fade.in").fadeTo(500, 0).slideUp 500, ->
        $(this).remove()
    ), 5000

window.showFlashMessage = (message, options) ->
  options = $.extend(
    type: "notice"
  , options)
  options.type = "success"  if options.type is "notice"
  $flashContainer = $(".container .row:first")
  $flash = $("<div class=\"alert fade in alert-" + options.type + "\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>" + message + "</div>")
  $flashContainer.prepend $flash
  window.hideFlashMessages()

$(document).on 'ready page:load', ->
  window.hideFlashMessages()