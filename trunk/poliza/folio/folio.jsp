<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="FinFolio" scope="page" class="aca.fin.FinFolio" />
<jsp:useBean id="FinRecibo" scope="page" class="aca.fin.FinRecibo" />
<jsp:useBean id="FinFolioLista" scope="page" class="aca.fin.FinFolioLista" />
<jsp:useBean id="FinEjercicioLista" scope="page" class="aca.fin.FinEjercicioLista" />
<jsp:useBean id="FinLibroLista" scope="page" class="aca.fin.FinLibroLista" />
<jsp:useBean id="ejerc" scope="page" class="aca.fin.FinEjercicio" />

<html>
<head>
<script>
			
	function Grabar() {
		var rIni = document.formFolio.reciboInicial.value;
		var rFin = document.formFolio.reciboFinal.value;
		if(parseInt(rFin) < parseInt(rIni)){
			alert("El Recibo Final no puede ser menor que el Recibo Inicial");
		}else{
			if (document.formFolio.Usuario.value != ""
				 && document.formFolio.reciboInicial.value != ""
				 && document.formFolio.reciboFinal.value != "") {
					document.formFolio.Accion.value = "4";
					document.formFolio.submit();
			} else {
					alert("¡Completa todos los campos!");
			}
		}
	}
		
	function Editar() {
		var rIni = document.formFolio.reciboInicial.value;
		var rFin = document.formFolio.reciboFinal.value;
		if(parseInt(rFin)<parseInt(rIni)){
			alert("El Recibo Final no puede ser menor que el Recibo Inicial");
		}else{
			if (document.formFolio.reciboInicial.value != ""
				 && document.formFolio.reciboFinal.value != "") {
					document.formFolio.Accion.value = "5";
					document.formFolio.submit();
			} else {
					alert("¡Completa todos los campos!");
			}
		}
	}
	
	function Eliminar(ejercicioId, usuario, folio){
		if(confirm("¿Desea eliminar el ejercicio seleccionado?")){
			document.location.href="folio.jsp?Accion=3&EjercicioId="+ejercicioId+"&Usuario="+usuario+"&Folio="+folio;
		}
	}
</script>
</head>
<%
	String escuelaId 		= (String) session.getAttribute("escuela");	
	String usuario 			= (String) session.getAttribute("codigoId");
	String ejercicioId 	 	= (String) session.getAttribute("ejercicioId");
	
	String accion 			= request.getParameter("Accion") == null ?"0":request.getParameter("Accion");

	String resultado = "";

	if (!accion.equals("")) {
		if (accion.equals("2")) {
			FinFolio.mapeaRegId(conElias, ejercicioId, request.getParameter("Usuario"), request.getParameter("Folio"));
		} else if (accion.equals("3")) {
			FinFolio.setEjercicioId(ejercicioId);
			FinFolio.setUsuario(request.getParameter("Usuario"));
			FinFolio.setFolio(request.getParameter("Folio"));
			
			if (!FinFolio.deleteReg(conElias))
				resultado = "Error al eliminar el registro";
		} else if (accion.equals("4")) {
			FinFolio.setEjercicioId(ejercicioId);
			FinFolio.setReciboInicial(request.getParameter("reciboInicial"));
			FinFolio.setReciboFinal(request.getParameter("reciboFinal"));
			FinFolio.setReciboActual(request.getParameter("reciboInicial"));
			FinFolio.setUsuario(request.getParameter("Usuario"));
			FinFolio.setEstado("I");
			FinFolio.setFolio(FinFolio.maxReg(conElias, ejercicioId, request.getParameter("Usuario")));

			if(!FinFolio.verificaFolio(conElias, escuelaId, request.getParameter("reciboInicial"))) {
				if(!FinFolio.verificaFolio(conElias, escuelaId, request.getParameter("reciboFinal"))){	
					if (!FinFolio.existeReg(conElias)) {
						if (!FinFolio.insertReg(conElias)) {
							resultado = "Error al guardar el registro";
							accion = "1";
						}
					} else {
						resultado = "La póliza ya existe";
						accion = "1";
					}
				}else{
					resultado = "Recibo final está dentro de un rango existente";
					accion = "1";
				}
			}else{
				resultado = "Recibo inicial está dentro de un rango existente";
				accion = "1";
			}
		} else if (accion.equals("5")) {
			FinFolio.setEjercicioId(ejercicioId);
			FinFolio.setReciboInicial(request.getParameter("reciboInicial"));
			FinFolio.setReciboFinal(request.getParameter("reciboFinal"));
			FinFolio.setUsuario(request.getParameter("Usuario"));
			FinFolio.setEstado(request.getParameter("Estado"));
			FinFolio.setFolio(request.getParameter("Folio"));

			if (FinFolio.updateReg(conElias)) {
				if (!FinFolio.updateEstatusInactivos(conElias)){
					resultado = "Error al editar el estado de las inactivas";
					accion = "2";
				}
			}else {
				resultado = "Error al editar el registro";
				accion = "2";
			}
		}
	}
	
	TreeMap<String, aca.fin.FinEjercicio> listaEjercicios = FinEjercicioLista.getTreePorEscuela(conElias, escuelaId, "ORDER BY YEAR");
	ArrayList<aca.fin.FinFolio> listaFolios = FinFolioLista.getListEjercicio(conElias, ejercicioId, "ORDER BY EJERCICIO_ID ");
	ArrayList<aca.empleado.EmpPersonal> EmpPersonalLista = new aca.empleado.EmpPersonalLista().getListAll(conElias, escuelaId, "ORDER BY 4,5,3");

	ejerc.mapeaRegId(conElias, ejercicioId);
%>
<body>
<div id="content">
	<h2>Folios
		<small> 
		( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong> )
		</small>
	</h2>
<%	if(aca.fin.FinEjercicio.existeEjercicio(conElias, ejercicioId)){ %>
	<div class="well" style="overflow: hidden;">
		<a class="btn btn-primary" href="folio.jsp?Accion=1"><i class="icon-plus icon-white"></i> Añadir</a>
	</div>		

	<%
		if (!accion.equals("1") && !accion.equals("2")) {
	%>
	<%
		}else{
	%>
	<form name="formFolio"  action="folio.jsp">
	<input name="Accion" type="hidden" value="<%=accion%>"/>
	<table width="56%" align="center" class="table table-condensed table-striped">
		<tr>
			<td>Usuario:</td>
			<td>
				<select name="Usuario" id="Usuario" style="width:50%;" <%if(accion.equals("2")){%> disabled<%} %>>
				<%for(aca.empleado.EmpPersonal emp : EmpPersonalLista){ %>
					<option value="<%=emp.getCodigoId()%>" <%if(FinFolio.getUsuario().equals(emp.getCodigoId()))out.print("selected"); %>>
						<%=emp.getCodigoId()%> | <%=emp.getNombre()+" "+emp.getApaterno()+" "+emp.getAmaterno() %>
					</option>
						<%} %>
				</select>
				<%if(accion.equals("2")){ %>
				<input name="Usuario" type="hidden" value="<%=FinFolio.getUsuario()%>"/>
				<input name="Folio" type="hidden" value="<%=FinFolio.getFolio()%>"/>
				<%} %>
			</td>
		</tr>		
		<tr>
			<td>Recibo Inicial:</td>
			<td><input type="number" value="<%=FinFolio.getReciboInicial() == null ? "" : FinFolio.getReciboInicial()%>"  maxlength="7" id="reciboInicial" name="reciboInicial"></td>
		</tr>
		<tr>
			<td>Recibo Final:</td>
			<td><input type="number" value="<%=FinFolio.getReciboFinal() == null ? "" : FinFolio.getReciboFinal()%>"   maxlength="7" id="reciboFinal" name="reciboFinal"></td>
		</tr>
		<%if(accion.equals("2")){ %>
		<tr>
			<td>Estado:</td>
			<td>
				<select name="Estado" id="Estado" style="width:10%;">
					<option value="A" <%=FinFolio.getEstado().equals("A")?"selected":""%>>Activo</option>
					<option value="I" <%=FinFolio.getEstado().equals("I")?"selected":""%>>Inactivo</option>
				</select>
			</td>
		</tr>
	<%} %>		
	</table>
	
	<div class="well" style="overflow: hidden;">
		<a class="btn btn-primary" href="folio.jsp"	align="right"><i class="icon-remove icon-white"></i> Cancelar</a>
		<%if(accion.equals("2")){%>
		<a href="javascript:Editar()" class="btn btn-primary"><i class="icon-ok icon-white"></i> Editar</a>
		<%}else if(accion.equals("1")){ %>
		<a href="javascript:Grabar()" class="btn btn-primary"><i class="icon-ok icon-white"></i> Guardar</a>
		<%} %>
	</div>	
	</form>			
	<%
		}
	%>	
	<font color="#AE2113"><%=resultado.equals("") ? "" : resultado%></font>	
	<table width="56%" class="table table-condensed table-striped">

		<tr>
			<th>Editar</th>
			<th>Ejercicio Id</th>
			<th>Usuario</th>
			<th>Recibo Inicial</th>
			<th>Recibo Final</th>
			<th>Recibo Actual</th>
			<th>Estado</th>
			<th>Folio</th>
		</tr>

	<%
		for (aca.fin.FinFolio folio : listaFolios) {
	%>
		<tr class="tr2">
			<td align="center">
				<a href="folio.jsp?Accion=2&EjercicioId=<%=folio.getEjercicioId()%>&Usuario=<%=folio.getUsuario()%>&Folio=<%=folio.getFolio()%>"><i class="icon-pencil"></i></a> &nbsp;
				<%if(!folio.tieneRecibo(conElias, folio.getEjercicioId(), folio.getUsuario(), folio.getFolio())){ %> 
					<a href="javascript:Eliminar('<%=folio.getEjercicioId()%>','<%=folio.getUsuario()%>','<%=folio.getFolio()%>')">
						<i class="icon-remove"></i>
					</a>
				<%} %>
			</td>
			<td align="right"><%=folio.getEjercicioId()%>&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;<%=aca.empleado.EmpPersonal.getNombre(conElias,folio.getUsuario(), "NOMBRE")%></td>
			<td>&nbsp;&nbsp;&nbsp;<%=folio.getReciboInicial()%></td>
			<td>&nbsp;&nbsp;&nbsp;<%=folio.getReciboFinal()%></td>
			<td>&nbsp;&nbsp;&nbsp;<%=folio.getReciboActual()%></td>
			<td>&nbsp;&nbsp;&nbsp;<%=folio.getEstado().equals("I")?"Inactivo":"Activo"%></td>
			<td>&nbsp;&nbsp;&nbsp;<%=folio.getFolio()%></td>
		</tr>
		<%
		}
		%>
	</table>
	<%}else{%>
	<div class="alert alert-danger">
		<h3><fmt:message key="aca.EjercicioNoValido" /></h3>
	</div>
<%} %>
</div>
<link rel="stylesheet" href="../../js-plugins/chosen/chosen.css" />
<script src="../../js-plugins/chosen/chosen.jquery.js" type="text/javascript"></script>
<script> 
		$('#Usuario').chosen();
		
		jQuery("#reciboInicial").keyup(function(){ 
			$this = jQuery(this); 
			var maximo = parseInt($this.val());
			if(maximo==0){
					$this.val("1");
					alert("El recibo inicial no puede empezar en 0");
			}
		});
		
		jQuery("#reciboFinal").keyup(function(){ 
			$this = jQuery(this); 
			var maximo = parseInt($this.val());
			if(maximo==0){
					$this.val("1");
					alert("El recibo final no puede empezar en 0");
			}
		});
		
</script>
</body>
</html>
<%@ include file="../../cierra_elias.jsp"%>