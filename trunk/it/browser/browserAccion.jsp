<%@page import="java.io.*"%>
<%@ include file= "../conn.jsp" %>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%
	int accion = Integer.parseInt(request.getParameter("Accion"));
	String path = request.getParameter("path");
	
	switch(accion){
		case 5:{//Muestra solo carpetas
			File dir = new File(path);
			File[] files = dir.listFiles();
%>
			<table width="100%">
<%
			for(int i = 0; i < files.length; i++){
				if(files[i].isDirectory()){
%>
				<tr class="button" onclick="browse('<%=files[i].getAbsolutePath().replaceAll("\\\\","/") %>', '<%=files[i].getAbsolutePath().replaceAll("\\\\","/").replaceAll(" ", "_") %>');">
					<td width="20px" valign="top">
						<img src="../../imagenes/sub.gif" />
					</td>
					<td valign="top">
						<b><%=files[i].getName() %></b>
					</td>
				</tr>
				<tr>
					<td width="20px" valign="top">
						
					</td>
					<td valign="top">
						<div id="<%=files[i].getAbsolutePath().replaceAll("\\\\","/").replaceAll(" ", "_") %>"></div>
					</td>
				</tr>
<%
				}
			}
%>
			</table>
<%
		}break;
		case 6:{//Muestra carpetas y archivos
			File dir = new File(path);
			File[] files = dir.listFiles();
%>
			<table width="100%">
<%
			for(int i = 0; i < files.length; i++){
				if(files[i].isDirectory()){
%>
				<tr class="button" onclick="browse('<%=files[i].getAbsolutePath().replaceAll("\\\\","/") %>', '<%=files[i].getAbsolutePath().replaceAll("\\\\","/").replaceAll(" ", "_") %>');" >
					<td width="20px" valign="top">
						<img src="../../imagenes/download2.gif" />
					</td>
					<td valign="top">
						<%=files[i].getName() %>
					</td>
					<td width="60px">&nbsp;</td>
				</tr>
<%
				}
			}
			for(int i = 0; i < files.length; i++){
				if(files[i].isFile()){
%>
				<tr class="button">
					<td width="20px" valign="top">
						<img src="../../imagenes/edit.gif" />
					</td>
					<td valign="top" onclick="download('<%=files[i].getAbsolutePath().replaceAll("\\\\","/") %>');">
						<%=files[i].getName() %>
					</td>
					<td width="60px">
						<%=files[i].length()<(1024)?(files[i].length()+" B"):files[i].length()<(1024*1024)?((files[i].length()/(1024))+" KB"):((files[i].length()/(1024*1024))+" MB") %>
					</td>
				</tr>
<%
				}
			}
%>
			</table>
<%
		}break;
		case 7:{//Bajar archivo
			File archivo = new File(path);
			InputStream is = new FileInputStream(archivo);
			
			long length = archivo.length();
			
			if (length > Integer.MAX_VALUE) {
%>
				alert("El archivo es muy grande (<%=archivo.length() %> Bits)");
<%
	        }else{
	        	byte[] bytes = new byte[(int)length];
				is.read(bytes, 0, (int)length);
				session.setAttribute("archivo", bytes);
				System.out.println("Va a sacar el alert");
%>
				location.href = "<%=request.getContextPath() %>/bajar?nombre=<%=archivo.getName() %>";
<%
	        }
		}break;
		case 8:{//Subir archivo
			MultipartRequest multi = new MultipartRequest(request, application.getRealPath("/it/browser/"), 20*1024*1024);
			path = multi.getParameter("path");
			String name = multi.getFilesystemName("file");
			
			File archivo = new File(application.getRealPath("/it/browser/")+"/"+name);
			
			File nuevoArchivo = new File(path+"/"+name);
			
			InputStream is = new FileInputStream(archivo);
			OutputStream os = new FileOutputStream(nuevoArchivo);

			byte[] buf = new byte[1024];
			int len;
			while ((len = is.read(buf)) > 0) {
				os.write(buf, 0, len);
			}
			is.close();
			os.close();
			archivo.delete();
%>
			<script type="text/javascript">
				parent.ocultaCargando();
				parent.browse('<%=path %>', '<%=path.replaceAll(" ", "_") %>');
				parent.browse('<%=path %>', '<%=path.replaceAll(" ", "_") %>');
			</script>
			<b>Guardado</b>
<%
		}break;
		case 9:{//Crear carpeta
			String dir = request.getParameter("dir");
			File carpeta = new File(path+"/"+dir);
			if(!carpeta.exists()){
				if(carpeta.mkdir()){
%>
					<script type="text/javascript">
						parent.ocultaCargando();
						parent.browse('<%=path %>', '<%=path.replaceAll(" ", "_") %>');
						parent.browse('<%=path %>', '<%=path.replaceAll(" ", "_") %>');
					</script>
					<b>Carpeta "<%=dir %>" creada</b>
<%
				}else{
%>
					<script type="text/javascript">
						parent.ocultaCargando();
						alert("No se pudo crear la carpeta");
					</script>
					<b>Error...</b>
<%
				}
			}else{
%>
				<script type="text/javascript">
					parent.ocultaCargando();
					alert("La carpeta ya existe");
				</script>
				<b>Error... Ya existia la carpeta</b>
<%
			}
		}break;
	}
	
	if(conn != null)conn.close();
	conn = null;
%>