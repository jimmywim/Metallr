# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

  $.ajax '/trending/topics.json',
    type: 'GET'
    success: (data) ->
      $(data.data).each ->
        if this.length == 0
          return
        topicSearchLink = '<li><a href="/search/results?keyword=' + this + '">' + this + '</a></li>'
        $('.trending-topics').append(topicSearchLink)
