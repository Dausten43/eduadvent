<% String idJsp="---"; %>
<%@ include file= "../body.jsp" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="aca.conecta.*" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="sys.general.Config"%>
<%
	String user						= (String)session.getAttribute("userDB");
	String password					= (String)session.getAttribute("passwordDB");
	String query					= request.getParameter("query");
	String salto					= "X";
	
	Connection  conn	 			= null;
	
	query = query.replace('\\', '%');
	
	//System.out.println("query = "+query);
	if(user == null){
		salto = "user.jsp?query="+query;
	}else{

		try{
			// EL SERVIDOR RIGEL ES EL DE PRODUCCION Y EL OREB ES EL DE PRUEBAS
			
		 	if (Config.OWNER.equals("ELIAS")){
		 		Class.forName("org.postgresql.Driver");
				conn = DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
			}else{				
				Class.forName("org.postgresql.Driver");
				conn = DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
			}			
		}catch(Exception ex){
			System.out.println("Error - :"+ex);
		}
%>
<body>
	<table>
<%
		if(query.equals("")){
%>
		<tr><td class="title">El query no es v&aacute;lido</td></tr>
<%
		}else{
			//System.out.println(query);
			StringTokenizer tokenizer = new StringTokenizer(query,";");
			while(tokenizer.hasMoreTokens()){
				query = tokenizer.nextToken();
				//System.out.println(query);
			
				Statement st 					= conn.createStatement();
				ResultSet rs		 			= null;
				ResultSetMetaData rsm			= null;
				int cont						= 0;
				
%>
	</table>
	<br />
	<table>
		<tr>
			<td colspan="50"><b><%=query %></b></td>
		</tr>
<%
				if(query.trim().substring(0, 6).toUpperCase().equals("SELECT")){
					try{
						rs = st.executeQuery(query);
						rsm = rs.getMetaData();
						while (rs.next()){
							if(cont == 0){
%>
		<tr>
<%
								for(int i = 1; i <= rsm.getColumnCount(); i++){
%>
			<th><%=rsm.getColumnName(i) %></th>
<%
								}
%>
		</tr>
<%
							}
%>
		<tr>
<%
							for(int i = 1; i <= rsm.getColumnCount(); i++){
								if(rsm.getColumnName(i).equals("CODIGO_PERSONAL")){
%>
			<td style="border-top: solid 1px gray; border-bottom: solid 1px gray; border-left: solid 1px gray;" class="ayuda alumno <%=rs.getString(i) %>"><%=rs.getString(i) %></td>
<%
								}else{
%>
			<td style="border-top: solid 1px gray; border-bottom: solid 1px gray; border-left: solid 1px gray;"><%=rs.getString(i) %></td>
<%
								}
							}
%>
		</tr>
<%
						cont++;
						}
						if(cont == 0){
%>
		<tr>
			<td><font color="red" size="3"><b>No regres&oacute; ningun resultado</b></font></td>
		</tr>
<%
						}
						
					}catch(Exception e){
						out.println("<tr><td>Error - SQL Editor:"+e+" \""+query+"\"</td></tr>");
					}finally{
						if (rs!=null) rs.close();
						if (st!=null) st.close();
					}
				}else if(query.trim().substring(0, 6).toUpperCase().equals("UPDATE") || query.trim().substring(0, 6).toUpperCase().equals("INSERT") || query.trim().substring(0, 6).toUpperCase().equals("DELETE")){
					int rowsUpdated = sys.general.Execute.update(conn, query);
					if(rowsUpdated != -1){
						out.print("<tr><td class=title2>Se actualizaron correctamente correctamente "+rowsUpdated+" columnas</tr></td>");
					}else{
						out.print("<tr><td class=title2>Ocurri&oacute; un error al actualizar</tr></td>");
					}
					//System.out.println("Actualizó "+rowsUpdated+" filas");
				}else{
					out.print("<tr><td class=title2>No se puede ejecutar el query \""+query+"\"</tr></td>");
				}
			}
		}
	}
%>
	</table>
</body>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../cierra_conn.jsp" %>