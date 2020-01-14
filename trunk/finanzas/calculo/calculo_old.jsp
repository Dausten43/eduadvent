<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.ciclo.CicloPeriodo"%>
<%@page import="aca.beca.BecAlumno"%>
<%@page import="aca.fin.FinPago"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.fin.FinMovimiento"%>
<%@page import="aca.util.Fecha"%>
<%@page import="aca.kardex.KrdxCursoAct"%>

<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="Kardex" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="AlumCiclo" scope="page" class="aca.alumno.AlumCiclo"/>
<jsp:useBean id="finCalculo" scope="page" class="aca.fin.FinCalculo"/>
<jsp:useBean id="finCalculoDet" scope="page" class="aca.fin.FinCalculoDet"/>
<jsp:useBean id="DetalleL" scope="page" class="aca.fin.FinCalculoDetLista"/>
<jsp:useBean id="cicloPeriodo" scope="page" class="aca.ciclo.CicloPeriodo"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="costo" scope="page" class="aca.fin.FinCosto"/>
<jsp:useBean id="costoL" scope="page" class="aca.fin.FinCostoLista"/>
<jsp:useBean id="pagos" scope="page" class="aca.fin.FinPagoLista"/>

<head>	
	<script type="text/javascript">	
		
		function cambiaCiclo( ){
			document.forma.Accion.value = "1";
			document.forma.submit();
		}
		
		function cambiaPeriodo( ){
			document.forma.Accion.value = "1";
			document.forma.submit();
		}
		function Grabar(){
			document.forma.Accion.value	= "2";
			document.forma.submit();
		}				
		function Borrar(){
			document.forma.Accion.value	= "3";
			document.forma.submit();
		}
		function Calcular(){
			document.forma.Accion.value	= "4";
			document.forma.submit();
		}
		function Formato( periodoId ){
			document.location.href = "formato.jsp?PeriodoId="+periodoId;
		}
		
		function GrabaMovtos( ){
			if (confirm("¿ Estás seguro de grabar los movimientos en el estado de cuenta del alumno ?")){
				document.forma.Accion.value	= "5";
				document.forma.submit();
			}
		}
		
		function BorraMovtos( ){
			if (confirm("¿ Estás seguro de borrar los movimientos en el estado de cuenta del alumno ?")){
				document.forma.Accion.value	= "6";
				document.forma.submit();
			}	
		}
	</script>
</head>
<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String codigoAlumno 	= (String) session.getAttribute("codigoAlumno");
	String nombreAlumno		= "";
	String texto 			= " ";
	
	// Verifica el ciclo que esta seleccionado contra el de la sesión
	String ciclo2 			= request.getParameter("Ciclo")==null?"------":request.getParameter("Ciclo");
	if (!cicloId.equals(ciclo2) && !ciclo2.equals("------")) cicloId = ciclo2;			
	
	String puedeAplicar 	= request.getParameter("aplicar")==null? "no" : "si";
	
	boolean existeAlumno 	= false;
	if (alumno.existeReg(conElias, codigoAlumno)){
		alumno.mapeaRegId(conElias, codigoAlumno);
		nombreAlumno		= alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno();
		existeAlumno = true;
	}
	String fecha 			= request.getParameter("Fecha")==null?aca.util.Fecha.getHoy():request.getParameter("Fecha");
	String planId			= aca.alumno.AlumPlan.getPlanActual(conElias, codigoAlumno);
	String strNivel			= String.valueOf(aca.alumno.AlumPlan.getNivelAlumno(conElias, codigoAlumno));
	String strGrado 		= alumno.getGrado();
	String clasFin			= existeAlumno?alumno.getClasfinId():"0";
	String tipoPago 		= request.getParameter("TipoPago")==null?"C":request.getParameter("TipoPago");
	String pagoInicial		= request.getParameter("PagoInicial")==null?"0":request.getParameter("PagoInicial");
	String strAccion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String periodoId		= request.getParameter("PeriodoId")==null?"1":request.getParameter("PeriodoId");
	int numAccion			= Integer.parseInt(strAccion);
	String numPagos			= "0";
	if (tipoPago.equals("P")){
		numPagos 			= request.getParameter("Pagos")==null?"0":request.getParameter("Pagos");
	}else{
		pagoInicial			= request.getParameter("TotPago");
	}
	
	double impBeca			= 0;
	double impCuenta		= 0;
	double impTotal			= 0;	
	double totBeca			= 0;
	double totCuenta		= 0;
	double totCalculo		= 0;
	double totPago			= 0;
	
	String strResultado = "";
	
	int error=0, j=0, i=0;
	
	boolean calculoCerrado = false;
	
	
	ArrayList lisCiclo	 	= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	ArrayList lisPeriodo 	= cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_PERIODO.F_INICIO");
	ArrayList lisCostos		= costoL.getListCicloPeriodo(conElias, cicloId, periodoId, planId, clasFin, codigoAlumno,"ORDER BY CUENTA_ID");
	ArrayList lisDetalles	= null;
	
	switch (numAccion){
	
		case 1:{
			strResultado = "";
			cicloId = request.getParameter("Ciclo");
			session.setAttribute("cicloId",cicloId);
		}break;
		
		case 2:{
			/********Graba los costos del ciclo escolar ********/
			boolean existeCalculo	= false;
			
			String cuenta 	= "";
			String beca		= "";	
			
			finCalculo.setCicloId(cicloId);
			finCalculo.setPeriodoId(periodoId);
			finCalculo.setCodigoId(codigoAlumno);						
			if (finCalculo.existeReg(conElias)){
				finCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
				finCalculo.setTipoPago(tipoPago);
				finCalculo.setClasFinId(clasFin);
				finCalculo.setFecha(fecha);
				if (finCalculo.updateReg(conElias)){
					existeCalculo = true;
				}				
			}else{
				finCalculo.setClasFinId(clasFin);
				finCalculo.setImporte("0");
				finCalculo.setInscrito("N");
				finCalculo.setPlanId(planId);
				finCalculo.setTipoPago("C");
				finCalculo.setFecha(fecha);
				finCalculo.setFolio( finCalculo.maxReg(conElias, cicloId, periodoId));
				if (finCalculo.insertReg(conElias)){
					existeCalculo = true;
				}
			}
			if (existeCalculo){
				for( j=0;j<lisCostos.size();j++){
					aca.fin.FinCosto costos = (aca.fin.FinCosto) lisCostos.get(j);
					cuenta = request.getParameter("Cuenta-"+costos.getCuentaId())==null?"N":"S";
					if (cuenta.equals("S")){						
						beca 	= request.getParameter("Beca-"+costos.getCuentaId()).length()<1?"0":request.getParameter("Beca-"+costos.getCuentaId());
						finCalculoDet.setCicloId(cicloId);
						finCalculoDet.setPeriodoId(periodoId);
						finCalculoDet.setCodigoId(codigoAlumno);
						finCalculoDet.setCuentaId(costos.getCuentaId());
						finCalculoDet.setBeca(beca);
						finCalculoDet.setFecha(aca.util.Fecha.getHoy());
						finCalculoDet.setImporte(costos.getImporte());
						if (finCalculoDet.insertReg(conElias)){
							conElias.commit();
						}						
					}
				}
			}
			conElias.setAutoCommit(true);
		}break;
		
		case 3:{
			
			/********Borra o quita los costos del ciclo escolar ********/
			boolean borrar	= false;
			String cuenta 	= request.getParameter("CuentaId");
			
			conElias.setAutoCommit(false);
			finCalculoDet.setCicloId(cicloId);
			finCalculoDet.setPeriodoId(periodoId);
			finCalculoDet.setCodigoId(codigoAlumno);
			finCalculoDet.setCuentaId(cuenta);
			if (finCalculoDet.existeReg(conElias)){
				if(finCalculoDet.deleteReg(conElias)){
					borrar = true;					
				}								
			}
			if (borrar){				
				if (aca.fin.FinCalculoDet.getNumDetalles(conElias, cicloId, periodoId, codigoAlumno)==0){			
					finCalculo.setCicloId(cicloId);
					finCalculo.setPeriodoId(periodoId);
					finCalculo.setCodigoId(codigoAlumno);
					if (finCalculo.existeReg(conElias)){
						if (finCalculo.deleteReg(conElias)){
							conElias.commit();							
						}else{
							conElias.rollback();							
						}
					}
				}else{
					conElias.commit();
				}
			}
		}
		break;		
		case 4:{
			/********Calcula el cobro del alumno de acuerdo a los parametros registrados ********/
			strResultado = "";			
			finCalculo.setCicloId(cicloId);
			finCalculo.setPeriodoId(periodoId);
			finCalculo.setCodigoId(codigoAlumno);		
			if (finCalculo.existeReg(conElias)){
				finCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
				finCalculo.setInscrito("C");
				finCalculo.setTipoPago(tipoPago);
				finCalculo.setClasFinId(clasFin);
				finCalculo.setNumPagos(numPagos);
				finCalculo.setPagoInicial(pagoInicial);
				finCalculo.setFecha(fecha);
				if (finCalculo.updateReg(conElias)){
					conElias.commit();
					strResultado = "Modificado..!";
				}
			}
		}break;
		
		case 5:{
			/***********Genera los movimientos en el estado de cuenta********/
			if(puedeAplicar.equals("si")){
				strResultado = "";
				double becaDetalle	= 0; 
				int errorEdoCta = 0;
				finCalculo.setCicloId(cicloId);
				finCalculo.setPeriodoId(periodoId);
				finCalculo.setCodigoId(codigoAlumno);
				if(finCalculo.existeReg(conElias)){
					finCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);				
					lisDetalles		= DetalleL.getListCalDet(conElias, cicloId, periodoId, codigoAlumno,"ORDER BY CUENTA_ID");
					for( j=0;j<lisDetalles.size();j++){
						aca.fin.FinCalculoDet detalle = (aca.fin.FinCalculoDet) lisDetalles.get(j);
						
						aca.fin.FinMovimiento finMovto = new aca.fin.FinMovimiento();
						
						/******Graba el cargo en el estado de cuenta ******/
						finMovto.setCodigoId(detalle.getCodigoId());
						finMovto.setFolio(finMovto.maxReg(conElias, detalle.getCodigoId()));
						finMovto.setDescripcion( aca.fin.FinCuenta.getCuentaNombre(conElias, detalle.getCuentaId()));
						finMovto.setFecha(detalle.getFecha());
						finMovto.setImporte(detalle.getImporte());
						finMovto.setNaturaleza("D");
						finMovto.setReferencia(cicloId+"-"+periodoId);
						
						if (finMovto.insertReg(conElias)){
							conElias.commit();
						}else{
							errorEdoCta++;
						}
						
						/*limpia los datos del bean de movimientos */
						finMovto = new aca.fin.FinMovimiento();
						
						/********** Aplica la beca en el estado de cuenta **********/					
						double beca = Double.parseDouble(detalle.getBeca());	
						if (beca > 0){						
							becaDetalle =  ( Double.parseDouble(detalle.getImporte())* Double.parseDouble(detalle.getBeca())) / 100;
							finMovto.setCodigoId(detalle.getCodigoId());
							finMovto.setFolio(finMovto.maxReg(conElias, detalle.getCodigoId()));
							finMovto.setDescripcion( "Beca: "+aca.fin.FinCuenta.getCuentaNombre(conElias, detalle.getCuentaId()));
							finMovto.setFecha(detalle.getFecha());
							finMovto.setImporte(formato.format(becaDetalle).replace(",",""));
							finMovto.setNaturaleza("C");
							finMovto.setReferencia(cicloId+"-"+periodoId);
							if (finMovto.insertReg(conElias)){
								conElias.commit();
							}else{
								errorEdoCta++;
							}
						}
					}
					if (finCalculo.getTipoPago().equals("P")){
						double enPagos = Double.parseDouble(request.getParameter("TotPago")) - Double.parseDouble(finCalculo.getPagoInicial());
						aca.fin.FinMovimiento finMovto = new aca.fin.FinMovimiento();
						finMovto.setCodigoId(codigoAlumno);
						finMovto.setFolio(finMovto.maxReg(conElias, codigoAlumno));
						finMovto.setDescripcion("Crédito Otorgado");
						finMovto.setFecha(aca.util.Fecha.getHoy());
						finMovto.setImporte( formato.format(enPagos).replace(",",""));
						finMovto.setNaturaleza("C");
						finMovto.setReferencia(cicloId+"-"+periodoId);
						if (finMovto.insertReg(conElias)){
							conElias.commit();
						}else{
							errorEdoCta++;
						}
						
						String pago = formato.format( enPagos / Double.parseDouble(finCalculo.getNumPagos())).replace(",","");					
						for( int z=1; z <= Integer.parseInt(finCalculo.getNumPagos());z++){
							
							/*limpia los datos del bean de movimientos */
							finMovto = new aca.fin.FinMovimiento();	
							
							finMovto.setCodigoId(codigoAlumno);
							finMovto.setFolio(finMovto.maxReg(conElias, codigoAlumno));
							finMovto.setDescripcion("Cobro Mensual");
							
							ArrayList<FinPago> listaPagos = pagos.getListCicloPeriodo(conElias, cicloId, periodoId, " ORDER BY FECHA");
							finMovto.setFecha(listaPagos.get(z-1).getFecha());
							//finMovto.setFecha(aca.util.Fecha.getNextFecha(finCalculo.getFecha(), z));
							
							finMovto.setImporte( pago );
							finMovto.setNaturaleza("D");
							finMovto.setReferencia(cicloId+"-"+periodoId);
							if (finMovto.insertReg(conElias)){
								conElias.commit();
							}else{
								errorEdoCta++;
							}
						}
					}
				}
				if (errorEdoCta>0){
					strResultado="¡ Error al guardar los movimientos !, Intentalo nuevamente.";
					aca.fin.FinMovimiento finMovto = new aca.fin.FinMovimiento();
					if (finMovto.deleteMovtosAlumno(conElias, codigoAlumno, cicloId, periodoId)){
						conElias.commit();
					}	
				}else{
					strResultado="¡¡..Los movimientos han sido grabados..!";
				}
			}
			else{%>
				<script>
					alert("Favor de capturar todas las fechas de cobro. Los cambios no han sido guardados")
				</script>	
		<%	}
			
		}break;
		
		case 6:{
			/********Borra los movimietos del estado de cuenta ********/
			strResultado = "";			
			aca.fin.FinMovimiento finMovto = new aca.fin.FinMovimiento();
			if (finMovto.deleteMovtosAlumno(conElias, codigoAlumno, cicloId, periodoId)){
				conElias.commit();
				strResultado="¡¡..Los movimientos han sido borrados..!";
			}	
			
		}break;
		
	}
	
	finCalculo.setCicloId(cicloId);
	finCalculo.setPeriodoId(periodoId);
	finCalculo.setCodigoId(codigoAlumno);						
	if (finCalculo.existeReg(conElias)){
		finCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
		tipoPago = finCalculo.getTipoPago();
	}
	
	lisCostos		= costoL.getListCicloPeriodo(conElias, cicloId, periodoId, planId, clasFin, codigoAlumno,"ORDER BY CUENTA_ID");
	lisDetalles		= DetalleL.getListCalDet(conElias, cicloId, periodoId, codigoAlumno,"ORDER BY CUENTA_ID");
	
	//************* Valida si estan grabados los movimientos.***************
	calculoCerrado 	= aca.fin.FinMovimiento.movtosGrabados(conElias, codigoAlumno, cicloId, periodoId);
%>
<body>
	<div id="content">
		<h2>C&aacute;lculo de Cobro <small><%=nombreAlumno%> ( <%=codigoAlumno%> )</small></h2>		
		<form id="forma" name="forma" action="calculo.jsp" method="post">
			<input type="hidden" name="Accion">
			<div class="well" style="overflow:hidden;" >
				Ciclo:
			   	  <select name="Ciclo" id="Ciclo" onchange='javascript:cambiaCiclo()' style="width:310px;margin-bottom:0px;">
			<%
				for( j=0;j<lisCiclo.size();j++){
					aca.ciclo.Ciclo ciclo = (aca.ciclo.Ciclo) lisCiclo.get(j);
					if (ciclo.getCicloId().equals(cicloId)){
						out.print(" <option value='"+ciclo.getCicloId()+"' Selected>"+ ciclo.getCicloNombre()+"</option>");
					}else{
						out.print(" <option value='"+ciclo.getCicloId()+"'>"+ ciclo.getCicloNombre()+"</option>");
					}
				}
			%>
				  </select>&nbsp;&nbsp;
				  Período:
				  <select name="PeriodoId" id="PeriodoId" onchange='javascript:cambiaPeriodo()' style="margin-bottom:0px;">
			<%
				for( j=0;j<lisPeriodo.size();j++){
					aca.ciclo.CicloPeriodo periodo = (aca.ciclo.CicloPeriodo) lisPeriodo.get(j);
					if (periodo.getPeriodoId().equals(periodoId)){
						out.print(" <option value='"+periodo.getPeriodoId()+"' Selected>"+ periodo.getPeriodoNombre()+"</option>");
					}else{
						out.print(" <option value='"+periodo.getCicloId()+"'>"+ periodo.getPeriodoNombre()+"</option>");
					}
				}
			%>
				  </select>&nbsp;&nbsp; Fecha: 
			      <input name="Fecha" type="text" id="Fecha" value="<%=finCalculo.getFecha()%>"> DD/MM/AAAA
			</div>
			<div class="alert alert-info" align="center">
				<strong>
				Plan: [ <font color='green'><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></font>] -  
				Nivel: [ <font color='green'><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, strNivel)%></font> ] - 
				Grado: [ <font color='green'><%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(strGrado))%></font> ] - 
				Grupo: [ <font color='green'>" <%=alumno.getGrupo()%> "</font> ] - 
				Clas. Fin.: [ <font color='blue'><%=aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, aca.alumno.AlumPersonal.getClasFinId(conElias, codigoAlumno))  %> </font>] -
				Saldo Actual: [ <%=formato.format(aca.fin.FinMovimiento.saldoAlumno(conElias, codigoAlumno, aca.util.Fecha.getHoy()))%>]</strong>				
			</div>
			<br>
			<table align="center" width="97%">
				<tr align="center"><td><strong><%=strResultado%></strong></td></tr>
				<tr>
				  <td width="30%" valign="top">
				    <table align="center" valign="top" class="table table-condensed" width="100%">
				    <tr>
				      <th colspan="5" style="background: none;">Costos del Período</th>
				    </tr>
				    <tr>
				      <th>#</th>
				      <th>Elegir</th>      
				      <th>Cuenta</th>
				      <th>Importe</th>
				      <th>%Beca</th>
				    </tr>
				<%
					for( j=0;j<lisCostos.size();j++){
						aca.fin.FinCosto costos = (aca.fin.FinCosto) lisCostos.get(j);%>
				    <tr>
				      <td align="center"><%= j+1 %></td>
				      <td align="center"><input type="Checkbox" id="Cuenta-<%=costos.getCuentaId()%>" name="Cuenta-<%=costos.getCuentaId()%>" value="S" /></td>      
				      <td><%= aca.fin.FinCuenta.getCuentaNombre(conElias, costos.getCuentaId()) %></td>
				      <td align="right"><%= costos.getImporte() %></td>
				      <td align="center"><input type="text" id="Beca-<%=costos.getCuentaId()%>" name="Beca-<%=costos.getCuentaId()%>" size="5" maxlength="5"/></td>
				    </tr>    		
				<%	}
					if (lisCostos.size()>0){
				%>
					<tr><td align="center" colspan="5"><input type="button" value="Enviar" id="Enviar" class="btn btn-primary" onclick="javascript:Grabar()"></td></tr>
				<% 	}%>	
				</table>
			  </td>
			  <td width="70%">
			    <table align="center" valign="top" class="table table-condensed" width="100%">
			    <tr>
			      <th colspan="7" style="background: none;">Costos Asignados</th>
			    </tr>
			    <tr>
			      <th>#</th>
			      <th>Elegir</th>      
			      <th>Cuenta</th>      
			      <th>Beca %</th>
			      <th>Importe</th>
			      <th>Beca $</th>
			      <th>Total</th>
			    </tr>
			<%	 
				for( j=0;j<lisDetalles.size();j++){ impCuenta = 0; impTotal=0;
					aca.fin.FinCalculoDet detalle = (aca.fin.FinCalculoDet) lisDetalles.get(j);
					
					impCuenta	= Double.parseDouble(detalle.getImporte());
					impBeca 	= (Double.parseDouble(detalle.getImporte())*Double.parseDouble(detalle.getBeca()))/Double.parseDouble("100");	
					impTotal 	=  impCuenta - impBeca;
					
					totBeca 	+= impBeca;
					totCuenta	+= impCuenta;
					totCalculo	+= impTotal;
			%>
					
			    <tr>
			      <td align="center"><%= j+1 %></td>
			      <td align="center">
			        <a href="calculo.jsp?cicloId=<%=cicloId%>&PeriodoId=<%=periodoId%>&CuentaId=<%=detalle.getCuentaId()%>&Accion=3">Quitar</a>
			      </td>
			      <td><%= aca.fin.FinCuenta.getCuentaNombre(conElias, detalle.getCuentaId()) %></td>
			      <td align="center"><%=detalle.getBeca() %></td>
			      <td align="right"><%=formato.format(impCuenta)%></td>
			      <td align="right"><%=formato.format(impBeca)%></td>
			      <td align="right"><%=formato.format(impTotal)%></td>
			    </tr>
			<%	} %>
				<tr>
			      <td align="center" colspan="4" style="color:black;"><b>T o t a l e s . . .</b></td>
			      <td align="right" style="color:black;"><b><%=formato.format(totCuenta)%></b></td>
			      <td align="right" style="color:black;"><b><%=formato.format(totBeca)%></b></td>
			      <td align="right" style="color:black;"><b><%=formato.format(totCalculo)%></b></td>
			    </tr>
			    <tr>
			  	  <td align = "center" colspan="7">Tipo de Pago:&nbsp;
			    	<select name="TipoPago" id="TipoPago">
			          <option value="C" <%if (tipoPago.equals("C")) out.print("Selected");%>> Contado </option>
			          <option value="P" <%if (tipoPago.equals("P")) out.print("Selected");%>> Pagaré </option>
			        </select>
			        &nbsp;&nbsp;
			        Pago Inicial:  $ <input type="text" id="PagoInicial" name="PagoInicial" value="<%=finCalculo.getPagoInicial()%>" size="5" maxlength="7" <%=tipoPago.equals("C")?texto:" "%>/>
			    	&nbsp;&nbsp;
			    	Num. Pagos: <input type="text" id="Pagos" name="Pagos" value="<%=finCalculo.getNumPagos()%>" size="2" maxlength="2" <%=tipoPago.equals("C")?texto:" "%>/>
			    	&nbsp;&nbsp;<br>
			<% 	if(calculoCerrado==false){%>    	
			    	<input class="btn btn-primary" type="button" value="Cálculo" id="Calculo" onclick="javascript:Calcular()">
			<%	} %>    	
			<%	if(finCalculo.getInscrito().equals("C")){	%>
			    	&nbsp;&nbsp;
			    	<input  class="btn" type="button" value="Imprimir" id="Imprimir" onclick="javascript:Formato('<%=periodoId%>')">
			<% 		if (calculoCerrado == false ){%>
			    	&nbsp;&nbsp;    	
			    	<input class="btn" type="button" value="Aplicar" id="Aplicar" onclick="javascript:GrabaMovtos()">
			<% 		}else{ %>
					&nbsp;&nbsp;
			    	<input class="btn" type="button" value="Borrar" id="Borrar" onclick="javascript:BorraMovtos()">
			<% 		}%>    	
			<%	}%>
			  	  </td>
				</tr>
				<tr>	  
				  <td colspan="7" align="center">
				    <table align="center" border="0" cellspacing="0" cellpadding="0" width="40%">
				    <tr>
				      <th>#</th>
				      <th>Descripción</th>
				      <th>Importe</th>
				    </tr>
			<%
				if (tipoPago.equals("C")){
					totPago = totCalculo;
				}else{
					totPago = totCalculo - Double.parseDouble(finCalculo.getPagoInicial());
				}
				
				ArrayList<FinPago> listaPagos = pagos.getListCicloPeriodo(conElias, cicloId, periodoId, " ORDER BY TO_CHAR(FECHA,'YYYY-MM-DD')");
				
				if(Integer.parseInt(finCalculo.getNumPagos()) == listaPagos.size()) puedeAplicar = "s";
				
				for(j=0; j < Integer.parseInt(finCalculo.getNumPagos()); j++){
			%>
					<tr>
					  <td align="center"><%=j+1%></td>
				  	<%  if(j<listaPagos.size()){
				  			FinPago pago = listaPagos.get(j);
				  	%>
					  		<td>&nbsp;&nbsp;<%=pago.getDescripcion()%> - (<%=pago.getFecha()%>)</td>
					<%	}
				  		else%><td>&nbsp;&nbsp;<font color="#AE2113">No capturado</font></td><%
					%>
					  <td align="right"><%= formato.format(totPago / Double.parseDouble(finCalculo.getNumPagos())) %></td>
					</tr>
			<% 	} %>
				    </table>
				  </td>	  
			    </tr>
			    </table>
			  </td>
			<tr/>
			</table>
			<input type="hidden" name="aplicar" value="<%=puedeAplicar%>">
			<input type="hidden" name="TotPago" value="<%=totCalculo%>">
		</form>
	</div>
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>