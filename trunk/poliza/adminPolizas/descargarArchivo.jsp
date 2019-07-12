<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.sql.*"%>
<%
	aca.ciclo.CicloGrupoArchivo Archivo		= new aca.ciclo.CicloGrupoArchivo();
	try {
		// Conexion a postgres
		DriverManager.registerDriver (new org.postgresql.Driver());
		Connection conn2	= DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
		

		String descargaId	= request.getParameter("descargaId");			
		
		conn2.setAutoCommit(false);		
		String sql			= "SELECT * FROM FIN_DESCARGA_SUNPLUS WHERE DESCARGA_ID = ?";
		PreparedStatement ps = conn2.prepareStatement(sql);
		ps.setString(1, descargaId);
		 
		ResultSet rs = ps.executeQuery();
		byte archivo[]=null;
		if (rs.next()) {
	        org.postgresql.largeobject.LargeObject obj;
			org.postgresql.largeobject.LargeObjectManager lobj = ((org.postgresql.PGConnection)conn2).getLargeObjectAPI();	
			Integer oid = rs.getInt("ARCHIVO");
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
			response.setHeader("Content-Disposition","attachment; filename=\"Ledger_Import.xls\"");
			response.getOutputStream().write(archivo);
			response.flushBuffer();
		}catch(Exception e){
			e.printStackTrace();
		}		

	}catch ( Exception e ) {
		e.printStackTrace();
	}	
%>