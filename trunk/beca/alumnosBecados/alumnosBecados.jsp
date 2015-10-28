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
<jsp:useBean id="FinCalculoDetL" scope="page" class="aca.fin.FinCalculoDetLista"/>



<script>  
 	function Grabar(){
		document.frmBeca.Accion.value = "1";
		document.frmBeca.submit();
	}
	
	function Consultar( PeriodoId, BecaId ){
	  	document.location="alumnosBecados.jsp?Accion=2&Periodo="+PeriodoId+"&BecaId="+BecaId;
	}
	
	function Borrar( PeriodoId, BecaId ){
		if(confirm( "<fmt:message key="js.Confirma" />" )==true){
	  		document.location="alumnosBecados.jsp?Accion=3&Periodo="+PeriodoId+"&BecaId="+BecaId;
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
	String entidadId		= request.getParameter("EntidadId")==null?"0":request.getParameter("EntidadId");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	/* Actualiza el cicloId */
	if(cicloId.equals("0")){
		cicloId = (String) session.getAttribute("cicloId");
	}else{
		session.setAttribute("cicloId", cicloId);
	}
	
	/* LISTA DE CICLOS */
	ArrayList<aca.ciclo.Ciclo> lisCiclo 				= cicloL.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	/* LISTA DE PERIODOS*/
	ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo 	= cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY F_INICIO");	
	
	/* LISTA DE ENTIDADES */	
	ArrayList<aca.beca.BecEntidad> lisEntidad			= BecEntidadL.getListEntidad(conElias, cicloId, periodoId, "ORDER BY ENTIDAD_NOMBRE");	
	
	/* LISTA DE BECAS */
	ArrayList<aca.beca.BecAlumno> lisBeca;
	if(!entidadId.equals("T")){
		lisBeca 				= BecaL.getListPorEntidad(conElias, cicloId, periodoId, entidadId, "");
	}else{
		lisBeca 				= BecaL.getListTodo(conElias, cicloId, periodoId, "");	
	}
	/* MAP DE USUARIOS */
	java.util.HashMap<String,String> mapEmpleado		= EmpPersonalL.mapEmpleados(conElias, escuelaId, "NOMBRE");
	
	/* MAP DE IMPORTE DE BECA*/
	java.util.HashMap<String, String> mapFinCalculoDet 	= FinCalculoDetL.mapImporte(conElias, cicloId);
	
	
	if(periodoId == null||periodoId.equals("")){
		if(lisCicloPeriodo.size() > 0){
			periodoId = lisCicloPeriodo.get(0).getPeriodoId();
		}else{
			periodoId = "0";
		}
	}
%>

<div id="content">

	<h2><fmt:message key="becas.BecaAlumno" /></h2>
	
	<form id="frmBeca" name="frmBeca" action="alumnosBecados.jsp" method="post">
		<input type="hidden" name="Accion" />
		
		<div class="well" >	
			<select id="Ciclo" name="Ciclo" onchange="javascript:cambiaCiclo()" class="input-xlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId()%>"<%=cicloId.equals(ciclo.getCicloId())? " Selected":"" %>><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
				<%}%>
			</select>
			
			<select id="Periodo" name="Periodo" onchange="javascript:cambiaCiclo()" >
				<%for(aca.ciclo.CicloPeriodo cicloPeriodo : lisCicloPeriodo){%>
					<option value="<%=cicloPeriodo.getPeriodoId() %>"<%=periodoId.equals(cicloPeriodo.getPeriodoId())? " Selected":"" %>><%=cicloPeriodo.getPeriodoNombre() %></option>
				<%}%>
			</select>			
			
			<fmt:message key="aca.Entidad" />
			<select id="EntidadId" name="EntidadId" onchange="javascript:document.frmBeca.submit();">	
				<option value="T"><fmt:message key="boton.Todos" /></option>			
				<%for(aca.beca.BecEntidad entidad : lisEntidad){%>			
					<option value="<%=entidad.getEntidadId()%>" <%=entidadId.equals(entidad.getEntidadId())?"Selected":"" %>><%=entidad.getEntidadNombre()%></option>
				<%}%>
			</select>		
		</div>	
		
		<table class="table table-condensed table-bordered table-striped">		
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Entidad" /></th>
					<th><fmt:message key="aca.Cuenta" /></th>
					<th><fmt:message key="aca.Alumno" /></th>
					<th><fmt:message key="aca.Tipo" /></th>
					<th style="text-align:right"><fmt:message key="aca.Beca" /></th>
					<th style="text-align:right">Importe</th>
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
					String importe = "0.00";
					if(mapFinCalculoDet.containsKey(beca.getCicloId() + beca.getPeriodoId() + beca.getCodigoId() + beca.getCuentaId())){
						importe = mapFinCalculoDet.get(beca.getCicloId() + beca.getPeriodoId() + beca.getCodigoId() + beca.getCuentaId());
					}
			%>	
					<tr>
					  	<td><%=i+1%></td>
					 	<td><%= aca.beca.BecEntidad.getEntidadNombre(conElias, beca.getEntidadId())%></td>		 	
					  	<td><%= aca.fin.FinCuenta.getCuentaNombre(conElias, beca.getCuentaId())%></td>	
					  	<td><%= aca.alumno.AlumPersonal.getNombre(conElias, beca.getCodigoId(), "NOMBRE")%></td>	  	
					  	<td><%=beca.getTipo() %></td>
					  	<td style="text-align:right"><%= beca.getBeca()%><%if(beca.getTipo().equals("PORCENTAJE")){out.print("%");} %></td>
					  	<td style="text-align:right"><%=importe %></td>
					  	<td><%=beca.getUsuario()%> | <%=nombreEmpleado%></td>
					</tr>		
			<% 
				} 
			%>					  
		</table>
	</form>
</div>
<%@ include file= "../../cierra_elias.jsp" %>