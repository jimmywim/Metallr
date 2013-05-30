# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('#post_content').bind 'input propertychange', ->
		inputLength = 255 - this.value.length
		$('.riff-length').text(inputLength)

		if inputLength < 0
			$('.riff-length').addClass('riff-length-overflow')
			$('.actions input').attr('disabled', 'disabled')
		else
			$('.riff-length').removeClass('riff-length-overflow')
			$('.actions input').removeAttr('disabled')

	$('.post_content').linkify({hashtagUrlBuilder: toHashTagUrl})

	curUrl = document.location.href[document.location.href.length-1]

#	if curUrl == '/'
#		setInterval -> 
#			pollNewPosts '/posts'
#		, 20000
#	else if curUrl = '/replies'
#		setInterval ->
#			pollNewPosts '/replies'
#		, 20000

sinceDate = new Date

toHashTagUrl = (kw) ->
	return '/search/results?keyword=' + kw

pollNewPosts = (url) ->
	sinceDate = new Date sinceDate - 60
	month = sinceDate.getUTCMonth() + 1
	hours = sinceDate.getUTCHours()
	minutes = sinceDate.getUTCMinutes()
	seconds = sinceDate.getUTCSeconds()

	dateformat = sinceDate.getUTCDate() + '/' + month + '/' + sinceDate.getUTCFullYear() + ' ' + hours + ':' + minutes + ':' + seconds
	console.log dateformat

	$.ajax url + '.js?since=' + dateformat,
		type: 'GET'
		success: (data, textStatus, jqXhr) ->
			sinceDate = new Date
			
	