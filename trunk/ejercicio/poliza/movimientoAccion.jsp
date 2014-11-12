<%@ include file= "../../con_elias.jsp" %><%

	int accion		= Integer.parseInt(request.getParameter("Accion"));

	switch(accion){
		case 5:{	//Buscar cuentas por id -- Mostrar las cuentas disponibles para el centro de costo
			String ccostoId = request.getParameter("ccostoId");
			String mayorId	= request.getParameter("mayorId");
			aca.cont.ContRelacionLista contRelacionL 	= new aca.cont.ContRelacionLista();
			aca.cont.ContRelacion contRelacion 			= null;
			//System.out.println("ccostoId = "+ccostoId+"; mayorId = "+mayorId+";");
			ArrayList<aca.cont.ContRelacion> lisBalance = contRelacionL.getListTipo(conElias, ccostoId, mayorId, "B", "ORDER BY MAYOR_ID, AUXILIAR_ID");
			ArrayList<aca.cont.ContRelacion> lisResultado = contRelacionL.getListTipo(conElias, ccostoId, mayorId, "R", "ORDER BY MAYOR_ID, AUXILIAR_ID");
%>
			<table>
				<tr id="th">
					<td align="center"><b>Cuentas de Balance</b></td>
					<td align="center" style="border-left: solid 1px gray;"><b>Cuentas de Resultado</b></td>
				</tr>
				<tr>
					<td valign="top">
						<div style="max-height: 300px; overflow: auto;">
							<table>
								<tr id="th">
									<th>ID</th>
									<th>Nombre</th>
								</tr>
<%
			for(int i = 0; i < lisBalance.size(); i++){
				contRelacion = (aca.cont.ContRelacion) lisBalance.get(i);
%>
								<tr onclick="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" id="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" onmouseover="this.style.backgroundColor='#E4F7FA';currentElement=null;" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
									<td><%=contRelacion.getMayorId() %>.<%=contRelacion.getAuxiliarId() %></td>
									<td><%=contRelacion.getNombre() %></td>
								</tr>
<%
			}
%>
							</table>
						</div>
					</td>
					<td valign="top" style="border-left: solid 1px gray;">
						<div style="max-height: 300px; overflow: auto;">
							<table>
								<tr id="th">
									<th>ID</th>
									<th>Nombre</th>
								</tr>
<%
			for(int i = 0; i < lisResultado.size(); i++){
				contRelacion = (aca.cont.ContRelacion) lisResultado.get(i);
%>
								<tr onclick="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" id="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" onmouseover="this.style.backgroundColor='#E4F7FA';currentElement=null;" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
									<td><%=contRelacion.getMayorId() %>.<%=contRelacion.getAuxiliarId() %></td>
									<td><%=contRelacion.getNombre() %></td>
								</tr>
<%
			}
%>
							</table>
						</div>
					</td>
				</tr>
			</table>
<%
		}break;
		case 6:{	//Guardar nuevo movimiento -- Guarda cada movimiento por separado
			String ejercicioId		= request.getParameter("ejercicioId");
			String libroId			= request.getParameter("libroId");
			String polizaId			= request.getParameter("polizaId");
			String descripcion		= request.getParameter("descripcion");
			String importe			= request.getParameter("importe");
			String referencia		= request.getParameter("referencia");
			String mayorId			= request.getParameter("mayorId");
			String ccostoId			= request.getParameter("ccostoId");
			String auxiliarId		= request.getParameter("auxiliarId");
			String naturaleza		= request.getParameter("naturaleza");
			String numMovto			= request.getParameter("numMovto");
			
			aca.cont.ContMovimiento contMovimiento	= new aca.cont.ContMovimiento();
			aca.cont.ContRelacion contRelacion 		= new aca.cont.ContRelacion();
			aca.cont.ContMayor contMayor			= new aca.cont.ContMayor();
			
			contMayor.mapeaRegId(conElias, mayorId);
			
			contMovimiento.setEjercicioId(ejercicioId);
			contMovimiento.setLibroId(libroId);
			contMovimiento.setPolizaId(polizaId);
			//contMovimiento.setNumMovto(contMovimiento.maxReg(conElias, ejercicioId, libroId, polizaId));
			contMovimiento.setFecha(aca.util.Fecha.getHoy());
			contMovimiento.setDescripcion(descripcion);
			contMovimiento.setImporte(importe);
			contMovimiento.setEstado("A");
			contMovimiento.setReferencia(referencia);
			contMovimiento.setMayorId(mayorId);
			contMovimiento.setCcostoId(ccostoId);
			contMovimiento.setAuxiliarId(auxiliarId);
			contMovimiento.setTipoCta(contMayor.getTipoCta());
			contMovimiento.setNaturaleza(naturaleza);
			contMovimiento.setNumMovto(numMovto);
			
			if(!numMovto.equals("")){
				if(contMovimiento.existeReg(conElias)){
					if(contMovimiento.updateReg(conElias)){
%>
						location.href = location.href;
<%
					}else{
%>
						mensaje('<font color="red" size="3">Ocurri&oacute; un error al modificar. Int&eacute;ntelo de nuevo</font>');
<%
					}
				}else{
%>
						mensaje('<font color="orange" size="3"><b>El movimiento no existe.<br>Es posible que alguien mas haya borrado el movimiento.<br>Salga de la poliza y vuelva a entrar para ver los movimientos actuales</b></font>');
<%
				}
			}else{
				contMovimiento.setNumMovto(contMovimiento.maxReg(conElias, ejercicioId, libroId, polizaId));
				if(contMovimiento.insertReg(conElias)){
					contMovimiento.mapeaRegId(conElias);
					contRelacion.mapeaRegMayorId(conElias, contMovimiento.getMayorId(), contMovimiento.getCcostoId(), contMovimiento.getAuxiliarId());
%>
					mensaje('<font color="blue" size="3"><b>Se guard&oacute; correctamente el movimiento!!!</b></font>');
					if(tMensaje)
						clearTimeout(tMensaje);
					tMensaje = setTimeout('mensaje("&nbsp;");',3000);
					
					contMovimientos++;
					contFilas++;
					var respuesta = '<tr'+(contFilas%2==0?' bgcolor = "#dddddd"':'')+' id="'+contMovimientos+'" height="24px">'+
						'<td width="40px" align="center">'+contMovimientos+'</td>'+
						'<td width="255px"><%=contMovimiento.getMayorId() %> - <%=contRelacion.getNombre() %></td>'+
						'<td width="178px"><%=contMovimiento.getDescripcion() %></td>'+
						'<td width="105px"><%=contMovimiento.getReferencia()==null?"":contMovimiento.getReferencia() %></td>'+
						'<td width="80px" align="right"><%=contMovimiento.getNaturaleza().equals("D")?contMovimiento.getImporte():"&nbsp;" %></td>'+
						'<td width="80px" align="right"><%=contMovimiento.getNaturaleza().equals("C")?contMovimiento.getImporte():"&nbsp;" %></td>'+
						'<td width="50px" id="opciones" align="right">'+
							'&nbsp;&nbsp;'+
							'<img src="../../imagenes/edit.gif" onclick="modificarMovimiento(\'<%=contMovimiento.getEjercicioId() %>\', \'<%=contMovimiento.getLibroId() %>\', \'<%=contMovimiento.getPolizaId() %>\', \'<%=contMovimiento.getNumMovto() %>\');" title="Modificar" class="button" />&nbsp;'+
							'<img src="../../imagenes/no.gif" onclick="borrarMovimiento(\'<%=contMovimiento.getEjercicioId() %>\', \'<%=contMovimiento.getLibroId() %>\', \'<%=contMovimiento.getPolizaId() %>\', \'<%=contMovimiento.getNumMovto() %>\', '+contMovimientos+');" title="eliminar" class="button" />'+
						'</td>'+
					'</tr>';
					$('movimientos').insert({bottom: respuesta});
					$("foco").focus();
<%
					if(contMovimiento.getNaturaleza().equals("D")){
%>
						sumD += <%=contMovimiento.getImporte() %>;
						$("sumD").innerHTML = addCommas(sumD.toFixed(2));
<%
					}else{
%>
						sumC += <%=contMovimiento.getImporte() %>;
						$("sumC").innerHTML = addCommas(sumC.toFixed(2));
<%
					}
%>
					if(sumD > sumC){
						$("difD").innerHTML = addCommas((sumD-sumC).toFixed(2));
						$("difC").innerHTML = "-";
					}else if(sumC > sumD){
						$("difC").innerHTML = addCommas((sumC-sumD).toFixed(2));
						$("difD").innerHTML = "-";
					}else if(sumC == sumD){
						$("difD").innerHTML = "-";
						$("difC").innerHTML = "-";
					}
					
					limpiaInputs();
<%
				}else{
%>
					mensaje('<font color="red" size="3">Ocurri&oacute; un error al guardar. Int&eacute;ntelo de nuevo</font>');
<%
				}
			}
		}break;
		case 7:{	//Buscar cuentas por nombre -- Mostrar las cuentas disponibles para el centro de costo
			String ccostoId = request.getParameter("ccostoId");
			String texto	= "%"+request.getParameter("texto").replaceAll(" ", "%")+"%";
			
			aca.cont.ContRelacionLista contRelacionL 	= new aca.cont.ContRelacionLista();
			aca.cont.ContRelacion contRelacion 			= null;
			
			ArrayList<aca.cont.ContRelacion> lisBalance = contRelacionL.getListAll(conElias, "WHERE CCOSTO_ID LIKE '"+ccostoId.substring(0, 3)+"%' AND TIPO_CTA = 'B' AND UPPER(NOMBRE) LIKE UPPER('"+texto+"') ORDER BY MAYOR_ID, AUXILIAR_ID");
			ArrayList<aca.cont.ContRelacion> lisResultado = contRelacionL.getListAll(conElias, "WHERE CCOSTO_ID LIKE '"+ccostoId.substring(0, 3)+"%' AND TIPO_CTA = 'R' AND UPPER(NOMBRE) LIKE UPPER('"+texto+"') ORDER BY MAYOR_ID, AUXILIAR_ID");
%>
			<table>
				<tr id="th">
					<td align="center"><b>Cuentas de Balance</b></td>
					<td align="center" style="border-left: solid 1px gray;"><b>Cuentas de Resultado</b></td>
				</tr>
				<tr>
					<td valign="top">
						<div style="max-height: 300px; overflow: auto;">
							<table>
								<tr id="th">
									<th>ID</th>
									<th>Nombre</th>
								</tr>
<%
			for(int i = 0; i < lisBalance.size(); i++){
				contRelacion = (aca.cont.ContRelacion) lisBalance.get(i);
%>
								<tr onclick="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" id="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" onmouseover="this.style.backgroundColor='#E4F7FA';currentElement=null;" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
									<td><%=contRelacion.getMayorId() %>.<%=contRelacion.getAuxiliarId() %></td>
									<td><%=contRelacion.getNombre() %></td>
								</tr>
<%
			}
%>
							</table>
						</div>
					</td>
					<td valign="top" style="border-left: solid 1px gray;">
						<div style="max-height: 300px; overflow: auto;">
							<table>
								<tr id="th">
									<th>ID</th>
									<th>Nombre</th>
								</tr>
<%
			for(int i = 0; i < lisResultado.size(); i++){
				contRelacion = (aca.cont.ContRelacion) lisResultado.get(i);
%>
								<tr onclick="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" id="cargarCuenta('<%=contRelacion.getMayorId() %>', '<%=contRelacion.getAuxiliarId() %>', '<%=contRelacion.getNombre() %>', '<%=contRelacion.getNaturaleza() %>');" onmouseover="this.style.backgroundColor='#E4F7FA';currentElement=null;" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
									<td><%=contRelacion.getMayorId() %>.<%=contRelacion.getAuxiliarId() %></td>
									<td><%=contRelacion.getNombre() %></td>
								</tr>
<%
			}
%>
							</table>
						</div>
					</td>
				</tr>
			</table>
<%
		}break;
		case 8:{// Poliza terminada (Cambiar el estado a revision)
			String ejercicioId	= request.getParameter("ejercicioId");
			String libroId		= request.getParameter("libroId");
			String polizaId		= request.getParameter("polizaId");
			
			aca.cont.ContPoliza contPoliza = new aca.cont.ContPoliza();
			contPoliza.mapeaRegId(conElias, ejercicioId, libroId, polizaId);

			contPoliza.setEstado("R");
			if(contPoliza.updateReg(conElias)){
%>
				location.href = 'cabecera.jsp';
<%
			}else{
%>
				alert("Ocurrio un error al marcar como terminada la poliza. Intentelo de nuevo");
				$("btnTerminaPoliza").disabled = false;
<%
			}
		}break;
		case 9:{// Cerrar poliza (Cambiar el estado a cerrada)
			String ejercicioId	= request.getParameter("ejercicioId");
			String libroId		= request.getParameter("libroId");
			String polizaId		= request.getParameter("polizaId");
			
			aca.cont.ContPoliza contPoliza = new aca.cont.ContPoliza();
			contPoliza.mapeaRegId(conElias, ejercicioId, libroId, polizaId);

			contPoliza.setEstado("C");
			if(contPoliza.updateReg(conElias)){
%>
				location.href = 'cabecera.jsp';
<%
			}else{
%>
				alert("Ocurrio un error al marcar como terminada la poliza. Intentelo de nuevo");
				$("btnTerminaPoliza").disabled = false;
				$("btnAbrirPoliza").disabled = false;
<%
			}
		}break;
		case 10:{// Abrir poliza (Cambiar el estado a abierta)
			String ejercicioId	= request.getParameter("ejercicioId");
			String libroId		= request.getParameter("libroId");
			String polizaId		= request.getParameter("polizaId");
			
			aca.cont.ContPoliza contPoliza = new aca.cont.ContPoliza();
			contPoliza.mapeaRegId(conElias, ejercicioId, libroId, polizaId);

			contPoliza.setEstado("A");
			if(contPoliza.updateReg(conElias)){
%>
				location.href = 'cabecera.jsp';
<%
			}else{
%>
				alert("Ocurrio un error al marcar como terminada la poliza. Intentelo de nuevo");
				$("btnTerminaPoliza").disabled = false;
				$("btnAbrirPoliza").disabled = false;
<%
			}
		}break;
		case 11:{// Carga movimiento a modificar
			String ejercicioId	= request.getParameter("ejercicioId");
			String libroId		= request.getParameter("libroId");
			String polizaId		= request.getParameter("polizaId");
			String numMovto		= request.getParameter("numMovto");
			
			aca.cont.ContMovimiento contMovimiento = new aca.cont.ContMovimiento();
			contMovimiento.mapeaRegId(conElias, ejercicioId, libroId, polizaId, numMovto);
%>
			$("mayorId").value = "<%=contMovimiento.getMayorId() %>";
			$("auxiliarId").value = "<%=contMovimiento.getAuxiliarId() %>";
			$("cuenta").innerHTML = "<%=aca.cont.ContRelacion.getNombre(conElias, contMovimiento.getMayorId(), contMovimiento.getCcostoId(), contMovimiento.getAuxiliarId()) %>";
			$("descripcion").value = "<%=contMovimiento.getDescripcion() %>";
			$("referencia").value = "<%=contMovimiento.getReferencia() %>";
			$("importe").value = "<%=contMovimiento.getImporte() %>";
			$("importe").focus();
			$("numMovto").value = "<%=numMovto %>";
<%
			if(contMovimiento.getNaturaleza().equals("D")){//Si es cargo
%>
				document.forma.naturaleza[0].checked = "checked";
<%
			}else{//Si es credito
%>
				document.forma.naturaleza[1].checked = "checked";
<%
			}
%>
			$("btnGuardar").value = "Modificar";
<%
		}break;
		case 12:{// Carga movimiento a modificar
			String ejercicioId	= request.getParameter("ejercicioId");
			String libroId		= request.getParameter("libroId");
			String polizaId		= request.getParameter("polizaId");
			String numMovto		= request.getParameter("numMovto");
			String contMovto	= request.getParameter("contMovto");//Contador de la fila del movimiento (sirve para poder eliminarlo de la lista)
			
			aca.cont.ContMovimiento contMovimiento = new aca.cont.ContMovimiento();
			contMovimiento.mapeaRegId(conElias, ejercicioId, libroId, polizaId, numMovto);
			if(contMovimiento.existeReg(conElias)){
				if(contMovimiento.deleteReg(conElias)){
					if(contMovimiento.getNaturaleza().equals("D")){
%>
						sumD -= <%=contMovimiento.getImporte() %>;
						$("sumD").innerHTML = addCommas(sumD.toFixed(2));
<%
					}else{
%>
						sumC -= <%=contMovimiento.getImporte() %>;
						$("sumC").innerHTML = addCommas(sumC.toFixed(2));
<%
					}
%>
					if(sumD > sumC){
						$("difD").innerHTML = addCommas((sumD-sumC).toFixed(2));
						$("difC").innerHTML = "-";
					}else if(sumC > sumD){
						$("difC").innerHTML = addCommas((sumC-sumD).toFixed(2));
						$("difD").innerHTML = "-";
					}else if(sumC == sumD){
						$("difD").innerHTML = "-";
						$("difC").innerHTML = "-";
					}
					
					$("<%=contMovto %>").remove();
					contFilas--;
					mensaje('<font color="blue" size="3">Se borr&oacute; correctamente el movimiento!!!</font>');
<%
				}else{
%>
					mensaje('<font color="red" size="3">Ocurri&oacute; un error al borrar. Int&eacute;ntelo de nuevo</font>');
<%
				}
			}else{
%>
				mensaje('<font color="orange" size="3"><b>El movimiento no existe.<br>Es posible que alguien mas haya borrado el movimiento.<br>Salga de la poliza y vuelva a entrar para ver los movimientos actuales</b></font>');
<%
			}
		}break;
	}
%>
<%@ include file= "../../cierra_elias.jsp" %>