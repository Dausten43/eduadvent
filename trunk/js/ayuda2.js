var dom = document.getElementById;
var ie  = document.all;
var obj,crossobj;
var x,y;
var visible = false;
	
	if (dom) {
		document.write("<div id=\"Texto\" style=\"z-index:+999;position:absolute;visibility:visible;\">");
			
		document.write("</div>");
		obj = document.getElementById("Texto");
		crossobj = obj.style;
		}
		
	function Ayuda(event,frase){
		if(!visible){
			MuestraAyuda(event,frase);
		}else{
			OcultaAyuda();
		}
	}
		
	function MuestraAyuda(event,frase){
		var leftpos = 0;
		var toppos  = 0;
		crossobj.visibility = (dom||ie) ? "visible" : "show";
		if(ie){
			crossobj.left = window.event.clientX + document.documentElement.scrollLeft
	      					+ document.body.scrollLeft;;
			crossobj.top = window.event.clientY + document.documentElement.scrollTop
	      					+ document.body.scrollTop;
		}else{
			crossobj.left = event.clientX+"px";
			crossobj.top = event.clientY+"px";
		}
		
		crossobj.background = "yellow";
		crossobj.border = "outset";
		obj.innerHTML = frase;
		visible = true;
	}
	
	function OcultaAyuda(){
		crossobj.visibility = "hidden";
		visible = false;
	}
	
	document.body.onmousedown = verificaAyuda;
	
	function verificaAyuda(event){
		if(visible == true){
			OcultaAyuda();
		}
	}