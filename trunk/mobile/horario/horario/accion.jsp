<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Horario" scope="page" class="aca.catalogo.CatHorario"/>
<jsp:useBean id="HorarioPeriodo" scope="page" class="aca.catalogo.CatHorarioPeriodo"/>

<script>
	function Grabar(){			
		if(document.forma.nombre.value!=""){			
			document.forma.Accion.value="1";				
			document.forma.submit();			
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	
	String horarioId 	= request.getParameter("HorarioId")==null?"-1":request.getParameter("HorarioId");
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String resultado 	= "";
	String salto		= "X";
	
	HorarioPeriodo.setHorarioId(horarioId);
	
	if(accion.equals("1")){//grabar
		Horario.setEscuelaId(escuelaId);
		Horario.setHorarioNombre(request.getParameter("nombre"));
		Horario.setEstado(request.getParameter("Estado"));
		
		if(horarioId!=null && !horarioId.equals("") && !horarioId.equals("-1")){
			Horario.setHorarioId(request.getParameter("HorarioId"));
			if(Horario.updateReg(conElias)){
				resultado = "Modificado";
			}else{
				resultado = "NoModifico"; 
			}
		}else{
			if(Horario.insertReg(conElias)){
				resultado = "Guardado";
			}else{
				resultado = "NoGuardo";
			}
		}
		
	}else if(accion.equals("2") && !HorarioPeriodo.existeHorario(conElias)){//borrar
		Horario.setEscuelaId(escuelaId);
		Horario.setHorarioId(horarioId);
		
		if(Horario.deleteReg(conElias)){
			salto = "horario.jsp";	
		}else{
			resultado = "NoElimino";
		}
	}
	
	pageContext.setAttribute("resultado", resultado);
	
	Horario.mapeaRegId(conElias, horarioId);

%>

<div id="content">
	
	<h2><fmt:message key="boton.Anadir" /></h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a href="horario.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form name="forma" action="accion.jsp" method="post">
		<input type="hidden" name="Accion">
		<input type="hidden" name="HorarioId" value="<%=horarioId %>">
		<p>
			<label for="nombre"><fmt:message key="aca.Nombre" /></label>
			<input name="nombre" id="nombre" type="text" class="input-large" maxlength="40" value="<%=Horario.getHorarioNombre() %>">
		</p>
		<p>
			<label for="nombre"><fmt:message key="aca.Estado" /></label>
			<select  id="Estado" name="Estado">										
					<option value="A" <%if(Horario.getEstado().equals("A"))out.print("selected"); %>><fmt:message key="aca.Activo" /></option>
					<option value="I" <%if(Horario.getEstado().equals("I"))out.print("selected"); %>><fmt:message key="aca.Inactivo" /></option>
			</select>	
		</p>
		<div class="well">
			<a href="javascript:Grabar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		</div>
	</form>
	
	
</div>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>