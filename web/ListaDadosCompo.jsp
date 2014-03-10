<%-- 
    Document   : ListaDados
    Created on : 02/04/2012, 13:41:40
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="def" class="ja_jdbc_plpgsql.jdbc.jDefeito"/>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>Listagem Registros Reparos</title>
        <script>
           // parent.evento = "recarrega";
            parent.window.scrollTo(0, 0);
        </script>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {packages: ['table']});
            function drawVisualization() {
                // Create and populate the data table.
                var data = new google.visualization.DataTable();
                data.addColumn('number', 'Qtd');
                data.addColumn('string', 'Produto');
                data.addColumn('string', 'Componente');
                data.addColumn('string', 'Descrição Componente');

      
                data.addRows(${fn:length(requestScope.lista)});
      
            <c:forEach var="bConsultaCompo" items="${requestScope.lista}" varStatus="status">
                    data.setCell(${status.count}-1, 0, ${bConsultaCompo.cont});
                    data.setCell(${status.count}-1, 1, "${bConsultaCompo.cod_prod}");
                    data.setCell(${status.count}-1, 2, "${bConsultaCompo.str_compo}");
                    data.setCell(${status.count}-1, 3, "${bConsultaCompo.descricao1}");
            </c:forEach>
                

                    // Create and draw the visualization.
                    var table = new google.visualization.Table(document.getElementById('visualization'));
    
                    //  var formatter = new google.visualization.TableArrowFormat();
                    //  formatter.format(data, 2); 
    
                    table.draw(data, {allowHtml: true, showRowNumber: false});
                }
    
                google.setOnLoadCallback(drawVisualization);
        </script>
    </head>
    <body style="font-family: Arial;border: 0 none;">
    <center>
        <div id="visualization" style="width: 800px; height: 470px;"></div>
    </center>
</body>
</html>