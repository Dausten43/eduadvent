<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file="../../seguro.jsp"%>

<%@ page import="java.util.*" %>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="escuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="paisLista" scope="page" class="aca.catalogo.CatPaisLista"/>
<jsp:useBean id="estadoLista" scope="page" class="aca.catalogo.CatEstadoLista"/>
<jsp:useBean id="ciudadLista" scope="page" class="aca.catalogo.CatCiudadLista"/>
<jsp:useBean id="asociacionLista" scope="page" class="aca.catalogo.CatAsociacionLista"/>
<jsp:useBean id="ejercicioL" scope="page" class="aca.fin.FinEjercicioLista" />

<head>
<%		
	String escuelaId			= "00"; 
	String sAccion				= request.getParameter("Accion")==null?"1":request.getParameter("Accion");
	int numAccion 				= Integer.parseInt(sAccion);
	String resultado			= "";
	String salto 				= "";  
	
	/* Lista completa de escuela */
	ArrayList<aca.catalogo.CatEscuela> lisEscuela		= escuelaLista.getListAll(conElias," ORDER BY ESCUELA_NOMBRE");
	
	/* Map de Paises */
	HashMap<String, aca.catalogo.CatPais> mapPaises 	= paisLista.getMapAll(conElias, "");
	
	/* Map de Estados */
	HashMap<String, aca.catalogo.CatEstado> mapEstados 	= estadoLista.getMapAll(conElias, "");
	
	/* Map de Ciudades */
	HashMap<String, aca.catalogo.CatCiudad> mapCiudades = ciudadLista.getMapAll(conElias, "");
	
	/* Map de Ciudades */
	HashMap<String, aca.catalogo.CatAsociacion> mapAsociacion = asociacionLista.getMapAll(conElias, "");
	
	switch (numAccion){
		case 1:{			
			if (lisEscuela.size() > 0)
				resultado = "ClickNombreEscuela";
			else
				resultado = "NoEncontro";
			break;
		} 
		case 2:{
			if (request.getParameter("EscuelaId").length()==1)
				escuelaId = "0"+request.getParameter("EscuelaId");
			else
				escuelaId = request.getParameter("EscuelaId");				
			session.setAttribute("escuela",escuelaId);
			session.setAttribute("cicloId",aca.ciclo.Ciclo.getMejorCargaEscuela(conElias, escuelaId));
			resultado = "RegistradoentuSesion";
			
			// Subir a sesion el ejercicio actual de la escuela			
			String ejercicioId = aca.fin.FinEjercicio.getEjercicioActual(conElias, escuelaId);	
			session.setAttribute("ejercicioId", ejercicioId);
			
			salto = "../../general/inicio/index.jsp";		
			
			break;			
		}
	}
	
	String usuarioLogeado = (String)session.getAttribute("codigoId");
	
	usuario.mapeaRegId(conElias, usuarioLogeado);
	String escuelas = usuario.getEscuela();
	pageContext.setAttribute("resultado",resultado);
%>
</head>
<body>

<div id="content">

	<h2><fmt:message key="escuelas.Escuelas" /> </h2>
<%
	if(!resultado.equals("")){
%>
	<div class="alert alert-info"><fmt:message key="aca.${resultado}" /></div> 
<%
	}
%>	
	<div class="well">
		<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>

        <table id="table" class="table table-condensed table-bordered" >
			<thead>
				<tr> 
				    <th width="5%"><fmt:message key="aca.Id" /></th>
				    <th width="30%"><fmt:message key="aca.Escuela" /></th>
				    <th width="20%"><fmt:message key="catalogo.Asociacion" /></th>
				    <th width="20%"><fmt:message key="aca.Ciudad" />, <fmt:message key="aca.Estado" />, <fmt:message key="aca.Pais" /></th>
				    <th width="30%"><fmt:message key="aca.Direccion" /></th>
				    <th width="10%"><fmt:message key="aca.Telefono" /></th>
				</tr>
			</thead>
			<%
			for (int i=0; i< lisEscuela.size(); i++){
				aca.catalogo.CatEscuela escuela = (aca.catalogo.CatEscuela) lisEscuela.get(i);			
				
				if(!escuelas.contains( escuela.getEscuelaId() ))continue;
				
				String nombreAsociacion = "";
				if (mapAsociacion.containsKey(escuela.getAsociacionId())){
					aca.catalogo.CatAsociacion  asociacion = mapAsociacion.get(escuela.getAsociacionId());
					nombreAsociacion = asociacion.getAsociacionNombre();
				}
				
				String nombrePais = "";
				if (mapPaises.containsKey(escuela.getPaisId())){
					aca.catalogo.CatPais  pais = mapPaises.get(escuela.getPaisId());
					nombrePais = pais.getPaisNombre();
				}
				
				String nombreEstado = "";
				if (mapEstados.containsKey(escuela.getPaisId()+escuela.getEstadoId())){
					aca.catalogo.CatEstado estado = mapEstados.get(escuela.getPaisId()+escuela.getEstadoId());
					nombreEstado = estado.getEstadoNombre();
				}
				
				String nombreCiudad = "";
				if (mapCiudades.containsKey(escuela.getPaisId()+escuela.getEstadoId()+escuela.getCiudadId())){
					aca.catalogo.CatCiudad ciudad = mapCiudades.get(escuela.getPaisId()+escuela.getEstadoId()+escuela.getCiudadId());
					nombreCiudad = ciudad.getCiudadNombre();
				}
			%>
				<tr>
					<td align="center"><%=escuela.getEscuelaId()%></td>
				    <td>
				      <a href="javascript:SubirEscuela('<%=escuela.getEscuelaId()%>')"><%=escuela.getEscuelaNombre()%></a>
				    </td>
				    <td><%=nombreAsociacion%></td>
				    <td>
				    	<%= nombreCiudad %>, <%= nombreEstado %>, <%= nombrePais %>
				    </td>
				    <td><%=escuela.getDireccion()%></td>
				    <td><%=escuela.getTelefono()%></td>
				</tr>
			<%
			}	
			lisEscuela			= null;
			%>
		  </table>
</div>	
	<script>
		function SubirEscuela( EscuelaId ){
	  		document.location="escuela.jsp?Accion=2&EscuelaId="+EscuelaId;
		}
	</script>
	
	<script src="../../js/search.js"></script>
	<script>
		$('#buscar').focus().search({table:$("#table")});
	</script>
</body>
<%	
	// Salto de pagina
	if (salto.length()>0){%>
	<meta http-equiv="refresh" content="0; url=<%=salto%>">
<%	} %>

<%@ include file= "../../cierra_elias.jsp" %> 