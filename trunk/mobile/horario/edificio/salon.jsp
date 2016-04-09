<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Salon" scope="page" class="aca.catalogo.CatSalon"/>
<jsp:useBean id="SalonU" scope="page" class="aca.catalogo.CatSalonLista"/>

<%
	String edificioId = request.getParameter("edificioId");

	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){//grabar
		Salon.setEdificioId(edificioId);
		Salon.setSalonClave(request.getParameter("clave"));
		Salon.setSalonNombre(request.getParameter("nombre"));
		Salon.setLimite(request.getParameter("limite"));
		
		if(request.getParameter("SalonId")!=null && !request.getParameter("SalonId").equals("")){
			Salon.setSalonId(request.getParameter("SalonId"));
			Salon.updateReg(conElias);
		}else{
			Salon.insertReg(conElias);
		}
		
	}else if(accion.equals("2")){//borrar
		Salon.setSalonId(request.getParameter("salonId"));
		
		Salon.deleteReg(conElias);
	}

	ArrayList<aca.catalogo.CatSalon> salones = SalonU.getListAll(conElias, edificioId, "ORDER BY 1" );	
	
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
		margin-top: -152px;
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

	<h2><fmt:message key="aca.Salones" /></h2>
	<div class="well">
		<a class="btn btn-primary" href="edificio.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a class="btn btn-primary add" href="#"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
	</div>

	<table class="table">
		<tr>
			<th><fmt:message key="aca.Operacion" /></th>
			<th><fmt:message key="aca.Clave" /></th>
			<th><fmt:message key="aca.Nombre" /></th>
			<th><fmt:message key="aca.Limite" /></th>
		</tr>
	<%
		int cont = 0;
		for(aca.catalogo.CatSalon salon: salones){
			cont++;
		
	%>
		<tr>
			<td width="45px">
				&nbsp;
				<i class="icon-remove"></i> 
				<i class="icon-pencil"></i>
				<input type="hidden" value="<%=salon.getSalonId() %>"> 
			</td>
			<td class="clave">
					<%=salon.getSalonClave() %> 
			</td>
			<td class="nombre">
					<%=salon.getSalonNombre() %> 
			</td>
			<td class="limite">
					<%=salon.getLimite() %> 
			</td>
		</tr>
	<%
		}
	%>
	</table>
</div>

<div class="popup">
	<form name="forma" action="salon.jsp" method="post">
		<input type="hidden" name="Accion">
		<input type="hidden" name="SalonId">
		<input type="hidden" name="edificioId" value="<%=edificioId%>">
		<p>
			<label for="nombre"><fmt:message key="aca.Clave" />:</label>
			<input name="clave" id="clave" type="text" class="input-mini" maxlength="10">
		</p>
		<p>
			<label for="nombre"><fmt:message key="aca.Nombre" />:</label>
			<input name="nombre" id="nombre" type="text" class="input-large" maxlength="40">
		</p>
		<p>
			<label for="nombre"><fmt:message key="aca.Limite" />:</label>
			<input name="limite" id="limite" type="text" class="input-mini" maxlength="10">
		</p>
		<p>
			<a href="#" class="btn btn-primary grabar"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
			<a href="#" class="btn cancel"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></a>
		</p>
	</form>
</div>
<div class="bg-popup"></div>

<script>
(function(){
	
	var popup = $('.popup'),
		bgPopup = $('.bg-popup');
	
	$('.add').on('click', function(e){
		e.preventDefault();
		document.forma.SalonId.value = "";
		document.forma.nombre.value = "";
		document.forma.clave.value = "";
		document.forma.limite.value = "";
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
		
		if(document.forma.nombre.value!="" && document.forma.clave.value!="" && document.forma.limite.value){
			document.forma.Accion.value="1";
			document.forma.submit();	
		}else{
			alert("<fmt:message key="aca.CamposRequeridos" />");
		}
		
	});
	
	$('.icon-remove').on('click', function(e){
		e.preventDefault();
		var salonId = $(this).siblings('input').val();
		
		
		if(confirm("<fmt:message key="js.Confirma" />")){
			location.href="salon.jsp?Accion=2&salonId="+salonId+"&edificioId="+document.forma.edificioId.value;
		}
		
	});
	
	$('.icon-pencil').on('click', function(e){
		e.preventDefault();
		var salonId = $(this).siblings('input').val();
		
		document.forma.SalonId.value = salonId;
		document.forma.nombre.value = $.trim($(this).parent().parent().find('.nombre').text());
		document.forma.clave.value = $.trim($(this).parent().parent().find('.clave').text());
		document.forma.limite.value = $.trim($(this).parent().parent().find('.limite').text());
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