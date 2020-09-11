<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "aca.alumno.AlumPersonal"%>
<%@ page import= "aca.ciclo.Ciclo"%>
<jsp:useBean id="tipoU" scope="page" class="aca.cond.CondReporteLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="Ciclos" scope="page" class="aca.ciclo.CicloLista"/>

<%		
	String codigoAlumno 		= (String) session.getAttribute("codigoAlumno");
	String escuelaId 			= (String) session.getAttribute("escuela");
	
	String strNombreAlumno		= "";
	String strNivel				= Alumno.getNivelId();
	String strGrado				= Alumno.getGrado();
	
	// Verifica si existe el Alumno	
	boolean existeAlumno		= false;
	Alumno.setCodigoId(codigoAlumno);
	if (Alumno.existeReg(conElias)){
		Alumno.mapeaRegId(conElias, codigoAlumno);
		strNombreAlumno 	= Alumno.getNombre()+" "+Alumno.getApaterno()+" "+Alumno.getAmaterno();
		strNivel			= Alumno.getNivelId();
		strGrado			= Alumno.getGrado();
		existeAlumno 		= true;
	}
	
	ArrayList lisReporte	= new ArrayList();
	lisReporte	 			= tipoU.getListAll(conElias,"WHERE CODIGO_ID = '"+codigoAlumno+"' ORDER BY FOLIO");
	ArrayList lisCiclos 	= Ciclos.getListCiclosAlumno(conElias, codigoAlumno, "ORDER BY CICLO_ID");
	String cicloId 			="";
%>
<body>
<div id="content">
   <h2><fmt:message key="disciplina.ReportesdelAlumno" /></h2>

<%	if (existeAlumno){ %> 
   
   <div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="Filtrar" id="buscar">
	 	<select id="cicle" name="cicle" style= "width:280px">
	 	<%
	 		for(int j = 0; j < lisCiclos.size(); j++){
	 			Ciclo cicloL = (Ciclo)lisCiclos.get(j);
	 			if(lisCiclos.size()-1==j){
	 				cicloId = cicloL.getCicloId();
	 			}
	 	%>
	 		<option <%if(cicloL.getCicloId().equals(cicloId)) out.print("selected");%> value="<%=cicloL.getCicloId()%>"><%=cicloL.getCicloNombre()%></option>
	 	<%} %>
	 	</select>
	</div>
   
   <div class="well" style="overflow:hidden;">
		<%	if(existeAlumno){ 
			
			%>
        <a href="accion.jsp?Accion=1&CicloId=<%=cicloId %>" class="btn btn-primary" id="button"><i class="icon-plus icon-white" ></i> A&ntilde;adir</a>
		<% 	}else{
			out.print("¡ Busca un alumno !");
		}%>   
   </div>
 
   <td align="center"><strong>
 	  <fmt:message key="aca.Alumno" />: [ <font color='gray'><%=codigoAlumno%></font> ] [ <font color='gray'><%=strNombreAlumno%></font> ] - 
 	  <fmt:message key="aca.Nivel" />: [ <font color='gray'><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, strNivel)%></font> ] - 
 	  <fmt:message key="aca.Grado" />: [ <font color='gray'><%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(strGrado))%></font>] - 
 	  <fmt:message key="aca.Grupo" />: [ <font color='gray'><%=Alumno.getGrupo()%></font> ]
 	  </strong>
	</td>
  <div id="reportes"></div>
<%  
	
	} else{// Si no existe un alumno
%>
		<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
		</div>
<% 	}
		lisReporte			= null;
%>
	

</div>

</body>

<link rel="stylesheet" href="../../js-plugins/tablesorter/themes/blue/style.css" />
<script src="../../js-plugins/tablesorter/jquery.tablesorter.js"></script>
<script src="../../js/search.js"></script>

<script>
	(function () {
	    let defaultCicle = document.getElementById('cicle').value;
	    call(defaultCicle);
	  })();
	  
	  document.getElementById('cicle').addEventListener('change', (el) => {
	      let cicle = el.target.value;
	      call(cicle);
	      let btn = document.getElementById('button'); 
	      const href = "accion.jsp?Accion=1&CicloId="+cicle;
	      btn.href=href;
	    });
	  
	function call(cicle){
		$.ajax('ajaxOrdenCiclo.jsp', {
			data: {
				cicloId: cicle,
			}
		})
		
		.done((r) => {
			document.getElementById('reportes').innerHTML = r;
			
			$('#table').tablesorter();
			$('#buscar').search({
				table:$("#table"),
				dontUpdate: false,
			});
			
		})
        .fail((e, textStatus) => console.error('ERROR >> ', textStatus));
	}
	
	
	function borrar(codigoId,folio, cicloId){
		if(confirm("<fmt:message key="js.BorrarReporte"/>")==true){
			console.log("sdf");
			document.location.href = "accion.jsp?Accion=4&CodigoId="+codigoId+"&Folio="+folio+"&CicloId="+cicloId+"";
		}
	}
	
</script>
<%@ include file= "../../cierra_elias.jsp" %> 
