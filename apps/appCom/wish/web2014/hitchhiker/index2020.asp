<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 히치하이커 메인 페이지
' History : 2021-01-12 임보라 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "히치하이커"
End if

dim appVersion, VuserAgent, vs
VuserAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
appVersion = mid(VuserAgent, Instr(VuserAgent,"tenapp")+8, 5)
vs = getAppVersion()
' response.write appVersion & "<br>"
' response.write vs & "<br>"
' if Instr(VuserAgent,"tenapp i") > 0 then
' 	response.write "ios"
' elseif Instr(VuserAgent,"tenapp a") > 0 then
' 	response.write "android"
' end if

dim hflag : hflag = RequestCheckVar(request("hflag"),1)
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<link rel="stylesheet" type="text/css" href="/lib/css/hitchhiker.css?v=1.0">
<style>
.hitchhiker .tab_nav.fixed .tab_list {top:0;}

<% If hflag = "1" Then %>
/* 플로팅 투명 헤더일 때만 */
.modal_type4 .modal_wrap {height:calc(93vh - 30px);}

/* Android */
.hitchhiker > .topic {height:calc(52.9rem + 48px);}
.hitchhiker .topic .bnr_addr {top:calc(1.37rem + 48px);}
.hitchhiker .tab_nav.fixed .tab_list {top:48px;}
/* iOS */
@supports (-webkit-overflow-scrolling: touch) {
	.hitchhiker > .topic {height:calc(52.9rem + 68px);}
	.hitchhiker .topic .bnr_addr {top:calc(1.37rem + 68px);}
	.hitchhiker .tab_nav.fixed .tab_list {top:68px;}
}
/* iphoneX */
@media only screen and (device-width : 375px) and (device-height : 812px) and (-webkit-device-pixel-ratio : 3) {
	.hitchhiker > .topic {height:calc(52.9rem + 88px);}
	.hitchhiker .topic .bnr_addr {top:calc(1.37rem + 88px);}
	.hitchhiker .tab_nav.fixed .tab_list {top:88px;}
}
/* iphoneXs Max , iphoneXr */
@media only screen and (device-width : 414px) and (device-height : 896px) {
	.hitchhiker > .topic {height:calc(52.9rem + 88px);}
	.hitchhiker .topic .bnr_addr {top:calc(1.37rem + 88px);}
	.hitchhiker .tab_nav.fixed .tab_list {top:88px;}
}
<% End If %>
</style>
</head>
<body class="<% If hflag = "1" Then %>hflag<% End If %>">
	<% server.Execute("/hitchhiker/exc_main.asp") %>
</body>
</html>