/*
 * 
 * 	By David Blanco
 * 
 * 
 */

(function($) {

    var Search = function(element, options){
        //Defaults are below
        var settings = $.extend({}, $.fn.search.defaults, options);
        

        var table = settings.table,
		tbody = table.children('tbody'),
		tr    = tbody.children('tr');
	
		$(element).keyup(function(){
			var value = $(this).val();
			tr.each(function(){
				$this = $(this);
				var encontro = false;
				$this.find('td').each(function(){
					if( $(this).html().toLowerCase().indexOf(value.toLowerCase()) !== -1 ){
						encontro = true;
					}
				});
				if(!encontro){
					$this.hide();
				}else{
					$this.show();
				}
			});
		});

        return this;

    };//END


        
    $.fn.search = function(options) {
        return this.each(function(key, value){
            var element = $(this);
            var dontUpdate = options.dontUpdate ?? true;
            // Return early if this element already has a plugin instance
            if (dontUpdate && element.data('search')) {
            	return element.data('search');
            }
            // Pass options to plugin constructor
            var search = new Search(this, options);
            // Store plugin object in this element's data
            element.data('search', search);
        });
    };
  
    //Default settings
    $.fn.search.defaults = {
        table: $('#table')
    };
    
    $.fn._reverse = [].reverse;
  
})(jQuery);