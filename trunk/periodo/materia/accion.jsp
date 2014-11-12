<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloBloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>

<%	
	String cicloId 		= (String) session.getAttribute("cicloId");	
	String materia 		= request.getParameter("cursoId");
	String cicloGrupoId = request.getParameter("cicloGrupoId");

	ArrayList lisCicloBloque = cicloBloqueLista.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	String msj="ErrorGrabarEval";
	boolean grabo= false;
	
	for(int m = 0; m < lisCicloBloque.size(); m++){
		cicloBloque = (aca.ciclo.CicloBloque) lisCicloBloque.get(m);
		
		cicloGrupoEval.setCicloGrupoId(cicloGrupoId);
		cicloGrupoEval.setCursoId(materia);
		cicloGrupoEval.setEvaluacionId(cicloBloque.getBloqueId());
		cicloGrupoEval.setEvaluacionNombre(cicloBloque.getBloqueNombre());	
		cicloGrupoEval.setFecha(cicloBloque.getFFinal());
		cicloGrupoEval.setValor(cicloBloque.getValor());
		cicloGrupoEval.setTipo("P");
		cicloGrupoEval.setEstado("A");
		cicloGrupoEval.setCalculo("V");
		cicloGrupoEval.setOrden(String.valueOf( (m+1) ));
		if(!cicloGrupoEval.existeReg(conElias)){
			cicloGrupoEval.insertReg(conElias);
			grabo=true;
		}
		
	}
	if(grabo){
		msj="GrabarEval";
	}
	pageContext.setAttribute("msj", msj);
%>
	<table class="table table-condensed" width="40%" height="50px" align="center" valign="middle">
		<tr>
			<td align="center" valign="middle"><font size="6"><fmt:message key="aca.${msj}" /></font></td>
		</tr>
	</table>
	<meta http-equiv="refresh" content="1;url=materia.jsp" />
<%@ include file= "../../cierra_elias.jsp" %>