<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.TreeMap"%>

<jsp:useBean id="CatGrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	String salto			= "X";
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	int numAccion 			= Integer.parseInt(accion);
	
	String nivelId 			= aca.plan.Plan.getNivel(conElias,planId);
	String titulo 			= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivelId).toUpperCase();
	String nombreGrado		= "";
	String cicloGrupoId		= "";
	String resultado 		= "";
	
	switch (numAccion){
		case 1: { 
			CicloGrupo.setCicloId(cicloId);
			CicloGrupo.setCicloGrupoId(cicloId+ aca.ciclo.CicloGrupo.getSecuencial(conElias, cicloId) );
			CicloGrupo.setPlanId(planId);
			CicloGrupo.setNivelId(nivelId);
			CicloGrupo.setGrado(request.getParameter("Grado"));
			CicloGrupo.setGrupo(request.getParameter("Grupo"));
			CicloGrupo.setGrupoNombre(request.getParameter("NombreGrado"));
			CicloGrupo.setHorarioId("0");
			CicloGrupo.setSalonId("0");
			CicloGrupo.setEmpleadoId("Agregar");
			
			if(!CicloGrupo.existeGradoGrupo(conElias)){
				if (CicloGrupo.existeReg(conElias)==false){
					if (CicloGrupo.insertReg(conElias)){
						resultado = "¡ Grabado !";
					}else{
						resultado = "¡ Error al Grabar !";	
					}					
				}			
			}else{
				System.out.println("ya existe: "+cicloId+"+"+CicloGrupo.getGrado()+"+"+CicloGrupo.getGrupo());
				salto = "grupo.jsp";
			}
			break;
		}
		case 2: { 
			conElias.setAutoCommit(false);
			CicloGrupo.setCicloGrupoId(request.getParameter("CicloGrupoId"));			
			if (CicloGrupo.existeReg(conElias)){				
				if (CicloGrupo.deleteReg(conElias)){
					resultado = "¡ Borrado !";
					conElias.commit();
				}else{
					resultado = "¡ Error al Borrar !";
				}
			}
			conElias.setAutoCommit(false);
			break;
		}
	}
	
	ArrayList<aca.catalogo.CatGrupo> lisGrupo 		= CatGrupoL.getListGrupos(conElias, cicloId, planId, escuelaId, nivelId, "ORDER BY NIVEL_ID, GRADO, GRUPO");	
	ArrayList<aca.catalogo.CatGrupo> lisGrupoAlta	= CatGrupoL.getListGruposAlta(conElias, cicloId, planId, escuelaId, nivelId, "ORDER BY NIVEL_ID, GRADO, GRUPO");		
%>

<div id="content">
	<h2><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId)%>
  	  <small><%= aca.plan.Plan.getNombrePlan(conElias, planId)%></small></h2>

 	<div class="alert alert-info">
  	  	<%= aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId) %>
  	</div>
  	
  	<div class="well" style="overflow:hidden;">
		<a href="materia.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<form name="frmGrupo" action="materia.jsp" method="post">
		<input type="hidden" name="Accion" />

		<div class="row">
		
			<div class="span5">
				<div class="alert">
					<h4><fmt:message key="aca.GruposDisponibles" /></h4>
				</div>
				
				<table class="table table-striped table-bordered">
					<thead>
						<tr>
				  			<th><fmt:message key="aca.Grado" /></th>
				  			<th><fmt:message key="aca.Grupo" /></th>
				  			<th><fmt:message key="aca.NombreGrupo" /></th>
						</tr>
					</thead>
				<%	
					for(aca.catalogo.CatGrupo grupo: lisGrupo){
						nombreGrado = aca.catalogo.CatEsquema.getNombreGrado(conElias, escuelaId, nivelId, grupo.getGrado());
						if (nombreGrado.equals("X")) nombreGrado = aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))+ " "+titulo.toUpperCase()+" "+grupo.getGrupo();
				%>  
				  	  	<tr>
				    		<td><%= grupo.getGrado() %></td>
				    		<td><%= grupo.getGrupo() %></td>
				    		<td>
				      	  		<a href="grupo.jsp?Accion=1&Grado=<%=grupo.getGrado()%>&Grupo=<%=grupo.getGrupo()%>&NombreGrado=<%=nombreGrado%>"><%=nombreGrado%></a>
				    		</td>
				  	  	</tr>
				<%
					}
				%>
				</table>
			</div>
			
			<div class="span5">
				<div class="alert">	
					<h4><fmt:message key="aca.GruposActivos" /></h4>
				</div>
				
				<table class="table table-striped table-bordered">
					<tr>
				  		<th><fmt:message key="aca.Grado" /></th>
				  		<th><fmt:message key="aca.Grupo" /></th>
				  		<th><fmt:message key="aca.NombreGrupo" /></th>
				  		<th># <fmt:message key="aca.Cursos" /></th>
				  		<th># <fmt:message key="aca.Alumnos" /></th>
					</tr>
				<%	
					int numCursos=0; int numAlumnos = 0; boolean notas = false;
					for(int i = 0; i < lisGrupoAlta.size(); i++){
						aca.catalogo.CatGrupo grupo = (aca.catalogo.CatGrupo) lisGrupoAlta.get(i);
						nombreGrado = aca.catalogo.CatEsquema.getNombreGrado(conElias, escuelaId, nivelId, grupo.getGrado());
						if (nombreGrado.equals("X")) {
							nombreGrado = aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))+ " "+titulo.toUpperCase()+" "+grupo.getGrupo();
						}else {
							nombreGrado = nombreGrado + " " +grupo.getGrupo();
						}				
						cicloGrupoId 	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, nivelId, grupo.getGrado(), grupo.getGrupo(), cicloId, planId);
						numCursos 		= aca.ciclo.CicloGrupoCurso.numCursosGrupo(conElias, cicloGrupoId);
						numAlumnos 		= aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoId);
				%>  
				  	  	<tr>
				    		<td><%= grupo.getGrado() %></td>
				    		<td><%= grupo.getGrupo() %></td>
				    		<td>
							<%if (numCursos==0 && numAlumnos==0){%>    	
				      	  		<a href="grupo.jsp?Accion=2&CicloGrupoId=<%=cicloGrupoId%>"><%=nombreGrado%></a>
							<%}else{%>
								<%=nombreGrado %>
							<%}%>	
				    	</td>
				    	<td><%=numCursos%></td>
				    	<td><%=numAlumnos%></td>
				  	  </tr>
				<%	}%>
				</table>
			</div>
		
		</div>
	</form>
	
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>