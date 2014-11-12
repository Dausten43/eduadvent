<%@page import="sys.views.AllConsColumnsUtil"%>
<%@page import="sys.views.AllConsColumns"%>
<%@ include file= "../../con_elias.jsp" %><%
	int accion		= Integer.parseInt(request.getParameter("Accion"));
	
	switch(accion){
		case 5:{//Obtiene las tablas (padres) con las que se relaciona
			String tableName	= request.getParameter("tableName");
			
			AllConsColumns allConsColumns = null;
			AllConsColumnsUtil allConsColumnsU = new AllConsColumnsUtil();
			ArrayList<AllConsColumns> lisParents = allConsColumnsU.getListParents(conElias, tableName, "");
			if(lisParents.size() > 0){
%>
	var tmpDiv = $("table-<%=tableName %>");
	var tmpLista = "Llave(s) foranea(s) de: ";
	tmpDiv.parents = <%=lisParents.size() %>;
<%
				for(int i = 0; i < lisParents.size(); i++){
					allConsColumns = (AllConsColumns) lisParents.get(i);
%>
	tmpDiv.parent<%=i %> = "<%=allConsColumns.getTableName() %>";
	tmpLista += "[<%=allConsColumns.getTableName() %>] ";
<%
				}
%>
	tmpDiv.title = tmpLista;
<%
			}
		}break;
	}
%>
<%@ include file= "../../cierra_elias.jsp" %>