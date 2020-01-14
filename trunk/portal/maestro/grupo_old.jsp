<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="java.util.TreeMap"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.Plan"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>

<%
	java.text.DecimalFormat df = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	String escuelaId	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");
	String cicloId 		= request.getParameter("Ciclo");
	
	String grupo 				= request.getParameter("Grupo")==null?"X":request.getParameter("Grupo");
	String grupos[] 			= new String[10];
	
	empPersonal.mapeaRegId(conElias, codigoId);
	String maestro 		= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	String materia 		= "";
	
	double promGral=0, prom1=0, prom2=0, prom3=0;
	int todos=0, tipo1=0, tipo2=0, tipo3=0,i=0;
	String tipoCurso 	= "";
	String promMateria 	= "";
	String promGrupo 	= "";	
%>
<body>
<form>
	<table width="97%">
		<tr>
			<td align="center">
				<select id="Ciclo" onchange="location.href='grupo.jsp?Ciclo='+this.options[this.selectedIndex].value">
<%
	String cicloSeleccionado;
	ArrayList lisCiclo = cicloLista.getListCiclosEmpleadoPlanta(conElias, codigoId, "ORDER BY CICLO_ID");
	for(i = 0; i < lisCiclo.size(); i++){
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
			</td>
		</tr>
		<tr>
	      <td align="center"> <b>Grupos:</b> 
<%		
		// Despliega la lista de grupos que ha inscrito el alumno en este periodo
		grupos = aca.ciclo.CicloGrupo.getMaestroGrupos(conElias, cicloId, codigoId);
		int z = 0;
		boolean negrita = false;
		while( z < grupos.length && grupos[z] != null){
			
			// identifica el grupo seleccionado
			if (grupo.equals("X")) { 
				grupo = grupos[z]; negrita = true;
			}else if (grupo.equals(grupos[z]) ){
				negrita = true; 
			}else{
				negrita = false;
			}
%>			&nbsp;
			<a href="grupo.jsp?Ciclo=<%=cicloId%>&Grupo=<%=grupos[z]%>">
<%
			  // Despliega el nombre del grupo seleccionado
			  if (negrita){ out.print("<font size='2'><b>"); }
			  out.print( aca.ciclo.CicloGrupo.getGrupoNombre(conElias, grupos[z]) );
			  if (negrita){ out.print("</b></font>"); }
%>
			</a>&nbsp;
<%
			z++;
		}		
		
		// Identifica y busca el grupo
		cicloGrupo.mapeaRegId(conElias, grupo);
%>		
	      </td>
	    </tr>
	    <tr><td></td></tr>
		<tr>
			<td align="center"><font size="3"><b><%=empPersonal.getNombre() %> <%=empPersonal.getApaterno() %> <%=empPersonal.getAmaterno() %></b></font></td>
		</tr>
		<tr>
			<td align="center"><font size="2"><%=Plan.getNombrePlan(conElias, cicloGrupo.getPlanId()) %> - <%=cicloGrupo.getGrupoNombre() %></font></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">Imprimir Acta&nbsp;&nbsp;
				<a href="acta.jsp?Bimestre=1&Ciclo=<%=cicloId %>"><b>1</b></a>&nbsp;&nbsp;
				<a href="acta.jsp?Bimestre=2&Ciclo=<%=cicloId %>"><b>2</b></a>&nbsp;&nbsp;
				<a href="acta.jsp?Bimestre=3&Ciclo=<%=cicloId %>"><b>3</b></a>&nbsp;&nbsp;
				<a href="acta.jsp?Bimestre=4&Ciclo=<%=cicloId %>"><b>4</b></a>&nbsp;&nbsp;
				<a href="acta.jsp?Bimestre=5&Ciclo=<%=cicloId %>"><b>5</b></a>&nbsp;&nbsp;Bimestres
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" class="tabla">
					<tr>
					    <th style="text-align:center" width="7%"><b>Matrícula</b></th>
						<th style="text-align:center"><b>Nombres</b></th>
					
<%
	ArrayList lisMaterias = cicloGrupoCursoLista.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_ID");
System.out.println("LisMaterias size:"+lisMaterias.size());
	String[] colores = {"#FF8080","#93C9FF","#04C68B","#FF8040","#FFCAE4","#BE7C7C","#00AA55","#C5AF65","#0080FF","#FFC891","#C5EBDE","#C4FCFF","#B9C4B5","#9EA2C5","#E9ED3F"};
	String materias[] = new String[lisMaterias.size()];
	double promMaterias[] = new double[lisMaterias.size()];
	
	// inicializa los valores del arreglo de materias
	for(int x = 0; x < lisMaterias.size(); x++){ materias[z]="0";}
	
	for( i = 0; i < lisMaterias.size(); i++){
		cicloGrupoCurso = (CicloGrupoCurso) lisMaterias.get(i);
		promMaterias[i] = 0;
		materias[i] = aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
		if(CicloGrupoCurso.daEsteCurso(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), codigoId)){
%>
					<th width="3%" title="Evaluar: <%=materias[i] %> " style="cursor:pointer;padding:2px" onclick="location.href='evaluar.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>'" onmouseover="border=this.style.border;this.style.border='outset';this.style.padding='0px';" onmouseout="this.style.border=border;this.style.padding='2px';"><b><%=i+1 %></b></th>
<%
		}else{
%>
					<th width="3%" title="<%=materias[i] %> " ><b><%=i+1 %></b></th>
<%
		}
	} System.out.println("Paso 4");

%>
					</tr>
					<tr>
<%
	
	ArrayList lisKardex = kardexLista.getListAll(conElias, escuelaId, "AND CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ALUM_APELLIDO(CODIGO_ID), ORDEN_CURSO_ID(CURSO_ID), CURSO_ID");
System.out.println("LisKardex size:"+lisMaterias.size());
	String alumno = "";
	String nota = "";
	int contador = 1;
	int contadorAlumnos = 1;
	for( i = 0; i < lisKardex.size(); i++){
		
		
		kardex = (KrdxCursoAct) lisKardex.get(i);
		
		if(!alumno.equals(kardex.getCodigoId())){
			alumno = kardex.getCodigoId();
			if(contador != 1)
				for(int j = contador; j <= lisMaterias.size(); j++){
%>
							<td align="center" bgcolor="<%=colores[j-1] %>" title="<%=materias[j-1] %>">X</td>
<%
				}
			contador = 1;
			contadorAlumnos++;
%>
					</tr>
					<tr<%if(contadorAlumnos%2 != 0) out.print(" bgcolor=\"#C8D4A3\""); %>>
					    <td><%=kardex.getCodigoId()%></td>
						<td onclick="location.href='notas.jsp?CicloGrupoId=<%=cicloGrupo.getCicloGrupoId() %>&CodigoAlumno=<%=alumno %>&EvaluacionId=0';" style="cursor:pointer;" onmouseover="this.style.backgroundColor='#CCE8FF';" onmouseout="this.style.backgroundColor='';"><%=AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO") %></td>
<%
		}
		cicloGrupoCurso = (CicloGrupoCurso) lisMaterias.get(contador-1);
		if(kardex.getTipoCalId().equals("1")){
			TreeMap treeProm 	= AlumPromLista.getTreeCurso(conElias, cicloGrupo.getCicloGrupoId(), cicloGrupoCurso.getCursoId(),"");
			double prom 	= 0.0; 
			int promedio 	= 0;
			if (treeProm.containsKey(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+kardex.getCodigoId())){
				aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+kardex.getCodigoId());
				prom = Double.parseDouble(alumProm.getPromedio())+Double.parseDouble(alumProm.getPuntosAjuste())+.5;
				nota =  String.valueOf(prom);
			}else{
				System.out.println("Error... "+kardex.getCodigoId());
			}
			//nota = aca.vista.AlumEval.getAlumPromCurso(conElias, alumno, cicloGrupo.getCicloGrupoId(), kardex.getCursoId());
			if(nota.trim().equals(".0"))
				nota = "0";
		}else if(kardex.getTipoCalId().equals("2") || kardex.getTipoCalId().equals("3")){
			nota = kardex.getNota();
		}else if(kardex.getTipoCalId().equals("4") || kardex.getTipoCalId().equals("5")){
			nota = kardex.getNotaExtra();
		}
		
		tipoCurso = aca.plan.PlanCurso.getTipocurso(conElias,kardex.getCursoId());
		if (nota!=null && !nota.equals("0")){
			if ( tipoCurso.equals("1")){
				tipo1++;
				prom1 += Double.valueOf(nota).doubleValue();
			}else if(tipoCurso.equals("2")){
				tipo2++;
				prom2 += Double.valueOf(nota).doubleValue();
			}else if(tipoCurso.equals("3")){
				tipo3++;
				prom3 += Double.valueOf(nota).doubleValue();
			}
			System.out.println("Antes de asignar promedio a materia");
			promMaterias[contador-1] += Double.valueOf(nota).doubleValue();
		}	
		System.out.println("Datos:"+contador+":");
		while(!cicloGrupoCurso.getCursoId().equals(kardex.getCursoId()) && contador<=lisMaterias.size()){
%>
						<td align="center" bgcolor="<%=colores[contador-1] %>" title="<%=materias[contador-1] %>">X</td>
<%
			contador++;
			cicloGrupoCurso = (CicloGrupoCurso) lisMaterias.get(contador-1);
		}
%>
						<td align="center" bgcolor="<%=colores[contador-1] %>" title="<%=materias[contador-1] %> "><%=nota %></td>
<%
		contador++;
	}
	System.out.println("Paso 5");
%>
					</tr>
					<tr>
						<th style="text-align:center" width="7%" colspan="2"><b>Promedios</b></th>
						
					
<%				for(i = 0; i < lisMaterias.size(); i++){
					promMaterias[i] 	= promMaterias[i]/contadorAlumnos;
					promMateria 		= String.valueOf(promMaterias[i]);
					promMateria 		= promMateria.substring(0,promMateria.indexOf(".")+2);
					promGral 			+=  Double.valueOf(promMateria).doubleValue();
%>
					<th width="3%" title="promedio: <%=materias[i]%> "><b><%=promMateria%></b></th>
<%				}
				promGral 		= promGral / lisMaterias.size();
				promGrupo 		= df.format(promGral);
%>
					</tr>
					<tr>
						<td style="text-align:center" width="7%" colspan="20">
						  <font size = "2">
						  <b>Promedio General: <%=promGrupo%></b>
						  </font>
						</td>
					</tr>
				</table>
			</td>
		</tr>				
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="70%" class="tabla">
<%
		for( i = 0; i < lisMaterias.size(); i++){
			cicloGrupoCurso = (CicloGrupoCurso) lisMaterias.get(i);
			materia	= aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
			
			if(CicloGrupoCurso.daEsteCurso(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), codigoId)){
%>
					<tr bgcolor="<%=colores[i] %>" title="Evaluar: <%=materia %>" style="cursor:pointer" onclick="location.href='evaluar.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>'" onmouseover="color=this.style.background;this.style.background='#DBDBDB';" onmouseout="this.style.background=color">
						<td><font size="2"><b><%=i+1 %></b></font></td>
						<td><font size="2"><b><%=materia%></b></font></td>
						<td>
						  [<a href="modulo.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>">Planeación</a>]&nbsp;
<% 
				String metodo = aca.catalogo.CatNivel.getMetodo(conElias, aca.catalogo.CatNivel.getNivelId(conElias, cicloGrupoCurso.getCursoId()));				
				if(metodo.equals("S")){
%>							
				  [<a href="metodo.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&Materia=<%=materia%>&Maestro=<%=maestro%>">Estrategias</a>]
<% 
				}else{
%>
				  [<a href="metodologia.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&Materia=<%=materia%>&Maestro=<%=maestro%>">Estrategias</a>]	
<%					
				}
%>						  						  						  
						</td>
					</tr>
<%
			}else{
%>
					<tr bgcolor="<%=colores[i] %>" title="<%=materia %>">
						<td><font size="2"><b><%=i+1 %></b></font></td>
						<td><font size="2"><b><%=materia %></b></font></td>
						<td><%= aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(),"NOMBRE") %></td>
					</tr>
<%
			}
		} 
		System.out.println("Paso 6");
%>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
<%@ include file="../../cierra_elias.jsp" %>