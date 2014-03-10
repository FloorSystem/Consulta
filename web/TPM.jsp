<%-- 
    Document   : TPM
    Created on : 24/09/2012, 10:42:30
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Eficiência de Inserção</title>


        <style type="text/css"> 
            .centro {
                background-image: url(/Consulta/bgBody.jpg);
                background-repeat: no-repeat;
                background-position:top left;
            }
            * {
                margin: 0;
                padding: 0;
                border: 1;
                outline: 0
            }

            .formularios{
                position:relative;
                width:700px;
                left:40%;
            }


        </style>
    </head>
    <body>
        <div class="centro">
            <br/>
            <center>
                <br/>
                <br/>
                Paradas de Produção
                <br/>
                <br/>
                <form id="tpm" name="tpm" method="post" action="consultaServ?acao=TPM" target="grafc">
                    <b> Mês/Ano: 
                        <input type="text" name="data"></input>

                        Linha:
                        <input type="text" name="codlin"></input>

                        <input type="submit"></input>
                    </b>
                </form>
            </center>
        </div>
        
        <iframe id="grafc" name="grafc" width='100%' height='490'  frameborder='0'> </iframe>
    </body>
</html>
