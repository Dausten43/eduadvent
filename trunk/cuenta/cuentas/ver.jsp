<%@page import="aca.cont.ContCcosto"%>
<%@page import="aca.cont.ContRelacion"%>
<%@page import="aca.cont.ContMovimiento"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../head.jsp" %>
<jsp:useBean id="contCcosto" scope="page" class="aca.cont.ContCcosto"/>
<jsp:useBean id="contCcostoL" scope="page" class="aca.cont.ContCcostoLista"/>
<jsp:useBean id="contRelacion" scope="page" class="aca.cont.ContRelacion"/>
<jsp:useBean id="contRelacionL" scope="page" class="aca.cont.ContRelacionLista"/>
<%
	String ccostoId						= request.getParameter("ccostoId");	
	String mayorId						= request.getParameter("mayor")==null?"":request.getParameter("mayor");
	String respuesta					= "";
	
	int accion							= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	ArrayList<ContCcosto> lisCcosto		= null;
	ArrayList<ContRelacion> lisRelacion	= null;
		
	lisCcosto		= contCcostoL.getListCentros(conElias, "ORDER BY CCOSTO_ID");
	
	if(ccostoId == null && lisCcosto.size() > 0)
		ccostoId = ((ContCcosto)lisCcosto.get(0)).getCcostoId();
	
	switch(accion){
		case 3:{//Borrar
			contRelacion.setMayorId(request.getParameter("mayorId"));
			contRelacion.setCcostoId(ccostoId);
			contRelacion.setAuxiliarId(request.getParameter("auxiliarId"));
			if(contRelacion.deleteReg(conElias)){
				respuesta = "<font size=3 color=blue><b>¡¡¡Se borr&oacute; correctamente la cuenta!!!</b></font>";
			}else{
				respuesta = "<font size=3 color=red><b>¡Ocurri&oacute; un error al borrar. Int&eacute;ntelo de nuevo!</b></font>";
			}
		}break;
		case 5:{
			contRelacion.mapeaRegId(conElias, request.getParameter("mayorId"), ccostoId, request.getParameter("auxiliarId"));
			contRelacion.setEstado(request.getParameter("estado"));
			if(contRelacion.updateReg(conElias)){
				respuesta = "<font size=3 color=blue><b>¡¡¡Se actualiz&oacute; correctamente la cuenta!!!</b></font>";
			}else{
				respuesta = "<font size=3 color=red><b>¡Ocurri&oacute; un error al actualizar. Int&eacute;ntelo de nuevo!</b></font>";
			}
		}break;
	}
	
	lisRelacion		= contRelacionL.getListCcosto(conElias, ccostoId, mayorId, "ORDER BY MAYOR_ID, AUXILIAR_ID, ESTADO, NATURALEZA, NOMBRE");
%>
<head>
	<script type="text/javascript">
		function borrar(mayorId, auxiliarId){
			if(confirm("¿Está seguro que desea borrar la cuenta \""+mayorId+" | "+auxiliarId+"\"?")){
				document.forma.action += "?Accion=3&mayorId="+mayorId+"&auxiliarId="+auxiliarId;
				document.forma.submit();
			}
		}
		
		function muestraCombo(obj, mayorId, auxiliarId, estado){
			if(obj.innerHTML.indexOf("select") == -1){
				var selects = document.getElementsByTagName("select");
				for(var i = 0; i < selects.length; i++){
					if(selects[i].id == "estado"){
						selects[i].parentNode.innerHTML = (selects[i].value == "A")?"Activa":"Inactiva";
					}
				}
				obj.innerHTML = "<select id=\"estado\" name=\"estado\" onchange=\"cambiaEstado('"+mayorId+"','"+auxiliarId+"');\">"+
									"<option value=\"A\""+((estado == "A")?" Selected":"")+">Activa</option>"+
									"<option value=\"I\""+((estado == "I")?" Selected":"")+">Inactiva</option>"
								"</select>";
			}
		}
		
		function cambiaEstado(mayorId, auxiliarId){
			document.forma.action += "?Accion=5&mayorId="+mayorId+"&auxiliarId="+auxiliarId;
			document.forma.submit();
		}
		
		function verCuentas(){			
			document.forma.submit();
		}
	</script>
</head>
<body>
<table width="77%" align="center">
  <tr><td align="center"><%=respuesta %></td></tr>
  <tr><td align="center" class="titulo">Consulta Cuentas Contables</td></tr>
  <tr><td align="center">&nbsp;</td></tr>
</table>
<form id="forma" name="forma" action="ver.jsp" method="post">
  <table width="50%" align="center" style="border: dotted 1px gray;">
	<tr>
	  <td align="center">
	    Centro de Costo: 
		<select id="ccostoId" name="ccostoId" onchange="document.forma.submit();">
<%
	for(int i = 0; i < lisCcosto.size(); i++){
		contCcosto = (ContCcosto) lisCcosto.get(i);
%>
		  <option value="<%=contCcosto.getCcostoId() %>"<%=contCcosto.getCcostoId().equals(ccostoId)?" Selected":"" %>><%=(contCcosto.getCcostoId().charAt(contCcosto.getCcostoId().length()-1)!='0')?"&nbsp;&nbsp;&nbsp;":"" %><%=contCcosto.getNombre() %></option>
<%	} %>
		</select>
		- Cuenta de Mayor: 
		  <input type="text" id="mayor" name="mayor" size="5" maxlength="7">
		  <input type="submit" value="Ver" id="Ver" onclick="javascript:verCuentas()">
	  </td>
	</tr>	
  </table>
  <table align="center" width="80%">
	<tr>
	  <th width="5%">&nbsp;</th>
	  <th width="5%">#</th>
	  <th width="10%">Mayor</th>
	  <th width="10%">Auxiliar</th>
	  <th width="45%">Nombre</th>
	  <th width="10%">Activo</th>
	  <th width="5%">Naturaleza</th>
	  <th width="10%">Tipo Cta.</th>
	</tr>
<%
	for(int i = 0; i < lisRelacion.size(); i++){
		contRelacion = (ContRelacion) lisRelacion.get(i);
%>
	<tr<%=i%2!=0?(" "+strColor):"" %>>
	  <td align="right">
<%
		if(ContMovimiento.existeRegRelacion(conElias, ccostoId, contRelacion.getMayorId(), contRelacion.getAuxiliarId())){
%>
				&nbsp;
<%
		}else{
%>
		<img src="../../imagenes/no.gif" onclick="borrar('<%=contRelacion.getMayorId() %>','<%=contRelacion.getAuxiliarId() %>');" class="button" />
<%
		}
%>
	  </td>
	  <td align="center"><%=i+1 %></td>
	  <td><%=contRelacion.getMayorId() %></td>
	  <td><%=contRelacion.getAuxiliarId() %></td>
	  <td><%=contRelacion.getNombre() %></td>
	  <td class="input" align="center" onclick="muestraCombo(this, '<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getEstado() %>');">
		<%=contRelacion.getEstado().equals("A")?"Activa":"Inactiva" %>
	  </td>
	  <td align="center"><%=contRelacion.getNaturaleza() %></td>
	  <td align="center"><%=contRelacion.getTipoCta() %></td>
	</tr>
<%
	}
%>
	<tr>
	  <td colspan="7">&nbsp;</td>
	</tr>
	<tr>
	  <td colspan="7" align="center"><b>Fin!!!</b></td>
	</tr>
  </table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>