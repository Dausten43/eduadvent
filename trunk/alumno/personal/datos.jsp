<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ page import="aca.alumno.AlumPersonal"%>
<%@ page import="aca.alumno.AlumPersonalLista"%>

<script>
	function Buscar() {
		if (document.frmDatos.nombre.value == "") {
			alert("<fmt:message key="aca.IngreseAlumno"/>");
		}else if ( document.frmDatos.aPaterno.value == ""){
			alert("¡Ingrese el apellido paterno del alumno!");
		}else{	
			document.frmDatos.Accion.value = "1";
			return true;
		}
		return false;
	}

	function Select(codigoId) {
		document.location.href = "alumno.jsp?Accion=1&CodigoAlumno=" + codigoId;
	}
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	String nombre			= request.getParameter("nombre")==null?"":request.getParameter("nombre").toUpperCase();
	String aPaterno			= request.getParameter("aPaterno")==null?"":request.getParameter("aPaterno").toUpperCase();
	String aMaterno			= request.getParameter("aMaterno")==null?"":request.getParameter("aMaterno").toUpperCase();
	String sCodigoAlumno	= request.getParameter("codigoPersonal");	
	String sNom 			= "";
	String sPat				= "";
	String sMat				= "";
	
	ArrayList<aca.alumno.AlumPersonal> lisLista		= new ArrayList<aca.alumno.AlumPersonal>();
	
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	if(accion.equals("1")){	
		
		if (nombre==null || nombre.length()==0) sNom = "-"; else sNom = nombre;
		if (aPaterno==null || aPaterno.length()==0) sPat = "-"; else sPat = aPaterno;
		if (aMaterno==null || aMaterno.length()==0) sMat = "-"; else sMat = aMaterno;
		
		lisLista = AlumPersonalLista.BuscaDuplicados(conElias, escuelaId, sNom,sPat,sMat,50);
		
	}else if(accion.equals("2")){
		
		session.setAttribute("codigoAlumno", request.getParameter("CodigoPersonal"));
		response.sendRedirect("accion_p.jsp");
		
	}
%>

<div id="content">
	
	<form action="datos.jsp" name="frmDatos" method="post" target="_self">
		<input type="hidden" name="Accion">
		
		<h2><fmt:message key="alumnos.VerificaciondeInformacion"/></h2>	

		<div class="well">
			<a class="btn btn-primary" href="alumno.jsp">
				<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/>
			</a>
		&nbsp;  &nbsp;Instrucciones: <fmt:message key="aca.IngresaDatos"/>
		</div>
		
		<table class="table table-condensed" onkeypress='presDocumento()' style="margin-bottom: 0px;">
		 <tr>
		  <td>
		     <p>
			   <label><fmt:message key="aca.Nombre"/></label>
			   <input name="nombre" type="text" value="<%=nombre%>">
		     </p>
		  </td>
				
		  <td>
		    <p>
			  <label><fmt:message key="aca.ApellidoPat"/></label>
			  <input type="text" name="aPaterno" value="<%=aPaterno%>">
		    </p>
		  </td>	
		  
		  <td>
		     <p>
			   <label><fmt:message key="aca.ApellidoMat"/></label>
			   <input type="text" name="aMaterno" value="<%=aMaterno%>">
		     </p>
		  </td>
		 </tr>
		</table>	
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="return Buscar();">
				<i class="icon-search icon-white"></i> <fmt:message key="boton.Buscar"/>
			</button>
		</div>
			
	</form>
		
<%
	if (accion.equals("1")) {%>
	
	<form action="datos.jsp" name="frmLista" method="post" target="_self">
		
		<div class="alert"><fmt:message key="aca.AlumnosParecidos"/></div>
		
		<table  class="table table-bordered table-striped">
		<thead>
			<tr>
				<th width="30%"><fmt:message key="aca.Nombre"/></th>
				<th width="20%"><fmt:message key="aca.Matricula"/></th>
			</tr>
		</thead>
		<%
			for (int i = 0; i < lisLista.size(); i++) {
				AlumPersonal alumno = (AlumPersonal) lisLista.get(i);
		%>
		<tr>
			<td><a href="javascript:Select('<%=alumno.getCodigoId()%>')"
				title="<fmt:message key="aca.SelecAlumno"/>"><%=alumno.getNombre()%>&nbsp;<%=alumno.getApaterno()%>&nbsp;<%=alumno.getAmaterno()%></a>
			</td>
			<td align="center"><%=alumno.getCodigoId()%>&nbsp;</td>
		</tr>
		<%
			}
		%>
		<tr>
			<td colspan="2">
				<fmt:message key="aca.CreaRegistro"/>
				<a class="btn btn-primary btn-mini" href="nuevoAlumno.jsp?Accion=7&Escuela=<%=escuelaId%>&Nombre=<%=nombre%>&APaterno=<%=aPaterno%>&AMaterno=<%=aMaterno%>&FNacimiento=01/01/2000&Genero=<%="M"%>&Curp=<%="S"%>">
					<i class="icon-plus icon-white"></i> <fmt:message key="aca.NuevoAlumno"/>
				</a>
			</td>
		</tr>
		</table>
	</form>
		
<%	}%>
	
</div>

<script>
	document.frmDatos.nombre.focus();
</script>

<%@ include file="../../cierra_elias.jsp"%>

