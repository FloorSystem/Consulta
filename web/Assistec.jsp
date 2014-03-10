<%@page contentType="text/html" pageEncoding="UTF-8"%>

<jsp:useBean id="reg" class="ja_jdbc_plpgsql.jdbc.jAssistec"/>

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
            
            function send(action)
            {
                switch(action) {
                    case 'compAssistec':
                        url = 'consultaServ?acao=compAssistec';//&data_in='+data1;;
                        document.forms[0].action = url;
                        document.forms[0].target="grafc";
                        document.forms[0].submit();
                        break;
                    case 'AsisMap':
                        url = 'consultaServ?acao=AsisMap';
                        document.forms[0].action = url;
                        document.forms[0].target="janela";
                        abrir();
                        document.forms[0].submit();
                        break;
                    case 'assistec':
                        url = 'consultaServ?acao=assistec';
                        document.forms[0].action = url;
                        document.forms[0].target="grafc";
                        document.forms[0].submit();
                        break;
                    case 'listaAssistec':
                        url = 'consultaServ?acao=listaAssistec&tp_def= ';
                        document.forms[0].action = url;
                        document.forms[0].target="grafc";
                        document.forms[0].submit();
                        break;
                    case 'resumo':
                        minhaData = new Date() ;
                        document.getElementById('grafc').src = "consultaServ?acao=resumo&dia=" + minhaData.getDate() + "/" + (minhaData.getMonth() + 1) + "/" + minhaData.getFullYear() ;
                        break;
                }
            }
    
    
            function abrir() {
                var width = 621;
                var height = 431;

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
                    myIframe.height = screen.height - 280; // altura
                    myIframe.width = screen.width ;
                }
            }
            
        </script>

        <title>Parks SFMS_II Consultas</title>
    </head>
    <body onload="document.getElementById('upload_process').style.visibility = 'hidden';">
        <div class="centro">
            <center>
                <br/>
                <br/>
                <br/>
                Gráfico Reparo de Defeitos Assistência Técnica
                <form id="assistec"  method="post" >
                    <table border="0">
                        <tr>
                            <th>Período</th>
                            <td align="left">
                                <select onchange="obterObjRequisicao(this,'assistec')" onclick="obterObjRequisicao(this,'assistec')"  id="data_in"  name="data_in" >
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
                                <input type="submit" name="def" value="Defeitos" onclick="send('assistec');"/>
                                <input type="submit" value="Mapa Defeitos" onclick="send('AsisMap');"/>
                                <input type="button" value="Componentes" onclick="send('compAssistec');" />
                                <input type="button" value="Listar" onclick="send('listaAssistec');" />
                            </th>
                        </tr>
                    </table>
                </form>

                <div id="upload_process"> <img src="ajax-loader(1).gif" /> </div>
                <div id="visualization">
                    <iframe onscroll="ajustaIframe(this);" onload="ajustaIframe(this);" id="grafc" name="grafc" width='100%' height='490'  frameborder='0'> </iframe>
                </div>
                <script language="javascript">
                    //     onload="send('resumo');"
                    //send("resumo");
                </script>

            </center>
        </div>
    </body>
</html>