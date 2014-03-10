<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="reg" class="ja_jdbc_plpgsql.jdbc.jRegistro"/>
<c:set var="now" value="<%=new java.util.Date()%>" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


        <style type="text/css"> 
            .centro {
                background-image: url(/Consulta/bgBody.jpg);
                background-repeat: no-repeat;
                background-position:top left;

                /*
                background-position: 3% 5%;
                background: url(/Consulta/bgBody.jpg) top center no-repeat; 
                   
                */
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

                /*
                
                 margin-left:-350px;
                
                 text-align: right;
                */

            }


        </style>


        <script language="javascript">
        
            var url = "";
            var xmlhttp = "";
            var evento = "";
            
            function abreAjax(){
                if (window.XMLHttpRequest) {
                    xmlhttp = new XMLHttpRequest();
                }
                else {
                    try{
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    }
                    catch (e) {
                        try {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        }
                        catch (E) {
                            xmlhttp = false;
                        }
                    }
                }
                if(!xmlhttp && window.createRequest) {
                    try {
                        xmlhttp = window.createRequest();
                    }
                    catch (e) {
                        xmlhttp=false;
                    }
                }
                if(xmlhttp == null || xmlhttp == false )
                {
                    alert("Navegador não compatível.");
                }
            }
            
            // defeitos
            function obterObjRequisicao(arg_data,arg_acao)
            {
                document.getElementById('upload_process').style.visibility = 'visible';
                url = "listaProdData?data_in=" +
                    arg_data.value
                    +"&acao=" + arg_acao;
                
                abreAjax();

                try {
                    xmlhttp.open("GET", url, true);
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4){
                            if(xmlhttp.status == 200){
                                // processar(arg_acao);
                                var x = document.getElementById(arg_acao);
                                var result = xmlhttp.responseText;
                                var quebra = result.split("\n"); 
                                var tamanha = quebra.length - 1; 
                                var select = x.elements[1];//document.getElementById("imput_prod");
                                select.innerHTML = "";
                                // 
                                newOpt = document.createElement('option');
                                newOpt.text = 'Total';
                                newOpt.value = '';
                                //document.getElementsByName('imput_prod')[0].options.add(newOpt, 0);
                                x.elements[1].options.add(newOpt, 0);
                                //
                                for(i = 0; i < tamanha; i++) {
                                    var quebre = quebra[i].split("|"); //alert("teste:"+quebre+".");
                                    //var oSelect = document.getElementsByName('imput_prod')[0].options.length
                                    var oSelect = x.elements[1].options.length
                                    nextOptIndex = quebre[0]; 
                                    newOpt = document.createElement('option');
                                    newOpt.text = quebre[1];
                                    newOpt.value = nextOptIndex;
                                    //document.getElementsByName('imput_prod')[0].options.add(newOpt, oSelect);
                                    x.elements[1].options.add(newOpt, oSelect);
                                }
                                document.getElementById('upload_process').style.visibility = 'hidden';
                            }
                        }
                    }
                    try {
                        xmlhttp.send(null);
                    }
                    catch(e){
                        xmlhttp="";
                    }
                }
                catch (e) {
                    try {
                        xmlhttp.send(null)
                        xmlhttp="";
                    }
                    catch(e){
                        xmlhttp="";
                    }
                }
            }
            
            // funcional
            function obterObjReqFun()
            {
                //alert("Entrou");
                document.getElementById('upload_process').style.visibility = 'visible';
                url = "listaProdData?data_in=" +
                    document.getElementById("fun").elements[0].value
                    + "&gmp=" +
                    document.getElementById("fun").elements[1].value
                    +"&acao=fun";
                // alert(url);
                abreAjax();

                try {
                    xmlhttp.open("GET", url, true);
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4){
                            if(xmlhttp.status == 200){
                                //   processarFunGMP("fun");
                                var x = document.getElementById("fun");
                                var result = xmlhttp.responseText;
                                var quebra = result.split("\n"); 
                                var tamanha = quebra.length - 1; 
                                var select = x.elements[2];//document.getElementById("imput_prod");
                                select.innerHTML = "";
                                // 
                                newOpt = document.createElement('option');
                                newOpt.text = 'Todos os Produtos';
                                newOpt.value = '';
                                //document.getElementsByName('imput_prod')[0].options.add(newOpt, 0);
                                x.elements[2].options.add(newOpt, 0);
                                //
                                for(i = 0; i < tamanha; i++) {
                                    var quebre = quebra[i].split("|"); //alert("teste:"+quebre+".");
                                    //var oSelect = document.getElementsByName('imput_prod')[0].options.length
                                    var oSelect = x.elements[2].options.length;
                                    nextOptIndex = quebre[0]; 
                                    newOpt = document.createElement('option');
                                    newOpt.text = quebre[1];
                                    newOpt.value = nextOptIndex;
                                    //document.getElementsByName('imput_prod')[0].options.add(newOpt, oSelect);
                                    x.elements[2].options.add(newOpt, oSelect);
                                }
                                document.getElementById('upload_process').style.visibility = 'hidden';
                            }
                        }
                    }
                    try {
                        xmlhttp.send(null);
                    }
                    catch(e){
                        xmlhttp="";
                    }
                }
                catch (e) {
                    try {
                        xmlhttp.send(null);
                        xmlhttp="";
                    }
                    catch(e){
                        xmlhttp="";
                    }
                }
            }
            
            function obterObjGMP(arg_data)
            {
                document.getElementById('upload_process').style.visibility = 'visible';
                url = "listaProdData?data_in=" +
                    arg_data.value
                    +"&acao=gmp";
                 //alert(url);
                abreAjax();

                try {
                    xmlhttp.open("GET", url, true);
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4){
                            if(xmlhttp.status == 200){
                                //   processarFunGMP("fun");
                                var x = document.getElementById("fun");
                                var result = xmlhttp.responseText;
                                var quebra = result.split("\n"); 
                                var tamanha = quebra.length - 1; 
                                var select = x.elements[1];//document.getElementById("imput_prod");
                                select.innerHTML = "";
                                // 
                                newOpt = document.createElement('option');
                                newOpt.text = 'Todos GMPs';
                                newOpt.value = '-1';
                                //document.getElementsByName('imput_prod')[0].options.add(newOpt, 0);
                                x.elements[1].options.add(newOpt, 0);
                                //
                                for(i = 0; i < tamanha; i++) {
                                    var quebre = quebra[i].split("|"); //alert("teste:"+quebre+".");
                                    //var oSelect = document.getElementsByName('imput_prod')[0].options.length
                                    var oSelect = x.elements[1].options.length;
                                    nextOptIndex = quebre[0]; 
                                    newOpt = document.createElement('option');
                                    newOpt.text = quebre[1];
                                    newOpt.value = nextOptIndex;
                                    //document.getElementsByName('imput_prod')[0].options.add(newOpt, oSelect);
                                    if(newOpt.value == 110)  {
                                        newOpt.selected = "true";
                                    }
 
                                    x.elements[1].options.add(newOpt, oSelect);
 
                                }
                                document.getElementById('upload_process').style.visibility = 'hidden';
                            }
                        }
                    }
                    try {
                        xmlhttp.send(null);
                    }
                    catch(e){
                        xmlhttp="";
                    }
                }
                catch (e) {
                    try {
                        xmlhttp.send(null);
                        xmlhttp="";
                    }
                    catch(e){
                        xmlhttp="";
                    }
                }
                setTimeout(function(){
                    obterObjReqFun()
                }
                , 1700);
            }

            function send(action)
            {
                evento = action;
                
         //       var data1 = document.getElementById('data_in').value;
          //      var n = data1.split("-");
           //     data1 = n[1]+ "/" + n[0];
                //alert(data1);
                
                switch(action) {
                    case 'recarrega':
                        document.getElementById("grafc").contentWindow.location.reload();
                        //document.getElementById(FrameID).contentDocument.location.reload(true);
                        break;
                    case 'componentes':
                        url = 'consultaServ?acao=componentes';//&data_in='+data1;;
                        document.forms[0].action = url;
                        document.forms[0].target="grafc";
                        document.forms[0].submit();
                        break;
                    case 'fun':
                        url = 'consultaServ?acao=fun';
                        document.forms[1].action = url;
                        document.forms[1].target="grafc";
                        document.forms[1].submit();
                        break;
                    case 'defMap':
                        url = 'consultaServ?acao=defMap';
                        document.forms[0].action = url;
                        document.forms[0].target="janela";
                        abrir();
                        document.forms[0].submit();
                        break;
                    case 'def':
                        url = 'consultaServ?acao=def';
                        document.forms[0].action = url;
                        document.forms[0].target="grafc";
                        document.forms[0].submit();
                        break;
                    case 'listaReg':
                        url = 'consultaServ?acao=listaReg';
                        document.forms[1].action = url;
                        document.forms[1].target="grafc";
                        document.forms[1].submit();
                        break;
                    case 'listaDef':
                        url = 'consultaServ?acao=listaDef';
                        document.forms[0].action = url;
                        document.forms[0].target="grafc";
                        document.forms[0].submit();
                        break;
                    case 'totalMes':
                        url = 'totaisFunMes';
                        //document.location.href='totaisFunMes'
                        document.forms[1].action = url;
                        document.forms[1].target="grafc";
                        document.forms[1].submit();
                        break;
                    case 'resumo':
                        minhaData = new Date() ;
                        //alert(minhaData);
                        document.getElementById('grafc').src = "consultaServ?acao=resumo&dia=" +minhaData.getDate()+ "/" + (minhaData.getMonth() + 1) +  "/" + minhaData.getFullYear();
                        break;
                    case 'resumoSemana':
                        document.getElementById('grafc').src = "consultaServ?acao=resumoSemana";
                        break;
                    case 'ops':
                        
                        //location.href="consultaServ?acao=ops"
                        window.open("consultaServ?acao=ops",'grafc');
                        break;
                    case 'opsConsulta':
                        url = 'consultaServ?acao=opsConsulta';
                        //document.location.href='totaisFunMes'
                        document.forms[1].action = url;
                        document.forms[1].target="grafc";
                        document.forms[1].submit();
                        break;
                    case 'MediaHoras':
                        url = 'consultaServ?acao=MediaHoras';
                        //document.location.href='totaisFunMes'
                        document.forms[1].action = url;
                        document.forms[1].target="grafc";
                        document.forms[1].submit();
                        break;
                       
                }
                // window.scrollTo(0, 0);

            }
    
    
            function abrir() {
                var width = 610;
                var height = 420;

                var left = 270;
                var top = 99;

                window.open('','janela', 'width='+width+', height='+height+', top='+top+', left='+left+', scrollbars=yes, status=no, toolbar=no, location=no, directories=no, menubar=no, resizable=no, fullscreen=no');
                
                //var janela = window.open("", "janela", "height=300, width=300" ) ;
                // form.submit();
                //  window.open ("http://www.javascript-coder.com","mywindow","menubar=1,resizable=1,width=350,height=250");
            }
            
           
            function ajustaIframe() {
                
                var myIframe = parent.document.getElementById("grafc");
                if (myIframe) {
                    //    if (myIframe.contentDocument && myIframe.contentDocument.body.offsetHeight) {
                    // W3C DOM (and Mozilla) syntax
                    //myIframe.height = myIframe.contentDocument.body.offsetHeight + 60;
                    myIframe.height = screen.height - 280; // altura
                    myIframe.width = screen.width ;
                    //   if (myIframe.height <= 999) {
                    //       myIframe.height = 1000; 
                    //   }
                    // } else if (myIframe.Document && myIframe.Document.body.scrollHeight) {
                    // IE DOM syntax
                    //        myIframe.height = 
                        
                    // if (myIframe.height <= 999) { 
                    //    myIframe.height = 1000; 
                    //}
                }
                //     }
                
                
                //alert (myIframe.height);
            }
            
            // a cada 1 minutos atualiza a ultima acao:
            setInterval(
            function(){
                send(evento)
            }
            ,100000); // 100000
            
        </script>

        <title>Parks SFMS_II Consultas</title>
    </head>
    <body onload="document.getElementById('upload_process').style.visibility = 'hidden';">

        <div class="centro">
            <center>
                <div>
                    <br/>
                    Gráfico Reparo de Defeitos
                    <form name="def" id="def"  method="post" >
                        <table border="0">
                            <tr>
                                <!--th>Período</th-->
                                <td align="left">
                                    <!--input type="month" name="data_in" value=<fmt:formatDate pattern="yyyy-MM" value='${now}'/>
                                           onchange="obterObjRequisicao(this,'def')" onclick="obterObjRequisicao(this,'def')"  id="data_in" 
                                           /-->
                                    
                                    <select onchange="obterObjRequisicao(this,'def')" onclick="obterObjRequisicao(this,'def')"  id="data_in"  name="data_in" >
                                        ${reg.dataReg}
                                    </select>
                                </td>
                                <th></th>
                                <td> 
                                    <select name="imput_prod" id="imput_prod" >
                                        <option value="">Totais</option>
                                    </select>
                                </td>
                                <th colspan="2">
                                    <input type="submit" name="def" value="Defeitos" onclick="send('def');"/>
                                    <input type="submit" value="Mapa Defeitos" onclick="send('defMap');"/>
                                    <input type="button" value="Componentes" onclick="send('componentes');" />
                                    <input type="button" value="Listar" onclick="send('listaDef');" />
                                </th>
                            </tr>
                        </table>
                    </form>

                    <br/>
                    Gráfico Yeld Funcional
                    <form name="fun" id="fun"  method="post">
                        <table border="0">
                            <tr>
                                <!--th>Período</th-->
                                <td align="left">
                                    <!--input type="month" name="data_in" value=<fmt:formatDate pattern="yyyy-MM" value='${now}'/>
                                           onchange="obterObjGMP(this)" id="data_in" 
                                           /-->
                                    
                                    <select onclick="obterObjGMP(this)"  id="data_in"  name="data_in" >
                                       ${reg.dataReg}
                                    </select>
                                </td>
                                <th></th>
                                <td>
                                    <select  onclick="obterObjReqFun()"   name="imput_gmp" id="imput_gmp" >
                                        <option value=110 selected="this">GMP-110</option>
                                    </select>
                                </td>                    
                                <td>
                                    <select name="imput_prod" id="imput_prod" >
                                        <option value="">Totais</option>
                                    </select>

                                </td>

                                <th colspan="2">
                                    <input type="submit" name="fun" value="Funcional" onclick="send('fun');"/>
                                    <input type="button" value="Total Por Mes" onclick="send('totalMes')" />
                                    <input type="button" value="O.Ps" onclick="send('opsConsulta');" />
                                    <input type="button" value="Listar" onclick="send('listaReg');" />
                                </th>
                            </tr>
                        </table>
                    </form>
                </div>

                <div id="upload_process"> <img src="ajax-loader(1).gif" /> </div>
                <div id="visualization">
                    <!--iframe onscroll="ajustaIframe(this);" onload="ajustaIframe(this);" id="grafc" name="grafc" width='100%' height='490'  frameborder='0'> </iframe-->
                    <iframe  onscroll="ajustaIframe(this);" onload="ajustaIframe(this);" id="grafc" name="grafc" frameborder='0'> </iframe>
                </div>
                <script language="javascript">
                    //setTimeout(function(){                        obterObjReqFun()                    }                    , 2500); // Carrega os produtos
                    
                    obterObjGMP(document.fun.data_in);
                    send("resumo");
                    setTimeout(function(){ 
                        obterObjRequisicao(document.def.data_in,'def')
                    }, 3010); // Aumentar caso nao carregar todos os produtos.
                </script>

            </center>
        </div>


    </body>
</html>