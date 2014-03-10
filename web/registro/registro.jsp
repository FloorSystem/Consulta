<%-- 
    Document   : registro
    Created on : 03/04/2013, 16:18:36
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro SFMS</title>
    </head>
    <body>



        <form name="gmp" action="/Consulta/consultaServ" method="POST">

            <input type="hidden" name="acao" value="registrar" />
            <input type="hidden" name="user" value="${param.user}" />
            <input type="hidden" name="gmp" value="${param.gmp}" />


            <br/>
            <h2>
                <label> 
                    <input type="radio" name="status" value="0" checked="checked" />
                    OK
                </label> 

                <label> 
                    <input type="radio" name="status" value="1" />
                    NOK
                </label> 
            </h2>
            <br/>
            <input type="text" name="serial" value="" autocomplete="off" />
            <input type="submit" value="OK" />
            <br/>
            <h2> ${param.serial} </h2>
        </form>
    </body>
</html>
