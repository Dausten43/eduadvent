<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>

<head>
<script type="text/javascript" src="js/prototype-min.js"></script>
<script type="text/javascript">

	
	
	function cambiaCodigoPersonal(){
		document.location = "busca.jsp?Accion=3&matricula="+document.forma.parametroBusqueda.value;
	}
	
</script>
</head>
<% 
	String codigoId		= (String)session.getAttribute("codigoId");
	usuario.mapeaRegId(conElias, codigoId);

%>
<body>
<table align="center" width="80%" style="padding-top:50px;">
  <tr>
    <td align="center"><a href="../../cambia_clave.jsp"><strong><font size="5" face="helvetica"><img src="../../imagenes/password.png" width="30px" style="position:relative;top:4px;left:-2px;"/>Cambiar Contraseña</font></strong></a></td>
  </tr>
</table>  
</body>



<%@ include file= "../../cierra_elias.jsp" %>