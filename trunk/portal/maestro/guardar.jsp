<%@ include file= "../../con_elias_dir.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>

<jsp:useBean id="archivo" scope="page" class="aca.ciclo.CicloGrupoArchivo" />
<%	
	String cicloGrupo 	= (String) session.getAttribute("cicloGrupoId");
	String cursoId 		= (String) session.getAttribute("cursoId");
	String modulo 		= request.getParameter("ModuloId");
	String temaId		= request.getParameter("TemaId");
	String salto		= "X";
	
	String ruta 		= application.getRealPath("/portal/maestro/")+"/";
	String folio		= "";	
	String nombre		= "";
	String descripcion 	= "-";
	
	boolean guardo = false; 
	
	try{		
		conEliasDir.setAutoCommit(false);
		
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, 10*1024*1024);
	    temaId			= multi.getParameter("TemaId");
	    folio			= archivo.maximoReg(conEliasDir, cicloGrupo, cursoId, temaId);
	    nombre			= multi.getFilesystemName("archivo");
	    descripcion		= multi.getParameter("Descripcion");	    
	    
	    File fi = new File(ruta+nombre);
		FileInputStream fis = new FileInputStream(fi);
		org.postgresql.largeobject.LargeObjectManager lobj = ((org.postgresql.PGConnection)conEliasDir).getLargeObjectAPI();
		long oid = lobj.createLO(org.postgresql.largeobject.LargeObjectManager.READ | org.postgresql.largeobject.LargeObjectManager.WRITE);
		org.postgresql.largeobject.LargeObject obj = lobj.open(oid, org.postgresql.largeobject.LargeObjectManager.WRITE);
		byte buf[] = new byte[(int)fi.length()];
		int le; 
		while ((le=fis.read(buf)) !=-1){
			obj.write(buf,0,le);
		}	
		
		archivo.setCicloGrupoId(cicloGrupo);
		archivo.setCursoId(cursoId);
		archivo.setTemaId(temaId);
		archivo.setFolio(folio);
		archivo.setArchivo(oid);
		archivo.setDescripcion(descripcion);
		archivo.setNombre(nombre);
		
		if(archivo.insertReg(conEliasDir)){
			conEliasDir.commit();
			guardo = true;
	   	}	
	   	
		if (fis!=null) fis.close();
		if (fi!=null) fi.delete();		
	    
	}catch(Exception e){
		System.out.println("Error al subir el archivo: "+e);
%>
		<div id="content">
			<div class="alert alert-danger">
				<strong><fmt:message key="aca.Error"/></strong>	<fmt:message key="aca.ErrorGrande"/>
				<a href="subir.jsp?ModuloId=<%= modulo %>&TemaId=<%=temaId%>"><fmt:message key="aca.IntentarDeNuevo"/></a>
			</div>
		</div>
<%
	}
	if (guardo){ 
		salto = "modulo.jsp?ModuloId="+modulo;
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias_dir.jsp" %>