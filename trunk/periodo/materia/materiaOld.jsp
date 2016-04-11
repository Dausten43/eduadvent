<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatGrupo"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.ciclo.CicloBloque"%>
<%@page import="aca.util.Fecha"%>
<%@page import="aca.ciclo.CicloGrupo"%>
<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPermiso"%>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="PermisoLista" scope="page" class="aca.ciclo.CicloPermisoLista"/>
<jsp:useBean id="PlanLista" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="grupoLista" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="grupo" scope="page" class="aca.catalogo.CatGrupo"/>
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="planCursoL" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="empPersonalL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="cicloBloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	String strAccion 		= request.getParameter("Accion");
	String nivelId 		= aca.plan.Plan.getNivel(conElias,planId);
	String titulo 		= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivelId).toUpperCase();
	
	ArrayList<Ciclo> lisCiclo	= null;
	ArrayList<CicloPermiso> lisConPermiso	= null;
	
	if (strAccion==null) 	strAccion = "0"; 
	int numAccion 			= Integer.parseInt(strAccion);
	int j=0,i=0;
	
	switch (numAccion){
		case 1: { 
			cicloId = request.getParameter("Ciclo");
			session.setAttribute("cicloId",cicloId);
			break;
		}
	}
%>
<head>
	<style type="text/css">
		div#buscar
		{
			z-index:+999;
			position:absolute;
			visibility:hidden;
			background:#E6F7FF;
			border-color:blue;
			border-style:groove;
			width:200px;
			height:300px
		}
	</style>
</head>
<body>
<script>
	var ie  = document.all;

	function Browser() {
		
	  var ua, s, i;
		
	  this.isIE    = false;
	  this.isNS    = false;
	  this.version = null;
	
	  ua = navigator.userAgent;
	
	  s = "MSIE";
	  if ((i = ua.indexOf(s)) >= 0) {
	    this.isIE = true;
	    this.version = parseFloat(ua.substr(i + s.length));
	    return;
	  }
	
	  s = "Netscape6/";
	  if ((i = ua.indexOf(s)) >= 0) {
	    this.isNS = true;
	    this.version = parseFloat(ua.substr(i + s.length));
	    return;
	  }
	
	  // Treat any other "Gecko" browser as NS 6.1.
	
	  s = "Gecko";
	  if ((i = ua.indexOf(s)) >= 0) {
	    this.isNS = true;
	    this.version = 6.1;
	    return;
	  }
	}
		
	var browser = new Browser();

	function cambiaCiclo( ){
		document.frmMateria.Accion.value = "1";
		document.frmMateria.submit();	
	}
	
	function initRequest() {
		if (window.XMLHttpRequest) {
			return new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			isIE = true;
			return new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	
	function muestraEstado(tipo,frase, event){
		var mensaje = document.getElementById("Mensaje");
		mensaje.innerHTML = frase;
		var theWidth;
		if (window.innerWidth)
		{
			theWidth = window.innerWidth;
		}
		else if (document.documentElement && document.documentElement.clientWidth)
		{
			theWidth = document.documentElement.clientWidth;
		}
		else if (document.body)
		{
			theWidth = document.body.clientWidth;
		}
		if(tipo == "flotante"){
			//mensaje.style.left = event.clientX + window.scrollX + "px";
			mensaje.style.left = ((theWidth/2)-(mensaje.offsetWidth/2))+"px";
			mensaje.style.top = "0px";
			mensaje.style.position = "fixed";
		}
		if(tipo == "estatico"){
			mensaje.style.left = ((theWidth/2)-(mensaje.offsetWidth/2))+"px";
			mensaje.style.top = "10px";
		}
		
		mensaje.style.visibility = "visible";
		mensaje.style.font = "bold 10pt Arial, Arial Narrow";
	}
	
	function ocultaEstado(){
		document.getElementById("Mensaje").style.visibility = "hidden";
		document.getElementById("Mensaje").style.background = "red";
		document.getElementById("Mensaje").style.color = "white";
	}
	
	function materiasAsignadas(folio, numDespliegue, nivel, event){
		muestraEstado("flotante","Cargando...",event);
		var url = "materiaAccion.jsp?Accion=2&folio="+folio+"&despliegue="+numDespliegue+"&nivel="+nivel;
		var req = initRequest();
		
		req.onreadystatechange = function() {
			if(req.readyState == 4){
				
				if(req.status==404) {
					alert("esta pagina no existe");
					ocultaEstado();
				}
				if(req.status == 200){
					document.getElementById("desplegar"+numDespliegue+"-"+nivel).innerHTML = req.responseText;
					ocultaEstado();
					
				}else if (req.status == 204){
					alert("Ocurrió un error al solicitar la informacion");
					ocultaEstado();
				}
			}
		};
		req.open("get", url, true);
		req.send(null);
	}
	
	function grabarMaterias(posicion, folio, numDespliegue, nivel, event){
		muestraEstado("flotante","Grabando...",event);
		var url = "materiaAccion.jsp?Accion=3&folio="+folio+"&posicion="+posicion+"&despliegue="+numDespliegue;
		var req = initRequest();
		
		for(i = 0; i < posicion; i++){
			var mat = document.getElementById("materia"+i+"-"+folio);

			if(mat != null){
				if(mat.checked)
					url += "&materia"+i+"-"+folio+"="+mat.value;
				else
					url += "&noMateria"+i+"-"+folio+"="+mat.value;
			}
		}
		
		req.onreadystatechange = function() {
			if(req.readyState == 4){
				
				if(req.status==404) {
					alert("esta pagina no existe");
					ocultaEstado();
				}
				if(req.status == 200){
					//alert("***");
					//alert("llegaron los datos"+req.responseText);
					document.getElementById("desplegar"+numDespliegue+"-"+nivel).innerHTML = req.responseText;
					ocultaEstado();
					
				}else if (req.status == 204){
					alert("Ocurrió un error al solicitar la informacion");
					ocultaEstado();
				}
			}
		};
		req.open("get", url, true);
		req.send(null);
	}
	
	var dom = document.getElementById;
	var ie  = document.all;
	var obj,crossobj,despliegue,posArreglo, cicloGrupo, curso, evento, tipoDeBusqueda;
<%
	ArrayList lisEmpleados 	= empPersonalL.getListAll(conElias, escuelaId, " AND CODIGO_ID LIKE '%E%'ORDER BY APATERNO, AMATERNO, NOMBRE");
%>
	var nombres = new Array(<%=lisEmpleados.size() %>);
	var matriculas = new Array(<%=lisEmpleados.size() %>);
	var folioGrupo = 0;
<%
	for(int e = 0; e < lisEmpleados.size(); e++){
		empPersonal = (aca.empleado.EmpPersonal) lisEmpleados.get(e);
			out.print("nombres["+e+"] = '" + empPersonal.getNombre() + " " + empPersonal.getApaterno() + " " + empPersonal.getAmaterno() +"';");
			out.print("matriculas["+e+"] = '"+empPersonal.getCodigoId()+"';");
	}
%>

	function muestraBuscar(objeto, event, cicloGrupoId, cursoId, tipo, folio){
		var leftpos = 0;
		var toppos  = 0;
		despliegue = objeto;
		cicloGrupo = cicloGrupoId;
		curso = cursoId;
		obj = document.getElementById("buscar");
		crossobj = obj.style;
		folioGrupo = folio;
		
		crossobj.visibility = (dom||ie) ? "visible" : "show";
		
		if(browser.isIE){
			crossobj.left = window.event.clientX + document.documentElement.scrollLeft
	      					+ document.body.scrollLeft;
			crossobj.top = window.event.clientY + document.documentElement.scrollTop
	      					+ document.body.scrollTop;
		}else if(browser.isNS){
			crossobj.left = event.clientX + window.scrollX + "px";
			crossobj.top = event.clientY + window.scrollY + "px";
		}
		tipoDeBusqueda = tipo;
		buscar();
		
		document.getElementById("nombre").focus();
		visible = true;
	}
	
	function cancelar(){
		crossobj.visibility = "hidden";
	}
	
	function seleccion(pos, event, tipo){
		posArreglo = pos;
		grabarMaestro(event, tipo);
	}
	
	function buscar(){
		var frase,tabla, i, numFilas;
		frase = document.getElementById("nombre");
		tabla = "<table width=\"100%\">"
		numFilas = 0;
		
		if(tipoDeBusqueda == "grupo"){
			for(i = 0; i < nombres.length; i++){
				if(frase.value == ""){
					tabla += "<tr><td onclick=\"seleccion('"+i+"', event, 'grupo');cancelar();\" style=\"cursor:pointer\" onmouseover=\"this.style.backgroundColor='#CCE8FF'\" onmouseout=\"this.style.backgroundColor=''\">"+nombres[i]+"</td></tr>";
					numFilas++;
				}else{
					if(nombres[i].toUpperCase().search(frase.value.toUpperCase()) != -1){
						tabla += "<tr><td onclick=\"seleccion('"+i+"', event, 'grupo');cancelar();\" style=\"cursor:pointer\" onmouseover=\"this.style.backgroundColor='#CCE8FF'\" onmouseout=\"this.style.backgroundColor=''\">"+nombres[i]+"</td></tr>";
						numFilas++;
					}
				}
				crossobj.height = ((numFilas * 20)+60)+"px";
			}
			//Agregar un click al guardar
		}else if(tipoDeBusqueda == "curso"){
			for(i = 0; i < nombres.length; i++){
				if(frase.value == ""){
					tabla += "<tr><td onclick=\"seleccion('"+i+"', event, 'curso');cancelar();\" style=\"cursor:pointer\" onmouseover=\"this.style.backgroundColor='#CCE8FF'\" onmouseout=\"this.style.backgroundColor=''\">"+nombres[i]+"</td></tr>";
					numFilas++;
				}else{
					if(nombres[i].toUpperCase().search(frase.value.toUpperCase()) != -1){
						tabla += "<tr><td onclick=\"seleccion('"+i+"', event, 'curso');cancelar();\" style=\"cursor:pointer\" onmouseover=\"this.style.backgroundColor='#CCE8FF'\" onmouseout=\"this.style.backgroundColor=''\">"+nombres[i]+"</td></tr>";
						numFilas++;
					}
				}
				crossobj.height = ((numFilas * 20)+60)+"px";
			}
		}

		tabla += "</table>";
		document.getElementById("lista").innerHTML = tabla;
	}
	
	function grabarMaestro(event, tipo){
		muestraEstado("flotante","Grabando...",event);
		var url = "";
		if(tipo == 'grupo'){
			url = "materiaAccion.jsp?Accion=5&cicloGrupoId="+cicloGrupo+"&cursoId="+curso+"&empleadoId="+matriculas[posArreglo]+"&folio="+folioGrupo;
		}else if(tipo == 'curso'){
			url = "materiaAccion.jsp?Accion=4&cicloGrupoId="+cicloGrupo+"&cursoId="+curso+"&empleadoId="+matriculas[posArreglo];
		}
		
		var req = initRequest();
		req.onreadystatechange = function() {
			if(req.readyState == 4){
				
				if(req.status==404) {
					alert("esta pagina no existe");
					ocultaEstado();
				}
				if(req.status == 200){
					muestraNombreMaestro(req.responseText, event);
					
					
				}else if (req.status == 204){
					alert("Ocurrió un error al solicitar la informacion");
					ocultaEstado();
				}
			}
		};
		req.open("get", url, true);
		req.send(null);
	}
	
	function muestraNombreMaestro(respuesta, event){
		respuesta = respuesta.replace(/^\s*|\s*$/g,"");
		if(respuesta == 'si'){
			despliegue.innerHTML = nombres[posArreglo];
			document.getElementById("Mensaje").style.background = "#CCE8FF";
			document.getElementById("Mensaje").style.color = "black";
			
			muestraEstado("flotante","El maestro fu&eacute; grabado correctamente",event);
			
			setTimeout("ocultaEstado()",5000);
		}else if(respuesta == 'no1'){
			alert("Ocurrió un error y no se finalizo el cambio de maestro. Intentelo de nuevo");
		}else if(respuesta == 'no2'){
			alert("Esta materia no esta dada de alta para el grupo, por lo tanto no se le puede asignar un maestro");
		}
	}
	
</script>

<table width="70%" border="0" align="center">
  <form name="frmMateria" action="materia.jsp" method="post">
  <input type="hidden" name="Accion" />
  <tr> 
    <td colspan="19" align="center">
	  <strong>Ciclo Académico: </strong>
	  <select name="Ciclo" id="Ciclo" onchange='javascript:cambiaCiclo()'>
<%
	lisCiclo 	= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");
	boolean cambio = false;
	for( j=0;j<lisCiclo.size();j++){
		aca.ciclo.Ciclo ciclo = (aca.ciclo.Ciclo) lisCiclo.get(j);
		if (ciclo.getCicloId().equals(cicloId)){
			cambio = true;
			out.print(" <option value='"+ciclo.getCicloId()+"' Selected>"+ ciclo.getCicloNombre()+"</option>");
		}else{
			out.print(" <option value='"+ciclo.getCicloId()+"'>"+ ciclo.getCicloNombre()+"</option>");
		}
	}
	if(!cambio){
		cicloId = ((aca.ciclo.Ciclo) lisCiclo.get(0)).getCicloId();
		session.setAttribute("cicloId", cicloId);
	}
	
	lisConPermiso			= PermisoLista.getListConPermiso(conElias, cicloId, planId, "ORDER BY NIVEL_ID");
	
%>
	  </select>
	</td>
  </tr>
  </form>
<%
	plan.mapeaRegId(conElias, planId);
	for (i=0; i< lisConPermiso.size(); i++){
		aca.ciclo.CicloPermiso permiso = (aca.ciclo.CicloPermiso) lisConPermiso.get(i);		
		
%>
  <tr><td colspan="9" align="center">&nbsp;</td></tr>
  <tr>
  	<td colspan="9" align="center"><font size="2"><strong><%=plan.getPlanNombre() %></strong></font></td>
  </tr>
  <tr>
    <td colspan="9" align="center">
	  <strong><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, permiso.getNivelId())%></strong>
    </td>
  </tr>
<%
	
		ArrayList lisGrupo = grupoLista.getListNivel(conElias,permiso.getNivelId(),"ORDER BY GRADO, GRUPO");
		for(int k = 0; k < lisGrupo.size(); k++){
			grupo = (CatGrupo) lisGrupo.get(k);		
			if(cicloGrupo.existeReg(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId)){
				cicloGrupo.mapeaRegId(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId);			
			}else{
				cicloGrupo = new CicloGrupo();
			}	
%>
  <tr style="cursor:pointer">
  	<td bgcolor="#C1C1C1" onmouseover="this.style.backgroundColor='#CCE8FF'" onmouseout="this.style.backgroundColor='#C1C1C1'">
  		<table width="100%">
  			<tr>
  				<td width="40%" onclick="materiasAsignadas(<%=grupo.getFolio() %>,<%=k %>, <%=i %>,event);"><b><%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))+" "+titulo+" "+grupo.getGrupo() %></b></td>
  				<td onclick="muestraBuscar(this, event, '<%=cicloGrupo.getCicloGrupoId() %>', '<%=cicloGrupoCurso.getCursoId() %>', 'grupo', <%=grupo.getFolio() %>);" onmouseover="this.style.backgroundColor='#9BD2FF'" onmouseout="this.style.backgroundColor=''"><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupo.getEmpleadoId(), "NOMBRE") %></td>
  			</tr>
  		</table>
  	</td>
  </tr>
  <tr>
	<td>
		<div id="desplegar<%=k %>-<%=i %>">
			<table width="100%">
<%
			if(cicloGrupo.existeReg(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId)){
				cicloGrupo.mapeaRegId(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId);
				
				ArrayList lisCicloGrupoCurso = cicloGrupoCursoLista.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_ID");
				
				for(int l = 0; l < lisCicloGrupoCurso.size(); l++){
					cicloGrupoCurso = (aca.ciclo.CicloGrupoCurso) lisCicloGrupoCurso.get(l);
%>
					  <tr>
					  	<td><%=l+1 %></td>
					  	<td><%=aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId()) %></td>
					  	<td onclick="muestraBuscar(this, event, '<%=cicloGrupo.getCicloGrupoId() %>', '<%=cicloGrupoCurso.getCursoId() %>', 'curso', 0);" style="cursor:pointer" onmouseover="this.style.backgroundColor='#CCE8FF'" onmouseout="this.style.backgroundColor=''"><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(), "NOMBRE") %></td>
					  </tr>
<%
				}
				
			}
%>
			</table>
		</div>
	</td>
  </tr>
<%		}  %>
  <tr>
  	<td></td>
  </tr>
  
<%	}  %>
  <tr> 
    <td colspan="9" align="center"><strong>Fin del listado<%=cicloId%></strong></td>
  </tr>
</table>
<div id="buscar" style="z-index:+998;position:absolute">
	<table width="100%">
		<tr>
			<td><input id="nombre" type="text" onkeyup="buscar();" /><input type="button" value="Cancelar" onclick="cancelar();" /></td>
		</tr>
		<tr>
			<td>
				<div id="lista">

				</div>
			</td>
		</tr>
	</table>
</div>
<div id="Mensaje" style="z-index:+999;position:fixed;background:red;top:10px;left:0px;visibility:hidden;color:white">
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>