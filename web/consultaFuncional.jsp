<%-- 
    Document   : consulta1
    Created on : 13/12/2011, 08:36:08
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>

        <title>
            Grafico
        </title>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {packages: ['corechart']});
        </script>
        <script type="text/javascript">
            
            //parent.evento = "recarrega";
            //setTimeout(function(){             location.reload();            }, 3010); 
             
            function SelectElement(valueToSelect)
            {    
                var element = document.getElementById('imput_prod1');
                element.value = valueToSelect;
            }
            
            function drawVisualization() {
                // Create and populate the data table. 
                var data = new google.visualization.DataTable();
                var raw_data = [
            <c:forEach var="bConsulta" items="${requestScope.lista}" varStatus="status">
                        ['${bConsulta.dia}', ${bConsulta.yield}]
                <c:choose>
                    <c:when test="${status.last}"></c:when>
                    <c:otherwise> , </c:otherwise>
                </c:choose>
            </c:forEach>
                        
                    ];
        
                    var years = ["${param.imput_prod1}"];
                        
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
                    {title:"Yeld Funcional ${param.imput_prod1} - ${param.data_in}",
                        width:600, height:400,
                        hAxis: {title: " "}}
                );
                }
      

                google.setOnLoadCallback(drawVisualization);
        </script>
    </head>
    <body style="font-family: Arial;border: 0 none;">
        <div id="visualization" style="width: 650px; height: 450px;"></div>
        <pre>Produto&#09;Data&#09;&#09;NOKs&#09;OKs&#09;Yield: (OK*100/(OK+NOK))</pre>    
        <c:forEach var="bConsulta" items="${requestScope.lista}" varStatus="status">
            <pre>${param.imput_prod1}&#09;${bConsulta.dia}&#09;${bConsulta.nok}&#09;${bConsulta.ok}&#09;${bConsulta.yield}%</pre>
            <c:choose>
                <c:when test="${status.last}"> ------------------------------------------------------------------------------------------ </c:when>
            </c:choose>
        </c:forEach>


        <br/>



    </body>
</html>