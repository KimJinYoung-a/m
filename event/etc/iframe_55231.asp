<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [캔디이벤트] 아싸!봉잡았네! (M)
' History : 2014.09.26 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event55231Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<%
Dim cEvent, eCode, ename, emimg
Dim cnt, sqlStr
	If application("Svr_Info") = "Dev" Then
		eCode   =  21312
	Else
		eCode   =  55231
	End If
	
	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='" & eCode & "'" &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' and sub_opt2 = '1' and convert(varchar(10),regdate,120) = '" & Left(now(),10) & "'"
		rsget.Open sqlStr, dbget, 1
			cnt = rsget(0)
		rsget.Close
	End If

	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode
		cEvent.fnGetEvent

		ename		= cEvent.FEName
		emimg		= cEvent.FEMimg
	set cEvent = nothing

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode(ename)
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
	snpPre = Server.URLEncode("텐바이텐 이벤트")
	snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
	snpTag2 = Server.URLEncode("#10x10")
	snpImg = Server.URLEncode(emimg)
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt55231 {}
.mEvt55231 img {vertical-align:top; width:100%;}
.mEvt55231 p {max-width:100%;}
.mEvt55231 .selfSwiperWrap {padding-bottom:25px; background:#fffa7f;}
.mEvt55231 .selfSwiper {position:relative;}
.mEvt55231 .selfSwiper .swiper-wrapper {overflow:hidden; position:relative;}
.mEvt55231 .selfSwiper .swiper-container {overflow:hidden; width:320px; height:224px; margin:0 auto; border-top:3px solid #dfd942; border-bottom:3px solid #dfd942;}
.mEvt55231 .selfSwiper .swiper-container:after {content:" "; display:block; clear:both;}
.mEvt55231 .selfSwiper .swiper-slide {overflow:hidden; float:left;}
.mEvt55231 .selfSwiper .swiper-slide a {display:block;}
.mEvt55231 .selfSwiper button {border:0; background:none;}
.mEvt55231 .selfSwiper .btnArrow {display:block; position:absolute; top:50%; z-index:10; width:42px; height:42px; margin-top:-20px; text-indent:-9999em;}
.mEvt55231 .selfSwiper .arrow-left {left:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55231/btn_prev.png) left top no-repeat; background-size:100% 100%;}
.mEvt55231 .selfSwiper .arrow-right {right:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55231/btn_next.png) left top no-repeat; background-size:100% 100%;}
.mEvt55231 .selfSwiper .pagination {position:absolute; bottom:-25px; left:0; width:100%; text-align:center;}
.mEvt55231 .selfSwiper .pagination span {display:inline-block; position:relative; width:12px; height:12px; margin:0 4px;  border-radius:50%; background:#ff6941; cursor:pointer;}
.mEvt55231 .selfSwiper .pagination .swiper-active-switch {background:#000;}
.mEvt55231 .selfCamera div {position:relative;}
.mEvt55231 .selfCamera a, .selfCamera input {display:block; position:absolute; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55231/bg_blank.png) left top repeat; background-size:100% 100%; z-index:50; text-indent:-9999em;}
.mEvt55231 .selfCamera .twitter {left:56.5%; top:51.5%; width:11%; height:10%;}
.mEvt55231 .selfCamera .facebook {left:69%; top:51.5%; width:11%; height:10%;}
.mEvt55231 .selfCamera .kakaotalk {left:81%; top:51.5%; width:11%; height:10%;}
.mEvt55231 .selfCamera .apply {left:12.5%; top:68.5%; width:75%; height:15%;}
.mEvt55231 .selfCamera .join {left:11%; bottom:7%; width:78%; height:9%;}
.mEvt55231 .selfCamera .goApp {left:12.5%; bottom:11%; width:75%; height:19%;}
.mEvt55231 .evtNoti {padding:48px 15px 45px; text-align:left; background:#fffa7f;}
.mEvt55231 .evtNoti h4 {padding-left:12px;}
.mEvt55231 .evtNoti h4 img {width:55px;}
.mEvt55231 .evtNoti ul {padding-top:12px;}
.mEvt55231 .evtNoti li {position:relative; font-size:11px; line-height:1.2; padding:0 0 4px 12px; color:#444;}
.mEvt55231 .evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:3px; width: 0; height: 0; border-style: solid; border-width:3px 0 3px 5px; border-color: transparent transparent transparent #ff6941;}
@media all and (min-width:480px){
	.mEvt55231 .selfSwiperWrap {padding-bottom:38px;}
	.mEvt55231 .selfSwiper .swiper-container {width:480px; height:336px; border-top:4px solid #dfd942; border-bottom:4px solid #dfd942;}
	.mEvt55231 .selfSwiper .btnArrow {width:62px; height:62px; margin-top:-31px;}
	.mEvt55231 .selfSwiper .pagination {bottom:-38px;}
	.mEvt55231 .selfSwiper .pagination span {width:18px; height:18px; margin:0 6px;}
	.mEvt55231 .evtNoti {padding:72px 23px 68px;}
	.mEvt55231 .evtNoti h4 {padding-left:18px;}
	.mEvt55231 .evtNoti h4 img {width:83px;}
	.mEvt55231 .evtNoti ul {padding-top:18px;}
	.mEvt55231 .evtNoti li {font-size:17px; padding:0 0 7px 18px;}
	.mEvt55231 .evtNoti li:after {top:5px; border-width:4px 0 4px 7px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="/lib/js/swiper-2.1.min.js"></script>
<script>
$(function(){
	showSwiper= new Swiper('.swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	});
	$('.selfSwiper .arrow-left').on('click', function(e){
		e.preventDefault()
		showSwiper.swipePrev()
	});
	$('.selfSwiper .arrow-right').on('click', function(e){
		e.preventDefault()
		showSwiper.swipeNext()
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			showSwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});
});

	function checkform() {

<%
	If date >= "2014-09-29" and date <= "2014-10-05" Then
		If IsUserLoginOK Then
			If cnt > 0 Then
%>
				alert('하루에 한번만 응모 가능합니다.');
				return false;
<%			Else %>
				document.efrm.mode.value='confirmreg';
				document.efrm.action = "doEventSubscript55231.asp";
				document.efrm.submit();
				return true;
<%			End If
		Else
%>
   			parent.jsevtlogin();
<%		End If
	Else
%>
			alert('이벤트 기간이 아닙니다.');
			return;
<%	End If %>
	}	

Kakao.init('c967f6e67b0492478080bcf386390fdd');

function kakaosendcall(){
	kakaosend55231();
}

function kakaosend55231(){
	  Kakao.Link.sendTalkLink({
		  label: '[10x10 APP EVENT]\n[캔디이벤트]\n아싸!봉잡았네!',
		  image: {
			src: 'http://webimage.10x10.co.kr/eventIMG/2014/55231/tit_self_camera.png',
			width: '140',
			height: '100'
		  },
		 appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
				android: { url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=55231'},
				iphone: { url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=55231'}
			}
		  },
		  installTalk : Boolean
	  });
}

function popSNSgubun(snsval){
	if (snsval==''){
		alert('sns구분이 없습니다');
		return;
	}
	<% If IsUserLoginOK Then %>
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doEventSubscript55231.asp",
		data: "mode=snsreg&snsgubun="+snsval,
		dataType: "text",
		async: false
	}).responseText;

	if (String(str).length!='2'){
		alert('정상적인 값이 아닙니다.');
		return;
	}else{
		if ( str=='tw' ){
			popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		}else if ( str=='fb' ){
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		}else if ( str=='ka' ){
			kakaosendcall();
		}else{
			alert('이미 참여 하셨거나, 종료된 이벤트 입니다.');
			return;
		}
	}
	<% else %>
		parent.jsevtlogin();
	<% end if %>
}

</script>

</head>
<body>
<div class="evtView tMar15" style="padding:0;">
	<div class="mEvt55231">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/tit_self_camera.png" alt="아싸! 봉 잡았네!" /></h3>
		<!-- swiper -->
		<div class="selfSwiperWrap">
			<div class="selfSwiper">
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/img_self_camera01.png" alt="" /></a></div>
						<div class="swiper-slide"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/img_self_camera02.png" alt="" /></a></div>
						<div class="swiper-slide"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/img_self_camera03.png" alt="" /></a></div>
						<div class="swiper-slide"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/img_self_camera04.png" alt="" /></a></div>
						<div class="swiper-slide"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/img_self_camera05.png" alt="" /></a></div>
					</div>
					<div class="pagination"></div>
				</div>
				<button type="button" class="btnArrow arrow-left">Previous</button>
				<button type="button" class="btnArrow arrow-right">Next</button>
			</div>
		</div>
		<!--// swiper -->
		<form name="efrm" method="POST" style="margin:0px;">
		<input type="hidden" name="mode">
		<div class="selfCamera">
			<div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/txt_apply_tip.png" alt="" /></p>
				<a href="" onclick="popSNSgubun('tw'); return false;" class="twitter">트위터</a>
				<a href="" onclick="popSNSgubun('fb'); return false;" class="facebook">페이스북</a>
				<a href="" onclick="popSNSgubun('ka'); return false;" class="kakaotalk">카카오톡</a>
				<a href="" onclick="checkform(); return false;" class="apply">이벤트 응모하기</a>
				<a href="/member/join.asp" target="_top" class="join">아직 회원이 아니세요? 텐바이텐 회원 가입하기</a>
			</div>
			<div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/img_app_coupon.png" alt="" /></p>
				<a href="/event/etc/app_down.asp" class="goApp">텐바이텐 앱 방문하기</a>
			</div>
		</div>
		</form>
		<div class="evtNoti">
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55231/tit_notice.png" alt="이벤트 안내" /></h4>
			<ul>
				<li>본 이벤트는 캔디카메라 고객을 위한 이벤트입니다.</li>
				<li>본 이벤트는 ID당 매일 1회씩 응모 가능하며, 많이 응모할 수록 당첨 확률이 올라갑니다.</li>
				<li>텐바이텐에 앱 설치 후, 로그인을 하면 3000원 할인 쿠폰이 자동 발급됩니다.</li>
				<li>이벤트 당첨은 10월 8일 텐바이텐 공지사항에서 확인 가능하며, 당첨자에게는 SMS가 발송됩니다.</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->