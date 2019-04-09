<%@page import="aca.alumno.AlumPersonalLista"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<jsp:useBean id="alumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="empeladosLista" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="inscritosLista" scope="page" class="aca.vista.AlumInscritoLista"/>
<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.sql.*" %>

<%
	boolean error 			= false;
	boolean withoutPhotos 	= false;
	boolean withoutUsers = false;

	String dir				= application.getRealPath("informe/carnet")+"/";
	String fechaIni			= request.getParameter("fechaIni");
	String fechaFin			= request.getParameter("fechaFin");
	String escuelaId		= request.getParameter("EscuelaId");
	String cicloId			= request.getParameter("Ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("Ciclo");
	
	String ciclo="";
	String errorMessage = "";
	
	if(request.getParameter("empleados")==null){
		System.out.println("Dir => " + dir);
		ciclo = aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
					
		cicloId = ciclo;
		
			
		//LISTA DE ESCUELAS
	
		ArrayList<aca.vista.AlumInscrito> lisAlumnos 	= inscritosLista.getListaInscritos(conElias, escuelaId, " ORDER BY NIVEL, GRADO, GRUPO, NOMBRE,APATERNO,AMATERNO");
		//ArrayList<aca.alumno.AlumPersonal> lisAlumnos = alumPersonalL.getListAlumnosInscritos(conElias, escuelaId, cicloId, "");
		if(lisAlumnos.size() > 0){
			System.out.println("datoos "+ cicloId + " " + escuelaId + " " + lisAlumnos.size());
			Connection  conn2 				= null;
			Statement   stmt2 				= null;
			ResultSet   rset2 				= null;
			String COMANDO 					= "";
			int cont						= 0;
			org.postgresql.largeobject.LargeObject obj			= null;
			org.postgresql.largeobject.LargeObjectManager lobj	= null;
			// Elegir el mejor ciclo
		
			/* --- PONER EN UN ARCHIVO .ZIP LAS IMAGENES --- */
			try{ 
				System.out.println("Respaldando...");
				
				String zipFile = dir+"respaldoAl.zip";
				FileOutputStream fout	= new FileOutputStream(zipFile);
				ZipOutputStream zout	= new ZipOutputStream(new BufferedOutputStream(fout));
				
				ArrayList<String> listCodes = new ArrayList<String>();
				for(aca.vista.AlumInscrito listaAl : lisAlumnos){
					
					// Avoid duplicate ids
					if(listCodes.contains(listaAl.getCodigoId())){
						System.out.println("Id repetido");
						continue;
					}else{
						listCodes.add(listaAl.getCodigoId());
					}
					
					String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
					java.io.File f = new java.io.File(dirAlumnos+"/"+listaAl.getCodigoId()+".jpg");
					if(f.exists()){
						System.out.println(listaAl.getCodigoId());
						String NombreArch 		= listaAl.getCodigoId()+".jpg";
						//System.out.println(NombreArch);
						//System.out.println("Nombre de Archivo:"+NombreArch);
					    zout.putNextEntry(new ZipEntry(NombreArch));
						 FileInputStream fis = new FileInputStream(f);
						 
						 byte[] buffer = new byte[4092];
					        int byteCount = 0;
					        while ((byteCount = fis.read(buffer)) != -1)
					        {
					            zout.write(buffer, 0, byteCount);
					            System.out.print('.');
					            System.out.flush();
					        }
					        cont++;
					        fis.close();
						    zout.closeEntry();
					}else{
						withoutPhotos = true;
					}
				    
					
				 }
				
				
				zout.close();
				fout.close();
				
				
				 System.out.println("OK... "+String.valueOf(cont) + " archivos respaldados...");	
			}catch (Exception ex){
				ex.printStackTrace();
				errorMessage = ex.getMessage();
				error = true;
			}
		}else{
			withoutUsers = true;	
		}
	}else{
		ArrayList<aca.empleado.EmpPersonal> lisEmpleadosActivos 	= empeladosLista.listEmpleados(conElias, escuelaId, "'E'","'A'", "ORDER BY NOMBRE,APATERNO,AMATERNO");
		if(lisEmpleadosActivos.size() > 0){
			int cont						= 0;
			System.out.println("Empleados " + lisEmpleadosActivos.size());
			try{ 
				System.out.println("Respaldando...");
				
				String zipFile = dir+"respaldoEmp.zip";
				System.out.println(zipFile);
				FileOutputStream fout	= new FileOutputStream(zipFile);
				ZipOutputStream zout	= new ZipOutputStream(new BufferedOutputStream(fout));
				
				
				ArrayList<String> listCodes = new ArrayList<String>();
				for(aca.empleado.EmpPersonal listaAl : lisEmpleadosActivos){
					
					// Avoid duplicate ids
					if(listCodes.contains(listaAl.getCodigoId())){
						System.out.println("Id repetido");
						continue;
					}else{
						listCodes.add(listaAl.getCodigoId());
					}
					
					String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
					java.io.File f = new java.io.File(dirAlumnos+"/"+listaAl.getCodigoId()+".jpg");
					if(f.exists()){
					
						String NombreArch 		= listaAl.getCodigoId()+".jpg";
						//System.out.println(NombreArch);
						//System.out.println("Nombre de Archivo:"+NombreArch);
					    zout.putNextEntry(new ZipEntry(NombreArch));
						 FileInputStream fis = new FileInputStream(f);
						 
						 byte[] buffer = new byte[4092];
					        int byteCount = 0;
					        while ((byteCount = fis.read(buffer)) != -1)
					        {
					            zout.write(buffer, 0, byteCount);
					            System.out.print('.');
					            System.out.flush();
					        }
					        cont++;
					        fis.close();
						    zout.closeEntry();
					}else{
						withoutPhotos = true;
					}
				    
					
				 }
				
				
				zout.close();
				fout.close();
				
				System.out.println(" => " + withoutPhotos);	
				System.out.println("OK... "+String.valueOf(cont) + " archivos respaldados...");	
			}catch (Exception ex){
				ex.printStackTrace();
				errorMessage = ex.getMessage();
				error = true;
			}
		}else{
			withoutUsers = true;	
		}
	}
	
	
	if(error){
		if(request.getParameter("empleados")==null){
			new File(dir+"respaldoAl.zip").delete();
		}else{
			new File(dir+"respaldoEmp.zip").delete();
		}
		out.print("error: " + errorMessage);
	}
	else if(withoutPhotos){
		out.print("withoutPhotos");
	}
	else if(withoutUsers){
		out.print("withoutUsers");
	}
%>

<%@ include file="../../cierra_elias.jsp"%>