<%@page import="aca.fin.FinCuenta"%>
<%@page import="aca.fin.FinCuentaLista"%>
<%@page import="java.util.Map"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovL" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="krdxCursoAct" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

<head>
<%	
	String escuelaId	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");
	String cicloIdM 	= (String) session.getAttribute("cicloId");
	
	ArrayList<aca.alumno.AlumPadres> lisAlumPadres = alumPadresLista.getListTutor(conElias, codigoId, "ORDER BY 1");
	
	Personal.mapeaRegId(conElias, codigoId);	
	FinCuentaLista finCuenta = new FinCuentaLista();
 	Map<String, FinCuenta> mapCuentas = finCuenta.mapCuentasEscuela(conElias, escuelaId);
%>
</head>
<body>

<div id="content">

	
	<h2><fmt:message key="empleados.DatosPersonalesMin"/></h2>
	<hr />
			
	<div class="row">
	  <div class="span3">
		   	<address>
			  <strong><fmt:message key="aca.Matricula"/></strong><br>
			  <%=codigoId %>
			</address>
			
			<address>
				<strong><fmt:message key="aca.Nombre" /></strong><br>
				<%=aca.empleado.EmpPersonal.getNombre(conElias, codigoId, "NOMBRE") %>
			</address>
			
			<address>
				<strong><fmt:message key="aca.Genero" /></strong><br>
				<%if(Personal.getGenero().equals("M")){ %>
					<fmt:message key="aca.Hombre" />
				<%}else{ %>
					<fmt:message key="aca.Mujer" />
				<%} %>
			</address>
			
			<address>
				<strong><fmt:message key="aca.Telefono" /></strong><br>
				<%=Personal.getTelefono() %>
			</address>
			
			<address>
				<strong><fmt:message key="aca.Direccion" /></strong><br>
				<%=Personal.getDireccion() %>
			</address>
			
			<address>
				<strong><fmt:message key="aca.Ocupacion" /></strong><br>
				<%=Personal.getOcupacion() %>
			</address>
			
			<address>
				<strong><fmt:message key="aca.Email" /></strong><br>
				<%=Personal.getEmail() %>
			</address>
	  </div>
	  <div class="span3" id="hijos">
	  		<address>
			  <strong><fmt:message key="aca.Hijos"/></strong><br>
			  <%for(aca.alumno.AlumPadres alumno : lisAlumPadres){
				  cicloGrupo.mapeaRegId(conElias,aca.kardex.KrdxCursoAct.getAlumGrupo(conElias,alumno.getCodigoId(),cicloIdM));
				  
			  %>
				<a href="javascript:refresca('<%=alumno.getCodigoId()%>');" id="alumno-<%=alumno.getCodigoId()%>" data-ciclogpoid="<%= cicloGrupo.getCicloGrupoId() %>" data-codigoid="<%=alumno.getCodigoId()%>"><%=aca.alumno.AlumPersonal.getNombre(conElias, alumno.getCodigoId(), "NOMBRE") %></a> 
				<a href="mensaje.jsp?cicloGrupoId=<%= cicloGrupo.getCicloGrupoId() %>&codigoAlumno=<%=alumno.getCodigoId()%>&ciclo=<%= cicloIdM %>" id="msg-<%=alumno.getCodigoId()%>" class="btn btn-info btn-mini"></a> <br />
			  <%}%>
			</address>
	  </div>
	</div>
	
	<hr />
    
    <h4><fmt:message key="aca.EstadoDeCuenta" /></h4>
    
    <table class="table table-condensed table-striped table-bordered">
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.Nombre" /></th>
					<th><fmt:message key="aca.Descripcion" /></th>
					<th><fmt:message key="aca.Referencia" /></th>
					<th><fmt:message key="aca.Fecha" /></th>
					<th><fmt:message key="aca.Cargo" /></th>
					<th><fmt:message key="aca.Credito" /></th>
					<th><fmt:message key="aca.Saldo" /></th>
				</tr>
			</thead>
<%
			String hijos = "";
		
			for(aca.alumno.AlumPadres alum : lisAlumPadres){
				hijos += "'"+alum.getCodigoId()+"',";
			}
			if(hijos.length()>0){
				hijos = hijos.substring(0, hijos.length()-1);
			}
		
			float total = 0f;
			java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
			ArrayList<aca.fin.FinMovimientos> lisMovimientos = FinMovL.getMovimientosHijos(conElias, hijos, "ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD'), MOVIMIENTO_ID");
			for(int i = 0; i < lisMovimientos.size(); i++){
				FinMov = (aca.fin.FinMovimientos) lisMovimientos.get(i);
				if(mapCuentas.containsKey(FinMov.getCuentaId()) && mapCuentas.get(FinMov.getCuentaId()).getCuentaAislada().equals("N")){
				if(FinMov.getNaturaleza().equals("D"))
					total -= Float.parseFloat(FinMov.getImporte());
				else
					total += Float.parseFloat(FinMov.getImporte());
%>
					<tr>
						<td align="center"><%=i+1 %></td>
						<td><%=FinMov.getAuxiliar() %></td>
						<td><%=aca.alumno.AlumPersonal.getNombre(conElias, FinMov.getAuxiliar(), "NOMBRE") %></td>
						<td><%=FinMov.getDescripcion() %></td>
						<td><%=FinMov.getReferencia() %></td>
						<td><%=FinMov.getFecha() %></td>
						<td align="right"><%=FinMov.getNaturaleza().equals("D")?formato.format(Float.parseFloat(FinMov.getImporte())):"" %></td>
						<td align="right"><%=FinMov.getNaturaleza().equals("C")?formato.format(Float.parseFloat(FinMov.getImporte())):"" %></td>
						<td align="right"><%=formato.format(total) %></td>
					</tr>
<%
				}
			}
			
			if(lisMovimientos.size() == 0){
%>
				<tr>
					<td colspan="9" align="center"><fmt:message key="aca.NoExistenMovimientos" /></td>
				</tr>
<%
			}
%>
	</table>	
	
</div>
	
<script>

	
	
	function refresca(codigoId){
		document.location = "datos.jsp?Accion=1&codigo="+codigoId;
	}
	
	var IDs = [];
	$("#hijos").find("a").each(function(){ IDs.push($(this).attr("id")); });
	
	console.log(IDs);
	
	$.each(IDs, function(i, v){
		console.log('recorriendo el array ' + i + ' ' + v );
		var datocodigoid = $('#'+v).data('codigoid');
		var datociclogpoid = $('#'+v).data('ciclogpoid');
		
		contarMensajesNuevos(datociclogpoid, datocodigoid);
	});
	
	function contarMensajesNuevos(ciclogpoid, codigoid){
		var usuarioid = codigoid;
		var suma = 0;	
		var escuela = '<%= escuelaId %>';
		var tipodestino = '\'P\',\'I\',\'G\'';
		var ciclo = ciclogpoid.substring(0,8);
		var datadataA = 'cuenta_msgs=true&destino=\''+codigoid+'\',\''+ciclogpoid+'\',\''+escuela+'\',\''+ciclo+'\'&tipodestino='+tipodestino+'&usuario='+usuarioid;
		console.log(datadataA);
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
			type : 'post',
			data : datadataA,
			cache : false,
			success : function(output) {
				suma += $.isNumeric(output) ? parseInt(output) : 0;
				$('#msg-'+codigoid).html(suma + ' Mensajes Nuevos');
				console.log('suma 1 ' + suma);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
		
	}

</script>
	

</body>


<%@ include file="../../cierra_elias.jsp" %>