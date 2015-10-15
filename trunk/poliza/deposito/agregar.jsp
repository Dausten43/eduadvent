<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="FinDeposito" scope="page" class="aca.fin.FinDeposito" />
<jsp:useBean id="empLista" scope="page" class="aca.empleado.EmpPersonalLista" />
<head>
	
<script>
	function Grabar(){
		document.frmDeposito.Accion.value="1";		
		document.frmDeposito.submit();
	}
	
	function Modificar(folio){
		document.frmDeposito.Accion.value="2";
		document.frmDeposito.action+="?Folio="+folio;
		document.frmDeposito.submit();
	}
</script>
<%
	String escuelaId 	= (String) session.getAttribute("escuela");	
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	String folio 		= request.getParameter("Folio")==null?"0":request.getParameter("Folio");
	String fechaIni		= request.getParameter("FechaIni")==null?aca.util.Fecha.getHoy():request.getParameter("FechaIni");
	String fechaFin		= request.getParameter("FechaFin")==null?aca.util.Fecha.getHoy():request.getParameter("FechaFin");
	String responsable 	= request.getParameter("Responsable")==null?"0":request.getParameter("Responsable"); 
	
	ArrayList<aca.empleado.EmpPersonal> empleados = empLista.getListEmpActivos(conElias, escuelaId, "");
	
	if( accion.equals("1")){ // Grabar		
		FinDeposito.setEscuelaId(escuelaId);
		folio =  FinDeposito.maxReg(conElias, escuelaId );
		FinDeposito.setFolio(folio);
		FinDeposito.setFecha(aca.util.Fecha.getHoy());
		FinDeposito.setFechaDeposito(request.getParameter("FechaDeposito"));
		FinDeposito.setImporte(request.getParameter("Importe"));
		FinDeposito.setResponsable(request.getParameter("Responsable"));		
		if(FinDeposito.insertReg(conElias)){
			conElias.commit();
			folio = FinDeposito.maxReg(conElias, escuelaId );
		}
	}else if( accion.equals("2")){ // Modificar		
		FinDeposito.setEscuelaId(escuelaId);		
		FinDeposito.setFolio(folio);
		FinDeposito.setFecha(aca.util.Fecha.getHoy());
		FinDeposito.setFechaDeposito(request.getParameter("FechaDeposito"));
		FinDeposito.setImporte(request.getParameter("Importe"));
		FinDeposito.setResponsable(request.getParameter("Responsable"));		
		if(FinDeposito.updateReg(conElias)){
			conElias.commit();
		}
	}else if (accion.equals("3")){
		FinDeposito.setEscuelaId(escuelaId);		
		FinDeposito.setFolio(folio);
		if (FinDeposito.existeReg(conElias)){
			FinDeposito.mapeaRegId(conElias, escuelaId, folio);
		}		
	}
	
%>

</head>

<div id="content">
	<h2>Depositos de caja</h2>	
	<div class="well">
		<a class="btn btn-primary" href="alta.jsp?FechaIni=<%=fechaIni%>&FechaFin=<%=fechaFin%>">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/>
		</a>
	</div>	
	<form action="agregar.jsp" method="post" name="frmDeposito" target="_self" >
	<input type="hidden" name="Accion">
	<input name="FechaIni" type="hidden" id="FechaIni" value="<%=fechaIni%>">
	<input name="FechaFin" type="hidden" id="FechaFin" value="<%=fechaFin%>">
	
	<fieldset style="max-width:100px; display:inline;">
		<label for="Folio"><fmt:message key="aca.Folio" /></label>
		<input name="Folio" type="text" id="Folio" size="10" maxlength="10" value="<%=folio%>" disabled>
	</fieldset>

	<fieldset>
		<label for="FechaDeposito"><fmt:message key="aca.Fecha" /></label>
		<input name="FechaDeposito" type="text" id="FechaDeposito" size="10" maxlength="10" class="datepicker" value="<%=FinDeposito.getFechaDeposito()%>" required>
	</fieldset>		

	<fieldset>
		<label for="Importe"><fmt:message key="aca.Importe" /></label>
		<input name="Importe" type="text" id="Importe" size="10" maxlength="10" value="<%=FinDeposito.getImporte()%>" required>
	</fieldset>		
	
	<fieldset>
		<label for="Responsable"><fmt:message key="aca.Responsable" /></label>
		<select name="Responsable" required>
		<%for(aca.empleado.EmpPersonal empleado : empleados){ %>
		
		<option value="<%=empleado.getCodigoId() %>" <%if(responsable.equals(empleado.getCodigoId()))out.print("selected"); %>><%=empleado.getNombre()%> <%=empleado.getApaterno() %> <%=empleado.getAmaterno() %></option>
		<%} %>
		</select>
	</fieldset>
	
	<div class="well">
	<%if(!accion.equals("4")){ %>
		<button class="btn btn-primary" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Anadir" /></button>&nbsp;&nbsp;
	<%}else{ %>
		<button class="btn btn-primary" onclick="javascript:Modificar('<%=folio%>')"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Modificar" /></button>
	<%} %>
	</div>

	</form>
</div>
		
	
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('.datepicker').datepicker();
</script>

</body>
<%@ include file="../../cierra_elias.jsp"%>