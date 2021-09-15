<%@ include file="../../con_elias.jsp"%>
<%@ include file= "../../idioma.jsp" %>

<jsp:useBean id="CicloLista" class="aca.ciclo.CicloLista" scope="page" />
<jsp:useBean id="PlanLista" class="aca.plan.PlanLista" scope="page" />
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela" />
<jsp:useBean id="AlumLista" class="aca.alumno.AlumPersonalLista" scope="page" />
<jsp:useBean id="Alum" class="aca.alumno.AlumPersonal" scope="page" />
<jsp:useBean id="AlumPlan" class="aca.alumno.AlumPlan" scope="page" />
	
<%
String escuelaId	= (String) session.getAttribute("escuela");
String fecha 		= aca.util.Fecha.getHoy();

String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
String continuar 		= request.getParameter("continuar")==null?"0":request.getParameter("continuar");

String ciclo			= request.getParameter("ciclo");	
String planId	 		= request.getParameter("PlanId")==null?"Selecciona":request.getParameter("PlanId");
String grado	 		= request.getParameter("grado")==null?"":request.getParameter("grado");
String grupo	 		= request.getParameter("grupo")==null?"":request.getParameter("grupo").toUpperCase();

String planId2	 		= request.getParameter("PlanId2")==null?"Selecciona":request.getParameter("PlanId2");
String grado2	 		= request.getParameter("grado2")==null?"":request.getParameter("grado2");
String grupo2	 		= request.getParameter("grupo2")==null?"":request.getParameter("grupo2").toUpperCase();

String nivelId			= "0";
String sResultado		= "";

ArrayList<aca.plan.Plan> lisPlan		= PlanLista.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, " ORDER BY CICLO_ID");
String [] arreglo 						= new String[0];// arreglo para guardar codigos_id a promover

if(accion.equals("2") && continuar.equals("0")){
	nivelId = aca.plan.Plan.getNivel(conElias, planId2);
	Nivel.mapeaRegId(conElias, nivelId, escuelaId);
	ArrayList<aca.alumno.AlumPersonal> lisPro	= AlumLista.getListPromover(conElias, escuelaId, ciclo, planId2, grado2, grupo2, "ORDER BY NOMBRE");
	if(Integer.parseInt(grado2)==Integer.parseInt(Nivel.getGradoFin())+1){
		accion="1";
		%>
		<script>
			var continuar = confirm("<fmt:message key='js.ConfirmaInactivarAlumnos'/>");
		</script>
		<%
	}
	else if(lisPro.size()>0){
		accion="1";
		%>
		<script>
			var continuar = confirm("<fmt:message key='aca.HayAlumnosGpo'/> "+'<%=grado2%>'+"º "+'<%=grupo2%>'+". <fmt:message key='js.ConfirmaPromocion'/>");
		</script>
		<%
	}

}
if(accion.equals("1")){
	String periodoId	    = request.getParameter("PeriodoId")==null?aca.ciclo.CicloPeriodo.periodoActual(conElias, ciclo):request.getParameter("PeriodoId");
	ArrayList<aca.alumno.AlumPersonal> lisPro	= AlumLista.getListPromover(conElias, escuelaId, ciclo, planId, grado, grupo, "ORDER BY NOMBRE");
	%>
	<input type="hidden" id="planId" name="planId" value="<%=planId%>">
	<table class="table table-condensed table-bordered">
		<tr>
			<th width="1%">
				<input name="CheckAll" type="checkbox" value="S" onclick='javascript:seleccionarTodos(this)'>
			</th>
			<th width="5%">#</th>
			<th width="8%"><fmt:message key="aca.Matricula" /></th>
			<th width="30%"><fmt:message key="aca.Nombre" /></th>
			<th width="2%"><fmt:message key="aca.Edad" /></th>
		</tr> <%
		int contador = 0;
		for (aca.alumno.AlumPersonal alum : lisPro){
			boolean isNotInscrito = !aca.vista.AlumInscrito.estaInscrito(conElias, alum.getCodigoId());
			%>
			<%contador++; %>
			<tr>
				<td>
					<%if(isNotInscrito){%> 
						<input type="checkbox" id="alum" name="Alum" value="<%=alum.getCodigoId()%>" />
					<%} %>
				</td>
				<td><%=contador%></td>
				<td><%=alum.getCodigoId()%></td>
				<td><%=alum.getNombre()+" "+alum.getApaterno()+" "+alum.getAmaterno()%></td>
				<td><%=aca.alumno.AlumPersonal.getEdad(conElias, alum.getCodigoId())%></td>
			</tr> <%
		}%>
	</table><%
}else if(accion.equals("2")){
	String[] lisPro2 = request.getParameterValues("alumnos[]");
	arreglo = new String[lisPro2.length];
	int contadorArreglo = 0;
	int num = 0;
	
	/* BEGIN TRANSACTION */
	conElias.setAutoCommit(false);
	boolean error = false;
	for (String alumId : lisPro2){
		
			// DESACTIVAR EL PLAN ANTERIOR (SI ES QUE ES DIFERENTE AL NUEVO)
			AlumPlan.setCodigoId(alumId);
			AlumPlan.setPlanId(planId);
			if (AlumPlan.existeReg(conElias) && !planId.equals(planId2) ){
				if (AlumPlan.updateRegDesactivarPlan(conElias, alumId, planId)){
					System.out.println("Se desactivo correctamente");
				}else{
					error = true;
				}
			}
			// ACTUALIZAMOS DATOS EN ALUM_PLAN
			AlumPlan.setCodigoId(alumId);
			AlumPlan.setPlanId(planId2);
			if (AlumPlan.existeReg(conElias)){
				AlumPlan.mapeaRegId(conElias, alumId, planId2);
				AlumPlan.setGrado(grado2);
				AlumPlan.setGrupo(grupo2);
				AlumPlan.setEstado("1");
				if (AlumPlan.updateReg(conElias)){
					//Se mofico en Alum_plan				
				}else{
					error = true;
				}
			}else{
				AlumPlan.setCodigoId(alumId);
				AlumPlan.setFInicio(fecha);
				AlumPlan.setEstado("1");
				AlumPlan.setPlanId(planId2);							
				AlumPlan.setGrado(grado2);
				AlumPlan.setGrupo(grupo2);
				if (AlumPlan.insertReg(conElias)){
					//Se grabo en Alum_plan	\
				}else{
					error = true;
				}
			}		
			// ACUTALIZAMOS DATOS EN ALUM_PERSONAL
			if (error == false){
				nivelId = aca.plan.Plan.getNivel(conElias, planId2);
				Alum.setCodigoId(alumId);
				Alum.setNivelId(nivelId);
				Alum.setGrado(grado2);
				Alum.setGrupo(grupo2);
				if(Alum.existeReg(conElias)){
					if (Alum.updateRegPromover(conElias)){
						num++;
						arreglo[contadorArreglo] = alumId;
						contadorArreglo++;
					}else{							
						error = true;
					}
				}else{
					error = true;
				}	
			}	  
	}//End for que recorre alumnos
	if(error == true){
		conElias.rollback();
		sResultado = "2";
	}else{
		conElias.commit();
		sResultado = "1";
	}
	/* END TRANSACTION */
	conElias.setAutoCommit(true);
	%>
	<!-- <form action="promover.jsp" method="post" name="formTabla"> -->
	<input type="hidden" id="result" name="result" value="<%=sResultado%>">
	<%
	
	ArrayList<aca.alumno.AlumPersonal> lisPro3	= AlumLista.getListPromover(conElias, escuelaId, ciclo, planId2, grado2, grupo2, "ORDER BY NOMBRE");
	%>
	
	<table class="table table-bordered table-condesed">
		<tr>
			<th width="5%">#</th>
			<th width="8%"><fmt:message key="aca.Matricula" /></th>
			<th width="30%"><fmt:message key="aca.Nombre" /></th>
		</tr>
		<%
		int conta = 0;
		for (aca.alumno.AlumPersonal alum : lisPro3){
			boolean promovido = false;
			conta++;
			for(int k=0; k<arreglo.length; k++){
				String temp = arreglo[k];
				if(temp==null){
					temp="";
				}
				if(temp.equals(alum.getCodigoId())){
					promovido = true;
				}
			} %>
			<tr>
				<td <%if(promovido==true){%> style="color: green" <%}%>><%=conta%></td>
				<td <%if(promovido==true){%> style="color: green" <%}%>><%=alum.getCodigoId()%></td>
				<td <%if(promovido==true){%> style="color: green" <%}%>><%=alum.getNombre()+" "+alum.getApaterno()+" "+alum.getAmaterno()%></td>
			</tr> <%
		} %>
	</table> 
	<!-- </form> -->
	<%
}
%>

<%@ include file="../../cierra_elias.jsp"%>