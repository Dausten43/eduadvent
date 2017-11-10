<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="aca.kardex.UtilKrdxAlumObs"%>
<%@page import="aca.kardex.KrdxAlumObs"%>

<%

Connection  conElias 	= new Conectar().conEliasPostgres(); 

UtilKrdxAlumObs uob = new UtilKrdxAlumObs(conElias);

String codigoid = request.getParameter("codigoid")!=null ? request.getParameter("codigoid") : "";
Long id = request.getParameter("id")!=null && !request.getParameter("id").equals("") ? new Long(request.getParameter("id")) : 0L;
String cicloGpoId = request.getParameter("cicloGpoId")!=null ? request.getParameter("cicloGpoId") : "";
Integer periodo = request.getParameter("periodo")!=null && !request.getParameter("periodo").equals("") ? new Integer(request.getParameter("periodo")) : 0;
String observacion = request.getParameter("observacion")!=null ? request.getParameter("observacion") : "";
String observacion2 = request.getParameter("observacion2")!=null ? request.getParameter("observacion2") : "";

if(request.getParameter("guardar")!=null){
	
	if(id==0L){
		KrdxAlumObs ob = new KrdxAlumObs(id,cicloGpoId,codigoid,periodo,observacion,observacion2);
		Long salida = uob.addObservacion(ob);
		out.println(salida);
	}else{
		uob.updObservaciones(id, observacion, observacion2);
		out.println(id);	
	}
}

if(request.getParameter("borrar")!=null){
	uob.delObservaciones(id);
}


conElias.close();
%>
