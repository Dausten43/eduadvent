<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="Libro" scope="page" class="aca.cont.ContLibro"/>
<head>
	<script>
		
		function Nuevo()	{		
			document.frmLibro.LibroId.value 		= " ";
			document.frmLibro.LibroNombre.value 	= " ";
			document.frmLibro.Accion.value="1";
			document.frmLibro.submit();		
		}
		
		function Grabar(){
			if(document.frmLibro.LibroId.value!="" && document.frmLibro.LibroNombre!=""){			
				document.frmLibro.Accion.value="2";
				document.frmLibro.submit();			
			}else{
				alert("Complete el formulario ..! ");
			}
		}		
		
		function Borrar( ){
			if(document.frmLibro.LibroId.value!=""){
				if(confirm("Estas seguro de eliminar el registro!")==true){
		  			document.frmLibro.Accion.value="3";
					document.frmLibro.submit();
				}			
			}else{
				alert("Escriba la Clave !");
				document.frmLibro.LibroId.focus(); 
		  	}
		}
		
		function Consultar(){
			document.frmLibro.Accion.value="4";
			document.frmLibro.submit();		
		}
		
	</script>
	<title>Documento sin t&iacute;tulo</title>
</head>
<%
	// Declaracion de variables	
	int nAccion			= Integer.parseInt(request.getParameter("Accion"));
	String sResultado		= "";
	
	if ( nAccion == 1 )
		Libro.setLibroId(Libro.maxReg(conElias));
	else
		Libro.setLibroId(request.getParameter("LibroId"));
		
	// Operaciones a realizar en la pantalla	
	switch (nAccion){
		case 1: { // Nuevo			
			sResultado = "Llene el formulario correctamente ..¡¡";
			break;
		}		
		case 2: { // Grabar y Modificar
			Libro.setLibroNombre(request.getParameter("LibroNombre"));
			
			if (Libro.existeReg(conElias) == false){
				if (Libro.insertReg(conElias)){
					sResultado = "Grabado: "+Libro.getLibroId();
					conElias.commit();
				}else{
					sResultado = "No Grabó: "+Libro.getLibroId();
				}
			}else{
				if (Libro.updateReg(conElias)){
					sResultado = "Modificado: "+Libro.getLibroId();
					conElias.commit();
				}else{
					sResultado = "No Cambió: "+Libro.getLibroId();
				}				
			}
			
			break;
		}
		case 3: { // Borrar
			if (Libro.existeReg(conElias) == true){
				if (Libro.deleteReg(conElias)){
					sResultado = "Borrado: "+Libro.getLibroId();
					conElias.commit();
				}else{
					sResultado = "No Borró: "+Libro.getLibroId();
				}	
			}else{
				sResultado = "No existe: "+Libro.getLibroId();
			}
			break;
		}
		case 4: { // Consultar			
			if (Libro.existeReg(conElias) == true){
				Libro.mapeaRegId(conElias, request.getParameter("LibroId"));
				sResultado = "Consulta";
			}else{
				sResultado = "No existe: "+Libro.getLibroId(); 
			}	
			break;			
		}
	}	
%>
<body>
<form action="accion.jsp" method="post" name="frmLibro" target="_self">
<input type="hidden" name="Accion">
<table width="50%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
  <tr>
  	  <th align="center"><font size="2">Catalogo de Libros [ <a href="libro.jsp">Listado</a> 
        ]</font></th>
  </tr>
  <tr>
    <td>
	  <table width="100%" border="0">
        <tr> 
          <td width="15%"><strong>Clave:</strong></td>
          <td width="76%"><input name="LibroId" type="text" id="LibroId" size="3" maxlength="3" value="<%=Libro.getLibroId()%>"></td>
		</tr>
        <tr> 
          <td><strong>Nombre:</strong></td>
          <td><input name="LibroNombre" type="text" id="LibroNombre" value="<%=Libro.getLibroNombre()%>" size="40" maxlength="20"></td>
        </tr>                
        <tr> 
          <td colspan="2" align="center"><%=sResultado%></td>
        </tr>
        <tr>
          <th colspan="2" align="center"> 
		  <a href="javascript:Nuevo()">Nuevo</a> &nbsp;
		  <a href="javascript:Grabar()">Grabar</a> &nbsp;
		  <a href="javascript:Borrar()">Borrar</a> &nbsp;
		  <a href="javascript:Consultar()">Consultar</a>
		  </th>
        </tr>
      </table>
	</td>
  </tr>
</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>
