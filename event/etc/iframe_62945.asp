<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description :  ## 10x10 SUMMER BRAND AWARD
' History : 2015-05-22 유태욱 생성
'####################################################

Dim oEventid : oEventid = Trim(request("eventid"))

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
function chgBA(v){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+v;	//앱영역 스크립트
	}else{
		parent.location.href="/event/eventmain.asp?eventid="+v;	//모바일영역 스크립트
	}
}
</script>
<style>
.selectBrand {height:50px; padding:0 5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/brandaward/m/bg_select_area.gif) no-repeat 0 0 #68d0fd; background-size:100% auto;}
.selectBrand select {display:inline-block; width:100%; height:32px; padding:0 20px; border:0; color:#fff; font-weight:bold; border-radius:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/brandaward/m/blt_arrow.png) no-repeat 95% 50% #057ac3; background-size:8px 8px;}
@media all and (min-width:480px){
	.selectBrand select {height:48px;}
}
</style>
</head>
<body>
<div class="selectBrand">
	<select onchange="chgBA(this.value);">
		<% If Now() > #05/22/2015 00:00:00# Then %><option value="62945" <% if oEventid = "62945" then response.write "selected" end if %>>05.26(화) | BLOOMING&amp;ME</option><% End If %>
		<% If Now() > #05/27/2015 00:00:00# Then %><option value="63015" <% if oEventid = "63015" then response.write "selected" end if %>>05.27(수) | BO WELL</option><% End If %>
		<% If Now() > #05/28/2015 00:00:00# Then %><option value="63049" <% if oEventid = "63049" then response.write "selected" end if %>>05.28(목) | INSTAX</option><% End If %>
		<% If Now() > #05/29/2015 00:00:00# Then %><option value="63104" <% if oEventid = "63104" then response.write "selected" end if %>>05.29(금) | MONOPOLY</option><% End If %>
		<% If Now() > #06/01/2015 00:00:00# Then %><option value="63135" <% if oEventid = "63135" then response.write "selected" end if %>>06.01(월) | LAUNDRY.MAT</option><% End If %>
		<% If Now() > #06/02/2015 00:00:00# Then %><option value="63207" <% if oEventid = "63207" then response.write "selected" end if %>>06.02(화) | I THINK SO</option><% End If %>
		<% If Now() > #06/03/2015 00:00:00# Then %><option value="63263" <% if oEventid = "63263" then response.write "selected" end if %>>06.03(수) | TEVA</option><% End If %>
		<% If Now() > #06/04/2015 00:00:00# Then %><option value="63019" <% if oEventid = "63019" then response.write "selected" end if %>>06.04(목) | MORIDAIN</option><% End If %>
		<% If Now() > #06/05/2015 00:00:00# Then %><option value="63185" <% if oEventid = "63185" then response.write "selected" end if %>>06.05(금) | PLAYMOBIL</option><% End If %>
		<% If Now() > #06/08/2015 00:00:00# Then %><option value="63455" <% if oEventid = "63455" then response.write "selected" end if %>>06.08(월) | ICONIC</option><% End If %>
		<% If Now() > #06/09/2015 00:00:00# Then %><option value="63464" <% if oEventid = "63464" then response.write "selected" end if %>>06.09(화) | IRIVER</option><% End If %>
		<% If Now() > #06/10/2015 00:00:00# Then %><option value="63605" <% if oEventid = "63605" then response.write "selected" end if %>>06.10(수) | KOKACHARM</option><% End If %>
		<% If Now() > #06/11/2015 00:00:00# Then %><option value="63640" <% if oEventid = "63640" then response.write "selected" end if %>>06.11(목) | TATTLY</option><% End If %>
		<% If Now() > #06/12/2015 00:00:00# Then %><option value="63657" <% if oEventid = "63657" then response.write "selected" end if %>>06.12(금) | MARTHA IN THE GARRET</option><% End If %>
	</select>
</div>
</html>