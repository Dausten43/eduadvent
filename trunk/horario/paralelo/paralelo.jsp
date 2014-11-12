<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="horarioc" scope="page" class="aca.catalogo.CatHorarioCiclo"/>
<jsp:useBean id="horariocL" scope="page" class="aca.catalogo.CatHorarioCicloLista"/>
<jsp:useBean id="CatUnionU" scope="page" class="aca.catalogo.CatUnionLista"/>
<jsp:useBean id="Union" scope="page" class="aca.catalogo.CatUnion"/>

<head>
	<script>
		function Borrar( folio ){
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
		  		document.location="accion.jsp?Accion=3&folio="+folio;
		  	}
		}
	</script>
</head>
<%
	
	String escuelaId = (String) session.getAttribute("escuela");
	ArrayList<aca.catalogo.CatHorarioCiclo> horario = horariocL.getListAll(conElias, escuelaId, "ORDER BY FOLIO") ;
	int cont = 1;
%>
<body>

<div id="content">
    <h2><fmt:message key="aca.ListHorariosP" /></h2> 
    <form action="" name="forma">
	    <div class="well" style="overflow:hidden;">
	    	<a class="btn btn-primary " href="accion.jsp?folio=<%=horarioc.maximoReg(conElias, escuelaId)%>"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	    </div>
    </form>
   <table width="35%" align="center" class="table tabe-condensed">
  <tr> 
    <th width="2%">#</th>
    <th width="5%"><fmt:message key="aca.Operacion" /></th>
    <th width="2%"><fmt:message key="aca.Folio" /></th>
    <th width="30%"><fmt:message key="aca.Nombre" /></th>
   </tr>
  <%
	for (aca.catalogo.CatHorarioCiclo horarioC : horario){
		String nombre = aca.catalogo.CatEscuela.getNombre(conElias, horarioC.getEscuelaId());
%>
  <tr> 
    <td align="center"><%=cont%></td>
    <td align="center"> 
      <a class="icon-pencil" href="accion.jsp?folio=<%=horarioC.getFolio()%>"> </a> 
      <a href="javascript:Borrar('<%=horarioC.getFolio()%>')" class="icon-remove"></a> 
    </td>
    <td align="center"><%=horarioC.getFolio() %></td>
    <td align="center"><%=nombre%></a></td>
    </tr>
  <%
	cont++;}	
%>
   </table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
