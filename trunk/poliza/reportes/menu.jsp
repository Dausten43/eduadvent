<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<html>

<body>
	<div id="content">
		<h1>Reportes</h1>
		<div class="row-fluid">
          <div class="well well-small">
            <ul class="nav nav-list">
              <li><a href="cierre_caja.jsp"><i class="icon-chevron-right"></i>Cierre de Caja</a></li>
              <li><a href="estado_cuenta.jsp"><i class="icon-chevron-right"></i>Movimientos Por Cuenta</a></li>
              <li><a href="control.jsp"><i class="icon-chevron-right"></i>Control Alumno</a></li>
            </ul>
        </div>
	</div>
	</div>
</body>
</html>
<style>
	body{
		background:white;
	}
</style>
<%@ include file= "../../cierra_elias.jsp" %>