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
<jsp:useBean id="finMovimiento" scope="page" class="aca.fin.FinMovimiento"/>
<jsp:useBean id="finMovimientoL" scope="page" class="aca.fin.FinMovimientoLista"/>

<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ciclo			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");
	
	String strBgcolor		= "";
	String nivelTemp        = "0";
	String grado = "", grupo = "";
	int cont				= 1;
	int contMov		=0;
	
	// Lista de ciclos activos en la escuela
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList lisInscritos = AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");	
	
	HashMap<String, aca.alumno.AlumCiclo > mapaGradoGrupo =   aca.alumno.AlumCicloLista.getMapHistoria(conElias, "");
%>
<style>
	body{
		background: white;
	}
</style>
<body>
<div id="content">	
  <h2>Reporte de Alumnos Inscritos</h2>
  <form name="forma" action="reporte.jsp" method='post'>
  <div class="well">
  	<select id="ciclo" name="ciclo" onchange="document.forma.submit();">
<%
	for(int i = 0; i < lisCiclo.size(); i++){
		Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
		<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
<%	}%>
	</select>
  </div>
  </form>
<table class="table table-fullcondensed" width="80%">
<%	 	
		String gradoAndGrupo = "0";
		java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00");
		float total = 0f;
		for(int i=0; i<lisInscritos.size();i++){
			cont++;			
			aca.alumno.AlumPersonal inscrito = (aca.alumno.AlumPersonal) lisInscritos.get(i);
			ArrayList lisMovimientos = finMovimientoL.getListAlumno(conElias, inscrito.getCodigoId(), "ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD'), FOLIO");
			for(int j = 0; j < lisMovimientos.size(); j++){
				finMovimiento = (FinMovimiento) lisMovimientos.get(j);
				
				if((finMovimiento.getImporte()==null)&&(finMovimiento.getNaturaleza()==null)){
					finMovimiento.setImporte("0");
					finMovimiento.setNaturaleza("");					
				}
				
				if(finMovimiento.getNaturaleza().equals("D")){
					total -= Float.parseFloat(finMovimiento.getImporte());
				}else{
					total += Float.parseFloat(finMovimiento.getImporte());
				}	
			}
			
			if (mapaGradoGrupo.containsKey(inscrito.getCodigoId()+ciclo+"1")){
				aca.alumno.AlumCiclo historia = (aca.alumno.AlumCiclo) mapaGradoGrupo.get(inscrito.getCodigoId()+ciclo+"1");
				grado 		= historia.getGrado();			
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
  				<h4><%= aca.catalogo.CatNivel.getNivelNombre(conElias,Integer.parseInt(inscrito.getNivelId()))%></h4>
  				</div>
<%  			} %>				
				<table class="table table-fullcondensed" width="100%">
				  	<tr><td style="font-size:11pt; "><b>Grado y Grupo: <%=grado%>° "<%= grupo%>"</b></td></tr>
			  	</table>
				<table width="100%" class="table table-fullcondensed table-fontsmall table-striped">
					<tr>
					    <th>#</th>
					    <th>Matr&iacute;cula</th>
					    <th>Nombre</th>
					    <th>Grado</th>
					    <th>Grupo</th>
					    <th>Saldo</th>
					 </tr>
		<%	} %>
			<tr >
			  <td align="center"><%= cont %></td>
			  <td align="center"><%= inscrito.getCodigoId() %></td>
			  <td align="left"><%= inscrito.getApaterno()+" "+inscrito.getAmaterno()+", "+inscrito.getNombre()%></td>
			  <td align="center"><%= grado%></td>
			  <td align="center"><%= grupo%></td>
			  <td align="right"><%=formato.format(total) %></td>
			  
			</tr>
			
			<% 
				boolean credito = false;
				 for(int j = (lisMovimientos.size()-1); j>=0; j--){
					 finMovimiento = (FinMovimiento) lisMovimientos.get(j);
						if((finMovimiento.getImporte()==null)&&(finMovimiento.getNaturaleza()==null)){
						finMovimiento.setImporte("0");
						finMovimiento.setNaturaleza("");	
						}
						if(finMovimiento.getNaturaleza().equals("D")){
							continue;
						}else{
							credito=true;
							break;
						}	
				 }
				 if(credito==true){ 
			%>
			<tr>
			<td></td>
			<td colspan="5">
			<table class="table" width="100%">
			<tr>		
					    <th>#</th>
						<th>Fecha</th>
						<th>Descripción</th>
						<th>Referencia</th>						
						<th>Crédito</th>
			 </tr>
			 <%
			 
			 for(int j = (lisMovimientos.size()-1); j>=0; j--){
					finMovimiento = (FinMovimiento) lisMovimientos.get(j);
					if((finMovimiento.getImporte()==null)&&(finMovimiento.getNaturaleza()==null)){
					finMovimiento.setImporte("0");
					finMovimiento.setNaturaleza("");	
					}
					if(finMovimiento.getNaturaleza().equals("D")){
						continue;
					}else{
						contMov++;
					}	
					/*if(contMov>=4){
						break;
					}*/
				%>
				<tr>
					<td><%=contMov %></td>
					<td><%=finMovimiento.getFecha() %></td>
					<td><%=finMovimiento.getDescripcion() %></td>
					<td><%=finMovimiento.getReferencia() %></td>						
					<td align="right"><%=finMovimiento.getNaturaleza().equals("C")?formato.format(Float.parseFloat(finMovimiento.getImporte())):"" %></td>
				</tr>
		
<% 			}contMov=0;%>

</td>
</tr>
	</table><%
			 
			}
	 total = 0;
	 } %>
</table>
</body>
<%@ include file="../../cierra_elias.jsp" %>