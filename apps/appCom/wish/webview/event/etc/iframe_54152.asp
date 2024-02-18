<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : Oh~My baby! - app
' History : 2014.08.11 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim eCode, cnt, sqlStr, regdate, gubun,  i, totalsum
	Dim iCTotCnt , iCPageSize

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21266"
	Else
		eCode 		= "54152"
	End If
'
'	Response.write request.cookies("rdsite") & "<br/>"
'	Response.write "aaaaa" &"<br/>"
'	Response.write request("") &"<br/>"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 내가 SNS에서 제일 잘 나가</title>
<style type="text/css">
.mEvt54152 {position:relative;}
.mEvt54152 img {vertical-align:top; width:100%;}
.mEvt54152 p {max-width:100%;}
.mEvt54152 .snsShare {overflow:hidden;}
.mEvt54152 .snsShare li {float:left; width:25%;}
.momsInput {background-color:#ffe0e8; position:relative;}
.momsInput p {position:absolute;}
.momsInput .idInput {left:15%; top:51%; width:39%; height:13.5%;}
.momsInput .idInput input {border:none; background-color:transparent; font-weight:bold; -webkit-appearance:none; -webkit-border-radius:0; outline-style:none;}
.momsInput .btn {right:10%; top:7%; width:28%;}
@media all and (min-width:480px) {
	.momsInput .idInput input {font-size:24px;}
}
</style>
<script type="text/javascript">

function checkform(frm) {
	<% if datediff("d",date(),"2014-08-23")>=0 then %>
		if (frm.evtopt3.value == "")
		{
			alert("맘스다이어리 회원 ID를 입력해주세요");
			frm.evtopt3.focus();
			document.frm.evtopt3.value = "";
			return false;
		}
	
		frm.action = "/apps/appcom/wish/webview/event/etc/doEventSubscript54152.asp";
		return true;
	<% else %>
		alert('이벤트가 종료되었습니다.');
		return;
	<% end if %>
	}
</script>
</head>
<body>
<div class="mEvt54152">
	<div class="section">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img01.png" alt="텐바이텐에 오신 걸 환영합니다." /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img02.png" alt="Oh! My Baby!" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img03.png" alt="오직 맘스다이어리 회원들께만 드리는 시크릿 혜택!" /></p>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img04.png" alt="3가지 시크릿 혜택" /></h3>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img05.png" alt="혜택 하나" /></p>
		<p><a href="http://m.10x10.co.kr/apps/appcom/wish/webview/category/category_itemprd.asp?itemid=1096325&disp=115105102" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img06.png" alt="혜택 둘" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img07.png" alt="혜택 셋" /></p>
		<p><a href="http://m.10x10.co.kr/apps/appcom/wish/webview/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_btn.png" alt="텐바이텐 회원가입 하기" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img08.png" alt="텐바이텐 회원가입을 하신 분에 한해 지급되며 3만원 이상 구매시 사용 가능합니다." /></p>
	</div>
	<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="page" value="">
	<div class="section momsInput">
		<p class="idInput"><input type="text" style="width:100%; height:100%;" name="evtopt3"/></p>
		<p class="btn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_btn2.png" alt="인증받고 응모하기" width="100%" /></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_bg_input.png" alt="맘스다이어리 ID 입력하기" /></div>
	</div>
	</form>
	<%
		'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
		dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
		snpTitle = Server.URLEncode("[맘스다이어리] Oh~! My Baby!")
		snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode)
		snpPre = Server.URLEncode("텐바이텐 이벤트 [맘스다이어리] Oh~! My Baby!")
		'노출 썸네일 이미지
		snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2014/54152/kakao_event_banner_54152.jpg")
		snpTag = Server.URLEncode("텐바이텐 [맘스다이어리] Oh~! My Baby!")
		snpTag2 = Server.URLEncode("#10x10")

	%>
	<ul class="snsShare">
		<li><a href="#" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_sns1.png" alt="트위터 공유하기" /></a></li>
		<li><a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_sns2.png" alt="페이스북 공유하기" /></a></li>
		<li><a id="kakaoa" href="javascript:;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_sns3.png" alt="카카오톡 공유하기" /></a></li>
		<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
		<script>
			//카카오 SNS 공유
			Kakao.init('c967f6e67b0492478080bcf386390fdd');

			// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
			Kakao.Link.createTalkLinkButton({
			  //1000자 이상일경우 , 1000자까지만 전송 
			  //메시지에 표시할 라벨
			  container: '#kakaoa',
			  label: '[텐바이텐 EVENT]\n오직 맘스 다이어리 고객에만 드리는 3가지 시크릿 혜택!',
			  image: {
				//500kb 이하 이미지만 표시됨
				src: 'http://webimage.10x10.co.kr/eventIMG/2014/54152/kakao_event_banner_54152.jpg',
				width: '300',
				height: '200'
			  },
			  appButton: {
				text: '북포인트받기',
				execParams :{
					android : {"url": encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= ecode %>&rdsite=moms')},
					iphone : {"url": "http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= ecode %>&rdsite=moms"}
				}
			  },
			  installTalk : Boolean
			});
		</script>
		<li><a href="#" onclick="pinit('<%=snpLink%>','<%=snpImg%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_sns4.png" alt="핀터레스트 공유하기" /></a></li>
	</ul>
	<div class="section">
		<p><a href="http://m.10x10.co.kr/apps/appcom/wish/webview/event/eventmain.asp?eventid=54095&rdsite=moms" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img09.png" alt="뽀로로부터 타요까지 베이비/키즈 기획전 확인하러가기" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54152/54152_img10.png" alt="이벤트 안내" /></p>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->