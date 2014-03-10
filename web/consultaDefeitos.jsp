<%-- 
    Document   : consulta1
    Created on : 13/12/2011, 08:36:08
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title>
            Grafico Defeitos
        </title>


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
                    <c:otherwise> <c:out value=","> </c:out>  </c:otherwise>
                </c:choose>
            </c:forEach>
                        
            <c:out value="];"> </c:out>
        
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
                        {title:"Defeitos ${param.imput_prod} - ${param.data_in}",
                            width:600, height:400,
                            hAxis: {title: " "}}
                    );
                    }
      

                    google.setOnLoadCallback(drawVisualization);
        </script>

        <style type="text/css"> 

            table#sample {
                background-color:#FFFFFF;
                border: solid #000 3px;
                width: 400px;
            }
            table#sample td {
                padding: 5px;
                border: solid #000 1px;
            }
            .data {
                color: #000000;
                text-align: right;
                background-color: #CCCCCC;
            }
            .toprow {
                font-style: italic;
                text-align: center;
                background-color: #FFFFCC;
            }
            .leftcol {
                font-weight: bold;
                text-align: left;
                width: 150px;
                background-color: #CCCCCC;
            }
            .centcol{
                text-align: center;
            }
        </style>
    </head>
    <body style="font-family: Arial;border: 0 none;">
        <center> 
            <div id="visualization" style="width: 650px; height: 450px;"></div>

            <table border="0" cellspacing="1">
                <thead>
                    <tr>
                        <th>Data</th>
                        <th>Contagem</th>
                        <th>Percentual</th>
                        <th>Total</th>
                        <th>Defeito</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bConsultaDef" items="${requestScope.lista}" varStatus="status">
                        <tr>
                            <td>${param.data_in}</td>
                            <td class="centcol">${bConsultaDef.cont}</td>
                            <td class="centcol"><f:formatNumber type="number" maxFractionDigits="2" minFractionDigits="2"  value="${bConsultaDef.percent}"/></td>
                            <td>${bConsultaDef.total}</td>
                            <td><a href="consultaServ?acao=listaDefTipo&data_in=${param.data_in}&imput_prod=${param.imput_prod}&tp_def=${bConsultaDef.cod_def}">${bConsultaDef.str_def}</a></td>
                        </tr>
                    </c:forEach>       
                </tbody>
            </table>


            ---------------------------------------------------------------------------------------------------- 






        </center>

        <br/>



    </body>
</html>