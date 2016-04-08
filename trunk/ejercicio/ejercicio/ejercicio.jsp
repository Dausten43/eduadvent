<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="aca.cont.ContEjercicio"%>
<jsp:useBean id="ejercicio" scope="page" class="aca.cont.ContEjercicio"/>
<jsp:useBean id="ejercicioL" scope="page" class="aca.cont.ContEjercicioLista"/>

<head>
	<script type="text/javascript">
		function Grabar(){
			if(document.frmEjercicio.EjercicioId.value	!= ""){
				document.frmEjercicio.Accion.value	= "2";
				document.frmEjercicio.submit();
			}else{
				alert('Ingresa todos los datos');
			}
		}
		
		function Nuevo(){
			document.frmEjercicio.EjercicioId.value	= "";
			document.frmEjercicio.Nombre.value = "";
			document.frmEjercicio.Estado.value = "A";
			document.frmEjercicio.Accion.value = "1";
			document.frmEjercicio.submit();
		}
		
		function Modificar(){
			document.frmEjercicio.Accion.value	= "5";
			document.frmEjercicio.submit();
		}
		
		
	function Consultar(){
		document.frmReligion.Accion.value="4";
		document.frmReligion.submit();		
	}
	</script>
</head>
<%	
	String sResultado		= "";
	String strAccion 		= request.getParameter("Accion");
	if (strAccion == null) 
		strAccion = "0";
	int nAccion				= Integer.parseInt(strAccion);
	ArrayList lisEjercicio		= new ArrayList();
	lisEjercicio			= ejercicioL.getListAll(conElias, "ORDER BY 1");
	
	// Operaciones a realizar en la pantalla	
	switch (nAccion){
		case 1: { // Nuevo			
			sResultado = "Llene el formulario correctamente ..¡¡";
			break;
		}
	
		case 2: { 	// Grabar
			ejercicio.setEjercicioId(request.getParameter("EjercicioId"));
			ejercicio.setEjercicioNombre(request.getParameter("Nombre"));
			ejercicio.setEstado(request.getParameter("Estado"));
				if(ejercicio.existeReg(conElias) == false){
					if(ejercicio.insertReg(conElias)){
						sResultado = "Grabado: "+ejercicio.getEjercicioId();
						conElias.commit();
					}else{
						sResultado = "No Grabo: "+ejercicio.getEjercicioId();
					}
				}else{
					sResultado = "Ya Existe: "+ejercicio.getEjercicioId();
				}
		break;
		}
		
		case 3:{ // Borrar
			ejercicio.setEjercicioId(request.getParameter("EjercicioId"));
			ejercicio.setEjercicioNombre(request.getParameter("Nombre"));
			ejercicio.setEstado(request.getParameter("Estado"));
			if(ejercicio.existeReg(conElias) == true){
				if(ejercicio.deleteReg(conElias)){
					sResultado = "Borrado: "+ejercicio.getEjercicioId();
					conElias.commit();
				}else{
					sResultado = "No Borro: "+ejercicio.getEjercicioId();
				}
			}else{
				sResultado = "No Existe: "+ejercicio.getEjercicioId();
			}
		break;
		}
		
		case 4: { // Consultar	
			ejercicio.setEjercicioId(request.getParameter("EjercicioId"));
			ejercicio.setEjercicioNombre(request.getParameter("Nombre"));
			ejercicio.setEstado(request.getParameter("Estado"));
			if (ejercicio.existeReg(conElias) == true){
				ejercicio.mapeaRegId(conElias, request.getParameter("EjercicioId"));							
				sResultado = "Consulta";
			}else{
				sResultado = "No existe: "+ejercicio.getEjercicioId();
			}	
			break;			
		}
		
		case 5:{ // Actualizar
			ejercicio.setEjercicioId(request.getParameter("EjercicioId"));
			ejercicio.setEjercicioNombre(request.getParameter("Nombre"));
			ejercicio.setEstado(request.getParameter("Estado"));	
			if(ejercicio.existeReg(conElias)== true){
				if(ejercicio.updateReg(conElias)){
					sResultado = "Modificado: "+ejercicio.getEjercicioId();
					conElias.commit();
				}else{
					sResultado = "No cambio: "+ejercicio.getEjercicioId();
				}
			}else{
				sResultado = "No Existe: "+ejercicio.getEjercicioId();
			}
		}
	}
%>
<body>
<font color="black">
<h1 align="center">Ejercicios Contables</h1>
</font>
<form action="ejercicio.jsp" method="post" name="frmEjercicio" target="_self">
<input type="hidden" name="Accion" id="Accion">
<table width="40%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
  <tr>
  	  <th align="center"><font size="2">Ejercicios</font></th>
  </tr>
  <tr>
    <td>
	  <table width="100%" cellpadding="0">
		 <td width="14%" height="26"><strong>Id:</strong></td>
            <td><input name="EjercicioId" id="EjercicioId" size="5" type="text" value="<%=ejercicio.getEjercicioId()%>"></td>            
		  	<tr>	  		
		  		<td height="27"><strong>Nombre:</strong></td>
		  		 <td><input name="Nombre" type="text" id="Nombre" size="20" maxlength="40" value="<%=ejercicio.getEjercicioNombre()%>"></td>
		  	</tr>
		  	<tr>
		  		<td height="28"><strong>Estado:</strong></td>
	            <td>
		            <select name="Estado">
		            	<option value="A">Activo</option>
		            	<option value="I">Inactivo</option>
		            </select>
	            </td>
		  	</tr>
		  	 <tr> 
            <td colspan="2" align="center"><%=sResultado%></td>
          </tr>		  	
          <tr> 
            <td colspan="4" align="center">             
            	<input type="button" value="Nuevo" id="nuevo" onclick="javascript:Nuevo()" style="cursor:pointer"/>
            	<input type="button" value="Grabar" id="grabar" onclick="javascript:Grabar()" style="cursor:pointer"/>              
            	<input type="button" value="Modificar" id="modificar" onclick="javascript:Modificar()" style="cursor:pointer"/>
            </td>
          </tr>	
	  </table>
	</td>
  </tr>
</table>
</form>
<br>
<br>
<table width="40%" border="0" align="center">
  <tr align="center"> 
    <td colspan="5"><strong><font size="3">Listado de Ejercicios</strong> </td>
  </tr>
  <tr> 
    <th width="1%">Operacion</th>
    <th width="15%">Id</th>
    <th width="30%">Nombre</th> 
    <th width="10%">Estado</th>    
 </tr>
<%
	for (int i=0; i< lisEjercicio.size(); i++){
		aca.cont.ContEjercicio ejer = (aca.cont.ContEjercicio) lisEjercicio.get(i);
%>
  
  <tr> 
    <td align="center"> <a href="ejercicio.jsp?Accion=4&EjercicioId=<%=ejer.getEjercicioId()%>&Nombre=<%=ejer.getEjercicioNombre()%>&Estado=<%=ejer.getEstado() %>"> 
      <img src="../../imagenes/editar.gif" alt="Modificar" border="0"></a> 
      <a href="ejercicio.jsp?Accion=3&EjercicioId=<%=ejer.getEjercicioId()%>&Nombre=<%=ejer.getEjercicioNombre()%>&Estado=<%=ejer.getEstado() %> onclick="javascript:Borrar()"><img src="../../imagenes/no.gif" alt="Eliminar" border="0"></a>      
    </td>
    <td align="center"><%=ejer.getEjercicioId()%> </td>
    <td align="center"><%=ejer.getEjercicioNombre() %></td>    
    <td align="center"><%=ejer.getEstado() %></td>
    </tr>
<%
	}	

%>
</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %>