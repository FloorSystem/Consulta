<%-- 
    Document   : consulta1
    Created on : 13/12/2011, 08:36:08
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>  



        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {packages: ['corechart']});
        </script>
        <script type="text/javascript">
            function drawVisualization() {
                // Create and populate the data table. 
                var data = new google.visualization.DataTable();
                var raw_data = [
            <c:forEach var="bConsultaDef" items="${requestScope.lista}" varStatus="status">
                        [ '${bConsultaDef.str_def}' , ${bConsultaDef.percent}]
                <c:choose>
                    <c:when test="${status.last}"></c:when>
                    <c:otherwise> , </c:otherwise>
                </c:choose>
            </c:forEach>
                        
                    ];
        
                    var years = ["${param.imput_prod}"];
                        
                    data.addColumn('string', 'Year');
                    for (var i = 0; i < raw_data.length; ++i) {
                        data.addColumn('number', raw_data[i][0]);    
                    }
        
                    data.addRows(years.length);
      
                    for (var j = 0; j < years.length; ++j) {    
                        data.setValue(j, 0, years[j].toString());    
                    }
                    for (var i = 0; i  < raw_data.length; ++i) {
                        for (var j = 1; j  < raw_data[i].length; ++j) {
                            data.setValue(j-1, i+1, raw_data[i][j]);    
                        }
                    }
        
                    // Create and draw the visualization.
                    new google.visualization.ColumnChart(document.getElementById('visualization')).
                        draw(data,
                    {title:"${param.imput_prod} - ${param.data_in}",
                        width:600, height:400,
                        hAxis: {title: " "}}
                );
                }
      

                google.setOnLoadCallback(drawVisualization);
        </script>


        <div id="visualization" style="width: 650px; height: 450px;"></div>
        <pre>Data&#09;Contagem&#09;Percentual&#09;Total&#09;Defeito&#09; </pre>
        <c:forEach var="bConsultaDef" items="${requestScope.lista}" varStatus="status">
            <pre>${param.data_in}&#09;&#09;${bConsultaDef.cont}&#09; <f:formatNumber type="number" maxFractionDigits="2" minFractionDigits="2"  value="${bConsultaDef.percent}"/>%&#09;&#09;${bConsultaDef.total}&#09;${bConsultaDef.str_def}&#09;</pre>
            <c:choose>
                <c:when test="${status.last}"> ------------------------------------------------------------------------------------------ </c:when>
            </c:choose>
        </c:forEach>
                
        
        <br/>


