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

	$('.post_content').linkify({hashtagUrlBuilder: toHashTagUrl, target:"_blank"})

toHashTagUrl = (kw) ->
	return '/search/results?keyword=' + kw