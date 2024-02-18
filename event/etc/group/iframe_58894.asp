<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description :  이벤트코드 58690(www) 책시리즈 모바일버전
' History : 2015.08.03 유태욱 생성
'####################################################
Dim oEventid : oEventid = Trim(request("eventid"))
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.selectMonth {padding:7px 6px;}
.selectMonth select {width:100%;}
@media all and (min-width:480px){
	.selectMonth {padding:11px 9px;}
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
	<% If Now() > #01/26/2015 00:00:00# Then %><option value="58894" <% if oEventid = "58894" then response.write "selected" end if %>>1월의 책 : GRE, 그래!</option><% End If %>
	<% If Now() > #02/16/2015 00:00:00# Then %><option value="59507" <% if oEventid = "59507" then response.write "selected" end if %>>2월의 책 : Before after</option><% End If %>
	<% If Now() > #08/03/2015 00:00:00# Then %><option value="65318" <% if oEventid = "65318" then response.write "selected" end if %>>3월의 책 : 우주 우표책</option><% End If %>
	<% If Now() > #04/27/2015 00:00:00# Then %><option value="61764" <% if oEventid = "61764" then response.write "selected" end if %>>4월의 책 : 우리가족 평균연령 60세!</option><% End If %>
	<% If Now() > #05/02/2015 00:00:00# Then %><option value="62769" <% if oEventid = "62769" then response.write "selected" end if %>>5월의 책 : COLOR THIS BOOK</option><% End If %>
	<% If Now() > #06/17/2015 00:00:00# Then %><option value="63721" <% if oEventid = "63721" then response.write "selected" end if %>>6월의 책 : HOW OLD ARE YOU</option><% End If %>
	<% If Now() > #07/31/2015 00:00:00# Then %><option value="65128" <% if oEventid = "65128" then response.write "selected" end if %>>7월의 책 : 이환천의 문학살롱</option><% End If %>
	<% If Now() > #08/12/2015 00:00:00# Then %><option value="65362" <% if oEventid = "65362" then response.write "selected" end if %>>8월의 책 : 반 고흐</option><% End If %>
	<% If Now() > #09/23/2015 00:00:00# Then %><option value="66270" <% if oEventid = "66270" then response.write "selected" end if %>>9월의 책 : 케이트와 고양이의 ABC</option><% End If %>
	<% If Now() > #10/27/2015 00:00:00# Then %><option value="67604" <% if oEventid = "67604" then response.write "selected" end if %>>10월의 책 : 주말클렌즈</option><% End If %>
	<% If Now() > #11/25/2015 00:00:00# Then %><option value="67355" <% if oEventid = "67355" then response.write "selected" end if %>>11월의 책 : 상상고양이</option><% End If %>
	<% If Now() > #12/30/2015 00:00:00# Then %><option value="68253" <% if oEventid = "68253" then response.write "selected" end if %>>12월의 책 : 갱상도 사투리 배우러 들온나</option><% End If %>
	</select>
</div>

