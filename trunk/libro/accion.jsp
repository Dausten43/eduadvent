<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivel"/>
<head>
	<script>
		
		function Nuevo()	{		
			document.frmNivel.NivelId.value 		= " ";
			document.frmNivel.NivelNombre.value 	= " ";
			document.frmNivel.Accion.value="1";
			document.frmNivel.submit();		
		}
		
		function Grabar(){
			if(document.frmNivel.NivelId.value!="" && document.frmNivel.NivelNombre!=""){			
				document.frmNivel.Accion.value="2";
				document.frmNivel.submit();			
			}else{
				alert("Complete el formulario ..! ");
			}
		}
		
		function Modificar(){
			document.frmNivel.Accion.value="3";
			document.frmNivel.submit();
		}
		
		function Borrar( ){
			if(document.frmNivel.NivelId.value!=""){
				if(confirm("Estas seguro de eliminar el registro!")==true){
		  			document.frmNivel.Accion.value="4";
					document.frmNivel.submit();
				}			
			}else{
				alert("Escriba la Clave !");
				document.frmNivel.NivelId.focus(); 
		  	}
		}
		
		function Consultar(){
			document.frmNivel.Accion.value="5";
			document.frmNivel.submit();		
		}
		
	</script>
	<title>Documento sin t&iacute;tulo</title>
</head>
<%
	// Declaracion de variables	
	int nAccion			= Integer.parseInt(request.getParameter("Accion"));
	String sResultado		= "";
	
	if ( nAccion == 1 )
		Nivel.setNivelId(Nivel.maximoReg(conElias));
	else
		Nivel.setNivelId(request.getParameter("NivelId"));
		
	// Operaciones a realizar en la pantalla	
	switch (nAccion){
		case 1: { // Nuevo			
			sResultado = "Llene el formulario correctamente ..¡¡";
			break;
		}		
		case 2: { // Grabar
			Nivel.setNivelNombre(request.getParameter("NivelNombre"));
			Nivel.setGradoIni(request.getParameter("GradoIni"));
			Nivel.setGradoFin(request.getParameter("GradoFin"));
			
			if (Nivel.existeReg(conElias) == false){
				if (Nivel.insertReg(conElias)){
					sResultado = "Grabado: "+Nivel.getNivelId();
				}else{
					sResultado = "No Grabó: "+Nivel.getNivelId();
				}
			}else{
				sResultado = "Ya existe: "+Nivel.getNivelId();
			}
			
			break;
		}
		case 3: { // Modificar
			Nivel.setNivelNombre(request.getParameter("NivelNombre"));
			Nivel.setGradoIni(request.getParameter("GradoIni"));
			Nivel.setGradoFin(request.getParameter("GradoFin"));
			
			if (Nivel.existeReg(conElias) == true){
				if (Nivel.updateReg(conElias)){
					sResultado = "Modificado: "+Nivel.getNivelId();
				}else{
					sResultado = "No Cambió: "+Nivel.getNivelId();
				}
			}else{
				sResultado = "No existe: "+Nivel.getNivelId();
			}
			break;
		}
		case 4: { // Borrar
			if (Nivel.existeReg(conElias) == true){
				if (Nivel.deleteReg(conElias)){
					sResultado = "Borrado: "+Nivel.getNivelId();
				}else{
					sResultado = "No Borró: "+Nivel.getNivelId();
				}	
			}else{
				sResultado = "No existe: "+Nivel.getNivelId();
			}
			break;
		}
		case 5: { // Consultar			
			if (Nivel.existeReg(conElias) == true){
				Nivel.mapeaRegId(conElias, request.getParameter("NivelId"));
				sResultado = "Consulta";
			}else{
				sResultado = "No existe: "+Nivel.getNivelId(); 
			}	
			break;			
		}
	}	
%>
<body>
<form action="accion.jsp" method="post" name="frmNivel" target="_self">
<input type="hidden" name="Accion">
<table width="50%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
  <tr>
  	  <th align="center"><font size="2">Catalogo de Niveles [ <a href="nivel.jsp">Listado</a> 
        ]</font></th>
  </tr>
  <tr>
    <td>
	  <table width="100%" border="0">
        <tr> 
          <td width="15%"><strong>Clave:</strong></td>
          <td width="76%"><input name="NivelId" type="text" id="NivelId" size="3" maxlength="3" value="<%=Nivel.getNivelId()%>"></td>
		</tr>
        <tr> 
          <td><strong>Nombre:</strong></td>
          <td><input name="NivelNombre" type="text" id="NivelNombre" value="<%=Nivel.getNivelNombre()%>" size="40" maxlength="20"></td>
        </tr>
        <tr> 
          <td><strong>Rango de Grados:</strong></td>
          <td>
            De <input name="GradoIni" type="text" id="GradoIni" value="<%=Nivel.getGradoIni()%>" size="3" maxlength="3"> a
            <input name="GradoFin" type="text" id="GradoFin" value="<%=Nivel.getGradoFin()%>" size="3" maxlength="3">
          </td>
        </tr>        
        <tr> 
          <td colspan="2" align="center"><%=sResultado%></td>
        </tr>
        <tr>
          <th colspan="2" align="center"> 
		  <a href="javascript:Nuevo()">Nuevo</a> &nbsp;<a href="javascript:Grabar()">Grabar</a> &nbsp; 
		  <a href="javascript:Modificar()">Modificar</a> &nbsp; <a href="javascript:Borrar()">Borrar</a> &nbsp;
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
