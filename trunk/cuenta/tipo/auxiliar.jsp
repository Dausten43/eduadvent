<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contTipo" scope="page" class="aca.cont.ContTipo"></jsp:useBean>
<jsp:useBean id="contTipoL" scope="page" class="aca.cont.ContTipoLista"></jsp:useBean>
<jsp:useBean id="contAuxiliar" scope="page" class="aca.cont.ContAuxiliar"></jsp:useBean>
<jsp:useBean id="contAuxiliarL" scope="page" class="aca.cont.ContAuxiliarLista"></jsp:useBean>
<head>
	<script type="text/javascript">
		function Guardar(){
			if(document.forma.numero.value != "" && document.forma.nombre.value != ""){
				document.forma.Accion.value = "2";
				document.forma.submit();
			}else{
				alert("Los campos deben estar llenos para poder guardar!!!");
			}
		}
		
		function modificar(Id){
			document.forma.action += "?Accion=4&Id="+Id;
			document.forma.submit();
		}
		
		function eliminar(Id){
			if(confirm("¿Está seguro que desea borrar el registro?")){
				location.href='accion.jsp?Accion=4&Id='+Id;
			}
		}
	</script>
</head>
<%
	String sResultado	= "";
	ArrayList lisTipo = new ArrayList();
	lisTipo = contTipoL.getListAll(conElias, "ORDER BY 1");
	

%>
<body>
	<table align="center" width="40%" border="0">
		<tr>
			<td class="titulo" colspan="3">Tipos de Auxiliares</td>
		</tr>
	</table>
	<br>
	<table align="center" width="40%" border="0" cellpadding="1px">
			<tr>
				<td align="center" colspan="3"><a href="accion.jsp?Accion=1">[Añadir]</a></td>
			</tr>
			<tr>
				<td width="1%"></td>
				<th width="5%">Id</th>
				<th width="15%">Nombre</th>
			</tr>
<%
			for (int i=0; i< lisTipo.size(); i++){
				aca.cont.ContTipo tipo = (aca.cont.ContTipo) lisTipo.get(i);
%> 
			<tr>
				<td align="center">
					<img src="../../imagenes/no.gif" style="cursor: pointer;" title="Borrar" class="button" onclick="eliminar('<%=tipo.getTipoId()%>')" />
					<img src="../../imagenes/edit.gif" style="cursor: pointer;" title="Modificar" class="button" onclick="location.href='accion.jsp?Accion=5&Id=<%=tipo.getTipoId()%>&nombre=<%=tipo.getTipoNombre()%>';"/>
				</td>
				<td align="center"><%=tipo.getTipoId()%></td>
				<td><%=tipo.getTipoNombre()%></td>
			</tr>
<%} %>
		</table>
</body>

<%@ include file= "../../cierra_elias.jsp" %>