<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista" />


<script>
	function cambiaCiclo() {
		document.frmCiclo.action = "grupo.jsp";
		console.log(document.frmCiclo.Accion);
		document.frmCiclo.Accion.value = "1";
		document.frmCiclo.submit();
	}

	function grupo(cicloGrupoId) {
		document.location.href = "alumnos.jsp?CicloGrupoId=" + cicloGrupoId;
	}
	function grupal(cicloGrupoId) {
		document.location.href = "bimestre.jsp?CicloGrupoId=" + cicloGrupoId;
	}
	function materias(cicloGrupoId) {
		document.location.href = "materias.jsp?CicloGrupoId=" + cicloGrupoId;
	}
	
	function promedioGrupo(cicloGrupoId) {
		document.location.href = "promedioGrupo.jsp?CicloGrupoId=" + cicloGrupoId;
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");
	String cicloId 		= (String) session.getAttribute("cicloId");

	if (cicloId == "XXXXXXX"){
		cicloId = aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	}
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");

	String accion = request.getParameter("Accion") == null ? "" : request.getParameter("Accion");
	if(accion.equals("1")){
		cicloId = request.getParameter("Ciclo");
		session.setAttribute("cicloId", cicloId);
	}

	ArrayList<aca.ciclo.CicloGrupo> lisCicloGrupo = cicloGrupoLista.getListGrupos( conElias, cicloId, " ORDER BY NIVEL_ID, GRADO, GRUPO");
%>

<div id="content">
	<h2><fmt:message key="aca.Grados" /></h2>
			
	<form name="frmCiclo" action="permiso.jsp" method="post">
		<input type="hidden" name="Accion">
		
		<div class="well">
			<select name="Ciclo" id="Ciclo" onchange="javascript:cambiaCiclo()" class="input-xxlarge">
			<%for (aca.ciclo.Ciclo ciclo : lisCiclo) {%>
				<option value="<%=ciclo.getCicloId() %>" <%if (ciclo.getCicloId().equals(cicloId)) {%>selected<%} %>><%=ciclo.getCicloNombre() %></option>
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
					
								<th width="5%"><fmt:message key="aca.Alumnos" /></th>
								<th width="5%"><fmt:message key="aca.Evaluaciones" /></th>
								<th width="5%"><fmt:message key="aca.Materias" /></th>
								<th width="5%"><fmt:message key="aca.Grupo" /></th>
							</tr>
						</thead>

		<%
				} //if de cambia nivel
		%>
			<tr>
				<td><%=row%></td>
				<td><%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))%></td>
				<td>"<%=grupo.getGrupo()%>"</td>
				<td><%=grupo.getEmpleadoId()%> | <%=aca.empleado.EmpPersonal.getNombre(conElias,grupo.getEmpleadoId(), "NOMBRE")%></td>
				<td><%=grupo.getPlanId()%> | <%=aca.plan.Plan.getNombrePlan(conElias, grupo.getPlanId())%></td>
				
				<td style="text-align: center; cursor:pointer;" onclick="grupo('<%=grupo.getCicloGrupoId()%>');" onmouseover="this.style.backgroundColor='#F2F2F2';" onmouseout="this.style.backgroundColor='';">
					<i class="icon-user"></i>
				</td>
				<td style="text-align: center; cursor:pointer;" onclick="grupal('<%=grupo.getCicloGrupoId()%>');" onmouseover="this.style.backgroundColor='#F2F2F2';" onmouseout="this.style.backgroundColor='';">
					<i class="icon-th-list"></i>
				</td>
				<td style="text-align: center; cursor:pointer;" onclick="materias('<%=grupo.getCicloGrupoId()%>');" onmouseover="this.style.backgroundColor='#F2F2F2';" onmouseout="this.style.backgroundColor='';">
					<i class="icon-list-alt"></i>
				</td>
				<td style="text-align: center; cursor:pointer;" onclick="promedioGrupo('<%=grupo.getCicloGrupoId()%>');" onmouseover="this.style.backgroundColor='#F2F2F2';" onmouseout="this.style.backgroundColor='';">
					<i class="icon-book"></i>
				</td>
			</tr>
		<%
			} //fin de for
		%>
	
	</table>
</div>

<%@ include file="../../cierra_elias.jsp"%>
