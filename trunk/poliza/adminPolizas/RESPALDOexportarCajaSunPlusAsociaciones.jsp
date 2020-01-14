<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinMovimientosLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="FinDescargaSunplus" scope="page" class="aca.fin.FinDescargaSunplus"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinPolizaL" scope="page" class="aca.fin.FinPolizaLista"/>
<jsp:useBean id="CatAsocL" scope="page" class="aca.catalogo.CatAsociacionLista"/>
<jsp:useBean id="CatEscuelaL" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="AlumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="CatNivelEscuelaL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
	
<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("##0.00;(##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String usuario 		= (String)session.getAttribute("codigoId");
	
	/* ASOCIACIONES DEL USUARIO */
	String strAsociacionesDelUsuario = "";
	ArrayList<String> AsociacionesDelUsuario = aca.usuario.Usuario.AsociacionesDelUsuario(conElias, usuario);
	for(String asocId : AsociacionesDelUsuario){
		strAsociacionesDelUsuario += "'"+asocId+"',";
	}
	strAsociacionesDelUsuario=strAsociacionesDelUsuario.substring(0, strAsociacionesDelUsuario.length()-1);	
	
	/* LISTA DE MOVIMIENTOS DE CAJA DE LAS ASOCIACIONES DEL USUARIO */	
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovimientosLista.getMovimientosAsociaciones(conElias, strAsociacionesDelUsuario, "C" /* 'C' DE CAJA */, "C" /* NATURALEZA 'C', PORQUE LOS 'D' SON LOS MOVIMIENTOS QUE CUADRAN LA POLIZA Y ESOS NO SE VAN AL SUNPLUS */, " ORDER BY ASOCIACION_ESCUELA(SUBSTR(POLIZA_ID, 1, 3)), SUBSTR(POLIZA_ID, 1, 3), RECIBO_ID DESC, FECHA DESC ");
	
	/* MAP DE CUENTAS */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 					= FinCuentaL.mapCuentasAsociacion(conElias, strAsociacionesDelUsuario);
	
	/* MAP DE INFORMACION DE LAS POLIZAS */
	java.util.HashMap<String, aca.fin.FinPoliza> mapPolizas      			= FinPolizaL.getPolizasAsociacion(conElias, strAsociacionesDelUsuario);
	
	/* MAP DE INFORMACION DE LA ASOCIACION */
	java.util.HashMap<String, aca.catalogo.CatAsociacion> mapAsociaciones 	= CatAsocL.getMapAll(conElias, "");
	
	/* MAP DE INFORMACION DE LA ESCUELA */
	java.util.HashMap<String, aca.catalogo.CatEscuela> mapEscuelas 			= CatEscuelaL.getMapAll(conElias, "");
	
	/* MAP DE INFORMACION DE LOS ALUMNOS */
	java.util.HashMap<String, aca.alumno.AlumPersonal> mapAlumnos 			= AlumPersonalL.mapAlumnosAsociacion(conElias, strAsociacionesDelUsuario);
	
	/* MAP DE INFORMACION DE LOS NIVELES POR ESCUELA */
	java.util.HashMap<String, aca.catalogo.CatNivelEscuela> mapNivelEscuela	= CatNivelEscuelaL.mapNivelEscuela(conElias, strAsociacionesDelUsuario);
	
	
	/* CUENTAS SUNPLUS */
	java.util.HashMap<String, String> cuentasSunPlus = new java.util.HashMap<String, String>();
	cuentasSunPlus.put("621110", "ENSEÑANZA");
	cuentasSunPlus.put("622110", "INGRESOS POR INSCRIPCIÓN");
	cuentasSunPlus.put("601110", "TIENDA ESCOLAR");
	cuentasSunPlus.put("601120", "UNIFORMES ESTUDIANTES");
	cuentasSunPlus.put("671140", "INGRESOS POR OTROS SERVICIOS");
	cuentasSunPlus.put("622120", "DERECHO A EXAMEN");
	cuentasSunPlus.put("622140", "SALA DE TAREAS");
	cuentasSunPlus.put("622150", "INGRESOS CLÍNICA NACIONALES");
	cuentasSunPlus.put("671120", "RECARGO ESTUDIANTIL");
	
	
	
	/* ================== VALIDAR MOVIMIENTOS ================== */
			
	ArrayList<String> polizas 							= new ArrayList<String>();

	ArrayList<String> cuentasNoAsociadas 				= new ArrayList<String>();
	ArrayList<String> asociacionesNoIdentificadas 		= new ArrayList<String>();
	ArrayList<String> escuelasSinOrgId 					= new ArrayList<String>();
	ArrayList<String> escuelasSinDistrito				= new ArrayList<String>();
	ArrayList<String> escuelasConNivelesSinFuncion		= new ArrayList<String>();
	ArrayList<String> asociacionesSinFondo				= new ArrayList<String>();

	for(aca.fin.FinMovimientos mov : movimientos){
		if(mov.getEstado().equals("C")){ continue; }
				
		String cuentaNombre 	= mov.getCuentaId();
		String cuentaSunPlus 	= "-"; 
		if(mapCuenta.containsKey(mov.getCuentaId())){
			cuentaNombre 	= mapCuenta.get(mov.getCuentaId()).getCuentaNombre();
			cuentaSunPlus 	= mapCuenta.get(mov.getCuentaId()).getCuentaSunPlus();
		}
		
		String escuelaId 			= mov.getCuentaId().substring(0,3);
		String asociacionId 		= mapEscuelas.containsKey(escuelaId) ? mapEscuelas.get(escuelaId).getAsociacionId() : "-"; 
		String orgIdEscuela 		= mapEscuelas.containsKey(escuelaId) ? mapEscuelas.get(escuelaId).getOrgId() : "-";
		String distritoEscuela		= mapEscuelas.containsKey(escuelaId) ? mapEscuelas.get(escuelaId).getDistrito() : "-";
		
		String nivelAlumno			= mapAlumnos.containsKey(mov.getAuxiliar()) ? mapAlumnos.get(mov.getAuxiliar()).getNivelId() : "-";
		String funcionIdNivel		= mapNivelEscuela.containsKey(escuelaId+"@@"+nivelAlumno) ? mapNivelEscuela.get(escuelaId+"@@"+nivelAlumno).getFuncionId() : "-";
		
		String polizaDescripcion 	= mapPolizas.containsKey(mov.getEjercicioId()+"@@"+mov.getPolizaId()) ? mapPolizas.get(mov.getEjercicioId()+"@@"+mov.getPolizaId()).getDescripcion() : "-";
		String fondoIdAsociacion 	= mapAsociaciones.containsKey(asociacionId) ? mapAsociaciones.get(asociacionId).getFondoId() : "-";
		float importe 				= Float.parseFloat(mov.getImporte());
		
		
		if(polizas.contains(mov.getEjercicioId()+mov.getPolizaId()) == false){
			polizas.add(mov.getEjercicioId()+mov.getPolizaId());
		}
		
		/* ========== VERIFICACIONES ========== */
		
				
	
		/* VERIFICAR LAS CUENTAS QUE NO TIENEN ASOCIADAS UNA CUENTA EN SUNPLUS */
		if( cuentasSunPlus.containsKey(cuentaSunPlus) == false ){
			if(cuentasNoAsociadas.contains(mov.getCuentaId()) == false){
				cuentasNoAsociadas.add(mov.getCuentaId());
			}
		}
		
		/* VERIFICAR SI HAY ALGUNA ASOCIACION NO VALIDA */
		if( asociacionId.equals("-") ){
			if(asociacionesNoIdentificadas.contains(escuelaId) == false){
				asociacionesNoIdentificadas.add(escuelaId);
			}
		}
		
		/* VERIFICAR SI HAY ALGUNA ESCUELA SIN ORG_ID */
		if( orgIdEscuela.trim().equals("-") || orgIdEscuela.trim().equals("") ){
			if(escuelasSinOrgId.contains(escuelaId) == false){
				escuelasSinOrgId.add(escuelaId);
			}
		}
		
		/* VERIFICAR SI HAY ALGUNA ESCUELA SIN DISTRITO */
		if( distritoEscuela.trim().equals("-") || distritoEscuela.trim().equals("") ){
			if(escuelasSinDistrito.contains(escuelaId) == false){
				escuelasSinDistrito.add(escuelaId);
			}
		}
		
		/* VERIFICAR SI HAY ALGUNA ESCUELA QUE TIENE NIVELES SIN FUNCION */
		if( funcionIdNivel.trim().equals("-") || funcionIdNivel.trim().equals("") ){
			if(escuelasConNivelesSinFuncion.contains(escuelaId) == false){
				escuelasConNivelesSinFuncion.add(escuelaId);
			}
		}
		
		/* VERIFICAR SI HAY ALGUNA ASOCIACION SIN FONDO */
		if( fondoIdAsociacion.trim().equals("-") || fondoIdAsociacion.trim().equals("") ){
			if(asociacionesSinFondo.contains(asociacionId) == false){
				asociacionesSinFondo.add(asociacionId);
			}
		}
			
	}
	
	
	/* ================== END VALIDAR MOVIMIENTOS ================== */
	
	
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Movimientos" />
	</h2>
	
	<div class="alert alert-info">
		Número de polizas con movimientos: <%=polizas.size() %>
	</div>
		
	<div class="well">
		<a href="asociacion.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	
<!-- ========  FEEDBACK DE VALIDACIONES ======== -->
		
	<%if(cuentasNoAsociadas.size()>0){%>
		
		<div class="alert alert-danger">
			<fmt:message key="aca.ErrorExportacionSunPlusCuentas" />
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Escuela" /></th>
				<th><fmt:message key="aca.Cuenta" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
				<th><fmt:message key="aca.CuentaSunPlus" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String str: cuentasNoAsociadas){
					cont++;
					String cuentaNombre 	= str;
					String cuentaSunPlus 	= "-"; 
					if(mapCuenta.containsKey(str)){
						cuentaNombre 	= mapCuenta.get(str).getCuentaNombre();
						cuentaSunPlus 	= mapCuenta.get(str).getCuentaSunPlus();
					}
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=aca.catalogo.CatEscuela.getNombre(conElias, str.substring(0,3)) %></td>
					<td><%=str %></td>
					<td><%=cuentaNombre %></td>
					<td><%=cuentaSunPlus %></td>
				</tr>
			<%} %>
		</table>
	
	<%} %>
	
	<%if(asociacionesNoIdentificadas.size()>0){ %>
	
		<div class="alert alert-danger">
			Las siguientes escuelas no tienen <strong>una asociación válida</strong>, favor de arreglarlo en el catálogo de escuelas para poder realizar la exportación correctamente.
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Escuela" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String str: asociacionesNoIdentificadas){
					cont++;
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=str%> | <%=aca.catalogo.CatEscuela.getNombre(conElias, str) %></td>
				</tr>
			<%} %>
		</table>
	
	<%} %>	
		
	<%if(escuelasSinOrgId.size()>0){ %>
	
		<div class="alert alert-danger">
			Las siguientes escuelas no tienen <strong>OrgId</strong>, favor de arreglarlo en el catálogo de escuelas para poder realizar la exportación correctamente.
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Escuela" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String str: escuelasSinOrgId){
					cont++;
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=str%> | <%=aca.catalogo.CatEscuela.getNombre(conElias, str) %></td>
				</tr>
			<%} %>
		</table>
		
	<%} %>
		
	<%if(escuelasSinDistrito.size()>0){ %>
	
		<div class="alert alert-danger">
			Las siguientes escuelas no tienen <strong>distrito</strong>, favor de arreglarlo en el catálogo de escuelas para poder realizar la exportación correctamente.
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Escuela" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String str: escuelasSinDistrito){
					cont++;
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=str%> | <%=aca.catalogo.CatEscuela.getNombre(conElias, str) %></td>
				</tr>
			<%} %>
		</table>
		
	<%} %>
		
	<%if(escuelasConNivelesSinFuncion.size()>0){ %>
	
		<div class="alert alert-danger">
			Las siguientes escuelas cuentan con niveles sin <strong>función</strong>, favor de agregarle a cada nivel de estas escuelas su función en el catalogo de niveles para poder realizar la exportación correctamente.
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Escuela" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String str: escuelasConNivelesSinFuncion){
					cont++;
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=str%> | <%=aca.catalogo.CatEscuela.getNombre(conElias, str) %></td>
				</tr>
			<%} %>
		</table>	
		
	<%} %>
		
	<%if(asociacionesSinFondo.size()>0){ %>
	
		<div class="alert alert-danger">
			Las siguientes asociaciones no tienen <strong>fondo</strong>, favor de agregarlo en el catálogo de asociaciones para poder realizar la exportación correctamente.
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Escuela" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String str: asociacionesSinFondo){
					cont++;
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=str%> | <%=aca.catalogo.CatAsociacion.getNombre(conElias, str) %></td>
				</tr>
			<%} %>
		</table>		
		
	<%} %>
		
<!-- ======== END FEEDBACK DE VALIDACIONES ======== -->
	
	<%if(
		movimientos.size() > 0 &&		
		cuentasNoAsociadas.size() == 0 && 
		asociacionesNoIdentificadas.size() == 0 && 
		escuelasSinOrgId.size() == 0 && 			
		escuelasSinDistrito.size() == 0 &&		
		escuelasConNivelesSinFuncion.size() == 0 &&
		asociacionesSinFondo.size() == 0		
	){%>

		<table class="table table-condensed table-bordered table-striped" id="tabla-movs">
			<thead>
				<tr>
					<th>Trans Reference</th>
					<th>Cod Cuenta</th>
					<th>Nombre de Cuenta</th>
					<th>TFWW</th>
					<th>Fondo</th>
					<th>Funcion</th>
					<th>Restr</th>
					<th>OrgID</th>
					<th>Who</th>
					<th>Detalles</th>
					<th>Proyecto</th>
					<th>Descripción Transaccion</th>
					<th>Cantidad</th>
					<th>Mone</th>
					<th>Flag</th>
					<th>Allctn</th>
				</tr>
			</thead>
			
			<!--  ===== MOVIMIENTOS =====  -->
			 
			<%
			
				for(aca.fin.FinMovimientos mov : movimientos){
					if(mov.getEstado().equals("C")){ continue; }
					
					String cuentaNombre 	= mov.getCuentaId();
					String cuentaSunPlus 	= "-"; 
					if(mapCuenta.containsKey(mov.getCuentaId())){
						cuentaNombre 	= mapCuenta.get(mov.getCuentaId()).getCuentaNombre();
						cuentaSunPlus 	= mapCuenta.get(mov.getCuentaId()).getCuentaSunPlus();
					}
				
					String escuelaId 			= mov.getCuentaId().substring(0,3);
					String asociacionId 		= mapEscuelas.containsKey(escuelaId) ? mapEscuelas.get(escuelaId).getAsociacionId() : "-"; 
					String orgIdEscuela 		= mapEscuelas.containsKey(escuelaId) ? mapEscuelas.get(escuelaId).getOrgId() : "-";
					String distritoEscuela		= mapEscuelas.containsKey(escuelaId) ? mapEscuelas.get(escuelaId).getDistrito() : "-";
					
					String nivelAlumno			= mapAlumnos.containsKey(mov.getAuxiliar()) ? mapAlumnos.get(mov.getAuxiliar()).getNivelId() : "-";
					String funcionIdNivel		= mapNivelEscuela.containsKey(escuelaId+"@@"+nivelAlumno) ? mapNivelEscuela.get(escuelaId+"@@"+nivelAlumno).getFuncionId() : "-";
					
					String polizaDescripcion 	= mapPolizas.containsKey(mov.getEjercicioId()+"@@"+mov.getPolizaId()) ? mapPolizas.get(mov.getEjercicioId()+"@@"+mov.getPolizaId()).getDescripcion() : "-";
					String fondoIdAsociacion 	= mapAsociaciones.containsKey(asociacionId) ? mapAsociaciones.get(asociacionId).getFondoId() : "-";
					float importe 				= Float.parseFloat(mov.getImporte());
					
				/* ============== MOVIMIENTOS DE ENSENANZA ============== */
						
						
					if( cuentaSunPlus.equals("621110") ){
			%>
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>101110</td>
								<td>CAJA</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right">-<%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>621110</td>
								<td><%=cuentasSunPlus.containsKey("621110")==true ? cuentasSunPlus.get("621110") : "-" %></td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right"><%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>370120</td>
								<td>INGRESOS DIFERIDOS POR ENSEÑANZA</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right">-<%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>134ALUM01</td>
								<td>ALUMNO</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right"><%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
						
			<%
			
			
					/* ============== MOVIMIENTOS DE INGRESOS POR INSCRIPCION ============== */
			
			
					}else if( cuentaSunPlus.equals("622110") ){
			%>
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>101110</td>
								<td>CAJA</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right">-<%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>622110</td>
								<td><%=cuentasSunPlus.containsKey("622110")==true ? cuentasSunPlus.get("622110") : "-" %></td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right"><%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>370110</td>
								<td>INGRESOS DIFERIDOS POR INSCRIPCIÓN</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right">-<%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>134ALUM01</td>
								<td>ALUMNO</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right"><%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
			<%					
			
			
					/* ============== MOVIMIENTOS DE TIENDA ESCOLAR ============== */
			
			
					}else if( cuentaSunPlus.equals("601110") ){
			
						
			%>
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>101110</td>
								<td>CAJA</td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right">-<%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
							
							<tr>
								<td><%=polizaDescripcion %></td>
								<td>601110</td>
								<td><%=cuentasSunPlus.containsKey("601110")==true ? cuentasSunPlus.get("601110") : "-" %></td>
								<td></td>
								<td><%=fondoIdAsociacion %></td>
								<td><%=funcionIdNivel  %></td>
								<td>01</td>
								<td><%=orgIdEscuela %></td>
								<td></td>
								<td></td>
								<td><%=distritoEscuela %></td>
								<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
								<td class="text-right"><%=getformato.format( importe ) %></td>
								<td>DOP1</td>
								<td></td>
								<td></td>
							</tr>
			<%
		
			
					/* ============== MOVIMIENTOS DE UNIFORMES ESTUDIANTES ============== */
			
			
					}else if( cuentaSunPlus.equals("601120") ){
			
			
			%>
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>101110</td>
							<td>CAJA</td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>601120</td>
							<td><%=cuentasSunPlus.containsKey("601120")==true ? cuentasSunPlus.get("601120") : "-" %></td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
			<%
		
					
					/* ============== MOVIMIENTOS DE INGRESOS POR OTROS SERVICIOS ============== */
			
			
					}else if( cuentaSunPlus.equals("671140") ){
			
			
			%>
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>101110</td>
							<td>CAJA</td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>671140</td>
							<td><%=cuentasSunPlus.containsKey("671140")==true ? cuentasSunPlus.get("671140") : "-" %></td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
			<%
		
			
					/* ============== MOVIMIENTOS DE DERECHO A EXAMEN ============== */
			
			
					}else if( cuentaSunPlus.equals("622120") ){
			
			
			%>
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>101110</td>
							<td>CAJA</td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>622120</td>
							<td><%=cuentasSunPlus.containsKey("622120")==true ? cuentasSunPlus.get("622120") : "-" %></td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
			<%
		
			
					/* ============== MOVIMIENTOS DE SALA DE TAREAS ============== */
			
			
					}else if( cuentaSunPlus.equals("622140") ){
			
			
			%>
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>101110</td>
							<td>CAJA</td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>622140</td>
							<td><%=cuentasSunPlus.containsKey("622140")==true ? cuentasSunPlus.get("622140") : "-" %></td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
			<%		
		
					
					/* ============== MOVIMIENTOS DE INGRESOS CLINICA NACIONALES ============== */
			
			
					}else if( cuentaSunPlus.equals("622150") ){
			
			
			%>
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>101110</td>
							<td>CAJA</td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>622150</td>
							<td><%=cuentasSunPlus.containsKey("622150")==true ? cuentasSunPlus.get("622150") : "-" %></td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
			<%						
		
			
					/* ============== MOVIMIENTOS DE RECARGO ESTUDIANTIL ============== */
			
			
					}else if( cuentaSunPlus.equals("671120") ){
			
			
			%>
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>134ALUMN01</td>
							<td>ALUMNO</td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=polizaDescripcion %></td>
							<td>671120</td>
							<td><%=cuentasSunPlus.containsKey("671120")==true ? cuentasSunPlus.get("671120") : "-" %></td>
							<td></td>
							<td><%=fondoIdAsociacion %></td>
							<td><%=funcionIdNivel  %></td>
							<td>01</td>
							<td><%=orgIdEscuela %></td>
							<td></td>
							<td></td>
							<td><%=distritoEscuela %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
			<%	
					}
				
				
			
				}
			%>
			
			
			
			
			<!-- ======== CAMBIAR ESTADO POLIZA Y AGREGAR DESCARGA_ID ======== -->
			
			<%
				
				conElias.setAutoCommit(false);
				boolean error = false;
				
				String descargaId = FinDescargaSunplus.maxReg(conElias);
			
				ArrayList<String> polizasActualizadas = new ArrayList<String>();
				for(aca.fin.FinMovimientos mov : movimientos){
					if(mov.getEstado().equals("C")){ continue; }
					
					if(polizasActualizadas.contains(mov.getEjercicioId()+mov.getPolizaId()) == false){
						
						// CAMBIAR ESTADO DE LA POLIZA A CERRADO DEFINITIVAMENTE
						FinPoliza.setEjercicioId(mov.getEjercicioId());
						FinPoliza.setPolizaId(mov.getPolizaId());
						FinPoliza.setEstado("C");
						FinPoliza.setDescargaId(descargaId);
						
						if(FinPoliza.updateEstadoYDescargaId(conElias)){
							//todo chido
						}else{
							error = true; break;
						}
						
						polizasActualizadas.add(mov.getEjercicioId()+mov.getPolizaId());
					}
				}
				
				// GUARDAR LA DESCARGA DE LA POLIZA
				FinDescargaSunplus.setDescargaId(descargaId);
				FinDescargaSunplus.setCodigoId(usuario);
				FinDescargaSunplus.setFecha(aca.util.Fecha.getDateTime());
				FinDescargaSunplus.setTipoPoliza("C");
				
				if(FinDescargaSunplus.insertReg(conElias)){
					//todo chido
				}else{
					error = true;
				}
			
				if(error){
					conElias.rollback();
					out.print("<style>#tabla-movs{display:none;}</style><div class='alert alert-danger'>Ocurrió un error al hacer la exportación</div>");
				}else{
					conElias.commit();
					out.print("<div class='alert alert-success'>Se realizó la exportación</div>");
				}
				conElias.setAutoCommit(true);
				
			%>
			
			
		</table>		
	<%}%>

	
</div>	

<script src="../../js-plugins/tableToExcel/tableToExcel.js"></script>
	
<%@ include file= "../../cierra_elias.jsp" %>