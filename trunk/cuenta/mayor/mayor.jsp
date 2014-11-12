<%@page import="aca.cont.ContMayor"%>

<%@ include file= "../../con_elias.jsp"%>
<%@ include file= "id.jsp"%>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp"%>

<jsp:useBean id="contMayor" scope="page" class="aca.cont.ContMayor"/>
<jsp:useBean id="contMayorL" scope="page" class="aca.cont.ContMayorLista"/>
<jsp:useBean id="contMascara" scope="page" class="aca.cont.ContMascara"/>
<%  
	String tipoCta 		= request.getParameter("tipoCta")==null?"B":request.getParameter("tipoCta");
	String mascaraCta	= "";
	String respuesta	= "";
	String detalleChk	= "";
	String detalle 		= "";
	int nivel			= 0;
	String sBgcolor	= "";
	int cont		= 0;
	
	int accion			= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	ArrayList lisMayor 	= null;
	
	contMascara.mapeaRegId(conElias, "1");
	mascaraCta = tipoCta.equals("B")?contMascara.getMascBalance():contMascara.getMascResultado();
	
	switch(accion){
		case 2:{	//Grabar y Modificar
			String mayorId = "";			
			for(int i = 0; i < mascaraCta.length(); i++){
				mayorId += request.getParameter(String.valueOf(i));
			}
			if (request.getParameter("detalle")==null) detalle = "N"; else detalle = "S";
			contMayor.setMayorId(mayorId);
			contMayor.setTipoCta(tipoCta);			
			if(contMayor.existeReg(conElias)){				
				contMayor.mapeaRegId(conElias, mayorId);
				contMayor.setMayorNombre(request.getParameter("nombre"));
				contMayor.setDetalle(detalle);	 
				contMayor.setNaturaleza(request.getParameter("naturaleza"));				
				if(contMayor.updateReg(conElias)){
					respuesta = "<tr><td align=center><font size=2 color=blue><b>Se modific&oacute; correctamente la cuenta!!!</b></font></td></tr>";
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al modificar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
				}
			}else{
				contMayor.setMayorNombre(request.getParameter("nombre"));
				contMayor.setDetalle(detalle);
				contMayor.setNaturaleza(request.getParameter("naturaleza"));
				if(contMayor.insertReg(conElias)){
					respuesta = "<tr><td align=center><font size=2 color=blue><b>Se guard&oacute; correctamente la cuenta!!!</b></font></td></tr>";
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al guardar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
				}
			}
		}break;
		case 3:{	//Borrar
			contMayor.setMayorId(request.getParameter("mayorId"));
			contMayor.setTipoCta(request.getParameter("tipoId"));
			if(contMayor.deleteReg(conElias)){
				respuesta = "<tr><td align=center><font size=2 color=blue><b>Se borr&oacute; correctamente la cuenta!!!</b></font></td></tr>";
			}else{
				respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al borrar. Verifique que la cuenta no se est&eacute; usando</b></font></td></tr>";
			}
		}break;
		case 4:{	//Consultar
			contMayor.mapeaRegId(conElias, request.getParameter("mayorId"));
			if (contMayor.getDetalle().equals("S")) detalleChk = "checked"; else detalleChk = "";  
		}break;
	}	
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
		
		function borrar(mayorId, tipoCta){
			if(confirm("¿Está seguro que desea borrar la cuenta?")){
				document.forma.action += "?Accion=3&mayorId="+mayorId+"&tipoId="+tipoCta;
				document.forma.submit();
			}
		}
		
		function modificar(mayorId, tipoCta){
			document.forma.action += "?Accion=4&mayorId="+mayorId+"&tipoId="+tipoCta;
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
<body onload="document.getElementById('0').focus();">
	<form id="forma" name="forma" action="mayor.jsp" method="post">
		<table width="100%">
<%=respuesta %>
			<tr>
				<td class="titulo">Cuentas de Mayor</td>
			</tr>
			<tr>
				<td align="center">
					<select id="tipoCta" name="tipoCta" onchange="document.forma.submit();">
						<option value="B"<%=tipoCta.equals("B")?" Selected":"" %>>Cuentas de Balance</option>
						<option value="R"<%=tipoCta.equals("R")?" Selected":"" %>>Cuentas de Resultado</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
		<table width="77%" align="center" style="border: dotted 1px gray;">
			<tr>
				<td>
					ID: 
<%
	int inicio = 0;
	for(int i = 0; i < mascaraCta.length(); i++){
		if(accion==4){
%>
					<input type="text" id="<%=i %>" name="<%=i %>" value="<%=contMayor.getMayorId().substring(inicio, inicio+Integer.parseInt(String.valueOf(mascaraCta.charAt(i)))) %>" size="<%=mascaraCta.charAt(i) %>" maxlength="<%=mascaraCta.charAt(i) %>" Disabled />
					<input type="hidden" id="<%=i %>" name="<%=i %>" value="<%=contMayor.getMayorId().substring(inicio, inicio+Integer.parseInt(String.valueOf(mascaraCta.charAt(i)))) %>" />
<%
		}else{
%>
					<input type="text" id="<%=i %>" name="<%=i %>"<%=accion==4?(" value=\""+contMayor.getMayorId().substring(inicio, inicio+Integer.parseInt(String.valueOf(mascaraCta.charAt(i))))+"\""):"" %> onkeypress="saltoPress(event, <%=i %>, <%=mascaraCta.charAt(i) %>);" onkeyup="saltoUp(event, <%=i %>, <%=mascaraCta.charAt(i) %>);" size="<%=mascaraCta.charAt(i) %>" maxlength="<%=mascaraCta.charAt(i) %>"<%=accion==4?" Disabled":"" %> />
<%
		}
		inicio += Integer.parseInt(String.valueOf(mascaraCta.charAt(i)));
	}
%>				
					Nombre: <input type="text" id="nombre" name="nombre"<%=accion==4?" value=\""+contMayor.getMayorNombre()+"\"":"" %> size="40" maxlength="50" /> &nbsp;
					Detalle: <input name="detalle" type="checkbox" value="S" <%= detalleChk %>> &nbsp;
					Naturaleza:					
					<select id="naturaleza" name="naturaleza">
						<option value="D"<%=(accion==4&&contMayor.getNaturaleza().equals("D"))?" Selected":"" %>>Deudora</option>
						<option value="C"<%=(accion==4&&contMayor.getNaturaleza().equals("C"))?" Selected":"" %>>Acreedora</option>
					</select> &nbsp;
					<input type="submit" value="Graba" onclick="return revisa();" />
				</td>
			</tr>
		</table>
		<table width="77%" align="center" border="0">
			<tr>
				<td align="center" colspan="4" style="border-bottom:dotted 1px blue">Nota</td>
			</tr>
<%
	if(tipoCta.equals("B")){
%>
			<tr>
				<td align="center">Nivel 1 - Clasificación General</td>
				<td align="center">Nivel 2 - Clasificacion de las Cuentas</td>
				<td align="center">Nivel 3 - Cuentas Contables</td>
				<td align="center">Nivel 4 - Subcuentas</td>
			</tr>
<% }%>
	</table>
	<br>
		<table width="77%" align="center" style="border: solid 1px gray;">
			<tr>
				<th width="80px">Operaciones</th>
				<th width="60px">ID</th>
				<th>Nombre</th>
				<th width="80px">Naturaleza</th>
				<th width="70px">Detalle</th>
				<th width="70px">Nivel</th>
			</tr>
			<tr>
				<td colspan="6">
					<div style="width: 100%; height: 330px; overflow: auto;">
					<table width="100%">
<%
	lisMayor = contMayorL.getListAll(conElias, "WHERE TIPO_CTA = '"+tipoCta+"' ORDER BY MAYOR_ID");
	for(int i = 0; i < lisMayor.size(); i++){ cont++;
		contMayor = (ContMayor) lisMayor.get(i);
		if ((i % 2) == 1 ) sBgcolor = strColor; else sBgcolor = "";
		String identacion = "";
		
		if(contMayor.getTipoCta().equals("B")){
			if(Integer.parseInt(contMayor.getMayorId().substring(4,6)) > 0){				
				nivel = 4;
				identacion += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			}else if (Integer.parseInt(contMayor.getMayorId().substring(2,6))>0){
				nivel = 3;
				identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; 
			}else if(Integer.parseInt(contMayor.getMayorId().substring(1,2)) > 0){ 
				nivel = 2;
				identacion += "&nbsp;&nbsp;&nbsp;";
			}else{ 
				nivel = 1;				
			}
		}
		
		if(contMayor.getTipoCta().equals("R")){
			if(Integer.parseInt(contMayor.getMayorId().substring(2,4)) > 0){				
				nivel = 3;
				identacion += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			}else if (Integer.parseInt(contMayor.getMayorId().substring(1,4))>0){
				nivel = 2;
				identacion = "&nbsp;&nbsp;&nbsp;"; 
			}else{ 
				nivel = 1;
			}				
		}	
%>
						<tr <%=sBgcolor%>>
							<td width="78px" align="center">
								<img src="../../imagenes/no.gif" style="cursor: pointer;" title="Borrar" onclick="borrar('<%=contMayor.getMayorId() %>', '<%=contMayor.getTipoCta() %>');" />
								<img src="../../imagenes/edit.gif" style="cursor: pointer;" title="Modificar" onclick="modificar('<%=contMayor.getMayorId() %>', '<%=contMayor.getTipoCta() %>');" />
							</td>				
							<td width="58px" align="center"><%=contMayor.getMayorId() %></td>			
							<td><%=identacion %><%=contMayor.getMayorNombre()%></td>
							<td width="79px"><%=contMayor.getNaturaleza().equals("D")?"Deudora":"Acreedora" %></td>
							<td width="69px" align="center"><%=contMayor.getDetalle().equals("N")?"NO":"SI" %></td>
							<td width="50px" align="center"><%=nivel %></td>
						</tr>
	<%}%>
						<tr>
							<td colspan="5" align="center"><b>Fin</b></td>
						</tr>
					</table>
					</div>
				</td>
			</tr>
		</table>
	</form>
</body>

<%@ include file= "../../cierra_elias.jsp"%>