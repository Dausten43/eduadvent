<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.sql.*"%>
<%
	aca.ciclo.CicloGrupoArchivo Archivo		= new aca.ciclo.CicloGrupoArchivo();
	try {
		// Conexion a postgres
		DriverManager.registerDriver (new org.postgresql.Driver());
		Connection conn2	= DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
		
		String cicloGrupo 	= (String) session.getAttribute("cicloGrupoId");
		String cursoId 		= (String) session.getAttribute("cursoId");		
		String temaId		= request.getParameter("TemaId");
		String folio		= request.getParameter("Folio");			
		String ruta 		= "maestro/";
		String nombre 		= "";
		
		conn2.setAutoCommit(false);		
		String sql			= "SELECT ARCHIVO, NOMBRE FROM CICLO_GRUPO_ARCHIVO "+
				"WHERE CICLO_GRUPO_ID = ? AND CURSO_ID = ? AND TEMA_ID = ? AND FOLIO = TO_NUMBER(?,'99')";
		PreparedStatement ps = conn2.prepareStatement(sql);
		ps.setString(1, cicloGrupo );
		ps.setString(2, cursoId);
		ps.setString(3, temaId);
		ps.setString(4, folio);
		
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