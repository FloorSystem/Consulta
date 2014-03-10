<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            .dia{
                width:54px;
            }           
        </style>

        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

        <script>
            $(document).ready(function(){
                    $('#data_in1').change(function(){
                        document.getElementById('upload_process').style.visibility = 'visible';
                        $('#imput_gmp1').load('listaProdData?data_in='+$('#data_in1').val() + "&acao=gmp2" ,                    function() {                        $('#imput_prod1').load('listaProdData?data_in='+$('#data_in1').val() + "&gmp=" +$('#imput_gmp1').val() + "&acao=fun2" ,                    function() {  document.getElementById('upload_process').style.visibility = 'hidden'; }                );                    });
                    });
                
                    $('#imput_gmp1').change(function(){
                        document.getElementById('upload_process').style.visibility = 'visible';
                        $('#imput_prod1').load('listaProdData?data_in='+$('#data_in1').val() + "&gmp=" +$('#imput_gmp1').val() + "&acao=fun2",function(){ document.getElementById('upload_process').style.visibility = 'hidden'; } );
                    });

                $('#data_in').change(function(){
                    document.getElementById('upload_process').style.visibility = 'visible';
                    $('#imput_prod').load('listaProdData?data_in='+$('#data_in').val()+ '&acao=def2', function(){ document.getElementById('upload_process').style.visibility = 'hidden';});
                });
                
                $('#imput_gmp1').load('listaProdData?data_in='+$('#data_in1').val() + "&acao=gmp2",
                    function(){  $('#imput_prod1').load('listaProdData?data_in='+$('#data_in1').val() + "&gmp=" +$('#imput_gmp1').val() + "&acao=fun2" );}
                );
                $('#imput_prod').load('listaProdData?data_in='+$('#data_in').val()+ '&acao=def2');
            });
            
        </script>

        <script language="javascript">
            function send(action)
            {
                evento = action;
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
            }           
            function ajustaIframe() {
                var myIframe = parent.document.getElementById("grafc");
                if (myIframe) {
                    myIframe.height = screen.height - 280; // altura
                    myIframe.width = screen.width ;
                }
            }
            setInterval(
            function(){
                send(evento)
            }
            ,100000); // 100000
          
            //formata data (não usado)
            function dtval0(d,e) {
                var pK = e ? e.which : window.event.keyCode;
                if (pK == 8) {d.value = substr(0,d.value.length-1); return;}
                var dt = d.value;
                var da = dt.split('/');
                for (var a = 0; a < da.length; a++) {if (da[a] != +da[a]) da[a] = da[a].substr(0,da[a].length-1);}
                if (da[0] > 31) {da[1] = da[0].substr(da[0].length-1,1);da[0] = '0'+da[0].substr(0,da[0].length-1);}
                if (da[1] > 12) {da[2] = da[1].substr(da[1].length-1,1);da[1] = '0'+da[1].substr(0,da[1].length-1);}
                if (da[2] > 9999) da[1] = da[2].substr(0,da[2].length-1);
                dt = da.join('/');
                if (dt.length == 2 || dt.length == 5) dt += '/';
                d.value = dt;
            }
        </script>

        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
        <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
        <!link rel="stylesheet" href="http://code.jquery.com/resources/demos/style.css" />

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
                            <th></th>
                            <td align="left">
                                <input  autocomplete="false" class="dia" type="text" id="data_in" name="data_in" value="<fmt:formatDate pattern="MM/yyyy" value='${now}'/>" </input>
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
                                <input autocomplete="false" class="dia"  type="text" name="data_in1" id="data_in1" value="<fmt:formatDate pattern="MM/yyyy" value='${now}'/>" </input>
                            </td>
                            <th></th>
                            <td>
                                <select   name="imput_gmp1" id="imput_gmp1" >
                                    <option value=110 selected="this">GMP-110</option>
                                </select>
                            </td>                    
                            <td>
                                <select name="imput_prod1" id="imput_prod1" >
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
       <div id="upload_process" name="upload_process"> <img src="ajax-loader(1).gif" /> </div>
            <div id="visualization">
                <iframe  onscroll="ajustaIframe(this);" onload="ajustaIframe(this);" id="grafc" name="grafc" frameborder='0'> </iframe>
            </div>
            <script language="javascript">
                send("resumo");
            </script>
        </center>
    </div>
</body>
</html>