<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloGrupoL" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="CursoL" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="GrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivel"/>
<jsp:useBean id="KrdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	String grado 			= (String) session.getAttribute("grado")==null?"0":(String) session.getAttribute("grado");
	String cicloGrupoId		= request.getParameter("CicloGrupoId")==null?cicloId:request.getParameter("CicloGrupoId");
		
	String nivelId 			= aca.plan.Plan.getNivel(conElias,planId);
	Nivel.mapeaRegId(conElias, nivelId);	
	
	int gradoFin			= Integer.parseInt(Nivel.getGradoFin());
	
	ArrayList<aca.ciclo.CicloGrupo> lisGrupo 	= CicloGrupoL.getListGrupos(conElias, cicloId, planId, "ORDER BY NIVEL_ID, GRADO, GRUPO");
	ArrayList<aca.plan.PlanCurso> lisCurso 		= CursoL.getListCursoActivo(conElias, planId, "ORDER BY GRADO, ORDEN");
	java.util.TreeMap<String, aca.ciclo.CicloGrupoCurso> treeGrupoCurso 	= GrupoCursoL.getTreeMateriasPlan(conElias, cicloId, planId, " ORDER BY CURSO_ID");
	java.util.TreeMap<String, String> treeAlumnos			= KrdxCursoActL.treeCantidadAlumnos(conElias, cicloId); 
	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	if(accion.equals("1")){//Cambiar grado
		session.setAttribute("grado",request.getParameter("Grado"));
		grado = request.getParameter("Grado");
	}
	
%>
<div id="content">
	<h2><%= aca.plan.Plan.getNombrePlan(conElias, planId) %></h2>
	
	<div class="alert alert-info">
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId)%> |
		<%= aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId) %>
	</div>
  	  
	<div class="well">
		<a class="btn btn-primary" href="plan.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<ul class="nav nav-tabs">
  		<li <%if(grado.equals("0")){out.print("class='active'");} %>>
  			<a href="materias.jsp?Accion=1&Grado=0"><fmt:message key="boton.Todos" /></a>
  		</li>
		<%for(int i=1; i<=gradoFin; i++){%>
	  		<li <%if(grado.equals(i+"")){out.print("class='active'");} %>>
				<a href="materias.jsp?Accion=1&Grado=<%=i%>"><%=i%>°</a>
			</li>
		<%}%>
	</ul>
	
<%
	for(aca.ciclo.CicloGrupo grupo: lisGrupo){
		if (!grado.equals("0") && !grado.equals(grupo.getGrado()) ){
			continue;
		}
				
		boolean encabezado 	= true;
%>
		
	  	<div class="alert" >		    		
	    	<%= grupo.getGrupoNombre() %>
	    	<div style="float:right;"><%= aca.empleado.EmpPersonal.getNombre(conElias,grupo.getEmpleadoId(),"NOMBRE") %></div>
	 	</div> 
<%	
		for(aca.plan.PlanCurso curso: lisCurso){
			if (curso.getGrado().equals(grupo.getGrado())){
				if (encabezado){ 
					encabezado = false;
%>
					<table class="table table-striped table-bordered">
						<thead>
							<tr>
								<th style="width:3%;">#</th>
								<th style="width:10%;"><fmt:message key="aca.Clave" /></th>
								<th style="width:25%;"><fmt:message key="aca.Materia" /></th>
								<th style="width:4%;"><fmt:message key="aca.Cred" /></th>
								<th style="width:4%;"><fmt:message key="aca.Horas" /></th>
								<th style="width:25%;"><fmt:message key="aca.Maestro" /></th>    
								<th style="width:8%;"><fmt:message key="aca.Evaluaciones" /></th>
								<th style="width:8%;"><fmt:message key="aca.Alumnos" /></th>
							</tr>
						</thead>
<%					
				}
					
				boolean existeMat 	= false; 
				String	numAlumnos 	= "0";
				String maestro 		= "";
				if (treeGrupoCurso.containsKey(grupo.getCicloGrupoId()+curso.getCursoId())){
					aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) treeGrupoCurso.get(grupo.getCicloGrupoId()+curso.getCursoId());
					existeMat 		= true;
					maestro 		= grupoCurso.getEmpleadoId();
						
					if(treeAlumnos.containsKey(grupo.getCicloGrupoId()+"@@"+curso.getCursoId())){
						numAlumnos = treeAlumnos.get(grupo.getCicloGrupoId()+"@@"+curso.getCursoId());
					}
				}else{
					maestro = "-";
				}	
				
				int numEval = aca.ciclo.CicloGrupoEval.getNumEval(conElias, grupo.getCicloGrupoId(), curso.getCursoId());
				
%>
		  			<tr>
	    				<td><%= curso.getOrden() %></td>
	    				<td><%= curso.getCursoId() %></td>
	    				<td>
	    					<a href="actamateria.jsp?CicloGrupoId=<%=grupo.getCicloGrupoId()%>&CursoId=<%=curso.getCursoId()%>">
	    						<%= curso.getCursoNombre() %>
	    					</a>
	    				</td>
	    				<td><%= curso.getCreditos() %></td>
	    				<td><%= curso.getHoras() %></td>
		    			<td>
							<%if (existeMat){%>       
						      	<%= aca.empleado.EmpPersonal.getNombre(conElias,maestro,"NOMBRE") %>
							<%}else{%>
								-
							<%}%>      
		    			</td>
		    			<td><%=numEval%></td>
						<td><%= numAlumnos %></td>
		  			</tr>			
<%				
			}
		}//Fin for lisCurso
%>
		</table>    
<%	
	}//Fin for cicloGrupo  
%>

</div>
<%@ include file= "../../cierra_elias.jsp" %>