<%-- 
    Document   : ListaDados
    Created on : 02/04/2012, 13:41:40
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="def" class="ja_jdbc_plpgsql.jdbc.jRegistro"/>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />

        <title>Listagem Registros Funcionais</title>
        <script>
          //  parent.evento = "recarrega";
            parent.window.scrollTo(0, 0);
        </script>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load('visualization', '1', {packages: ['table']});
            function drawVisualization() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Produto');
                data.addColumn('string', 'Serial');
                data.addColumn('number', 'Status');
                data.addColumn('string', 'Posto');
                data.addColumn('string', 'Data');
                data.addColumn('string', 'Operador');
                data.addColumn('string', 'Complemento');
                data.addRows(${fn:length(requestScope.lista)});
            <c:forEach var="bRegistro" items="${requestScope.lista}" varStatus="status">
                    data.setCell(${status.count}-1, 0, "${bRegistro.cod_prod}");
                    data.setCell(${status.count}-1, 1, "${bRegistro.serial}");
                    data.setCell(${status.count}-1, 2, ${bRegistro.cod_statusW});
                    data.setCell(${status.count}-1, 3, "${bRegistro.posto_gmp}");
                    data.setCell(${status.count}-1, 4, "<fmt:formatDate pattern="dd/MM/yyyy HH:mm" value="${bRegistro.datah}" />");
                    data.setCell(${status.count}-1, 5, "${bRegistro.str_nome}");
                    data.setCell(${status.count}-1, 6, "${bRegistro.complemento}");
            </c:forEach>
                    var table = new google.visualization.Table(document.getElementById('visualization'));
                    var formatter = new google.visualization.TableArrowFormat();
                    formatter.format(data, 2); 
                    table.draw(data, {allowHtml: true, showRowNumber: true});
                }
                google.setOnLoadCallback(drawVisualization);
        </script>
    </head>
    <body style="font-family: Arial;border: 0 none;">
    <center>
        <div id="visualization" ></div>
        <script>
            var myId = document.getElementById("visualization");
            if (myId) {
                myId.style.height = screen.height - 310 + 'px'; // altura
                myId.style.width = screen.width - 70 + 'px';
                //alert(myId.style.width );
            }
        </script>
    </center>    
</body>
</html>