<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Edificio" scope="page" class="aca.catalogo.CatEdificio"/>
<jsp:useBean id="EdificioU" scope="page" class="aca.catalogo.CatEdificioLista"/>


<%
	String escuelaId = (String) session.getAttribute("escuela");

	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){//grabar
		Edificio.setEscuelaId(escuelaId);
		Edificio.setEdificioNombre(request.getParameter("nombre"));
		
		if(request.getParameter("EdificioId")!=null && !request.getParameter("EdificioId").equals("")){
			Edificio.setEdificioId(request.getParameter("EdificioId"));
			Edificio.updateReg(conElias);
		}else{
			Edificio.insertReg(conElias);
		}
		
	}else if(accion.equals("2")){//borrar
		Edificio.setEscuelaId(escuelaId);
		Edificio.setEdificioId(request.getParameter("edificioId"));
		
		Edificio.deleteReg(conElias);
	}

	ArrayList<aca.catalogo.CatEdificio> edificios = EdificioU.getListAll(conElias, escuelaId, "ORDER BY 1" );	
	
%>
<style>
	.bg-popup, .popup{
		display: none;
		position: absolute;
		top:0;
		left: 0;
	}
	.bg-popup{
		width: 100%;
		height: 100%;
		background: rgba(0,0,0,.7);
	}
	.popup{
		top: 50%;
		margin-top: -132px;
		background:white;
		padding: 15px 20px 15px 20px;
		z-index: 999;
		
		-webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
		-moz-box-sizing: border-box;    /* Firefox, other Gecko */
		box-sizing: border-box;         /* Opera/IE 8+ */
	}
	.popup{
		width: 264px;
		left: 50%;
		margin-left: -126px;
	}
	form{
		padding: 0;
		margin: 0;
	}
</style>
<div id="content">
	
	<h2><fmt:message key="aca.Edificios" /></h2>
	
	<div class="well">
		<a class="btn add btn-primary" href="#"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
	</div>

	<table class="table ">
		<tr>
			<th><fmt:message key="aca.Operacion" /></th>
			<th><fmt:message key="aca.Edificio" /></th>
		</tr>
	<%
		int cont = 0;
		for(aca.catalogo.CatEdificio edificio: edificios){
			cont++;
		
	%>
		<tr>
			<td width="45px">
				<i class="icon-remove"></i> 
				<i class="icon-pencil"></i>
				<input type="hidden" value="<%=edificio.getEdificioId() %>"> 
			</td>
			<td>
						<a href="salon.jsp?edificioId=<%=edificio.getEdificioId() %>" class="nombre">
							<%=edificio.getEdificioNombre() %>
						</a>  
				
			</td>
		</tr>
	<%
		}
	%>
	</table>


<div class="popup">
	<form name="forma" action="edificio.jsp" method="post">
		<input type="hidden" name="Accion">
		<input type="hidden" name="EdificioId">
		<p>
			<label for="nombre"><fmt:message key="aca.Nombre" />:</label>
			<input name="nombre" id="nombre" type="text" class="input-large" maxlength="70">
		</p>
		<p>
			<a href="#" class="btn btn-primary grabar"><fmt:message key="boton.Guardar" /></a>
			<a href="#" class="btn cancel"><fmt:message key="boton.Cancelar" /></a>
		</p>
	</form>
</div>
<div class="bg-popup"></div>
</div>
<script>
(function(){
	
	var popup = $('.popup'),
		bgPopup = $('.bg-popup');
	
	$('.add').on('click', function(e){
		e.preventDefault();
		document.forma.EdificioId.value = "";
		document.forma.nombre.value = "";
		show();
	});
	
	bgPopup.on('click', function(){
		hide();
	});
	
	$('.cancel').on('click', function(e){
		e.preventDefault();
		hide();
	});
	
	$('.grabar').on('click', function(e){
		e.preventDefault();
		document.forma.Accion.value="1";
		document.forma.submit();
	});
	
	$('.icon-remove').on('click', function(e){
		e.preventDefault();
		var edificioId = $(this).siblings('input').val();
		
		$.get('checkEdificio.jsp?edificioId='+edificioId, function(r){
			if($.trim(r)=='existe'){
				alert('<fmt:message key="js.EdificioError" />');
			}else{
				if(confirm("<fmt:message key="js.Confirma" />")){
					location.href="edificio.jsp?Accion=2&edificioId="+edificioId;
				}
			}
		});
		
	});
	
	$('.icon-pencil').on('click', function(e){
		e.preventDefault();
		var edificioId = $(this).siblings('input').val();
		
		document.forma.EdificioId.value = edificioId;
		document.forma.nombre.value = $.trim($(this).parent().parent().find('.nombre').text());
		show();
		
	});
	
	function hide(){
		popup.fadeOut();
		bgPopup.fadeOut();
	}
	
	function show(){
		popup.fadeIn();
		bgPopup.fadeIn();
	}
	
})();
</script>

<%@ include file= "../../cierra_elias.jsp" %>