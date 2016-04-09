<%@page import="sys.views.AllTabColumns"%>
<%@page import="sys.views.AllAllTables"%>
<%@page import="sys.views.AllConsColumns"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../head.jsp" %>
<jsp:useBean id="allTabColumns" scope="page" class="sys.views.AllTabColumns"/>
<jsp:useBean id="allTabColumnsU" scope="page" class="sys.views.AllTabColumnsUtil"/>
<jsp:useBean id="allAllTables" scope="page" class="sys.views.AllAllTables"/>
<jsp:useBean id="allAllTablesU" scope="page" class="sys.views.AllAllTablesUtil"/>
<jsp:useBean id="allConsColumns" scope="page" class="sys.views.AllConsColumns"/>
<jsp:useBean id="allConstraints" scope="page" class="sys.views.AllConstraints"/>
<%
	ArrayList<AllAllTables> lisTables = allAllTablesU.getListAll(conElias, "ORDER BY TABLE_NAME");
	ArrayList<AllTabColumns> lisColumns = null;
%>
<head>
	<style type="text/css">
		div.table{
			//position: absolute;
			//background-color: #fffcad;
			width: auto;
			cursor: default;
		}
		
		div#toolBar{
			position: fixed;
			z-index: 1000;
			top: 0px;
			left: 0px;
			border: solid 1px gray;
			background-color: white;
			visibility: hidden;
		}
		
		div#status{
			position: fixed;
			z-index: 1100;
			top: 0px;
			left: 0px;
		}
		
		table.fields{
			border: solid 1px gray;
			background-color: white;
		}
	</style>
</head>
<body>
<table>
	<tr>
<%
	//Otras tablas user_ind_columns
	String tableName = "";
	String size = "";
	for(int i = 0; i < lisTables.size(); i++){
		allAllTables = (AllAllTables) lisTables.get(i);
		lisColumns = allTabColumnsU.getListTable(conElias, allAllTables.getTableName(), "ORDER BY COLUMN_NAME");
		if(i%2 == 0){
%>
	</tr>
	<tr>
<%
		}
%>
		<td>
			<table>
				<tr>
					<th id="tableName-<%=allAllTables.getTableName() %>"><%=allAllTables.getTableName()%></th>
				</tr>
				<tr>
					<td>
						<table id="columns-<%=allAllTables.getTableName() %>" class="fields">
<%
		for(int j = 0; j < lisColumns.size(); j++){
			allTabColumns = (AllTabColumns) lisColumns.get(j);
%>
							<tr>
<%
			if(allConsColumns.existeReg(conElias, allAllTables.getTableName(), allTabColumns.getColumnName())){
				String tipo = "";
				if(allConstraints.isPK(conElias, allAllTables.getTableName(), allTabColumns.getColumnName())){
					tipo += "<a style='cursor:pointer;' title='"+allConstraints.getConstraintName()+"'>PK</a>";
				}
				if(allConstraints.isFK(conElias, allAllTables.getTableName(), allTabColumns.getColumnName())){
					allConsColumns.mapeaRegId(conElias, allConstraints.getRConstraintName());
					tipo += tipo.equals("")?"":" | ";
					tipo += "<a style='cursor:pointer;' title='"+allConstraints.getConstraintName()+" conecta con la tabla "+allConsColumns.getTableName()+"'>FK</a>";
				}
				if(!allConstraints.getIndexName().equals("")){
					tipo += tipo.equals("")?"":" | ";
					tipo += "<a style='cursor:pointer;' title='"+allConstraints.getIndexName()+"'>I</a>";
				}
				//Es mejor sustituir lo de arriba por condiciones que pregunten si son llave primaria o foranea...
%>
								<td style="border-right: dotted 1px gray;"><%=tipo %></td>
<%
			}else{
%>
								<td>&nbsp;</td>
<%
			}
%>
								<td style="border-right: dotted 1px gray; border-left: dotted 1px gray;"><%=allTabColumns.getColumnName()%></td>
<%
			size = "";
			if(allTabColumns.getDataType().equals("VARCHAR2") || allTabColumns.getDataType().equals("CHAR")){
				size = "(";
				size += allTabColumns.getDataLength();
				size += ")";
			}
			if(allTabColumns.getDataType().equals("NUMBER")){
				size = "(";
				size += allTabColumns.getDataPrecision();
				size += allTabColumns.getDataScale().equals("0")?"":("."+allTabColumns.getDataScale());
				size += ")";
			}
%>
								<td><%=allTabColumns.getDataType()%><%=size %></td>
							</tr>
<%
		}
%>
						</table>
					</td>
				</tr>
			</table>
		</td>
<%
	}
%>
	</tr>
</table>
</body>

<%@ include file= "../../cierra_elias.jsp" %>