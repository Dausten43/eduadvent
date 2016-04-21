<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>
  

<div id="content">
<h1>Reportes</h1>
	<div class="row-fluid">
          <div class="well well-small">
            <ul class="nav nav-list">
              <li><a href="reporte.jsp"><i class="icon-chevron-right"></i>Reporte de alumnos inscritos</a></li>
              <li><a href="reporte_deudor.jsp"><i class="icon-chevron-right"></i>Reporte de alumnos Deudores</a></li>
            </ul>
        </div>
	</div>
</div>
<%@ include file= "../../cierra_elias.jsp" %>