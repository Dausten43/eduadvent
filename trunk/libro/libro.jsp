<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="Libro" scope="page" class="aca.cont.ContLibroLista"/>

<%
	ArrayList lisLibro				= new ArrayList();
	lisLibro 					= nivelLista.getListAll(conElias," ORDER BY LIBRO_NOMBRE");
%>
<head>
	<script>
		function Borrar( LibroId ){
			if(confirm("Estas seguro de eliminar el registro: "+LibroId)==true){
		  		document.location="accion.jsp?Accion=3&NivelId="+LibroId;
		  	}
		}
	</script>
	<title>Documento sin t&iacute;tulo</title>
</head>
<body>
<table width="60%" border="0" align="center">
  <tr align="center"> 
    <td colspan="3"><strong><font size="3">Libros Contables [</font>
		<a href="accion.jsp?Accion=1">A&ntilde;adir</a> 
		<font size="3">]</font></strong>
	</td>
  </tr>
  <tr> 
    <th width="20%">Operacion</th>
    <th width="10%">#</th>
    <th width="70%">Descripcion</th>    
  </tr>
<%
	for (int i=0; i< lisLibro.size(); i++){
		aca.cont.ContLibro libro = (aca.cont.ContLibro) lisLibro.get(i);
%>  
  <tr> 
    <td align="center">
	  <a href="accion.jsp?Accion=4&NivelId=<%=nivel.getLibroId()%>">
	  	<img src="../../imagenes/editar.gif" alt="Modificar" border="0">
	  </a>
	  <a href="javascript:Borrar('<%=libro.getLibroId()%>')">
	    <img src="../../imagenes/no.gif" alt="Eliminar" border="0">
	  </a>
	</td>
    <td align="center"><%=libro.getLibroId() %></td>
    <td><%=libro.getLibroNombre()%></td>    
  </tr>
<%
	}	
	libroLista	= null;
	lisLibro	= null;
%>  
</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
