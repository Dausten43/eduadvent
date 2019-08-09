<%@page import="com.google.gson.Gson"%>
<%@ page import="aca.kinder.Criterios"%>
<%@ page import="aca.kinder.Areas"%>
<%@ page import="aca.kinder.UtilCriterios"%>
<%@ page import="aca.kinder.UtilAreas"%>
<%@ page import="aca.conecta.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="application/json" %>
<%@ include file="../../con_elias.jsp"%>
<%
	String cicloId 				= (String) session.getAttribute("cicloId");
	boolean isOk 				= true;
	String areasError 			= "";
	
	UtilCriterios uc 			= new UtilCriterios(conElias);
	UtilAreas ua 				= new UtilAreas(conElias);
	
	List<Criterios> lsCriterios = new ArrayList<Criterios>();
	List<String> lsAreasERR 	= new ArrayList<String>();
	Map<Long, Areas> mpAreas	= new LinkedHashMap<Long, Areas>();
	
	lsCriterios.addAll(uc.getLsCriterios(0L, "", cicloId, 0L, 1));
	mpAreas.putAll(ua.getMapAreas(0L, "", cicloId, 1));
	
	for(Criterios cr: lsCriterios){
		if(cr.getCriterio().replaceAll("\\s+","").equals("")){
			isOk = false;
			lsAreasERR.add(mpAreas.get(cr.getArea_id()).getArea());
		}
	}
	
	areasError = new Gson().toJson(lsAreasERR);
	
	response.setContentType("application/json");
	response.setHeader("Content-Disposition", "inline");
%>
	{
		"isOk":<%=isOk%>,
		"areasError":<%=areasError%>
	}
<%@ include file="../../cierra_elias.jsp"%>