<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="BecAlum" scope="page" class="aca.beca.BecAlumno"/>
<jsp:useBean id="BecaL" scope="page" class="aca.beca.BecAlumnoLista"/>
<jsp:useBean id="BecEntidadL" scope="page" class="aca.beca.BecEntidadLista"/>
<jsp:useBean id="BecCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="BecCuentaN" scope="page" class="aca.fin.FinCuenta"/>
<jsp:useBean id="EmpPersonalL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
  
 <script>  
 	function Grabar(){ 	  		
		if(document.frmBeca.Beca.value!= ""){ 	
			
			if(document.getElementById("Tipo").value == 'PORCENTAJE' && parseFloat(document.getElementById("Beca").value) > 100){
				alert("<fmt:message key='js.PorcentajeMayorDe100' />"); 
			}else{
				document.frmBeca.Accion.value = "1";
				document.frmBeca.submit();
			}
		}else{
			alert("<fmt:message key='js.Completar' />");			
		}	
	}
	 	
	function Consultar( PeriodoId, BecaId ){
	  	document.location="alumno.jsp?Accion=2&Periodo="+PeriodoId+"&BecaId="+BecaId;
	}
	
	function Borrar( PeriodoId, BecaId ){
		if(confirm( "<fmt:message key="js.Confirma" />" )==true){
	  		document.location="alumno.jsp?Accion=3&Periodo="+PeriodoId+"&BecaId="+BecaId;
	  	}
	}
	
	function cambiaCiclo( ){
		document.frmBeca.Accion.value = "0";
		document.frmBeca.submit();
	}	
</script>	

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String usuario	 		= (String) session.getAttribute("codigoId");
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	
	String cicloId			= request.getParameter("Ciclo")==null?"0":request.getParameter("Ciclo");
	String periodoId		= request.getParameter("Periodo")==null?"1":request.getParameter("Periodo");
	String cuentaId			= request.getParameter("CuentaId")==null?"0":request.getParameter("CuentaId");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	String nombreAlumno		= "-";
	String nivelAlumno		= "0";
	
	
	/* Actualiza el cicloId */
	if(cicloId.equals("0")){
		cicloId = (String) session.getAttribute("cicloId");
	}else{
		session.setAttribute("cicloId", cicloId);
	}
	
	/* LISTA DE PERIODOS*/
	ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo 	= cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_ID");
	boolean encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisCicloPeriodo){
		if(per.getPeriodoId().equals(periodoId)){
			encontro = true;
		}
	}
	if(encontro==false && lisCicloPeriodo.size()>0){
		periodoId = lisCicloPeriodo.get(0).getPeriodoId();
	}
	
	AlumPersonal.setCodigoId(codigoAlumno);
	if (AlumPersonal.existeReg(conElias)){
		nombreAlumno 	= aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "NOMBRE");
		nivelAlumno 	= String.valueOf(aca.alumno.AlumPersonal.getNivel(conElias, codigoAlumno));
	}
	
	switch (Integer.parseInt(accion)){
		case 1: { // Grabar o Modificar		
			
			BecAlum.setCicloId(cicloId);
			BecAlum.setPeriodoId(periodoId);
			BecAlum.setCodigoId(codigoAlumno);			
			BecAlum.setEntidadId(request.getParameter("EntidadId"));			
			BecAlum.setCuentaId(cuentaId);
			BecAlum.setBeca(request.getParameter("Beca"));
			BecAlum.setTipo(request.getParameter("Tipo"));
			BecAlum.setUsuario(usuario);
			conElias.setAutoCommit(false);
			if (BecAlum.existeRegBeca(conElias)){
				// Modificar				
				BecAlum.setBecaId(BecAlum.getBecaId(conElias, cicloId, periodoId, codigoAlumno, request.getParameter("EntidadId"), cuentaId));
				if (BecAlum.updateReg(conElias)){					
					conElias.commit();
				}
			}else{
				// Grabar
				BecAlum.setBecaId(BecAlum.maximoReg(conElias));
				
				if (BecAlum.insertReg(conElias)){
					conElias.commit();
				}
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 2: { // Consultar
			BecAlum.setBecaId(request.getParameter("BecaId"));
			if (BecAlum.existeReg(conElias)){				
				BecAlum.mapeaRegId(conElias,BecAlum.getBecaId());
			}
			break;
		}
		case 3: { // Borrar
			conElias.setAutoCommit(false);
			BecAlum.setBecaId(request.getParameter("BecaId"));
			if (BecAlum.existeReg(conElias)){
				if (BecAlum.deleteReg(conElias)){
					conElias.commit();
				}
			}
			conElias.setAutoCommit(true);
			break;
			
		}
	}
	
	/* LISTA DE CICLOS */
	ArrayList<aca.ciclo.Ciclo> lisCiclo 				= cicloL.getListActivos(conElias, escuelaId, "ORDER BY F_INICIAL");
	
	/* LISTA DE ENTIDADES */
	ArrayList<aca.beca.BecEntidad> lisEntidad			= BecEntidadL.getListAll(conElias, escuelaId, "ORDER BY ENTIDAD_NOMBRE");	
	
	/* CUENTAS DE LA ESCUELA */
	ArrayList<aca.fin.FinCuenta> lisCuenta  			= BecCuentaL.getListBecas(conElias, escuelaId, "ORDER BY CUENTA_ID");
	
	/* LISTA DE BECAS DEL ALUMNO */
	ArrayList<aca.beca.BecAlumno> lisBeca 				= BecaL.getListAlumno(conElias, cicloId, periodoId, codigoAlumno, "ORDER BY CUENTA_ID DESC");
	
	/* MAP DE USUARIOS */
	java.util.HashMap<String,String> mapEmpleado		= EmpPersonalL.mapEmpleados(conElias, escuelaId, "NOMBRE");
	
	
	/* PERIODO */
	if(periodoId == null||periodoId.equals("")){
		if(lisCicloPeriodo.size() > 0){
			periodoId = lisCicloPeriodo.get(0).getPeriodoId();		
		}else{
			periodoId = "0";
		}
	}
	
%>
<div id="content">

<%if(!Alumno.existeReg(conElias, codigoAlumno)){ %>
	<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
	</div>
<%}else{ %>


	<h2><fmt:message key="aca.Becas" />/<fmt:message key="aca.Descuentos" /><small><%=nombreAlumno%> </small></h2>
	
	<form id="frmBeca" name="frmBeca" action="alumno.jsp" method="post">
		<input type="hidden" name="Accion" />
		
		<div class="well" >	
			<select id="Ciclo" name="Ciclo" onchange="javascript:cambiaCiclo()" class="input-xlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId()%>"<%=cicloId.equals(ciclo.getCicloId())? " Selected":"" %>><%=ciclo.getCicloNombre()%></option>
				<%}%>
			</select>
			
			<select id="Periodo" name="Periodo" onchange="javascript:cambiaCiclo()" >
				<%for(aca.ciclo.CicloPeriodo cicloPeriodo : lisCicloPeriodo){%>
					<option value="<%=cicloPeriodo.getPeriodoId() %>"<%=periodoId.equals(cicloPeriodo.getPeriodoId())? " Selected":"" %>><%=cicloPeriodo.getPeriodoNombre() %></option>
				<%}%>
			</select>				
		</div>
		
		
		<div class="row">
		
			<div class="span4">
			
				<div class="alert">
				
					<fieldset>			
						<label><fmt:message key="aca.Entidad" /></label>
						<select id="EntidadId" name="EntidadId">				
							<%for(aca.beca.BecEntidad entidad : lisEntidad){%>			
								<option value="<%=entidad.getEntidadId()%>"<%=BecAlum.getEntidadId().equals(entidad.getEntidadId())?" Selected":"" %> data-limcantidad="<%= entidad.getLimiteCantidad() %>" data-limporc="<%= entidad.getLimitePorcentaje() %>" ><%=entidad.getEntidadNombre()%></option>
							<%}%>
						</select>			
					</fieldset>
					
					<fieldset>			
						<label><fmt:message key="aca.Cuenta" /></label>		
						<select id="CuentaId" name="CuentaId">
							<%for(aca.fin.FinCuenta cuenta : lisCuenta){%>			
								<option value="<%=cuenta.getCuentaId()%>" <%=BecAlum.getCuentaId().equals(cuenta.getCuentaId())?" Selected":"" %>>[<%=cuenta.getCuentaId()%>] - <%=cuenta.getCuentaNombre()%></option>								
							<%}%>
						</select>			
					</fieldset>
					
					<fieldset>
						<label><fmt:message key="aca.Tipo" /></label>
						<select name="Tipo" id="Tipo">
							<option value="PORCENTAJE" <%=BecAlum.getTipo().equals("PORCENTAJE")?"Selected":"" %>><fmt:message key="aca.Porcentaje" /></option>
							<option value="CANTIDAD" <%=BecAlum.getTipo().equals("CANTIDAD")?"Selected":"" %>><fmt:message key="aca.Cantidad" /></option>
						</select>
					</fieldset>
					
					<fieldset>
						<label><fmt:message key="aca.Beca" />/<fmt:message key="aca.Descuento" /></label>
						<input type="text" class="input-small" id="Beca" name="Beca" value="<%=BecAlum.getBeca()%>" maxlength="9" />
					</fieldset>
				
				</div>		
				
				<div class="well">
					<a href="javascript:Grabar()" class="btn btn-large btn-primary"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
				</div>
					
			</div>	
			
			<div class="span8">
				
				<table class="table table-condensed table-bordered table-striped">		
					<thead>
						<tr>
							<th><fmt:message key="aca.Accion" /></th>
							<th>#</th>
							<th><fmt:message key="aca.Entidad" /></th>
							<th><fmt:message key="aca.Cuenta" /></th>
							<th><fmt:message key="aca.Tipo" /></th>
							<th><fmt:message key="aca.Beca" /></th>
							<th><fmt:message key="aca.Usuario" /></th>
						</tr>
					</thead>		
					<%		
						for(int i = 0; i < lisBeca.size(); i++){
							aca.beca.BecAlumno beca = (aca.beca.BecAlumno) lisBeca.get(i);
							
							// Busca el nombre del empleado 
							String nombreEmpleado = "";
							if (mapEmpleado.containsKey(beca.getUsuario())){ 
								nombreEmpleado = mapEmpleado.get(beca.getUsuario());
							}
					%>	
							<tr>
								<td>
					    			<a href="javascript:Consultar('<%=beca.getPeriodoId()%>','<%=beca.getBecaId()%>');" style="cursor: pointer;"><i class="icon-pencil"></i></a>
					    			<a href="javascript:Borrar('<%=beca.getPeriodoId()%>','<%=beca.getBecaId()%>');" style="cursor: pointer;"><i class="icon-remove "></i></a>
					  			</td>
					  			<td><%=i+1%></td>
					 			<td><%= aca.beca.BecEntidad.getEntidadNombre(conElias, beca.getEntidadId())%></td>		 	
							  	<td><%= beca.getCuentaId()%> | <%= aca.fin.FinCuenta.getCuentaNombre(conElias, beca.getCuentaId())%></td>		  	
							  	<td><%=beca.getTipo() %></td>
							  	<td>
							  		<%= beca.getBeca()%><%if(beca.getTipo().equals("PORCENTAJE")){out.print("%");} %>
							  	</td>
							  	<td><%=beca.getUsuario()%> | <%=aca.vista.Usuarios.getNombreUsuario(conElias, beca.getUsuario()) %></td>
							</tr>		
					<%
						} 
					%>					  
				</table>
						
			</div>
		
		</div>
	
	</form>
<script type="text/javascript">

	$('#Tipo').change(function(){
		$('#Beca').trigger('change');
	});
	
	$('#EntidadId').change(function(){
		$('#Beca').trigger('change');
	});

	$('#Beca').change(function(){
		if($('#Tipo').val()=='PORCENTAJE'){
			console.log($('#EntidadId').find(':selected').data('limporc'));
			var lim = parseFloat($('#EntidadId').find(':selected').data('limporc'));
			if(lim>0 && parseFloat($(this).val())>lim ){
				alert('El limite para esta beca es de '+ lim + '');
				$(this).val('0');
			} else if(lim==0){
				alert('El tipo de beca de porcentaje no esta permitido para esta opcion');
						$(this).val('0');
			}
		}else{
			console.log($('#EntidadId').find(':selected').data('limcantidad'));
			var lim = parseFloat($('#EntidadId').find(':selected').data('limcantidad'));
			if(lim>0 && parseFloat($(this).val())>lim ){
				alert('El limite para esta beca es de '+ lim + '');
				$(this).val('0');
			}else if(lim==0){
				alert('El tipo de beca por cantidad no esta permitido para esta opcion');
						$(this).val('0');
			}
		}
	});
</script>
<%} %>
</div>
<%@ include file= "../../cierra_elias.jsp" %>