<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>

<jsp:useBean id="cicloPeriodo" scope="page" class="aca.ciclo.CicloPeriodo"/>
<%
	String cicloId		= request.getParameter("ciclo");
	String periodoId	= request.getParameter("periodo");
	String accion		= request.getParameter("Accion");
	String tipoGuardado = "";
	
	if(periodoId != null){
		if(!periodoId.equals("")){
			cicloPeriodo.mapeaRegId(conElias, cicloId, periodoId);
			tipoGuardado = "Modificar";
		}else{
			periodoId = "";
			tipoGuardado = "Guardar";
		}
	}else{
		periodoId = "";
		tipoGuardado = "Guardar";
	}
	
	if(accion == null)
		accion = "0";
	
	if(accion.equals("1")){
		cicloPeriodo.setPeriodoNombre(request.getParameter("nombre"));
		cicloPeriodo.setFInicio(request.getParameter("fInicio"));
		cicloPeriodo.setFFinal(request.getParameter("fFinal"));
		if(tipoGuardado.equals("Guardar")){	// Guardar			
			cicloPeriodo.setCicloId(cicloId);
			cicloPeriodo.setPeriodoId(cicloPeriodo.siguientePeriodo(conElias, cicloId));
			if(cicloPeriodo.insertReg(conElias)){
%>
<table align="center">
	<tr>
		<td><font color="blue" size="3"><b>Se guard&oacute; correctamente el periodo!!!</b></font></td>
	</tr>
</table>
<%
			}else{
%>
<table align="center">
	<tr>
		<td><font color="red" size="3"><b>Ocurri&oacute; un error al guardar. Int&eacute;ntelo de nuevo</b></font></td>
	</tr>
</table>
<%
			}
		}else{	//Modificar
			if(cicloPeriodo.updateReg(conElias)){
%>
<table align="center">
	<tr>
		<td><font color="blue" size="3"><b>Se modific&oacute; correctamente el periodo</b></font></td>
	</tr>
</table>
<%
			}else{
%>
<table align="center">
	<tr>
		<td><font color="red" size="3"><b>Ocurri&oacute; un error al modificar. Int&eacute;ntelo de nuevo</b></font></td>
	</tr>
</table>
<%
			}
		}
	}
%>
<head>
	<script type="text/javascript">
		function revisa(){
			if(document.getElementById("nombre").value != "" &&
			   document.getElementById("fInicio").value != "" &&
			   document.getElementById("fFinal").value != ""){
				return true;
			}else{
				alert("Todas las casillas deben llenarse para poder guardar!!!");
			}
			return false;
		}
	</script>
</head>
<body>
	<div id=content>
	<h2>Editar Período</h2>
		<div class="well" style="overflow:hidden;">
			<a class="btn btn-primary "href="listado.jsp?ciclo=<%=cicloId %>"><i class="icon-arrow-left icon-white"></i> Regresar</a>
		</div>
		<form id="forma" name="forma" action="edita_periodo.jsp?Accion=1&ciclo=<%=cicloId %>&periodo=<%=periodoId %>" method="post">
			<fieldset>
				<div class="control-group ">
				<label for="nombre">
		        	Nombre:
		         	<span class="required-indicator">*</span>
		        </label>
					<input type="text" id="nombre" name="nombre" value="<%=cicloPeriodo.getPeriodoNombre() %>" maxlength="40" size="30" />
				</div>
				<div class="control-group">
					<label for="fInicio">
		        	F. Inicio:
		         	<span class="required-indicator">*</span>	
		        	</label>
		        	<input type="text" id="fInicio" name="fInicio" value="<%=cicloPeriodo.getFInicio() %>" size="8" maxlength="10" /> DD/MM/YYYY
				</div>
				<div class="control-group">
					<label for="fFinal">
		        	F. Final:
		         	<span class="required-indicator">*</span>
		        	</label>
		        	<input type="text" id="fFinal" name="fFinal" value="<%=cicloPeriodo.getFFinal() %>" size="8" maxlength="10" /> DD/MM/YYYY
				</div>
			</fieldset>
			<div class="well" style="overflow:hidden;">
				<input class="btn btn-primary" type="submit" value="<%=tipoGuardado %>" onclick="return revisa();" />
			</div>
		</form>
	</div>	
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fInicio').datepicker();
	$('#fFinal').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>