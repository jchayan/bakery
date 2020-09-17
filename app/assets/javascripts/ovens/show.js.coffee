$(document).on 'DOMContentLoaded', ->
  ###
  Turbolinks will make scripts added in document body trigger this
  event twice. They recommend to put the scripts in the <head> tag
  using the defer attribute.

  https://github.com/turbolinks/turbolinks#loading-your-applications-javascript-bundle

  However, the <head> tag is in the global application layout,
  putting this script there would make it run application-wide.
  As specified in the 3rd requirement, we don't want to do that,
  hence this hack (this.loaded)... There are other ways around
  but I found this to be the simplest thing to do.

  This is a violation to the DOM Specification and a design error
  from turbolinks
  ###

  if this.loaded == true
    return

  this.loaded = true
  ovenId = location.pathname.split('/').pop()
  cookieStatus = document.querySelector('.cookie-info > .status')
  eventSource = new EventSource('/ovens/' + ovenId + '/progress')
  eventSource.addEventListener 'message', (event) ->
    cookieStatus.innerHTML = event.data
    eventSource.close()
