<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contTipo" scope="page" class="aca.cont.ContTipo"></jsp:useBean>
<script>

	function Nuevo()	{		
		document.frmTipo.Id.value 		= " ";
		document.frmTipo.nombre.value		 = " ";
		document.frmTipo.Accion.value="1";
		document.frmTipo.submit();		
	}
	
	function Grabar(){
		if(document.frmTipo.Id.value!="" && document.frmTipo.nombre!=""){			
			document.frmTipo.Accion.value="2";
			document.frmTipo.submit();			
		}else{
			alert("Complete el formulario ..! ");
		}
	}
	
	function Modificar(){
		document.frmTipo.Accion.value="3";
		document.frmTipo.submit();
	}
	
	function Borrar( ){
		if(document.frmTipo.Id.value!=""){
			if(confirm("Estas seguro de eliminar el registro!")==true){
	  			document.frmTipo.Accion.value="4";
				document.frmTipo.submit();
			}			
		}else{
			alert("Escriba la Clave !");
			document.frmTipo.numero.focus(); 
	  	}
	}
	
	function Consultar(){
		document.frmTipo.Accion.value="5";
		document.frmTipo.submit();		
	}
	
</script>
<%
	// Declaracion de variables	
	int nAccion			= Integer.parseInt(request.getParameter("Accion"));
	String sResultado		= "";
	if ( nAccion == 1 ){
		contTipo.setTipoId(contTipo.maxReg(conElias));
	}else{
		contTipo.setTipoId(request.getParameter("Id"));
	}
	// Operaciones a realizar en la pantalla	
	switch (nAccion){
		case 1: { // Nuevo			
			sResultado = "Llene el formulario correctamente ..¡¡";
			break;
		}	
		
		case 2: { // Grabar
			contTipo.setTipoId(request.getParameter("Id"));
			contTipo.setTipoNombre(request.getParameter("nombre"));
			if (contTipo.existeReg(conElias) == false){
				if (contTipo.insertReg(conElias)){
					sResultado = "<font color=blue>Grabado: "+contTipo.getTipoId()+"</font>";
					conElias.commit();
				}else{
					sResultado = "<font color=red>No Grabó: "+contTipo.getTipoId()+"</font>";
				}
			}else{
				sResultado = "<font color=red>Ya existe: "+contTipo.getTipoId()+"</font>";
			}
			
			break;
		}
		
		case 3: { // Modificar
			contTipo.setTipoId(request.getParameter("Id"));
			contTipo.setTipoNombre(request.getParameter("nombre"));
			if (contTipo.existeReg(conElias) == true){
				if (contTipo.updateReg(conElias)){
					sResultado = "<font color=blue>Modificado: "+contTipo.getTipoId()+"</font>";
					conElias.commit();
				}else{
					sResultado = "<font color=red>No Cambió: "+contTipo.getTipoId()+"</font>";
				}
			}else{
				sResultado = "<font color=red>No existe: "+contTipo.getTipoId()+"</font>";
			}
			break;
		}
		
		case 4: { // Borrar
			contTipo.setTipoId(request.getParameter("Id"));
			if (contTipo.existeReg(conElias) == true){
				if (contTipo.deleteReg(conElias)){
					sResultado = "<font color=blue>Borrado: "+contTipo.getTipoId()+"</font>";
					conElias.commit();
				}else{
					sResultado = "<font color=red>No Borró: "+contTipo.getTipoId()+"</font>";
				}	
			}else{
				sResultado = "<font color=red>No existe: "+contTipo.getTipoId()+"</font>";
			}
			break;
		}
		
		case 5: { // Consultar	
			contTipo.setTipoId(request.getParameter("Id"));
			contTipo.setTipoNombre(request.getParameter("nombre"));
			if (contTipo.existeReg(conElias) == true){
				contTipo.mapeaRegId(conElias, request.getParameter("Id"));
				sResultado = "<b>Consulta</b>";
			}else{
				sResultado = "<font color=red>No existe: "+contTipo.getTipoId()+"</font>"; 
			}	
			break;			
		}
	}	
%>
<html>
<head><title>Documento sin t&iacute;tulo</title></head>
<form action="accion.jsp" method="post" name="frmTipo" target="_self">
<input type="hidden" name="Accion">
<table class="goback">
	<tr>
		<td><a href="auxiliar.jsp">&lsaquo;&lsaquo; Regresar</a></td>
	</tr>
</table>
<table width="50%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
  <tr>
  	  <th align="center"><font size="2">Añadir Nuevo [ <a href="auxiliar.jsp">Listado</a> 
        ]</font></th>
  </tr>
  <tr>
    <td>
	  <table width="100%" border="0">
        <tr> 
          <td width="15%"><strong>Id:</strong></td>
          <td width="76%"><input name="Id" type="text" class="text" id="Id" size="3" maxlength="3" value="<%=contTipo.getTipoId()%>"></td>			
        </tr>
        <tr> 
          <td><strong>Nombre:</strong></td>
          <td><input name="nombre" type="text" class="text" id="nombre" size="40" maxlength="40" value="<%=contTipo.getTipoNombre()%>"></td>
        </tr>
        <tr> 
          <td colspan="2" align="center"><font size="2"><b><%=sResultado %></b></font></td>
        </tr>
        <tr>
          <th colspan="2" align="center">
<%
	if(nAccion != 1){
%>
		  <a href="javascript:Nuevo()">Nuevo</a> &nbsp;
<%
	}
	if(nAccion == 1){
%>
		  <a href="javascript:Grabar()">Grabar</a> &nbsp;
<%
	}else if(nAccion != 4){
%> 
		  <a href="javascript:Modificar()">Modificar</a> &nbsp;
<%
	}
%>
		  <!-- a href="javascript:Borrar()">Borrar</a> &nbsp;
		  <a href="javascript:Consultar()">Consultar</a>  -->
		  </th>
        </tr>
      </table>
	</td>
  </tr>
</table>
</form>
</body>
</html>
<%@ include file= "../../cierra_elias.jsp" %>
