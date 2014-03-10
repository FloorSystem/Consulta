<%-- 
    Document   : consultaDefMap
    Created on : 26/03/2012, 11:07:32
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="def" class="ja_jdbc_plpgsql.jdbc.jDefeito"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta Defeitos</title>

        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {packages: ['treemap']});
        </script>
        <script type="text/javascript">
            function drawVisualization() {
                // Create and populate the data table.
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Location');
                data.addColumn('string', 'Parent');
                data.addColumn('number', 'Market trade volume (size)');
                data.addColumn('number', 'Market increase/decrease (color)');
                data.addRows([
                    ["Defeitos",null,0,0],
            ${requestScope.lista2}
            <c:forEach var="bConsultaDef" items="${requestScope.lista}" varStatus="status">
                        ["${bConsultaDef.str_prod} = ${bConsultaDef.cont} = ${bConsultaDef.percent}%","${bConsultaDef.str_def}",${bConsultaDef.percent},${bConsultaDef.percent}],
            </c:forEach>
                    ]);
                    var treemap = new google.visualization.TreeMap(document.getElementById('visualizationMap'));
                    treemap.draw(data, {
                        minColor: '#E0EEE0',
                        midColor: '#5CACEE',
                        maxColor: '#8B0000',
                        headerHeight: 15,
                        fontColor: 'black',
                        showScale: true});
                }
                google.setOnLoadCallback(drawVisualization);
        </script>
    </head>
    <body style="font-family: Arial;border: 0 none;">
        <div id="visualizationMap" style="width: 600px; height: 400px;"></div>
<%--<jsp:include page="consultaServ" flush="true">
    <jsp:param name="acao" value="def"/>
</jsp:include> --%>
    </body>
</html>
