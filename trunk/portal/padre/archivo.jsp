<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<%@page import="aca.ciclo.CicloGrupoArchivop"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="oracle.jdbc.OracleDriver"%>
<%@page import="java.io.*"%>
<%@page import="oracle.sql.BLOB"%>

<jsp:useBean id="cicloGrupoArchivop" scope="page" class="aca.ciclo.CicloGrupoArchivop"/>
<jsp:useBean id="cicloGrupoArchivopL" scope="page" class="aca.ciclo.CicloGrupoArchivopLista"/>
<jsp:useBean id="krdxCursoAct" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<%
	String cursoId		= request.getParameter("cursoId");
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	String cicloId		= request.getParameter("ciclo");
	String resultado	= "";
	String codigoAlumno = (String) session.getAttribute("codigoAlumno");
	String salto		= "X";
	
	int accion 			= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	ArrayList<CicloGrupoArchivop> lisArchivos = null;
	ArrayList<String> lisAlumnos = null;
	
	switch(accion){
		case 5:{//Bajar... y marcar como leido
			String folio = request.getParameter("folio");
			cicloGrupoArchivop.mapeaRegId(conElias, cicloGrupoId, folio);
            InputStream is = cicloGrupoArchivop.getArchivo().getBinaryStream();
            int size = (int)cicloGrupoArchivop.getArchivo().length();
            byte[] buffer = new byte[size];
            is.read(buffer, 0, size);
            cicloGrupoArchivop.setAlumnos(cicloGrupoArchivop.getAlumnos().replaceFirst(codigoAlumno+"_N", codigoAlumno));
            cicloGrupoArchivop.updateRegAlumnos(conElias);
            session.setAttribute("archivo", buffer);
			salto = "../../bajar?nombre="+cicloGrupoArchivop.getNombre();
		}break;
	}
	// TO_DATE(FECHA, 'DD/MM/YYYY HH24:MI:SS')
	lisArchivos = cicloGrupoArchivopL.getListEnviados(conElias, cicloGrupoId, "ORDER BY FECHA");
	lisAlumnos = krdxCursoActL.getListAlumnosGrupo(conElias, cicloGrupoId);
%>
<head>
	<link href="css/pa.css" rel="STYLESHEET" type="text/css">
</head>
<body>
<script>
	parent.tabs.document.body.style.backgroundColor=parent.contenidoP.document.bgColor;
</script>
<table class="goback">
	<tr>
		<td><a href="materias.jsp?ciclo=<%=cicloId %>">&lsaquo;&lsaquo; Regresar</a></td>
	</tr>
</table>
<%
	if(!resultado.equals("")){
%>
<table align="center">
	<tr>
		<td><%=resultado %></td>
	</tr>
</table>
<%
	}
%>
<table align="center" width="80%">
	<tr>
		<td align="center"><font size="3"><b>Archivos Recibidos</b></font></td>
	</tr>
	<tr>
		<td align="center"><font size="2"><b><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %></b></font></td>
	</tr>
</table>
<br>
<table align="center" width="80%" style="border: solid 1px black;">
	<tr>
		<td width="20px"></td>
		<td class="encabezadoV">#</td>
		<td class="encabezadoV">Nombre</td>
		<td class="encabezadoV">Comentario</td>
		<td class="encabezadoV">Fecha</td>
	</tr>
<%
	for(int i = 0; i < lisArchivos.size(); i++){
		cicloGrupoArchivop = (CicloGrupoArchivop) lisArchivos.get(i);
%>
	<tr onMouseOver="this.style.backgroundColor='#e4f7fa'" onMouseOut="this.style.backgroundColor=''" style="cursor: pointer;">
		<td id="<%=i %>">
<%
		if(cicloGrupoArchivop.getAlumnos().indexOf(codigoAlumno+"_N") != -1){
%>
			<img src="../../imagenes/estrella.gif" />
<%
		}
%>
		</td>
		<td onclick="location.href='archivo.jsp?cursoId=<%=cursoId %>&cicloGrupoId=<%=cicloGrupoId %>&Accion=5&folio=<%=cicloGrupoArchivop.getFolio() %>&ciclo=<%=cicloId %>'; document.getElementById('<%=i %>').innerHTML = '&nbsp;';"><%=i+1 %></td>
		<td onclick="location.href='archivo.jsp?cursoId=<%=cursoId %>&cicloGrupoId=<%=cicloGrupoId %>&Accion=5&folio=<%=cicloGrupoArchivop.getFolio() %>&ciclo=<%=cicloId %>'; document.getElementById('<%=i %>').innerHTML = '&nbsp;';"><%=cicloGrupoArchivop.getNombre() %></td>
		<td onclick="location.href='archivo.jsp?cursoId=<%=cursoId %>&cicloGrupoId=<%=cicloGrupoId %>&Accion=5&folio=<%=cicloGrupoArchivop.getFolio() %>&ciclo=<%=cicloId %>'; document.getElementById('<%=i %>').innerHTML = '&nbsp;';"><%=cicloGrupoArchivop.getComentario() %></td>
		<td onclick="location.href='archivo.jsp?cursoId=<%=cursoId %>&cicloGrupoId=<%=cicloGrupoId %>&Accion=5&folio=<%=cicloGrupoArchivop.getFolio() %>&ciclo=<%=cicloId %>'; document.getElementById('<%=i %>').innerHTML = '&nbsp;';"><%=cicloGrupoArchivop.getFecha() %></td>
	</tr>
<%
	}
%>
</table>
</body>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>