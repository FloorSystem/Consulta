<%-- 
    Document   : OpLista
    Created on : 26/09/2012, 14:37:05
    Author     : psantos
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <script>
         //   parent.evento = "recarrega";
            parent.window.scrollTo(0, 0);
        </script>

        <style type="text/css"> 
            #main {
                border: 1px #999;
                border-top-style:solid;
                border-right-style:solid;
                border-right-width: 4px;
                border-bottom-width: 4px;
                border-bottom-style:solid;
                border-left-style:solid;
                border-radius: 10px;

                /* padding-left:9px;  Espaçamento do texto a esquerda */
            }
            #cabeca{
                border: 1px #999;
                border-bottom-style:solid;
                background: #FFFAFA;
                padding-top: 5px;
                font-weight: bold;
                color: brown;
                -webkit-border-top-left-radius : 10px;
                -webkit-border-top-right-radius: 10px;
            }


        </style>

    </head>
    <body style="font-family: Arial;border: 0 none;">

        <div id="main">
            <div id="cabeca">
                <pre>Op&#09;Data_OP&#09;        S.Ini&#09;S.Fin&#09;Primeiro Reg.&#09;Ultimo Reg&#09;QtdOp&#09;Cont.&#09;Produto&#09;&#09;Dt_Estimada&#09;Media_hora&#09;Yield</pre>    
            </div>  
            <c:forEach var="lista" items="${requestScope.lista}" varStatus="status">
                <pre>${lista}</pre>
                <c:choose>
                    <c:when test="${status.last}"> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- </c:when>
                </c:choose>
            </c:forEach>

            <c:forEach var="lista1" items="${requestScope.lista1}" varStatus="status">
                <pre>${status.count} - ${lista1}</pre>
                <c:choose>
                    <c:when test="${status.last}"> ---------------------------------------------------------------- Lista de Seriais Faltantes</c:when>
                </c:choose>
            </c:forEach>
        </div> 

        <br/> <br/>
        <form id="porOp" name="porOp" method="post" action="consultaServ?acao=opsConsultaOp">
            <label for="txt_op">Por OP:</label>
            <input type="text" name="txt_op" autocomplete="off"></input>
            <input type="submit"></input>
        </form>
        <br/>
        <form id="porSerial" name="porSerial" method="post" action="consultaServ?acao=opsConsultaSerial">
            Por Serial: <input type="text" name="txt_serial" autocomplete="off"></input>
            <input type="submit"></input>
        </form>

    </body>
</html>

