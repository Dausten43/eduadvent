<%@ include file= "../../con_elias_dir.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>

<jsp:useBean id="Imagen" scope="page" class="aca.archivo.ArchImagen" />
<%	
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String escuelaId	= (String) session.getAttribute("escuela");
	String documentoId	= request.getParameter("DocumentoId");
	String hoja			= request.getParameter("Hoja");
	String nombre		= "";	
	String ruta 		= application.getRealPath("/archivo/docalum/")+"/";		
	String salto		= "X";
	
	boolean guardo = false;	
	
	try{	
		conEliasDir.setAutoCommit(false);
		
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, 10*1024*1024);
		documentoId		= multi.getParameter("DocumentoId");
	    hoja			= multi.getParameter("Hoja");
	    nombre			= multi.getFilesystemName("archivo");
	    
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
		
		Imagen.setCodigoId(codigoId);
		Imagen.setEscuelaId(escuelaId);
		Imagen.setDocumentoId(documentoId);
		Imagen.setHoja(hoja);
		Imagen.setImagen(oid);	
		Imagen.setNombre(nombre);
		
		if(Imagen.insertReg(conEliasDir)){
			conEliasDir.commit();
			guardo = true;
	   	}	
	   	
		if (fis!=null) fis.close();
		if (fi!=null) fi.delete();
		
		//Termina la transacción
		conEliasDir.setAutoCommit(false);   
	}catch(Exception e){
		System.out.println("Error al subir el archivo: "+e);
%>
		<div id="content">
			<div class="alert alert-danger">
				<strong><fmt:message key="aca.Error"/></strong>	<fmt:message key="aca.ErrorGrande"/>
				<a href="subir.jsp?DocumentoId=<%= documentoId %>&Hoja=<%=hoja%>"><fmt:message key="aca.IntentarDeNuevo"/></a>
			</div>
		</div>
<%
	}
	if (guardo){ 
		salto = "docalum.jsp";
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias_dir.jsp" %>