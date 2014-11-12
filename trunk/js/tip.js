//tip--->
	var tipbox = jQuery('.tip');
	
	function tip(codigoId, obj){
		var $this = jQuery(obj);
		tipbox.html("<img src='imagenes/loading.gif' />");
		
		var top = $this.offset().top - 10;
		
		
		if(top+tipbox.height()>jQuery(window).height()-50){
			tipbox.show().css({
				'left': $this.offset().left + $this.width(),
				'text-align': 'center',
				'top':  $this.offset().top-tipbox.height()
			});
			
		}else{
			tipbox.show().css({
				'left': $this.offset().left + $this.width(),
				'top': top,
				'text-align': 'center'
			});
		}
		
		
		jQuery.get('tip.jsp?codigoId='+codigoId, function(data){
			tipbox.html(data);
			tipbox.css('text-align', 'left');
			
			if(top+tipbox.height()>jQuery(window).height()-50){
				tipbox.prepend(jQuery('<i class=arr-left-side-bottom></i>'));
			}else{
				tipbox.prepend(jQuery('<i class=arr-left-side ></i>'));
			}
		});
	}
	
	jQuery('.container-search').on('click', hideTip);
	
	function hideTip(){
		tipbox.hide();
	}