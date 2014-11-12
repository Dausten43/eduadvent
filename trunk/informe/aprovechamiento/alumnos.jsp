<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista" />
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>


<script>
	function cambiaCiclo() {
		document.frmCiclo.Accion.value = "1";
		document.frmCiclo.submit();
	}
	
	function cambiaBloque(){
		document.frmCiclo.submit();
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");
	String cicloId 		= (String) session.getAttribute("cicloId");

	if (cicloId == "XXXXXXX"){
		cicloId = aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	}
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID");

	String accion = request.getParameter("Accion") == null ? "" : request.getParameter("Accion");
	if(accion.equals("1")){
		cicloId = request.getParameter("Ciclo");
		session.setAttribute("cicloId", cicloId);
	}
	
	//LISTA PARA EL COMBO DE BLOQUES
	String bloqueId			= request.getParameter("Bloque");
	ArrayList<aca.ciclo.CicloBloque> lisCicloBloque = CicloBloqueL.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	if(bloqueId == null||bloqueId.equals("")){
		bloqueId = "0";
	}
	

	
	
	
	ArrayList<aca.ciclo.CicloGrupo> lisCicloGrupo = cicloGrupoLista.getListGrupos( conElias, cicloId, " ORDER BY NIVEL_ID, GRADO, GRUPO");
	
	java.util.HashMap<String, String> mapAlumnos  		  = aca.kardex.KrdxCursoActLista.mapAlumnosCicloGrupoId(conElias, cicloId);
	java.util.HashMap<String, String> mapReprobones		  = new java.util.HashMap<String, String>();
	
	if( bloqueId.equals("0") ){
		mapReprobones		  = aca.kardex.KrdxCursoActLista.mapAlumnosReprobonesCicloGrupoId(conElias, cicloId);
	}else{
		mapReprobones 		  = aca.kardex.KrdxAlumEvalLista.mapAlumnosReprobonesCicloGrupoId(conElias, cicloId, "1");	
	}
	
%>

<div id="content">
	<h2><fmt:message key="aca.Grados" /></h2>
			
	<form name="frmCiclo" action="alumnos.jsp" method="post">
		<input type="hidden" name="Accion">
		
		<div class="well">
			
			<select name="Ciclo" id="Ciclo" onchange="javascript:cambiaCiclo()" class="input-xxlarge">
			<%for (aca.ciclo.Ciclo ciclo : lisCiclo) {%>
				<option value="<%=ciclo.getCicloId() %>" <%if (ciclo.getCicloId().equals(cicloId)) {%>selected<%} %>><%=ciclo.getCicloNombre() %></option>
			<%}%>
			</select>
			
			<select id="Bloque" name="Bloque" onchange="cambiaBloque();" >
				<option value="0" <%= bloqueId.equals("0")?" Selected":"" %>><fmt:message key="boton.Todos" /></option>
			<%for(aca.ciclo.CicloBloque bloque :  lisCicloBloque){%>
				<option value="<%= bloque.getBloqueId()%>"<%= bloque.getBloqueId().equals(bloqueId)?" Selected":"" %>><%=bloque.getBloqueNombre()%></option>
			<%}%>
			</select>
			
		</div>
	</form>
		
		
		<%
			String strNivel = "-1";
			int row = 0;
			for (aca.ciclo.CicloGrupo grupo : lisCicloGrupo) {
				row++;
				
				if (!grupo.getNivelId().equals(strNivel)) {
					strNivel = grupo.getNivelId();
					row = 1;
					
		%>		
					</table>
					
					<div class="alert alert-info"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), strNivel)%></div>
					
					<table class="table table-condensed table-striped table-bordered">
						<thead>
							<tr>
								<th width="5%">#</th>
								<th width="10%"><fmt:message key="aca.Grado" /></th>
								<th width="5%"><fmt:message key="aca.Grupo" /></th>
								<th width="50%"><fmt:message key="aca.Maestro" /></th>
								<th width="20%"><fmt:message key="aca.Plan" /></th>
								<th><fmt:message key="aca.Alumnos" /></th>
								<th><fmt:message key="aca.Aprobados" /></th>
								<th><fmt:message key="aca.Reprobados" /></th>
							</tr>
						</thead>

		<%
				} //if de cambia nivel
		%>
		<%
			String alumnos = "0";
			if( mapAlumnos.containsKey(grupo.getCicloGrupoId()) ){
				alumnos = mapAlumnos.get(grupo.getCicloGrupoId());
			}
			
			String reprobones = "0";
			if( mapReprobones.containsKey(grupo.getCicloGrupoId()) ){
				reprobones = mapReprobones.get(grupo.getCicloGrupoId());
			}
			
			int numAlumnos 		= Integer.parseInt(alumnos);
			int numReprobones   = Integer.parseInt(reprobones);
			int numAprobados    = numAlumnos - numReprobones;
		%>
		
			<tr>
				<td><%=row%></td>
				<td><%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))%></td>
				<td>"<%=grupo.getGrupo()%>"</td>
				<td><%=grupo.getEmpleadoId()%> | <%=aca.empleado.EmpPersonal.getNombre(conElias,grupo.getEmpleadoId(), "NOMBRE")%></td>
				<td><%=grupo.getPlanId()%> | <%=aca.plan.Plan.getNombrePlan(conElias, grupo.getPlanId())%></td>
				<td><%=numAlumnos%></td>
				<td><%=numAprobados %></td>
				<td><%=numReprobones %></td>
			</tr>
		<%
			} //fin de for
		%>
	
	</table>
</div>

<%@ include file="../../cierra_elias.jsp"%>
