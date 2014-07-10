
overlayTimer = 0

delay = (ms, func) -> setTimeout func, ms

height = 0

setHeight = ()->
	h = $(window).height()
	$('body').height(h)

size = ()->
	setHeight()

animate = (el, eff, act, out)->
	if act == 'show'
		$(el).show()
	$(el).addClass('animated '+eff).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ()->
		$(this).removeClass('animated '+eff);
		if act == 'hide'
			$(el).hide()

init =()->
	params = {
		center: [55.747044, 37.664958]
		zoom: 16
	}
	myMap = new ymaps.Map "map", params
	myPlacemark = new ymaps.Placemark(myMap.getCenter(), {
    }, {
        preset: 'islands#redDotIcon'
    })
	myMap.geoObjects.add(myPlacemark)

$(document).ready ->

	FastClick.attach(document.body);

	$('#catalog .bar .trigger').tooltip('show')

	$('body').imagesLoaded ()->
		size()

	ymaps.ready(init);

	


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
		animate parent, 'slideOutRight', 'hide'
		e.preventDefault()

	$('.switcher a').on 'click', (e)->
		$(this).parents('.switcher').find('a').removeClass 'active'
		$(this).addClass 'active'
		parent = $(this).attr('href')
		if $(parent).is ':hidden'
			$(this).parents('.block').find(".switch-item:not(.main, #{parent})").hide()
			animate parent, 'fadeInDown', 'show'
		e.preventDefault()

	$('a.toggle').on 'click ', (e)->
		parent = $(this).attr('href')
		if parent == '#order' && $(this).hasClass('one-click')
			$('.switcher a[href="#short-order"]').trigger 'click'
		if $(this).parents('#bottom-nav').length > 0
			if $(parent).is ':hidden'
				animate parent, 'fadeInDown', 'show'
			if $(".block:visible:not(.main, #{parent})").length > 0
				animate ".block:visible:not(.main, #{parent})", 'fadeOutUp', 'hide'
			$('#bottom-nav a.active').removeClass 'active'
			$(this).addClass 'active'
		else
			animate parent, 'slideInRight', 'show'
		e.preventDefault()

	$('input[type=radio]').iCheck();

	$('a.buy').on 'click', (e)->
		val = parseInt($('#bottom-nav a[href="#cart"] .counter').text())
		$('#bottom-nav a[href="#cart"] .counter').text(val+1)
		animate '#bottom-nav a[href="#cart"] .counter', 'fadeInUp', 'show'
		e.preventDefault()

	$('.block .content').on 'scroll', ()->
		scroll = $(this).scrollTop()
		bar  = $(this).parent().find('.bar')
		
		if scroll > 0 && !bar.hasClass('shadow')
			bar.addClass('shadow')
		else if scroll <= 0 && bar.hasClass('shadow')
			bar.removeClass('shadow')

		fade = $(this).parent().find('.bottom-fade')
		pos = scroll + $(window).height()
		height = $(this).find('.elements').height() + $(this).find('.fotorama').height() + parseInt($(this).css('padding-top').split('px')[0])

		if($(this).parents('.block').attr('id')=="cart")
			height += parseInt($(this).css('padding-bottom').split('px')[0]) - 10

		if height < pos || ($(this).parents('.block').attr('id') == 'product' && scroll > 50)
			fade.addClass('on') if !fade.hasClass('on')
		else
			fade.removeClass('on')

	x = undefined
	delay 400, ()->
		window.scrollTo(0,1);
		size()
	$(window).resize ->
		clearTimeout(x)
		x = delay 400, ()->
			window.scrollTo(0,1);
			size()
   
