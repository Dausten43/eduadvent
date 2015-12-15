<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<script src='../../js/jquery-1.7.1.min.js'></script>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="empLista" scope="page" class="aca.empleado.EmpPersonalLista"/>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String unionId			= aca.catalogo.CatEscuela.getUnionId(conElias, escuelaId);
	String fileJsp			= "credencialPDF"+unionId+".jsp";

	int contador			= 0;

	ArrayList<aca.empleado.EmpPersonal> lisEmpleados = null;
	
	String dirFoto = application.getRealPath("/empleado/credencial/"+fileJsp);
	java.io.File formato = new java.io.File(dirFoto);
	Boolean tieneFormato=false;
	if (formato.exists()){
		tieneFormato = true;
	}	
%>
<head>
	<script type="text/javascript">	
		
		function generarCredenciales(archivo){
			var inputs		= document.getElementsByTagName("INPUT");
			var codigos		= "";
			var selecciono	= false;
			var contador	= 0;
			
			for(i = 0; i < inputs.length; i++){
				if(inputs[i].type == "checkbox"){
					if(inputs[i].checked){
						contador++;
						codigos+="&codigo-" + contador + "=" + inputs[i].value + "\n";
					}
				}
			}
			codigos = "cantidad=" + contador + codigos;
			
			if(contador > 0){
				document.location.href = archivo+"?"+codigos;
			}else{
				alert("<fmt:message key="aca.SeleccioneAlumno" />");
			}
		}
		
		
		function check(){			
			var chksboxs = jQuery('.chkbx');
			
			if(chksboxs.prop('checked')  === false ){
				chksboxs.prop('checked', true);
			}else{
				chksboxs.prop('checked', false);				
			}
		}
	</script>
</head>
<body>
<div id="content">
<h2><fmt:message key="empleados.ListadodeEmpleados" /></h2>


<div class="well" style="overflow:hidden;">
<%if(tieneFormato==true){%>
	<button class="btn btn-primary" onclick="generarCredenciales('<%=fileJsp%>');" ><i class="icon-th icon-white"></i> <fmt:message key="boton.GenerarCredenciales" /></button>
<%}
else{%>
	<button class="btn btn-primary" onclick="alert('No tiene formato.');" ><i class="icon-th icon-white"></i> <fmt:message key="boton.GenerarCredenciales" /></button>
<%}
%>
</div>

	<table width="70%" align="center" class="table table-striped">
	  <tr>
	  	<th width="20px" align="center">#</th>
		<th width="50px" align="center" ><input  class="btn btn-small btn-info" type="button" class="btn" onclick="check();" value="Todos"></th>
		<th width="80px" align="center"><b><fmt:message key="aca.Codigo" /></b></th>
		<th align="center"><b><fmt:message key="empleados.NombreDelEmpleado" /></b></th>
	  </tr>
<%
		lisEmpleados = empLista.getListEmpActivos(conElias, escuelaId, "ORDER BY APATERNO, AMATERNO, NOMBRE");

		for(int l = 0; l < lisEmpleados.size(); l++){
			empPersonal = (aca.empleado.EmpPersonal) lisEmpleados.get(l);
%>	  
	  <tr>
	  	<td style="text-align:center;"><b><%=l+1%></b></td>
		<td style="text-align:center;"><input class="chkbx" type="checkbox" id="codigo-<%=contador %>" name="codigo-<%=contador %>" value="<%=empPersonal.getCodigoId() %>" /></td>
		<td align="center"><%=empPersonal.getCodigoId() %></td>
		<td><%=empPersonal.getApaterno() %> <%=empPersonal.getAmaterno() %> <%=empPersonal.getNombre() %></td>
	  </tr>
<%			
			contador++;
		}
%>	
		<tr>
			<td style="text-align:center;" colspan="3"></td>
		</tr>
	</table>
</div>	
</body>
<%@ include file="../../cierra_elias.jsp" %>