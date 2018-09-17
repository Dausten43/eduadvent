<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<div id="content">
	<h1><fmt:message key="aca.Reportes" /></h1>
	<div class="row-fluid">
          <div class="well well-small">
            <ul class="nav nav-list">
              <li><a href="calculos.jsp"><i class="icon-chevron-right"></i>Cálculos</a></li>
              <li><a href="reporte.jsp"><i class="icon-chevron-right"></i>Saldos de inscritos</a></li>
              <li><a href="reporte_deudor.jsp"><i class="icon-chevron-right"></i>Alumnos Con Saldo</a></li>
              <li><a href="reporte_deudores_noinscritos.jsp"><i class="icon-chevron-right"></i>Alumnos no Inscritos Con Saldo </a></li>
              <li><a href="cuentas_abono.jsp"><i class="icon-chevron-right"></i>Saldos Cuentas de Abono </a></li>
              <li><a href="estado_cuenta.jsp"><i class="icon-chevron-right"></i>Movimientos Cuentas de Abono</a></li>
            </ul>
        </div>
	</div>
</div>
<%@ include file= "../../cierra_elias.jsp" %>