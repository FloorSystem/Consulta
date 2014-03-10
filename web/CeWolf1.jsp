<%@page contentType="text/html"%>
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

<HTML>
    <BODY>
        <H1>Page View Statistics</H1>
        <HR>

        <cewolf:chart 
            id="line" 
            title="Teste LOco" 
            type="line" 
            xaxislabel="Hora" 
            plotbordervisible="true"
            >
            <!--   plotbackgroundcolor="#E0FFFF"  -- >
            <cewolf:gradientpaint>
                <cewolf:point x="0" y="0" color="#FFFFFF" />
                <cewolf:point x="0" y="300" color="#F3F3F3" />
            </cewolf:gradientpaint>
            <cewolf:data>
                <cewolf:producer id="pageViews"> 
                    <cewolf:param name="arg_prod" value="011235"/>
                    <cewolf:param name="data_in" value="03/12/2012"/>
                    <cewolf:param name="data_fim" value="07/12/2012"/>
                    <cewolf:param name="gmp" value="90"/>
                </cewolf:producer>
            </cewolf:data>
            <!--cewolf:colorpaint color="#E0EEEE" /--> 
            <cewolf:chartpostprocessor id="labelRotation">
                <cewolf:param name="rotate_at" value="1"/>
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
            <cewolf:img chartid="line" renderer="cewolf" width="1350" height="500" >
                <!--cewolf:map linkgeneratorid="pageViews" tooltipgeneratorid="pageViews"/-->
                <!--cewolf:map tooltipgeneratorid="pageViews" /--> 
            </cewolf:img>
        <P>
    </BODY>
</HTML>

