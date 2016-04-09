<%@page import="sys.views.AllTabColumns"%>
<%@page import="sys.views.AllAllTables"%>
<%@page import="sys.views.AllConsColumns"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="allTabColumns" scope="page" class="sys.views.AllTabColumns"/>
<jsp:useBean id="allTabColumnsU" scope="page" class="sys.views.AllTabColumnsUtil"/>
<jsp:useBean id="allAllTables" scope="page" class="sys.views.AllAllTables"/>
<jsp:useBean id="allAllTablesU" scope="page" class="sys.views.AllAllTablesUtil"/>
<jsp:useBean id="allConsColumns" scope="page" class="sys.views.AllConsColumns"/>
<jsp:useBean id="allConstraints" scope="page" class="sys.views.AllConstraints"/>
<%
	ArrayList<AllAllTables> lisTables = allAllTablesU.getListAll(conElias, "ORDER BY TABLE_NAME");
	ArrayList<AllTabColumns> lisColumns = null;
%>
<head>
	<style type="text/css">
		div.table{
			position: absolute;
			background-color: #fffcad;
			width: auto;
			cursor: default;
		}
		
		div#toolBar{
			position: fixed;
			z-index: 1000;
			top: 0px;
			left: 0px;
			border: solid 1px gray;
			background-color: white;
		}
		
		div#status{
			position: fixed;
			z-index: 1100;
			top: 0px;
			left: 0px;
		}
		
		table.fields{
			border: solid 1px gray;
			background-color: white;
		}
	</style>
	<script type="text/javascript" src="../../js/prototype.js"></script>
	<script type="text/javascript">
		//--------------------------------- Variables Globales -----------------------------
		var theHeight;			//tamaño de la pantalla (alto)
		var theWidth;			//tamaño de la pantalla (ancho)
		//--------------------------------- Funciones para cuando se carga la pagina -----------------------------
		function inicio(){
			getSizeOfPage();
			ordenaEntidades();
		}
		
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
		//Ordena las tablas Simetricamente
		function ordenaEntidades(){
			var divs = document.getElementsByTagName("div");
			var tmpX = 0;
			var tmpY = 50;
			var tmpHeight = 0;
			
			for(var i = 0; i < divs.length; i++){
				if(divs[i].id.indexOf("table-") == 0){
					divs[i].style.left = tmpX + "px";
					divs[i].style.top = tmpY + "px";
					divs[i].style.zIndex = "0";
					divs[i].fijada = "N";	//Este parametro es para ver si se fijó la tabla a una posicion
					tmpX = tmpX + divs[i].offsetWidth + 5;
					if(tmpHeight < divs[i].offsetHeight)
						tmpHeight = divs[i].offsetHeight;
					if((tmpX + divs[i+1].offsetWidth + 5) > theWidth){
						tmpX = 0;
						tmpY = tmpY + tmpHeight + 5;
						tmpHeight = 0;
					}
					var tableName = divs[i].id.substring(divs[i].id.indexOf("-")+1,divs[i].id.length);
					var url = "erAccion.jsp?Accion=5&tableName="+tableName;
					new Ajax.Request(url, {
						method: "get",
						onLoading: function(req){
							showLoading();
						},
						onSuccess: function(req){
							//$("status").innerHTML += req.responseText;
							eval(req.responseText);
							hideLoading();
						},
						onFailure: function(req){
							alert("Ocurrió un error al accesar a la página. Inténtelo de nuevo");
						}
					});
				}
			}
		}
		//Acomoda las tablas de acuerdo a sus relaciones con otras tablas
		function acomodaEntidadesPorRelacion(){
			alert("va a acomodar ");
			var divs = document.getElementsByTagName("div");
			acomodaEntidadPorRelacion(divs, 0);
			alert("terminó");
		}
		
		function acomodaEntidadPorRelacion(divs, i){
			if(i < divs.length){
				if(divs[i].id.indexOf("table-") == 0){
					var tableName = divs[i].id.substring(divs[i].id.indexOf("-")+1,divs[i].id.length);
					if(divs[i].parents)
						var table = $("table-"+tableName);
						if(table.fijada != "N"){
							table.style.left = theWidth + "px";
							table.style.top = "0px";
						}
						var numParents = divs[i].parents;
						for(var j = 0; j < numParents; j++){
							//$("tableName-"+tableName).innerHTML += "<br>" + divs[i].eval("parent"+j);
							
						}
					acomodaEntidadPorRelacion(divs, i+1);
				}else{
					acomodaEntidadPorRelacion(divs, i+1);
				}
			}
		}
		
		//--------------------------------- Mensajes -----------------------------
		
		function showLoading(){
			var status = $("status");
			status.innerHTML = "Cargando...";
			status.style.backgroundColor = "red";
			status.style.visibility = "visible";
		}
		
		function hideLoading(){
			var status = $("status");
			status.style.visibility = "hidden";
		}
		
		//--------------------------------- Mover Entidades -----------------------------
		
		var obj = new Object();
		obj.element = null;
		obj.elementX = 0;
		obj.elementY = 0;
		ojb.zIndex = "0";
		
		function dragStart(e, event){
			obj.element = e;
			obj.elementX = Event.pointerX(event) - Position.cumulativeOffset($(e))[0];
			obj.elementY = Event.pointerY(event) - Position.cumulativeOffset($(e))[1];
			obj.zIndex = e.style.zIndex;
			e.style.zIndex = "100";
			Event.observe(document, 'mousemove', dragGo);
		}
		
		function dragStop(){
			obj.element.style.zIndex = obj.zIndex;
			obj.element = null;
			Event.stopObserving(document, 'mousemove', dragGo);
		}
		
		function dragGo(event){
			//$("coordenadas").innerHTML = "<br><br>X = "+Event.pointerX(event)+"<br>Y = "+Event.pointerY(event);
			obj.element.style.left = (Event.pointerX(event) - obj.elementX)+"px";
			obj.element.style.top = (Event.pointerY(event) - obj.elementY)+"px";
		}
	</script>
</head>
<body onload="inicio();">
	<!-- div id="coordenadas" align="right" style="color: white; background-color: black;"><br><br><br><br></div -->
	<div id="status"></div>
	<div id="toolBar">
		<table width="100%">
			<tr>
				<td>
					<input type="button" value="Acomodar por Relacion" onclick="acomodaEntidadesPorRelacion();" />
				</td>
			</tr>
		</table>
	</div>
<%
	//Otras tablas user_ind_columns
	String tableName = "";
	String size = "";
	for(int i = 0; i < lisTables.size(); i++){
		allAllTables = (AllAllTables) lisTables.get(i);
		lisColumns = allTabColumnsU.getListTable(conElias, allAllTables.getTableName(), "ORDER BY COLUMN_NAME");
%>
	<div id="table-<%=allAllTables.getTableName() %>" class="table" onmousedown="dragStart(this, event);" onmouseup="dragStop();">
		<table>
			<tr>
				<th id="tableName-<%=allAllTables.getTableName() %>"><%=allAllTables.getTableName()%></th>
			</tr>
			<tr>
				<td>
					<table id="columns-<%=allAllTables.getTableName() %>" class="fields">
<%
		for(int j = 0; j < lisColumns.size(); j++){
			allTabColumns = (AllTabColumns) lisColumns.get(j);
%>
						<tr>
<%
			if(allConsColumns.existeReg(conElias, allAllTables.getTableName(), allTabColumns.getColumnName())){
				String tipo = "";
				if(allConstraints.isPK(conElias, allAllTables.getTableName(), allTabColumns.getColumnName())){
					tipo += "<a style='cursor:pointer;' title='"+allConstraints.getConstraintName()+"'>PK</a>";
				}
				if(allConstraints.isFK(conElias, allAllTables.getTableName(), allTabColumns.getColumnName())){
					allConsColumns.mapeaRegId(conElias, allConstraints.getRConstraintName());
					tipo += tipo.equals("")?"":" | ";
					tipo += "<a style='cursor:pointer;' title='"+allConstraints.getConstraintName()+" conecta con la tabla "+allConsColumns.getTableName()+"'>FK</a>";
				}
				if(!allConstraints.getIndexName().equals("")){
					tipo += tipo.equals("")?"":" | ";
					tipo += "<a style='cursor:pointer;' title='"+allConstraints.getIndexName()+"'>I</a>";
				}
				//Es mejor sustituir lo de arriba por condiciones que pregunten si son llave primaria o foranea...
%>
							<td style="border-right: dotted 1px gray;"><%=tipo %></td>
<%
			}else{
%>
							<td>&nbsp;</td>
<%
			}
%>
							<td style="border-right: dotted 1px gray; border-left: dotted 1px gray;"><%=allTabColumns.getColumnName()%></td>
<%
			size = "";
			if(allTabColumns.getDataType().equals("VARCHAR2") || allTabColumns.getDataType().equals("CHAR")){
				size = "(";
				size += allTabColumns.getDataLength();
				size += ")";
			}
			if(allTabColumns.getDataType().equals("NUMBER")){
				size = "(";
				size += allTabColumns.getDataPrecision();
				size += allTabColumns.getDataScale().equals("0")?"":("."+allTabColumns.getDataScale());
				size += ")";
			}
%>
							<td><%=allTabColumns.getDataType()%><%=size %></td>
						</tr>
<%
		}
%>
					</table>
				</td>
			</tr>
		</table>
	</div>
<%
	}
%>
</body>

<%@ include file= "../../cierra_elias.jsp" %>