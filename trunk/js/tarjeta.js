// Cambia el signo "$" a "jQuery" para eliminar los conflictos con otras librerias js

jQuery(document).ready(
	function () {
		var tarjeta;
  		jQuery("body").append('<div id="divTarjeta">alumno</div>');
  		tarjeta = jQuery("#divTarjeta");
  		tarjeta.hide();
  		
  		jQuery(".tarjeta").hover(
  			function (e) {	
    			tarjeta.show();
    			tarjeta.css("left",e.clientX+document.body.scrollLeft+5);
    			tarjeta.css("top",e.clientY+document.body.scrollTop+5);
    			tarjeta.load("../../ajax/tarjeta.jsp?codigo="+jQuery(this).attr('id'));
  			},
  			function () {
    			tarjeta.hide();
  			}
  		)
  		jQuery(".tarjeta").mousemove(
  			function (e){
    			tarjeta.css("left",e.clientX+document.body.scrollLeft+5);
    			tarjeta.css("top",e.clientY+document.body.scrollTop+5);
  			}
  		)
	}
)