<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="empleado" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="empleadoLista" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="modulo" scope="page" class="aca.menu.Modulo"/>
<jsp:useBean id="moduloOpcion" scope="page" class="aca.menu.ModuloOpcion"/>

<head>
	<script>
	
		function Consultar(){
			document.frmalumno.Accion.value="1";
			document.frmalumno.submit();
		}
		
		function BuscarNombre( ){
			if (document.frmnombre.Nombre.value!="" || document.frmnombre.Paterno.value!="" || document.frmnombre.Materno.value!=""){
				document.frmnombre.Accion.value="1";
				document.frmnombre.submit();
			}else{
				alert(" Es necesario por lo menos un dato..¡¡");
				document.frmnombre.Nombre.focus();
			}
		}
		
		function BuscarCodigo( ){
			if(document.frmcodigo.CodigoPersonal.value!=""){
				document.frmcodigo.Accion.value="2";
				document.frmcodigo.submit();
			}else{
				alert("Ingrese el Código..! ");
				document.frmcodigo.CodigoPersonal.focus();
			}
		}
		
		function SubirCodigo( CodigoPersonal ){
		  		document.location="buscar.jsp?Accion=3&CodigoPersonal="+CodigoPersonal;
		}	
	</script>
</head>
<%
	String escuelaId		= (String) session.getAttribute("escuela");	
	String idJspOrigen		= (String) session.getAttribute("idJsp");
	
	String sAccion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	int nAccion 			= Integer.parseInt(sAccion);
	
	String origen			= "";	
	String carpeta 			= "";
	String menu 			= "";
	String salto 			= "X";
	
	//Obtiene la opción del menu que mando llamar la busqueda
	moduloOpcion.setOpcionId(idJspOrigen);
	if (moduloOpcion.existeOpcion(conElias)){
		moduloOpcion.mapeaRegId(conElias, idJspOrigen);
		modulo.mapeaRegId(conElias, moduloOpcion.getModuloId());
		origen 		= modulo.getUrl()+moduloOpcion.getUrl();
		menu		= modulo.getModuloId();
		carpeta 	= modulo.getUrl();
	}
	
	String strResultado		= "Elija la opción de Consulta";
	String strBgcolor		= "";
	String strNombre 		= "";
	String strPaterno		= "";
	String strMaterno		= "";
	
	ArrayList<aca.empleado.EmpPersonal> lisEmpleado	= new ArrayList<aca.empleado.EmpPersonal>();
	
	switch (nAccion){
		case 1:{
			strNombre		= request.getParameter("Nombre");
			strPaterno		= request.getParameter("Paterno");
			strMaterno		= request.getParameter("Materno");
			if (strNombre == null) strNombre = "";
			if (strPaterno== null) strPaterno = "";
			if (strMaterno== null) strMaterno = "";
			lisEmpleado = empleadoLista.getArrayList(conElias, escuelaId, strNombre, strPaterno, strMaterno,"ORDER BY 3,4,5");
			if (lisEmpleado.size() > 0)
				strResultado	= "Click sobre el nombre del empleado";
			else
				strResultado = "No encontro..¡¡";
			break;
		} 
		case 2:{
			empleado.setCodigoId(request.getParameter("CodigoPersonal"));
			if (empleado.existeReg(conElias) == true && request.getParameter("CodigoPersonal").substring(0,3).equals(escuelaId.length()==1?("0"+escuelaId):escuelaId)){
				empleado.mapeaRegId(conElias, request.getParameter("CodigoPersonal"));
				strResultado = "Click sobre el nombre del empleado";
			}else{
				strResultado = "No existe: "+empleado.getCodigoId();
			}
			break;
		}
		case 3:{
			session.setAttribute("codigoPadre", request.getParameter("CodigoPersonal"));
			session.setAttribute("codigoReciente", request.getParameter("CodigoPersonal"));
			strResultado = "Registrado en tú sesión: "+request.getParameter("CodigoPersonal");
			
			if(origen.equals(""))origen="general/inicio/index.jsp";
			if(!origen.equals("X"))salto = "../../"+origen;
		}
	}
	
	if(((String)session.getAttribute("codigoId")).contains("E") || ((String)session.getAttribute("codigoId")).equals("B01P0002") || session.getAttribute("admin").equals("B01P0002")){
%>

<div id="content">
	<h3>Escuela: <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></h3>
<%		if(!origen.equals("X") && !carpeta.equals("X")){%>
	<div class="well">
    	<a class="btn" href="../../<%=origen%>?moduloId=<%=menu%>&carpeta=<%=carpeta%>"><strong>R e g r e s a r</strong></a>
	</div>  
<%		}%>

	<form name="frmnombre" method="POST" action="buscar.jsp?Accion=1">
	<input name="Accion" type="hidden">
	<table align='CENTER' class="table table-condensed">
	<tr>
    	<th align="CENTER">B&uacute;squeda por Nombre</th>
  	</tr>

  	<tr align='CENTER'>
    	<td>Nom.  
			<input type="Text" name="Nombre" size="3" maxlength="15">
		Pat. 
			<input type="Text" name="Paterno" size="3" maxlength="15">
		Mat.
			<input type="Text" name="Materno" size="3" maxlength="15">
			<a class="btn" href="javascript:BuscarNombre()">Buscar</a>
		</td>
  	</tr>
  	<tr>
   		<th align="CENTER">B&uacute;squeda por C&oacute;digo</th>
  	</tr>
  	</table>
  	</form>
	<form name="frmcodigo" method="POST" action="buscar.jsp?Accion=2">
	<input name="Accion" type="hidden">
	<table align='CENTER' class="table table-condensed">
  	<tr align='CENTER'> 		
    	<td> C&oacute;digo: 
      		<input type="Text" name="CodigoPersonal" id="CodigoPersonal" size="8" maxlength="8">
      		<a class="btn" href="javascript:BuscarCodigo()">Buscar</a>
		</td>
  	</tr>
  	</table>
	</form>
	<br>
	<table class="table table-condensed table-striped" width="50%" border="0" align="center">
	<tr>
  		<td width="7%" align="center" colspan="3"><font size="2"><strong>Mensaje: </strong> <%=strResultado%></font></tr>
	<tr>
  		<th width="7%" align="center">#</th>
  		<th width="18%" align="center">Codigo</th>
  		<th width="75%" align="center">Nombre</th>
	</tr>
<%
	switch (nAccion){
		case 1:{
			for (int i=0; i< lisEmpleado.size(); i++){
				empleado = (aca.empleado.EmpPersonal) lisEmpleado.get(i);
%>				
  	<tr>
    	<td align="center">
	  	<%=i+1%>
		</td>
    	<td align="center"><%=empleado.getCodigoId()%></td>
    	<td>
	  		<a href="javascript:SubirCodigo('<%=empleado.getCodigoId()%>')">
	  		<%=empleado.getNombre()%>&nbsp;<%=empleado.getApaterno()%>&nbsp;<%=empleado.getAmaterno()%>
	  		</a>
		</td>
  	</tr>  
<%				if(lisEmpleado.size()==1){
					empleado = (aca.empleado.EmpPersonal) lisEmpleado.get(0);
					session.setAttribute("codigoEmpleado", empleado.getCodigoId());
					session.setAttribute("codigoReciente", empleado.getCodigoId());
					strResultado = "Registrado en tú sesión: "+empleado.getCodigoId();
					if( !origen.equals("X") && !carpeta.equals("X"))					
					salto = "../../"+origen+"?moduloId="+menu+"&carpeta="+carpeta;
				}
			}	
			break;
		} 
		case 2:{
			empleado.setCodigoId(request.getParameter("CodigoPersonal"));
			if (!request.getParameter("CodigoPersonal").substring(0,3).equals(escuelaId.length()==1?("0"+escuelaId):escuelaId) || !empleado.existeReg(conElias)) break;
%>		
	<tr> 
    	<td align="center">	  
	  	<%out.print("1"); %>
		</td>
    	<td align="center"><%=empleado.getCodigoId()%></td>
    	<td>
	  	<a href="javascript:SubirCodigo('<%=empleado.getCodigoId()%>')">
	  		<%=empleado.getNombre()%>&nbsp;<%=empleado.getApaterno()%>&nbsp;<%=empleado.getAmaterno()%>
	  	</a>
		</td>
  	</tr>	
<%  		
			session.setAttribute("codigoEmpleado", empleado.getCodigoId());
			session.setAttribute("codigoReciente", empleado.getCodigoId());
			strResultado = "Registrado en tú sesión: "+empleado.getCodigoId();
			if( !origen.equals("X") && !carpeta.equals("X"))
				salto = "../../"+origen;
			break;
		}
	}
%>  
	</table>
</div>
<%
	}
	lisEmpleado 	= null;
%>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp"%>