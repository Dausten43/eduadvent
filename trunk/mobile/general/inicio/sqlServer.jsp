<%@ include file="../../con_sunplus.jsp"%>
<%
	String strEscuela 			= (String)session.getAttribute("escuela");
	String sCodigoPersonal 		= (String)session.getAttribute("codigoId");
	
	Statement stmt				= conSunPlus.createStatement();
	ResultSet rset				= null;	
	String comando				= "";
	
	
%>

<style>
	.table input{
		margin: 0 !important;
	}
</style>

<div id="content">
	
	<h2>Prueba</h2>
	
	<div class="well">
		<a href="index.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
<%	
	comando = "SELECT ACNT_CODE, DESCR FROM ADV_ACNT"; 
	rset = stmt.executeQuery(comando);
	while (rset.next()){	
		out.print("<p>"+rset.getString("ACNT_CODE")+"-"+rset.getString("DESCR")+"</p>");
 	}
%>	
</div>
<%@ include file="../../cierra_sunplus.jsp"%>