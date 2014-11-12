<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<head>
	<script type="text/javascript" src="../../js/jquery-1.7.1.min.js"></script>
	<script>
    	jQuery(document).ready(function () {  
        	alert("DOM cargado");  
     	});  
	</script>	
	<title>Documento sin t&iacute;tulo</title>	
</head>
<%
	// Declaracion de variables		
%>
<body>
<form action="accion.jsp" method="post" name="frmEntidad" target="_self">
<input type="hidden" name="Accion">
<table width="50%" class="tabla" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
  <tr>
  	  <th align="center"><font size="2">Catalogo de Entidades [ <a href="entidad.jsp">Listado</a> 
        ]</font></th>
  </tr>
  <tr>
    <td>
	  <table width="100%" border="0">
        <tr> 
          <td width="15%"><strong>Clave:</strong></td>
          <td width="76%">...</td>
		</tr>
        <tr> 
          <td><strong>Nombre:</strong></td>
          <td><input name="EntidadNombre" type="text" id="EntidadNombre" value="-" size="40" maxlength="70"></td>
        </tr>
        <tr> 
          <td><strong>Referente:</strong></td>
          <td><input name="Referente" type="text" id="Referente" value="-" size="40" maxlength="70"></td>
        </tr>
        <tr> 
          <td><strong>Telefono:</strong></td>
          <td><input name="Telefono" type="text" id="Telefono" value="-" size="40" maxlength="50"></td>
        </tr>
        <tr> 
          <td><strong>Porcentaje:</strong></td>
          <td><input name="Porcentaje" type="text" id="Porcentaje" value="-" size="3" maxlength="10"></td>
        </tr>
        <tr> 
          <td colspan="2" align="center">...</td>
        </tr>
        <tr>
          <th colspan="2" align="center">-</th>
        </tr>
      </table>
	</td>
  </tr>
</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>