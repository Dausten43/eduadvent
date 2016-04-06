<%@ include file= "../../con_elias_dir.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<jsp:useBean id="archivo" scope="page" class="aca.archivo.ArchImagen" />
<%	
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String escuelaId 		= (String) session.getAttribute("escuela");
	String documentoId		= request.getParameter("DocumentoId");
	String hoja				= request.getParameter("Hoja")==null?"0":request.getParameter("Hoja");
	String salto 			= "X";
	
	boolean borroPg = false;
	try{		
		conEliasDir.setAutoCommit(false);
		
		archivo.setCodigoId(codigoId);
		archivo.setEscuelaId(escuelaId);
		archivo.setDocumentoId(documentoId);
		archivo.setHoja(hoja);		
		
		if(archivo.existeReg(conEliasDir)){
			System.out.println("Existe..");
			archivo.mapeaRegId(conEliasDir, codigoId, escuelaId, documentoId, hoja);			 
			if(archivo.deleteReg(conEliasDir)){
				borroPg = true;
				conEliasDir.commit();
			}		
		}else{
			borroPg = false;
	   	}		
		conEliasDir.setAutoCommit(true);
		
	    if(borroPg){	    	
	    	salto = "docalum.jsp";
	    }else{
%>
		<font size="4" color="red"><b><fmt:message key="aca.ErrorBorrarCorto"/></b> <a href="docalum.jsp">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a></font><br>
<%
	    }
	}catch(Exception e){
		System.out.println("Error al borrar el archivo: "+e);
%>
		<font size="4" color="red"><b><fmt:message key="aca.ErrorBorrarCorto"/></b> <a href="docalum.jsp">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a></font>
<%
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias_dir.jsp" %>