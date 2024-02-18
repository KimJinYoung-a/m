<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64New.asp"-->
<%
function appUIDEnc(ostr)
    dim i, buf, buf2, subs, istep, imod, imaxloop
    buf = Base64Encode(ostr)
    istep = 3
    imaxloop = LEN(buf)\istep
    imod = LEN(buf) mod istep

    buf2 = buf2&Right(buf,imod)
    for i=imaxloop-1 to 0 step -1
        subs = Mid(buf,(i)*istep+1,istep)
        buf2 = buf2&subs
    next

    appUIDEnc = replace(replace(Base64Encode(buf2),"+","-"),"/","_")
end function


%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

</head>

<body class="shop">
    <!-- wrapper -->
    <div class="wrapper product-detail">
        <!-- #content -->
        <div id="content">
        <a href="#" onClick="alert(1);return callmain();">go Main</a>
        <br>
        <br>

        <a href="#" onClick="openhiswishCustom('<%=appUIDEnc("10x10yellow")%>');">openhiswishCustom:10x10yellow</a>

        <br>
        <br>

        <a href="#" onClick="openhiswishCustom('<%=appUIDEnc("10x10green")%>');">openhiswishCustom:10x10green</a>

        <br>
        <br>

        <a href="#" onClick="openhiswishCustom('<%=appUIDEnc("icommang")%>');">openhiswishCustom:icommang</a>

       <br>
        <br>
        <br>
        <br>
        urlEncode
        <br>
        <a href="#" onClick="opencategoryCustom('<%=server.URLEncode("cd1=103&nm1=캠핑/트래블")%>');">opencategoryCustom:('<%=server.URLEncode("cd1=103&nm1=캠핑/트래블")%>')</a>

        <br>
        <br>
        <a href="#" onClick="opencategoryCustom('<%=server.URLEncode("cd1=103&cd2=108&nm1=캠핑/트래블&nm2=아웃도어")%>');">opencategoryCustom:('<%=server.URLEncode("cd1=103&cd2=108&nm1=캠핑/트래블&nm2=아웃도어")%>')</a>

        <br>
        <br>
        <a href="#" onClick="opencategoryCustom('<%=server.URLEncode("cd1=103&cd2=108&cd3=102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭")%>');">opencategoryCustom:('<%=server.URLEncode("cd1=103&cd2=108&cd3=102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭")%>')</a>

        <br>
        <br>
        브랜드
        <br>
        <a href="#" class="product-brand" style="font-size:14px;line-height:16px;" onclick="FnGotoBrand('mmmg')">엠엠엠지</a>
        <br>
        <br>
        <a href="#" class="product-brand" style="font-size:14px;line-height:16px;" onclick="FnGotoBrand('2nul')">2nul</a>
        <br>
        <br>
        urlEncode 안함

        <br>
        <a href="#" onClick="opencategoryCustom('<%=("cd1=103&nm1=캠핑/트래블")%>');">opencategoryCustom:('cd1=103&nm1=캠핑/트래블')</a>

        <br>
        <br>
        <a href="#" onClick="opencategoryCustom('<%=("cd1=103&cd2=108&nm1=캠핑/트래블&nm2=아웃도어")%>');">opencategoryCustom:('cd1=103&cd2=108&nm1=캠핑/트래블&nm2=아웃도어')</a>

        <br>
        <br>
        <a href="#" onClick="opencategoryCustom('<%=("cd1=103&cd2=108&cd3=102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭")%>');">opencategoryCustom:('cd1=103&cd2=108&cd3=102&nm1=캠핑/트래블&nm2=아웃도어&nm3=배낭')</a>

        <br>
        <br>

        <a href="#" onClick="window.location.reload(true); return false;">### 페이지 새로고침</a>
        <br>
        <br>

        </div><!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			<a href="#" class="btn-top">top</a>
		</footer><!-- #footer -->
    </div><!-- wrapper -->
	<div id="modalCont" style="display:none;"></div>
    <script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>

    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
