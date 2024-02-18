<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : app 다운로드(쿠폰이벤트)
' History : 2014-09-30 이종화
'			2016-01-19 이종화 리뉴얼
'           2017-09-18 허진원 리뉴얼
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim eCode, cnt, sqlStr
	dim	couponid
	Dim logStore : logStore = requestCheckVar(Request("store"),16)
	Dim itemordercheck
	itemordercheck = True  '// 구매이력 있음
	Dim userid : userid = getloginuserid()
	
	strHeadTitleName = "이벤트"

	If logStore <> "" And Len(logstore) = 1 Then '// log입력
		sqlStr = " insert into db_temp.dbo.tbl_log_appdown_store (store) values ('"&logStore&"')"
		dbget.Execute sqlStr
	End If 

	IF application("Svr_Info") = "Dev" THEN
		couponid   =  2761 '2016년
	Else
		couponid   =  1060 '2018년
	End If

	If IsUserLoginOK Then
		'쿠폰 발급 여부 확인
		sqlStr = " Select count(*) as cnt " &VBCRLF
		sqlStr = sqlStr & " From [db_user].dbo.tbl_user_coupon " &VBCRLF
		sqlStr = sqlStr & " WHERE  masteridx = " & couponid & "" &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "'"
		rsget.Open sqlStr,dbget,1
			cnt=rsget(0)
		rsget.Close
	End If

	'// 구매 이력 유무
	itemordercheck = fnUserGetOrderCheck(userid,"APP")
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 텐바이텐 APP 다운로드</title>
<style type="text/css">
.appDown {}
.appDown button {background-color:transparent;}
.topic {position:relative;}
.btnDown {position:absolute; left:0; bottom:10%; width:100%;}
.sns {position:relative; margin-top:-15vw;}
.sns ul {overflow:hidden; position:absolute; bottom:22%; left:50%; width:90%; margin-left:-45%;}
.sns ul li {float:left; width:25%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 5%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
</style>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		fnAmplitudeEventMultiPropertiesAction('click_appdown','devicetype','iphone');
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		fnAmplitudeEventMultiPropertiesAction('click_appdown','devicetype','ipad');
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		fnAmplitudeEventMultiPropertiesAction('click_appdown','devicetype','ipod');
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		fnAmplitudeEventMultiPropertiesAction('click_appdown','devicetype','android');
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	} else { //그 외
		fnAmplitudeEventMultiPropertiesAction('click_appdown','devicetype','etc');
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	}
};

<!--
	function checkform(frm) {
	<% If IsUserLoginOK Then %>
		<% If cnt > 0 Then %>
				alert('ID당 1회 발급 사용 가능합니다.');
				return false;
		<% else %>
				<%'// 앱 구매 이력이 없을경우 %>
				<% if not(itemordercheck) then %>
					fnAmplitudeEventMultiPropertiesAction('click_appdown_coupon','','');
					frm.action = "doEventSubscript_appdown.asp";
					frm.submit();
				<% else %>
					alert('죄송합니다.\nAPP에서 구매 이력이 없으신 고객을 위한 이벤트 입니다.');
					return;
				<% end if %>
		<% end if %>
	<% Else %>
		if(confirm("로그인 후에 응모하실 수 있습니다.")) {
			self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		}
	<% End If %>
	}	
//-->
</script>
</head>
<body>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content">
		<!-- 이벤트 배너 등록 영역 -->
		<div class="evtContV15">

			<div class="appDown">
				<section class="topic">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/tit_tenten_app.jpg" alt="텐바이텐 APP - 지금 텐바이텐 앱 다운받고 다양한 혜택 받으세요" /></h2>
					<a href="" onclick="gotoDownload(); return false;" class="btnDown"><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/btn_down.png" alt="APP 다운받기" /></a>
				</section>

				<form name="frm" method="POST" style="margin:0px;">
				<section class="topic" style="display:none;">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/img_coupon_v2.png" alt="신규설치 시 앱전용 3천원쿠폰 즉시 지급! 3천원 앱 쿠폰! 3만원 이상 구매시 사용가능합니다. 단, 다운로드 후 24시간 이내에 사용하셔야 하며, 아이디당 1회 사용가능합니다." /></p>
					<button type="button" onclick="checkform(frm);" class="btnDown"><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/btn_coupon_v2.png" alt="쿠폰 다운받기" /></button>
				</section>
				</form>

				<%
					'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
					dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
					snpTitle = Server.URLEncode("텐바이텐 APP 다운 이벤트")
					snpLink = Server.URLEncode("http://m.10x10.co.kr/event/appdown/")
					snpPre = Server.URLEncode("텐바이텐 이벤트")
					snpTag = Server.URLEncode("텐바이텐 APP 다운 이벤트")
					snpTag2 = Server.URLEncode("#10x10")
					snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2016/app/m/img_kakao.png")
				%>
				<section class="sns">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/img_sns.png" alt="텐바이텐 APP을 친구들에게 공유해주세요!" /></p>
					<ul>
						<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); fnAmplitudeEventMultiPropertiesAction('click_appdown_share','type','facebook'); return false;"><span></span>페이스북</a></li>
						<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); fnAmplitudeEventMultiPropertiesAction('click_appdown_share','type','twitter'); return false;"><span></span>트위터</a></li>
						<li><a href="javascript:;" onclick="fnAmplitudeEventMultiPropertiesAction('click_appdown_share','type','kakao');return false;" id="kakaoa"><span></span>카카오톡</a></li>
						<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
						<script>
							Kakao.init('c967f6e67b0492478080bcf386390fdd');
							Kakao.Link.createTalkLinkButton({
							  container: '#kakaoa',
							  label: '모바일에서도 10X10을 만나세요',
							  image: {
								src: 'http://webimage.10x10.co.kr/eventIMG/2016/app/m/img_kakao.png',
								width: '200',
								height: '200'
							  },
							  webButton: {
								text: '10x10 APP 다운 바로가기',
								url: 'http://m.10x10.co.kr/event/appdown/'
							  }
							});
						</script>
						<li><a href="" onclick="pinit('<%=snpLink%>','<%=snpImg%>'); fnAmplitudeEventMultiPropertiesAction('click_appdown_share','type','pinterest'); return false;"><span></span>핀터레스트</a></li>
					</ul>
				</section>
			</div>

		</div>
		<!--// 이벤트 배너 등록 영역 -->
	</div>
	<!-- //contents -->

	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->