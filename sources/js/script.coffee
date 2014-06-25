
overlayTimer = 0

delay = (ms, func) -> setTimeout func, ms

height = 0

setHeight = ()->
	h = $(window).height()
	$('body').height(h)

size = ()->
	setHeight()
	$('#catalog .item > .item-content').width ()->
		$(this).parents('.item').width()-10
	if not container
		container = $('#catalog > .content .elements').imagesLoaded ()->
			$(this).isotope
				itemSelector: '.item'
	else
		container.isotope('layout')

animate = (el, eff, act, out)->
	if act == 'show'
		$(el).show()
	$(el).addClass('animated '+eff).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ()->
		$(this).removeClass('animated '+eff);
		if act == 'hide'
			$(el).hide()

$(document).ready ->

	FastClick.attach(document.body);

	$('#catalog .bar .trigger').tooltip('show')

	$('body').imagesLoaded ()->
		size()

	$('.bar a.trigger').on 'click', (e)->
		$('body').toggleClass('open-side')
		$('#catalog .bar .trigger').tooltip('hide').removeClass('animated')
		if $('body').hasClass('open-side')
			$('#nav').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ()->
				$(this).addClass('on');
		else
			$('#nav').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ()->
				$(this).removeClass('on');
		$('body #catalog > .content')
			.one 'touchstart click', (e)->
				if $('body').hasClass('open-side')
					$('body').removeClass('open-side')
					return false
				else
					return true
		e.preventDefault()

	$('.popup .bar .back').on 'click ', (e)->
		parent = '#'+$(this).parents('.block').attr('id')
		console.log(parent)
		animate parent, 'slideOutRight', 'hide'
		e.preventDefault()

	$('a.toggle').on 'click ', (e)->
		parent = $(this).attr('href')
		console.log parent
		animate parent, 'slideInRight', 'show'
		e.preventDefault()

	$('input[type=radio]').iCheck();

	$('.block .content').on 'scroll', ()->
		scroll = $(this).scrollTop()
		bar  = $(this).parent().find('.bar')
		
		if scroll > 0 && !bar.hasClass('shadow')
			bar.addClass('shadow')
		else if scroll <= 0 && bar.hasClass('shadow')
			bar.removeClass('shadow')

		fade = $(this).parent().find('.bottom-fade')
		pos = scroll + $(window).height()
		height = $(this).find('.elements').height()

		if($(this).parents('.block').attr('id')=="cart")
			height += fade.height()
		if height < pos
			fade.addClass('on') if !fade.hasClass('on')
		else
			fade.removeClass('on')

	x = undefined
	$(window).resize ->
		clearTimeout(x)
		x = delay 400, ()->
			window.scrollTo(0,1);
			size()
   
