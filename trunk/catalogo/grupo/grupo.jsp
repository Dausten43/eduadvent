<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="grupoLista" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="empleado" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivel"/>
<jsp:useBean id="grupo" scope="page" class="aca.catalogo.CatGrupo"/>

<script>
	function Borrar( folio, nivel ){
		if(confirm("<fmt:message key="js.Confirma" /> ")==true){
	  		document.location="accionGrupo.jsp?Accion=5&folio="+folio+"&nivelId="+nivel;
	  	}
	}
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String nivelId			= request.getParameter("nivelId");
	String esquema			= request.getParameter("Esquema")==null?"A":request.getParameter("Esquema");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String Grado			= request.getParameter("Grado")==null?"0":request.getParameter("Grado");
	String subNivel			= request.getParameter("subNivel")==null?"1":request.getParameter("subNivel");
	String resultado		= "";
	
	ArrayList<aca.catalogo.CatGrupo> lisGrupo		= grupoLista.getListNivel(conElias, escuelaId, nivelId, " ORDER BY GRADO, GRUPO");
	
	nivel.mapeaRegId(conElias, nivelId);	
%>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloGrupo"%>

<div id="content">
	<h2>
		<fmt:message key="catalogo.ListadoDeGrupos" /> <small><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId) %></small> 
	</h2>
		
	<div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="nivel.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a href="accionGrupo.jsp?Accion=1&nivelId=<%=nivelId %>" class="btn btn-primary"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	</div>		
	
	
	<%
		String grado = "";
		for (int i=0; i< lisGrupo.size(); i++){
			grupo = (aca.catalogo.CatGrupo) lisGrupo.get(i);
			boolean borrar = !aca.ciclo.CicloGrupo.existeGradoyGrupo(conElias, escuelaId, grupo.getGrado(), grupo.getGrupo());
			
			if(!grado.equals(grupo.getGrado())){
				String titulo = aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivelId);
	%> 
		</table>
		<div class="alert alert-info" style="overflow:hidden;padding:8px 14px 8px 14px;"> 
	  		
	  		<div style="float:left;"><%=titulo%> <%=grupo.getGrado() %>
			</div>
			
			<div style="float:right;">
				<a href="editarGrado.jsp?nivelId=<%=nivelId %>&grado=<%=grupo.getGrado() %>&titulo=<%=request.getParameter("titulo")%>" class="btn btn-mini btn-info"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Editar" /></a>
			</div>	
	  		
		</div>		
	  	
	  	<table class="table table-fullcondesned table-nohover table-bordered">
	  		<tr>
	  			<th><fmt:message key="aca.Accion" /></th>
	  			<th><fmt:message key="aca.Grupo" /></th>
	  			<th style="width:10%;"><fmt:message key="aca.Turno" /></th>
	  		</tr>
	<%
				grado = grupo.getGrado();
			}
	%>
	  		<tr>
	  			<td>
		  			<a class="icon-pencil" href="accionGrupo.jsp?Accion=4&folio=<%=grupo.getFolio() %>&nivelId=<%=nivelId %>"></a>
					<%if (borrar){%>	  
		  				<a class="icon-remove" href="javascript:Borrar('<%=grupo.getFolio() %>',<%=nivelId %>)"></a>
					<%}%>	  
				</td>
	  			<td><%=grupo.getGrupo() %></td>
	  			<%
	  				String turno = grupo.getTurno()==null?"":grupo.getTurno();
	  			%>
	  			<td>
	  				<%if(turno.equals("")){%> <fmt:message key="aca.NoAplica" /> <%}%>
					<%if(turno.equals("M")){%> <fmt:message key="aca.Matutino" /> <%}%>
					<%if(turno.equals("V")){%> <fmt:message key="aca.Vespertino" /> <%}%>
	  			</td>
	  		</tr>
	<%
		}	
	%>  
	    </table>
</div>

<%@ include file= "../../cierra_elias.jsp" %>