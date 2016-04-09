<head>
	<style type="text/css">
		div#divDataGrid{
			position: absolute;
		}
		
		div#divEditors{
			width: 99%;
			border: solid 1px gray;
			overflow: auto;
			position: relative;
		}
		
		iframe#dataGrid{
			height: 350px
		}
		
		input#btnExecute{
			position: absolute;
		}
	</style>
	<link href="../../academico.css" rel="STYLESHEET" type="text/css">
	<link href="../../print.css" rel="STYLESHEET" type="text/css" media="print">
	<script type="text/javascript" src="../../js/prototype.js"></script>
	<script type="text/javascript">
		var theWidth;
		var theHeight;
		function getSizeOfPage(){
			if (window.parent.innerWidth){
			  theWidth = window.innerWidth 
			  theHeight = window.innerHeight 
			} 
			else if (document.documentElement && document.documentElement.clientWidth){
			  theWidth = document.documentElement.clientWidth 
			  theHeight = document.documentElement.clientHeight 
			} 
			else if (document.body){
			  theWidth = document.body.clientWidth 
			  theHeight = document.body.clientHeight 
			}
		}
	
		function start(){
			//Obtencion de dimenciones de la pagina
			getSizeOfPage();
			
			//Acomodo del grid donde se muestra el resultado de los querys
			var divDataGrid = $("divDataGrid");
			var dataGrid = $("dataGrid");
			divDataGrid.style.top = (theHeight - divDataGrid.offsetHeight - 10) + "px";
			divDataGrid.style.left = "5px";
			dataGrid.style.width = (theWidth-30) + "px";
			
			//Acomodo del boton de ejecutar
			var btnExecute = $("btnExecute");
			btnExecute.style.left = (theWidth - btnExecute.offsetWidth - 30) + "px";
			btnExecute.style.top = (divDataGrid.offsetTop - btnExecute.offsetHeight) + "px";
			
			//Acomodo del div contenedor de los querys
			var divEditors = $("divEditors");
			divEditors.style.height = (theHeight - divDataGrid.offsetHeight - btnExecute.offsetHeight - 60)+"px";
			divEditors.style.left = "5px";
			
			newQuery();
		}
		
		Event.observe(window, 'load', start);

//------------------------- Manejo de los query's -------------------------------

		function checkQuery(obj){
			var query = obj.value;
			while(query.indexOf("%") != -1){
				query = query.replace("%", "\\");
			}
			while(query.indexOf("\n") != -1){
				query = query.replace("\n", " ");
			}
			
			var url = "dataGrid.jsp?query="+query;
			$("dataGrid").src = url;
		}
		
//------------------------- Manejo de TEXTAREA's para los query's -------------------------------

		function checkKeys(event){
			//alert(event.keyCode);
			if(event.ctrlKey){//Si esta presionado el ctrl
				if(event.keyCode == 13){//y si es enter
					checkQuery(this);
				}
				if(event.keyCode == 38){//y si es flecha hacia arriba
					$(this).previous().focus();
				}
				if(event.keyCode == 40){//y si es flecha hacia abajo
					$(this).next().focus();
				}
			}else{
				if(event.keyCode == 13){//y si es enter
					if(this.value.substring(this.value.length-1,this.value.length) != "\n"){//y si la tecla anterior no fue enter
						this.rows = this.rows+1;
					}else{//si la tecla anterior si fue enter
						this.rows = this.rows+1;
						if(!$(this).next())
							newQuery();
					}
				}
				if(event.keyCode == 8){//Si es backspace
					if(this.value == ""){//y si no tiene ningun valor---- se elimina el textarea y se enfoca el anterior
						$(this).previous().focus();
						$(this).remove();
					}
					if(this.value.substring(this.value.length-1,this.value.length) == "\n"){
						if((this.rows-1) != 0)
							this.rows = this.rows-1;
					}
				}
				if(event.keyCode >= 37 && event.keyCode <= 40){//y si es flecha hacia arriba
					var contadorEnters = 0;
					this.value.scan("\n", function(){contadorEnters++;});
					this.rows = contadorEnters+1;
				}
			}
		}
		
		function newQuery(){
			var textarea = document.createElement("textarea");
			Element.extend(textarea);
			textarea.style.width = "100%";
			textarea.rows = 1;
			Event.observe(textarea, 'keypress', checkKeys);
			$("textAreas").insert(textarea);
			textarea.focus();
		}
		
		function executeAll(){
			var querys = document.getElementsByTagName("TEXTAREA");
			var value = "";
			
			for(var i = 0; i < querys.length; i++){
				value += "\n\n"+querys[i].value;
			}
			
			var obj = new Object();
			obj.value = value;
			
			checkQuery(obj);
		}
	</script>
</head>
<body>
	<table align="center">
		<tr>
			<td class="title">SQL Editor</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<div id="divEditors">
		<table width="100%">
			<tr>
				<td id="textAreas">
					<!-- textarea id="query" name="query" cols="100" rows="20" onkeypress="checkKeys(event, this);"></textarea -->
					
				</td>
			</tr>
			<tr>
				<td class="title2">
					<div onclick="newQuery();" style="width: 100%; height: 20px;" onmouseover="this.style.backgroundColor = '#BBBBFF';" onmouseout="this.style.backgroundColor = '';" align="center">
						Nuevo Query
					</div>
				</td>
			</tr>
		</table>
	</div>
	<input id="btnExecute" type="button" value="Ejecutar todos" onclick="executeAll();" />
	<div id="divDataGrid">
		<iframe id="dataGrid" name="dataGrid"></iframe>
	</div>
</body>