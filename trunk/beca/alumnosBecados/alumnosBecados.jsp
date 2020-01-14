<%@page import="aca.alumno.AlumPersonalLista"%>
<%@page import="aca.alumno.AlumCicloLista"%>
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
<jsp:useBean id="AlumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>


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
	
	java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
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
	ArrayList<aca.beca.BecEntidad> lisEntidad			= BecEntidadL.getListEntidad(conElias, escuelaId, cicloId, periodoId, " ORDER BY ENTIDAD_NOMBRE");	
	
	/* LISTA DE BECAS */
	ArrayList<aca.beca.BecAlumno> lisBeca;
	if(!entidadId.equals("T")){
		lisBeca 										= BecaL.getListPorEntidad(conElias, cicloId, periodoId, entidadId, "");
	}else{
		lisBeca 										= BecaL.getListTodo(conElias, cicloId, periodoId, "");	
	}
	/* MAP DE USUARIOS */
	java.util.HashMap<String,String> mapEmpleado		= EmpPersonalL.mapEmpleados(conElias, escuelaId, "NOMBRE");
	
	/* MAP DE IMPORTE DE BECA*/
	java.util.HashMap<String, String> mapFinCalculoDet 	= FinCalculoDetL.mapImporte(conElias, cicloId);
	
	/*Inscritos*/
	java.util.HashMap<String, String> mapInscritos		= aca.alumno.AlumCicloLista.mapInscritos(conElias, cicloId, periodoId);	
	
	/*Nombre de Alumnos*/
	java.util.HashMap<String, String> mapAlumnos 		= AlumPersonalL.mapNombreLargo(conElias, escuelaId, "NOMBRE");
	
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
			<select id="Ciclo" name="Ciclo"  class="input-xlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId()%>"<%=cicloId.equals(ciclo.getCicloId())?" Selected":"" %>><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
				<%}%>
			</select>
			
			<select id="Periodo" name="Periodo" >
				<%for(aca.ciclo.CicloPeriodo cicloPeriodo : lisCicloPeriodo){%>
					<option value="<%=cicloPeriodo.getPeriodoId() %>"<%=periodoId.equals(cicloPeriodo.getPeriodoId())? " Selected":"" %>><%=cicloPeriodo.getPeriodoNombre() %></option>
				<%}%>
			</select>			
			
			<fmt:message key="aca.Entidad" />
			<select id="EntidadId" name="EntidadId" >	
				<option value="T"><fmt:message key="boton.Todos" /></option>			
				<%for(aca.beca.BecEntidad entidad : lisEntidad){%>			
					<option value="<%=entidad.getEntidadId()%>" <%=entidadId.equals(entidad.getEntidadId())?"Selected":"" %>><%=entidad.getEntidadNombre()%></option>
				<%}%>
			</select>
			<a id = boton class="btn btn-primary btn-medium" onclick="javascript:document.frmBeca.submit();" onclick="javascript:cambiaCiclo()" onclick="javascript:cambiaCiclo()">Mostrar</a>
		</div>	
		
	</form>
	
	
		<table class="table table-condensed table-bordered table-striped">		
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Entidad" /></th>
					<th><fmt:message key="aca.Cuenta" /></th>
					<th><fmt:message key="aca.Alumno" /></th>
					<th>Inscrito</th>
					<th><fmt:message key="aca.Tipo" /></th>
					<th style="text-align:right"><fmt:message key="aca.Beca" /></th>
					<th style="text-align:right">Importe</th>
				</tr>
			</thead>		
			<%		
				
				String importe;
				String becaCantidad = "0";
				String inscrito = "-";
				String nombre = "-";
				for(int i = 0; i < lisBeca.size(); i++){
					aca.beca.BecAlumno beca = (aca.beca.BecAlumno) lisBeca.get(i);	
					importe = "0";
	 				if(mapFinCalculoDet.containsKey(beca.getCicloId() + beca.getPeriodoId() + beca.getCodigoId() + beca.getCuentaId())){
	 					importe =mapFinCalculoDet.get(beca.getCicloId() + beca.getPeriodoId() + beca.getCodigoId() + beca.getCuentaId());
					}
	 				
	 				if(mapInscritos.containsKey(beca.getCodigoId())){
	 					inscrito = mapInscritos.get(beca.getCodigoId());
	 				}
	 				
	 				if(mapAlumnos.containsKey(beca.getCodigoId())){
	 					nombre = mapAlumnos.get(beca.getCodigoId());
	 				}
			%>	
					<tr>
					  	<td><%=i+1%></td>
					 	<td><%= aca.beca.BecEntidad.getEntidadNombre(conElias, beca.getEntidadId())%></td>		 	
					  	<td><%= aca.fin.FinCuenta.getCuentaNombre(conElias, beca.getCuentaId())%></td>	
					  	<td><%= nombre%></td>
					  	<td><%= inscrito.equals("I")?"Si":"No" %></td>	  	
					  	<td><%= beca.getTipo() %></td>
					  	<td style="text-align:right"><%= beca.getTipo().equals("CANTIDAD")?formato.format(Float.parseFloat(beca.getBeca())):beca.getBeca().replaceAll("(?<=^\\d+)\\.0*$", "").concat("%") %></td>
					  	<td style="text-align:right"><%= formato.format(Float.parseFloat(importe))%></td>
					</tr>		
			<% 
				} 
			%>					  
		</table>
</div>
<%@ include file= "../../cierra_elias.jsp" %>