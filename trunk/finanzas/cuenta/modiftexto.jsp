<%@page import="aca.util.Fecha"%>
<%@page import="java.io.*" %>
<%@ page import= "java.io.BufferedReader" %>
<%@ page import= "java.io.FileNotFoundException"  %>
<%@ page import= "java.io.FileReader" %>
<%@ page import= "java.io.IOException" %>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<jsp:useBean id="escuela" scope="page"	class="aca.catalogo.CatEscuela" />
<%
//Sacamos el texto cuano mandamos a grabar
String nuevotexto = request.getParameter("textopersonalizado");

//ubicamos la escuela
String escuelaId 	= (String) session.getAttribute("escuela");

//mapeamos la ecuela para sacar el nombre
escuela.mapeaRegId(conElias, escuelaId.toString());

//leemos el contenido del archivo de texto que contiene el mensaje personalizado
String txtPersonalizado ="";
String archivo = "textopersonalizado.txt";
FileReader f = new FileReader(getServletContext().getRealPath("/")+"finanzas/cuenta/"+archivo);
BufferedReader b = new BufferedReader(f);
String cadena="";
while((cadena = b.readLine())!=null) {
    txtPersonalizado = txtPersonalizado+cadena;
}
b.close();	


//esribimos el nuevo mensaje que mandaron grabar
File ff;
if (nuevotexto!=null && nuevotexto!=""){
	ff = new File(getServletContext().getRealPath("/")+"finanzas/cuenta/"+archivo);
	//Escritura
	try{
		FileWriter w = new FileWriter(ff);
		BufferedWriter bw = new BufferedWriter(w);
		PrintWriter wr = new PrintWriter(bw);  
		wr.write(nuevotexto);//escribimos en el archivo
		//wr.append(" - y aqui continua"); //concatenamos en el archivo sin borrar lo existente
		wr.close();
		bw.close();
	} catch(IOException e){};
	 }
%>
<div id="content">
<center></center><h3><%=escuela.getEscuelaNombre() %></h3></center>
<h2>
	Modificar Texto Personalizado
</h2>
<form name="frmtexto" id="frmtexto" method="post" action="modiftexto.jsp">
<table class="table table-condensed table-bordered table-striped">
<tr><td><textarea id="textopersonalizado" name="textopersonalizado" cols="500" rows="10"><%=txtPersonalizado%></textarea></td></tr>
<tr><td><a class="btn btn-success" onclick="javascript:document.frmtexto.submit();">Modificar texto</a></td></tr>
</table>
</form>
</div>
<%@ include file= "../../cierra_elias.jsp" %>