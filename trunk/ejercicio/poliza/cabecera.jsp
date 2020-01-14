<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="aca.usuario.Usuario"%>
<%@page import="aca.cont.ContPoliza"%>
<%@page import="aca.cont.ContCcosto"%>
<%@page import="aca.cont.ContMovimiento"%>

<jsp:useBean id="contEjercicioL" scope="page" class="aca.cont.ContEjercicioLista"/>
<jsp:useBean id="contPolizaL" scope="page" class="aca.cont.ContPolizaLista"/>
<jsp:useBean id="contPoliza" scope="page" class="aca.cont.ContPoliza"/>
<jsp:useBean id="fecha" scope="page" class="aca.util.Fecha"/>
<jsp:useBean id="contLibroL" scope="page" class="aca.cont.ContLibroLista"/>
<jsp:useBean id="contCcosto" scope="page" class="aca.cont.ContCcosto"/>
<jsp:useBean id="contCcostoL" scope="page" class="aca.cont.ContCcostoLista"/>
<%
	String strEjercicioId		= request.getParameter("Ejercicio");
	String strLibroId			= request.getParameter("Libro");
	String ccostoId				= request.getParameter("ccostoId");
	String codigoId				= (String) session.getAttribute("codigoId");
	String resultado			= "";
	String mesId				= request.getParameter("mesId")==null?"00":request.getParameter("mesId");
	ArrayList lisEjercicio			= null;
	ArrayList lisPoliza			= null;
	ArrayList lisLibro				= null;
	ArrayList lisCcosto			= null;
	
	if(ccostoId == null)
		ccostoId = ContCcosto.getCcosto(conElias, (String)session.getAttribute("escuela"));
	
	int accion					= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	switch(accion){
		case 3:{	//Borrar Registro
			contPoliza.setEjercicioId(strEjercicioId);
			contPoliza.setLibroId(strLibroId);
			contPoliza.setPolizaId(request.getParameter("polizaId"));
			if(contPoliza.deleteReg(conElias)){
				resultado = "<font size=2 color=blue>Se borr&oacute; correctamente el registro!!!</font>";
			}else{
				resultado = "<font size=2 color=red>Ocurri&oacute; un error al borrar. Int&eacute;ntelo de nuevo</font>";
			}
		}break;
		case 5:{	//Guardo la poliza
			resultado = "<font color=blue size=2>Se guard&oacute; correctamente la poliza</font>";
		}break;
		case 6:{
			resultado = "<font color=blue size=2>Se modific&oacute; correctamente la poliza</font>";
		}break;
	}
	
	lisEjercicio 				= contEjercicioL.getListAll(conElias," ORDER BY EJERCICIO_ID");
	lisLibro 					= contLibroL.getListAll(conElias," ORDER BY LIBRO_NOMBRE");
	
	if(strEjercicioId == null && lisEjercicio.size() > 0){
		strEjercicioId = ((aca.cont.ContEjercicio)lisEjercicio.get(lisEjercicio.size()-1)).getEjercicioId();
	}
	if(strLibroId == null && lisLibro.size() > 0){
		strLibroId = ((aca.cont.ContLibro)lisLibro.get(0)).getLibroId();
	}
	
	lisPoliza = contPolizaL.getListEjercicioLibroCcosto(conElias, strEjercicioId, strLibroId, ccostoId, (Usuario.esAdministrador(conElias, codigoId)?"":"AND US_REVISION = '"+codigoId+"'")+" ORDER BY FECHA, POLIZA_ID");
%>
<head>
	<script>
		function Borrar(ejercicioId, libroId, polizaId){
			if(confirm("¿Estas seguro de eliminar el registro: "+polizaId+"?")){
		  		document.location="cabecera.jsp?Accion=3&Ejercicio="+ejercicioId+"&Libro="+libroId+"&polizaId="+polizaId+"&ccostoId="+<%=ccostoId %>;
		  	}
		}
	</script>
	<title>Documento sin t&iacute;tulo</title>
</head>

<body>
<form name="frmEjercicio" action="cabecera.jsp" method="post">
<table width="90%" border="0" align="center">
  <tr>
  	<td colspan="10" align="center"><%=resultado %>&nbsp;</td>
  </tr>
  <tr align="center">
    <td colspan="10">
    	<strong><font size="3">Polizas del Periodo <%if(Usuario.esAdministrador(conElias, codigoId)){ %>[</font>
			<a href="accion.jsp?Accion=1&ejercicioId=<%=strEjercicioId%>&libroId=<%=strLibroId %>&ccostoId=<%=ccostoId %>">A&ntilde;adir</a> 
		<font size="3">]<%} %></font></strong>
	</td>
  </tr>
  <tr align="center"> 
    <td colspan="10">Ejercicio 
    	<select name="Ejercicio" id="Ejercicio" onchange="javascript:document.frmEjercicio.submit();">
<%
	for( int j=0;j<lisEjercicio.size();j++){
		aca.cont.ContEjercicio ejercicio = (aca.cont.ContEjercicio) lisEjercicio.get(j);
		if (strEjercicioId==null&&j==0) strEjercicioId = ejercicio.getEjercicioId();

		if (ejercicio.getEjercicioId().equals(strEjercicioId)){
			out.print(" <option value='"+ejercicio.getEjercicioId()+"' Selected>"+ ejercicio.getEjercicioNombre()+"</option>");
		}else{
			out.print(" <option value='"+ejercicio.getEjercicioId()+"'>"+ ejercicio.getEjercicioNombre()+"</option>");
		}
	}
%>
		</select><br>
		Mes:
		<select id="mesId" name="mesId" onchange="javascript:document.frmEjercicio.submit();">
			<option value="00" <%=mesId.equals("00")?"Selected":"" %>>Todos</option>
			<option value="01" <%=mesId.equals("01")?"Selected":"" %>>Enero</option>
			<option value="02" <%=mesId.equals("02")?"Selected":"" %>>Febrero</option>
			<option value="03" <%=mesId.equals("03")?"Selected":"" %>>Marzo</option>
			<option value="04" <%=mesId.equals("04")?"Selected":"" %>>Abril</option>
			<option value="05" <%=mesId.equals("05")?"Selected":"" %>>Mayo</option>
			<option value="06" <%=mesId.equals("06")?"Selected":"" %>>Junio</option>
			<option value="07" <%=mesId.equals("07")?"Selected":"" %>>Julio</option>
			<option value="08" <%=mesId.equals("08")?"Selected":"" %>>Agosto</option>
			<option value="09" <%=mesId.equals("09")?"Selected":"" %>>Septiembre</option>
			<option value="10" <%=mesId.equals("10")?"Selected":"" %>>Octubre</option>
			<option value="11" <%=mesId.equals("11")?"Selected":"" %>>Noviembre</option>
			<option value="12" <%=mesId.equals("12")?"Selected":"" %>>Diciembre</option>
		</select><br>
		<div style="border: solid 1px gray; width: 50%;">
<%
	if(Usuario.esAdministrador(conElias, codigoId)){
%>
	  Centro de Costo
	  	<select id="ccostoId" name="ccostoId" onchange="javascript:document.frmEjercicio.submit();">
<%
		lisCcosto = contCcostoL.getListNivelContable(conElias, "ORDER BY NOMBRE");
		for(int i = 0; i < lisCcosto.size(); i++){
			contCcosto = (ContCcosto) lisCcosto.get(i);
%>
			<option value="<%=contCcosto.getCcostoId() %>"<%=ccostoId.equals(contCcosto.getCcostoId())?" Selected":"" %>><%=contCcosto.getNombre() %></option>
<%
		}
%>
	  	</select>
<%
	}
%>
	&nbsp;&nbsp;&nbsp;&nbsp;
	Libro 
		<select name="Libro" id="Libro" onchange="javascript:document.frmEjercicio.submit();">
<%
	for( int j=0;j<lisLibro.size();j++){
		aca.cont.ContLibro libro = (aca.cont.ContLibro) lisLibro.get(j);
		if (strLibroId==null&&j==0) strLibroId = libro.getLibroId();

		if (libro.getLibroId().equals(strLibroId)){
			out.print(" <option value='"+libro.getLibroId()+"' Selected>"+ libro.getLibroNombre()+"</option>");
		}else{
			out.print(" <option value='"+libro.getLibroId()+"'>"+ libro.getLibroNombre()+"</option>");
		}
	}
%>
		</select>
		</div>
    </td>
  </tr>
<%
	java.text.DecimalFormat format = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	String mes = "";
	for (int i=0; i< lisPoliza.size(); i++){
		aca.cont.ContPoliza poliza = (aca.cont.ContPoliza) lisPoliza.get(i);
		if(fecha.getMes(poliza.getFecha()).equals(mesId) || mesId.equals("00")){
			if(!fecha.getMes(poliza.getFecha()).equals(mes)){
				mes = fecha.getMes(poliza.getFecha());
%>
  <tr>
  	<td colspan="10">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="10"><font size="2"><b><%=fecha.getMesNombre(poliza.getFecha()).toUpperCase() %></b></font></td>
  </tr>
  <tr> 
<%
				if(Usuario.esAdministrador(conElias, codigoId)){
%>
    <th width="40px">Operación</th>
<%
				}
%>
    <th width="40px">Libro</th>
    <th width="50px">Poliza</th>
    <th width="60px">Fecha</th>
    <th>Descripción</th>
    <th width="70px">Us. Admin</th>
    <th width="70px">Us. Captura</th>
    <th width="90px">Cargo</th>
    <th width="90px">Credito</th>
    <th width="90px">Estado</th>
  </tr>
<%
			}
			if(poliza.getEstado().equals("A") && poliza.getUsRevision().equals(codigoId)){
%>  
  <tr onmouseover="this.style.backgroundColor='#E4F7FA';" onmouseout="this.style.backgroundColor='';" class="button">
    <td align="center">
<%
				if(Usuario.esAdministrador(conElias, codigoId) && !ContPoliza.tieneMovimientos(conElias, strEjercicioId, poliza.getLibroId(), poliza.getPolizaId())){
%>
      <a href="javascript:Borrar('<%=strEjercicioId %>', '<%=strLibroId %>', '<%=poliza.getPolizaId()%>');">
	    <img src="../../imagenes/no.gif" class="button" alt="Eliminar" width="15" border="0">
	  </a>
	  <a href="accion.jsp?Accion=4&ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId()%>&ccostoId=<%=ccostoId %>">
	  	<img src="../../imagenes/editar.gif" class="button" alt="Modificar" width="12" border="0">
	  </a>
<%
				}
%>
	</td>
    <td align="center" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getLibroId() %></td>
    <td align="center" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getPolizaId() %></td>
    <td align="center" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getFecha() %></td>
    <td onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getDescripcion()%></td>
    <td align="center" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getUsAlta()%></td>
    <td align="center" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getUsRevision()%></td>
    <td align="right" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=format.format(Double.parseDouble(ContMovimiento.getTotal(conElias, strEjercicioId, strLibroId, poliza.getPolizaId(), "D"))) %></td>
    <td align="right" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=format.format(Double.parseDouble(ContMovimiento.getTotal(conElias, strEjercicioId, strLibroId, poliza.getPolizaId(), "C"))) %></td>
    <td align="center" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';"><%=poliza.getEstado().equals("A")?"Activa":poliza.getEstado().equals("R")?"En revision":"Cerrada" %></td>
  </tr>
<%
			}else if(poliza.getEstado().equals("R") && Usuario.esAdministrador(conElias, codigoId)){
%>
  <tr onmouseover="this.style.backgroundColor='#E4F7FA';" onmouseout="this.style.backgroundColor='';" onclick="document.location.href='movimiento.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';" class="button">
    <td align="center">&nbsp;</td>
    <td align="center"><%=poliza.getLibroId() %></td>
    <td align="center"><%=poliza.getPolizaId() %></td>
    <td align="center"><%=poliza.getFecha() %></td>
    <td><%=poliza.getDescripcion()%></td>
    <td align="center"><%=poliza.getUsAlta()%></td>
    <td align="center"><%=poliza.getUsRevision()%></td>
    <td align="right"><%=format.format(Double.parseDouble(ContMovimiento.getTotal(conElias, strEjercicioId, strLibroId, poliza.getPolizaId(), "D"))) %></td>
    <td align="right"><%=format.format(Double.parseDouble(ContMovimiento.getTotal(conElias, strEjercicioId, strLibroId, poliza.getPolizaId(), "C"))) %></td>
    <td align="center"><%=poliza.getEstado().equals("A")?"Activa":poliza.getEstado().equals("R")?"En revision":"Cerrada" %></td>
  </tr>
<%
			}else{
				if(Usuario.esAdministrador(conElias, codigoId)){
%>
  <tr onmouseover="this.style.backgroundColor='#E4F7FA';" onmouseout="this.style.backgroundColor='';" onclick="document.location.href='visualizar.jsp?ejercicioId=<%=strEjercicioId %>&libroId=<%=strLibroId %>&polizaId=<%=poliza.getPolizaId() %>';" class="button">
<%
				}else{
%>
  <tr>
<%
				}
%>
    <td align="center">&nbsp;</td>
    <td align="center"><%=poliza.getLibroId() %></td>
    <td align="center"><%=poliza.getPolizaId() %></td>
    <td align="center"><%=poliza.getFecha() %></td>
    <td><%=poliza.getDescripcion()%></td>
    <td align="center"><%=poliza.getUsAlta()%></td>
    <td align="center"><%=poliza.getUsRevision()%></td>
    <td align="right"><%=format.format(Double.parseDouble(ContMovimiento.getTotal(conElias, strEjercicioId, strLibroId, poliza.getPolizaId(), "D"))) %></td>
    <td align="right"><%=format.format(Double.parseDouble(ContMovimiento.getTotal(conElias, strEjercicioId, strLibroId, poliza.getPolizaId(), "C"))) %></td>
    <td align="center"><%=poliza.getEstado().equals("A")?"Activa":poliza.getEstado().equals("R")?"En revision":"Cerrada" %></td>
  </tr>
<%
			}
		}
	}
	
	lisPoliza	= null;
%>  
</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>