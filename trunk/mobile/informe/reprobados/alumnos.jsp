<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.HashMap"%>
<%@page import="aca.ciclo.Ciclo"%>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloGrupoL" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="CicloGrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>


<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String bloqueId			= request.getParameter("Bloque");

	if(cicloId == "XXXXXXX"){
		cicloId = Ciclo.getCargaActual(conElias, escuelaId);
	}
	
	//LISTA PARA EL COMBO DE CICLOS
	ArrayList<aca.ciclo.Ciclo> lisCiclo	= CicloLista.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID");
	//LISTA PARA EL COMBO DE BLOQUES
	ArrayList<aca.ciclo.CicloBloque> lisCicloBloque = CicloBloqueL.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	if(bloqueId == null||bloqueId.equals("")){
		if(lisCicloBloque.size() > 0)
			bloqueId = ((aca.ciclo.CicloBloque) lisCicloBloque.get(0)).getBloqueId();
	}
	
	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	if(accion.equals("1")){
		cicloId = request.getParameter("Ciclo");
		session.setAttribute("cicloId",cicloId);
	}
	
	//LISTA PARA DESPLEGAR LOS NIVELE, GRADOS Y GRUPOS
	ArrayList<aca.ciclo.CicloGrupo> lisCicloGrupo	= CicloGrupoL.getListGrupos(conElias, cicloId, " ORDER BY NIVEL_ID, GRADO, GRUPO");
	
	//NUMERO DE REPROBADOS
	HashMap<String, aca.ciclo.CicloGrupo> reprobados = CicloGrupoL.getReprobonesPorNivel(conElias, cicloId, bloqueId, "");
	ArrayList<aca.ciclo.CicloGrupoCurso> reprobadosMaterias = CicloGrupoCursoL.getReprobonesPorMaterias(conElias, cicloId, bloqueId, "ORDER BY CICLO_GRUPO_ID, CURSO_ID ");
	
	
%>

<style>
	body{
		background: white;
	}
	.materias{
		display: none;
	}
</style>

<div id="content">

<h2><fmt:message key="aca.Reprobados" /> <small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%> )</small></h2>

<form name="forma" action="alumnos.jsp" method="post">
	<input type="hidden" name="Accion" />
	<div class="well">
		<select name="Ciclo" id="Ciclo" onchange='javascript:cambiaCiclo()'style="width:310px;">
	<%
		for(int j=0;j<lisCiclo.size();j++){
			aca.ciclo.Ciclo ciclo = (aca.ciclo.Ciclo) lisCiclo.get(j);
			if (ciclo.getCicloId().equals(cicloId)){
				out.print(" <option value='"+ciclo.getCicloId()+"' Selected>"+ ciclo.getCicloNombre()+"</option>");
			}else{
				out.print(" <option value='"+ciclo.getCicloId()+"'>"+ ciclo.getCicloNombre()+"</option>");
			}
		}
	%>   </select>
	
		<select id="Bloque" name="Bloque" onchange="cambiaBloque();" >
	<%
		for(int j = 0; j < lisCicloBloque.size(); j++){
			aca.ciclo.CicloBloque bloque = (aca.ciclo.CicloBloque) lisCicloBloque.get(j);
	%>
			<option value="<%= bloque.getBloqueId()%>"<%= bloque.getBloqueId().equals(bloqueId)?" Selected":"" %>><%=bloque.getBloqueNombre()%></option>
	<%	} %>
		</select>
		
		<a style="float:right;" class="btn btn-info showAll"><i class="icon-plus icon-white"></i> <fmt:message key="boton.MostrarMaterias" /></a>
	</div>
	
	
</form>


<%
	String nivelTmp = "";
	for(aca.ciclo.CicloGrupo cicloGrupo: lisCicloGrupo){

		if (!cicloGrupo.getNivelId().equals(nivelTmp)){
			
			out.print("<div class='alert alert-info'><h4>"+aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, cicloGrupo.getNivelId())+"</h4></div>");
			
			nivelTmp = cicloGrupo.getNivelId();
		}
		
		String reprobones = "0";
		
		if(reprobados.containsKey(cicloGrupo.getNivelId()+cicloGrupo.getGrado()+cicloGrupo.getGrupo())){
			reprobones = reprobados.get(cicloGrupo.getNivelId()+cicloGrupo.getGrado()+cicloGrupo.getGrupo()).getGrupoNombre();	//EN LA COLUMNA GRUPO NOMBRE SE PUSO EL NUMERO DE REPROBADOS
		}
		
%>
		<div class="alert" style="margin-left:20px;">
			
			<h5><button class="btn btn-mini showMaterias"><i class="icon-zoom-in"></i></button> &nbsp;&nbsp;<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(cicloGrupo.getGrado()))%> <small>"<%=cicloGrupo.getGrupo()%>"</small></h5>
			<br />
			<fmt:message key="aca.Reprobados" />: <%=reprobones %>
		</div>
		<div class="materias">
			<table class="table table-condensed" style="margin-left:40px;width:90%;">
				<tr>
					<th><fmt:message key="aca.CursoId" /></th>
					<th><fmt:message key="aca.NombreMateria" /></th>
					<th><fmt:message key="aca.Maestro" /></th>
					<th><fmt:message key="aca.Reprobados" /></th>
				</tr>
			<%
				for(aca.ciclo.CicloGrupoCurso materias: reprobadosMaterias){	
					if(!materias.getCicloGrupoId().equals(cicloGrupo.getCicloGrupoId()))continue;
			%>
				<tr>
					<td><%=materias.getCursoId() %></td>
					<td><%=aca.plan.PlanCurso.getCursoNombre(conElias,materias.getCursoId())%></td>
					<td><%=aca.empleado.EmpPersonal.getNombre(conElias, materias.getEmpleadoId(), "NOMBRE")  %></td>
					<td><a href="detalle.jsp?cursoId=<%=materias.getCursoId()%>&cicloGrupoId=<%=materias.getCicloGrupoId()%>&bloqueId=<%=bloqueId%>"><%=materias.getHorario() %></a></td><!-- EN EL CAMPO DE HORARIO SE PUSO LA CANTIDAD DE REPROBADOS -->
				</tr>
			<%
				}
			%>
			</table>
		</div>
<%	


	} 
%>




</div>

<script>
	
	function cambiaCiclo(){
		document.forma.Accion.value = "1";
		document.forma.submit();	
	}
	
	function cambiaBloque(){
		document.forma.submit();
	}
	
	jQuery(".showMaterias").on('click', function(){
		$this = $(this);
		
		if($this.find('i').hasClass('icon-zoom-in')){
			$this.parents('div.alert').next('div.materias').slideDown(300);
			
			$this.find('i').removeClass('icon-zoom-in').addClass('icon-zoom-out');
		}else{
			$this.parents('div.alert').next('div.materias').slideUp(300);
			
			$this.find('i').removeClass('icon-zoom-out').addClass('icon-zoom-in');
		}
		
	});
	
	var icons = jQuery(".showMaterias").find('i');
	jQuery(".showAll").on('click', function(){
		var $this = $(this);
		
		if($this.find('i').hasClass('icon-plus')){
			$this.find('i').removeClass('icon-plus').addClass('icon-minus');
			icons.removeClass('icon-zoom-in').addClass('icon-zoom-out');
			icons.parents('div.alert').next('div.materias').slideDown(300);
		}else{
			$this.find('i').removeClass('icon-minus').addClass('icon-plus');
			icons.removeClass('icon-zoom-out').addClass('icon-zoom-in');
			icons.parents('div.alert').next('div.materias').slideUp(300);
		}
		
	});
	
</script>

<%@ include file="../../cierra_elias.jsp" %>