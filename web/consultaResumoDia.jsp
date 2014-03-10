<%-- 
    Created on : 18/05/2012
    Author     : psantos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:useBean id="agora" class="java.util.Date"/>
<jsp:useBean id="reg" class="ja_jdbc_plpgsql.jdbc.jResumo"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>
            Resumo Diario
        </title>        
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>

        <script>
            
            function verificar(form){
                with (form) {
                    if ( txt_serial.value ==""){
                        alert("Informar o serial");
                        txt_serial.focus();
                        return false;
                    }
                }
            }
            
            function resumoOps(){
                parent.evento = "recarrega";
                location.href="consultaServ?acao=ops"
            }
            
            function resumoSemana(){
                //   parent.evento = "resumoSemana";
                //  location.href="consultaServ?acao=resumoSemana"
                
                document.forms[0].action = "consultaServ?acao=resumoSemana";
                document.forms[0].submit();
            }
            
            var str = "";
            var url = "";
            function resumoFun(str){
                
                // formata a data certinho ex: 2013-04 para 04/2013 (para compatilidade versoes sql)
                var data1 = document.getElementById('dia').value;
                var n = data1.split("/");
                data1 = n[1]+ "/" + n[2];
                //alert(data1);
                
                url = 'consultaServ?acao=fun&imput_prod1=' + str +
                    '&data_in1=' + data1 +
                    '&imput_gmp1=' + parent.document.getElementById('imput_gmp1').value ;
                // alert (url);
                parent.evento = "recarrega";
                window.open(url, 'grafc');
                
            }
            
            
            
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
                width:35.0em;
                box-shadow: 10px 10px 5px #888888;


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
            #corpo{
                padding-left:9px;  /*Espaçamento do texto a esquerda */
            }
        </style>
        <!-- http://www.dynarch.com/projects/calendar/ -->
        <script src="src/js/jscal2.js"></script>
        <script src="src/js/lang/pt.js"></script>
        <link rel="stylesheet" type="text/css" href="src/css/jscal2.css" />
        <link rel="stylesheet" type="text/css" href="src/css/border-radius.css" />
        <link rel="stylesheet" type="text/css" href="src/css/steel/steel.css" />
        <!-- -->
    </head>

    <body style="font-family: Arial;border: 0 none;">


        <div id="main">
            <div id="cabeca">
                <pre>Produto&#09; OKs&#09;NOKs&#09;Reparos&#09;Descrição</pre>    
            </div>  
            <div id="corpo">
                <c:forEach var="bResumo" items="${requestScope.lista}" varStatus="status">
                    <pre><a href="#" onclick="resumoFun('${bResumo.f1}')">${bResumo.f1}</a>&#09;${bResumo.f2}&#09;${bResumo.f3}&#09;${bResumo.f4}&#09;${bResumo.f5}</pre>

                    <% /*<c:choose>
                        <c:when test="${status.last}">  </c:when>
                        </c:choose> */%>
                </c:forEach>
            </div>
        </div>


        ----------------------------------------------------------------------------------------------------------------
        <br/>


        <form action="consultaServ?acao=resumo" method="post" >

            <input type="text" id="dia" name="dia" value="${param.dia}" autocomplete="off"> </input>
            <script type="text/javascript">
                //<![CDATA[
                var cal = Calendar.setup({
                    onSelect   : function() { this.hide() },
                    showTime   : false,
                    weekNumbers : true,
                    fdow : 0
                });
                cal.manageFields("dia", "dia", "%d/%m/%Y");
  
                //]]>
            </script>
            <!--input type="date" id="dia" name="dia" value=${param.dia}-->
            <input type="submit" value="Resumo Dia"></input>
            <input type="button" onclick="resumoSemana()" value="Semana"></input>
            <input type="button" onclick="resumoOps()" value="O.P.s"></input>
        </form>

        <form id="porSerial" name="porSerial" method="post" action="consultaServ?acao=consultaSerial" onsubmit="return verificar(this)">
            <input type="text" name="txt_serial" autocomplete="off"></input>
            <input type="submit" value="Serial"></input>
        </form>
    </body>
</html>