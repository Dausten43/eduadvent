<%@ include file="../../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

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

<%
	DecimalFormat frmEntero		= new DecimalFormat("##0;-##0");
	DecimalFormat frmDecimal	= new DecimalFormat("##0.0;-##0.0");
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String colorPortal 	= (String)session.getAttribute("colorPortal")==null?colorPortal="":(String)session.getAttribute("colorPortal");	
	String cicloId 		= request.getParameter("ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("ciclo");
	String codigoId 	= request.getParameter("codigoId");
	
	//String cicloGrupoId	= "011011A019";
	//String cursoId      = "01-04INFO05";
	
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String cursoId      = request.getParameter("cursoId");
	
	String notaEval		= "";
	String notaAct		= "";	
	String strBgcolor 	= "";
	
	String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias,codigoId,cicloId);
	String punto		= aca.plan.PlanCurso.getPunto(conElias, cursoId);
	
	ArrayList grupoEval	= GrupoEval.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	ArrayList grupoAct	= GrupoAct.getListGrupo(conElias, cicloGrupoId, cursoId, "ORDER BY FECHA" );
	
	TreeMap alumEval	= AlumEval.getTreeAlumMat(conElias, codigoId, cicloGrupoId, cursoId, "ORDER BY EVALUACION_ID");
	TreeMap alumAct		= AlumAct.getTreeAlumAct(conElias, cicloGrupoId, cursoId, codigoId,"ORDER BY EVALUACION_ID, ACTIVIDAD_ID");	
%>
<html>
<body>

<div data-role="page">
	
	<div data-role="header" style="border:0;">
   		<a href="materias.jsp"  data-rel="back" data-role="none" class="ui-btn ui-icon-back ui-btn-icon-notext" style="background:transparent !important;"></a>
   		<h1><%=PlanCurso.getCursoNombre(conElias, cursoId)%></h1>
    </div>
	
	<div data-role="content">
		
   		<table data-role="table" data-mode="columntoggle" class="ui-body-d ui-shadow table-stripe ui-responsive" data-column-btn-theme="b" data-column-btn-text="Ver más" data-column-popup-theme="a">
		    <thead>
	           <tr class="ui-bar-d">
	           	 <th data-priority="2"><fmt:message key="aca.Fecha"/></th>           
	             <th data-priority="1"><fmt:message key="aca.Nombre"/></th>
	             <th data-priority="2"><fmt:message key="aca.Valor"/></th>
	             <th data-priority="1"><fmt:message key="aca.Nota"/></th>
	           </tr>
	         </thead>
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
					<tr>
					  <td colspan="1"><b><%= gpoEval.getFecha() %></b></td>
				      <td><b>&nbsp;&nbsp;<%=gpoEval.getEvaluacionNombre() %></b></td>
				      <td align="center"><b><%= gpoEval.getValor() %></b>%</td>
				      <td align="center"><b><%= notaEval %></b></td>
				    </tr>
	<% 	//aca.ciclo.CicloGrupoActividad tmpgpoAct = (aca.ciclo.CicloGrupoActividad) grupoAct.get(0);
		int ponerTitulo = i;
		//if (tmpgpoAct.getEvaluacionId().equals(gpoEval.getEvaluacionId())){%>
	    <tr>
	    	<td colspan="5">
	    		<table>
			<%
					for(int j=0; j<grupoAct.size(); j++){
						aca.ciclo.CicloGrupoActividad actividad = (aca.ciclo.CicloGrupoActividad) grupoAct.get(j);				    	

						if (actividad.getEvaluacionId().equals(gpoEval.getEvaluacionId())){
							if(ponerTitulo == i){
						    	%>
					   				<tr>
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
										<input type="image" onmouseover="this.src='../../imagenes/Archivo-enviarOver.png'" onmouseout="this.src='../../imagenes/Archivo-enviar.png'" class="button"  style="vertical-align:middle" src="../../imagenes/Archivo-enviar.png" value="Continuar"  onClick="location.href='subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=tiempoTarea%>&Regresar=0'" width="30"/>
										<font size="2"><b>(<%=lista.size()%>)</b></font>
									  </td>
					<% 			}
								else{%>
									<td align="center">
										<input type="image" onmouseover="this.src='../../imagenes/Archivo-enviarOver.png'" onmouseout="this.src='../../imagenes/Archivo-enviar.png'" class="button" src="../../imagenes/Archivo-enviar.png" value="Continuar"  onClick="location.href='subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=tiempoTarea%>&Regresar=0'" width="30"/>
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
			</td>
		</tr><%
		//}
	%><%
	}
%>    
  </table>
</div>
</div>
 
</body>

<%@ include file="../../../cierra_elias.jsp" %>