<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.ciclo.Ciclo"%>

<jsp:useBean id="Nivel" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="EmpPersonalL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>

<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>

<%
	String codigoId 		= (String)session.getAttribute("codigoEmpleado");
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= request.getParameter("ciclo")==null ? Ciclo.getCargaActual(conElias, escuelaId) : request.getParameter("ciclo");
	
	//Niveles con permiso de alta de materias en el ciclo escolar   
	String nivel   			= aca.ciclo.CicloPermiso.getNiveles(conElias, cicloId);
	String [] listaNivel 	= nivel.split("-");	
	
	String idNivel			= "";
	String empleadoId		= "";
	int numAlumnos			= 0;
%>

<style>
	body{
		background: white;
	}
	
</style>
<body>

<div id="content">

<form id="frmMaestro" name="frmMaestro" action="carga.jsp" method="post">


<h2><fmt:message key="informes.CargaDocente" /> <small><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %></small></h2>

<div class="well">
	<select id="ciclo" name="ciclo" onchange="document.frmMaestro.submit();" style="width:310px;">
<%
	ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID DESC");

	for(int i = 0; i < lisCiclo.size(); i++){
		ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
			<option value="<%=ciclo.getCicloId() %>"<%=ciclo.getCicloId().equals(cicloId)?" Selected":"" %>><%=ciclo.getCicloNombre() %></option>
<%
	}
%>
  	</select>  
  	
</div>
<div class="content">
	<img src="imagen.jsp?id=<%=new java.util.Date().getTime()%>" width="140">
</div>


  <%
    	for(int j=1; j<listaNivel.length; j++){
	  	ArrayList<aca.empleado.EmpPersonal> lisMaestro = EmpPersonalL.getListMaestroxNivel(conElias,escuelaId, listaNivel[j], cicloId, "ORDER BY NOMBRE");%>
		  		
		  		
			   <%
			    idNivel = listaNivel[j];
			   	for (int i=0; i< lisMaestro.size(); i++){  
			   	if(lisMaestro.get(i).getCodigoId().equals(codigoId)){%>
				   	<div class="alert alert-info">
			  			<h4><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, listaNivel[j]+"")%></h4>
			  		</div>
		  		<%}
					  					
			   		if(lisMaestro.get(i).getCodigoId().equals(codigoId)){
				   ArrayList<aca.ciclo.CicloGrupoCurso> lisMaterias		= GrupoCursoLista.getListMateriasEmpleadoxNivel(conElias, cicloId, codigoId, idNivel, " ORDER BY ORDEN_NGG(CICLO_GRUPO_ID)");
			   %>
				   
			   <div class="alert" style="margin-left:20px;">
				
					<h5><%=lisMaestro.get(i).getCodigoId() %>&nbsp; &nbsp; <%=lisMaestro.get(i).getNombre()+" "+lisMaestro.get(i).getApaterno()+" "+lisMaestro.get(i).getAmaterno()%> </h5>
					<br />
					<fmt:message key="aca.Materias" />: <%=lisMaterias.size() %>
				</div>
				
				<div class="materias">  
				<table class="table table-condensed" style="margin-left:40px;width:80%;">	   		
				   <tr>
				   	  <th width="5%" align="center"><fmt:message key="aca.AbreviaNum" /></th>
				      <th width="5%" align="center"><fmt:message key="aca.Grado" /></th>
				      <th width="5%" align="center"><fmt:message key="aca.Grupo" /></th>
				      <th width="15%" align="center"><fmt:message key="aca.Materia" /></th>
				      <th width="7%" align="center"># <fmt:message key="aca.AbreviaAlum" /></th>
	         	   </tr>
	         	            	 
	         	  <%         	 	
	  					for (int x=0;x<lisMaterias.size();x++){  					
							aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(x);
							CicloGrupo.mapeaRegId(conElias, grupoCurso.getCicloGrupoId());
							numAlumnos 	= Integer.parseInt(aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId()));
							
							String grado	= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, CicloGrupo.getNivelId(), CicloGrupo.getGrado());
					%>
		  				<tr >
		  				    <td align="center"><%=x+1%></td>
						    <td align="center"><%=grado%></td>
						    <td align="center"><%=CicloGrupo.getGrupo()%></td>
						    <td align="center"><%=aca.plan.PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId())%></td>    
						    <td align="center"><%=numAlumnos%></td>    
		  				</tr>
	  
					<%	
						}//FIN DE FOR
					%>
				  </table>
				  </div>
<%					}
			   }
  		}
%>

</form>
</div>
</body>
<%@ include file="../../cierra_elias.jsp" %>