/* 
	By David Blanco
*/
(function($){
	search = {
		container: $('div.container-search'),
		results: $('div.results'),
		init: function(btn,input){
			search.center();
			search.close();
			
			btn.on('click', function(){
				search.loading();
				search.getResults(input);
			});
			input.keypress(function(e) {
			    if(!e.ctrlKey && e.keyCode==13) {
					search.loading();
					search.getResults(input);
			    }
			});
		},
		center: function(){
			var position = $(window).width()/2 - search.container.outerWidth()/2;
			search.container.css({
				'top' : '-1px',
				'left' : position,
			});
			search.results.css({
				'max-height' : $(window).height()-80,
				'overflow' : 'auto'
			});
		},
		loading: function(){
			if(!search.results.find('img').length){
				search.results.html("<img src='imagenes/loading.gif' />");
			}
			search.container.css({
				'text-align' : 'center'
			}).slideDown(100);
		},
		close: function(){
			if(search.container.find('div.Close').length) return;
			$('<div class=Close>cerrar</div>')
				.appendTo(search.container)
				.on('click',function(){
					search.container.slideUp(300, function(){
						search.results.html("<img src='imagenes/loading.gif' />");
					});
				});
		},
		getResults: function(parametro){
			$.get('buscar.jsp?parametro='+parametro.val(), function(data){
				search.container.hide();
				search.results.html(data);
				search.container.slideDown(300);
			});
		}
	}
})(jQuery);