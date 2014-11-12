<!-- bootstrap -->
  
  <link rel="stylesheet" href="../../bootstrap/css/bootstrap.min.css" type="text/css" media="screen" />
  <script type="text/javascript" src="../../js/jquery-1.7.1.min.js"></script>
  
<jsp:useBean id="colorAlum" scope="page" class="aca.portal.Alumno"/>
  
<!-- end bootstrap -->

<style>
	body{
		background:#fff;
		font-size: 8pt;
	}
	
	TABLE  {
		font-size: 7pt;
	}
	TABLE.tabla  {
		font-size: 7pt;
	}
	.encabezado{
		font-size:10px;
	}
	.encabezado2{
		font-size:12px;
	}
	td {
		font-size: 7pt;
		font-size:11px;
	}
	.encabezadoV {
		font-size: 7pt;
		font-size:11px;
	}
	th2 {
		font-size: 7pt;
		font-size:11px;
	}
	TH{
		font-size: 7pt;
	}
	
	.table th{
		color: <%=((String)session.getAttribute("colorUsuario")).equals("default")?"#66A600":(String)session.getAttribute("colorUsuario")%>;
	}
</style>


<style>
<%
	String currentColor = ((String)session.getAttribute("colorUsuario")).equals("default")?"#66A600":(String)session.getAttribute("colorUsuario");

	out.print(".nav a{color:"+currentColor+";}.nav a:hover{color:"+currentColor+";}");
	
%>
</style>

<ul class="nav nav-tabs" style="margin-bottom:0;background: #E6E6E6;">
  <li class="grafica oculto"><a href="grafica.jsp">Gráfica</a></li>
  
</ul>
