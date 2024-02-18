<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : app 다운로드(쿠폰이벤트)
' History : 2014.07.01 이종화
'###########################################################

	dim eCode, cnt, sqlStr
	dim	couponid

	IF application("Svr_Info") = "Dev" THEN
		couponid   =  340
	Else
		''couponid   =  615	'7월
		couponid   =  622	'8월
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

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐 모바일앱 출시!</title>
<style type="text/css">
	.mEvt50401 {padding-bottom:7.7%;}
	.mEvt50401 p {max-width:100%;}
	.mEvt50401 img {vertical-align:top;}
	.tentenApp img {width:100%;}
	.tentenApp .tentenAppMsg {padding:0 8%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50401/bg_box.gif) left top repeat-y; background-size:100% auto;}
	.tentenApp .tentenAppMsg p {padding-bottom:15px; font-size:12px; line-height:1.25em; text-align:left;}
	.july2014 {position:relative;}
	.july2014 a {display:block; position:absolute; left:0; bottom:10%; width:100%;}
</style>
<script type="text/javascript">
	function wishAppDown() {
		var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
			isAndroid = navigator.userAgent.match('Android');

		if ( isiOS ) {
			var fallbackLink = isAndroid ? 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>' :
										 'https://itunes.apple.com/kr/app/id864817011' ;
			window.setTimeout(function (){ window.location.replace(fallbackLink); }, 25);

		} else if ( isAndroid ){
			
			var tmpurl = 'intent://http//m.10x10.co.kr/apps/appcom/wish/webview/today/#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>;end';
			parent.top.document.location.href = tmpurl;

		} else {
			alert("안드로이드 또는 IOS 기기만 지원합니다.");
		}
	}
</script>
<script>
<!--
	function checkform(frm) {
	<% if datediff("d",date(),"2014-08-01")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% If cnt > 0 Then %>
					alert('ID당 1회 발급 사용 가능합니다.');
					return false;
			<% else %>
					frm.action = "doEventSubscript50401.asp";
					frm.submit();
			<% end if %>
		<% Else %>
   			parent.jsevtlogin();;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}	
//-->
</script>
</head>
<body>
	<!-- 텐바이텐 모바일앱 출시! -->
	<div class="mEvt50401">
		<div class="tentenApp">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/tit_tenten_app.jpg" alt="텐바이텐 모바일 앱 출시! 모바일로 더욱 손쉽게 만나는 텐바이텐 스마트폰에서 즐거운 쇼핑라이프를 즐겨보세요!" /></h2>
			<!-- 2014 07월 이벤트 -->
			<!-- <form name="frm" method="POST" style="margin:0px;">
			<div class="july2014">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/img_app_event_201407.png" alt="7월, 한 여름 밤의 꿈같은 혜택" /></p>
				<a href="javascript:checkform(frm);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/btn_coupon_download_201407.png" alt="7월, 한 여름 밤의 꿈같은 혜택" /></a>
			</div>
			</form> -->
			<!--// 2014 07월 이벤트 -->
			<div class="btnDownload">
				<a href="#" onclick="wishAppDown()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/btn_app_download_tenbyten.jpg" onClick="goog_report_conversion(http://m.10x10.co.kr/event/etc/app_down.asp?ref=gap);" alt="텐바이텐 앱 다운로드" /></a>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/txt_tenten_app_andriod_msg.jpg" alt="iOS 기종을 쓰시는 고객님은 앱스토어에서 안드로이드 기종을 쓰시는 고객님은 구글플레이에서 ‘텐바이텐’을 검색해주세요" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/txt_tenten_app_03.jpg" alt="텐바이텐을 모바일로 간편하게 만나는 방법! 텐바이텐 모바일 앱과 함께 하세요!" /></p>
			<div class="tentenAppMsg">
				<p>대한민국 감성 디자인 쇼핑몰 분야를 탄생시킨 <br />
				텐바이텐(10x10.co.kr) 앱이 드디어 출시되었습니다. <br /></p>
				<p>텐바이텐은 2001년 국내 최초로 디자인 소품 쇼핑몰을<br />
						탄생시키며 쇼핑 트렌드를 리드한 1등 디자인 쇼핑몰입니다.<br /></p>
				<p>디자인문구, 디지털, 핸드폰, 캠핑, 트래블, 토이, 가구, <br />
				인테리어, 패션, 뷰티, 키즈, 베이비, 강아지, 고양이까지 <br />
				다양한 카테고리를 10x10 감성으로 확장한 <br /> 
				텐바이텐 모바일 쇼핑 앱을 언제 어디서나 만나실 수 있습니다.<br /></p>
				<p>이벤트, 할인, 주문 및 배송 확인, 상품 구매 및 결제가 <br />
				가능할 뿐 아니라 다른 사람들의 위시 리스트를 통해 <br />
				보물처럼 숨겨져 있던 상품들을 발견하는 재미를 만끽할 수 있습니다.<br /></p>
				<p>누군가의 wish list를 following 할 수 있으며, <br />
				내 위시 리스트 공개 여부도 선택할 수 있습니다. <br />
				나와 다른 사람들의 위시 리스트 상품들을 비교해<br />
				나와 취향이 비슷한 위시리스트를 추천 받을 수 있고, <br />
				이를 통해 내가 선호하는 디자인과 스타일의 상품들을 <br />
				계속 발견하고 추천 받게 됩니다. <br />
				이제 스마트폰에서도 가장 트렌디하고 스타일리쉬한 <br />
				텐바이텐 쇼핑몰 앱을 즐겨보세요.<br />
				<br /><br /><br />
				[참고 사항]텐바이텐 앱을 쾌적하게 이용하기 위해서 <br />
				Android 4.0 이상을 설치한 스마트폰 단말기를 권장합니다.
				</p>
			</div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50401/bg_line.gif" alt="" /></div>
		</div>
	</div>
	<!-- //텐바이텐 모바일앱 출시! -->
</div>

<!-- Google Code for APP&#45796;&#50868; &#48260;&#53948;&#53364;&#47533; Conversion Page
In your html page, add the snippet and call
goog_report_conversion when someone clicks on the
phone number link or button. -->
<script type="text/javascript">
  /* <![CDATA[ */
  goog_snippet_vars = function() {
    var w = window;
    w.google_conversion_id = 1013881501;
    w.google_conversion_label = "RZQLCPP6zggQnbW64wM";
    w.google_remarketing_only = false;
  }
  // DO NOT CHANGE THE CODE BELOW.
  goog_report_conversion = function(url) {
    goog_snippet_vars();
    window.google_conversion_format = "3";
    window.google_is_call = true;
    var opt = new Object();
    opt.onload_callback = function() {
    if (typeof(url) != 'undefined') {
      window.location = url;
    }
  }
  var conv_handler = window['google_trackConversion'];
  if (typeof(conv_handler) == 'function') {
    conv_handler(opt);
  }
}
/* ]]> */
</script>
<script type="text/javascript"
  src="//www.googleadservices.com/pagead/conversion_async.js">
</script>


</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->