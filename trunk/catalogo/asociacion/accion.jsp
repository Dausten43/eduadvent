<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Asociacion" scope="page" class="aca.catalogo.CatAsociacion"/>
<jsp:useBean id="AsociacionU" scope="page" class="aca.catalogo.CatAsociacionLista"/>
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
	String unionId 			= request.getParameter("unionId");
	ArrayList lisUnion		= new ArrayList();
	String salto			= "X";
	//String añadir 			= request.getParameter("añadir");
	

	if(accion.equals("1")){//Nuevo
		java.util.HashMap<String, aca.catalogo.CatAsociacion> asocs = AsociacionU.getMapAll(conElias, "");
		String id = "";
		
		for(int i=1; i<100; i++){
			if( asocs.containsKey(i+"") ){
				//Este no
			}else{
				//Este si
				id = i+"";
				break;
			}
		}
		
		Asociacion.setAsociacionId(id);
	}else if(accion.equals("2")){//Grabar
		Asociacion.setAsociacionId(request.getParameter("AsocId"));
		Asociacion.setAsociacionNombre(request.getParameter("AsocNombre"));		
		Asociacion.setUnionId(request.getParameter("UnionId"));
		Asociacion.setFondoId(request.getParameter("FondoId"));
		Asociacion.setAsociacionNombreCorto(request.getParameter("AsocNombreCorto"));
			
		if(Asociacion.existeReg(conElias)){
			if(Asociacion.updateReg(conElias)){
	       		sResultado = "Modificado";
	       		
			}else{
				sResultado = "NoModifico"; 
			}
		}else{
			if(Asociacion.insertReg(conElias)){
				sResultado = "Guardado";
			}else{
				sResultado = "NoGuardo";
			}
		}
		
		
		//Si ya hay una Asociacion 
	/*	if(!Asociacion.existeReg(conElias)){
			if(Asociacion.insertReg(conElias)){
				sResultado = "Guardado";
			}else{
				sResultado = "NoGuardo";
			}
		}else{
			if(Asociacion.updateReg(conElias)){
	       		sResultado = "Modificado";
	       		
			}else{
				sResultado = "NoModifico"; 
			}
		}
		*/
	}else if(accion.equals("3")){//Borrar
		Asociacion.setAsociacionId(request.getParameter("AsocId"));
	
		ArrayList<aca.catalogo.CatEscuela> escuelas = EscuelaU.getListAsociacion(conElias, Asociacion.getAsociacionId(), "");
		
		if(escuelas.size()==0){
	
			if(Asociacion.deleteReg(conElias)){
				sResultado = "Eliminado";
				salto = "asociacion.jsp";
			}else{
				sResultado = "NoElimino";
			}
			
		}else{
			sResultado = "EliminarAsocError";
		}
	}else if(accion.equals("4")){//Editar
		Asociacion.mapeaRegId(conElias, request.getParameter("AsocId"));
	}
	
	pageContext.setAttribute("resultado", sResultado);
	
%>
<body>
<div id="content">
   	<h2><fmt:message key="catalogo.AnadirAsoc" /></h2>
   	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  
   <div class="well" style="overflow:hidden;">
  	<a class="btn btn-primary" href="asociacion.jsp?unionId=<%=unionId%>"><i class="icon-list icon-white"></i>&nbsp;<fmt:message key="boton.Listado" /></a>
  </div>

<form action="accion.jsp" method="post" name="forma" target="_self">
<input type="hidden" name="Accion">
<input name="Pec" type="hidden">
<input type="hidden" name="unionId" value="<%=unionId %>" />
	<fieldset>
		<div class="control-group ">
	    	<label for="AsocId">
	        	<fmt:message key="aca.Id" />:
	         
	        </label>
	        <input name="AsocId" type="text" id="AsocId" size="2" maxlength="2" value="<%=Asociacion.getAsociacionId()%>">     
	    </div>
	        
	    <div class="control-group ">
	    	<label for="AsocNombre">
	        	<fmt:message key="aca.Nombre" />:
	        </label>
	        <input name="AsocNombre" type="text" id="AsocNombre" value="<%=Asociacion.getAsociacionNombre()%>" size="40" maxlength="70">        
	    </div>
	        
	    <div class="control-group ">
	    	<label for="UnionId">
	        	<fmt:message key="catalogo.Union" />:
	        </label>
	           <select name="UnionId" id="UnionId"  tabindex="7">
			     <%	aca.catalogo.CatUnionLista unionL = new aca.catalogo.CatUnionLista();
				 	lisUnion = unionL.getListAll(conElias,"ORDER BY 2");
					for(int i=0; i<lisUnion.size(); i++){
						aca.catalogo.CatUnion union = (aca.catalogo.CatUnion) lisUnion.get(i);
				   	   		if(union.getUnionId().equals(Asociacion.getUnionId())){
								out.print(" <option value='"+union.getUnionId()+"' Selected>"+ union.getUnionNombre()+"</option>");
							}else if (unionId.equals(union.getUnionId())){
								out.print(" <option value='"+union.getUnionId()+"' Selected>"+ union.getUnionNombre()+"</option>");
							}else{
								out.print(" <option value='"+union.getUnionId()+"'>"+ union.getUnionNombre()+"</option>");
					 		}
					}	
					unionL = null;%>
			  	</select>
	    </div>
	    
	    <div class="control-group ">
	    	<label for="FondoId">
	        	<fmt:message key="aca.Fondo" />:
	        </label>
	        <input name="FondoId" type="text" id="FondoId" value="<%=Asociacion.getFondoId() %>" size="40" maxlength="10">
	                
	    </div>
	    
	   	<div class="control-group ">
	    	<label for="AsocNombreCorto">
	        	<fmt:message key="aca.NombreCorto" />:
	        </label>
	        <input name="AsocNombreCorto" type="text" id="AsocNombreCorto" value="<%=Asociacion.getAsociacionNombreCorto() %>" size="40" maxlength="24">
	                
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
