<%@ include file="../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<style>
	.procesando, .completado, .error{
		display:none;
	}
</style>

<div id="content">
	
	<h1>Respaldo</h1>
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
			<a href="" class="btn btn-primary btn-large crear-respaldo"><i class="icon-folder-open icon-white"></i> Crear</a>
			<a href="" class="btn btn-success btn-large descargar-respaldo"><i class="icon-arrow-down icon-white"></i> Descargar</a>
			<a href="" class="btn btn-danger btn-large eliminar-respaldo"><i class="icon-remove icon-white"></i> Eliminar</a>
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
			
			$.get('zip.jsp?fechaIni='+fInicio.val()+'&fechaFin='+fFin.val(), function(r){
				completado.html('<i class="icon-ok"></i> Respaldo Completado en el Servidor').show();
				procesando.hide();
				$this.prop('disabled', false);
				$this.html('<i class="icon-folder-open icon-white"></i> Crear');
				error.hide();
				
				if( $(r).filter('.error')[0] != undefined ){
			    	error.html('<i class="icon-warning-sign"></i> Ocurrió un Error al Crear el Respaldo').show();
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
			
			$.get('deleteZip.jsp', function(r){
				completado.html('<i class="icon-ok"></i> Respaldo Eliminado').show();
				procesando.hide();
				$this.prop('disabled', false);
				$this.html('<i class="icon-folder-open icon-white"></i> Eliminar');
				error.hide();
				
				if( $(r).filter('.error')[0] != undefined ){
			    	error.html('<i class="icon-warning-sign"></i> Ocurrió un Error al Eliminar el Respaldo').show();
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
			
			$.get('existeZip.jsp', function(r){
				if( $(r).filter('.error')[0] != undefined ){
			    	error.html('<i class="icon-warning-sign"></i> No Existe el Archivo de Respaldo en el Servidor, Favor de Crearlo').show();
			    }else{
			    	location.href="respaldo.zip";
			    }
			})
		})
		
		
		
	})(jQuery)
</script>

<%@ include file="../../cierra_elias.jsp"%>