<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<%@ include file= "../../head.jsp" %>
<%@page import="aca.alumno.AlumPadres"%>

<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>

<html>
<head>
<script type="text/javascript" src="jquery-1.5.2.min.js"></script>
<script>
$(document).ready(function() {
	
    $(".tabs .tab[id^=tab_menu]").hover(function() {
        var curMenu=$(this);
        $(".tabs .tab[id^=tab_menu]").removeClass("selected");
        curMenu.addClass("selected");
        
		
		
        var index=curMenu.attr("id").split("tab_menu_")[1];
        $(".curvedContainer .tabcontent").css("display","none");
        $(".curvedContainer #tab_content_"+index).css("display","block");
    });
});

function refresca(codigo){
    document.location = "hijos.jsp?Accion=1&codigo="+codigo;
}

function cargarDatos(){//Activa la pestania de Datos
	$(".tabs .tab[id^=tab_menu_1]").removeClass("selected");
	$(".tabs .tab[id^=tab_menu_2]").addClass("selected");
	
	$(".curvedContainer .tabcontent").css("display","none");
    $(".curvedContainer #tab_content_2").css("display","block");
    
}
	
</script>
<style>
div.tabscontainer{
    margin:15px 0px;
}

div.tabscontainer div.tabs{
    list-style: none;
    width: 130px;
    cursor: pointer;
    float:left;
    margin-top: 10px;
    left: 0px;
    z-index: 2;
}

div.tabscontainer div.curvedContainer{
	margin-left: 132px;
	border:1px solid #7c7c77;
	min-height:327px;
	-moz-border-radius: 13px;
	border-radius: 13px;
}

div.tabscontainer div.curvedContainer.tabcontent{
	display:none;
	padding:20px;
	font-size:20px;
	font-family: "CenturyGothicRegular", "Century Gothic", Arial, Helvetica, sans-serif;
}

div.tabs div.tab{
    display: block;
    height: 50px;
    width: 130px;
    background: url(tabs.png) repeat-x;    
    border: #d6d6d2 solid 1px;
    border-top: none;
    position: relative;
   	color: #73736b;
}

div.tabs div.link{
	padding-left: 20px;
	padding-top:13px;
	font-family: "CenturyGothicRegular", "Century Gothic", Arial, Helvetica, sans-serif;
    font-size: 16px;
    color: #484B3F;
}

div.tabs div.tab.selected{
    color: #ffffff;
    border-right-color: #aeaeaa;
}

div.tabs div.tab.selected{
    background: url(tabsSelected.png) repeat-x;
    border-right-color: #7c7c77;
}

div.tabs div.tab.first{
	border-top: #dbdbb7 solid 1px;
	-moz-border-radius-topleft: 13px;
	border-top-left-radius: 13px;
}

div.tabs div.tab.last{
	-moz-border-radius-bottomleft: 13px;
	border-bottom-left-radius: 13px;
}

div.tabs div.tab div.arrow{
    position: absolute;
    background: url(homeSelArrow.png) no-repeat;
    height: 58px;
    width: 17px;
    left: 100%;
    top: 0px;
    display: none;
}

div.tabs div.tab.selected div.arrow{
    display: block;
}

</style>
</head>
<%
	String escuelaId	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");
	String accion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");

	ArrayList<aca.alumno.AlumPadres> lisAlumPadres = alumPadresLista.getListTutor(conElias, codigoId, "ORDER BY 1");
	
	boolean activar = false;	
	
	if(accion.equals("1")){
		session.setAttribute("codigoAlumno",request.getParameter("codigo"));
		activar=true;
		//out.print("<script>parent.tabs.location.href='menuPortal.jsp?ac=2';document.location.href = 'cambiaPortal.jsp?pagina=datos.jsp';</script>");
	}
%>
<body <%if(activar){%>onload="cargarDatos()"<%} %> >
<!-- ----------------------------------TABS------------------------------------------------------------------------------------ -->
 <div class="tabscontainer" >
     <div class="tabs"  >

         <div class="tab selected first" id="tab_menu_1">
             <div class="link">Hijos</div>
             <div class="arrow"></div>
         </div>
         <%
			alumPersonal.setCodigoId((String)session.getAttribute("codigoAlumno"));
			if(alumPersonal.existeReg(conElias)){
		%>
         <div class="tab" id="tab_menu_2">
             <div class="link">Datos</div>
             <div class="arrow"></div>
         </div>

          <div class="tab" id="tab_menu_3">
             <div class="link">Materias</div>
             <div class="arrow"></div>
         </div>
         <div class="tab" id="tab_menu_4">
             <div class="link">Notas</div>
             <div class="arrow"></div>
         </div>
         <div class="tab" id="tab_menu_5">
             <div class="link">Disciplina</div>
             <div class="arrow"></div>
         </div>
         <div class="tab last" id="tab_menu_6">
             <div class="link">Finanzas</div>
             <div class="arrow"></div>
         </div>
         <%} %>
    </div>
<!-- ----------------------------------HIJOS------------------------------------------------------------------------------------ -->
	<div class="curvedContainer">
		<div class="tabcontent" id="tab_content_1" style="display:block">
			<table width="50%" align="center" class="tabla">
			  <tr><th>Alumno (s)</th></tr>
			<%
				for(int i = 0; i < lisAlumPadres.size(); i++){
					alumPadres = (AlumPadres) lisAlumPadres.get(i);
					alumPersonal.mapeaRegId(conElias, alumPadres.getCodigoId());
			%>
				<tr onclick="javascript:refresca('<%=alumPersonal.getCodigoId()%>');" style="cursor: pointer;" onmouseover="this.style.backgroundColor = '#C8D4A3';" onmouseout="this.style.backgroundColor = '';">
					<td align="center"><%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %></td>
				</tr>
			<%
				}
			%>
			</table>
		</div>
		<div class="tabcontent" id="tab_content_2">
			<P ALIGN=center><iframe  id="iframe2" width="100%" height="450px" src="datos.jsp"
			 frameborder="0" target="_self"></iframe></P>	
		</div>
		<div class="tabcontent" id="tab_content_3">
			<P ALIGN=center><iframe  id="iframe3" width="100%" height="680px" src="materias.jsp"
			 frameborder="0" target="_self"></iframe></P>
		</div>
		<div class="tabcontent" id="tab_content_4">
			<P ALIGN=center><iframe id="iframe4" width="100%" height="500px" src="notas.jsp"
			 frameborder="0" target="_self" ></iframe></P>
		</div>
		<div class="tabcontent" id="tab_content_5">
			<P ALIGN=center><iframe id="iframe5" name="iframe5"  src="disciplina.jsp" width="100%" height="450px" frameborder="0"></iframe></P>
		</div>
		<div class="tabcontent" id="tab_content_6">
			<P ALIGN=center><iframe id="iframe6" width="100%" height="450px" src="finanzas.jsp"
			 frameborder="0" target="_self" ></iframe></P>
		</div>
	</div>
</div>
</body>
</html>
<%@ include file= "../../cierra_elias.jsp" %>