<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "UTF-8"
%>
<%
'#######################################################
'	History	:  2012.02.01 김진영 생성
'	History	:  2014.06.16 이종화 생성 
'	Description : 카카오톡 링크공유
'	Description : 카카오톡 링크공유 ver 3.5 (앱용 // 바로 앱을 띄우는건 안드로이드만 됐음 아이폰은 차후 업데이트 이후)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim chk, code, strTgtUrl
chk = request("chk")
code = request("code")

If chk = "" or code = "" Then
	Call Alert_Close("올바른 접근이 아닙니다.")
	Response.End
End If

'// 전송할 URL생성
Select Case chk
	Case "item"
		strTgtUrl = "http://10x10.co.kr/" & code
	Case "event"
		strTgtUrl = "http://10x10.co.kr/evt/" & code
	Case "culture"
		strTgtUrl = "http://10x10.co.kr/culture/" & code
	Case "etc"
		strTgtUrl = code
	Case Else
		strTgtUrl = "http://10x10.co.kr/" & code
End Select
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 카카오톡 링크공유</title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script>

	Kakao.init('c967f6e67b0492478080bcf386390fdd'); //appcode

	function trim(txt) {
		return txt.replace(/(^\s*)|(\s*$)/g, "");
	}

	function sendlink(){

		var msg = document.getElementById('kakaomsg').value;

		if(trim(msg) == ''){
			alert('메세지를 작성하세요');
			document.getElementById('kakaomsg').value="";
			document.getElementById('kakaomsg').focus();
			return;
		}

		//기존 버전 대체용 2.0 -> 3.5 ver
		Kakao.Link.sendTalkLink({
			  label: '[텐바이텐]\n'+msg+'\n\n',
			  webLink: {
				text: '<%=strTgtUrl%>',
				url: '<%=strTgtUrl%>' // 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
			  }
		});

	}
	</script>
</head>
<body>
<div class="heightGrid" id="main">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--마이텐바이텐-->
				<div class="prevPage">
					<a href="javascript:window.close();"><em class="elmBg">이전으로</em></a>
				</div>
				<div class="innerH15W10">
					<h2>카카오톡 링크공유</h2>
				</div>

				<div class="innerW">
					<textarea name="kakaomsg" id="kakaomsg" cols="" rows="" style="width:98%; height:80px;"></textarea>
				</div>

				<div class="bgGry2 inner tMar10">
					<p class="b c555 ftMidSm2">카카오톡 친구에게 링크 공유하는 방법!</p>
					<ul class="txtList tMar05">
						<li class="elmBg3 c999">메세지 작성 후 '확인' 버튼을 누릅니다.</li>
						<li class="elmBg3 c999">메세지 보낼 친구를 선택 후 '완료'를 누르면 메세지 전송 완료!</li>
					</ul>
				</div>

				<div class="ct tMar10 bPad20">
					<span class="btn btn1 gryB w100B"><a href="javascript:window.close();">취소</a></span>
					<span class="btn btn1 redB w100B"><a href="javascript:sendlink();" id="kakao">확인</a></span>
				</div>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->