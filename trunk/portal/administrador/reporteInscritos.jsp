<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="catNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="catEscuelaU" scope="page" class="aca.catalogo.CatEscuelaLista"/>

<%

	String codigoId = (String)session.getAttribute("codigoId");
	
	//----------------TRAER LAS ESCUELAS DE CADA ASOCIACION-------------- 
	usuario.mapeaRegId(conElias, codigoId);
	String [] asociacionesUsuario 	= usuario.getAsociacion().trim().split("-");
	
	
	String [] escuelasUsuario = usuario.getEscuela().trim().split("-");
	ArrayList<String> arrayEscuelas = new ArrayList<String>();
	java.util.Collections.addAll(arrayEscuelas, escuelasUsuario);
	
	
	ArrayList<aca.catalogo.CatEscuela> escuelas = catEscuelaU.getListAll(conElias, " ORDER BY ASOCIACION_ID ");
	
	ArrayList<String> EscuelasPorAsociacion = new ArrayList<String>();
	ArrayList<String> AsociacionesDeEscuelasPorAsociacion = new ArrayList<String>();
	
	
	for(String asoc: asociacionesUsuario){
		String schools  = "";
		for(aca.catalogo.CatEscuela escTmp: escuelas){
			String asocTmp = escTmp.getAsociacionId()==null?"*":escTmp.getAsociacionId();
			
			if(asocTmp.equals(asoc)){
				if(arrayEscuelas.contains(escTmp.getEscuelaId())){
					schools+="'"+escTmp.getEscuelaId()+"',";
				}
			}
		}
		if(!schools.equals("")){
			schools=schools.substring(0, schools.length()-1);
			EscuelasPorAsociacion.add(schools);
			AsociacionesDeEscuelasPorAsociacion.add(asoc);
		}
	}
	//---------------- END TRAER LAS ESCUELAS DE CADA ASOCIACION-------------- 
	
	//------------TRAER ESCUELAS A LAS QUE TIENE ACCESO EL USUARIO------------
	String allEscuelas = "";
	int contador=0;
	for(String str: EscuelasPorAsociacion){
		contador++;
		String coma = ",";
		if(contador==EscuelasPorAsociacion.size())coma="";
		allEscuelas+=""+str+""+coma;
	}
	//-----------END TRAER ESCUELAS A LAS QUE TIENE ACCESO EL USUARIO-----------







	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel = catNivelL.getListEscuela(conElias, (String) session.getAttribute("escuela"), "ORDER BY NIVEL_ID");
	
	
	int totGeneralAlumnos 		= 0;
	int totGeneralHombres 		= 0;
	int totGeneralMujeres 		= 0;
	int totGeneralAcfe    		= 0;
	int totGeneralNoAcfe  		= 0;
	float totGeneralHombresPor 	= 0;
	float totGeneralMujeresPor 	= 0;
	
	
	
	String fecha = request.getParameter("fecha")==null?aca.util.Fecha.getHoy():request.getParameter("fecha");
	
%>

<style>

.table td:first-child{
	text-align: left; 
}

.table td{
	text-align: right; 
}

.table tr td:first-child{
	width: 10% !important;
}
.table tr td{
	width: 10% !important;
}


</style>

<div id="content">
	<h2><fmt:message key="reportes.EstadisticaInscritos" /> </h2>
	
	<form name="forma" action="reporteInscritos.jsp" method='post'>		
		<div class="well">
			<a href="grafica.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> Regresar</a>
			
			<div style="float:right;">
				<input id="fecha" name="fecha" type="text" value="<%=fecha %>" maxlength="64" class="input-small" />
				<button class="btn btn-info"><i class="icon-refresh icon-white"></i> Actualizar</button>
			</div>
		</div>
	</form>
		
<%	for( aca.catalogo.CatNivelEscuela catNivel: lisNivel){

		ArrayList<aca.alumno.AlumPersonal> lisInscritos = AlumnoL.getListAlumnosInscritosNivelAll(conElias, fecha, allEscuelas, catNivel.getNivelId(), "ORDER BY NIVEL_ID, GRADO, GRUPO, CODIGO_ID");		
		if(!lisInscritos.isEmpty()){
			
			//Traer todos los grados y grupos de los alumnos
			ArrayList<String> gradosYgrupos = new ArrayList<String>();
			String gradoTmp = "";
			String grupoTmp = "";
			for(aca.alumno.AlumPersonal inscrito: lisInscritos){
					if(!inscrito.getGrado().equals(gradoTmp) || !inscrito.getGrupo().equals(grupoTmp)){
						gradoTmp = inscrito.getGrado();
						grupoTmp = inscrito.getGrupo();
						gradosYgrupos.add(gradoTmp+"&"+grupoTmp);
					}
			}
			//END Traer los grados y grupos de los alumnos
			
%>
			<div class="alert alert-info"><h4><%=catNivel.getNivelNombre() %></h4></div>
			
			<table class="table table-fullcondensed table-bordered">				
					<tr>
						<th><fmt:message key="aca.Grado" /> | <fmt:message key="aca.Grupo" /></th>
						<th># <fmt:message key="aca.Alumnos" /></th>
						<th># <fmt:message key="aca.Hombres" /></th>
						<th># <fmt:message key="aca.Mujeres" /></th>
						<th># ACFE</th>
						<th># No ACFE</th>
						<th>% <fmt:message key="aca.Hombres" /></th>
						<th>% <fmt:message key="aca.Mujeres" /></th>
					</tr>			
			<%
					int totAlumnos = 0;
					int totHombres = 0;
					int totMujeres = 0;
					int totAcfe    = 0;
					int totNoAcfe  = 0;
					float totHombresPor = 0;
					float totMujeresPor = 0;
			
					for(String gradoGrupo: gradosYgrupos){//RECORRER GRADOS Y GRUPOS
						String grado = gradoGrupo.split("&")[0];
						String grupo = gradoGrupo.split("&")[1];
						
						
						int alumnos    		= 0;
						int hombres    		= 0;
						int mujeres    		= 0;
						int acfe 	   		= 0;
						int noAcfe     		= 0;
						float hombresPor 	= 0;
						float mujeresPor 	= 0;
						
						for(aca.alumno.AlumPersonal inscrito: lisInscritos){//CONTAR ALUMNOS
								if(inscrito.getGrado().equals(grado) && inscrito.getGrupo().equals(grupo)){
									if(inscrito.getGenero().trim().equals("M")) hombres++; else mujeres++;
									if(inscrito.getClasfinId().trim().equals("1")) acfe++; else noAcfe++;
								}
						}
						
						alumnos = hombres+mujeres;
						
						if(hombres == 0) hombresPor = 0; else hombresPor = (float)hombres/(float)alumnos*100f;
						if(mujeres == 0) mujeresPor = 0; else mujeresPor = (float)mujeres/(float)alumnos*100f;
			%>
					<tr>
						<td><%=grado %> "<%=grupo %>"</td>
						<td><%=alumnos %></td>
						<td><%=hombres %></td>
						<td><%=mujeres %></td>
						<td><%=acfe %></td>
						<td><%=noAcfe %></td>
						<td><%=getformato.format( hombresPor ) %></td>
						<td><%=getformato.format( mujeresPor ) %></td>
					</tr>
			<%
						totAlumnos += alumnos;
						totHombres += hombres;
						totMujeres += mujeres;
						totAcfe    += acfe;
						totNoAcfe  += noAcfe;
					}
					
					if(totHombres == 0) totHombresPor = 0; else totHombresPor = (float)totHombres/(float)totAlumnos*100f;
					if(totMujeres == 0) totMujeresPor = 0; else totMujeresPor = (float)totMujeres/(float)totAlumnos*100f;
					
					totGeneralAlumnos += totAlumnos;
					totGeneralHombres += totHombres;
					totGeneralMujeres += totMujeres;
					totGeneralAcfe    += totAcfe;
					totGeneralNoAcfe  += totNoAcfe;
			%>
			
					<tr>
						<td><strong>SUBTOTAL</strong></td>
						<td><strong><%=totAlumnos %></strong></td>
						<td><strong><%=totHombres %></strong></td>
						<td><strong><%=totMujeres %></strong></td>
						<td><strong><%=totAcfe %></strong></td>
						<td><strong><%=totNoAcfe %></strong></td>
						<td><strong><%=getformato.format( totHombresPor ) %></strong></td>
						<td><strong><%=getformato.format( totMujeresPor ) %></strong></td>
					</tr>
			</table>
<%		}
	}


			if(totGeneralHombres == 0) totGeneralHombresPor = 0; else totGeneralHombresPor = (float)totGeneralHombres/(float)totGeneralAlumnos*100f;
			if(totGeneralMujeres == 0) totGeneralMujeresPor = 0; else totGeneralMujeresPor = (float)totGeneralMujeres/(float)totGeneralAlumnos*100f;
%>
		
			<table class="table table-bordered">
				<tr>
					<td><strong>TOTAL</strong></td>
					<td><strong><%=totGeneralAlumnos %></strong></td>
					<td><strong><%=totGeneralHombres %></strong></td>
					<td><strong><%=totGeneralMujeres %></strong></td>
					<td><strong><%=totGeneralAcfe %></strong></td>
					<td><strong><%=totGeneralNoAcfe %></strong></td>
					<td><strong><%=getformato.format( totGeneralHombresPor ) %></strong></td>
					<td><strong><%=getformato.format( totGeneralMujeresPor ) %></strong></td>
				</tr>
			</table>
	</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fecha').datepicker();
	jQuery('.estadisticas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>