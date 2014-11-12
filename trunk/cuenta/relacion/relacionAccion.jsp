<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<%@page import="aca.cont.ContMayor"%>
<%@page import="aca.cont.ContCcosto"%>
<%@page import="aca.cont.ContAuxiliar"%>
<%@page import="aca.cont.ContTipo"%>

<jsp:useBean id="contCcosto" scope="page" class="aca.cont.ContCcosto"/>
<jsp:useBean id="contCcostoL" scope="page" class="aca.cont.ContCcostoLista"/>
<jsp:useBean id="contAuxiliar" scope="page" class="aca.cont.ContAuxiliar"/>
<jsp:useBean id="contAuxiliarL" scope="page" class="aca.cont.ContAuxiliarLista"/>
<jsp:useBean id="contMayor" scope="page" class="aca.cont.ContMayor"/>
<jsp:useBean id="contMayorL" scope="page" class="aca.cont.ContMayorLista"/>
<jsp:useBean id="contRelacion" scope="page" class="aca.cont.ContRelacion"/>
<jsp:useBean id="contTipo" scope="page" class="aca.cont.ContTipo"/>
<jsp:useBean id="contTipoL" scope="page" class="aca.cont.ContTipoLista"/>
<%

	String ccostoId						= request.getParameter("ccostoId");
	String respuesta					= "";
	
	
	int accion							= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	ArrayList<ContCcosto> lisCcosto		= contCcostoL.getListCentros(conElias, "ORDER BY CCOSTO_ID");
	ArrayList<ContMayor> lisMayor 			= null;
	ArrayList<ContAuxiliar> lisAuxiliar	= contAuxiliarL.getListAll(conElias, "WHERE AUXILIAR_ID LIKE '"+ccostoId.subSequence(1,3)+"%' ORDER BY TIPO_ID, AUXILIAR_ID");
	ArrayList<ContTipo> lisTipo			= contTipoL.getListAll(conElias, "ORDER BY TIPO_ID");
	
	if(ccostoId == null && lisCcosto.size() > 0)
		ccostoId = ((ContCcosto)lisCcosto.get(0)).getCcostoId();
	
	if(ccostoId.charAt(ccostoId.length()-1) == '0')
		lisMayor = contMayorL.getListTipo(conElias, "B", "ORDER BY MAYOR_ID");
	else
		lisMayor = contMayorL.getListTipo(conElias, "R", "ORDER BY MAYOR_ID");

	switch(accion){
		case 2:{//Grabar
			int errores = 0, grabados = 0;
			String grabadosTexto = "<tr><td><font color=blue size=2><b>Cuentas grabadas:</b></font></td></tr>";
			String erroresTexto = "<tr><td><font color=red size=2><b>Errores al grabar:</b></font></td></tr>";
			contCcosto.mapeaRegId(conElias, ccostoId);
			contRelacion.setCcostoId(ccostoId);
			for(int i = 0; i < lisMayor.size(); i++){
				contMayor = (ContMayor) lisMayor.get(i);
				String mayorId = request.getParameter("mayor-"+contMayor.getMayorId());
				System.out.println("mayor-"+contMayor.getMayorId()+"  =  "+mayorId);
				if(mayorId != null){
					contRelacion.setMayorId(mayorId);
					contRelacion.setAuxiliarId("0000000000");
					contRelacion.setNombre(contCcosto.getNombre()+" | "+contMayor.getMayorNombre());
					contRelacion.setEstado("A");
					contRelacion.setNaturaleza(contMayor.getNaturaleza());
					contRelacion.setTipoCta(contMayor.getTipoCta());
					if(!contRelacion.existeReg(conElias)){
						if(contRelacion.insertReg(conElias)){
							grabados++;
							grabadosTexto += "<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;<font color=blue>La cuenta <b>\""+contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+"\"</b> fu&eacute; creada exitosamente</font></td></tr>";
						}else{
							errores++;
							erroresTexto += "<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>La cuenta <b>\""+contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+"\"</b> no pudo ser creada. Int&eacute;ntelo de nuevo</font></td></tr>";
						}
					}else{
						errores++;
						respuesta += "<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;<font color=orange>La cuenta <b>\""+contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+"\"</b> ya existe y no pudo ser creada</font></td></tr>";
					}
					for(int k = 0; k < lisTipo.size(); k++){
						contTipo = (ContTipo) lisTipo.get(k);
						String tipo = request.getParameter("tipo-"+contTipo.getTipoId());
						//System.out.println("    tipo-"+contTipo.getTipoId()+"  =  "+tipo);
						if(tipo != null){
							for(int j = 0; j < lisAuxiliar.size(); j++){
								contAuxiliar = (ContAuxiliar) lisAuxiliar.get(j);
								if(contTipo.getTipoId().equals(contAuxiliar.getTipoId())){
									contRelacion.setAuxiliarId(contAuxiliar.getAuxiliarId());
									contRelacion.setNombre(contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+" | "+contAuxiliar.getAuxiliarNombre());
									contRelacion.setEstado("A");
									contRelacion.setNaturaleza(contMayor.getNaturaleza());
									contRelacion.setTipoCta(contMayor.getTipoCta());
									if(!contRelacion.existeReg(conElias)){
										if(contRelacion.insertReg(conElias)){
											grabados++;
											grabadosTexto += "<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=blue>La cuenta <b>\""+contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+" | "+contAuxiliar.getAuxiliarNombre()+"\"</b> fu&eacute; creada exitosamente</font></td></tr>";
										}else{
											errores++;
											erroresTexto += "<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>La cuenta <b>\""+contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+" | "+contAuxiliar.getAuxiliarNombre()+"\"</b> no pudo ser creada. Int&eacute;ntelo de nuevo</font></td></tr>";
										}
									}else{
										errores++;
										respuesta += "<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=orange>La cuenta <b>\""+contCcosto.getNombre()+" | "+contMayor.getMayorNombre()+" | "+contAuxiliar.getAuxiliarNombre()+"\"</b> ya existe y no pudo ser creada</font></td></tr>";
									}
								}
							}
						}
					}
				}
			}
			if(errores > 0){
				respuesta = erroresTexto + respuesta;
			}
			if(grabados > 0){
				respuesta = grabadosTexto + respuesta;
			}
			if(errores > 0){
				respuesta = "<tr><td><font size=2 color=blue>Ocurrieron errores al guardar <font color=red><b>"+errores+"</b></font> cuenta(s)</font></td></tr>" + respuesta;
			}
			if(grabados > 0){
				respuesta = "<tr><td><font size=2 color=blue><b>Se guardaron exitosamente \""+grabados+"\" cuentas</b></font></td></tr>" + respuesta;
			}else{
				respuesta = "<tr><td><font size=2 color=blue><b>No se pudo guardar ninguna cuenta</b></font></td></tr>"+respuesta;
			}
			System.out.println(respuesta);
%>
			<table align="center">
				<%=respuesta %>
			</table>
<%
		}break;
		case 5:{	//Muestra Auxiliares
%>
			$(boton).remove();
			$("mayorBody").firstDescendant().style.width = "100%";
			$("mayorBody").style.width = "50%";

			$("mayorTitle").insert({after: '<td align="center" id="auxiliarTitle"><b>Cuentas Auxiliares</b> <input type="button" value="No Usar Auxiliares" onclick="remueveAuxiliar();" /></td>'});
			
<%
			respuesta =	"<table width=\"100%\">"+
							"<tr>"+
								"<th width=\"20px\"></th>"+
								"<th width=\"50px\">ID</th>"+
								"<th>Nombre</th>"+
							"</tr>"+
							"<tr>"+
								"<td colspan=\"3\">"+
									"<div style=\"width: 100%; height: 350px; overflow: auto;\">"+
										"<table>";
			for(int i = 0; i < lisTipo.size(); i++){
				contTipo = (ContTipo) lisTipo.get(i);
				respuesta +=		"<tr>"+
										"<td width=\"20px\"><input type=\"checkbox\" id=\"tipo-" + i + "\" name=\"tipo-" + contTipo.getTipoId() + "\" value=\"" + contTipo.getTipoId() + "\" /></td>"+
										"<td width=\"50px\" align=\"center\">" + contTipo.getTipoId() + "</td>"+
										"<td>" + contTipo.getTipoNombre() + "</td>"+
									"</tr>";
			}

				respuesta +=			"</table>"+
									"</div>"+
								"</td>"+
							"</tr>"+
							"</table>";
%>
			
			var tdBody = document.createElement('td');
			tdBody.innerHTML = "Otro Buuuu";
			$("mayorBody").insert({after: '<td width="50%" style="border: solid 1px gray;" id="auxiliarBody"><%=respuesta %></td>'});
<%
		}break;
	}
%>
<%@ include file= "../../cierra_elias.jsp" %>