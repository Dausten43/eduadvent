<%@page import="java.net.URLEncoder"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "aca.empleado.EmpPersonal"%>
<%@ page import= "aca.empleado.EmpPersonalLista"%>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");

	String nombre			= request.getParameter("nombre")==null?"":request.getParameter("nombre").toUpperCase();
	String aPaterno			= request.getParameter("aPaterno")==null?"":request.getParameter("aPaterno").toUpperCase();
	String aMaterno			= request.getParameter("aMaterno")==null?"":request.getParameter("aMaterno").toUpperCase();
	String sCodigoAlumno	= request.getParameter("codigoEmpleado");	
	String sNom 			= "";
	String sPat				= "";
	String sMat				= "";
	String salto			= "X";
	
	ArrayList<aca.empleado.EmpPersonal> lisLista		= new ArrayList<aca.empleado.EmpPersonal>();
	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");		
	if(accion.equals("1")){// Se pasan los parameteros a la funcion, junto con el porcentaje de comparacion
				
		if(aMaterno.length() == 0){
			sNom = nombre;			
			sPat = aPaterno;		
		}else{
			sNom = nombre;			
			sPat = aPaterno;
			sMat = aMaterno;
		}
	
		String nombreCompleto	= sNom +" "+ sPat +" "+sMat;
		lisLista = EmpPersonalLista.getListBusqueda(conElias, escuelaId, nombreCompleto.trim().replaceAll(" ", "%"), "ORDER BY NOMBRE, APATERNO, AMATERNO");
	
	}else if(accion.equals("2")){
		session.setAttribute("codigoEmpleado", request.getParameter("codigoEmpleado"));
		salto = "accion_p.jsp";
	}
%>

<div id="content">
	
	<h2><fmt:message key="alumnos.VerificaciondeInformacion" /></h2>
	
	<div class="well">
		<a href="empleado.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		&nbsp;  &nbsp;Instrucciones: <fmt:message key="empleados.IngresaDatosEmpleado" />
	</div>
		
	<form action="datos.jsp" name="frmDatos" method="post" target="_self">
		<input type="hidden" name="Accion">
		
		<table class="table table-condensed" onkeypress='presDocumento()' style="margin-bottom: 0px;">
		 <tr>
		  <td>
		     <p>			
				<label for="Nombre"><fmt:message key="aca.Nombre" /></label>
				<input name="nombre" type="text" class="text" size="20" value="<%=nombre%>">
			</p>
		  </td>
				
		  <td>
		    <p>
				<label for="Paterno"><fmt:message key="aca.ApellidoPat" /></label>
				<input type="text" class="text" size="20" name="aPaterno" value="<%=aPaterno%>">
			</p>
		  </td>	
		  
		  <td>
		     <p>
				<label for="Materno"><fmt:message key="aca.ApellidoMat" /></label>
				<input type="text" class="text" size="20" name="aMaterno" value="<%=aMaterno%>">
			</p>
		  </td>
		 </tr>
		</table>	
				
		<div class="well">
			<a class="btn btn-primary btn-large" href="javascript:Buscar()"><i class="icon-search icon-white"></i> <fmt:message key="boton.Buscar" /></a>
		</div>
			
	</form>
	
		
	<%if(accion.equals("1")){ %>
	
		<form action="datos.jsp" name="frmLista" method="post" target="_self">
			
			<div class="alert"><fmt:message key="empleados.NombreParecido"/></div>
		
			<table  class="table table-bordered table-striped">
				<tr>
					<th><fmt:message key="aca.Nombre"/></th>
					<th><fmt:message key="aca.Clave"/></th>		
				</tr>
				<%for(EmpPersonal empleado :lisLista){ %>
					<tr>
						<td>
							<a href="javascript:Select('<%=empleado.getCodigoId()%>')" title="<fmt:message key="empleados.SeleccionarEmpleado"/>"><%=empleado.getNombre()%>&nbsp;<%=empleado.getApaterno()%>&nbsp;<%=empleado.getAmaterno()%></a>
						</td>
						<td>
							<%=empleado.getCodigoId()%>
						</td>
					</tr>		
				<%}
				String urlsalida = "Accion=7&Escuela="+escuelaId+"&Nombre="+URLEncoder.encode( nombre)+"&APaterno="+URLEncoder.encode( aPaterno)+"&AMaterno="+URLEncoder.encode( aMaterno)+"&FNacimiento=01/01/2000&Genero=M&Curp=S";
				//urlsalida = URLEncoder.encode(urlsalida, "UTF-8");
				
				%>
						
				<tr>
					<td colspan="2">
						<fmt:message key="aca.CreaRegistro"/>
						<a class="btn btn-primary btn-mini" href="nuevoEmpleado.jsp?<%= urlsalida %>">
							<i class="icon-file icon-white"></i> <fmt:message key="empleados.NuevoEmpleado"/>
						</a>
					</td>
				</tr>
			</table>
		</form>
	<%} %>
		
</div>
	
<script>	
	document.frmDatos.nombre.focus();

	function Buscar(){
		if(document.frmDatos.nombre.value != ""){
			document.frmDatos.Accion.value="1";
			document.frmDatos.submit();
		}else{
			alert("<fmt:message key="aca.IngreseEmpleado"/>");
		}
	
	}
			
	function Select( codigoId ){
		document.location.href = "empleado.jsp?Accion=5&CodigoEmpleado="+codigoId;
	}		
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %> 