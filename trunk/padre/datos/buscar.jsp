<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<%
	String escuelaId	= (String) session.getAttribute("escuela");	
	String strCodigo 	= request.getParameter("CodigoEmpleado");
	String tipo 		= request.getParameter("tipo");
	String sResultado	= "";
	String nResultado   = "";
%>
<head>
	
</head>
<%
	ArrayList lisAlumno	 	= new ArrayList();
		
	String sAccion			= request.getParameter("Accion");
	if (sAccion == null) sAccion = "0";
	int nAccion 			= Integer.parseInt(sAccion);
	String strResultado		= "OpcionConsulta";
	String strBgcolor			= "";
	String strNombre 			= ""; 
	String strPaterno			= request.getParameter("Paterno")==null?"":request.getParameter("Paterno");
	String strMaterno			= "";
	
	switch (nAccion){
		case 1:{
			strNombre		= request.getParameter("Nombre");	
			strPaterno		= request.getParameter("Paterno");
			strMaterno		= request.getParameter("Materno");
			if (strNombre == null) strNombre = "";
			if (strPaterno== null) strPaterno = "";
			if (strMaterno== null) strMaterno = "";
			lisAlumno = alumnoLista.getArrayList(conElias, escuelaId, strNombre, strPaterno, strMaterno,"ORDER BY 3,4,5");
			if (lisAlumno.size() > 0)
				strResultado	= "ClickNombreAlumno";
			else
				strResultado = "NoEncontro";
			break;
		} 
		case 2:{
			alumno.setCodigoId(request.getParameter("CodigoPersonal"));
			if (alumno.existeReg(conElias) == true && request.getParameter("CodigoPersonal").substring(0,3).equals(escuelaId.length()==1?("0"+escuelaId):escuelaId)){
				alumno.mapeaRegId(conElias, request.getParameter("CodigoPersonal"));
				strResultado = "ClickNombreAlumno";
			}else{
				strResultado = "NoExiste";
			}
			break;
		}
		case 7:	{ // Guardar Hijo
			String hijo = request.getParameter("hijo");
			boolean ok = false;
			alumPadres.setCodigoId(hijo);
			if(alumPadres.existeReg(conElias)){
				
				alumPadres.mapeaRegId(conElias, hijo);
				if (tipo.equals("Padre")){
					if (alumPadres.getCodigoPadre().trim().length()==7){
						if(strCodigo.equals(alumPadres.getCodigoPadre())){
							nResultado = "YaEstaAsignado";
						}else{
							sResultado = "AlumnoYaTienePadre";
						}
					}else{
						alumPadres.setCodigoPadre(strCodigo);
						ok = true;
					}
				}else if(tipo.equals("Madre")){
					if (alumPadres.getCodigoMadre().trim().length()==7){
						if(strCodigo.equals(alumPadres.getCodigoMadre())){
							sResultado = "YaEstaAsignado";
						}else{
							sResultado = "AlumnoYaTieneMadre";
						}
					}else{
						alumPadres.setCodigoMadre(strCodigo);
						ok = true;
					}
				}else if(tipo.equals("Tutor")){
					if (alumPadres.getCodigoTutor().trim().length()==7){
						if(strCodigo.equals(alumPadres.getCodigoTutor())){
							sResultado = "YaEstaAsignado";
						}else{
							sResultado = "AlumnoYaTieneTutor";
						}	
					}else{
						alumPadres.setCodigoTutor(strCodigo);
						ok = true;
					}
				}
				if (ok == true && alumPadres.updateReg(conElias)){
					sResultado = "SeActualizaronCorrectamente";		
				}
			}else{
				
				if (tipo.equals("Padre")){					
					alumPadres.setCodigoPadre(strCodigo);
					alumPadres.setCodigoMadre("-");
					alumPadres.setCodigoTutor("-");
				}else if(tipo.equals("Madre")){
					alumPadres.setCodigoPadre("-");
					alumPadres.setCodigoMadre(strCodigo);
					alumPadres.setCodigoTutor("-");
				}else if(tipo.equals("Tutor")){
					alumPadres.setCodigoPadre("-");
					alumPadres.setCodigoTutor("-");
					alumPadres.setCodigoTutor(strCodigo);
				}

				if(alumPadres.insertReg(conElias)){
					sResultado = "AlumnoGuardadoCorrectamente";	
					//javascript location.href = 'accion_p.jsp?resultado='request
					
				}else{
					sResultado = "ErrorGuardadoAlumno";
				}
			}
		}break;
		//
	}	
	pageContext.setAttribute("strResultado",strResultado);
	pageContext.setAttribute("nResultado",nResultado);
	pageContext.setAttribute("sResultado",sResultado);
%>
<body>


<div id="content">

	<h2><fmt:message key="padre.BusquedaAlumnos" /></h2>
	
<%
	if(!strResultado.equals("")){
%>
		<div class="alert"><fmt:message key="aca.${strResultado}" /></div>
<%		
	}
%>
<%
	if(!nResultado.equals("")){
%>
		<div class="alert"><fmt:message key="aca.${nResultado}" /></div>
<%		
	}
%>
<%
	if(!sResultado.equals("")){
%>
		<div class="alert"><fmt:message key="aca.${sResultado}" /></div>
<%		
	}
%>
	
	<div class="well">
		<a href="accion_p.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	
	<div class="row">
	  <div class="span4">
	  	
	  	
			<form name="frmnombre" method="POST" action="buscar.jsp?Accion=1">
			<input name="Accion" type="hidden">
			<input name="CodigoEmpleado" type="hidden" value="<%= strCodigo%>">
			<fieldset>
			
				
		           <label for="Nombre">
		               <fmt:message key="aca.Nombre" />
		           </label>
		           <input type="Text" name="Nombre" size="3" maxlength="15">
		           
		           <label for="Paterno">
		               <fmt:message key="aca.ApellidoPat" />
		           </label>
		           <input type="Text" name="Paterno" size="3" value = "<%= strPaterno%>" maxlength="15">
		        	
		        	<label for="Materno">
		               <fmt:message key="aca.ApellidoMat" />
		           </label>
		           <input type="Text" name="Materno" size="3" maxlength="15">
				
			</fieldset>
			
			<p>
				<a class="btn btn-primary" href="javascript:BuscarNombre()"><i class="icon-search icon-white"></i> <fmt:message key="boton.Buscar" /></a>
			</p>
			</form>
	  
	  </div>
	  
	  <div class="span8">
	  
	  		<label for="tipo"><fmt:message key="aca.Tipo" /></label>
	  		<select id="tipo" name="tipo">
                <option value='Padre' <% if (Personal.getGenero().equals("M")) out.print("selected"); %>><fmt:message key="aca.Padre" /></option>
                <option value='Madre' <% if (Personal.getGenero().equals("F")) out.print("selected"); %>><fmt:message key="aca.Madre" /></option>
                <option value='Tutor' >Tutor</option>
			</select>
			
			<label for="hijo"><fmt:message key="aca.Alumnos" /></label>
			
			<select id="hijo" name="hijo" class="input-xxlarge">
			<%
				int mostrarBoton=0;
				switch (nAccion){
					case 1:{
						mostrarBoton = 1;
						for (int i=0; i< lisAlumno.size(); i++){
							alumno = (aca.alumno.AlumPersonal) lisAlumno.get(i);
			%>				
				  	<option value="<%=alumno.getCodigoId() %>"><%=alumno.getNombre()%>&nbsp;<%=alumno.getApaterno()%>&nbsp;<%=alumno.getAmaterno()%> [<%=alumno.getCodigoId() %>]</option>
			<%				
						}	
						break;
					} 
					case 2:{
						alumno.setCodigoId(request.getParameter("CodigoPersonal"));
						if (!request.getParameter("CodigoPersonal").substring(0,3).equals(escuelaId.length()==1?("0"+escuelaId):escuelaId) || !alumno.existeReg(conElias)) break;
			%>	
			
			 
			<%  		
					}
				}
			%> 
			</select>
			
			<p>
						
			<%if(mostrarBoton==1){ %> <a onclick="agregaHijo()" class="btn btn-primary"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a> <% }%>
			
			</p>
								  			  
	  </div>
	  
	</div>


</div>


<script>
	
	function Consultar(){
		document.frmalumno.Accion.value="1";
		document.frmalumno.submit();
	}
	
	function BuscarNombre( ){
		if (document.frmnombre.Nombre.value!="" || document.frmnombre.Paterno.value!="" || document.frmnombre.Materno.value!=""){
			document.frmnombre.Accion.value="1";
			document.frmnombre.submit();
		}else{
			alert(" <fmt:message key="aca.DatoNecesario" />");
			document.frmnombre.Nombre.focus();
		}
	}
	function agregaHijo(){
		document.location.href = "buscar.jsp?tipo="+document.getElementById("tipo").value+"&ref=0&Accion=7&CodigoEmpleado=<%=strCodigo%>&hijo="+document.getElementById("hijo").value;
	}
		
</script>
</body>
<%
	lisAlumno 	= null;
%>
<%@ include file= "../../cierra_elias.jsp" %>