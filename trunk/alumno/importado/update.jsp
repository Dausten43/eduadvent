<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.catalogo.CatTipocal"%>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoImp"/>
<jsp:useBean id="tipocal" scope="page" class="aca.catalogo.CatTipocal"/>
<jsp:useBean id="tipocalLista" scope="page" class="aca.catalogo.CatTipocalLista"/>
<head>
<script type="text/javascript">
	function actualiza(){
		if(document.getElementById("nota").value == "")
			alert("<fmt:message key="aca.ColocarNota"/>");
		else if(document.getElementById("fecha").value == "")
			alert("<fmt:message key="aca.ColocarFecha"/>");
		else{
			document.forma.submit();
		}
	}
</script>
</head>
<%
	String codigoId = (String) session.getAttribute("codigoAlumno");
	String folio = request.getParameter("folio");
	String accion = request.getParameter("Accion");
	String mensaje = "";
	
	if(accion == null)
		accion = "0";
	
	alumno.mapeaRegId(conElias, codigoId);
	kardex.mapeaRegId(conElias, codigoId, folio);
	tipocal.mapeaRegId(conElias, kardex.getTipoCalId());
	
	if(accion.equals("1")){
		kardex.setCal1(request.getParameter("b1"));
		kardex.setCal2(request.getParameter("b2"));
		kardex.setCal3(request.getParameter("b3"));
		kardex.setCal4(request.getParameter("b4"));
		kardex.setCal5(request.getParameter("b5"));
		kardex.setNota(request.getParameter("nota"));
		kardex.setFNota(request.getParameter("fecha"));
		kardex.setTipoCalId(request.getParameter("tipocal"));
		kardex.setComentario(request.getParameter("comentario"));
		kardex.setNotaExtra(request.getParameter("extra"));
		kardex.setFExtra(request.getParameter("fextra"));
		if(kardex.updateReg(conElias)){
			mensaje="GuardadoCorrectamente";
		}else{
			mensaje="ErrorGuardar";
		}
	}
	pageContext.setAttribute("resultado", mensaje);
%>
<body>
<div id="content">
<form name="forma" id="forma" action="update.jsp?folio=<%=folio %>&Accion=1" method="post">
	<table width="60%" align="center">
<%
	if(!mensaje.equals("")){
%>
		<tr><td align="center"><fmt:message key="aca.${mensaje}" /></td></tr>
		<tr><td align="center"><a href="cursos.jsp"><fmt:message key="boton.Regresar"/></a></td></tr>
<%
	}else{
%>

		<tr>
			<td align="center">[<%=codigoId %>] [<%=alumno.getNombre() %> <%=alumno.getApaterno() %> <%=alumno.getAmaterno() %>] -- [<%=CatNivel.getGradoNombre(Integer.parseInt(alumno.getNivelId())) %>] [<%=alumno.getGrado() %>º <%=alumno.getGrupo() %>]</td>
		</tr>
		<tr><td align="center"><a href="cursos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a></td></tr>
		<tr>
		
			<th><fmt:message key="alumnos.CursosImportados"/></th>
		</tr>
		<tr>
			<td align="center">
				<table widht="100%">
					<tr>
						<td width="50%"><b><fmt:message key="aca.Matricula"/></b></td>
						<td widht="50%"><input name="matricula" id="matricula" type="text" value="<%=codigoId %>" size="7" readonly="readonly" /></td>
					</tr>
					<tr>
						<td width="50%"><b><fmt:message key="aca.Cursos"/></b></td>
						<td widht="50%"><input name="curso" id="curso" type="text" value="<%=kardex.getCursoId() %>" size="7" readonly="readonly" /></td>
					</tr>
					<tr>
						<td width="50%"><b><fmt:message key="aca.Folio"/></b></td>
						<td widht="50%"><input name="folio" id="folio" type="text" value="<%=folio %>" size="2" readonly="readonly" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Bimestre"/> 1</b></td>
						<td><input name="b1" id="b1" type="text" value="<%=kardex.getCal1() %>" size="2" maxlength="2" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Bimestre"/> 2</b></td>
						<td><input name="b2" id="b2" type="text" value="<%=kardex.getCal2() %>" size="2" maxlength="2" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Bimestre"/> 3</b></td>
						<td><input name="b3" id="b3" type="text" value="<%=kardex.getCal3() %>" size="2" maxlength="2" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Bimestre"/> 4</b></td>
						<td><input name="b4" id="b4" type="text" value="<%=kardex.getCal4() %>" size="2" maxlength="2" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Bimestre"/> 5</b></td>
						<td><input name="b5" id="b5" type="text" value="<%=kardex.getCal5() %>" size="2" maxlength="2" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Nota"/></b></td>
						<td><input name="nota" id="nota" type="text" value="<%=kardex.getNota() %>" size="2" maxlength="3" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Fecha"/></b></td>
						<td><input name="fecha" id="fecha" type="text"  value="<%=kardex.getFNota() %>" size="7" maxlength="10" /> DD/MM/AAAA</td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.NotaExtra"/></b></td>
						<td><input name="extra" id="extra" type="text" value="<%=kardex.getNotaExtra() %>" size="2" maxlength="3" /></td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.FechaExtra"/></b></td>
						<td><input name="fextra" id="fextra" type="text" value="<%=kardex.getFExtra() %>" size="7" maxlength="10" /> DD/MM/AAAA</td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.TipoCalif"/></b></td>
						<td>
							<select name="tipocal" id="tipocal">
<%
		ArrayList lisTipocal = tipocalLista.getListAll(conElias, "ORDER BY TIPOCAL_ID");
		for(int j = 0; j < lisTipocal.size(); j++){
			tipocal = (CatTipocal) lisTipocal.get(j);
%>
								<option value="<%=tipocal.getTipocalId() %>" <%if(tipocal.getTipocalId().equals(kardex.getTipoCalId())) out.print("selected=\"selected\""); %>><%=tipocal.getTipocalCorto() %></option>
<%
		}
%>
							</select>
						</td>
					</tr>
					<tr>
						<td><b><fmt:message key="aca.Comentario"/></b></td>
						<td><input name="comentario" id="comentario" type="text" value="<%=kardex.getComentario() %>" /></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="button" value="Actualizar" onclick="actualiza();">
			</td>
		</tr>
<%
	}
%>
	</table>
</form>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>