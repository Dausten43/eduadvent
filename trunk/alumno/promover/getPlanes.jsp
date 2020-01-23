<%@ include file="../../con_elias.jsp"%>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela" />
<jsp:useBean id="CatGrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>
<%


	String accion = request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String actualizar = request.getParameter("Actualizar")==null?"":request.getParameter("Actualizar");	
	String escuelaId = request.getParameter("escuelaId") == null ? "" : request.getParameter("escuelaId");
	String cicloId = request.getParameter("ciclo") == null ? "" : request.getParameter("ciclo");
	String planId = request.getParameter("PlanId") == null ? "" : request.getParameter("PlanId");
	String nivelId = aca.plan.Plan.getNivel(conElias, planId);
	String grado = request.getParameter("grado") == null ? "" : request.getParameter("grado");
	

	if (actualizar.equals("plan")) {
		ArrayList<aca.plan.Plan> lisPlanes = new aca.plan.PlanLista().getListPlanPermiso(conElias, cicloId, "ORDER BY 1");
		for (aca.plan.Plan plan : lisPlanes) {
			out.print(" <option value='" + plan.getPlanId() + "'>" + plan.getPlanNombre() + "</option>");
		}
		
	} else if (actualizar.equals("grado")) {
		Nivel.mapeaRegId(conElias, nivelId, escuelaId);
		for (int i = Integer.parseInt(Nivel.getGradoIni()); i <= Integer.parseInt(Nivel.getGradoFin()); i++) {
			out.print(" <option value='" + i + "'>" + i + "</option>");
		}
		if(accion.equals("2")){
			out.print(" <option value='" + (0) + "'> Inactivar </option>");
		}
		
	} else if(actualizar.equals("grupo")) {
		ArrayList<aca.catalogo.CatGrupo> lisGrupoAlta = CatGrupoL.getListGruposAlta(conElias, cicloId, planId, escuelaId, nivelId, "ORDER BY NIVEL_ID, GRADO, GRUPO");
		
		int numCursos = 0, numAlumnos;
		for(int i = 0; i < lisGrupoAlta.size(); i++){
			aca.catalogo.CatGrupo grupo = (aca.catalogo.CatGrupo) lisGrupoAlta.get(i);
			if(grupo.getGrado().equals(grado)){
				String cicloGrupoId = aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, nivelId, grupo.getGrado(), grupo.getGrupo(), cicloId, planId);
	
				numCursos 		= aca.ciclo.CicloGrupoCurso.numCursosGrupo(conElias, cicloGrupoId);
				numAlumnos 		= aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoId);
				
				if((numCursos!=0 || numAlumnos!=0)){
					out.print(" <option value='" + grupo.getGrupo() + "'>" + grupo.getGrupo() + "</option>");
				}
			}
		}
	}else if(actualizar.equals("grupo2")) {
		ArrayList<aca.catalogo.CatGrupo> lisGrupoAlta = CatGrupoL.getListGruposAlta(conElias, cicloId, planId, escuelaId, nivelId, "ORDER BY NIVEL_ID, GRADO, GRUPO");
		ArrayList<aca.catalogo.CatGrupo> lisGrupoNotAlta = CatGrupoL.getListGrupos(conElias, cicloId, planId, escuelaId, nivelId, "ORDER BY NIVEL_ID, GRADO, GRUPO");
		ArrayList<aca.catalogo.CatGrupo> lisGrupo = new ArrayList<aca.catalogo.CatGrupo>();
		lisGrupo.addAll(lisGrupoAlta);
		lisGrupo.addAll(lisGrupoNotAlta);
		
		int numCursos = 0, numAlumnos;
		for(int i = 0; i < lisGrupo.size(); i++){
			aca.catalogo.CatGrupo grupo = (aca.catalogo.CatGrupo) lisGrupo.get(i);
			if(grupo.getGrado().equals(grado)){
				out.print(" <option value='" + grupo.getGrupo() + "'>" + grupo.getGrupo() + "</option>");
			}
		}
	}
%>
<%@ include file="../../cierra_elias.jsp"%>