<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.sql.*"%>
<%
	aca.archivo.ArchImagen Archivo		= new aca.archivo.ArchImagen();
	try {
		// Conexion a postgres
		DriverManager.registerDriver (new org.postgresql.Driver());
		Connection conn2	= DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
		
		String codigoId 		= (String) session.getAttribute("codigoAlumno");
		String escuelaId 		= (String) session.getAttribute("escuela");	
		String documentoId 		= request.getParameter("DocumentoId");
		String hoja 			= request.getParameter("Hoja");					
		String ruta 			= "docalum/";
		String nombre 			= "";
		
		conn2.setAutoCommit(false);
		String sql	= "SELECT IMAGEN, NOMBRE FROM ARCH_IMAGEN"+
				" WHERE ESCUELA_ID = ?"+
				" AND CODIGO_ID = ?"+
				" AND DOCUMENTO_ID = ?"+
				" AND HOJA = ?";
		PreparedStatement ps = conn2.prepareStatement(sql);
		ps.setString(1, escuelaId );
		ps.setString(2, codigoId);
		ps.setString(3, documentoId);
		ps.setString(4, hoja);
		
		ResultSet rs = ps.executeQuery();
		byte archivo[]=null;
		if (rs.next()) {
			nombre = rs.getString("NOMBRE");
	        org.postgresql.largeobject.LargeObject obj;
			org.postgresql.largeobject.LargeObjectManager lobj = ((org.postgresql.PGConnection)conn2).getLargeObjectAPI();
			Integer oid = rs.getInt(1);
	   		obj = lobj.open(oid.longValue(), org.postgresql.largeobject.LargeObjectManager.READ);
		    archivo = new byte[obj.size()];	    
		    archivo =  obj.read(obj.size()); 
			obj.close();        
	    }
		if (ps!=null) ps.close();
		if (rs!=null) rs.close();			
		if (conn2!=null) conn2.close();
		
		try{
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition","attachment; filename=\""+nombre+ "\"");
			response.getOutputStream().write(archivo);
			response.flushBuffer();
		}catch(Exception e){
			e.printStackTrace();
		}		

	}catch ( Exception e ) {
		e.printStackTrace();
	}	
%>