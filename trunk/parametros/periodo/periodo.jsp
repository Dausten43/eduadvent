<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file="../../seguro.jsp"%>

<%@page import="java.util.ArrayList"%>
<%@ page import= "aca.ciclo.Ciclo"%>
<%@ page import= "aca.ciclo.CicloLista"%>


<head>
	
<%
	String escuelaId		= (String) session.getAttribute("escuela");
	ArrayList  lisCiclo	 	= new ArrayList();
	CicloLista cicloL		= new CicloLista();
	Ciclo ciclo				= new Ciclo();
	lisCiclo				= cicloL.getListActivos(conElias,escuelaId,"ORDER BY CICLO_ID");
	String sBgcolor			= "";
	
	String cicloId				= "00"; 
	String sAccion				= request.getParameter("Accion")==null?"1":request.getParameter("Accion");
	int numAccion 				= Integer.parseInt(sAccion);
	String resultado			= "";
	
	switch (numAccion){
		case 1:{			
			if (lisCiclo.size() > 0)
				resultado = "ClickNombreCarga";
			else
				resultado = "NoEncontro";
			break;
		} 
		case 2:{
			
			cicloId = request.getParameter("CicloId");				
			session.setAttribute("cicloId",cicloId);
			resultado = "RegistradoentuSesion";
			break;			
		}
	}
	pageContext.setAttribute("resultado",resultado);
%>

</head>

<body>

<div id="content">

	<h2><fmt:message key="periodos.PeriodosInscripcion" /> <small><%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></small></h2>
<%if(!resultado.equals("")){
%> 
	<div class="alert"><fmt:message key="aca.${resultado}" /></div>
<%
	} 
%>
	
	<table class="table table-condensed">
	<tr>
	  <th width="3%" align="center">#</th>
	  <th width="5%" align="center"><fmt:message key="aca.Ciclo" /></th>
	  <th width="39%" align="center"><fmt:message key="aca.Nombre" /></th>
	    <th width="9%" align="center"><fmt:message key="aca.Creada" /></th>
	    <th width="13%" align="center"><fmt:message key="aca.Inicio" /></th>
	    <th width="12%" align="center"><fmt:message key="aca.Fin" /></th>
		<th width="12%" align="center"># <fmt:message key="aca.Cursos" /></th>
		<th width="7%" align="center"><fmt:message key="aca.Estado" /></th>
		<th width="10%" align="center"><fmt:message key="aca.Escala" /></th>
	</tr>
	<%
		for (int i=0; i< lisCiclo.size(); i++){
			ciclo = (Ciclo) lisCiclo.get(i);
			
	%>				
	  <tr>
	    <td align="center">	  
		  <%=i+1 %>
		</td>
	    <td align="center"><%=ciclo.getCicloId() %></td>
	    <td>
	      <a href="javascript:SubirCiclo('<%=ciclo.getCicloId()%>')">
		  <%=ciclo.getCicloNombre() %>
		  </a>
		</td>
		<td align="center"><%=ciclo.getFCreada() %></td>
		<td align="center"><%=ciclo.getFInicial() %></td>
		<td align="center"><%=ciclo.getFFinal() %></td>
		<td align="center"><%=ciclo.getNumCursos() %></td>
		<td align="center">
<%	if (ciclo.getEstado().equals("A")){
		out.print("Activa");
%> 	
			<label><fmt:message key="aca.Activa" /></label>			
<%
				}
			
		else{ 
%> 
			<label><fmt:message key="aca.Cerrada" /></label>		
<%
			}
%>
		</td>
		<td align="center"><%=ciclo.getEscala()%>%</td>
	  </tr>  
	<%  
		}
	%>  
	
	</table>

</div>
	<script>
		function Borrar( CicloId ){
			if(confirm("<fmt:message key="aca.EliminarRegistro" />"+CicloId)==true){
		  		document.location="accion.jsp?Accion=4&CicloId="+CicloId;
		  	}
		}	
		function SubirCiclo( CicloId ){
	  		document.location="periodo.jsp?Accion=2&CicloId="+CicloId;
		}
	</script>
</body> 
<%
	lisCiclo 	= null;
	ciclo 		= null;
	cicloL		= null;
%>
<%@ include file= "../../cierra_elias.jsp" %>