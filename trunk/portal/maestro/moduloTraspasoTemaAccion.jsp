<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "../../con_elias_dir.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<jsp:useBean id="ModuloFrom" scope="page" class="aca.ciclo.CicloGpoModulo"/>
<jsp:useBean id="ModuloL" scope="page" class="aca.ciclo.CicloGpoModuloLista"/>
<jsp:useBean id="Tema" scope="page" class="aca.ciclo.CicloGpoTema"/>
<jsp:useBean id="TemaFrom" scope="page" class="aca.ciclo.CicloGpoTema"/>
<jsp:useBean id="TemaL" scope="page" class="aca.ciclo.CicloGpoTemaLista"/>
<jsp:useBean id="Tarea" scope="page" class="aca.ciclo.CicloGrupoTarea"/>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>
<jsp:useBean id="Archivo" scope="page" class="aca.ciclo.CicloGrupoArchivo"/>
<jsp:useBean id="ArchivoL" scope="page" class="aca.ciclo.CicloGrupoArchivoLista" />


<%
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

	String codigoId 	= (String)session.getAttribute("codigoId");

	
	String msj 				= "";
	String cambiarOrden		= "0";//****
	String move 			= request.getParameter("move")==null?"0":request.getParameter("move");
	String temaIdMove		= request.getParameter("temaIdToMove")==null?"":request.getParameter("temaIdToMove");
	
			
	String cicloGrupoIdFrom		= request.getParameter("cicloGrupoIdFrom");
	String cursoIdFrom 			= request.getParameter("cursoIdFrom");
	String temaIdFrom			= request.getParameter("temaIdFrom")==null?"0":request.getParameter("temaIdFrom");
	String moduloIdFrom			= request.getParameter("moduloIdFrom")==null?"0":request.getParameter("moduloIdFrom");
	
	String cicloGrupoIdTo 		= request.getParameter("cicloGrupoIdTo")==null?"":request.getParameter("cicloGrupoIdTo");
	String cursoIdTo 				= request.getParameter("cursoIdTo")==null?"":request.getParameter("cursoIdTo");
	String moduloIdTo			= request.getParameter("moduloIdTo")==null?"0":request.getParameter("moduloIdTo");
	
	
	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	
	
	if(accion.equals("1")){//Agregar tema al módulo
		
		conElias.setAutoCommit(false);
		
		boolean grabo = true;
		
		//for(aca.ciclo.CicloGpoTema tema: temas){
		aca.ciclo.CicloGpoTema tema = new aca.ciclo.CicloGpoTema();
		
		tema.mapeaRegId(conElias, cicloGrupoIdFrom, temaIdFrom, cursoIdFrom);
		
		
		Tema.setCicloGrupoId(cicloGrupoIdTo);
		Tema.setCursoId(cursoIdTo);
		Tema.setTemaNombre(tema.getTemaNombre());
		Tema.setDescripcion(tema.getDescripcion());
		Tema.setModuloId(moduloIdTo);
		Tema.setTemaId(Tema.maximoReg(conElias));
		Tema.setOrden(tema.getOrden());
		Tema.setFecha(sdf.format(new Date()));

		
		if(Tema.insertReg(conElias)){
			
			ArrayList<aca.ciclo.CicloGrupoTarea> tareas = TareaL.getListTareasTema(conElias, cicloGrupoIdFrom, cursoIdFrom, temaIdFrom, "");
			for(aca.ciclo.CicloGrupoTarea tarea: tareas){
				if(grabo==false){
					break;
				}
				
				Tarea.setCicloGrupoId(cicloGrupoIdTo);
				Tarea.setCursoId(cursoIdTo);
				Tarea.setTareaNombre(tarea.getTareaNombre());
				Tarea.setDescripcion(tarea.getDescripcion());
				Tarea.setFecha(tarea.getFecha());
				Tarea.setTemaId(Tema.getTemaId());
				Tarea.setTareaId(Tarea.maximoReg(conElias));
				
				if(!Tarea.insertReg(conElias)){
					grabo = false;
					msj = "ErrorAlTraspasarTareas";
					break;
				}
				
			}
			
			/* los archivos estan al mismo nivel que las tareas pero se grabarán despues de las mismas */
			ArrayList<aca.ciclo.CicloGrupoArchivo> lisArchivo = ArchivoL.getListTema(conElias, cicloGrupoIdFrom, cursoIdFrom, temaIdFrom, "");
			
			for(aca.ciclo.CicloGrupoArchivo archivo: lisArchivo){
				
				Archivo.setCicloGrupoId(cicloGrupoIdTo);
				Archivo.setCursoId(cursoIdTo);
				Archivo.setTemaId(Tema.getTemaId());
				Archivo.setFolio(archivo.getFolio());
				Archivo.setArchivo(archivo.getArchivo());
				Archivo.setDescripcion(archivo.getDescripcion());
				Archivo.setNombre(archivo.getNombre());
				
				if(!Archivo.insertReg(conElias)){
					grabo = false;
					msj = "ErrorAlTraspasarTareas1";
					break;
				}
			}
			
		}else{
			grabo = false;
			msj = "ErrorAlTraspasarTemas";
		}
		
		if(grabo==false){
			conElias.rollback();
		}else{
			conElias.commit();
			msj = "SeTraspasoPlaneacion";
			cambiarOrden = "1";//****
		}
		
		conElias.setAutoCommit(true);
		try{
			response.sendRedirect("moduloTraspasoTema.jsp?moduloId="+moduloIdFrom+"&temaId="+temaIdFrom+"&msj="+msj+"&cursoIdToFocus="+cursoIdTo+"&moduloIdTo="+moduloIdTo+"&cambiarOrden="+cambiarOrden);//*****
		}catch(Exception e){
			System.out.println("portal/maestro/moduloTraspasoTemaAccion.jsp Excepcion:\n"+e);
			pageContext.setAttribute("resultado", msj);
%>
			<head>
				<meta http-equiv="refresh" content="0; url=moduloTraspasoTema.jsp?moduloId=<%=moduloIdFrom%>&temaId=<%=temaIdFrom%>&msj=<%=msj%>&cursoIdToFocus=<%=cursoIdTo%>&moduloIdTo=<%=moduloIdTo %>&cambiarOrden=<%=cambiarOrden%>" /><!-- ***** -->
			</head>
			<body>
				<div class="alert alert-success">
					<fmt:message key="aca.${resultado}" />
				</div>
			</body>	
<%
		}
	}else if(accion.equals("2")){//Reemplazar tema
		String temaIdTo		= request.getParameter("temaIdTo");
		boolean borro  		= true;
		
		conEliasDir.setAutoCommit(false);
		
		ArrayList<aca.ciclo.CicloGrupoTarea> tareasDel = TareaL.getListTareasTema(conEliasDir, cicloGrupoIdTo, cursoIdTo, temaIdTo, "");
		if(!tareasDel.isEmpty()){
			for(aca.ciclo.CicloGrupoTarea tarea: tareasDel){
				if (!tarea.deleteReg(conEliasDir)){
					msj = "NoEliminoTarea";
					borro = false;
					break;
				}
			}
		}
		
		//borra archivos
		ArrayList<aca.ciclo.CicloGrupoArchivo> lisArchivoDel = ArchivoL.getListTema(conEliasDir, cicloGrupoIdTo, cursoIdTo, temaIdTo, "");
		if(!lisArchivoDel.isEmpty()){
			for(aca.ciclo.CicloGrupoArchivo archivo: lisArchivoDel){
				if(archivo.existeReg(conEliasDir)){
				
					if( archivo.getCantidadOID(conEliasDir, archivo.getArchivo()) > 1 ){//Si existe mas de un registro con este OID entonces elimina solo el registro, no el archivo
						if(!archivo.deleteSoloRegistro(conEliasDir)){
							msj = "NoEliminoArchivo";
							borro = false;
							break;
						}
					}else{//Si solo hay un registro con este OID elimina el registro y el archivo 
						if(!archivo.deleteReg(conEliasDir)){
							msj = "NoEliminoArchivo";
							borro = false;
							break;
						}	
					}
				}else{
					borro = false;
			   	}
			}
		}
		
		aca.ciclo.CicloGpoTema tema = new aca.ciclo.CicloGpoTema();
		tema.mapeaRegId(conEliasDir, cicloGrupoIdFrom, temaIdFrom, cursoIdFrom);
				
		Tema.setCicloGrupoId(cicloGrupoIdTo);
		Tema.setCursoId(cursoIdTo);
		Tema.setTemaNombre(tema.getTemaNombre());
		Tema.setDescripcion(tema.getDescripcion());
		Tema.setModuloId(moduloIdTo);
		Tema.setTemaId(temaIdTo);
		Tema.setOrden(tema.getOrden());
		Tema.setFecha(sdf.format(new Date()));
		
		if(Tema.updateReg(conEliasDir)){
			
			ArrayList<aca.ciclo.CicloGrupoTarea> tareas = TareaL.getListTareasTema(conEliasDir, cicloGrupoIdFrom, cursoIdFrom, temaIdFrom, "");
			if(!tareas.isEmpty()){
				for(aca.ciclo.CicloGrupoTarea tarea: tareas){
					if(borro==false){
						break;
					}
					
					Tarea.setCicloGrupoId(cicloGrupoIdTo);
					Tarea.setCursoId(cursoIdTo);
					Tarea.setTareaNombre(tarea.getTareaNombre());
					Tarea.setDescripcion(tarea.getDescripcion());
					Tarea.setFecha(tarea.getFecha());
					Tarea.setTemaId(Tema.getTemaId());
					Tarea.setTareaId(Tarea.maximoReg(conEliasDir));
					
					if(!Tarea.insertReg(conEliasDir)){
						borro = false;
						msj = "ErrorAlTraspasarTareas";
						break;
					}
					
				}
			}
			/* los archivos estan al mismo nivel que las tareas pero se grabarán despues de las mismas */
			ArrayList<aca.ciclo.CicloGrupoArchivo> lisArchivo = ArchivoL.getListTema(conEliasDir, cicloGrupoIdFrom, cursoIdFrom, temaIdFrom, "");
			if(!lisArchivo.isEmpty()){
				for(aca.ciclo.CicloGrupoArchivo archivo: lisArchivo){
					
					Archivo.setCicloGrupoId(cicloGrupoIdTo);
					Archivo.setCursoId(cursoIdTo);
					Archivo.setTemaId(Tema.getTemaId());
					Archivo.setFolio(archivo.getFolio());
					Archivo.setArchivo(archivo.getArchivo());
					Archivo.setDescripcion(archivo.getDescripcion());
					Archivo.setNombre(archivo.getNombre());
					
					if(!Archivo.insertReg(conEliasDir)){
						borro = false;
						msj = "ErrorAlTraspasarArchivo";
						break;
					}
				}
			}
			
		}else{
			borro = false;
			msj = "ErrorAlTraspasarTema";
		}
		
		if(!borro){
			conEliasDir.rollback();
		}else{
			conEliasDir.commit();
			msj = "SeTraspasoPlaneacion";
		}
			
		conEliasDir.setAutoCommit(true);
		try{
			response.sendRedirect("moduloTraspasoTema.jsp?moduloId="+moduloIdFrom+"&temaId="+temaIdFrom+"&msj="+msj+"&cursoIdToFocus="+cursoIdTo+"&moduloIdTo="+moduloIdTo+"&cambiarOrden="+cambiarOrden);//*****
		}catch(Exception e){
			System.out.println("portal/maestro/moduloTraspasoTemaAccion.jsp Excepcion:\n"+e);
			pageContext.setAttribute("resultado", msj);
%>
			<head>
				<meta http-equiv="refresh" content="0; url=moduloTraspasoTema.jsp?moduloId=<%=moduloIdFrom%>&temaId=<%=temaIdFrom%>&msj=<%=msj%>&cursoIdToFocus=<%=cursoIdTo%>" />
			</head>
			<body>
				<div class="alert alert-success">
					<fmt:message key="aca.${resultado}" />
				</div>
			</body>	
<%
		}
	}else if(accion.equals("3")){//Cambiar de posicion el tema
		String temaIdTo		= request.getParameter("temaIdTo");
		conElias.setAutoCommit(false);
		
		//Checa si estan en desorden
		ArrayList<aca.ciclo.CicloGpoTema> listTema = TemaL.getListTemasModulo(conElias, cicloGrupoIdTo, cursoIdTo, moduloIdTo, "ORDER BY ORDEN, MODULO_ID");
		double tmp = 0;
		boolean desorden = false; 
		for(aca.ciclo.CicloGpoTema tema: listTema){
			if(Double.parseDouble((tema.getOrden())) != tmp && Double.parseDouble((tema.getOrden()))-1 == tmp){
				tmp = Double.parseDouble(tema.getOrden());
			}else{
				desorden = true;
				break;
			}
		}
		//ordena los temas
		if(desorden){
			boolean ordeno = true;
			for(int k = 0; k < listTema.size();){
				aca.ciclo.CicloGpoTema cgt = listTema.get(k);
				cgt.setOrden(Double.toString((double)++k));
				if(!cgt.updateReg(conElias)){
					ordeno = false;
					msj += " NoSeOrdenaronTemas";
				}
				if(!ordeno){
					conElias.rollback();
				}else{
					conElias.commit();
					msj += " SeOrdenaronTemas";
				}
			}
		}
		//
		
		boolean cambio = true;
		
		aca.ciclo.CicloGpoTema tema1 = new aca.ciclo.CicloGpoTema();
		tema1.mapeaRegId(conElias, cicloGrupoIdTo, temaIdTo, cursoIdTo);
		
		aca.ciclo.CicloGpoTema tema2 = new aca.ciclo.CicloGpoTema();
		tema2.mapeaRegId(conElias, cicloGrupoIdFrom, temaIdMove, cursoIdTo);
		
		String ordenTema1 = tema1.getOrden();
		tema1.setOrden(tema2.getOrden());
		tema2.setOrden(ordenTema1);
		
		if(tema1.updateReg(conElias)){
			if(tema2.updateReg(conElias)){
				msj = "SeCambiaronLosTemas";
			}else{
				cambio = false;
				msj = "NoSeCambionTema2";
			}
		}else{
			cambio = false;
			msj = "NoSeCambioTema1";
		}
		
		if(!cambio){
			conElias.rollback();
		}else{
			conElias.commit();
			msj = "SeTraspasoPlaneacion";
			cambiarOrden = "1";
		}
			
		conElias.setAutoCommit(true);
		try{
			response.sendRedirect("moduloTraspasoTema.jsp?moduloId="+moduloIdFrom+"&temaId="+temaIdFrom+"&msj="+msj+"&cursoIdToFocus="+cursoIdTo+"&cambiarOrden="+cambiarOrden);
		}catch(Exception e){
			System.out.println("portal/maestro/moduloTraspasoTemaAccion.jsp Excepcion:\n"+e);
			pageContext.setAttribute("resultado", msj);
%>
			<head>
				<meta http-equiv="refresh" content="0; url=moduloTraspasoTema.jsp?moduloId=<%=moduloIdFrom%>&temaId=<%=temaIdFrom%>&msj=<%=msj%>&cursoIdToFocus=<%=cursoIdTo%>&moduloIdTo=<%=moduloIdTo %>&cambiarOrden=<%=cambiarOrden%>" /><!-- ***** -->
			</head>
			<!--  Parte que muestra el "se grabó" el tema en el nuevo módulo
			<body>
				<div class="alert alert-success">
					<fmt:message key="aca.${resultado}" />
				</div>
			</body> 
			-->	
<%
		}
		
	}
	
	
	
%>
<%@ include file="../../cierra_elias_dir.jsp" %>
<%@ include file= "../../cierra_elias.jsp" %>