<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<%	
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= (String) session.getAttribute("escuela");	
	String cicloId			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	
	ArrayList lisAlumno		= new ArrayList();
	
	aca.util.Fecha fecha	= new aca.util.Fecha();

	String sDia			= request.getParameter("Dia"); if (sDia == null) sDia = "0";
	String sMes			= request.getParameter("Mes"); if (sMes == null) sMes= "0";
	String sMesNombre	= "";
	String sMatTemp		= "";

	String sAccion 		= request.getParameter("Accion");
	if (sAccion == null) sAccion = "1";
	int nAccion			= Integer.parseInt(sAccion);

	String sResultado		= "";
	int		i 				= 0;

	// Operaciones a realizar en la pantalla
	switch (nAccion){
		case 1: { // Captura Parametros
			sResultado = "LlenarFormulario";
			break;
		}		
		case 2: { // Listado
			sResultado = "Cumpleanos";
			if (sDia.length()==1 && !sDia.equals("0")) sDia = "0"+sDia;
			lisAlumno = alumnoLista.getListCumpleTodosInscritos(conElias, escuelaId, sMes, sDia, "ORDER BY F_NACIMIENTO, NIVEL_ID, APATERNO");
			break;
		}
		
	}
	
	int 	mes				= Integer.parseInt(sMes);
	switch (mes){
		case 1 : { sMesNombre = "Enero"; 		break; }
		case 2 : { sMesNombre = "Febrero";	break; }
		case 3 : { sMesNombre = "Marzo"; 		break; }
		case 4 : { sMesNombre = "Abril"; 		break; }
		case 5 : { sMesNombre = "Mayo";		break; }
		case 6 : { sMesNombre = "Junio"; 		break; }
		case 7 : { sMesNombre = "Julio"; 		break; }
		case 8 : { sMesNombre = "Agosto"; 	break; }
		case 9 : { sMesNombre = "Septiembre"; break; }
		case 10: { sMesNombre = "Octubre"; 	break; }
		case 11: { sMesNombre = "Noviembre"; 	break; }
		case 12: { sMesNombre = "Diciembre"; 	break; }
	}
	
	
	/*if (!sMes.equals("0")){
		sResultado += " Mes [ "+sMesNombre+" ]";
		if (!sDia.equals("0")){
			sResultado += " -- Dia [ "+sDia+" ]";
		}
	}	
	*/
	
	pageContext.setAttribute("resultado", sResultado);
%>
<body>
<div id="content">
<form action="cumple.jsp" method="post" name="frmcumple">
  <table width="50%" border="0" align="center">
    <tr> 
      <td style="text-align:center"><h4><fmt:message key="informes.CumpleanosAlumno"/></h4></td>    
    </tr>    
  </table>
        
        <div class="well" style="overflow:hidden;">	
			<input type="hidden" name="Accion" value="2">
	 		  <select name="Mes" id="Mes"><fmt:message key="aca.Mes"/>
		<%if (mes==1){%>
          <option value="01" Selected><fmt:message key="aca.Enero"/></option>
		<%}else{%>
		  <option value="01"><fmt:message key="aca.Enero"/></option>
		<%}%>
		<%if (mes==2){%>
		  <option value="02" Selected><fmt:message key="aca.Febrero"/></option>
		<%}else{%>
		  <option value="02"><fmt:message key="aca.Febrero"/></option>
		<%}%>
		<%if (mes==3){%>		  
          <option value="03" Selected><fmt:message key="aca.Marzo"/></option>
		<%}else{%>
		  <option value="03"><fmt:message key="aca.Marzo"/></option>
		<%}%>
		<%if (mes==4){%>
		  <option value="04" Selected><fmt:message key="aca.Abril"/></option>
		<%}else{%>
		  <option value="04"><fmt:message key="aca.Abril"/></option>
		<%}%>		
		<%if (mes==5){%>
		  <option value="05" Selected><fmt:message key="aca.Mayo"/></option>
		<%}else{%>
		  <option value="05"><fmt:message key="aca.Mayo"/></option>
		<%}%>
		<%if (mes==6){%>
		  <option value="06" Selected><fmt:message key="aca.Junio"/></option>
		<%}else{%>
		  <option value="06"><fmt:message key="aca.Junio"/></option>
		<%}%>
        <%if (mes==7){%>
		  <option value="07" Selected><fmt:message key="aca.Julio"/></option>
		<%}else{%>
		  <option value="07"><fmt:message key="aca.Julio"/></option>
		<%}%>
		<%if (mes==8){%>
		  <option value="08" Selected><fmt:message key="aca.Agosto"/></option>
		<%}else{%>
		  <option value="08"><fmt:message key="aca.Agosto"/></option>
		<%}%>
		<%if (mes==9){%>
		  <option value="09" Selected><fmt:message key="aca.Septiembre"/></option>
		<%}else{%>
		  <option value="09"><fmt:message key="aca.Septiembre"/></option>
		<%}%>
		<%if (mes==10){%>
		  <option value="10" Selected><fmt:message key="aca.Octubre"/></option>
		<%}else{%>
		  <option value="10"><fmt:message key="aca.Octubre"/></option>
		<%}%>
		<%if (mes==11){%>
		  <option value="11" Selected><fmt:message key="aca.Noviembre"/></option>
		<%}else{%>
		  <option value="11"><fmt:message key="aca.Noviembre"/></option>
		<%}%>
		<%if (mes==12){%>
		  <option value="12" Selected><fmt:message key="aca.Diciembre"/></option>
		<%}else{%>
		  <option value="12"><fmt:message key="aca.Diciembre"/></option>
		<%}%>          
        </select>
			 <input name="Dia" type="text" id="Dia" value="<%=sDia%>" size="3" maxlength="3">
        <fmt:message key="aca.DiaCero"/> &nbsp;&nbsp; <input class="btn btn-primary" name="Buscar" type="submit" id="Buscar" value="Buscar">
		</div> 
</form>
<div align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif"><fmt:message key="aca.${resultado}" /></font></strong></div>
<table width="70%" border="0" align="center" class="table table-condensed">
  <tr>     
	<th width="6%">#</th>
	<th width="9%"><fmt:message key="aca.Matricula"/></th>
    <th width="50%"><fmt:message key="aca.Nombre"/></th>
    <th width="25%"><fmt:message key="catalogo.Nivel"/></th>
    <th width="5%"><fmt:message key="aca.Gdo"/></th>
    <th width="5%"><fmt:message key="aca.Gpo"/></th>
    <th> <fmt:message key="aca.Foto"/></th>
  </tr>
<%	int row = 0;
	for (i=0; i< lisAlumno.size(); i++){
		aca.alumno.AlumPersonal alumno = (aca.alumno.AlumPersonal) lisAlumno.get(i);
		
		if ( !fecha.getDia(alumno.getFNacimiento()).equals(sDia) ){
				sDia = fecha.getDia( alumno.getFNacimiento());
%>
	<tr><td colspan="7">&nbsp;</td></tr>
	<tr><td colspan="7" align="center" bgcolor="#000099"><font color="#FFFFFF"><fmt:message key="aca.Dia"/> : &nbsp; <%=sDia%></font></td>
<%		
		}
		if ( !alumno.getCodigoId().equals(sMatTemp) ){ row++;
%>  
  <tr> 
    <td><%=i+1%></td>
    <td><%=alumno.getCodigoId()%></td>
    <td><%=alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno()%></td>
    <td>&nbsp;<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), alumno.getNivelId() )%></td>
    <td align="center"><%=alumno.getGrado()%>°</td>
    <td align="center">"<%=alumno.getGrupo()%>"</td>
    <td><img src="../../parametros/foto/foto.jsp?mat=<%=alumno.getCodigoId()%>" width="70"></td>
  </tr>
<%		}
		sMatTemp = alumno.getCodigoId();
	}%>  
</table>
<%
	lisAlumno 		= null;
	fecha			= null;
%>

</body>
</div>
<%@ include file= "../../cierra_elias.jsp" %> 