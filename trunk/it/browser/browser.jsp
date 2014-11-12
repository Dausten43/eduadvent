<%@ include file= "../conn.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../body.jsp" %>

<head>
<script type="text/javascript">
	var numCargando = 0;
	function muestraCargando(){
		numCargando++;
		if(!$("cargando")){
			$(document.body).insert({
				bottom: '<img id="cargando" src="../../imagenes/cargando2.gif" width="80px" />'
			});
			var cargando = $("cargando");
			cargando.style.position = "fixed";
			cargando.style.zIndex = "1000";
			cargando.style.top = "0px";
			cargando.style.left = (document.viewport.getWidth() - cargando.offsetWidth - 100)+"px";
			muestraFondo();
		}
	}
	
	function ocultaCargando(){
		numCargando--;
		if(numCargando == 0){
			$("cargando").remove();
			ocultaFondo();
		}
	}
	
	/*
	Funcion que muestra un fondo blanco con transparencia 
	sobrepuesto a la pagina para poder mostrar una 
	ventana emergente
	*/
	function muestraFondo(){
		var fondo = $("fondo");
		if(!fondo){
			$(document.body).insert({
				bottom: '<div id="fondo" style="position: fixed; z-index: 100; top: 0px; left:0px; width: 100%; height: 100%;-moz-opacity:0.6; filter: alpha(opacity=60); background-color: #FFFFFF;">'+
						'</div>'
			});
			fondo = $("fondo");
		}else{
			fondo.style.visibility = "visible";
		}
	}
	
	/*
	Funcion que oculta el fondo mostrado por la
	funcion de arriba
	*/
	function ocultaFondo(){
		$("fondo").style.visibility = "hidden";
	}
	
	function init(path){
		var tree = $("tree");
		tree.style.width = ($(tree.offsetParent).getWidth() - 8)+"px";
		tree.style.height = ($(tree.offsetParent).getHeight() - 8)+"px";
		
		var list = $("list");
		list.style.width = ($(list.offsetParent).getWidth() - 8)+"px";
		list.style.height = ($(list.offsetParent).getHeight() - 60)+"px";
		
		start(path);
	}
	
	function start(path){
		$("uri").value = path;
		var url = "browserAccion.jsp?Accion=5&path="+path;
		
		new Ajax.Request(url,{
			method: "get",
			onSuccess: function(req){
				$("tree").innerHTML = req.responseText;
			},
			onFailure: function(req){
				alert("No se pudo conectar a la pagina para cargar el raiz.\nIntentelo de nuevo");
			},
			onCreate: function(req){
				muestraCargando();
			},
			onComplete: function(req){
				ocultaCargando();
			}
		});
		
		url = "browserAccion.jsp?Accion=6&path="+path;
		
		new Ajax.Request(url,{
			method: "get",
			onSuccess: function(req){
				$("list").innerHTML = req.responseText;
			},
			onFailure: function(req){
				alert("No se pudo conectar a la pagina para cargar el raiz.\nIntentelo de nuevo");
			},
			onCreate: function(req){
				muestraCargando();
			},
			onComplete: function(req){
				ocultaCargando();
			}
		});
	}
	
	function browse(path, id){
		var list = $(id);
		
		if(list.innerHTML == ""){
			$("uri").value = path;
			var url = "browserAccion.jsp?Accion=5&path="+path;
			
			new Ajax.Request(url,{
				method: "get",
				onSuccess: function(req){
					list.innerHTML = req.responseText;
				},
				onFailure: function(req){
					alert("No se pudo conectar a la pagina para cargar el browser.\nIntentelo de nuevo");
				},
				onCreate: function(req){
					muestraCargando();
				},
				onComplete: function(req){
					ocultaCargando();
				}
			});
			
			url = "browserAccion.jsp?Accion=6&path="+path;
			
			new Ajax.Request(url,{
				method: "get",
				onSuccess: function(req){
					$("list").innerHTML = req.responseText;
				},
				onFailure: function(req){
					alert("No se pudo conectar a la pagina para cargar el browser.\nIntentelo de nuevo");
				},
				onCreate: function(req){
					muestraCargando();
				},
				onComplete: function(req){
					ocultaCargando();
				}
			});
		}else{
			list.innerHTML = "";
		}
	}
	
	function download(path){
		var url = "browserAccion.jsp?Accion=7&path="+path;
		
		new Ajax.Request(url,{
			method: "get",
			onSuccess: function(req){
				alert(req.responseText);
				eval(req.responseText);
			},
			onFailure: function(req){
				alert("No se pudo conectar a la pagina para cargar el browser.\nIntentelo de nuevo");
			},
			onCreate: function(req){
				muestraCargando();
			},
			onComplete: function(req){
				ocultaCargando();
			}
		});
	}
	
	function uploadFile(){
		if($("file").value != ""){
			//alert($("uri").value);
			$("path").value = $("uri").value;
			//alert(document.upload.path.value);
			muestraCargando();
			return true;
		}
		
		return false;
	}
	
	function makeDir(){
		if($("dir").value != ""){
			muestraCargando();
			$("statusBar").src = "browserAccion.jsp?Accion=9&path="+$("uri").value+"&dir="+$("dir").value;
			$("dir").value = "";
		}else
			alert("Ingrese el nombre de la nueva carpeta para poderla crear");
	}
</script>
</head>
<body>
<table width="99%" height="93%" align="center">
	<tr>
		<td colspan="2" height="30px">
			<table width="100%">
				<tr>
					<td class="title">Exodus Browser</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="30px">
			&nbsp;
		</td>
		<td height="30px">
			URI: <input id="uri" name="uri" size="70" disabled />
		</td>
	</tr>
	<tr>
		<td style="border: solid 1px gray;" width="35%" valign="top">
			<table width="100%">
				<tr>
					<td class="button" onclick="start('C:/');">C</td>
					<td class="button" onclick="start('D:/');">D</td>
				</tr>
			</table>
			<div id="tree" style="overflow: auto; border-top: solid 1px gray;">
				&nbsp;
			</div>
		</td>
		<td style="border: solid 1px gray;" width="65%" valign="top">
			<table width="100%">
				<tr>
					<td colspan="2">
						<table width="100%">
							<tr>
								<td style="border-right: solid 1px gray;">
									<form id="upload" name="upload" action="browserAccion.jsp?Accion=8" enctype="multipart/form-data" method="post" target="statusBar">
									Upload file: <input type="file" id="file" name="file" /> <input type="hidden" id="path" name="path" value="" /> <input type="submit" class="button" value="Upload" onclick="return uploadFile();" />
									</form>
								</td>
								<td>
									Crear Carpeta: <input type="text" class="text" id="dir" name="dir" /> <input type="button" class="button" value="Crear" onclick="makeDir();"  />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>
						Name
					</th>
					<th width="79px">Size</th>
				</tr>
			</table>
			<div id="list" style="overflow: auto; border: solid 1px red;">
				&nbsp;
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" height="30px">
			Status Bar: <iframe id="statusBar" name="statusBar" style="width: 500px; height: 30px; border: solid 1px black;" frameborder="no"></iframe>
		</td>
	</tr>
</table>
<script type="text/javascript">
	init('C:/');
</script>
</body>
<%@ include file= "../cierra_conn.jsp" %>