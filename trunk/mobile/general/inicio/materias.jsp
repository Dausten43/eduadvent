<%@ include file="../../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="java.util.TreeMap"%>
<%@page import="aca.catalogo.CatNivel"%>
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

	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){
		session.setAttribute("codigoAlumno",request.getParameter("codigo"));	
	}
		
	
	java.text.DecimalFormat frmDecimal		= new java.text.DecimalFormat("##0.0;-##0.0");

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String cicloId			= request.getParameter("ciclo");
	String colorPortal 		= (String) session.getAttribute("colorPortal");
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo 		= cicloLista.getListCiclosAlumno(conElias, codigoId, "ORDER BY CICLO_ID");
	
	if(colorPortal==null) colorPortal="";	
	// Elige el mejor ciclo para el alumno. 
	if( cicloId == null ){
		if (lisCiclo.size()>0){
			ciclo 	= (aca.ciclo.Ciclo) lisCiclo.get(lisCiclo.size()-1);
			cicloId = ciclo.getCicloId();
		}else{
			cicloId = (String) session.getAttribute("cicloId");
		}
	}
	
	alumPersonal.mapeaRegId(conElias, codigoId);
	alumPlan.mapeaRegActual(conElias, codigoId);
	
	cicloGrupo.mapeaRegId(conElias,aca.kardex.KrdxCursoAct.getAlumGrupo(conElias,codigoId,cicloId));	
	String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias,codigoId,cicloId);	
	int nivelId 		= -1;	
	
	if (cicloGrupo.getNivelId()!=null && cicloGrupo.getNivelId()!="" && cicloGrupo.getNivelId()!=" ") 
		nivelId = Integer.parseInt(cicloGrupo.getNivelId());	
	
	//TreeMap de los promedios del alumno en la materia
	TreeMap<String,aca.vista.AlumnoProm> treeProm 	= AlumPromLista.getTreeAlumno(conElias, codigoId,"");
%>
	

<div id="content">

<div data-role="page">
	<%@ include file="../../menu.jsp"%>
	
	<div data-role="header" style="border:0;">
   		<a href="#menu" data-role="none" class="ui-btn ui-icon-bars ui-btn-icon-notext" style="background:transparent !important;"></a>
   		<h1>Materias</h1>
    </div>

	<div data-role="content">

	
		<form name="frmmaterias" action="materias.jsp" style="margin:0;">
			 <select name="ciclo" onChange="javascritp:frmmaterias.submit()">
			<%
				String cicloSeleccionado;	
				for(int i = 0; i < lisCiclo.size(); i++){
					ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
					if(ciclo.getCicloId().equals(cicloId))
						cicloSeleccionado = "Selected";
					else
						cicloSeleccionado = "";
			%>
				<option value="<%=ciclo.getCicloId() %>" <%=cicloSeleccionado %>><%=ciclo.getCicloNombre() %></option>
			<%
				}
			%>
			 </select>
		</form>
			
		<ul data-role="listview">   
	<%
		cicloGrupo.mapeaRegId(conElias, alumPersonal.getNivelId(), alumPersonal.getGrado(), alumPersonal.getGrupo(), cicloId, alumPlan.getPlanId());
		ArrayList lisKrdx = krdxCursoActLista.getListAll(conElias, escuelaId, "AND CODIGO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID),CURSO_NOMBRE(CURSO_ID)");
	 	String notaMateria = "";
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
			if (cicloGrupoCurso.getEstado().equals("1")||cicloGrupoCurso.getEstado().equals("2")){
				notaMateria = frmDecimal.format(prom);
			}else{
				notaMateria = frmDecimal.format(Double.valueOf(krdxCursoAct.getNota()));
			}
			//notaMateria = AlumEval.getAlumPromCurso(conElias, codigoId, cicloGrupo.getCicloGrupoId(), krdxCursoAct.getCursoId());		
					
			String notaExtra = "";
			if(krdxCursoAct.getNotaExtra()!=null){
				notaExtra = krdxCursoAct.getNotaExtra();
			}
	%>
					
			<li>				
				 <a href="detalleCalificacion.jsp?cursoId=<%=cicloGrupoCurso.getCursoId() %>&cicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&ciclo=<%=cicloId %>&codigoId=<%=codigoId %>&promedio=<%=notaMateria%>">
				  	<h5><%=PlanCurso.getCursoNombre(conElias, krdxCursoAct.getCursoId()) %></h5>
					
					<small>
						<%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%>						    
				    </small>
					<span class="ui-li-count">
						<b><%=notaMateria%> <%=notaExtra%></b>
                    </span>
				</a>
			</li>		
					  			
	<%		
		} %>
	
	      	</ul>    	
	</div>
	</div>
</div>	

<script>
	$('.menuPrincipal').find('a[href="materias.jsp"]').addClass('selected');
</script>

<%@ include file="../../../cierra_elias.jsp" %>