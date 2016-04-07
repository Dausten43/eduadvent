<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="docU" scope="page" class="aca.archivo.ArchDocumentoLista" />
<jsp:useBean id="docNivelU" scope="page" class="aca.archivo.ArchDocNivelLista" />
<jsp:useBean id="docNivel" scope="page" class="aca.archivo.ArchDocNivel" />
<jsp:useBean id="nivelLista" scope="page" class="aca.catalogo.CatNivelLista" />
<jsp:useBean id="CicloL" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="horariocL" scope="page" class="aca.catalogo.CatHorarioCicloLista" />
<jsp:useBean id="horarioC" scope="page" class="aca.catalogo.CatHorarioCiclo" />

<%
	String escuelaId						= (String) session.getAttribute("escuela");
	String folio 							= request.getParameter("folio") == null? "1": request.getParameter("folio");
	String accion 							= request.getParameter("Accion") == null? "0": request.getParameter("Accion");
	String salto							= "X";

	ArrayList<aca.ciclo.Ciclo> cicloEsc 	= CicloL.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	String ciclosEsc						= aca.catalogo.CatHorarioCicloLista.getCiclos(conElias, escuelaId, folio);
	if(ciclosEsc.equals("X")){
		ciclosEsc = "";
	}
	String [] ciclo 						= ciclosEsc.split(",");
	String resultado 						= "";
	String cicloElegido 					= request.getParameter("cicloElegido") == null?"":request.getParameter("cicloElegido");
	if(accion.equals("1")){
		horarioC.setEscuelaId(escuelaId);
		horarioC.setFolio(folio);
		String cicloGuardado;
		if(ciclosEsc.isEmpty()){
			cicloGuardado			= ciclosEsc+"'"+cicloElegido+"',";
			cicloGuardado = cicloGuardado.substring(0, cicloGuardado.length()-1);
		}else{
			cicloGuardado			= ciclosEsc+",'"+cicloElegido+"',";
			cicloGuardado = cicloGuardado.substring(0, cicloGuardado.length()-1);
		}
		horarioC.setCiclos(cicloGuardado);
		if(horarioC.existeCiclo(conElias, escuelaId, folio) == false){
			if (horarioC.insertReg(conElias)) {
				resultado = "Guardado";
			} else {
				resultado = "NoGuardo ";
			}
		} else {
			if (horarioC.updateReg(conElias)) {
				resultado = "Modificado";
			} else {
				resultado = "NoModificado";
			}
		}
		salto = "accion.jsp?folio="+folio;
	}else if (accion.equals("2")){
		horarioC.setEscuelaId(escuelaId);
		horarioC.setFolio(folio);
		ciclosEsc = ciclosEsc.replaceAll("'"+cicloElegido+"',", "");
		ciclosEsc = ciclosEsc.replaceAll("'"+cicloElegido+"'", "");
		horarioC.setCiclos(ciclosEsc);		
		if (horarioC.updateReg(conElias)) {
			resultado = "Modificado";
		} else {
			resultado = "NoModificado";
		}
		salto = "accion.jsp?folio="+folio;
	}else if(accion.equals("3")){
		horarioC.setEscuelaId(escuelaId);
		horarioC.setFolio(folio);
		if(horarioC.deleteReg(conElias)){
			resultado = "Eliminado";
		}else{
			resultado = "NoEliminad";
		}
		salto = "paralelo.jsp";
	}

	
	
	pageContext.setAttribute("resultado", resultado);
%>

<div id="content">

	<h2><fmt:message key="aca.GrupoCiclo" /></h2>
	<div class="well"><a href="paralelo.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> <fmt:message key="boton.Regresar" /></a></div>
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
		
	<div class="row">
		
		<div class="span5">
		
			<table class="table table-condensed table-striped table-bordered">
				<thead>
					<tr>
						<th><fmt:message key="aca.CiclosDisp"/></th>
					</tr>
				</thead>
			<%
				int cont = 0;
				for (aca.ciclo.Ciclo cicloL: cicloEsc) {
					for (String x : ciclo) {
						String cicloComp = x.replaceAll("'", "");
						if (cicloL.getCicloId().equals(cicloComp)) {
							cont = 1;
						}
					}
					
					if (cont == 0) {
			%>
						<tr>
							<td>
								<a href="accion.jsp?Accion=1&cicloElegido=<%=cicloL.getCicloId()%>&escuelaId=<%=escuelaId%>&folio=<%=folio%>"><%=cicloL.getCicloNombre()%></a>
							</td>
						</tr>
			<%
					}
					cont = 0;
				}
			%>
			</table>
		</div>
		
		<div class="span5">
			<table class="table table-condensed table-striped table-bordered">
				<tr>
					<th><fmt:message key="aca.CiclosReq"/></th>
				</tr>
			<%
				for(String y : ciclo){
						String cicloDeEscuela = y.replaceAll("'", "");
						if(cicloDeEscuela.equals("X")){
							cicloDeEscuela = "";
						}
						String nombreCiclo = aca.ciclo.Ciclo.getCicloNombre(conElias, cicloDeEscuela);
						if(nombreCiclo.equals("x")){
							nombreCiclo = "";
						}
			%>
					<tr>
						<td>
							<a href="accion.jsp?Accion=2&cicloElegido=<%=cicloDeEscuela%>&escuelaId=<%=escuelaId%>&folio=<%=folio%>">
								<%=nombreCiclo%>
							</a>
						</td>

					</tr>
			<%
				}
			%>
			</table>	
		</div>
		
	</div>

</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>