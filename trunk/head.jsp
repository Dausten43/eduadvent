<!doctype html>
<%@page errorPage="../../paginaerror.jsp"%>
<%@ include file= "idioma.jsp" %>
<%@page buffer="32kb"%>

<link rel="stylesheet" href="../../bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" href="../../bootstrap/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" href="../../css/style.css" />
<link rel="stylesheet" href="../../css/print.css" type="text/css" media="print" />

<meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- needed for mobile devices -->

<script src="../../js/jquery-1.9.1.min.js"></script>
<script src="../../bootstrap/js/bootstrap.js"></script>

<link rel="shortcut icon" href="../../imagenes/icoEs.png">
<title>Sistema Escolar</title>


<%
	
	// Sube a sesión el idJsp
	if ( !idJsp.equals("0") ){
		session.setAttribute("idJsp", idJsp);		
	}
	
%>



<script src="../../js/onlyNumbers.js"></script>
<script>
	(function($){
		$('document').ready(function(){
			$('*[title]').tooltip({
				container: 'body'
			});
		});
	})(jQuery);
</script>