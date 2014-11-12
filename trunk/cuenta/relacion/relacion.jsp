<%@page import="aca.cont.ContMayor"%>
<%@page import="aca.cont.ContCcosto"%>
<%@page import="aca.cont.ContAuxiliar"%>
<%@page import="aca.cont.ContTipo"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contCcosto" scope="page" class="aca.cont.ContCcosto"/>
<jsp:useBean id="contCcostoL" scope="page" class="aca.cont.ContCcostoLista"/>
<jsp:useBean id="contMayor" scope="page" class="aca.cont.ContMayor"/>
<jsp:useBean id="contMayorL" scope="page" class="aca.cont.ContMayorLista"/>
<jsp:useBean id="contAuxiliar" scope="page" class="aca.cont.ContAuxiliar"/>
<jsp:useBean id="contAuxiliarL" scope="page" class="aca.cont.ContAuxiliarLista"/>
<jsp:useBean id="contRelacion" scope="page" class="aca.cont.ContRelacion"/>
<jsp:useBean id="contTipo" scope="page" class="aca.cont.ContTipo"/>
<jsp:useBean id="contTipoL" scope="page" class="aca.cont.ContTipoLista"/>

<%
	String ccostoId						= request.getParameter("ccostoId");
	
	ArrayList<ContCcosto> lisCcosto		= contCcostoL.getListCentros(conElias, "ORDER BY CCOSTO_ID");
	ArrayList<ContMayor> lisMayor 			= null;
	ArrayList<ContTipo> lisTipo			= contTipoL.getListAll(conElias, "ORDER BY TIPO_ID");
	
	if(ccostoId == null && lisCcosto.size() > 0)
		ccostoId = ((ContCcosto)lisCcosto.get(0)).getCcostoId();
	
	if(ccostoId.charAt(ccostoId.length()-1) == '0')
		lisMayor = contMayorL.getListTipo(conElias, "B", "ORDER BY MAYOR_ID");
	else
		lisMayor = contMayorL.getListTipo(conElias, "R", "ORDER BY MAYOR_ID");
	
	
%>
<head>
	<script type="text/javascript" src="../../js/prototype.js"></script>
	<script type="text/javascript">
		function crear(cantMayor, cantAuxiliar){
			var tieneMayor = false;
			for(i = 0; i < cantMayor; i++){
				if(document.getElementById("mayor-"+i))
					if(document.getElementById("mayor-"+i).checked)
						tieneMayor = true;
			}
			if(tieneMayor){
				$("respuestaBox").scrollTo();
				$("respuestaBox").style.visibility = "visible";
				$("respuestaField").innerHTML = '<div align="center"><img src="../../imagenes/cargando.gif" /></div>';
				var url = "relacionAccion.jsp?Accion=2&"+$("forma").serialize();
				new Ajax.Request(url, {
					method: 'get',
					onSuccess: function (req){
						$("respuestaField").innerHTML = req.responseText;
					},
					onFailure: function (req){
						$("respuestaField").innerHTML = '<table><tr><td><font size=3 color=red><b>Ocurrió un error al guardar. Inténtelo de nuevo<br>Si persiste reportelo...</b></font></td></tr></table><br><br><br>'+req.responseText;
					}
				});
			}else{
				alert("Tiene que seleccionar por lo menos una Cuenta de Mayor para poder crear las cuentas");
			}
		}
		
		function muestraAuxiliares(boton){
			boton.value = "Cargando...";
			boton.disabled = "disabled";
			
			var url = "relacionAccion.jsp?Accion=5&"+$("forma").serialize();
			
			new Ajax.Request(url, {
				method: 'get',
				onSuccess: function (req){
					eval(req.responseText);
				},
				onFailure: function (req){
					$("respuestaBox").style.visibility = "visible";
					$("respuestaField").innerHTML = '<font size=3 color=red><b>Fall&oacute; la solicitud. Int&eacute;ntelo de nuevo<br>Si persiste reportelo</b></font>'+req.responseText;
				}
			});
		}
		
		function remueveAuxiliar(){
			$("auxiliarTitle").remove();
			$("auxiliarBody").remove();
			
			$("mayorTitle").insert({bottom: '<input type="button" value="Unir con Auxiliares" onclick="muestraAuxiliares(this);" />'});
			
			$("mayorBody").firstDescendant().style.width = "50%";
			$("mayorBody").style.width = "100%";
		}
	</script>
</head>
<body>
	<form id="forma" name="forma" action="relacion.jsp" method="post">
		<table width="100%">
			<tr>
				<td class="titulo">Agregar Cuentas Contables</td>
			</tr>
			<tr>
				<td align="center">
					<select id="ccostoId" name="ccostoId" onchange="document.forma.submit();">
<%
	for(int i = 0; i < lisCcosto.size(); i++){
		contCcosto = (ContCcosto) lisCcosto.get(i);
%>
					<option value="<%=contCcosto.getCcostoId() %>"<%=contCcosto.getCcostoId().equals(ccostoId)?" Selected":"" %>><%=(contCcosto.getCcostoId().charAt(contCcosto.getCcostoId().length()-1)!='0')?"&nbsp;&nbsp;&nbsp;":"" %><%=contCcosto.getNombre() %></option>
<%
	}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
		<table align="center" width="100%">
			<tr>
				<td align="center" id="mayorTitle"><b>Cuentas de Mayor <input type="button" value="Unir con Auxiliares" onclick="muestraAuxiliares(this);" /></b></td>
			</tr>
			<tr>
				<td align="center" id="mayorBody">
					<table width="50%" style="border: solid 1px gray;">
						<tr>
							<th width="30px">&nbsp;</th>
							<th width="90px">ID</th>
							<th width="62%">Nombre</th>
							<th width="180px">Naturaleza</th>
						</tr>
						<tr>
							<td colspan="4">
								<div style="width: 100%; height: 350px; overflow: auto;">
									<table width="100%">
<%
	String tipoCta = "";
	String identacion = "";
	for(int i = 0; i < lisMayor.size(); i++){
		contMayor = (ContMayor) lisMayor.get(i);
		identacion = "";
		if(contMayor.getTipoCta().equals("B")){
			if(Integer.parseInt(contMayor.getMayorId().substring(4,6)) > 0){
				identacion += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			}else if (Integer.parseInt(contMayor.getMayorId().substring(2,6))>0){
				identacion = "&nbsp;&nbsp;&nbsp;&nbsp;"; 
			}else if(Integer.parseInt(contMayor.getMayorId().substring(1,2)) > 0){
				identacion += "&nbsp;&nbsp;";
			}
		}
		
		if(contMayor.getTipoCta().equals("R")){
			if(Integer.parseInt(contMayor.getMayorId().substring(2,4)) > 0){
				identacion += "&nbsp;&nbsp;&nbsp;&nbsp;";
			}else if (Integer.parseInt(contMayor.getMayorId().substring(1,4))>0){
				identacion = "&nbsp;&nbsp;"; 
			}
		}
		if(!tipoCta.equals(contMayor.getTipoCta())){
			tipoCta = contMayor.getTipoCta();
%>
										<tr>
											<td colspan="4" align="left"><b>Cuentas de <%=tipoCta.equals("B")?"Balance":"Resultados" %></b></td>
										</tr>
<%
		}
%>
										<tr <%=i%2!=0?strColor:"" %>>
											<td width="20px">
<% 			if ( contMayor.getDetalle().equals("S") ){ %>											
												<input type="checkbox" id="mayor-<%=i %>" name="mayor-<%=contMayor.getMayorId() %>" value="<%=contMayor.getMayorId() %>" />
<% 			}%>											
											</td>
											<td width="50px" align="center"><%=contMayor.getMayorId() %></td>
											<td><%=identacion %><%=contMayor.getMayorNombre() %></td>
											<td width="102px">
												<%=contMayor.getNaturaleza().equals("D")?"Deudora":"Acreedora" %>
											</td>
										</tr>
<%
	}
%>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="button" value="   Crear   " onclick="crear(<%=lisMayor.size() %>, <%=lisTipo.size() %>);" /></td>
			</tr>
		</table>
		<table align="center" width="80%" style="border: inset 1px gray; visibility: hidden;" id="respuestaBox">
			<tr>
				<td width="100%">
					<div style="width: 100%; height: 120px; overflow: auto;" id="respuestaField">
						<table align="center">
							<div align="center"><img src="../../imagenes/cargando.gif" /></div>
						</table>
					</div>
				</td>
			</tr>
		</table>

	</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>