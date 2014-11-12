<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>


<script>
	function materia(cicloGrupoId,cursoId){
		document.location.href="materia.jsp?CicloGrupoId="+cicloGrupoId+"&CursoId="+cursoId;
	}
</script>
<%	
	java.text.DecimalFormat frmDecimal	= new java.text.DecimalFormat("###,##0.0;(###,##0.0)");
	java.text.DecimalFormat frmDecimal2	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)");
	java.text.DecimalFormat frmEntero	= new java.text.DecimalFormat("###,##0;(###,##0)");
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	frmDecimal2.setRoundingMode(java.math.RoundingMode.DOWN);

	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String cursoId			= (String) request.getParameter("CursoId");
	String cicloId			= (String) session.getAttribute("cicloId");
	
	
	ArrayList<String> lisAlum						= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
	ArrayList<aca.ciclo.CicloBloque> listBloques 	= ciclo.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");	
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias,cicloGrupoId);
	
	// TreeMap para verificar si el alumno lleva la materia
	java.util.TreeMap<String,aca.kardex.KrdxCursoAct> treeAlumCurso	= kardexLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");
	
	// TreeMap para obtener la nota de un alumno en la materia
	java.util.TreeMap treeNota		= kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, "");
	
	// Arreglos para calcular el promedio de la materia
	
	float[] promedio 	= new float[20];
	int[] numAlum 		= new int[20];                       
	
	// Inicializa los arreglos
	for(int i=0;i<20;i++){
		promedio[i] = 0; numAlum[i] = 0;		
	}
	
	java.util.TreeMap<String,aca.vista.AlumnoProm> treeProm 	= AlumPromLista.getTreeCurso(conElias, cicloGrupoId, cursoId,"");
%>

<div id="content">
	<h2><fmt:message key="maestros.EvaluaciondelSemestre" /></h2>
	
	<div class="alert alert-info">
		<%=aca.plan.PlanCurso.getCursoNombre(conElias,cursoId)%>
	</div>
	
	<div class="well">
		<a href="materias.jsp?CicloGrupoId=<%=cicloGrupoId %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<table class="table table-condensed table-striped table-bordered">
  		<thead>
	  		<tr>
	        	<th width="2%" align="center">#</th>
	    		<th width="4%" align="center"><fmt:message key="aca.Matricula" /></th>
	    		<th width="24%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
				<%for(aca.ciclo.CicloBloque bloq : listBloques){%>
	    			<th class="text-right" width="7%" align="center"><%=bloq.getBloqueNombre() %></th>
				<%}%>
				<th class="text-right" width="4%"><fmt:message key="aca.Promedio" /></th>
			</tr>
		</thead>
		<%
			double totalGeneral = 0;
			int cont = 0;
			for (String codigoAlumno : lisAlum){
				cont++;
		%>
				<tr>
        			<td><%=cont%></td>
    				<td><%=codigoAlumno%></td>
    				<td><%=aca.alumno.AlumPersonal.getNombre(conElias,codigoAlumno,"APELLIDO")%></td>
    				<%
						for(int j=0; j<listBloques.size(); j++ ){
							aca.ciclo.CicloBloque bloq = (aca.ciclo.CicloBloque) listBloques.get(j);
			
							String punto = aca.plan.PlanCurso.getPunto(conElias, cursoId);
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
									if (nota > 0){
										promedio[j] = promedio[j]+nota;
										numAlum[j] = numAlum[j]+1;						
									}
								}else{
									strNota = "-";
								}
							}else{
								strNota = "X";
							}

					%>
    						<td class="text-right" width="7%"><%=strNota %></td>
					<%
						}
    	
    					aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId+cursoId+codigoAlumno);
    	
    					String prom = "0";
    					if(alumProm!=null){
    						prom = alumProm.getPromedio();
    					}
    	
    					String Promedio = frmDecimal.format(Double.parseDouble(prom)).replaceAll(",",".");
    					
    					String extra = "";
    					if (treeAlumCurso.containsKey(cicloGrupoId+cursoId+codigoAlumno)){
    						extra = treeAlumCurso.get(cicloGrupoId+cursoId+codigoAlumno).getNotaExtra();
    						if(extra==null){
    							extra = "";
    						}else{
    							extra = frmDecimal.format(Double.parseDouble(extra)).replaceAll(",",".");	
    						}
    					}
    					
    					if(extra.equals("")){
    						totalGeneral+= Double.parseDouble(Promedio);
    					}else{
    						totalGeneral+= Double.parseDouble(extra);
    					}
					%>
					<td class="text-right">
						<%=Promedio%>
						<%if(!extra.equals("")){ %>
							<span class="label">Extra: <%=extra %></span>
						<%} %>
					</td>
    			</tr>
		<%
			}
		%>
	 		<tr>
		    	<th colspan="3" ><fmt:message key="aca.Total" /></th>
				<% 
					for (int j=0;j<listBloques.size();j++){
						float prom = promedio[j]/numAlum[j];			
				%>
		    			<th class="text-right"><%=frmDecimal2.format(prom).replaceAll(",",".") %></th>
				<%    
	    			}
	    		%>
	    		<th class="text-right"><%=frmDecimal.format(totalGeneral/lisAlum.size()) %></th>
	 		</tr>
	</table>

</div>


<%@ include file= "../../cierra_elias.jsp" %> 