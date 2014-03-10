<%-- 
    Document   : TPMlista
    Created on : 24/09/2012, 13:05:06
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {packages: ['corechart']});
        </script>
        <script type="text/javascript">
            function drawVisualization() {
                // Create and populate the data table. 
                var data = new google.visualization.DataTable();
                var raw_data = [
            <c:forEach var="obj" items="${requestScope.lista}" varStatus="status">
                        ['<fmt:formatDate pattern="dd/MM/yyyy" value="${obj.datah}" />', ${obj.eficiencia}]
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
                    {title:" Mes: ${param.data} - Linha: ${param.codlin}",
                        width:600, height:400,
                        hAxis: {title: " EFICIÊNCIA DE INSERÇÃO  "}}
                );
                }
      

                google.setOnLoadCallback(drawVisualization);
        </script>


        <style type="text/css"> 
            .main {
                border: 1px #999;
                border-top-style:solid;
                border-right-style:solid;
                border-right-width: 4px;
                border-bottom-width: 4px;
                border-bottom-style:solid;
                border-left-style:solid;
                border-radius: 10px;
                width:35.0em;
                padding-left: 9px; /* Espaçamento do texto a esquerda */
            }
            #cabeca{
                border: 1px #999;
                border-bottom-style:solid;
                background: #FFFAFA;
                padding-top: 4px;
                font-weight: bold;
                color: brown;
                -webkit-border-top-left-radius : 10px;
                -webkit-border-top-right-radius: 10px;
            }
            #ok2{
                width:90%;
            }
        </style>
    </head>
    <body style="font-family: Arial;border: 0 none;">
        <div id="visualization" style="width: 650px; height: 450px;"></div>

        <div class="main">
            <div id="cabeca">
                <pre>Data     &#09;Minutos&#09;Eficiencia</pre>    
            </div>  
            <c:forEach var="lista" items="${requestScope.lista}" varStatus="status">
                <pre><fmt:formatDate pattern="dd/MM/yyyy" value="${lista.datah}" /> &#09;${lista.perda}&#09;${lista.eficiencia}%</pre>
                <c:choose>
                    <c:when test="${status.last}"> ------------------------------------------------------------------------------------------ </c:when>
                </c:choose>
            </c:forEach>
        </div>  
        <br/>
        <div class="main" id="ok2">
            <div id="cabeca">
                <pre>Op&#09;Item&#09;QtdOp&#09;N.S.Ini Fin&#09;Parada&#09;DataSetup&#09;&#09;T.(minu)&#09;Obser.</pre>    
            </div> 
            <c:forEach var="lista1" items="${requestScope.lista1}" varStatus="status">
                <pre><b>${lista1.cod_op}</b>&#09;${lista1.cod_prod}&#09;${lista1.qtd_op}&#09;${lista1.nroserieini}&#09;${lista1.nroseriefim}&#09;${lista1.cod_parada}&#09;<fmt:formatDate pattern="dd/MM/yyyy HH:mm" value="${lista1.datah_ini}" /> &#09;<b>${lista1.tempo}</b>&#09;${lista1.strobs}</pre>
                <c:choose>
                    <c:when test="${status.last}"> ------------------------------------------------------------------------------------------ </c:when>
                </c:choose>
            </c:forEach>
        </div> 
        <br/>
        <div class="main">
            <div id="cabeca">
                <pre>Parada&#09;P.Minu&#09;(%)&#09;Perda/Total Horas(%)</pre>    
            </div>  
            <c:forEach var="lista3" items="${requestScope.lista3}" varStatus="status">
                <pre>${lista3}</pre>
                <c:choose>
                    <c:when test="${status.last}"> ------------------------------------------------------------------------------------------ </c:when>
                </c:choose>
            </c:forEach>
        </div>
        <br/>



    </body>
</html>
