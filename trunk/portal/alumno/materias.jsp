<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<%@ include file= "menuPortal.jsp" %>

<%@page import="java.util.TreeMap"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.vista.AlumEval"%>
<%@page import="aca.plan.PlanCurso"%>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="krdxCursoAct" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="krdxCursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>

<%	
	java.text.DecimalFormat frmDecimal		= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoId");
	String cicloIdM 			= (String) session.getAttribute("cicloId");

	ArrayList<aca.ciclo.Ciclo> lisCiclo	= cicloLista.getListCiclosAlumno(conElias, codigoId, "ORDER BY CICLO_ID");
	
	//Verifica que el ciclo este en la lista de ciclo
	boolean encontro = false;
	for(aca.ciclo.Ciclo c : lisCiclo){
		if(cicloIdM != null && c.equals(cicloIdM)){
			encontro = true; break;
		}
	}
	
	// Elige el mejor ciclo para el alumno. 
	if( encontro==false && lisCiclo.size()>0 ){
		ciclo 	= (aca.ciclo.Ciclo) lisCiclo.get(lisCiclo.size()-1);
		cicloIdM = ciclo.getCicloId();
			
		session.setAttribute("cicloId", cicloIdM);
	}
	
	if( request.getParameter("ciclo") != null ){
		cicloIdM = request.getParameter("ciclo");
		session.setAttribute("cicloId", cicloIdM);
	}

	alumPersonal.mapeaRegId(conElias, codigoId);
	alumPlan.mapeaRegActual(conElias, codigoId);
	System.out.println("ciclogrupoid " + cicloGrupo.getCicloGrupoId() + " " + cicloIdM);
	cicloGrupo.mapeaRegId(conElias,aca.kardex.KrdxCursoAct.getAlumGrupo(conElias,codigoId,cicloIdM));
	System.out.println("ciclogrupoid " + cicloGrupo.getCicloGrupoId());
	String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias,codigoId,cicloIdM);
	int nivelId 		= -1;

	if (cicloGrupo.getNivelId()!=null && cicloGrupo.getNivelId()!="" && cicloGrupo.getNivelId()!=" "){
		nivelId = Integer.parseInt(cicloGrupo.getNivelId());
	} 
	
	//TreeMap de los promedios del alumno en la materia
	TreeMap<String, aca.vista.AlumnoProm> treeProm 	= AlumPromLista.getTreeAlumno(conElias, codigoId,"");
	
%>
	
<link href="../../css/tarjeta.css" rel="STYLESHEET" type="text/css" >
<script type="text/javascript" src="../../js/tarjeta.js"></script>	

<div id="content">

	<h2><fmt:message key="portal.MateriasQueInscribiste"/> <small><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE")%></small></h2>
	
	<div class="alert alert-info">
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, alumPersonal.getNivelId()) %>
	</div>
	
	<form name="frmmaterias" action="materias.jsp">
		
		<div class="well">
			 
			 <select name="ciclo" onChange="javascritp:frmmaterias.submit()" class="input-xxlarge">
				<%for(aca.ciclo.Ciclo Ciclo : lisCiclo ){%>
					<option value="<%=Ciclo.getCicloId() %>" <%if(Ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>><%=Ciclo.getCicloNombre() %></option>
				<%}%>
			 </select>
			 
			 <div class="pull-right">
			 	<a href="horario.jsp" class="btn btn-info btn-mobile"><i class="icon-calendar icon-white"></i> <fmt:message key="aca.Horario" /></a>
			 </div>
			 
		</div>			
		
		<table class="table table-hover">   
<%

		cicloGrupo.mapeaRegId(conElias, alumPersonal.getNivelId(), alumPersonal.getGrado(), alumPersonal.getGrupo(), cicloIdM, alumPlan.getPlanId());
		ArrayList<aca.kardex.KrdxCursoAct> lisKrdx = krdxCursoActLista.getListAll(conElias, escuelaId, "AND CODIGO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID),CURSO_NOMBRE(CURSO_ID)");
 		
		for(int i = 0; i < lisKrdx.size(); i++){
			krdxCursoAct = (KrdxCursoAct) lisKrdx.get(i);
			cicloGrupoCurso.mapeaRegId(conElias, cicloGrupo.getCicloGrupoId(), krdxCursoAct.getCursoId());
			empPersonal.mapeaRegId(conElias, cicloGrupoCurso.getEmpleadoId());		
		
			// Determina el promedio del alumno en la materia
			double prom 	= 0.0;		 
			if (treeProm.containsKey(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+codigoId)){
				aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+codigoId);
				prom = Double.parseDouble(alumProm.getPromedio())+Double.parseDouble(alumProm.getPuntosAjuste());
			}else{
				System.out.println("Error en promedio:"+codigoId+":"+cicloGrupoCurso.getCursoId());
			}
			
			String notaMateria = "";
			if (cicloGrupoCurso.getEstado().equals("1")||cicloGrupoCurso.getEstado().equals("2")){
				notaMateria = frmDecimal.format(prom);
			}else{
				notaMateria = frmDecimal.format(Double.valueOf(krdxCursoAct.getNota()));
			}
			  
%>
				<tr>
					<td style="padding:20px;">
						<div style="float:left">
							<h4 style="margin-top:0;">
								<a href="modulo.jsp?cursoId=<%=cicloGrupoCurso.getCursoId() %>&cicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&ciclo=<%=cicloIdM %>">
								  	<%=PlanCurso.getCursoNombre(conElias, krdxCursoAct.getCursoId()) %>
								</a>
							</h4>
							
							<div class="tarjeta" id="<%=empPersonal.getCodigoId()%>">
								<%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%>						    
						    </div>							  			
							<div><%=alumPersonal.getGrado() %>° <%=alumPersonal.getGrupo() %> de <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, alumPersonal.getNivelId()) %></div>
								
					  	</div>
						<div style="float:right;">
						<% if(!iskinder){ %>
							<h4>
							<%if(!escuelaId.contains("H")){ %>
								  <fmt:message key="aca.Promedio"/> <a  href="detalleCalificacion.jsp?cursoId=<%=cicloGrupoCurso.getCursoId() %>&cicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&ciclo=<%=cicloIdM %>&codigoId=<%=codigoId %>&promedio=<%=notaMateria%>"><%=notaMateria%></a>
							<%}else{%>
										<a  href="detalleCalificacion.jsp?cursoId=<%=cicloGrupoCurso.getCursoId() %>&cicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&ciclo=<%=cicloIdM %>&codigoId=<%=codigoId %>&promedio=<%=notaMateria%>">Ver evaluación</a>
									<%}if (krdxCursoAct.getTipoCalId().equals("4") || krdxCursoAct.getTipoCalId().equals("5")){
										out.println("Extra:["+krdxCursoAct.getNotaExtra()+"]");
									}
									%>
							</h4>
						</div>
						<% } %>
					</td>
				</tr>
				  			
<%		
		} 
%>
      	</table>    	

	</form>
	
</div>	

<script>
	jQuery('.materias').addClass('active');
</script>

<%@ include file="../../cierra_elias.jsp" %>