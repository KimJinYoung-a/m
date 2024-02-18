<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description :  이벤트코드 65671(m/a) MY DREAM HOUSE
' History : 2015.08.27 
'####################################################
Dim oEventid : oEventid = Trim(request("eventid"))
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
	function chgBA(v){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+v;	//앱영역 스크립트
		}else{
			parent.location.href="/event/eventmain.asp?eventid="+v;	//모바일영역 스크립트
		}
	}
</script>
<style type="text/css">
.navigator {height:50px; padding:10px; background-color:#fff;}
.navigator:after {content:' '; display:block; clear:both;}
.navigator strong, .navigator select {float:left; height:30px; font-size:14px; line-height:30px; font-weight:bold;}
.navigator strong {position:relative; width:49%;}
.navigator strong:after {content:' '; position:absolute; top:9px; right:2px; width:2px; height:10px; background-color:#e9cdc6;}
.navigator select {width:51%; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65671/m/bg_select_arrow.png) no-repeat 100% 50%; background-size:23px auto; color:#f7937a;}

/* 이벤트 코드별 스타일 변경되는 부분입니다. */
<% If oEventid="65779" Then %>
.navigator strong:after {background-color:#e3e3e3;}
.navigator select {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/65779/m/bg_select_arrow.png); color:#75c1d0;}
<% End If %>
<% If oEventid="65919" Then %>
.navigator strong:after {background-color:#ffeeb9;}
.navigator select {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/65919/m/bg_select_arrow.png); color:#fdc041;}
<% End If %>
<% If oEventid="66036" Then %>
.navigator strong:after {background-color:#dbebe5;}
.navigator select {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66036/m/bg_select_arrow.png); color:#7accba;}
<% End If %>

@media all and (min-width:360px){
	.navigator strong, .navigator select {height:32px; font-size:16px; line-height:32px;}
	.navigator strong:after {height:12px;}
}

@media all and (min-width:480px){
	.navigator {height:65px;}
	.navigator strong, .navigator select {height:45px; font-size:21px; line-height:45px;}
	.navigator strong:after {top:13px; height:16px;}
}
</style>
</head>
<body>
<div class="navigator">
	<strong>MY DREAM HOUSE</strong>
	<select title="MY DREAM HOUSE 선택 옵션" onchange="chgBA(this.value);">
		<option value="65671" <%=CHKIIF(oEventid="65671","selected","")%>>01. KITCHEN</option>
		<% If Now() > #08/31/2015 00:00:00# Then %>
			<option value="65779" <%=CHKIIF(oEventid="65779","selected","")%>>02. LIBRARY ROOM</option>
		<% Else %>
			<option value="65779" disabled="disabled">02. LIBRARY ROOM</option>
		<% End If %>
		
		<% If Now() > #09/07/2015 00:00:00# Then %>
			<option value="65919" <%=CHKIIF(oEventid="65919","selected","")%>>03. BEDROOM</option>
		<% Else %>
			<option value="65919" disabled="disabled">03. BEDROOM</option>
		<% End If %>

		<% If Now() > #09/14/2015 00:00:00# Then %>
			<option value="66036" <%=CHKIIF(oEventid="66036","selected","")%>>04. LIVING ROOM</option>
		<% Else %>
			<option value="66036" disabled="disabled">04. LIVING ROOM</option>
		<% End If %>
	</select>
</div>
</body>
</html>