<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Personal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="Padres" scope="page" class="aca.alumno.AlumPadres"/>

<% 
	String escuelaId 			= (String) session.getAttribute("escuela");
	String codigoAlumno			= (String) session.getAttribute("codigoAlumno");
	Personal.mapeaRegId(conElias, codigoAlumno);
	boolean tieneFoto 			= false;
	
	// Verifica si existe la imagen	
	String dirFoto = application.getRealPath("/WEB-INF/fotos/"+codigoAlumno+".jpg");
	java.io.File foto = new java.io.File(dirFoto);
	if (foto.exists()){
		tieneFoto = true;
	}
%>

<style>
	label{
		font-size: 14px;
		font-weight: 800;
	}
	.span4{
		font-size: 16px;
		font-weight: 300;
	}
</style>
		
<div id="content">

<%

	if(!Personal.existeReg(conElias, codigoAlumno)){
%>
		<div class="alert">
			<fmt:message key="aca.NoAlumnoSeleccionado" />
		</div>
<%		
	}else{
%>

		<h2>
			<%= Personal.getNombre() + " " + Personal.getApaterno() + " " + Personal.getAmaterno() %> 
		</h2>
		
		<hr />
		
		
		<div class="row">
			<div class="span3">
				<img src="../../parametros/foto/foto.jsp?mat=<%=Personal.getCodigoId()%>" width="300">
				
				<br><br>
				
				<div class="well" style="text-align:center;">
					<a title="<fmt:message key="boton.TomarFoto"/>" href="tomarfoto.jsp" class="btn btn-primary"><i class="icon-camera icon-white"></i></a>
			        <a title="<fmt:message key="aca.SubirFotoAlumno"/>" href="subir.jsp" class="btn btn-info"><i class="icon-arrow-up icon-white"></i></a>          
					<%if (tieneFoto){%>              
			        	<a title="<fmt:message key="boton.EliminarFoto"/>" class="btn btn-danger" onclick="borrar();"><i class="icon-remove icon-white"></i></a>
					<%}%>    
				</div>
			</div>
		<%
			String genero = Personal.getGenero();
			if(genero.equals("F")){
				genero = "Mujer";
			}else{
				genero = "Hombre";
			}
			
			String clasificacion = Personal.getClasfinId();
			if(clasificacion.equals("1")){
				clasificacion = "ACFE";
			}else{
				clasificacion = "NO ACFE";
			}
		%>
			<div class="span3">
				<p>
					<label><fmt:message key="aca.Codigo"/></label>
					<%= Personal.getCodigoId() %>
				</p>
				<p>
					<label><fmt:message key="aca.Genero"/></label>
					<%=genero %>
				</p>
				<p>
					<label><fmt:message key="aca.FechadeNacimiento"/></label>
					<%= Personal.getFNacimiento() %>
				</p>
				<p>
					<label><fmt:message key="aca.CURP"/></label>
					<%= Personal.getCurp().equals("")?"-":Personal.getCurp() %>
				</p>
				<p>
					<label><fmt:message key="aca.Religion"/></label>
					<%= aca.catalogo.CatReligion.getReligionNombre(conElias,Personal.getReligion()) %>
				</p>
				<p>
					<label><fmt:message key="aca.Clasificacion"/></label>
					<%= clasificacion %>
				</p>
				<p>
					<label><fmt:message key="aca.Telefono"/></label>
					<%= Personal.getTelefono() %>
				</p>
			</div>
	
	<%      
	        String padre = "";
			String madre = "";
			String tutor = "";
			Padres.setCodigoId(codigoAlumno);
			if(Padres.existeReg(conElias)){
				Padres.mapeaRegId(conElias,codigoAlumno);
		          padre = aca.empleado.EmpPersonal.getNombre(conElias,Padres.getCodigoPadre(),"NOMBRE"); 
				  madre = aca.empleado.EmpPersonal.getNombre(conElias,Padres.getCodigoMadre(),"NOMBRE");
				  tutor = aca.empleado.EmpPersonal.getNombre(conElias,Padres.getCodigoTutor(),"NOMBRE");
			}else{
				padre = "-";
				madre = "-";
				tutor = "-";
			}			
	%>
	
			<div class="span3">
				<p>
					<label><fmt:message key="aca.Padre"/></label>
					<%=padre%>
				</p>
				<p>
					<label><fmt:message key="aca.Madre"/></label>
					<%=madre%>
				</p>
				<p>
					<label><fmt:message key="aca.Tutor"/></label>
					<%=tutor%>
				</p>
				
				<hr />
				
				<p>
					<label><fmt:message key="aca.Plan"/></label>
					<%= aca.plan.Plan.getNombrePlan(conElias, aca.alumno.AlumPlan.getPlanActual(conElias,codigoAlumno))%>
				</p>
				<p>
					<label><fmt:message key="aca.Grado"/></label>
					<%= Personal.getGrado() %>
				</p>
				<p>
					<label><fmt:message key="aca.Grupo"/></label>
					<%= Personal.getGrupo()%>			
				</p>
			</div>
		</div>

<%
	}//End existe alumno
%>    

</div>

<script>
	function borrar(){
		if( confirm("<fmt:message key="js.Confirma" />") ){
			location.href="borrar.jsp";
		}
	}
</script>

<%@ include file="../../cierra_elias.jsp" %>