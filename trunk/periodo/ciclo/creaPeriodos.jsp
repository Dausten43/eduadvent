<%@page import="aca.preescolar.UtilPreescolar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%

UtilPreescolar up = new UtilPreescolar();
if(request.getParameter("promedio_id")==null){
	System.out.println("entra 1");
	up.generaTrimestres(request.getParameter("cicloId"));
}else{
	System.out.println("entra 2");
	up.generaTrimestres(request.getParameter("cicloId"), new Integer(request.getParameter("promedio_id")));
}

up.close();
%>
<h2 style="text-align: center;">OPERACION REALIZADA</h2>
<button  style="text-align: center;" name="Quit" id="Quit" value="Quit" onclick="return quitBox('quit');" style="font-size: 10px;">CERRAR</button>
<script type="text/javascript">
function quitBox(cmd)
{   
    if (cmd=='quit')
    {
        open(location, '_self').close();
    }   
    return false;   
}
</script>
</body>
</html>