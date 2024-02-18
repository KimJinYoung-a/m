<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 스냅스 사진을 보다가 MA_item페이지
' History : 2016.05.20 유태욱 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.popWin .content {padding-bottom:0;}
.snaps .app {background-color:#f9f9f9;}
.snaps .app ul {overflow:hidden; padding:0 13%;}
.snaps .app ul li {float:left; width:50%; padding:0 2%;}
.snaps .app .homepage {margin-top:12%;}

<% if isApp=1 then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.31"></script>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="http://itunes.apple.com/kr/app/id692816867";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="http://itunes.apple.com/kr/app/id692816867";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="http://itunes.apple.com/kr/app/id692816867";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=com.snaps.mobile.kr';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=com.snaps.mobile.kr';
	}
};
</script>
</head>
<body class="">
<div class="heightGrid">
	<div class="container popWin">
		<% if isApp=1 then %>
		<% else %>
			<div class="header">
				<h1>스냅스 포토북</h1>

				<% if isApp=1 then %>
					<p class="btnPopClose"><button onclick="fnAPPclosePopup(); return false;" class="pButton">닫기</button></p>
				<% else %>
					<p class="btnPopClose"><button onclick="self.close(); return false;" class="pButton">닫기</button></p>
				<% end if %>
			</div>
		<% end if %>

		<!-- content area -->
		<div class="content" id="contentArea">
		
			<div class="snaps">
				<div class="detail">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_item_detail_01.jpg" alt="스냅스 포토북은 모바일 전용상품으로 포토북 사이즈는 가로 6센치, 세로 6센치 입니다. 이렇게 사랑스러운 포토북을 본 적 있나요? 소중한 추억을 누구보다 예쁘게 간직하세요." /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_item_detail_02.jpg" alt="네모에 담는 추억 정사각형 포토북에 추억과 감성을 담으세요 사랑스러운 앨범 소장가치 100% 귀여운 6X6 사이즈예요" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_item_detail_03_v1.jpg" alt="책처럼 자연스러운 PUR 제본 접어서 보고, 휘어서 보아도 떨어짐 없이 튼튼해요" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_item_detail_04.jpg" alt="포토북의 퀄리티를 높여주는 Paper 잡지 표지처럼 가볍고 도톰한 소프트커버! 하드커버로 변경 시, 비용 추가됩니다. 벨벳처럼 부드럽고 매끄러운 느낌의  고급무광지 고급 수입용지 로 섬세한 인쇄, 우수한 보존성을 자랑하며, 예쁘고 다양한 디자인과 레이아웃" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_item_detail_05.jpg" alt="쿠폰 등록 방법은 스냅스앱을 실행 후 좌측 메뉴의 쿠폰관리에서 텐바이텐 쿠폰 선택 후 쿠폰번호를 등록하시면 됩니다." /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_item_detail_06.jpg" alt="포토북을 선택하고 원하는 디자인을 선택한 후, 6x6 사이즈 소프트커버 선택 합니다. 옵션 변경 및 페이지 추가 시 추가 비용 발생합니다. 편집 후 장바구니 담기 후 주문 결제 시, 쿠폰 적용을 하시면 쿠폰을 사용 하실 수 있습니다." /></p>
				</div>
		
				<!-- for dev msg : 앱에서 링크 확인해주세요 -->
				<div class="app">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/tit_snaps_app.png" alt="스냅스 앱 설치하기" /></h2>
					<ul>
						<li><a href="" onclick="gotoDownload(); return false;" title="iOS 앱스토어로 이동 새창"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_ios.png" alt="앱스토어" /></a></li>
						<li><a href="" onclick="gotoDownload(); return false;" title="안드로이드 구글플레이로 이동 새창"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_andriod.png" alt="구글 플레이" /></a></li>
					</ul>
		
					<div class="homepage">
						<% if isapp then %>
							<a href="" onclick="fnAPPpopupExternalBrowser('http://www.snaps.kr');return false;" title="새창">
						<% else %>
							<a href="http://www.snaps.kr?utm_source=tmon&utm_medium=sc&utm_campaign=1605+10x10" target="_blank" title="새창">
						<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_homepage.png" alt="스냅스 홈페이지 바로가기" />
						</a>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>