<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>


<%@page import="java.text.*" %>
<%@page import="java.util.TreeMap"%>
<%@page import="aca.util.Fecha"%>
<%@page import="java.util.Date"%>
<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.vista.AlumEval"%>
<%@page import="aca.plan.PlanCurso"%>

<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="GrupoAct" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="AlumEval" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="AlumAct" scope="page" class="aca.kardex.KrdxAlumActivLista"/>
<jsp:useBean id="archivo" scope="page" class="aca.kardex.KrdxAlumArchivo"/>
<jsp:useBean id="archivoLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista"/>
<jsp:useBean id="promedioL" scope="page" class="aca.ciclo.CicloPromedioLista" />
<%
	DecimalFormat frmEntero		= new DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	DecimalFormat frmDecimal	= new DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String colorPortal 	= (String)session.getAttribute("colorPortal")==null?colorPortal="":(String)session.getAttribute("colorPortal");	
	String cicloIdM 	= request.getParameter("ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("ciclo");
	String codigoId 	= request.getParameter("codigoId");
	
	//String cicloGrupoId	= "011011A019";
	//String cursoId      = "01-04INFO05";
	
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String cursoId      = request.getParameter("cursoId");
	
	String notaEval		= "";
	String notaAct		= "";	
	String strBgcolor 	= "";
	
	String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias,codigoId,cicloIdM);
	String punto		= aca.plan.PlanCurso.getPunto(conElias, cursoId);
	
	ArrayList<aca.ciclo.CicloGrupoEval> grupoEval	= new ArrayList();	
	ArrayList<aca.ciclo.CicloPromedio> listPromedio 		= promedioL.getListPromedioCiclo(conElias, cicloId," ORDER BY ORDEN");
	ArrayList grupoAct	= GrupoAct.getListGrupo(conElias, cicloGrupoId, cursoId, "ORDER BY FECHA" );
	
	TreeMap alumEval	= AlumEval.getTreeAlumMat(conElias, codigoId, cicloGrupoId, cursoId, "ORDER BY EVALUACION_ID");
	TreeMap alumAct		= AlumAct.getTreeAlumAct(conElias, cicloGrupoId, cursoId, codigoId,"ORDER BY EVALUACION_ID, ACTIVIDAD_ID");	
%>
<html>
<body>

<div id="content">

	<h2><%= PlanCurso.getCursoNombre(conElias, cursoId) %> <small><fmt:message key="aca.Promedio"/> <%=request.getParameter("promedio") %></small></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="materias.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>
<% 
	for(aca.ciclo.CicloPromedio promedios : listPromedio){ 
%>

	<div class="alert alert-success"><h4>N1. <%=promedios.getNombre() %> (Valor: <%=promedios.getValor() %>)<h4></div>
<% 
	grupoEval	= GrupoEval.getArrayListPorPromedio(conElias, cicloGrupoId, cursoId, promedios.getPromedioId(), "ORDER BY ORDEN");	
%>	
   
	    
<%
		for(int i=0; i<grupoEval.size();i++){
			aca.ciclo.CicloGrupoEval gpoEval = (aca.ciclo.CicloGrupoEval)  grupoEval.get(i);
			
			notaEval = "0";
			if (alumEval.containsKey(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId())){
				aca.kardex.KrdxAlumEval kae = (aca.kardex.KrdxAlumEval) alumEval.get(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId());
				
				// Si se evalua con punto decimal
				if (punto.equals("S")){
					notaEval = frmDecimal.format(Double.valueOf(kae.getNota()));
				}else{
					notaEval = frmEntero.format(Double.valueOf(kae.getNota()));
				}			
			}
			
%>  
	    <div class="alert alert-info">
	    	<h5> N2. 
	    		<%=gpoEval.getEvaluacionNombre() %>
	    		<span class="pull-right">
					<fmt:message key="aca.Valor" />: <%= gpoEval.getValor() %>% &nbsp; &nbsp;
					( <span style="font-size:12px;"><fmt:message key="aca.Promedio" />: <%= notaEval %></span> )
				</span>
				<small>( <%= gpoEval.getFecha() %> )</small>
	    		
	    	</h5>
	    </div>
	    
		<% 	//aca.ciclo.CicloGrupoActividad tmpgpoAct = (aca.ciclo.CicloGrupoActividad) grupoAct.get(0);
			int ponerTitulo = i;
			//if (tmpgpoAct.getEvaluacionId().equals(gpoEval.getEvaluacionId())){%>
		   
		    		<table class="table table-condensed table-bordered" >
				<%
						for(int j=0; j<grupoAct.size(); j++){
							aca.ciclo.CicloGrupoActividad actividad = (aca.ciclo.CicloGrupoActividad) grupoAct.get(j);				    	
	
							if (actividad.getEvaluacionId().equals(gpoEval.getEvaluacionId())){
								if(ponerTitulo == i){
							    	%>
						   				<tr style="background-color: #FFF1CF">
								          <th height="15"><fmt:message key="aca.FechaEntrega"/></th>
								          <th><fmt:message key="aca.Actividad"/></th>
								          <th><fmt:message key="portal.EnviarTarea"/></th>
								          <th><fmt:message key="aca.FechaEnvio"/></th>
								          <th><fmt:message key="aca.Valor"/></th>
								          <th><fmt:message key="aca.Nota"/></th>
								        </tr>				    	
					    	<%	}
						    	
						    	notaAct = "0";
								if (alumAct.containsKey(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId()+actividad.getActividadId())){
									aca.kardex.KrdxAlumActiv kaa = (aca.kardex.KrdxAlumActiv) alumAct.get(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId()+actividad.getActividadId());
									notaAct = kaa.getNota();
								}
				%>
								<tr <%=strBgcolor%>>
							      <td align="center"><%=actividad.getFecha().substring(0,10)%><br><%=actividad.getFecha().substring(12,19)%></td>
							      <td>&nbsp;&nbsp;<%=actividad.getActividadNombre() %></td><%
							      
						      	String evaluacionId		= actividad.getEvaluacionId();
								String actividadId 		= actividad.getActividadId();
									
								archivo.setCodigoId(codigoId);
								archivo.setCicloGrupoId(cicloGrupoId);
								archivo.setCursoId(cursoId);
								archivo.setEvaluacionId(evaluacionId);
								archivo.setActividadId(actividadId);
							      
								//Comparar Fechas						
								String horaActual 	= Fecha.getHora().length()==1 ? "0"+Fecha.getHora() : Fecha.getHora();
								String minActual 	= Fecha.getMinutos().length()==1 ? "0"+Fecha.getMinutos() : Fecha.getMinutos();
								String tiempoActual = Fecha.getHoy()+" "+horaActual+":"+minActual+" "+(Fecha.getAMPM()==0 ? "AM" : "PM");
								
				  				String tiempoTarea = actividad.getFecha();
				  	
				  				int yearTar = Integer.parseInt(tiempoTarea.substring(6,10));
				  				int mesTar 	= Integer.parseInt(tiempoTarea.substring(3,5));
				  				int diaTar 	= Integer.parseInt(tiempoTarea.substring(0,2));
				  				int horaTar = Integer.parseInt(tiempoTarea.substring(11,13));
				  				if(tiempoTarea.substring(17,19).equals("PM")&&Integer.parseInt(tiempoTarea.substring(11,13))!=12) horaTar += 12;	
				  				int minTar 	= Integer.parseInt(tiempoTarea.substring(14,16));
				  				
				  				int yearAct = Integer.parseInt(tiempoActual.substring(6,10));
				  				int mesAct 	= Integer.parseInt(tiempoActual.substring(3,5));
				  				int diaAct 	= Integer.parseInt(tiempoActual.substring(0,2));
				  				int horaAct = Integer.parseInt(tiempoActual.substring(11,13));
				  				if(tiempoActual.substring(17,19).equals("PM")&&Integer.parseInt(tiempoActual.substring(11,13))!=12) horaAct += 12;
				  				int minAct 	= Integer.parseInt(tiempoActual.substring(14,16));
				  				
				  				if(new Date(yearTar, mesTar, diaTar, horaTar, minTar).before(new Date(yearAct, mesAct, diaAct, horaAct, minAct))){
				  					if(archivo.existeArchivo(conElias)){
										archivo.mapeaRegId(conElias, codigoId);
										ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
						%>
										  <td align="center">
											<img SRC="../../imagenes/Archivo-candado.png" width="25" >
											<font size="2"><b>(<%=lista.size()%>)</b></font>
										  </td>
						<% 			}
									else{%>
										<td align="center">
											<img SRC="../../imagenes/Archivo-candado.png" width="25" > 
									  		&nbsp;&nbsp;&nbsp;&nbsp;
									  	</td>
								<% 	}
				  				}
				  				else{
									if(archivo.existeArchivo(conElias)){
										archivo.mapeaRegId(conElias, codigoId);
										ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
						%>
										  <td align="center">
											<input type="image" onmouseover="this.src='../../imagenes/Archivo-enviarOver.png'" onmouseout="this.src='../../imagenes/Archivo-enviar.png'" class="button"  style="vertical-align:middle; max-height:35px" src="../../imagenes/Archivo-enviar.png" value="Continuar"  onClick="location.href='subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=tiempoTarea%>&Regresar=0'" width="30"/>
											<font size="2"><b>(<%=lista.size()%>)</b></font>
										  </td>
						<% 			}
									else{%>
										<td align="center">
											<input type="image" onmouseover="this.src='../../imagenes/Archivo-enviarOver.png'" onmouseout="this.src='../../imagenes/Archivo-enviar.png'" class="button" style="vertical-align:middle; max-height:35px"  src="../../imagenes/Archivo-enviar.png" value="Continuar"  onClick="location.href='subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=tiempoTarea%>&Regresar=0'" width="30"/>
									  		&nbsp;&nbsp;&nbsp;&nbsp;
									  	</td>
								<% 	}			  					
				  				}
								if(archivo.existeArchivo(conElias)){
									archivo.mapeaRegId(conElias, codigoId);
									ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
									String [] arrFecha = lista.get(lista.size()-1).getFecha().split(" ");
						%>
								  	<td align="center"><%=arrFecha[0]%><br><%=arrFecha[1]+" "+arrFecha[2]%></td>
						<% 
								}
								else{%>
									<td>&nbsp;</td>
							<%	}%>
							      <td align="center"><%= actividad.getValor()%>%</td>
							      <td align="center"><%= notaAct %></td>
							    </tr><%
						    	ponerTitulo++;
							}
						}
				%>
					</table>
				<%
			//}
		%><%
	}
} %>
  
  
  
 </div>
 
</body>

<script>
	jQuery('.materias').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>