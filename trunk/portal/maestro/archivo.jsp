<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

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
	String cursoId		= request.getParameter("CursoId");
	String cicloGrupoId	= request.getParameter("CicloGrupoId");
	String resultado	= "";
	String salto		= "X";
	
	int accion 			= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	ArrayList<CicloGrupoArchivop> lisArchivos = null;
	ArrayList<String> lisAlumnos = null;
	
	switch(accion){
		case 2:{//Guardar
			DriverManager.registerDriver (new OracleDriver());
			Connection conn = null;
			String ruta = application.getRealPath("/portal/maestro/");
			try{
				conn = DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword())
				MultipartRequest multi = new MultipartRequest(request,ruta,20*1024*1024);
				
				String nombre = multi.getFilesystemName("archivo");
		        String alumnos = multi.getParameter("alumnos");
				String comentario = multi.getParameter("comentario");
				
				cicloGrupoArchivop.setCicloGrupoId(cicloGrupoId);
				cicloGrupoArchivop.setFolio(cicloGrupoArchivop.maxReg(conElias, cicloGrupoId));
				cicloGrupoArchivop.setComentario(comentario);
				cicloGrupoArchivop.setAlumnos(alumnos);
				cicloGrupoArchivop.setNombre(nombre);
				
				File file = new File(ruta+"/"+nombre);
				
				byte[] buff;
				java.io.FileInputStream instream;
				if(file.exists()){
					instream = new FileInputStream(file);
					buff = new byte[(int)file.length()];
					instream.read(buff);
					
					BLOB blob = BLOB.createTemporary(conn, true, BLOB.DURATION_SESSION);
					
					OutputStream blobOS = blob.getBinaryOutputStream();
					blobOS.write(buff);
					blobOS.flush();
					cicloGrupoArchivop.setArchivo(blob);
					System.out.println("Va a guardar...");
					if(cicloGrupoArchivop.insertReg(conn)){
						resultado = "ArchivoGuardado";
						file.delete();
					}else
						resultado = "ErrorGuardarArchivo";
					instream.close();
				}else{
					resultado = "ArchivoNoExiste";
				}
				conn.commit();
			}catch(Exception e){
				System.out.println("Error: "+e);
			}
			finally{
				conn.close();
			}
		}break;
		case 5:{
			String folio = request.getParameter("folio");
			cicloGrupoArchivop.mapeaRegId(conElias, cicloGrupoId, folio);
            InputStream is = cicloGrupoArchivop.getArchivo().getBinaryStream();
            int size = (int)cicloGrupoArchivop.getArchivo().length();
            byte[] buffer = new byte[size];
            is.read(buffer, 0, size);
            session.setAttribute("archivo", buffer);
			salto = "../../bajar?nombre="+cicloGrupoArchivop.getNombre();
		}break;
		case 6:{
			String folio = request.getParameter("folio");
			
			cicloGrupoArchivop.setCicloGrupoId(cicloGrupoId);
			cicloGrupoArchivop.setFolio(folio);
			if(cicloGrupoArchivop.deleteReg(conElias)){
				resultado = "ArchivoBorrado";
			}else{
				resultado = "ErrorBorrar";
			}
		}break;
	}
	// ORDER BY TO_DATE(FECHA, 'DD/MM/YYYY HH24:MI:SS')
	pageContext.setAttribute("resultado",resultado);
	lisArchivos = cicloGrupoArchivopL.getListEnviados(conElias, cicloGrupoId, "ORDER BY FECHA");
	lisAlumnos = krdxCursoActL.getListAlumnosGrupo(conElias, cicloGrupoId);
%>
<head>
<script type="text/javascript" src="../../js/prototype.js"></script>
<script type="text/javascript">
	function enviarArchivo(){
		if($("archivo").value != ""){
			var alumnos = "";
			for(var i = 0; i < <%=lisAlumnos.size() %>; i++){
				if($("envia-alumno-"+i).checked){
					alumnos += $("envia-alumno-"+i).value+"_N,";
				}
			}
			if(alumnos != ""){
				$("alumnos").value = alumnos;
				document.forma.submit();
			}else
				alert("<fmt:message key="js.SeleccionAQuien"/>");
		}else
			alert("<fmt:message key="aca.SeleccionaArchivo"/>");
	}
	
	function checaCuantasLetras(i){
		var txt=$("comentario").value;
		var n=txt.length;
		if (n>i){
			return false
		}
		return true;
	}
	
	function seleccionaTodos(cantidadAlumnos){
		for(var i = 0; i < cantidadAlumnos; i++){
			$("envia-alumno-"+i).checked = "checked";
		}
	}
	
	function deseleccionaTodos(cantidadAlumnos){
		for(var i = 0; i < cantidadAlumnos; i++){
			$("envia-alumno-"+i).checked = "";
		}
	}
</script>
</head>
<body>
<table class="goback">
	<tr>
		<td><a href="evaluar.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a></td>
	</tr>
</table>
<%
	if(!resultado.equals("")){
%>
<table align="center">
	<tr>
		<td><fmt:message key="aca.${resultado}"/></td>
	</tr>
</table>
<%
	}
%>
<table align="center" width="80%">
	<tr>
		<td class="titulo"><fmt:message key="archivo.EnviarArchivos"/></td>
	</tr>
	<tr>
		<td class="titulo2"><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %></td>
	</tr>
</table>
<br>
<table align="center" width="80%" class="table table-bordered table-condensed table-nohover">
	<tr>
		<td width="20px"></td>
		<th>#</th>
		<th><fmt:message key="aca.Nombre"/></th>
		<th><fmt:message key="aca.Comentario"/></th>
		<th><fmt:message key="aca.Fecha"/></th>
	</tr>
<%
	for(int i = 0; i < lisArchivos.size(); i++){
		cicloGrupoArchivop = (CicloGrupoArchivop) lisArchivos.get(i);
%>
	<tr class="button">
		<td><img src="../../imagenes/no.gif" class="button" onclick="location.href='archivo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&Accion=6&Folio=<%=cicloGrupoArchivop.getFolio() %>';" /></td>
		<td onclick="location.href='archivo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&Accion=5&Folio=<%=cicloGrupoArchivop.getFolio() %>';"><%=i+1 %></td>
		<td onclick="location.href='archivo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&Accion=5&Folio=<%=cicloGrupoArchivop.getFolio() %>';"><%=cicloGrupoArchivop.getNombre() %></td>
		<td onclick="location.href='archivo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&Accion=5&Folio=<%=cicloGrupoArchivop.getFolio() %>';"><%=cicloGrupoArchivop.getComentario() %></td>
		<td onclick="location.href='archivo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&Accion=5&Folio=<%=cicloGrupoArchivop.getFolio() %>';"><%=cicloGrupoArchivop.getFecha() %></td>
	</tr>
<%
	}
%>
</table>
<br>
<form id="forma" name="forma" enctype="multipart/form-data" action="archivo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&Accion=2" method="post">
<table>
	<tr>
		<td><b><fmt:message key="archivo.EnviarArchivo"/>:</b></td>
	</tr>
	<tr>
		<td>
			<input type="file" id="archivo" name="archivo" />
			<input type="hidden" id="alumnos" name="alumnos" />
		</td>
	</tr>
	<tr>
		<td><b><fmt:message key="aca.Comentario"/>:</b></td>
	</tr>
	<tr>
		<td>
			<textarea id="comentario" name="comentario" onkeypress="return checaCuantasLetras(190);" cols="60"></textarea>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><input type="button" value="Enviar" onclick="enviarArchivo();" /></td>
	</tr>
</table>
</form>
<table class="table table-condensed table-bordered table-striped">
	<tr>
		<td><a href="javascript:seleccionaTodos(<%=lisAlumnos.size() %>);"><fmt:message key="reportes.Todos"/></a> | <a href="javascript:deseleccionaTodos(<%=lisAlumnos.size() %>);"><fmt:message key="aca.Ninguno"/></a></td>
	</tr>
<%
	for(int i = 0; i < lisAlumnos.size(); i++){
		String alumno = (String) lisAlumnos.get(i);
%>
	<tr>
		<td><input type="checkbox" id="envia-alumno-<%=i %>" value="<%=alumno %>" /></td>
		<td><%=alumno %></td>
		<td><%=AlumPersonal.getNombre(conElias, alumno, "APELLIDO") %></td>
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