
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="aca.ciclo.CicloGrupo"%>
<%@ include file="../../con_elias.jsp"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	if (request.getParameter("ciclo_id") != null) {
			String escuelaId = (String) session.getAttribute("escuela");
			CicloGrupo cg = new CicloGrupo();
			List<CicloGrupo> lsCg = new ArrayList();
			lsCg.addAll(cg.mapClicloGrupo(conElias, request.getParameter("ciclo_id")));

			List<String> lsNivel = new ArrayList();
			List<String> lsGrado = new ArrayList();
			List<String> lsGrupo = new ArrayList();

			for (CicloGrupo cgg : lsCg) {
				if (!lsNivel.contains(cgg.getNivelId()))
					lsNivel.add(cgg.getNivelId());

				if (request.getParameter("nivel_id") != null
						&& cgg.getNivelId().equals(request.getParameter("nivel_id"))) {
					if (!lsGrado.contains(cgg.getGrado()))

						lsGrado.add(cgg.getGrado());
					if (request.getParameter("grado_id") != null
							&& cgg.getGrado().equals(request.getParameter("grado_id"))) {
						if (!lsGrupo.contains(cgg.getGrupo()))
							lsGrupo.add(cgg.getGrupo());
					}
				}
			}

			Collections.sort(lsNivel);
			Collections.sort(lsGrado);
			Collections.sort(lsGrupo);

			if (request.getParameter("ciclo_id") != null && request.getParameter("getniveles") != null) {
%>
<option value="">Elija un nivel...</option>
<%
	for (String nivel : lsNivel) {
%>
<option value="<%=nivel%>"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel)%></option>
<%
	}
			}

			if (request.getParameter("nivel_id") != null && request.getParameter("getgrados") != null) {
%>
<option value="">Elija un grado...</option>
<%
	for (String grado : lsGrado) {
%>
<option value="<%=grado%>"><%= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, request.getParameter("nivel_id"), grado) %></option>
<%
	}
			}

			if (request.getParameter("grado_id") != null && request.getParameter("getgrupos") != null) {
%>
<option value="">Elija un grupo...</option>
<%
	for (String grupo : lsGrupo) {
%>
<option value="<%=grupo%>"><%=grupo%></option>
<%
	}
			}

		}
%>
<%@ include file="../../cierra_elias.jsp"%>