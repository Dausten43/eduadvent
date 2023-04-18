<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="Permiso" scope="page" class="aca.ciclo.CicloPermiso"/>
<jsp:useBean id="PermisoLista" scope="page" class="aca.ciclo.CicloPermisoLista"/>
<jsp:useBean id="CatGrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="PlanLista" scope="page" class="aca.plan.PlanLista"/>


<script>

	function cambiaCiclo( ){
		document.frmPermiso.Accion.value = "1";
		document.frmPermiso.submit();	
	}
		
</script>
<%	
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoId");
	String cicloId			= (String) session.getAttribute("cicloId");
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo	 	= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");

	//Poner por default el primer ciclo en caso de no estra registrado en la sesión.
	if (cicloId==null || cicloId.equals("XXXXXXX")){		
		aca.ciclo.Ciclo ci = (aca.ciclo.Ciclo) lisCiclo.get(0);
		cicloId = ci.getCicloId();		
	}
	
	String strAccion 		= request.getParameter("Accion");
	if (strAccion==null) 	strAccion = "0"; 
	int numAccion 			= Integer.parseInt(strAccion);
	String strCheck			= "";
	
	switch (numAccion){
	
		case 1: { 
			cicloId = request.getParameter("Ciclo");
			session.setAttribute("cicloId",cicloId);
			break;
		}
		case 2: {
			int numNegado = Integer.parseInt(request.getParameter("TotNegado"));
			for(int i=0;i<=numNegado;i++){
				strCheck	= request.getParameter("Check"+i); if(strCheck==null){ strCheck="X"; }
				if(!strCheck.equals("X")){
					Permiso.setCicloId(cicloId);
					Permiso.setNivelId(request.getParameter("Nivel"+i));
					if (Permiso.insertReg(conElias) == true){						
					}
				}
			}
			break;
		}
		case 3: {
			int numPermiso = Integer.parseInt(request.getParameter("TotPermiso"));
			for(int i=0;i<=numPermiso;i++){
				strCheck	= request.getParameter("Check"+i); if(strCheck==null){ strCheck="X"; }
				if(!strCheck.equals("X")){
					Permiso.setCicloId(cicloId);
					Permiso.setNivelId(request.getParameter("Nivel"+i));
					if (Permiso.deleteReg(conElias) == true){						
					}
				}
			}
			break;
		}
	}
	ArrayList<aca.ciclo.CicloPermiso> lisConPermiso		= PermisoLista.getListConPermiso(conElias,cicloId,"ORDER BY NIVEL_ID");
	ArrayList<aca.ciclo.CicloPermiso> lisSinPermiso		= PermisoLista.getListSinPermiso(conElias,cicloId,"ORDER BY NIVEL_ID");
	
	
%>

<div id="content">
	<h2><fmt:message key="permisos.Permisos" /></h2>
	
	<form name="frmPermiso" action="permiso.jsp" method="post">
		<input type="hidden" name="Accion">
		
		<div class="well">
		  	<select name="Ciclo" id="Ciclo" onchange='javascript:cambiaCiclo()' style="width:310px;">
			<%for( aca.ciclo.Ciclo ciclo : lisCiclo){%>
				<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>><%=ciclo.getCicloNombre() %></option>
			<%}%>    
			</select>
		</div>
	</form>
	
	
	<div class="row">
		<div class="span5">
			<form name="frmSinPermiso" method="post" action="permiso.jsp">
				<input type="hidden" name="Accion" value="2">
				
				<div class="alert alert-info"><fmt:message key="permisos.SinPermiso" /></div>			
				<table class="table table-condensed table-bordered table-striped">
			    	<tr> 
			        	<th><fmt:message key="aca.Elegir" /></th>
			          	<th><fmt:message key="catalogo.Nivel" /></th>
			          	<th><fmt:message key="aca.Nombre" /></th>
			        </tr>
			        <%int i = 0; %>
					<%for (aca.ciclo.CicloPermiso permiso : lisSinPermiso){%>		
			        	<tr>
			          		<td>
					    		<input name="Check<%=i%>" type="checkbox" value="S">
								<input name="Nivel<%=i%>" type="hidden" value="<%=permiso.getNivelId()%>">
					  		</td>
			          		<td><%=permiso.getNivelId()%></td>
			          		<td><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, permiso.getNivelId())%></td>
			        	</tr>
			        	<%i++; %>
					<%}%>
					<tr>
						<td colspan="3">
					    	<input class="btn btn-primary" name="Aplicar" type="submit" value="<fmt:message key="boton.Aplicar" />">
							<input name="TotNegado" type="hidden" id="TotNegado" value="<%=i%>">
					  	</td>
					</tr>		
			     </table>
			</form>  
		</div>
	
		<div class="span5">
			<form name="frmConPermiso" method="post" action="permiso.jsp">    
				<input type="hidden" name="Accion" value="3">
				
				<div class="alert alert-info"><fmt:message key="permisos.ConPermiso" /></div>
				<table class="table table-condensed table-bordered table-striped">
			    	<tr> 
			        	<th><fmt:message key="aca.Elegir" /></th>
			          	<th><fmt:message key="catalogo.Nivel" /></th>
			          	<th><fmt:message key="aca.Nombre" /></th>
			        </tr>
			        <% i = 0; %>
					<%
				    java.util.TreeMap<String, Integer> nivelAlta = new java.util.TreeMap<String, Integer>();
					java.util.ArrayList<aca.plan.Plan> pPlanLista = PlanLista.getListPlanPermiso(conElias, cicloId, "ORDER BY NIVEL_ID");
				    for(aca.plan.Plan plan : pPlanLista){
				    	
				    	int numCursosAlta=CatGrupoL.getListGruposAlta(conElias, cicloId, plan.getPlanId(), escuelaId, plan.getNivelId(), "ORDER BY NIVEL_ID, GRADO, GRUPO").size();
				    	nivelAlta.put(plan.getNivelId().trim(), numCursosAlta);
				    	
				    	System.out.println("nivel alta mapa  "+ numCursosAlta + " " + plan.toString());
					}
					for(aca.ciclo.CicloPermiso permiso : lisConPermiso){
						System.out.println("compara ciclo permiso " + lisConPermiso.toString() + " " + i + " " + nivelAlta.containsKey(permiso.getNivelId().trim()));
						
					%>
			        	<tr>
			          		<td>
			          			
			          			<%
			          			
			          			if(nivelAlta.containsKey(permiso.getNivelId().trim()) && nivelAlta.get(permiso.getNivelId().trim()) <= 0){%>
					    		<input name="Check<%=i%>" type="checkbox" value="S">
								<input name="Nivel<%=i%>" type="hidden" value="<%=permiso.getNivelId()%>">
								<%}%>
					  		</td>
			          		<td><%=permiso.getNivelId()%></td>
			          		<td><%
			          		try{
			          		out.println(aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, permiso.getNivelId()));
			          		}catch(Exception e){
			          			System.out.println("si llega al 168 " + i);			          			
			          		}
			          		%></td>
			        	</tr>
			        	<% i++; 
			        	//System.out.println("si llega al 167 " + i);
			        	%>
					<%}%>
					<tr>
					<%
												
			        	//System.out.println("si llega al 172 " + i);
			        	%>
					  <td colspan="3">
					    <input class="btn btn-primary"name="Quitar" type="submit" id="Quitar" value="<fmt:message key="boton.Quitar" />">
						<input name="TotPermiso" type="hidden" id="TotPermiso" value="<%=i%>">
					  </td>
					</tr>
			   </table>
			</form>
		</div>
	</div>	  
	
	 
</div>

<%@ include file= "../../cierra_elias.jsp" %> 