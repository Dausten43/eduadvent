<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Distrito" scope="page" class="aca.catalogo.CatDistrito"/>
<jsp:useBean id="DistritoU" scope="page" class="aca.catalogo.CatDistritoLista"/>
<jsp:useBean id="EscuelaU" scope="page" class="aca.catalogo.CatEscuelaLista"/>

<head>
	<script>
		
		function Grabar(){			
			if(document.forma.AsocNombre.value!=""){			
				document.forma.Accion.value="2";				
				document.forma.submit();			
			}else{
				alert("<fmt:message key="js.Completar" />");
			}
		}
	</script>
</head>
<%
	// Declaracion de variables	
	String sResultado		= "";   
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String asociacionId 	= request.getParameter("asociacionId");
	ArrayList lisAsociacion	= new ArrayList();
	String salto			= "X";

	if(accion.equals("1")){//Nuevo
		java.util.HashMap<String, aca.catalogo.CatDistrito> dist = DistritoU.getMapAll(conElias, "");
		String id = "";
		
		for(int i=1; i<100; i++){
			if( dist.containsKey(i+"") ){
				//Este no
			}else{
				//Este si
				id = i+"";
				break;
			}
		}
		
		Distrito.setAsociacionId(id);
	}else if(accion.equals("2")){//Grabar
		Distrito.setAsociacionId(request.getParameter("asociacionId"));
		Distrito.setDistritoNombre(request.getParameter("distritoNombre"));		
		Distrito.setDistritoId(request.getParameter("distritoId"));
			
		if(Distrito.existeReg(conElias)){
			if(Distrito.updateReg(conElias)){
	       		sResultado = "Modificado";
	       		
			}else{
				sResultado = "NoModifico"; 
			}
		}else{
			if(Distrito.insertReg(conElias)){
				sResultado = "Guardado";
			}else{
				sResultado = "NoGuardo";
			}
		}
		
		
		//Si ya hay un Distrito 
		if(!Distrito.existeReg(conElias)){
			if(Distrito.insertReg(conElias)){
				sResultado = "Guardado";
			}else{
				sResultado = "NoGuardo";
			}
		}else{
			if(Distrito.updateReg(conElias)){
	       		sResultado = "Modificado";
	       		
			}else{
				sResultado = "NoModifico"; 
			}
		}
		
	}else if(accion.equals("3")){//Borrar
		Distrito.setAsociacionId(request.getParameter("AsocId"));
	
		ArrayList<aca.catalogo.CatEscuela> escuelas = EscuelaU.getListAsociacion(conElias, Distrito.getAsociacionId(), Distrito.getDistritoId(), "");
		
		if(escuelas.size()==0){
	
			if(Distrito.deleteReg(conElias)){
				sResultado = "Eliminado";
				salto = "asociacion.jsp";
			}else{
				sResultado = "NoElimino";
			}
			
		}else{
			sResultado = "EliminarDistError";
		}
	}else if(accion.equals("4")){//Editar
		Distrito.mapeaRegId(conElias, request.getParameter("DistritoId"));
	}
	
	pageContext.setAttribute("resultado", sResultado);
	
%>
<body>
<div id="content">
   	<h2><fmt:message key="catalogo.AnadirDistrito" /></h2>
   	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  
   <div class="well" style="overflow:hidden;">
  	<a class="btn btn-primary" href="distrito.jsp?asociacionId=<%=asociacionId%>"><i class="icon-list icon-white"></i>&nbsp;<fmt:message key="boton.Listado" /></a>
  </div>

<form action="accion.jsp" method="post" name="forma" target="_self">
<input type="hidden" name="Accion">
<input name="Pec" type="hidden">
	<fieldset>
		<div class="control-group ">
	    	<label for="distritoId">
	        	<fmt:message key="aca.Id" />:
	         
	        </label>
	        <input name="distritoId" type="text" id="distritoId" size="2" maxlength="2" value="<%=Distrito.getDistritoId()%>">     
	    </div>
	        
	    <div class="control-group ">
	    	<label for="distritoNombre">
	        	<fmt:message key="aca.Nombre" />:
	        </label>
	        <input name="distritoNombre" type="text" id="distritoNombre" value="<%=Distrito.getDistritoNombre()%>" size="40" maxlength="70">
	                
	    </div>
	        
	        
	    <div class="control-group ">
	    	<label for="asociacionId">
	        	<fmt:message key="catalogo.Asociacion" />:
	        </label>
	           <select name="asociacionId" id="asociacionId"  tabindex="7">
			     <%	aca.catalogo.CatAsociacionLista asocL = new aca.catalogo.CatAsociacionLista();
				 	lisAsociacion = asocL.getListAll(conElias,"ORDER BY 2");
					for(int i=0; i<lisAsociacion.size(); i++){
						aca.catalogo.CatAsociacion asociacion = (aca.catalogo.CatAsociacion) lisAsociacion.get(i);
				   	   		if(asociacion.getAsociacionId().equals(Distrito.getAsociacionId())){
								out.print(" <option value='"+asociacion.getAsociacionId()+"' Selected>"+ asociacion.getAsociacionNombre()+"</option>");
							}else{
								out.print(" <option value='"+asociacion.getAsociacionId()+"'>"+ asociacion.getAsociacionNombre()+"</option>");
					 		}
					}	
					asocL = null;%>
			  	</select>
	    </div>
		
	</fieldset>
    <div class="well" style="overflow:hidden;">
    	<button class="btn btn-primary" onclick="Grabar();" ><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></button>
    </div>

</form>
</div>
</body>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>
