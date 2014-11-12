<%@page import="aca.cont.ContCcosto"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contMascara" scope="page" class="aca.cont.ContMascara"/>
<jsp:useBean id="contCcosto" scope="page" class="aca.cont.ContCcosto"/>
<jsp:useBean id="contCcostoL" scope="page" class="aca.cont.ContCcostoLista"/>
<%
	String mascaraCta	= "";
	String respuesta	= "";
	int nivel			= 0;
	String sBgcolor	= "";

	int inicio			= 0;
	int accion			= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	ArrayList lisCcosto	= null;

	contMascara.mapeaRegId(conElias, "1");
	mascaraCta = contMascara.getMascCcosto();
	
	switch(accion){
		case 2:{	//Grabar y Modificar
			String ccostoId = "";
			for(int i = 0; i < mascaraCta.length(); i++){
				ccostoId += request.getParameter(String.valueOf(i));
			}
			contCcosto.setCcostoId(ccostoId);
			if(contCcosto.existeReg(conElias)){
				contCcosto.mapeaRegId(conElias, ccostoId);
				contCcosto.setNombre(request.getParameter("nombre"));
				if(contCcosto.updateReg(conElias)){
					respuesta = "<tr><td align=center><font size=2 color=blue><b>Se modific&oacute; correctamente el Centro de Costo!!!</b></font></td></tr>";
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al modificar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
				}
			}else{
				contCcosto.setNombre(request.getParameter("nombre"));
				contCcosto.setDetalle("N");
				if(contCcosto.insertReg(conElias)){
					respuesta = "<tr><td align=center><font size=2 color=blue><b>Se guard&oacute; correctamente el Centro de Costo!!!</b></font></td></tr>";
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al guardar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
				}
			}
		}break;
		case 3:{	//Borrar
			contCcosto.setCcostoId(request.getParameter("ccostoId"));
			if(contCcosto.deleteReg(conElias)){
				respuesta = "<tr><td align=center><font size=2 color=blue><b>Se borr&oacute; correctamente la cuenta!!!</b></font></td></tr>";
			}else{
				respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al borrar. Verifique que la cuenta no se est&eacute; usando</b></font></td></tr>";
			}
		}break;
		case 4:{	//Consultar
			contCcosto.mapeaRegId(conElias, request.getParameter("ccostoId"));
		}break;
	}
	
	lisCcosto = contCcostoL.getListAll(conElias, "ORDER BY CCOSTO_ID");
%>
<head>
	<script type="text/javascript">
		function revisa(){
			var correcto = true;
			var mascaraCta = "<%=mascaraCta %>";
			for(i = 0; i < mascaraCta.length; i++){
				if(document.getElementById(""+i).value.length != mascaraCta.charAt(i) && correcto)
					correcto = false;
			}
			if(correcto && document.forma.nombre.value != ""){
				document.forma.action += "?Accion=2";
				return true;
			}else{
				alert("Todas las casillas deben estar llenas para poder guardar!!!");
			}
			return false;
		}
		
		function borrar(ccostoId){
			if(confirm("¿Está seguro que desea borrar la cuenta?")){
				document.forma.action += "?Accion=3&ccostoId="+ccostoId;
				document.forma.submit();
			}
		}
		
		function modificar(ccostoId){
			document.forma.action += "?Accion=4&ccostoId="+ccostoId;
			document.forma.submit();
		}
		
		function saltoUp(event, id, length){
			var key;
			if(window.event){ // IE
				key = event.keyCode;
			}else if(event.which){ // Netscape/Firefox/Opera
				key = event.which;
			}
			
			if(key == 8){
				if(document.getElementById(""+id).value.length == 0){
					if(document.getElementById(""+(id-1))){
						document.getElementById(""+(id-1)).focus();
					}
				}
			}else{
				if(document.getElementById(""+id).value.length == length){
					if(document.getElementById(""+(id+1))){
						document.getElementById(""+(id+1)).focus();
					}
				}
			}
		}
		
		function saltoPress(event, id, length){
			var key;
			if(window.event){ // IE
				key = event.keyCode;
			}else if(event.which){ // Netscape/Firefox/Opera
				key = event.which;
			}
			
			if(key != 8){
				if(document.getElementById(""+id).value.length == length){
					if(document.getElementById(""+(id+1))){
						document.getElementById(""+(id+1)).focus();
						document.getElementById(""+(id+1)).value += key-48;
					}
				}
			}
		}
	</script>
</head>
<body>
	<table width="100%">
		<%=respuesta %>
		<tr>
			<td class="titulo">Centro de Costo</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<form id="forma" name="forma" action="ccosto.jsp" method="post">
		<table width="70%" align="center" style="border: dotted 1px gray;">
			<tr>
				<td align="center">ID: 
<%
	for(int i = 0; i < mascaraCta.length(); i++){
		if(accion==4){
%>
					<input type="text" value="<%=contCcosto.getCcostoId().substring(inicio, inicio+Integer.parseInt(String.valueOf(mascaraCta.charAt(i)))) %>" size="<%=mascaraCta.charAt(i) %>" maxlength="<%=mascaraCta.charAt(i) %>" Disabled />
					<input type="hidden" id="<%=i %>" name="<%=i %>" value="<%=contCcosto.getCcostoId().substring(inicio, inicio+Integer.parseInt(String.valueOf(mascaraCta.charAt(i)))) %>" />
<%
		}else{
%>
					<input type="text" id="<%=i %>" name="<%=i %>"<%=accion==4?(" value=\""+contCcosto.getCcostoId().substring(inicio, inicio+Integer.parseInt(String.valueOf(mascaraCta.charAt(i))))+"\""):"" %> onkeypress="saltoPress(event, <%=i %>, <%=mascaraCta.charAt(i) %>);" onkeyup="saltoUp(event, <%=i %>, <%=mascaraCta.charAt(i) %>);" size="<%=mascaraCta.charAt(i) %>" maxlength="<%=mascaraCta.charAt(i) %>"<%=accion==4?" Disabled":"" %> />
<%
		}
		inicio += Integer.parseInt(String.valueOf(mascaraCta.charAt(i)));
	}
%>
					&nbsp;&nbsp;
					Nombre: <input type="text" id="nombre" name="nombre"<%=accion==4?" value=\""+contCcosto.getNombre()+"\"":"" %> size="40" maxlength="50" />&nbsp;&nbsp;&nbsp;<input type="submit" value="Guardar" onclick="return revisa();" />
				</td>
			</tr>
		</table>
	</form>
	<table width="50%" align="center" border="0">
		<tr>
			<td align="center" colspan="3" style="border-bottom:dotted 1px blue">Nota</td>
		</tr>
		<tr>
			<td align="center">Nivel 1 - Asociaci&oacute;n</td>
			<td align="center">Nivel 2 - Escuelas</td>
			<td align="center">Nivel 3 - Departamentos</td>
		</tr>
	</table>
	<table width="80%" align="center">
		<tr>
			<td width="40px">&nbsp;</td>
			<th width="50px">ID</th>
			<th>Nombre</th>
			<th width="40px">Detalle</th>
			<th width="40px">Nivel</th>
		</tr>
<%
	for(int i = 0; i < lisCcosto.size(); i++){
		contCcosto = (ContCcosto) lisCcosto.get(i);
		if ((i % 2) == 1 ) sBgcolor = strColor; else sBgcolor = "";
		String identacion = "";
		
		if(Integer.parseInt(contCcosto.getCcostoId().substring(4,5)) > 0){ 
			nivel = 3;
			identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; 
		}else if(Integer.parseInt(contCcosto.getCcostoId().substring(3,5)) > 0){
			nivel = 2;
			identacion += "&nbsp;&nbsp;&nbsp;";
		}else{
			nivel = 1;
		}	
%>
		<tr <%=sBgcolor%>>
			<td>
				<img src="../../imagenes/no.gif" style="cursor: pointer;" title="Borrar" onclick="borrar('<%=contCcosto.getCcostoId() %>');" />
				<img src="../../imagenes/edit.gif" style="cursor: pointer;" title="Modificar" onclick="modificar('<%=contCcosto.getCcostoId() %>');" />
			</td>
			<td align="center"><%=contCcosto.getCcostoId() %></td>			
			<td>&nbsp;&nbsp;<%=identacion %><%=contCcosto.getNombre() %></td>			
			<td align="center"><%=contCcosto.getDetalle() %></td>
			<td align="center"><%=nivel %></td>
		</tr>
<%
	}
%>
		<tr>
			<td colspan="4" align="center"><b>Fin</b></td>
		</tr>
	</table>
</body>

<%@ include file= "../../cierra_elias.jsp" %>