<%@ page import="aca.cont.ContTipo"%>
<%@ page import="aca.cont.ContAuxiliar"%>
<%@ page import="aca.catalogo.CatEscuela"%>
<%@ page import="aca.usuario.Usuario"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contTipo" scope="page" class="aca.cont.ContTipo"></jsp:useBean>
<jsp:useBean id="contTipoL" scope="page" class="aca.cont.ContTipoLista"></jsp:useBean>
<jsp:useBean id="contAuxiliar" scope="page" class="aca.cont.ContAuxiliar"></jsp:useBean>
<jsp:useBean id="contAuxiliarL" scope="page" class="aca.cont.ContAuxiliarLista"></jsp:useBean>
<jsp:useBean id="catEscuela" scope="page" class="aca.catalogo.CatEscuela"></jsp:useBean>
<jsp:useBean id="catEscuelaL" scope="page" class="aca.catalogo.CatEscuelaLista"></jsp:useBean>
<%
	String respuesta 	= "";
	String tipoCta		= request.getParameter("tipoCta")==null?"1":request.getParameter("tipoCta");
	String auxiliarId	= request.getParameter("auxiliarId");
	String escuelaId	= request.getParameter("escuelaId");
	String codigoId		= (String) session.getAttribute("codigoId");
	
	if(escuelaId == null)
		escuelaId 		= (String) session.getAttribute("escuela");
	
	int accion			= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));

	ArrayList lisTipo 		= contTipoL.getListAll(conElias, "ORDER BY TIPO_ID");
	ArrayList lisAuxiliar	= null;
	ArrayList<CatEscuela> lisEscuelas	= null;
	
	switch(accion){
		case 2:{	//Grabar y Modificar
			contAuxiliar.setAuxiliarId((escuelaId.length()==1?("0"+escuelaId):escuelaId)+auxiliarId);
			if(contAuxiliar.existeReg(conElias)){
				if(request.getParameter("update") != null){
					contAuxiliar.mapeaRegId(conElias, (escuelaId.length()==1?("0"+escuelaId):escuelaId)+auxiliarId);
					contAuxiliar.setAuxiliarNombre(request.getParameter("nombre"));
					if(contAuxiliar.updateReg(conElias)){
						respuesta = "<tr><td align=center><font size=2 color=blue><b>Se modific&oacute; correctamente el auxiliar!!!</b></font></td></tr>";
					}else{
						respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al modificar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
					}
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>El ID del Auxiliar ya se est&aacute; usando</b></font></td></tr>";
				}
			}else{
				contAuxiliar.setAuxiliarNombre(request.getParameter("nombre"));
				contAuxiliar.setDetalle("N");
				contAuxiliar.setTipoId(tipoCta);
				if(contAuxiliar.insertReg(conElias)){
					respuesta = "<tr><td align=center><font size=2 color=blue><b>Se guard&oacute; correctamente el auxiliar!!!</b></font></td></tr>";
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al guardar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
				}
			}
			contAuxiliar = new ContAuxiliar();
		}break;
		case 3:{	//Borrar
			if(!ContAuxiliar.estaLigado(conElias, auxiliarId)){
				contAuxiliar.setAuxiliarId(auxiliarId);
				if(contAuxiliar.deleteReg(conElias)){
					respuesta = "<tr><td align=center><font size=2 color=blue><b>Se borr&oacute; correctamente el auxiliar!!!</b></font></td></tr>";
				}else{
					respuesta = "<tr><td align=center><font size=2 color=red><b>Ocurri&oacute; un error al borrar. Int&eacute;ntelo de nuevo</b></font></td></tr>";
				}
			}else{
				respuesta = "<tr><td align=center><font size=2 color=red><b>El auxiliar ya esta relacionado y no puede borrarse</b></font></td></tr>";
			}
			contAuxiliar.setAuxiliarId("");
		}break;
		case 4:{
			contAuxiliar.mapeaRegId(conElias, auxiliarId);
		}break;
	}
%>
<head>
	<script type="text/javascript">
		function revisa(){
			if(document.forma.auxiliarId.value != "" &&
			  document.forma.nombre.value != ""){
				document.forma.action += "?Accion=2";
				return true;
			}else{
				alert("Los campos deben estar llenos para poder guardar!!!");
			}
			return false;
		}
		
		function borrar(auxiliarId){
			if(confirm("¿Esta seguro que desea borrar el auxiliar?")){
				document.forma.action += "?Accion=3&auxiliarId="+auxiliarId;
				document.forma.submit();
			}
		}
		
		function modificar(auxiliarId){
			document.forma.action += "?Accion=4&auxiliarId="+auxiliarId;
			document.forma.submit();
		}
	</script>
</head>
<body>
	<form id="forma" name="forma" action="auxiliar.jsp" method="post">
		<table width="100%">
			<%=respuesta %>
			<tr>
				<td class="titulo">Auxiliares</td>
			</tr>
<%
	if(Usuario.esAdministrador(conElias, codigoId)){
%>
			<tr>
				<td align="center">
					<select id="escuelaId" name="escuelaId" onchange="document.forma.submit();">
<%
		lisEscuelas = catEscuelaL.getListAll(conElias, "ORDER BY ESCUELA_NOMBRE");
		for(int i = 0; i < lisEscuelas.size(); i++){
			catEscuela = (CatEscuela) lisEscuelas.get(i);
%>
						<option value="<%=catEscuela.getEscuelaId() %>"<%=escuelaId.equals(catEscuela.getEscuelaId())?" Selected":"" %>><%=catEscuela.getEscuelaNombre() %></option>
<%
		}
%>
					</select>
				</td>
			</tr>
<%
	}
%>
			<tr>
				<td align="center">
					<b>de tipo</b>
					<select id="tipoCta" name="tipoCta" onchange="document.forma.submit();">
<%
	for(int i = 0; i < lisTipo.size(); i++){
		contTipo = (ContTipo) lisTipo.get(i);
%>
						<option value="<%=contTipo.getTipoId() %>"<%=contTipo.getTipoId().equals(tipoCta)?" Selected":"" %>><%=contTipo.getTipoNombre() %></option>
<%
	}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
		<table width="70%" align="center" style="border: dotted 1px gray;">
			<tr>
				<td align="center">
					ID: 
					<input type="text" value="<%=(escuelaId.length()==1?("0"+escuelaId):escuelaId) %>" size="2" disabled />
					<input type="text" id="auxiliarId" name="auxiliarId" title="Identificador &uacute;nico del auxiliar" value="<%=accion==4?contAuxiliar.getAuxiliarId().substring(2):"" %>" size="5" maxlength="5"<%=accion==4?" Disabled":"" %> />&nbsp;&nbsp;
<%
	if(accion == 4){
%>
					<input type="hidden" id="auxiliarId" name="auxiliarId" value="<%=contAuxiliar.getAuxiliarId().substring(2) %>" />
					<input type="hidden" id="update" name="update" value="update" />
<%
	}
%>
					Nombre: <input type="text" id="nombre" name="nombre" value="<%=contAuxiliar.getAuxiliarNombre() %>" size="65" maxlength="100" />
				</td>
			</tr>
			<tr>
				<td align="center">
					<input type="submit" value="Guardar" onclick="return revisa();" />
				</td>
			</tr>
		</table>
		<table width="80%" align="center">
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td width="40px">&nbsp;</td>
				<th width="60px">ID</th>
				<th>Nombre</th>
				<th width="50px">Detalle</th>
			</tr>
<%
	lisAuxiliar	= contAuxiliarL.getListTipo(conElias, tipoCta, escuelaId, "ORDER BY AUXILIAR_NOMBRE");
	for(int i = 0; i < lisAuxiliar.size(); i++){
		contAuxiliar = (ContAuxiliar) lisAuxiliar.get(i);
%>
			<tr>
				<td>
					<img src="../../imagenes/no.gif" style="cursor: pointer;" title="Borrar" onclick="borrar('<%=contAuxiliar.getAuxiliarId() %>');" />
					<img src="../../imagenes/edit.gif" style="cursor: pointer;" title="Modificar" onclick="modificar('<%=contAuxiliar.getAuxiliarId() %>');" />
				</td>
				<td><%=contAuxiliar.getAuxiliarId() %></td>
				<td><%=contAuxiliar.getAuxiliarNombre() %></td>
				<td align="center"><%=contAuxiliar.getDetalle() %></td>
			</tr>
<%
	}
%>
			<tr>
				<td colspan="4" align="center"><b>Fin</b></td>
			</tr>
		</table>
	</form>
</body>

<%@ include file= "../../cierra_elias.jsp" %>