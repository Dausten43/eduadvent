<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="finReciboLista" scope="page" class="aca.fin.FinReciboLista"/>
<jsp:useBean id="finMovimiento" scope="page" class="aca.fin.FinMovimiento"/><%
	String accion = request.getParameter("Accion");
	if(accion.equals("1")){	//Cargar Buscar Alumno
%>
		<table width="100%">
			<tr>
				<td align="center"><b>Buscar</b></td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>Nombre</td>
							<td><input type="text" id="nombre" size="10" /></td>
							<td>Ap. Paterno</td>
							<td><input type="text" id="paterno" size="10" /></td>
							<td>Ap. Materno</td>
							<td><input type="text" id="materno" size="10" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center"><input type="button" value="Buscar" onclick="buscarAlumno();" /></td>
			</tr>
		</table>
<%
	}else if(accion.equals("2")){	//Buscar Alumno
		String nombre = request.getParameter("nombre");
		String paterno = request.getParameter("paterno");
		String materno = request.getParameter("materno");
		String escuelaId = (String) session.getAttribute("escuela");
		
		if (nombre == null) nombre = "";
		if (paterno== null) paterno = "";
		if (materno== null) materno = "";
%>
		<table width="100%">
			<tr>
				<td align="center"><b>Buscar</b></td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>Nombre</td>
							<td><input type="text" id="nombre" size="10" /></td>
							<td>Ap. Paterno</td>
							<td><input type="text" id="paterno" size="10" /></td>
							<td>Ap. Materno</td>
							<td><input type="text" id="materno" size="10" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center"><input type="button" value="Buscar" onclick="buscarAlumno();" /></td>
			</tr>
<%
		ArrayList lisAlumno = alumnoLista.getArrayList(conElias, escuelaId, nombre, paterno, materno,"ORDER BY 3,4,5");
		if(lisAlumno.size() > 0){
%>
			<tr>
				<td align="center">
					<table>
						<tr>
							<th>Matricula</th>
							<th>Nombre</th>
						</tr>
<%
			for (int i=0; i< lisAlumno.size(); i++){
				alumno = (aca.alumno.AlumPersonal) lisAlumno.get(i);
%>
						<tr onclick="cargaAlumno('<%=alumno.getCodigoId() %>', '<%=alumno.getNombre() %> <%=alumno.getApaterno() %> <%=alumno.getAmaterno() %>');" onmouseover="this.style.backgroundColor='#bcecf7';" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
							<td><%=alumno.getCodigoId() %></td>
							<td><%=alumno.getNombre() %> <%=alumno.getApaterno() %> <%=alumno.getAmaterno() %></td>
						</tr>
<%
			}
%>
					</table>
				</td>
			</tr>
<%
		}else{
%>
			<tr>
				<td align="center"><b>No se encontraron coincidencias.<br />Realice de nuevo la b&uacute;squeda</b></td>
			</tr>
<%
		}
%>
		</table>
<%
	}else if(accion.equals("3")){	//Carga Alumno en Session
		session.setAttribute("codigoId", request.getParameter("codigoId"));
%>
		mensaje('<font style="font: Arial; background-color: #fad163;" size="2"><b>Alumno cargado en sesi&oacute;n!!!</b></font>');
<%
	}else if(accion.equals("4")){	//Muestra los clientes
		ArrayList lisClientes = finReciboLista.getListClientesAlumno(conElias, request.getParameter("codigoId"));
		if(lisClientes.size() > 0){
%>
		<table width="80%">
			<tr>
				<td align="center"><input type="button" value="Cancelar" onclick="cancelaClientes();" /></td>
			</tr>
<%
			for(int i = 0; i < lisClientes.size(); i++){
				finRecibo = (aca.fin.FinRecibo) lisClientes.get(i);
%>
			<tr onclick="cargaCliente('<%=finRecibo.getCliente() %>', '<%=finRecibo.getDomicilio() %>', '<%=finRecibo.getLugar() %>', '<%=finRecibo.getRfc() %>');" onmouseover="this.style.backgroundColor='#bcecf7';" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
				<td><b><i><%=finRecibo.getCliente() %></i></b></td>
			</tr>
<%
			}
%>
		</table>
<%
		}else{
%>
			No existen clientes que correspondan a este alumno
<%
		}
		lisClientes = finReciboLista.getListClientes(conElias, "WHERE CODIGO_ID != '"+request.getParameter("codigoId")+"' ORDER BY CLIENTE");
		if(lisClientes.size() > 0){
%>
		<table>
<%
			for(int i = 0; i < lisClientes.size(); i++){
				finRecibo = (aca.fin.FinRecibo) lisClientes.get(i);
%>
			<tr onclick="cargaCliente('<%=finRecibo.getCliente() %>', '<%=finRecibo.getDomicilio() %>', '<%=finRecibo.getLugar() %>', '<%=finRecibo.getRfc() %>');" onmouseover="this.style.backgroundColor='#bcecf7';" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
				<td><b><%=finRecibo.getCliente() %></b></td>
			</tr>
<%
			}
%>
		</table>
<%
		}else{
%>
			No existen clientes en la BD que no sean de este alumno
<%
		}
	}else if(accion.equals("5")){	//Guarda Recibo
		conElias.setAutoCommit(false);
		String codigoId = request.getParameter("codigoId");
		finRecibo.setReciboId(request.getParameter("reciboId"));
		finRecibo.setImporte(request.getParameter("importe"));
		finRecibo.setFecha(aca.util.Fecha.getHoy());
		finRecibo.setCliente(request.getParameter("cliente"));
		finRecibo.setDomicilio(request.getParameter("domicilio"));
		finRecibo.setLugar(request.getParameter("lugar"));
		finRecibo.setConcepto(request.getParameter("concepto"));
		finRecibo.setCheque(request.getParameter("cheque"));
		finRecibo.setBanco(request.getParameter("banco"));
		finRecibo.setObservaciones(request.getParameter("observaciones"));
		finRecibo.setCodigoId(codigoId);
		finRecibo.setUsuario((String)session.getAttribute("codigoId"));
		finRecibo.setRfc(request.getParameter("rfc"));
		if(finRecibo.insertReg(conElias)){
			if(!codigoId.equals("0000000")){
				finMovimiento.setCodigoId(codigoId);
				finMovimiento.setFolio(aca.fin.FinMovimiento.maxReg(conElias, codigoId));
				finMovimiento.setFecha(finRecibo.getFecha());
				finMovimiento.setDescripcion(finRecibo.getConcepto());
				finMovimiento.setImporte(finRecibo.getImporte());
				finMovimiento.setNaturaleza("C");
				finMovimiento.setReferencia(finRecibo.getReciboId());				
				
				if(finMovimiento.insertReg(conElias)){
					conElias.commit();
%>
	document.location.href = "recibo.jsp?reciboId=<%=finRecibo.getReciboId() %>";
<%
				}else{
					conElias.rollback();
%>
	mensaje('<font style="font: Arial; background-color: #ff0000;" color="white" size="2"><b>Ocurri&oacute; un error al grabar el recibo. Verifique el folio del recibo e int&eacute;ntelo de nuevo!</b></font>');
<%
				}
			}else{
				conElias.commit();
				System.out.println("El recibo fue para el alumno 0000000");
%>
	document.location.href = "recibo.jsp?reciboId=<%=finRecibo.getReciboId() %>";
<%
			}
		}else{
%>
	mensaje('<font style="font: Arial; background-color: #ff0000;" color="white" size="2"><b>Ocurri&oacute; un error al grabar el recibo. Verifique el folio del recibo e int&eacute;ntelo de nuevo!</b></font>');
<%
		}
		conElias.setAutoCommit(true);
	}
%>
<%@ include file= "../../cierra_elias.jsp" %>
