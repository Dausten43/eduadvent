<%@ include file= "../con_elias.jsp" %>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<%	
	aca.empleado.EmpPersonal empleado	= new aca.empleado.EmpPersonal();
	aca.alumno.AlumPersonal alumno 		= new aca.alumno.AlumPersonal();

	String codigoId 	= request.getParameter("codigo");
	String tipo 		= codigoId.substring(3,4);
	
	int numMes 			= 0;
	if (tipo.equals("P")||tipo.equals("E")){		
		empleado.setCodigoId(codigoId);
		empleado.mapeaRegId(conElias, codigoId);
		numMes = Integer.parseInt(empleado.getFNacimiento().substring(3,5));
	}else{
		alumno.setCodigoId(codigoId);
		alumno.mapeaRegId(conElias, codigoId);
		numMes = Integer.parseInt(alumno.getFNacimiento().substring(3,5));
	}

	empPersonal.mapeaRegId(conElias, codigoId);
%>
<table>
  <tr>
    <td width='80' align='center' valign="top">
	  <table border='1' cellpadding='0' cellspacing='0'>
	    <tr><td bordercolor='#8596CA'><img src="../../parametros/foto/foto.jsp?mat=<%=codigoId%>" width="77"></td></tr>
	    <tr><td align="center"><%=codigoId%></td></tr>
	  </table>
	</td>
	<td valign="top">
<%	
	if (tipo.equals("P")||tipo.equals("E")){
%>		
	  <table width='100%' cellpadding='0' cellspacing='8'>
		<tr><td colspan="2"><font size=2><b><%= empleado.getNombre()+" "+empleado.getApaterno()+" "+empleado.getAmaterno() %></b></font></td></tr>
		<tr><td><b>F. Nac.:</b>&nbsp;<%= Integer.parseInt(empleado.getFNacimiento().substring(0,2))%> de <%=aca.util.Fecha.getMesNombre(numMes)%></td>
		</tr>
<%if(empPersonal.getPublicar().equals("S")){%>
		<tr>
		  <td><b>Telefono:</b>&nbsp;<%= empleado.getTelefono() %></td>
		</tr>
		<tr>
		  <td><b>E-mail:</b>&nbsp;<% if(empleado.getEmail()==null) out.print("-");%><% if(empleado.getEmail()!=null)out.print(empleado.getEmail());%></td>
		</tr>
<%}%>
	  </table>
<%		
	}else{
%>
	  <table width='100%' cellpadding='0' cellspacing='8'>
		<tr><td colspan="2"><font size=2><b><%= alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno() %></b></font></td></tr>
		<tr>
		  <td><b>F. Nac.:</b>&nbsp;<%= Integer.parseInt(alumno.getFNacimiento().substring(0,2))%> de <%=aca.util.Fecha.getMesNombre(numMes)%></td>
		</tr>
		<tr>
		  <td><b>Genero:</b>&nbsp;<%= alumno.getGenero() %></td>
		</tr>
		<tr>
		  <td><b>Plan:</b>&nbsp;<%= aca.alumno.AlumPlan.getPlanActual(conElias, codigoId) %>.</td>
		</tr>
		<tr>
		  <td><b>Grado:</b>&nbsp;<%= alumno.getGrado() %>&nbsp; &nbsp; <b>Grupo:</b>&nbsp;<%= alumno.getGrupo() %></td>
		</tr>
		<tr>
		  <td><b>Telefono:</b>&nbsp;<%= alumno.getTelefono() %></td>
		</tr>
		<tr>
		  <td><b>E-mail:</b>&nbsp;<% if(alumno.getEmail()==null) out.print("-");%><% if(empleado.getEmail()!=null)out.print(empleado.getEmail());%></td>
		</tr>
	  </table>  	
<%
	}
%>
    </td>    
  </tr>
</table>
<%@ include file= "../cierra_elias.jsp" %>