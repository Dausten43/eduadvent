<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.sql.*" %>
<%
	DriverManager.registerDriver (new org.postgresql.Driver());	
	Connection conn=DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
	Statement stmt= conn.createStatement();	
	ResultSet rset= null;
	
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String escuelaId 		= (String) session.getAttribute("escuela");	
	String documentoId 		= request.getParameter("DocumentoId");
	String hoja 			= request.getParameter("Hoja");	
	
	conn.setAutoCommit(false);
	String COMANDO = 	"SELECT IMAGEN FROM ARCH_IMAGEN"+ 
			" WHERE ESCUELA_ID = '"+escuelaId+"'"+
			" AND CODIGO_ID = '"+codigoId+"'"+
			" AND DOCUMENTO_ID = "+documentoId+
			" AND HOJA = "+hoja;
	rset = stmt.executeQuery(COMANDO);
	if (rset.next()){	
				
	    org.postgresql.largeobject.LargeObject obj;
		org.postgresql.largeobject.LargeObjectManager lobj = ((org.postgresql.PGConnection)conn).getLargeObjectAPI();	
		Integer oid = rset.getInt("imagen");
		obj = lobj.open(oid.longValue(), org.postgresql.largeobject.LargeObjectManager.READ);
	    byte buf[] = new byte[obj.size()];
	    obj.read(buf, 0, obj.size());
	    response.setContentType("image/jpeg");
		response.getOutputStream().write(buf);
		response.flushBuffer();
		obj.close();
	}
	if (conn!=null) conn.close();
	if (stmt!=null) stmt.close();
	if (rset!=null) rset.close();
%>