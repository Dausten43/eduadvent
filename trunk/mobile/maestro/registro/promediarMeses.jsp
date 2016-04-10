<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.TreeMap"%>
<%@page import="java.text.*" %>

<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>

<head>
<script type="javascript">
	function materia(cicloGrupoId,cursoId){
		document.location.href="materia.jsp?CicloGrupoId="+cicloGrupoId+"&CursoId="+cursoId;
	}
</script>
<%	
	DecimalFormat frmDecimal	= new DecimalFormat("###,##0.0;(###,##0.0)");
	DecimalFormat frmEntero		= new DecimalFormat("###,##0;(###,##0)");
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String cursoId			= (String) request.getParameter("CursoId");
	String cicloId			= (String) session.getAttribute("cicloId");
	
	
	ArrayList lisAlum		= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
	ArrayList listBloques 	= ciclo.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	String codigoAlumno		= "";
	
	String strBgcolor		= "";
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias,cicloGrupoId);
	
	// TreeMap para verificar si el alumno lleva la materia
	TreeMap treeAlumCurso	= kardexLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");
	
	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap treeNota		= kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, "");
	
	// Arreglos para calcular el promedio de la materia
	
	float[] promedio 	= new float[20];
	int[] numAlum 		= new int[20];                       
	
	// Inicializa los arreglos
	for(int i=0;i<20;i++){
		promedio[i] = 0; numAlum[i] = 0;		
	}
%>
</head>
<body>
<div id="content">
<h2><fmt:message key="maestros.PromedioPorBloque" /></h2>
<div class="well"><a href="materias.jsp?CicloGrupoId=<%=cicloGrupoId %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a></div>
 	<h4><fmt:message key="aca.Curso" />: <%=aca.plan.PlanCurso.getCursoNombre(conElias,cursoId)%></h4>
	<table  width="99%" align="center" class="table table-condensed table-striped">
  	  <tr>
        <th width="2%" align="center">#</th>
    	<th width="4%" align="center"><fmt:message key="aca.Matricula" /></th>
    	<th width="24%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
<%
		for(int j=0; j<(listBloques.size()/2); j++ ){
%>
    	<th width="7%" align="center"><fmt:message key="aca.Bloque" /> <%=j+1 %></th>
<%
		}
%>
	</tr>
<%
	for (int i=0;i<lisAlum.size();i++){
	codigoAlumno = (String)lisAlum.get(i);
	
%>
	<tr>
        <td align="center"><strong><%=i+1%></strong></td>
    	<td align="center"><%=codigoAlumno%></td>
    	<td align="left">
	  	  <strong><%=aca.alumno.AlumPersonal.getNombre(conElias,codigoAlumno,"APELLIDO")%></strong>
    	</td>
    	<%
    	String notaAnterior = "0";
    	int cont=0;
		for(int j=0; j<listBloques.size(); j++ ){
			aca.ciclo.CicloBloque bloq = (aca.ciclo.CicloBloque) listBloques.get(j);
			
			String punto		= aca.plan.PlanCurso.getPunto(conElias, cursoId);
			String strNota="0";
			// Verifica si el alumno tiene dada de alta la materia
			if (treeAlumCurso.containsKey(cicloGrupoId+cursoId+codigoAlumno)){
				if (treeNota.containsKey(cicloGrupoId+cursoId+bloq.getBloqueId()+codigoAlumno)){
					aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId+cursoId+bloq.getBloqueId()+codigoAlumno);
					if (punto.equals("S")){
						strNota = frmDecimal.format( Double.parseDouble(krdxEval.getNota()));	
					}else{
						strNota = frmEntero.format( Double.parseDouble(krdxEval.getNota()));
					}
					if (strNota.equals("")||strNota.equals(null)) strNota = "0";
					
					float nota = Float.parseFloat(strNota.replaceAll(",","."));
					
				}else{
					strNota = "-";
				}
			}else{
				strNota = "X";
			}
			if(j%2!=0){
				String nota = strNota.replaceAll(",",".");
				if(!nota.equals("X") && !nota.equals("-") && !notaAnterior.equals("X") && !notaAnterior.equals("-")){
					nota = Float.toString(new BigDecimal(nota).add(new BigDecimal(notaAnterior)).divide(new BigDecimal("2"), 1, RoundingMode.DOWN).floatValue());
				}
%>			
    			<td width="7%" align="center"><%=nota %></td>
<%
				if(!nota.equals("X") && !nota.equals("-")){
					if (Float.parseFloat(nota) > 0){
						promedio[cont] = promedio[cont]+Float.parseFloat(nota);
						numAlum[cont] = numAlum[cont]+1;
						cont++;
					}
				}
			}else{
				notaAnterior=strNota.replaceAll(",",".");
			}
		}
%>
    </tr>
<%
	}
%>
	 <tr>
		    <td colspan="3" align="center" height="26%" valign="middle"><font size="3"><b><fmt:message key="aca.TotalMayus" />:</b></font></td>
<% 
		for (int j=0;j<listBloques.size()/2;j++){
			float prom = promedio[j]/numAlum[j];			
%>
		    <td align="center" width="4%" valign="middle"><strong><%=frmDecimal.format(prom).replaceAll(",",".") %></strong></td>
<%    
	    }%>
	 </tr>
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 