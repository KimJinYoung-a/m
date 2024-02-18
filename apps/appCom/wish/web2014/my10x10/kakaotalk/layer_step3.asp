<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 카카오톡
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim sflow, chkCp
	sflow	= requestCheckVar(Request("flow"),3)
	chkCp	= requestCheckVar(Request("cp"),1)
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">

function doComplete() {
	setTimeout(function(){fnAPPopenerJsCallClose("pagereload()");}, 300);
	return false;
}

</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
		<!-- content area -->
		<div class="content kakaoService" id="contentArea">
			<h2><img src="http://fiximage.10x10.co.kr/m/2014/my10x10/txt_kakao_head.gif" alt="카카오톡 플러스친구 사용자 인증" /></h2>
			<div class="joinStep">
				<ol>
					<li class="on"><span>1</span>텐바이텐 인증</li>
					<li class="on"><span>2</span>카카오톡 인증</li>
					<li class="on"><span>3</span>신청완료</li>
				</ol>
			</div>
			<div class="inner5">
				<div class="box1">
					<div class="logoImg">
						<span><img src="http://fiximage.10x10.co.kr/m/2014/my10x10/logo_10x10.png" alt="10X10" /></span>
						<span><img src="http://fiximage.10x10.co.kr/m/2014/my10x10/logo_kakaotalk.png" alt="카카오톡" /></span>
					</div>
					<p class="finishMsg"><span><strong class="cRd1">카카오톡 맞춤정보 서비스</strong><br />신청이 완료되었습니다.</span></p>
					<p class="fs12 lh14">이제 카카오톡으로 텐바이텐의<br />다양한 서비스를 만나보실 수 있습니다.</p>
					<div class="btnWrap tMar30">
						<span class="button btB1 btRed cWh1 w50p"><a href="" onclick="doComplete(); return false;">확인</a></span>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->