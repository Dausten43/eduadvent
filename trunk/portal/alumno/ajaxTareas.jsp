
<%@page import="java.util.Locale"%>
<%@page import="java.util.Date"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="aca.ciclo.CicloGrupoTarea"%>
<%@page import="aca.ciclo.CicloGrupo"%>
<%@page import="java.util.List"%>

<%@ include file="../../con_elias.jsp"%>
<%@page import="aca.util.Fecha"%>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>
<jsp:useBean id="ActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="archivoLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista"/>
<jsp:useBean id="archivo" scope="page" class="aca.kardex.KrdxAlumArchivo"/>


<jsp:useBean id="fecha" scope="page" class="aca.util.Fecha"/>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	String lenguajeValue =  (String) session.getAttribute("lenguaje")==null?"es": (String) session.getAttribute("lenguaje");
%>

<%if(lenguajeValue.equals("es")){%>
	<fmt:setLocale value="es" scope="session"/>
<%}else if(lenguajeValue.equals("en")){%>
	<fmt:setLocale value="en" scope="session"/>
<%}else{%>
	<fmt:setLocale value="es" scope="session"/>
<%} %>
	
<fmt:setBundle basename="aca.idioma.messages"/>
<%

List<CicloGrupoTarea> lsTareasPlan = new ArrayList();
List<CicloGrupoActividad> lsTareasAct = new ArrayList();

String codigoId 			= (String) session.getAttribute("codigoAlumno");
String cicloIdM 			= (String) session.getAttribute("cicloId");

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
SimpleDateFormat sdfb = new SimpleDateFormat("EEEEE", new Locale("es_MX"));
SimpleDateFormat sdfc = new SimpleDateFormat("dd MMMMM", new Locale("es_MX"));

if(request.getParameter("semana")!=null){
	System.out.println("entrando a cargar tareas " + cicloIdM);
	lsTareasPlan.addAll(TareaL.getTareasFecha(conElias, codigoId, request.getParameter("semana"), "ORDER BY fecha desc", cicloIdM, 0));
	lsTareasAct.addAll(ActividadL.getListTareas(conElias, codigoId, request.getParameter("semana"), "ORDER BY fecha desc", cicloIdM));
}

System.out.println(lsTareasPlan.size() +" " + lsTareasAct.size() +" " + cicloIdM) ;
%>

 <table class="table table-condensed table-bordered">
       <tr>
         <th></th>
         <th><fmt:message key="aca.FechaEntrega"/></th>
         <th><fmt:message key="aca.Materia"/></th>
         <th><fmt:message key="aca.Titulo"/></th>
         <th><fmt:message key="aca.Descripcion"/></th>
         <th><fmt:message key="portal.EnviarTarea"/></th>
         <th><fmt:message key="aca.FechaEnvio"/></th>
       </tr>
       <% 
       	for(CicloGrupoTarea tarea : lsTareasPlan){
       %>
       <tr>
						  <td><img src="../../imagenes/planning.png" width="25px"/></td>
				          <td>
						  	<% 
									out.println("<b style=\"text-transform: capitalize;\">"+ sdfb.format(sdf.parse(tarea.getFecha())) +"</b>");
									out.println("<b style=\"text-transform: capitalize;\">"+ sdfc.format(sdf.parse(tarea.getFecha())) +"</b>");
								
							%>
						  </td>
				          <td><%= aca.plan.PlanCurso.getCursoNombre(conElias,tarea.getCursoId())%></td>
				          <td><%=tarea.getTareaNombre() %></td>
				          <td><%=tarea.getDescripcion()%></td>
				          <td> - </td>
				          <td> - </td>
				        </tr>
       <% } 
       for(CicloGrupoActividad actividad : lsTareasAct){
    	   if(actividad.getMostrar().equals("S")){
    	   %>		
			<tr>
			  <td><img src="../../imagenes/evaluation.png" width="25px"/></td>
			  <td>
<%						
			out.println("<b style=\"text-transform: capitalize;\">"+ sdfb.format(sdf.parse(actividad.getFecha())) +"</b>");
			out.println("<b style=\"text-transform: capitalize;\">"+ sdfc.format(sdf.parse(actividad.getFecha())) +"</b>");
		
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
			  <td><fmt:message key="aca.Actividad"/></td>
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
	<% 			}else{%>
					<td>
						<img src="../../imagenes/Archivo-candado.png" width="25"> 
				  	</td>
			<% 	}
				}else{			  				
				if(archivo.existeArchivo(conElias)){
					archivo.mapeaRegId(conElias, codigoId);
					ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
	%>
					  <td><% if(request.getParameter("aview")!=null){ %>
							<a class="btn btn-primary"
							   href="subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=tiempoTarea%>&Regresar=1">
								<i class="icon-arrow-up icon-white"></i> <fmt:message key="boton.Enviar"/>
							</a>
							<% } %>
							
							<span class="badge badge-info"><%=lista.size()%></span>
					  </td>
	<% 			}else{%>
					<td><% if(request.getParameter("aview")!=null){ %>
						<a class="btn btn-primary"
						   href="subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=tiempoTarea%>&Regresar=1">
							<i class="icon-arrow-up icon-white"></i> <fmt:message key="boton.Enviar"/>
						</a>	
				  		<% } %>
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
       
       
       		if(lsTareasPlan.size()==0 && lsTareasAct.size()==0){
       %>
       <td colspan="6">NO HAY TAREAS PARA ESTE PERIODO</td>
       <% } %>
       </table>
<%@ include file="../../cierra_elias.jsp"%>