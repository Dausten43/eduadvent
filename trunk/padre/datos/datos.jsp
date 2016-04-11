<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "aca.empleado.EmpPersonal"%>
<head>
	<script>	
		function Consultar(){				
			document.frmEmpleado.Accion.value="1";
			document.frmEmpleado.submit();
		}
	</script>
</head>
	
<%
	String escuelaId	= (String) session.getAttribute("escuela");
	System.out.println("escuela:"+escuelaId);
	EmpPersonal empleado	= new EmpPersonal();
	String strCodigoEmp 	= "x";
	String strCodigoPad		= "x";
	String strNombreEmp		= "";	
	String strAccion 		= request.getParameter("Accion");
	if (strAccion == null) strAccion = "0";
	int nAccion				= Integer.parseInt(strAccion);
	String strTipo			= request.getParameter("strTipo");
	if(strTipo==null){
		strTipo = "Empleado";
	}
	
	
	switch (nAccion){
		case 0:{
			if(strTipo.equals("Empleado")){				
				strCodigoEmp = (String) session.getAttribute("codigoEmpleado");
				strNombreEmp = aca.empleado.EmpPersonal.getNombre(conElias, strCodigoEmp,"NOMBRE");
				if (strNombreEmp.equals("x")){
					strNombreEmp = "NoDefinido";
				}
				break;
			}
			if(strTipo.equals("Padre")){				
					strCodigoEmp = (String) session.getAttribute("codigoPadre");
					strNombreEmp = aca.empleado.EmpPersonal.getNombre(conElias, strCodigoEmp,"NOMBRE");
					if (strNombreEmp.equals("x")){
						strNombreEmp = "NoDefinido";
					}
					break;
			}
		
		}
		case 1:{						
			strCodigoEmp = request.getParameter("codigoEmpleado");
			strNombreEmp = aca.empleado.EmpPersonal.getNombre(conElias, strCodigoEmp,"NOMBRE");
			if (strNombreEmp.equals("x")){
				strNombreEmp = "NoExiste";
			}else{
				if (strCodigoEmp.substring(0,1).equals("9"))
					session.setAttribute("codigoEmpleado", strCodigoEmp);
			}
			break;
		}
	}
	
	if (strCodigoEmp==null||strCodigoEmp.equals("x")){ 
	  strCodigoEmp=(String)session.getAttribute("escuela")+"P0001";
	  strTipo = "Padre";
	}else if (strCodigoEmp.substring(3,4).equals("P")){
		strTipo = "Padre";
	}	 
	pageContext.setAttribute("strNombreEmp",strNombreEmp);
%>
<body>
<table width="70%" border="0" align="center">	
  <tr align="center">   	
    <td colspan="2"><strong><font size="3"><fmt:message key="padre.InformacionPapa" /></font></strong></td>
  </tr>
  <tr> 
    <td width="40%" align="right"><b><%=strTipo%>:</b></td>
    <td width="61%" align="left"><b> [ <%=strCodigoEmp%> ] <fmt:message key="aca.${strNombreEmp}" /> </b></td>
  </tr>
  <tr align="center"> 
    <form action="datos.jsp" method="post" name="frmEmpleado">
    <input name="Accion" type="hidden" value="1">
      <td colspan="2"> <fmt:message key="padre.OtroPadre" />: 
        <input name="codigoEmpleado" type="text" id="codigoEmpleado" value="<%=strCodigoEmp%>" size="8" maxlength="8"> 
        &nbsp; <input type="button" value="Consultar" id="consultar" onclick="javascript:Consultar()" style="cursor:pointer" /></td>
    </form>
  </tr>  
</table>
<iframe width="100%" height="430" name="datos" src="accion_p.jsp?CodigoEmpleado=<%=strCodigoEmp%>&tipo=<%=strTipo%>&ref=0" style="border:none;">
</iframe>
</body>
<%@ include file= "../../cierra_elias.jsp" %>