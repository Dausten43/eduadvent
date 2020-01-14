<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.fin.FinMovimiento"%>
<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista"/>
<jsp:useBean id="finMovimientos" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="finMovimientosL" scope="page" class="aca.fin.FinMovimientosLista"/>

<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ejercicioId		= (String) session.getAttribute("ejercicioId");
	String ciclo			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");
	
	String strBgcolor		= "";
	String nivelTemp        = "0";
	String grado 			= "";
	String grupo 			= "";
	int cont				= 1;
	int contMov				= 0;
	
	
	String fecha = "";
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	fecha = sdf.format(new Date());
	
	if(request.getParameter("fecha")!=null){
		fecha = request.getParameter("fecha");
	}
	
	
	// Lista de ciclos activos en la escuela
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	
	//lista de ejerficio id
	
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList lisInscritos = AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");	
	
	HashMap<String, aca.alumno.AlumCiclo > mapaGradoGrupo =   aca.alumno.AlumCicloLista.getMapHistoria(conElias, "");
	HashMap<String, String> mapaSaldo =  finMovimientosL.getMapSaldosFecha(conElias, escuelaId,  fecha );	// eeste querry se cambio
%>
<style>
	body{
		background: white;
	}
</style>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript"	src="../../bootstrap/datepicker/datepicker.js"></script>
<div id="content">	
	<h2>Saldo de Alumnos Inscritos</h2>
	<form name="forma" action="reporte.jsp" method='post' class="form-inline">
		<div class="well">
		<div class="form-group">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
			<select id="ciclo" name="ciclo"  style="width:360px;margin-bottom:0px;">
				<%for(aca.ciclo.Ciclo c : lisCiclo){%>
					<option value="<%=c.getCicloId() %>"<%=c.getCicloId().equals(ciclo)?" Selected":"" %>><%=c.getCicloId()%> | <%=c.getCicloNombre()%></option>
				<%}%>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			<label>Fecha final:</label><input type="text" name="fecha" id="fecha" data-date-format="dd-mm-yyyy" value="<%=fecha%>"  class="form-control" style="width: 100px; text-align: center;" >
			<input type="submit" name="enviar" value="Generar" class="btn btn-success"> 
		 </div>
		 </div>
	 </form>
	 
	<table class="table table-fullcondensed" width="80%">
	<%	 	
			String gradoAndGrupo = "0";
			java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
			float total = 0f;
			for(int i=0; i<lisInscritos.size();i++){
				cont++;			
				aca.alumno.AlumPersonal inscrito = (aca.alumno.AlumPersonal) lisInscritos.get(i);
				
				if (mapaGradoGrupo.containsKey(inscrito.getCodigoId()+ciclo+"1")){
					aca.alumno.AlumCiclo historia = (aca.alumno.AlumCiclo) mapaGradoGrupo.get(inscrito.getCodigoId()+ciclo+"1");
					
					grado		= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, historia.getNivel(), historia.getGrado());
					grupo 		= historia.getGrupo();			 
									
				}else{
					grado = "-"; grupo = "-";
				}
				if(!gradoAndGrupo.equals(grado+grupo)){
				    cont=1;
				    gradoAndGrupo = grado+grupo;
					
					
					if(!nivelTemp.equals(inscrito.getNivelId())){
						nivelTemp = inscrito.getNivelId();
						 
					%>
					</table>
					<div class="alert alert-info">
	  				<h4><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivelId())%></h4>
	  				</div>
	<%  			} %>				
					<table class="table table-fullcondensed" width="100%">
					  	<tr><td style="font-size:11pt; "><b> <%=grado%> "<%= grupo%>"</b></td></tr>
				  	</table>
					<table class="table table-fullcondensed table-fontsmall table-striped">
						<tr>
						    <th>#</th>
						    <th>Matr&iacute;cula</th>
						    <th>Nombre</th>
						    <th>Grado</th>
						    <th>Grupo</th>
						    <th>Saldo</th>
						 </tr>
			<%	}
	
				if (mapaSaldo.containsKey(inscrito.getCodigoId())){
					String saldo =  mapaSaldo.get(inscrito.getCodigoId());
					total = Float.parseFloat(saldo);			
				%>
				<tr >
				  <td><%= cont %></td>
				  <td><%= inscrito.getCodigoId() %></td>
				  <td><%= inscrito.getApaterno()+" "+inscrito.getAmaterno()+", "+inscrito.getNombre()%></td>
				  <td><%= grado%></td>
				  <td><%= grupo%></td>
				  <td style="text-align: right;"><%=formato.format(total) %></td>
				  
				</tr>
				
				<% }
				} %>
	</table>
</div>
<script>
jQuery('#fecha').datepicker();
</script>
<%@ include file="../../cierra_elias.jsp" %>