<%
	String user			= (String) session.getAttribute("codigoId");
	String opciones		= (String) session.getAttribute("opciones");
	String esAdmSeguro	= (String) session.getAttribute("admin");
	
	if(esAdmSeguro.equals("-------")){
		if ( ( opciones.indexOf(idJsp) != -1 ) ){
			//System.out.println("Acceso Valido:"+user+idJsp);
		}else{
			response.sendRedirect("../../error.jsp?error=3"); 
		}
	}
%>