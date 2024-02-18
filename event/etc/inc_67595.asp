<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 11월 신규고객 대상 [택배가 온다!]
' History : 2015-11-19 이종화
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql 
Dim myregcnt , myzipcode , myaddr
userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65956
Else
	eCode   =  67595
End If
	
	'// 응모자 체크 11월 부터 신규 고객 1 true 0 false
	If IsUserLoginOK Then
		strSql = " IF EXISTS(select top 1 userid from db_user.dbo.tbl_user_n where convert(varchar(10),regdate,120) >= '2015-11-01' "
		strSql = strSql & "and userid = '"&userid&"') "
		strSql = strSql & "	begin "
		strSql = strSql & "		IF not EXISTS(select userid from db_event.dbo.tbl_event_subscript where evt_code = '"&eCode&"' and userid = '"&userid&"') "
		strSql = strSql & "			select 1 "
		strSql = strSql & "		else "
		strSql = strSql & "			select 2 "
		strSql = strSql & "	end "
		strSql = strSql & "else "
		strSql = strSql & "	begin "
		strSql = strSql & "		select 3 "
		strSql = strSql & "	end "
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly 
		IF Not rsget.Eof Then
			myregcnt = rsget(0)
		End IF
		rsget.close()

		strSql = " select top 1 zipcode , useraddr from db_user.dbo.tbl_user_n where userid = '"& userid &"' "
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly 
		IF Not rsget.Eof Then
			myzipcode = rsget(0)
			myaddr = rsget(1)
		End IF
		rsget.close()
	End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 택배가 온다")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 택배가온다!\n\n지금부터 텐바이텐\n회원가입을 하면 놀라운 선물이?!\n\n늦지 않게 가입하고\n선물 받아보세요!\n\n선착순입니다. 지금도전하세요!\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/67595/img_bnr_kakao.png"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt67595 h2 {visibility:hidden; width:0; height:0;}
.mEvt67595 button {background-color:transparent;}

.mEvt67595 {position:relative;}
.mEvt67595 .giftbox {position:absolute; top:2%; right:5%; width:14.375%;}

@-webkit-keyframes shake {
	0%, 100% {-webkit-transform:translateY(0);}
	10%, 30%, 50%, 70% {-webkit-transform:translateY(-7px);}
	20%, 40%, 60%, 80% {-webkit-transform:translateY(7px);}
}
@keyframes shake {
	0%, 100% {transform:translateY(0);}
	10%, 30%, 50%, 70% {transform:translateY(-7px);}
	20%, 40%, 60%, 80% {transform:translateY(7px);}
}
.shake {-webkit-animation-name:shake; animation-name:shake; -webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:1; animation-iteration-count:1;}

.gift {position:relative;}

.rolling {position:absolute; top:-18%; left:0; width:100%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-25%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:15px; height:15px; margin:0 2px; border-radius:0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67595/btn_pagination.png) no-repeat 50% 0; background-size:15px 30px; cursor:pointer; transition:all 1s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-position:50% 100%;}
.rolling .swiper button {position:absolute; top:53%; z-index:45; width:3.9%; background:transparent;}
.rolling .swiper .prev {left:3.5%;}
.rolling .swiper .next {right:3.5%;}

.btnmore {position:absolute; top:0; right:10%; z-index:5; width:25%; height:100%;}
.btnmore a {position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0); color:transparent;}

.gift .btnget {position:absolute; bottom:12%; left:50%; width:79.68%; margin-left:-39.84%;}

.lyDone {display:none; position:absolute; top:19.8%; left:50%; z-index:50; width:282px; height:275px; margin-left:-141px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67595/img_layer_done.png) no-repeat 50% 0; background-size:282px auto;}
.lyDone p {color:#404040; font-size:12px; font-weight:bold;}
.lyDone .done {margin-top:73px; color:#c92127; line-height:1.688em; text-align:center;}
.lyDone .msg {margin-top:12px; text-align:center;}
.lyDone .address {margin:19px 30px 0 60px; font-size:11px; line-height:2.4em;}
.lyDone .btnMy10x10 {margin:31px 30px 0 0; font-size:12px; text-align:right;}
.lyDone .btnMy10x10 a {color:transparent;}
.lyDone .btnClose {position:absolute; top:15px; right:26px; width:20px; height:20px; text-indent:-9999em;}

.lyGift {display:none; position:absolute; top:19.8%; left:50%; z-index:50; width:91.25%; margin-left:-45.625%;}
.lyGift .btnClose {position:absolute; top:3%; right:3%; z-index:5; width:10%; height:6%; color:transparent;}
.lyGift .btnClose span {position:absolute; top:0; right:10%; width:100%; height:100%; background-color:rgba(0,0,0,0);}

#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.6);}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:10%; left:50%; width:70%; margin-left:-35%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 8%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.noti {padding:8% 3.75%; background-color:#ececec;}
.noti strong {display:block; margin-bottom:4%; color:#3f3f3f; font-size:14px; font-weight:bold;}
.noti strong span {border-bottom:2px solid #3f3f3f;}
.noti ul li {position:relative; margin-top:3px; padding-left:12px; color:#7a7c7b; font-size:12px; line-height:1.688em;}
.noti ul li:after {content:' '; position:absolute; left:0; top:7px; width:4px; height:4px; border-radius:50%; background-color:#7a7c7b;}

@media all and (min-width:360px){
	.lyDone {width:310px; height:303px; margin-left:-155px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67595/img_layer_done.png) no-repeat 50% 0; background-size:310px auto;}
	.lyDone p {font-size:14px;}
	.lyDone .done {margin-top:80px;}
	.lyDone .address {margin:19px 35px 0 68px; font-size:12px;}
	.lyDone .btnMy10x10 {margin-top:33px; padding-bottom:5px; font-size:14px;}
}

@media all and (min-width:480px){
	.lyDone {width:423px; height:412px; margin-left:-211px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67595/img_layer_done.png) no-repeat 50% 0; background-size:423px auto;}
	.lyDone p {font-size:16px;}
	.lyDone .done {margin-top:113px;}
	.lyDone .msg {margin-top:20px;}
	.lyDone .address {margin:27px 50px 0 95px; font-size:16px;}
	.lyDone .btnClose {top:22px; right:40px; width:30px; height:30px;}

	.noti {padding:45px 30px;}
	.noti strong {padding-bottom:23px; font-size:21px;}
	.noti ul li {padding-left:20px; font-size:18px;}
	.noti ul li:after {top:9px; width:6px; height:6px;}
}
</style>
<script>
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
	
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});

	$("#btnClose02").click(function(){
		$("#lyDone").hide();
		$("#mask").fadeOut();
	});

	$("#btnmore a").click(function(){
		$("#lyGift").show();
		$("#mask").show();
		var val = $('#lyGift').offset();
		$('html,body').animate({scrollTop:val.top},200);
	});

	$("#btnClose01").click(function(){
		$("#lyGift").hide();
		$("#mask").fadeOut();
	});

	$("#mask").click(function(){
		$("#lyDone").hide();
		$("#lyGift").hide();
		$("#mask").fadeOut();
	});
});

function jschkevt(){
	<% If IsUserLoginOK() Then %>
		<% if Date() < "2015-11-23" or Date() > "2015-12-06" then %>
			alert('이벤트 응모 기간이 아닙니다.');
			return;
		<% else %>
			<% if myregcnt ="3" then %>
				alert('응모 대상자가 아닙니다');
				return;
			<% elseif myregcnt ="2" then %>
				alert('이미 응모 하셨습니다.');
				return;
			<% elseif myregcnt ="1" then %>
			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript67595.asp",
				data: "mode=insert",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.stcode=="77")
					{
						alert("이벤트에 응모를 하려면 로그인이 필요합니다.");
						return;
					}
					else if (result.stcode=="88")
					{
						alert("죄송합니다. 이벤트 기간이 아닙니다.");
						return;
					}
					else if (result.stcode=="99")
					{
						alert("응모 대상자가 아닙니다.");
						return;
					}
					else if (result.stcode=="11"){
						$("#lyDone").show();
						$("#mask").show();
						var val = $('#lyDone').offset();
						$('html,body').animate({scrollTop:val.top},200);
					}
					else if (result.stcode=="22"){
						alert("이미 이벤트에 참여 하셨습니다.");
						return;
					}
					else if (result.stcode=="33"){
						alert("한번만 응모 하실 수 있습니다.");
						return;
					}
					else if (result.stcode=="999"){
						alert("죄송합니다. 사은품이 모두 소진 되었습니다.");
						return;
					}
				}
			});
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsevtchk(sns){
	<% if Date() < "2015-11-23" or Date() > "2015-12-06" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript67595.asp",
			data: "mode=sns&snsgubun="+sns,
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if(result.stcode=="tw") 
				{
					popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
				}
				else if(result.stcode=="fb")
				{
					popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
				}
				else if(result.stcode=="ka")
				{
					parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
				}
				else if(result.stcode=="ln")
				{
					popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
				}
				else if(result.stcode=="77")
				{
					alert('로그인 후에 이용 하실 수 있습니다.');
					return false;
				}
				else
				{
					alert('오류가 발생했습니다.');
					return false;
				}
			}
		});
	<% end if %>
}
</script>
<div class="mEvt67595">
	<article>
		<h2>택배 왔어요!</h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/txt_come_v3.png" alt="신규 가입고객 대상 텐바이텐 가입만 해도 선물이 온다! 선착순이니 늦지 않게 응모하세요" /></p>
		<span class="giftbox shake"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_gift_box.png" alt="" /></span>

		<div class="gift">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/txt_random_v1.png" alt="사은품은 랜덤으로 발송됩니다" /></p>
			<div class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_slide_01_v1.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_slide_02_v1.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_slide_03_v1.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_slide_04_v1.png" alt="" /></div>
							<div class="swiper-slide">
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_slide_05_v1.png" alt="" />
								<div id="btnmore" class="btnmore">
									<a href="#lyGift">그 외 사은품 더보기</a>
								</div>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/btn_prev.png" alt="이전" /></button>
					<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/btn_next.png" alt="다음" /></button>
				</div>
			</div>

			<button type="button" id="btnget" class="btnget" onclick="jschkevt();"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/btn_get.png" alt="응모하기" /></button>
		</div>

		<div id="lyGift" class="lyGift">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/img_layer_gift.png" alt="11월 신규 가입 고객을 위한 사은품 리스트" /></p>
			<button type="button" id="btnClose01" class="btnClose"><span></span>닫기</button>
		</div>

		<% If IsUserLoginOK Then %>
		<div id="lyDone" class="lyDone">
			<p class="done"><%=userid%> 님의 응모가<br /> 완료 되었습니다.</p>
			<p class="msg">배송예정주소는 다음과 같습니다.</p>
			<p class="address">(<%=myzipcode%>) <%=myaddr%></p>
			<div class="btnMy10x10">
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupMy10x10();return false;">
				<% Else %>
				<a href="/my10x10/userinfo/confirmuser.asp">
				<% End If %>
				배송주소 수정하러 가기</a></div>
			<button type="button" id="btnClose02" class="btnClose">닫기</button>
		</div>
		<% End If %>

		<div class="sns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/txt_sns.png" alt="나만 알고 있기? 없기! 친구들에게 이벤트를 공유 해주세요!" /></p>
			<ul>
				<li><a href="" onclick="jsevtchk('fb'); return false;"><span></span>페이스북</a></li>
				<li><a href="" onclick="jsevtchk('ka'); return false;"><span></span>카카오톡</a></li>
				<li><a href="" onclick="jsevtchk('ln'); return false;"><span></span>라인</a></li>
			</ul>
		</div>

		<% If isapp <> "1" Then %>
		<div class="downloadApp">
			<a href="/event/appdown/?gaparam=evt67595_cpn" title="텐바이텐 앱 다운받기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67595/btn_down_app.png" alt="텐바이텐 APP 다운 받으면 더 핫한 이벤트와 할인 기회가 듬뿍!" /></a>
		</div>
		<% End If %>

		<div class="noti">
			<strong><span>이벤트 유의사항</span></strong>
			<ul>
				<li>텐바이텐 ID 로그인 후 참여할 수 있습니다.</li>
				<li>2015년 신규가입자 대상 이벤트입니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
				<li>동일한 배송주소 및 휴대폰 번호는 1회만 발송됩니다.</li>
				<li>응모되신 분들께는 매주 월요일 당첨안내 문자가 발송될 예정입니다.</li>
			</ul>
		</div>

		<div id="mask"></div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->