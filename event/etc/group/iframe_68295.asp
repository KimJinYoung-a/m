<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description :  이벤트코드 58690(www) 책시리즈 모바일버전
' History : 2016.01.05 진연미 생성
'####################################################
Dim oEventid : oEventid = Trim(request("eventid"))
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.selectMonth {padding:7px 6px;}
.selectMonth select {width:100%; border-radius:0; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/65469/blt_arrow.gif) no-repeat 97% 50%; background-size:22px 22px; color:#000; font-weight:bold;}
@media all and (min-width:480px){
	.selectMonth {padding:11px 9px;}
	.selectMonth select {background-size:33px 33px;}
}
</style>
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
<div class="selectMonth">
	<select onchange="chgBA(this.value);">
	<% If Now() > #01/26/2015 00:00:00# Then %><option value="68295" <% if oEventid = "68295" then response.write "selected" end if %>>Jewelry Report : JANUARY</option><% End If %>
	<% If Now() > #02/03/2016 00:00:00# Then %><option value="68812" <% if oEventid = "68812" then response.write "selected" end if %>>Jewelry Report : FEBRUARY</option><% End If %>
	<% If Now() > #03/09/2016 00:00:00# Then %><option value="69172" <% if oEventid = "69172" then response.write "selected" end if %>>Jewelry Report : MARCH</option><% End If %>
	<% If Now() > #04/06/2016 00:00:00# Then %><option value="69868" <% if oEventid = "69868" then response.write "selected" end if %>>Jewelry Report : APRIL</option><% End If %>
	<% If Now() > #05/04/2016 00:00:00# Then %><option value="70301" <% if oEventid = "70301" then response.write "selected" end if %>>Jewelry Report : MAY</option><% End If %>
	<% If Now() > #06/01/2016 00:00:00# Then %><option value="70821" <% if oEventid = "70821" then response.write "selected" end if %>>Jewelry Report : JUNE</option><% End If %>
	<% If Now() > #07/06/2016 00:00:00# Then %><option value="71551" <% if oEventid = "71551" then response.write "selected" end if %>>Jewelry Report : JULY</option><% End If %>
	<% If Now() > #08/03/2016 00:00:00# Then %><option value="72168" <% if oEventid = "72168" then response.write "selected" end if %>>Jewelry Report : AUGUST</option><% End If %>
	<% If Now() > #09/07/2016 00:00:00# Then %><option value="72886" <% if oEventid = "72886" then response.write "selected" end if %>>Jewelry Report : SEPTEMBER</option><% End If %>
	<% If Now() > #10/05/2016 00:00:00# Then %><option value="73361" <% if oEventid = "73361" then response.write "selected" end if %>>Jewelry Report : OCTOBER</option><% End If %>
	<% If Now() > #11/02/2016 00:00:00# Then %><option value="73952" <% if oEventid = "73952" then response.write "selected" end if %>>Jewelry Report : NOVEMBER</option><% End If %>
	<% If Now() > #11/30/2016 00:00:00# Then %><option value="74649" <% if oEventid = "74649" then response.write "selected" end if %>>Jewelry Report : DECEMBER</option><% End If %>
	</select>
</div>

