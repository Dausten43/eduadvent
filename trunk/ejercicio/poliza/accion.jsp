<%@page import="aca.cont.ContLibro"%>
<%@page import="aca.cont.ContCcosto"%>
<%@page import="aca.util.Fecha"%>
<%@page import="aca.usuario.Usuario"%>
<%@page import="aca.empleado.EmpPersonal"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contPoliza" scope="page" class="aca.cont.ContPoliza"/>
<jsp:useBean id="contLibro" scope="page" class="aca.cont.ContLibro"/>
<jsp:useBean id="contLibroL" scope="page" class="aca.cont.ContLibroLista"/>
<jsp:useBean id="contCcosto" scope="page" class="aca.cont.ContCcosto"/>
<jsp:useBean id="contCcostoL" scope="page" class="aca.cont.ContCcostoLista"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioL" scope="page" class="aca.usuario.UsuarioLista"/>
<%
	// Declaracion de variables	
	String ejercicioId						= request.getParameter("ejercicioId");
	String libroId							= request.getParameter("libroId");
	String polizaId							= request.getParameter("polizaId");
	String codigoId							= (String) session.getAttribute("codigoId");
	String ccostoId							= request.getParameter("ccostoId");
	String resultado						= "";
	int accion								= Integer.parseInt(request.getParameter("Accion"));
	String salto 							= "X";
	
	ArrayList<ContCcosto> lisCcosto			= null;
	ArrayList<Usuario> lisUsuario	= null;
	
	if(ccostoId == null)
		ccostoId = ContCcosto.getCcosto(conElias, (String)session.getAttribute("escuela"));
		
	// Operaciones a realizar en la pantalla
	switch (accion){
		case 1:{	//Nuevo
			contPoliza.setPolizaId(contPoliza.maxReg(conElias, ejercicioId, libroId));
		}break;
		case 2: {	// Grabar y Modificar
			contPoliza.setEjercicioId(ejercicioId);
			contPoliza.setLibroId(libroId);
			contPoliza.setPolizaId(polizaId);
			
			if (!contPoliza.existeReg(conElias)){
				contPoliza.setPolizaId(contPoliza.maxReg(conElias, ejercicioId, libroId));
				contPoliza.setCcostoId(ccostoId);
				contPoliza.setFecha(request.getParameter("fecha"));
				contPoliza.setDescripcion(request.getParameter("descripcion"));
				contPoliza.setEstado("A");
				contPoliza.setUsAlta((String)session.getAttribute("codigoId"));
				contPoliza.setUsRevision(request.getParameter("usRevision"));
				if (contPoliza.insertReg(conElias)){					
					salto = "cabecera.jsp?Ejercicio="+ejercicioId+"&Libro="+libroId+"&ccostoId="+ccostoId+"&Accion=5";
				}else{
					resultado = "<font color=red size=2>No Grab&oacute;: "+contPoliza.getPolizaId()+"</font>";
				}
			}else{
				contPoliza.mapeaRegId(conElias, ejercicioId, libroId, polizaId);
				contPoliza.setFecha(request.getParameter("fecha"));
				contPoliza.setDescripcion(request.getParameter("descripcion"));
				contPoliza.setUsRevision(request.getParameter("usRevision"));
				if (contPoliza.updateReg(conElias)){					
					salto = "cabecera.jsp?Ejercicio="+ejercicioId+"&Libro="+libroId+"&ccostoId="+ccostoId+"&Accion=6";
				}else{
					resultado = "<font color=red size=2>No Modific&oacute;: "+contPoliza.getPolizaId()+"</font>";
				}				
			}
		}break;
		case 4: {	// Consultar
			contPoliza.setEjercicioId(ejercicioId);
			contPoliza.setLibroId(libroId);
			contPoliza.setPolizaId(polizaId);
			if (contPoliza.existeReg(conElias) == true){
				contPoliza.mapeaRegId(conElias, ejercicioId, libroId, polizaId);
			}else{
				resultado = "<font color=red size=2>No existe: "+contPoliza.getPolizaId()+"</font>"; 
			}	
		}break;
	}	
%>
<head>
	<script>
		function grabar(){
			if(document.forma.fecha.value != "" &&
			  document.forma.descripcion.value != "" &&
			  document.forma.usRevision.value != ""){
				document.forma.action += "&Accion=2";
				return true;
			}else{
				alert("¡Complete el formulario! ");
			}
			return false;
		}		
	</script>
</head>
<body>
	<form id="forma" name="forma" action="accion.jsp?ejercicioId=<%=ejercicioId %>&libroId=<%=libroId %>" method="post">
		<table width="100%">
			<tr>
				<td><a href="cabecera.jsp?Ejercicio=<%=ejercicioId %>&Libro=<%=libroId %>&ccostoId=<%=ccostoId %>">&lsaquo;&lsaquo; Regresar</a></td>
			</tr>
			<tr>
				<td align="center">
					<%=resultado %>&nbsp;
				</td>
			</tr>
			<tr>
				<td class="titulo">Editar Poliza</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
		<table align="center" style="border: dotted 1px gray;">
			<tr>
				<td>ID</td>
				<td>
<%
	if(accion == 4 || accion == 2){
%>
					<%=contPoliza.getPolizaId() %>
					<input type="hidden" id="polizaId" name="polizaId" value="<%=contPoliza.getPolizaId() %>" />
<%
	}else{
%>
					<%=contPoliza.maxReg(conElias, ejercicioId, libroId) %>
<%
	}
%>
				</td>
			</tr>
<%
	if(Usuario.esAdministrador(conElias, codigoId)){
%>
			<tr>
				<td>Centro de Costo</td>
				<td>
<%
		if(accion == 4 || accion == 2){
			contCcosto.mapeaRegId(conElias, contPoliza.getCcostoId());
%>
					<%=contCcosto.getNombre() %>
					<input type="hidden" id="ccostoId" name="ccostoId" value="<%=contPoliza.getCcostoId() %>" />
<%
		}else{
%>
					<select id="ccostoId" name="ccostoId">
<%
			lisCcosto = contCcostoL.getListNivelContable(conElias, "ORDER BY NOMBRE");
			for(int i = 0; i < lisCcosto.size(); i++){
				contCcosto = (ContCcosto) lisCcosto.get(i);
%>
						<option value="<%=contCcosto.getCcostoId() %>"<%=contPoliza.getCcostoId().equals(contCcosto.getCcostoId())?" Selected":ccostoId.equals(contCcosto.getCcostoId())?" Selected":"" %>><%=contCcosto.getNombre() %></option>
<%
			}
%>
					</select>
				</td>
			</tr>
<%
		}
	}
%>
			<tr>
				<td>Fecha*</td>
				<td>
					<input id="fecha" name="fecha" type="text" size="10" maxlength="10" value="<%=contPoliza.getFecha().equals("")?Fecha.getHoy():contPoliza.getFecha() %>"> DD/MM/AAAA</td>
				</td>
			</tr>
			<tr>
				<td>Descripcion*</td>
				<td><input type="text" id="descripcion" name="descripcion" value="<%=contPoliza.getDescripcion() %>" size="40" maxlength="100" /></td>
			</tr>
			<tr>
				<td>Capturista*</td>
				<td>
					<select id="usRevision" name="usRevision">
<%
	lisUsuario = usuarioL.getListContable(conElias, "ORDER BY EMP_APELLIDO(CODIGO_ID)");
	for(int i = 0; i < lisUsuario.size(); i++){
		usuario = (Usuario) lisUsuario.get(i);
%>
						<option value="<%=usuario.getCodigoId() %>"<%=contPoliza.getUsRevision().equals(usuario.getCodigoId())?" Selected":"" %>><%=EmpPersonal.getNombre(conElias, usuario.getCodigoId(), "APELLIDO") %></option>
<%
	}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" value="Guardar" onclick="return grabar();" /></td>
			</tr>
		</table>
	</form>
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fecha').datepicker();
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>