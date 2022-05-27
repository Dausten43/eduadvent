<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.fin.FinTopeNivelEscuela"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.math.BigDecimal"%>

<jsp:useBean id="FinLimite" scope="page" class="aca.fin.FinTopeNivelEscuelaUtils"/>


<%
	String escuela			= (String) session.getAttribute("escuela");
	String nivelTxt			= request.getParameter("nivelAcademicoSistema")!=null ? (String) request.getParameter("nivelAcademicoSistema") : "-1";
	String importeTxt		= request.getParameter("importe")!=null ? (String) request.getParameter("importe") : "0.00" ;
	String accion 			= request.getParameter("Accion")==null ?"0": request.getParameter("Accion");
	String resultado 		= "";
	
	
	
	
	
	if(accion.equals("1")){
		Integer nivel = Integer.parseInt(nivelTxt);
		BigDecimal importe = new BigDecimal(importeTxt);
		
		FinLimite.guardaTope(conElias, escuela, nivel, importe );
		
	}
	
	List<FinTopeNivelEscuela> registros = FinLimite.traeRegistroEscuela(conElias,escuela);
	System.out.println(registros.size());
	pageContext.setAttribute("resultado", resultado);
	
	List<String> listaOpciones = new ArrayList();

	if(escuela.startsWith("S")){

		listaOpciones.add("<option value=\"2\" >Parvularia</option>");
		listaOpciones.add("<option value=\"3\" >Primer - Segundo Ciclo</option>");
		listaOpciones.add("<option value=\"4\" >Tercer Ciclo</option>");
		listaOpciones.add("<option value=\"5\" >Educacion Media</option>");
	}else{
		listaOpciones.add("<option value=\"0\" >Maternal</option>");
		listaOpciones.add("<option value=\"1\" >Pre-Kinder</option>");
		listaOpciones.add("<option value=\"2\" >Kinder</option>");
		listaOpciones.add("<option value=\"3\" >Primaria</option>");
		listaOpciones.add("<option value=\"4\" >Secundaria o Pre-Media</option>");
		listaOpciones.add("<option value=\"5\" >Bachillerato</option>");
	}
	
%>
<html>
	<div id="content">
		<% if (!resultado.equals("")){%>
	   		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
	  	<% }%>
		<div class="well" style="overflow:hidden;">
			<h2>L&iacute;mite de deuda por nivel</h2>
		</div>
		<p>Para establecer un limite de deuda por nivel elija el nivel deseado y coloque la cantidad 
		maxima de deuda que es permitida para ese nivel antes de suspender las funcionalidades del portal
		
		<ul>
			<li>Para alta a un nuevo registro elija el nivel deseado y el importe limite y pulse el boton grabar</li>
			<li>Para modificar un registro, elija el nivel deseado y coloque el nuevo importe y pulse grabar.
			<li>Para desactivar un registro, elija el nivel deseado y coloque en ceros (<strong>0.00</strong>) en el importe y pulse grabar</li>
		</ul>
		</p>
		<hr>
		<form name="frmLimite" method="post" class="form-inline">
			<input name="escuela" type="hidden" value="<%=escuela%>" />
			<input name="Accion" type="hidden" />
			<fieldset>
				<label form="nivelAcademicoSistema">Nivel de ciclo:</label>
				  	<select name="nivelAcademicoSistema" id="nivelAcademicoSistema">
				  		<option value="-1" >No Definido</option>
				  		<%
				  			for(String op : listaOpciones){
				  				out.println(op);
				  			}
				  		%>
				  	</select>
				  	<input style="text-align : right;" type="text" name="importe" id="importe" value="0.00" placeholder="importe">
			</fieldset>	
			<hr>
			<div class="well" style="overflow:hidden;">
				<button class="btn btn-primary" onclick="javascript:Graba()" ><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></button>
			</div>
		</form>
		<div class="row">
			<div class="span8">
				<table class="table table-striped">
					<thead>
						<tr>
							<th>Nivel</th>
							<th style="text-align: center;">Importe</th>
							<th style="text-align: center;">Fecha Modificado</th>
						</tr>
					</thead>
					<tbody>
					<%
						for(FinTopeNivelEscuela ft : registros ){
							
							String nivelText = "";
							
							switch (ft.getNivelSistema()) {
							case -1 : nivelText="NO DEFINIDO";
								break;
							case 0 : nivelText="MATERNAL";
								break;
							case 1 : nivelText="PRE-KINDER";
								break;
							case 2 : nivelText="KINDER";
								break;
							case 3 : nivelText="PRIMARIA";
								break;
							case 4 : nivelText="SECUNDARIA O PRE-MEDIA";
								break;
							case 5 : nivelText="BACHILLERATO";
								break;
							default : nivelText="NO VALIDO";
							}
							
							
							
					%>
						<tr>
							<td><%= nivelText %></td>
							<td style="text-align: right;"><%= ft.getImporteTope() %></td>
							<td style="text-align: center;"><%= ft.getFechaActualizado() %></td>
						</tr>
					<%
						}
					%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script>
		function Graba(){		
			document.frmLimite.Accion.value = "1";
			document.frmLimite.submit();
		}
	</script>
</html>

<%@ include file= "../../cierra_elias.jsp" %>