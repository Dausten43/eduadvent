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
<script language="javascript">
			
	function Guardar() {
		var rIni = document.formFolio.reciboInicial.value;
		var rFin = document.formFolio.reciboFinal.value;
		if(parseInt(rFin)<parseInt(rIni)){
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
	
	function Eliminar(ejercicioId, usuario){
		if(confirm("¿Desea eliminar el ejercicio seleccionado?")){
			document.location.href="folio.jsp?Accion=3&EjercicioId="+ejercicioId+"&Usuario="+usuario;
		}
	}
</script>
</head>
<%
		String escuelaId 		= (String) session.getAttribute("escuela");
		String accion 			= request.getParameter("Accion") == null ? "" : request.getParameter("Accion");
		String usuario 			= (String) session.getAttribute("codigoId");
		String ejercicioId 	 	= (String) session.getAttribute("ejercicioId");

		String resultado = "";

		if (!accion.equals("")) {
			if (accion.equals("2")) {
				FinFolio.mapeaRegId(conElias, ejercicioId, request.getParameter("Usuario"));
			} else if (accion.equals("3")) {
				FinFolio.setEjercicioId(ejercicioId);
				FinFolio.setUsuario(request.getParameter("Usuario"));

				if (!FinFolio.deleteReg(conElias))
					resultado = "Error al eliminar el registro";
			} else if (accion.equals("4")) {
				FinFolio.setEjercicioId(ejercicioId);
				FinFolio.setReciboInicial(request.getParameter("reciboInicial"));
				FinFolio.setReciboFinal(request.getParameter("reciboFinal"));
				FinFolio.setReciboActual(request.getParameter("reciboInicial"));
				FinFolio.setUsuario(request.getParameter("Usuario"));

				if (!FinFolio.existeReg(conElias)) {
					if (!FinFolio.insertReg(conElias)) {
						resultado = "Error al guardar el registro";
						accion = "1";
					}
				} else {
					resultado = "La póliza ya existe";
					accion = "1";
				}
			} else if (accion.equals("5")) {
				FinFolio.setEjercicioId(ejercicioId);
				FinFolio.setReciboInicial(request.getParameter("reciboInicial"));
				FinFolio.setReciboFinal(request.getParameter("reciboFinal"));
				FinFolio.setUsuario(request.getParameter("Usuario"));

				if (!FinFolio.updateReg(conElias)) {
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
	
		<h2>
			Folios 
		</h2>
		<%if(aca.fin.FinEjercicio.existeEjercicio(conElias, ejercicioId)){ %>
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong>
	</div>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="folio.jsp?Accion=1"><i
				class="icon-plus icon-white"></i> Añadir</a>
		</div>
		
		
			

				<%
					if (!accion.equals("1") && !accion.equals("2")) {
				%>
				<%
					} else {
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
					</table>
				</form>
					<div class="well" style="overflow: hidden;">
						<a class="btn btn-primary" href="folio.jsp"	align="right"><i class="icon-remove icon-white"></i> Cancelar</a>
						<%if(accion.equals("2")){%>
						<a class="btn btn-primary" onclick="javascript:Editar();"><i class="icon-ok icon-white"></i> Guardar</a>	
						<%}else if(accion.equals("1")){ %>
						<a class="btn btn-primary" onclick="javascript:Guardar();"><i class="icon-ok icon-white"></i> Guardar</a>
						<%} %>
					</div>
				
			<%
				}
			%>

			
			<font color="#AE2113"><%=resultado.equals("") ? "" : resultado%></font>
			
		
		<br>
		<table width="56%" align="center"
			class="table table-condensed table-striped">

			<tr>
				<th>Editar</th>
				<th>Ejercicio Id</th>
				<th>Usuario</th>
				<th>Recibo Inicial</th>
				<th>Recibo Final</th>
				<th>Recibo Actual</th>
			</tr>

			<%
				for (aca.fin.FinFolio folio : listaFolios) {
			%>
			<tr class="tr2">
				<td align="center">
					<a href="folio.jsp?Accion=2&EjercicioId=<%=folio.getEjercicioId()%>&Usuario=<%=folio.getUsuario()%>"><i class="icon-pencil"></i></a> &nbsp;
					<%if(!FinRecibo.existeUsuario(conElias, folio.getUsuario())){ %> 
						<a href="javascript:Eliminar('<%=folio.getEjercicioId()%>', '<%=folio.getUsuario()%>')"> <i class="icon-remove"></i></a>
					<%} %>
				</td>
				<td align="right"><%=folio.getEjercicioId()%>&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;<%=aca.empleado.EmpPersonal.getNombre(conElias,folio.getUsuario(), "NOMBRE")%></td>
				<td>&nbsp;&nbsp;&nbsp;<%=folio.getReciboInicial()%></td>
				<td>&nbsp;&nbsp;&nbsp;<%=folio.getReciboFinal()%></td>
				<td>&nbsp;&nbsp;&nbsp;<%=folio.getReciboActual()%></td>
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