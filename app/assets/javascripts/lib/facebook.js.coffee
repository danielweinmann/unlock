fb_root = null
fb_events_bound = false

$ ->
  loadFacebookSDK()
  bindFacebookEvents() unless fb_events_bound

bindFacebookEvents = ->
  $(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', ->
      FB?.XFBML.parse()
    )
  fb_events_bound = true

saveFacebookRoot = ->
  fb_root = $('#fb-root').detach()

restoreFacebookRoot = ->
  if $('#fb-root').length > 0
    $('#fb-root').replaceWith fb_root
  else
    $('body').append fb_root

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/#{$("body").data("locale").replace(/-/, "_")}/all.js#xfbml=1")

initializeFacebookSDK = ->
  FB.init
    appId     : $("body").data("facebook_app_id")
    channelUrl: '//unlcok.fund/channel.html'
    status    : true
    cookie    : true
    xfbml     : true
    oauth     : true
