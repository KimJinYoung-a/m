<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description :  이벤트코드 75327 주얼리 스토리 버전
' History : 2017. 02. 02 김송이 생성
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
	<% If Now() > #01/04/2017 00:00:00# Then %><option value="75327" <% if oEventid = "75327" then response.write "selected" end if %>>Jewelry Story : JANUARY</option><% End If %>
	<% If Now() > #02/08/2017 00:00:00# Then %><option value="76019" <% if oEventid = "76019" then response.write "selected" end if %>>Jewelry Story : FEBRUARY</option><% End If %>
	<% If Now() > #03/08/2017 00:00:00# Then %><option value="76532" <% if oEventid = "76532" then response.write "selected" end if %>>Jewelry Story : MARCH</option><% End If %>
	<% If Now() > #04/05/2017 00:00:00# Then %><option value="77138" <% if oEventid = "77138" then response.write "selected" end if %>>Jewelry Story : APRIL</option><% End If %>
	<% If Now() > #05/10/2017 00:00:00# Then %><option value="77778" <% if oEventid = "77778" then response.write "selected" end if %>>Jewelry Story : MAY</option><% End If %>
	<% If Now() > #06/08/2017 00:00:00# Then %><option value="78363" <% if oEventid = "78363" then response.write "selected" end if %>>Jewelry Story : JUNE</option><% End If %>
	<% If Now() > #07/05/2017 00:00:00# Then %><option value="0000" <% if oEventid = "0000" then response.write "selected" end if %>>Jewelry Story : JULY</option><% End If %>
	<% If Now() > #08/02/2017 00:00:00# Then %><option value="0000" <% if oEventid = "0000" then response.write "selected" end if %>>Jewelry Story : AUGUST</option><% End If %>
	<% If Now() > #09/06/2017 00:00:00# Then %><option value="0000" <% if oEventid = "0000" then response.write "selected" end if %>>Jewelry Story : SEPTEMBER</option><% End If %>
	<% If Now() > #10/04/2017 00:00:00# Then %><option value="0000" <% if oEventid = "0000" then response.write "selected" end if %>>Jewelry Story : OCTOBER</option><% End If %>
	<% If Now() > #11/01/2017 00:00:00# Then %><option value="0000" <% if oEventid = "0000" then response.write "selected" end if %>>Jewelry Story : NOVEMBER</option><% End If %>
	<% If Now() > #12/06/2017 00:00:00# Then %><option value="0000" <% if oEventid = "0000" then response.write "selected" end if %>>Jewelry Story : DECEMBER</option><% End If %>
	</select>
</div>
</div>

