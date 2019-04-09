<%@page import="aca.vista.AlumInscrito"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="inscritosLista" scope="page" class="aca.vista.AlumInscritoLista"/>
<jsp:useBean id="nivelEscuela" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="Personal" scope="page" class="aca.alumno.AlumPersonal"/>

<%
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= request.getParameter("EscuelaId");
	String cicloId			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	
	//LISTA DE ESCUELAS
	ArrayList<aca.vista.AlumInscrito> lisInscritos 	= inscritosLista.getListaInscritos(conElias, escuelaId, " ORDER BY NIVEL, GRADO, GRUPO, NOMBRE,APATERNO,AMATERNO");
	
	// Lista de niveles
	java.util.HashMap<String,aca.catalogo.CatNivelEscuela> mapNiveles = nivelEscuela.mapNivelesEscuela(conElias, escuelaId);

	Calendar year = new GregorianCalendar();
	
%>

<div id="content">
	<h1>Alumnos Inscritos<small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %>)</small></h1>	
  	<div class="well well-small">
  		<a href="listado.jsp" class="btn btn-primary"><fmt:message key="boton.Regresar" /></a>
    </div>		
    <style>
	.procesando, .completado, .error{
		display:none;
	}
</style>

<div id="content">
	
	<h3 align="center">Respaldo</h3>
	<div class="alert alert-success completado">
		<i class="icon-ok"></i> Respaldo Completado en el Servidor
	</div>
	<div class="alert procesando">
		<img src="../../imagenes/wait.gif" style="width:14px;vertical-align:text-top;" /> Creando Respaldo en el Servidor, <strong>esta operación puede tardar unos minutos</strong>
	</div>
	<div class="alert alert-warning error">
		<i class="icon-warning-sign"></i> Ocurrió un error
	</div>
	<div class="well">
		<p>
			<label><fmt:message key="aca.FechaInicio"/></label>
			<input type="text" data-date-format="dd/mm/yyyy" class="fInicio" value="<%=aca.util.Fecha.getHoy() %>" />
		</p>
		<p>
			<label><fmt:message key='aca.FechaFinal'/></label>
			<input type="text" data-date-format="dd/mm/yyyy" class="fFin" value="<%=aca.util.Fecha.getHoy() %>" />
		</p>
		<p>
			<input type="hidden" name="escuelaid" value='<%= escuelaId %>'>
			<a href="" class="btn btn-primary btn-large crear-respaldo"><i class="icon-folder-open icon-white"></i> Crear</a>
			<a href="" class="btn btn-success btn-large descargar-respaldo"><i class="icon-arrow-down icon-white"></i> Descargar</a>
			<!--<a href="" class="btn btn-danger btn-large eliminar-respaldo"><i class="icon-remove icon-white"></i> Eliminar</a>-->
		</p>
	</div>
</div>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<script>
	(function($){
		
		
		jQuery('.fInicio').datepicker();
		jQuery('.fFin').datepicker();
		
		
		
		var completado 	= $('.completado');
		var procesando 	= $('.procesando');
		var error 		= $('.error');
		
		var fInicio 	= $('.fInicio');
		var fFin 		= $('.fFin');
		
		
		
		/* ********* CREAR RESPALDO ********* */
		$('.crear-respaldo').on('click', function(e){
			e.preventDefault();
			$this = $(this);
			console.log('Entro a hacer respaldo ');
			var date1 = new Date(  fInicio.val().split('/')[2], fInicio.val().split('/')[1], fInicio.val().split('/')[0]  );
			var date2 = new Date(  fFin.val().split('/')[2], fFin.val().split('/')[1], fFin.val().split('/')[0] );
			var timeDiff = Math.abs(date2.getTime() - date1.getTime());
			var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
			
			/*
			if( isNaN(diffDays) ){
				alert('Fechas invalidas!');
				return;
			}else if( diffDays > 50  ){
				alert('No debe haber mas de 50 dias de diferencia entre la Fecha Inicio y la Fecha Final');
				return;
			}
			*/
			
			
			completado.hide();
			$this.prop('disabled', true);
			$this.html('<i class="icon-folder-open icon-white"></i> Respaldando...');
			procesando.html('<img src="../../imagenes/wait.gif" style="width:14px;vertical-align:text-top;" /> Creando Respaldo en el Servidor, <strong>esta operación puede tardar unos minutos</strong>').show();
			error.hide();
			
			$.get('zip.jsp?fechaIni='+fInicio.val()+'&fechaFin='+fFin.val()+'&EscuelaId=<%= escuelaId %>', function(r){
				completado.html('<i class="icon-ok"></i> Respaldo Completado en el Servidor').show();
				procesando.hide();
				$this.prop('disabled', false);
				$this.html('<i class="icon-folder-open icon-white"></i> Crear');
				error.hide();
				
				let res = r+"";
				if( res.includes("error") ){
					console.log(res);
			    	error.html('<i class="icon-warning-sign"></i> Ocurrió un Error al Crear el Respaldo').show();
			    	completado.hide();
			    }
				else if( res.includes("withoutPhotos") ){
					alert("Hay usuarios sin fotografía. Se guardarán únicamente las existentes.");
				}
				else if(res.includes("withoutUsers")){
					alert("No hay ningun usuario para respaldar.");
					completado.hide();
				}
			});
		})
		
		
		
		/* ********* ELIMINAR RESPALDO ********* */
		$('.eliminar-respaldo').on('click', function(e){
			e.preventDefault();
			$this = $(this);
			
			completado.hide();
			$this.prop('disabled', true);
			$this.html('<i class="icon-folder-open icon-white"></i> Respaldando...');
			procesando.html('<img src="../../imagenes/wait.gif" style="width:14px;vertical-align:text-top;" /> Eliminando Respaldo del Servidor</strong>').show();
			error.hide();
			
			$.get('deleteZip.jsp?alumnos=true', function(r){
				completado.html('<i class="icon-ok"></i> Respaldo Eliminado').show();
				procesando.hide();
				$this.prop('disabled', false);
				$this.html('<i class="icon-folder-open icon-white"></i> Eliminar');
				error.hide();
				
				let res = r+"";
				if( res.includes("error") ){
			    	error.html('<i class="icon-warning-sign"></i> Ocurrió un Error al elimniar el Respaldo').show();
			    	completado.hide();
			    }
			})
		})
		
		
		
		/* ********* DESCARGAR RESPALDO ********* */
		$('.descargar-respaldo').on('click', function(e){
			e.preventDefault();
			$this = $(this);
			
			completado.hide();
			procesando.hide();
			error.hide();
			
			$.get('existeZip.jsp?alumnos=true', function(r){
				let res = r+"";
				if( res.includes("error") ){
			    	error.html('<i class="icon-warning-sign"></i> No Existe el Archivo de Respaldo en el Servidor, Favor de Crearlo').show();
			    }else{
			    	location.href="./respaldoAl.zip";
			    }
			})
		})
		
		
		
	})(jQuery)
	
	function descargaImagen(mat){
		$(document.body).append('<iframe style="position: absolute; display:none; visibility:hidden" src="imagen.jsp?mat='+mat+'" />')
	}
</script>
	<table class="table table-bordered" >
		<tr>     
			<td width="10%"><fmt:message key="aca.Nivel" /></td>
		    <td width="5%"><fmt:message key="aca.Grado" /></td>
			<td width="5%" class="text-left"><fmt:message key="aca.Grupo" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Codigo" /></td>
			<td width="30%" class="text-left"><fmt:message key="aca.Nombre" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.CIP" /></td>
			<td width="5%" class="text-left"><fmt:message key="aca.Sangre" /></td>
			<td width="15%" class="text-left"><fmt:message key="aca.Foto" /></td>
			<td width="15%" class="text-left"><fmt:message key="aca.Poliza" /></td>
	  	</tr>
<%
	String codigoAlumno			= "";
	String tieneFoto 			= "No";
	String muestraYear			= String.valueOf(year.get(Calendar.YEAR));
	
	ArrayList<String> listCodes = new ArrayList<String>();
	
	for(aca.vista.AlumInscrito inscrito : lisInscritos){
		// Avoid duplicate ids
		if(listCodes.contains(inscrito.getCodigoId())){
			System.out.println("Id repetido");
			continue;
		}else{
			listCodes.add(inscrito.getCodigoId());
		}
		// Verifica si existe la imagen	
		String dirFoto = application.getRealPath("/WEB-INF/fotos/"+inscrito.getCodigoId()+".jpg");
		java.io.File foto = new java.io.File(dirFoto);
		if (foto.exists()){
			tieneFoto = "Si";
			
		}else {
			tieneFoto = "No";
		}
		
		String strGrado = "-";
		int grado 		= Integer.parseInt(inscrito.getGrado());
		
		switch (grado){
			case 1: { strGrado = "PRIMERO "; break; }
			case 2: { strGrado = "SEGUNDO "; break; }
			case 3: { strGrado = "TERCERO "; break; }
			case 4: { strGrado = "CUARTO "; break; }
			case 5: { strGrado = "QUINTO "; break; }
			case 6: { strGrado = "SEXTO "; break; }
			case 7: { strGrado = "SEPTIMO "; break; }
			case 8: { strGrado = "OCTAVO "; break; }
			case 9: { strGrado = "NOVENO "; break; }
			case 10:{ strGrado = "DECIMO "; break; }
			case 11:{ strGrado = "UNDECIMO "; break; }
			case 12:{ strGrado = "DUODECIMO "; break; }
		}
%>		
		<tr>
		<td class='text-left'><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivel())%></td>
		<td class='text-left'><%= inscrito.getGrado() %></td>
		<td class='text-left'><%= inscrito.getGrupo() %></td>
		<td class='text-left'><%= inscrito.getCodigoId() %></td>
		<td class='text-left'><%= inscrito.getNombre()+" "+inscrito.getaPaterno()+" "+inscrito.getaMaterno() %></td>
		<td class='text-left'><%= inscrito.getCurp() %></td>
		<td class='text-left'><%= inscrito.getTipoSangre() %></td>
		<td class='text-left'><%= tieneFoto %>
		<%
		if (foto.exists()){
			String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
			//java.io.File f = new java.io.File(dirAlumnos+"/"+inscrito.getCodigoId())+".jpg");
		%>
		<!-- a href="../../portal/maestro/imagen.jsp?mat=<%=inscrito.getCodigoId() %>" class="btn btn-success btn-xs"><i class="icon-download-alt icon-white"></i></a -->
		<a href="javascript:void(0)" onclick="descargaImagen('<%=inscrito.getCodigoId() %>');" class="btn btn-success btn-xs"><i class="icon-download-alt icon-white"></i></a>
		<%	
		}
		%>
		</td>
		<td class='text-left'><%= aca.catalogo.CatSeguro.getPoliza(conElias, escuelaId, muestraYear ) %></td>
		</tr>
<%		
	}
%>	
	</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>