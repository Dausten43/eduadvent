<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="fecha" scope="page" class="aca.util.Fecha"/>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>
<jsp:useBean id="ActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="archivo" scope="page" class="aca.kardex.KrdxAlumArchivo"/>
<%@page import="aca.util.Fecha"%>
<%@page import="java.util.Date"%>
<jsp:useBean id="archivoLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista"/>


<%
	String codigoId = (String) session.getAttribute("codigoAlumno");

	alumPersonal.mapeaRegId(conElias, codigoId);
	String strNivel						= alumPersonal.getNivelId();
	String strGrado						= alumPersonal.getGrado();
%>

<div id="content">

	<h2><fmt:message key="portal.Tareas"/> <small><%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %> <%=alumPersonal.getNombre() %></small></h2>
	<div class="alert alert-info">
		<strong><fmt:message key="aca.Nivel"/>:</strong> <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), strNivel)%> |
 	  	<strong><fmt:message key="aca.Grado"/>:</strong> <%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(strGrado))%> |
 	  	<strong><fmt:message key="aca.Grupo"/>:</strong> <%=alumPersonal.getGrupo()%> 
	</div>
   
    <table class="table table-condensed table-bordered">
       <tr>
         <th></th>
         <th><fmt:message key="aca.FechaEntrega"/></th>
         <th><fmt:message key="aca.Materia"/></th>
         <th><fmt:message key="aca.Actividad"/></th>
         <th><fmt:message key="portal.EnviarTarea"/></th>
         <th><fmt:message key="aca.FechaEnvio"/></th>
       </tr>
	<%  	
			String strBgcolor = "";
			ArrayList fechas = null;
			fechas = fecha.getSemanaActual();
			String fechaInicio = (String) fechas.get(0);
			int nTareas=0;
						
			for (int i=0;i<7;i++){
				ArrayList tareasEstrategias = TareaL.getTareasFecha(conElias, codigoId,(String)fechas.get(i)," ORDER BY FECHA");
				ArrayList tareas = ActividadL.getListTareas(conElias,codigoId,(String)fechas.get(i)," ORDER BY FECHA");
				
				if (tareasEstrategias.size()>0){//TAREAS DE LAS PLANEACIONES
					nTareas++;
					for(int j=0; j<tareasEstrategias.size();j++){
						aca.ciclo.CicloGrupoTarea tarea = (aca.ciclo.CicloGrupoTarea) tareasEstrategias.get(j);
%>
						<tr>
						  <td><img src="../../imagenes/planning.png" width="25px"/></td>
				          <td>
						  	<% if(i==0)
									out.print("<b>Hoy</b>"); 
								else if(i==1)
									out.print("<b>Mañana</b>"); 
								else{ 
									out.println("<b>"+fecha.getNombreDia((String)fechas.get(i))+"</b>");
									out.println("<b>"+fecha.getDia((String)fechas.get(i))+"/"+fecha.getMes((String)fechas.get(i))+"</b>");
								}
							%>
						  </td>
				          <td><%= aca.plan.PlanCurso.getCursoNombre(conElias,tarea.getCursoId())%></td>
				          <td><%=tarea.getDescripcion()%></td>
				          <td> - </td>
				          <td> - </td>
				        </tr>
<%
					}
				}
				if (tareas.size()>0){//TAREAS DEl METODO DE EVALUACION
					nTareas++;
	 				for(int j=0; j<tareas.size();j++){
						aca.ciclo.CicloGrupoActividad actividad = (aca.ciclo.CicloGrupoActividad) tareas.get(j);
						//if(j%2==1)strBgcolor = strColor; else strBgcolor = "";
						if(actividad.getMostrar().equals("S")){
					%>		
							<tr>
							  <td><img src="../../imagenes/evaluation.png" width="25px"/></td>
							  <td>
<%						if(i==0)
							out.print("<b>Hoy</b>"); 
						else if(i==1)
							out.print("<b>Mañana</b>"); 
						else{ 
							out.println("<b>"+fecha.getNombreDia((String)fechas.get(i))+"</b>");
							out.println("<b>"+fecha.getDia((String)fechas.get(i))+"/"+fecha.getMes((String)fechas.get(i))+"</b>");
						}
						//Despliega la hora
						out.println("<br>"+actividad.getFecha().substring(10,19));
						
						String cicloGrupoId		= actividad.getCicloGrupoId();
						String cursoId			= actividad.getCursoId();
						String evaluacionId		= actividad.getEvaluacionId();
						String actividadId 		= actividad.getActividadId();
							
						archivo.setCodigoId(codigoId);
						archivo.setCicloGrupoId(cicloGrupoId);
						archivo.setCursoId(cursoId);
						archivo.setEvaluacionId(evaluacionId);
						archivo.setActividadId(actividadId);
					%>
							  </td>	  
							  <td><%= aca.plan.PlanCurso.getCursoNombre(conElias,actividad.getCursoId())%></td>
							  <td><%= actividad.getActividadNombre()%></td>
					  	<% 			
					  	
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
			  				if(tiempoTarea.substring(17,19).equals("AM")&&Integer.parseInt(tiempoTarea.substring(11,13))==12) horaTar = 0;
			  				int minTar 	= Integer.parseInt(tiempoTarea.substring(14,16));
			  				
			  				int yearAct = Integer.parseInt(tiempoActual.substring(6,10));
			  				int mesAct 	= Integer.parseInt(tiempoActual.substring(3,5));
			  				int diaAct 	= Integer.parseInt(tiempoActual.substring(0,2));
			  				int horaAct = Integer.parseInt(tiempoActual.substring(11,13));
			  				if(tiempoActual.substring(17,19).equals("PM")&&Integer.parseInt(tiempoActual.substring(11,13))!=12) horaAct += 12;
			  				if(tiempoActual.substring(17,19).equals("AM")&&Integer.parseInt(tiempoActual.substring(11,13))==12) horaAct = 0;
			  				int minAct 	= Integer.parseInt(tiempoActual.substring(14,16));
			  				
			  				if(new Date(yearTar, mesTar, diaTar, horaTar, minTar).before(new Date(yearAct, mesAct, diaAct, horaAct, minAct))){
			  					if(archivo.existeArchivo(conElias)){
									archivo.mapeaRegId(conElias, codigoId);
									ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
					%>
									  <td>
										<img src="../../imagenes/Archivo-candado.png" width="25">
										<span class="badge badge-info"><%=lista.size()%></span>
									  </td>
					<% 			}
								else{%>
									<td>
										<img src="../../imagenes/Archivo-candado.png" width="25"> 
								  	</td>
							<% 	}
			  				}
			  				else{			  				
								if(archivo.existeArchivo(conElias)){
									archivo.mapeaRegId(conElias, codigoId);
									ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
					%>
									  <td>
											<span class="badge badge-info"><%=lista.size()%></span>
									  </td>
					<% 			}
								else{%>
									<td>
										
								  	</td>
							<% 	}			  					
			  				}
							if(archivo.existeArchivo(conElias)){
								archivo.mapeaRegId(conElias, codigoId);
								ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
								String [] arrFecha = lista.get(lista.size()-1).getFecha().split(" ");
					%>
							  	<td><%=arrFecha[0]%><br><%=arrFecha[1]+" "+arrFecha[2]%></td>
					<% 
							}else{%>
								<td>&nbsp;</td>
						<%	
							}
					}
	 				}
				}
				
			}
			
			if(nTareas==0)out.print("<tr><td colspan='10'>No hay tareas registradas para la semana</td></tr>");
			%>
			
	   </table>    
	      
</div>

<script>
	jQuery('.tareas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>