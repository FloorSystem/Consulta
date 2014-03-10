<%-- 
    Document   : ERRO606
    Created on : 04/04/2013, 10:49:16
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Erro</title>
    </head>
    <body>
        <h1> ${erro} </h1>
        <br/>
        <input type="button" value="Voltar" onClick="history.go(-1)"> 
    </body>
</html>
