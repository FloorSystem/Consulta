<%-- 
    Document   : ListaMediaHora.jsp
    Created on : 30/11/2012, 14:37:05
    Author     : psantos
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://cewolf.sourceforge.net/taglib/cewolf.tld" prefix="cewolf" %>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="de.laures.cewolf.*"%>
<%@page import="org.jfree.data.*"%>
<%@page import="org.jfree.data.time.*"%>
<jsp:useBean id="pageViews" class="graficos.Teste1"  />
<jsp:useBean id="labelRotation" class="de.laures.cewolf.cpp.RotatedAxisLabels" /> 
<jsp:useBean id="lineRenderer" class="de.laures.cewolf.cpp.LineRendererProcessor" />
<jsp:useBean id="visualEnhancer" class="de.laures.cewolf.cpp.VisualEnhancer" />
<jsp:useBean id="waferMapLegend" class="de.laures.cewolf.cpp.WaferMapLegendProcessor" />


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
                border-right-width: 2px;
                border-bottom-style:solid;
                border-bottom-width: 2px;
                border-left-style:solid;
                /* padding-left:9px;  Espaçamento do texto a esquerda */
            }
            #cabeca{
                border: 1px #999;
                border-bottom-style:solid;
                background: #e2e2e2;
                padding-top: 5px;
                color: brown;
            }


        </style>

    </head>
    <body style="font-family: Arial;border: 0 none;">



        <cewolf:chart 
            id="line" 
            title="" 
            type="line" 
            xaxislabel="" 
            plotbordervisible="true"
            >
            <!--   plotbackgroundcolor="#E0FFFF"  -- >
            <cewolf:gradientpaint>
                <cewolf:point x="0" y="0" color="#FFFFFF" />
                <cewolf:point x="0" y="300" color="#F3F3F3" />
            </cewolf:gradientpaint>
            <cewolf:data>
                <cewolf:producer id="pageViews"> 
                    <cewolf:param name="arg_prod" value='${param.imput_prod1}'/>
                    <cewolf:param name="data_in" value='${param.data_in1}'/>
                    <cewolf:param name="data_fim" value='${param.dt2}'/>
                    <cewolf:param name="gmp" value='${param.imput_gmp1}'/>
                </cewolf:producer>
            </cewolf:data>
            <!--cewolf:colorpaint color="#E0EEEE" /--> 
            <cewolf:chartpostprocessor id="labelRotation">
                <cewolf:param name="rotate_at" value="2"/>
                <!--cewolf:param name="skip_at" value=''/-->
                <cewolf:param name="remove_at" value="200"/>
            </cewolf:chartpostprocessor>  

            <cewolf:chartpostprocessor id="lineRenderer">
                <cewolf:param name="shapes" value="true" />
                <cewolf:param name="outline" value="true" />
                <cewolf:param name="useFillPaint" value="true" />
                <cewolf:param name="fillPaint" value="#FFFFFF" />
                <cewolf:param name="useOutlinePaint" value="true" />
                <cewolf:param name="outlinePaint" value="#000000" />
            </cewolf:chartpostprocessor>

            <cewolf:chartpostprocessor id="visualEnhancer">  
                <cewolf:param name="border" value="true" />
                <cewolf:param name="borderpaint" value="#4488BB" />
                <cewolf:param name="top" value="5" />
                <cewolf:param name="left" value="5" />
                <cewolf:param name="right" value="5" />
                <cewolf:param name="bottom" value="5" />
                <cewolf:param name="plotTop" value="0" />
                <cewolf:param name="plotLeft" value="0" />
                <cewolf:param name="plotRight" value="0" />
                <cewolf:param name="plotBottom" value="0" />
                <cewolf:param name="rangeIncludesZero" value="false" />
                <cewolf:param name="showDomainAxes" value="true" />
                <cewolf:param name="showRangeAxes" value="true" /> 
            </cewolf:chartpostprocessor>  


        </cewolf:chart>



        <p>
            <cewolf:img chartid="line" renderer="cewolf" width="1250" height="500" >
                <!--cewolf:map linkgeneratorid="pageViews" tooltipgeneratorid="pageViews"/-->
                <!--cewolf:map tooltipgeneratorid="pageViews" /--> 
            </cewolf:img>
        <P>

            </br>

        <div id="main">
            <div id="cabeca">
                <pre>Data Hora&#09;        Posto&#09;QTD/H&#09; Descrição Posto &#09; Nome </pre>    
            </div>  
            <c:forEach var="lista" items="${requestScope.lista}" varStatus="status">
                <pre>${lista.data_in} &#09; ${lista.posto} &#09;   ${lista.cont} &#09; ${lista.obs} &#09; ${lista.str_nome} </pre>
                <c:choose>
                    <c:when test="${status.last}"> ------------------------------------------------------------------------------------------ </c:when>
                </c:choose>
            </c:forEach>
        </div> 
    </body>
</html>

