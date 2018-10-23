<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.ciclo.Ciclo"%>

<jsp:useBean id="catNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="alumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>

<%
	String escuelaId			= (String) session.getAttribute("escuela");
	String unionId				= aca.catalogo.CatEscuela.getUnionId(conElias, escuelaId);
	String cicloId				= request.getParameter("Ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("Ciclo");
	String accion				= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String fileJsp				= "credencialPDF"+unionId+".jsp";
	
	String periodoId			= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);
	String bgColor				= "";
	int contador				= 0;
	
	if(accion.equals("1")){
		session.setAttribute("cicloId", cicloId);		
	}
	
	// Ciclos academicos de la escuela
	ArrayList<aca.ciclo.Ciclo> lisCiclo					= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");
	
	// Niveles encontrados en un ciclo academico
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel	= catNivelL.getListNivelesCarga(conElias, escuelaId, cicloId, " ORDER BY NIVEL_ID");
	
	// Grupos en cada nivel 
	ArrayList<String> lisGrupos							= null;
	
	// Alumnos por nivel, grado y grupo
	ArrayList<AlumPersonal> lisAlumnos 					= null;
	
	String dirFoto = application.getRealPath("/alumno/credencial/"+fileJsp);
	java.io.File formato = new java.io.File(dirFoto);
	Boolean tieneFormato=false;
	
	if (formato.exists()){
		tieneFormato = true;
	}
%>
<head>
	
</head>
<body>

	<div id="content">
	
		<h2><fmt:message key="alumnos.Credenciales"/></h2>
		<form name="frmCiclo" action="listado.jsp" method="post">
		<div class="well" style="overflow:hidden;">	
			<input type="hidden" name="Accion">
	 		<select name="Ciclo" id="Ciclo" onchange='javascript:cambiaCiclo()' style="width:350px;">
<%		
	for( int j=0;j<lisCiclo.size();j++){
		aca.ciclo.Ciclo ciclo = (aca.ciclo.Ciclo) lisCiclo.get(j);
		if (ciclo.getCicloId().equals(cicloId)){			
			out.print(" <option value='"+ciclo.getCicloId()+"' Selected> ["+ciclo.getCicloId()+"] "+ ciclo.getCicloNombre()+"</option>");
		}else{
			out.print(" <option value='"+ciclo.getCicloId()+"'> ["+ ciclo.getCicloId()+"] "+ciclo.getCicloNombre()+"</option>");
		}
	}	
%>
	  		</select>
			<input type="text" data-date-format="dd/mm/yyyy" class="text" id="VigIni" name="VigIni" value="" maxlength="40"  class="input-medium" placeholder="<fmt:message key="aca.VigenciaInicial"/>" />
			<input type="text" data-date-format="dd/mm/yyyy" class="text" id="VigFin" name="VigFin" value="" maxlength="40" class="input-medium" placeholder="<fmt:message key="aca.VigenciaFinal"/>" />
<%if(tieneFormato==true){%>		
			<a class="btn btn-primary pull-right" onclick="generarCredenciales('<%=fileJsp%>');" ><i class="icon-th icon-white"></i> <fmt:message key="boton.GenerarCredenciales"/></a>
<%}
else{
%>	
			<a class="btn btn-primary pull-right" onclick="alert('No tiene formato.');" ><i class="icon-th icon-white"></i> <fmt:message key="boton.GenerarCredenciales"/></a>		
<%}
%>
		</div>
		
	<%
		for(int i = 0; i < lisNivel.size(); i++){
			aca.catalogo.CatNivelEscuela nivel = (aca.catalogo.CatNivelEscuela) lisNivel.get(i);
	%>
			<div class="alert alert-info">
				<h4><%=nivel.getNivelNombre() %></h4>
			</div>
	
	<%
			for(int j = 1; j <= Integer.parseInt(nivel.getGradoFin()); j++){
				lisGrupos = alumPersonalL.getListGrupos(conElias, nivel.getNivelId(), String.valueOf(j));
				for(int k = 0; k < lisGrupos.size(); k++){
					String grupo = ((String)lisGrupos.get(k));
					lisAlumnos = alumPersonalL.getListAlumnosGrado(conElias, escuelaId, cicloId, periodoId, nivel.getNivelId(), String.valueOf(j), " AND C.GRUPO = '"+grupo+"' ORDER BY APATERNO, AMATERNO, NOMBRE, GRUPO");
					
					if(lisAlumnos.size() > 0){
	%>
	
			
			<div class="alert" style="margin-left:20px;">
				<h5><%=CatNivel.getGradoNombre(j) %> <small>"<%=grupo%>"</small></h5>
			</div>
			
			
			<table class="table table-condensed" style="margin-left:40px;">
						<tr>
							<th width="50px" align="center"><a class="btn btn-small btn-info" onclick="seleccionaGrupo(<%=contador+1 %>, <%=lisAlumnos.size() %>);" style="cursor:pointer; font-size:12px;"><b> <fmt:message key="boton.Todos"/></b></a></th>
							<th width="80px" align="center"><b><fmt:message key="aca.Matricula"/></b></th>
							<th align="center"><b><fmt:message key="aca.Nombre"/></b></th>
						</tr>
	<%
						for(int l = 0; l < lisAlumnos.size(); l++){
							alumPersonal = (AlumPersonal) lisAlumnos.get(l);
							contador++;
	%>
						<tr>
							<td style="text-align:center;"><input type="checkbox" id="matricula-<%=contador %>" name="matricula-<%=contador %>" value="<%=alumPersonal.getCodigoId() %>" /></td>
							<td align="center"><%=alumPersonal.getCodigoId() %></td>
							<td><%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %> <%=alumPersonal.getNombre() %></td>
						</tr>
	<%
						}
	%>
			</table>
				
	<%
					}
				}
			}
		}
	%>
	
		</form>
	</div>
	
	
	<script>
		
		function seleccionaGrupo(inicio, tamanio){
			for(i = inicio; i < (inicio+tamanio); i++){
				document.getElementById("matricula-"+i).checked = !document.getElementById("matricula-"+i).checked;
			}
		}
		
		function generarCredenciales(archivo){
			var inputs		= document.getElementsByTagName("INPUT");
			var matriculas	= "";
			var selecciono	= false;
			var contador	= 0;
			for(i = 0; i < inputs.length; i++){
				if(inputs[i].type == "checkbox"){
					if(inputs[i].checked){
						contador++;
						matriculas+="&matricula-" + contador + "=" + inputs[i].value + "\n";
					}
				}
			}
			matriculas = "cantidad=" + contador + matriculas;
			if(contador > 0){
				document.location.href = archivo+"?"+matriculas+"&VigIni="
											+document.getElementById("VigIni").value
											+"&VigFin="+document.getElementById("VigFin").value;
			}else{
				alert("<fmt:message key="aca.SeleccioneAlumno"/>");
			}
		}			
		
		function cambiaCiclo( ){		
			document.frmCiclo.Accion.value = "1";
			document.frmCiclo.submit();
		}
	</script>
</body>

<%@ include file="../../cierra_elias.jsp" %>