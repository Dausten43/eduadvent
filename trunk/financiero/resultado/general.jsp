<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="aca.cont.ContMayor"%>

<jsp:useBean id="contMascara" scope="page" class="aca.cont.ContMascara"/>
<jsp:useBean id="contMayor" scope="page" class="aca.cont.ContMayor"/>
<jsp:useBean id="contMayorL" scope="page" class="aca.cont.ContMayorLista"/>
<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("#,###,###,##0.00;-#,###,###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String ejercicioId	= request.getParameter("ejercicioId");
	String wildcard		= "";
	String identacion	= "";
	
	int nivel			= Integer.parseInt(request.getParameter("nivel"));
	int nivelCta		= 0;
	int mascaraLength	= 0;
	
	float sumNivel[]	= {0F, 0F, 0F, 0F};
	
	ArrayList<ContMayor> lisMayor = null;
	contMascara.mapeaRegId(conElias, "1");
	
	for(int i = 0; i < contMascara.getMascResultado().length(); i++){
		if(i >= nivel){//Esto es para obtener los 0's de la wildcard
			for(int j = 0; j < Integer.parseInt(contMascara.getMascResultado().substring(i,i+1)); j++){
				wildcard += "0";
			}
		}else{//Esto es para obtener el tamaño de la mascara (lo anterior a los 0's)
			mascaraLength += Integer.parseInt(contMascara.getMascResultado().substring(i,i+1));
		}
	}
	
	lisMayor	= contMayorL.getListResultado(conElias, ejercicioId, String.valueOf(mascaraLength), wildcard, "ORDER BY MAYOR_ID");
	//System.out.println("contMayorL.getListBalance(conElias, "+ejercicioId+", "+String.valueOf(mascaraLength)+", "+wildcard+", \"ORDER BY MAYOR_ID\")");
%>
<table align="center" width="95%">
	<tr>
		<td><a href="elegir.jsp?ejercicioId=<%=ejercicioId %>">&lsaquo;&lsaquo; Regresar</a></td>
	</tr>
	<tr>
		<td class="titulo">Resultado General</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<table align="center" width="90%">
	<tr>
		<th>Descripcion</th>
<%
	for(int i = 0; i < nivel; i++){
%>
		<th>&nbsp;</th>
<%
	}
%>
	</tr>
<%
	int tmpNivelCta = 0;
	for(int i = 0; i < lisMayor.size(); i++){
		contMayor = (ContMayor) lisMayor.get(i);
		if (Integer.parseInt(contMayor.getMayorId().substring(2,4))>0){
			nivelCta = 3;
			identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		}else if(Integer.parseInt(contMayor.getMayorId().substring(1,2)) > 0){
			nivelCta = 2;
			identacion = "&nbsp;&nbsp;&nbsp;";
		}else{ 
			nivelCta = 1;
		}
		if(nivelCta < tmpNivelCta){//Esto es solo para desplegar los totales
			int nivelDelTotal = tmpNivelCta;
			for(int j = 0; j < (tmpNivelCta-nivelCta); j++){
				nivelDelTotal--;
				
				switch(nivelDelTotal){
					case 1: identacion = ""; break;
					case 2: identacion = "&nbsp;&nbsp;&nbsp;"; break;
					case 3: identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
					case 4: identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
				}
%>
		<tr>
			<td><b><%=identacion %>Total</b></td>
<%
				for(int k = nivel; k > 0; k--){
					if(k+1 == nivelDelTotal+1){
%>
		<td width="10%" align="right" style="border-top: solid 1px black;"><b><%=getformato.format(sumNivel[nivelDelTotal])%></b></td>
<%
						sumNivel[nivelDelTotal] = 0;
					}else{
%>
		<td width="10%">&nbsp;</td>
<%
					}
				}
%>
		</tr>
<%
			}
		}
		tmpNivelCta = nivelCta;
		if(nivelCta == 1 || nivelCta == 2){
%>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
<%
		}
%>
	<tr <%=i%2!=0?strColor:"" %>>
		<td><%=identacion %><%=contMayor.getMayorNombre() %></td>
<%
		for(int j = nivel; j > 0; j--){
			sumNivel[j-1] += Float.parseFloat(contMayor.getDetalle());
			if(j == nivelCta && !contMayor.getDetalle().trim().equals("0.00")){
%>
		<td width="10%" align="right"><%=getformato.format(Float.parseFloat(contMayor.getDetalle()))%></td>
<%
			}else{
%>
		<td width="10%">&nbsp;</td>
<%
			}
		}
%>
	</tr>
<%
	}
	nivelCta = 1;
	if(nivelCta < tmpNivelCta){//Esto es solo para desplegar los totales
		int nivelDelTotal = tmpNivelCta;
		for(int j = 0; j < (tmpNivelCta-nivelCta); j++){
			nivelDelTotal--;
			
			switch(nivelDelTotal){
				case 1: identacion = ""; break;
				case 2: identacion = "&nbsp;&nbsp;&nbsp;"; break;
				case 3: identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
				case 4: identacion = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			}
%>
		<tr>
			<td><b><%=identacion %>Total</b></td>
<%
			for(int k = nivel; k > 0; k--){
				if(k+1 == nivelDelTotal+1){
%>
		<td width="10%" align="right" style="border-top: solid 1px black;"><b><%=getformato.format(sumNivel[nivelDelTotal])%></b></td>
<%
					sumNivel[nivelDelTotal] = 0;
				}else{
%>
		<td width="10%">&nbsp;</td>
<%
				}
			}
%>
		</tr>
<%
		}
	}
%>
</table>
<br>
<table align="center">
	<tr>
		<td><b>Fin del Listado</b></td>
	</tr>
</table>
<%@ include file= "../../cierra_elias.jsp" %>