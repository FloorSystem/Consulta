<%-- 
    Document   : gmp
    Created on : 03/04/2013, 16:17:42
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>GMP</title>
    </head>
    <body>
        <h1>GMP</h1><br/>
        
            <form name="gmp" action="registro.jsp" method="POST">
                <input  type="hidden" name="user" value="${param.user}" />
                <input type="text" name="gmp" value="" />
                <input type="submit" value="OK" />
            </form>
    </body>
</html>
