<%@ include file="../../con_elias.jsp"%>

<%

String ciclo = request.getParameter("ciclo_id")!=null ?request.getParameter("ciclo_id") :  "0000"; 

	String comando = "SELECT "
            + " ac.codigo_id, ac.nivel, ac.grado, ac.grupo "
            + ", ap.escuela_id, ap.nombre, ap.apaterno, ap.amaterno , "
            + " ce.escuela_nombre, ce.logo, ne.nivel_nombre "
            + " from alum_ciclo ac"
            + " join alum_personal ap on ap.codigo_id=ac.codigo_id "
            + " join cat_escuela ce on ce.escuela_id=ap.escuela_id "
            + " join cat_nivel_escuela ne on ne.escuela_id=ap.escuela_id and ne.nivel_id=ac.nivel"
            + " where "
            + " ac.codigo_id is not null ";

			if (!ciclo.equals("")) {
			    comando += " and ac.ciclo_id='" + ciclo + "'  ";
			    if (request.getParameter("nivel_id") != null && !request.getParameter("nivel_id").equals("")) {
			
			        comando += " AND ac.nivel=" + request.getParameter("nivel_id") + " ";
			
			        if (request.getParameter("grado_id") != null && !request.getParameter("grado_id").equals("")) {
			
			            comando += " AND ac.grado=" + request.getParameter("grado_id") + " ";
			
			            if (request.getParameter("grupo_id") != null && !request.getParameter("grupo_id").equals("")) {
			
			                comando += " AND ac.grupo='" + request.getParameter("grupo_id") + "' ";
			
			            }
			        }
			    }
			}
			comando += " order by ac.grado,ac.grupo, ap.apaterno ";
			
			//System.out.println("sql " +comando);
			%>
			<table class="table">
				<tr>
					<td>CODIGO</td>
					<td>NOMBRE</td>
					<td>GRADO Y GRUPO</td>
					<td></td>
					<td><input type="checkbox" id="controlaTodos" value="1" checked="checked" onclick="selecciona(this);"></td>
				</tr>
			<%
			

				PreparedStatement pst = conElias.prepareStatement(comando);
				ResultSet rs = pst.executeQuery();
				while(rs.next()){
					%>
					<tr>
						<td><%= rs.getString("codigo_id") %></td>
						<td><%= rs.getString("apaterno") %> <%= rs.getString("amaterno") %>, <%= rs.getString("nombre") %></td>
						<td><%= rs.getString("grado")  %> <%= rs.getString("grupo")  %></td>
						<td><input type="checkbox" class="alumnos" name="matricula" value="<%= rs.getString("codigo_id") %>" checked="checked"> </td>
						<td></td>
					</tr>
					<%
				}
				rs.close();
				pst.close();

			%>
			
			</table>
			<%

%>

<%@ include file="../../cierra_elias.jsp"%>