<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>
<%@page import="aca.ciclo.CicloGrupoAviso"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.util.Fecha"%>
<jsp:useBean id="cicloGrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="cicloGrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad"/>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="PadresAviso" scope="page" class="aca.ciclo.CicloGrupoAviso"/>
<jsp:useBean id="cicloGrupoAvisoLista" scope="page" class="aca.ciclo.CicloGrupoAvisoLista"/>
<head>
<script>
	
	function Guardar(){
		if(document.forma.Aviso.value != ""){
		  document.forma.Accion.value = "1";
		  document.forma.submit();
		  return true;
		}else{
			alert("<fmt:message key="js.CompletaCamposAsterisco" />");
		}
		return false;
	}

</script>
</head>
<% 
	String cicloGrupoId 	=  request.getParameter("CicloGrupoId");
	String cursoId 	  	 	=  request.getParameter("CursoId");
	String codigoEmpleado 	=  request.getParameter("CodigoEmpleado");	 
	String codigoId     	=  request.getParameter("CodigoId");
	
	String accion 			=  request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String aviso 			=  request.getParameter("Aviso")==null?"":request.getParameter("Aviso");
	
	String fecha           	=  aca.util.Fecha.getHoy();
	String folio      	 	=  "";		
	String resultado   		=  "";
	    
	
	    	
	    
	if (accion.equals("1") ){
		PadresAviso.setCicloGrupoId(cicloGrupoId);
		PadresAviso.setCursoId(cursoId);
		PadresAviso.setCodigoId(codigoId);
		PadresAviso.setEmpleadoId(codigoEmpleado);		
	 	PadresAviso.setFolio( PadresAviso.maximoReg(conElias, cicloGrupoId, cursoId) );
	    PadresAviso.setFecha(Fecha.getHoy());
	    PadresAviso.setAviso(aviso);
	    	
	    	
    	if (PadresAviso.existeReg(conElias) == false){
			if (PadresAviso.insertReg(conElias)){
				resultado = "DatosGuardados";
			}else{
				resultado = "NoGrabo";
			}
		}else{	
			if (PadresAviso.updateReg(conElias)){ 
				resultado = "DatosModificados";
			}else{
				resultado = "NoCambio";
			}
		}	       
	  
	 }
	ArrayList listAlumno   	= cicloGrupoAvisoLista.getListAlumno(conElias, cicloGrupoId, cursoId, codigoId,"ORDER BY FECHA");
    pageContext.setAttribute("resultado",resultado);
%>

<body>
<form name="forma" method="post" action="aviso.jsp">
  <input type="hidden" name="Accion">
  <input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>">
  <input type="hidden" name="CursoId" value="<%=cursoId%>">
  <input type="hidden" name="CodigoId" value="<%=codigoId%>">
  <input type="hidden" name="CodigoEmpleado" value="<%=codigoEmpleado%>"> 
  <table width="75%" border="0" align="center">    
	<tr>
	  <td align = "right"><a href="evaluar.jsp?cursoId=<%=cursoId %>&cicloGrupoId=<%=cicloGrupoId%>"><fmt:message key="boton.Regresar" /></a></td>
	 </tr>
	<tr>
	  <td colspan="2" align="center"><fmt:message key="aca.Maestro" />: <%=aca.empleado.EmpPersonal.getNombre(conElias, codigoEmpleado, "NOMBRE")%><b></b>
	 </tr>	    
	 <tr>
	   <td colspan="2" align="center"><fmt:message key="aca.Materia" />: <%=PlanCurso.getCursoNombre(conElias, cursoId) %><b></b>
	 </tr>
	 <tr>
	   <td colspan="2" align="center"><fmt:message key="aca.NombreDelAlumno" />: <%=AlumPersonal.getNombre(conElias, codigoId, "APELLIDO")%><b></b>
	 </tr>
	 <tr>          
       <td colspan="2" title="aviso" align="center">
       <textarea id="Aviso" name="Aviso" cols="40" rows="4"><%= PadresAviso.getAviso()%></textarea> 
       </td>
     </tr>
     <tr>
<%
		if(!resultado.equals("")){
%>
		<td colspan="2" align="center"><fmt:message key="aca.${resultado}" /></td>
<%			
		}
%>
	   <td colspan="2" align="center"><%=resultado%><b></b>
	 </tr>   
     <tr><td colspan="4" align="center"><input type="submit" value="Guardar" onclick="return Guardar();" /></td></tr>     
  </table> 
  <table width="100%">
	<tr>					
	  <th width="20%"><fmt:message key="aca.Fecha" /></th>
	  <th width ="80%"><fmt:message key="aca.Aviso" /></th>						
	</tr>
<%
	for(int i = 0; i < listAlumno.size(); i++){
		aca.ciclo.CicloGrupoAviso aviso1 = (aca.ciclo.CicloGrupoAviso)listAlumno.get(i);
		
		String colorFila;
		if(i%2 != 0)
			colorFila = " bgcolor=\"#C8D4A3\"";
		else
			colorFila = "";
%>
	<tr<%=colorFila %>>
	  <td align="center"><%=aviso1.getFecha()%></td>
	  <td align="center"><%=aviso1.getAviso() %></td>
	</tr>			
<%
	}
%>			
  </table>
</form>>
</body>
<%@ include file= "../../cierra_elias.jsp" %>