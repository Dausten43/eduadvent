<%@ include file= "../../con_elias_dir.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<jsp:useBean id="archivo" scope="page" class="aca.ciclo.CicloGrupoArchivo" />
<%	
	String cicloGrupo 	= (String) session.getAttribute("cicloGrupoId");
	String cursoId 		= (String) session.getAttribute("cursoId");
	String temaId		= request.getParameter("TemaId");
	String modulo 		= temaId.substring(0,2);		
	String folio		= request.getParameter("Folio");
	String salto		= "X";
	
	
	boolean borroPg = false;
	try{		
		conEliasDir.setAutoCommit(false);
		
		archivo.setCicloGrupoId(cicloGrupo);
		archivo.setCursoId(cursoId);
		archivo.setTemaId(temaId);
		archivo.setFolio(folio);
		
		archivo.mapeaRegId(conEliasDir, cicloGrupo, cursoId, temaId, folio);
		
		if(archivo.existeReg(conEliasDir)){
			
			if( archivo.getCantidadOID(conEliasDir, archivo.getArchivo()) > 1 ){//Si existe mas de un registro con este OID entonces elimina solo el registro, no el archivo
				if(archivo.deleteSoloRegistro(conEliasDir)){
					borroPg = true;
					conEliasDir.commit();
				}
			}else{//Si solo hay un registro con este OID elimina el registro y el archivo 
				if(archivo.deleteReg(conEliasDir)){
					borroPg = true;
					conEliasDir.commit();
				}	
			}
		}else{
			borroPg = false;
	   	}		
		conEliasDir.setAutoCommit(true);
		
	    if(borroPg){
	    	salto = "modulo.jsp?ModuloId="+modulo;
	    }else{
%>
		<font size="4" color="red"><b><fmt:message key="aca.ErrorBorrarCorto"/></b> <a href="modulo.jsp?ModuloId=<%= modulo%>">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a></font><br>
<%
	    }
	}catch(Exception e){
		System.out.println("Error al borrar el archivo: "+e);
%>
		<font size="4" color="red"><b><fmt:message key="aca.ErrorBorrarCorto"/></b> <a href="modulo.jsp?ModuloId=<%= modulo%>">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a></font>
<%
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias_dir.jsp" %>