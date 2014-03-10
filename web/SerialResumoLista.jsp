<%-- 
    Document   : SerialResumoLista
    Created on : 24/07/2013, 09:32:32
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta Seriais</title>
    </head>
    <body>
        Arquivo Texto com um serial por linha: <br/>
        <form enctype="multipart/form-data" method="post" name="consulta_txt" action="serialArquivo?acao=geral">
            <input type="file" name="arquivo" value="" />
            <br/>
            <input type="submit" value="Enviar" name="enviar" />
        </form>
        <br/><br/><br/>
        
        Exibi somente dados RMA:
        <form enctype="multipart/form-data" method="post" name="consulta_assistec" action="serialArquivo?acao=assistec">
            <input type="file" name="arquivo" value="" />
            <br/>
            <input type="submit" value="Enviar" name="enviar2" />
        </form>

        <br/><br/><br/>
        Consulta Por S.A.:
        <form  method="post" name="consulta_assistecsa" action="serialArquivo?acao=sa">
            <input type="text" name ="sa_str" id="sa_str" value="" />
            <br/>
            <input type="submit" name="enviar3" />
        </form>
        
    </body>
</html>
