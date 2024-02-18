<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "66216"
Else
	eCode = "73053"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg, vIsEnd, vQuery, vState, vNowTime, vCouponMaxCount
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 15주년 이벤트")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/15th/index.asp")
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "텐바이텐이 올해\n열다섯 살이 되었어요!\n\n15주년 기념 최대 30% 할인 쿠폰과 다양한 이벤트가 당신을 기다립니다.\n\n지금 바로 확인해보세요!\n오직, 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
End If



	If Now() < #10/15/2016 00:00:00# Then
		vCouponMaxCount = 48
	Else
		vCouponMaxCount = 13
	End If


'#######
' vState = "0" ### 이벤트 종료됨.
' vState = "1" ### 쿠폰다운가능.
' vState = "2" ### 다운 가능 시간 아님.
' vState = "3" ### 이미 받음.
' vState = "4" ### 한정수량 오버됨.
' vState = "5" ### 로그인안됨.
	If IsUserLoginOK() Then
		If Now() > #10/24/2016 23:59:59# Then
			vIsEnd = True
			vState = "0"	'### 이벤트 종료됨. 0
		Else
			vIsEnd = False
		End If
		
		If Not vIsEnd Then	'### 이벤트 종료안됨.
			vQuery = "select convert(int,replace(convert(char(8),getdate(),8),':',''))"
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
			vNowTime = rsget(0)	'### DB시간받아옴.
			rsget.close

			'If vNowTime > 100000 AND vNowTime < 235959 Then	'### 15시에서 24시 사이 다운가능. 1
			If vNowTime > 150000 AND vNowTime < 235959 Then	'### 15시에서 24시 사이 다운가능. 1
				vQuery = "select count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] where userid = '" & getencLoginUserid() & "' and evt_code = '73053'"
				rsget.CursorLocation = adUseClient
				rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
				If rsget(0) > 0 Then	' ### 이미 받음. 3
					vState = "3"
				End IF
				rsget.close
				
				If vState <> "3" Then	'### 한정수량 계산
					vQuery = "select count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] where evt_code = '73053' and sub_opt1 = convert(varchar(10),getdate(),120)"
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
					If rsget(0) >= vCouponMaxCount Then	' 한정수량 100 오버됨. 4
						vState = "4"
					Else
						vState = "1"	'### 쿠폰다운가능.
					End IF
					rsget.close
				End IF
			Else	' ### 다운 가능 시간 아님. 2
				vState = "2"
			End IF
		End IF
	Else
		vState = "5"	'### 로그인안됨.
	End IF
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<style type="text/css">
/* teN15th main */
.teN15thMain .shareSns {position:relative;}
.teN15thMain .shareSns li {position:absolute; right:6.25%; width:31.25%;}
.teN15thMain .shareSns li.btnKakao {top:21.6%;}
.teN15thMain .shareSns li.btnFb {top:53.15%;}

/* discount */
.teN15thMain {position:relative;}
.teN15thMain button {vertical-align:top; background:transparent; outline:none;}
.teN15thMain .coupon .btnCoupon {position:relative; width:100%; background:#1c1c4b;}
.teN15thMain .coupon .btnCoupon em {position:absolute; left:50%; top:71.66%; width:45.16%; height:15.178%; margin-left:-22.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_coupon.png) no-repeat 0 0; background-size:100% auto;}
#lyrCoupon {position:absolute; left:0; top:0; width:100%; height:100%; padding-top:4.5rem;}
#lyrCoupon .couponCont div {position:relative; z-index:200;}
#lyrCoupon .couponCont a {display:inline-block; position:absolute; width:20%; z-index:210;}
#lyrCoupon .couponCont .btn1 {top:54.5%; right:25.78%;}
#lyrCoupon .couponCont .btn2 {top:37.75%; right:20%;}
#lyrCoupon .couponCont .limit {display:inline-block; position:absolute; top:35.89%; left:24.375%; width:31.25%;}
#lyrCoupon .close {position:absolute; right:4.7%; top:2rem; z-index:210; width:9.375%;}
#lyrCoupon .mask {position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; background:rgba(0,0,0,.5);}
.teN15thMain .tenNav ul {background:#1c1c4b;}
.teN15thMain .tenNav li {line-height:0; font-size:0;  vertical-align:top;}
.tenComment {padding-bottom:50px; margin-bottom:-50px; background:#fff;}
.tenComment .tenCmtWrite {padding:0 1.4rem 3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_dot.png) repeat-y 0 0; background-size:100% auto;}
.tenComment .tenCmtWrite .msg {position:relative; overflow:hidden; width:100%; border:2px solid #4b267e; background:#fff; border-radius:0.3rem;}
.tenComment .tenCmtWrite .msg textarea {position:absolute; left:3%; top:5%; width:73%; height:90%; border:0;}
.tenComment .tenCmtWrite .msg .btnSubmit {display:block; float:right; width:21%; background:#4b267e; }
.tenComment .tenCmtList ul {padding:2.5rem 2rem 0;}
.tenComment .tenCmtList li {position:relative; font-size:1.1rem; margin-bottom:2rem; padding:3.4rem 8.9% 2.8rem; background-position:0 100%; background-repeat:no-repeat; background-size:100%;}
.tenComment .tenCmtList li.cmt01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_btm_01.png);}
.tenComment .tenCmtList li.cmt02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_btm_02.png);}
.tenComment .tenCmtList li.cmt03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_btm_03.png);}
.tenComment .tenCmtList li.cmt04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_btm_04.png);}
.tenComment .tenCmtList li.cmt05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_btm_05.png);}
.tenComment .tenCmtList li:after {content:''; display:inline-block; position:absolute; left:0; top:0; width:100%; height:2.55rem; background-position:0 0; background-repeat:no-repeat; background-size:100% auto;}
.tenComment .tenCmtList li.cmt01:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_top_01.png);}
.tenComment .tenCmtList li.cmt02:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_top_02.png);}
.tenComment .tenCmtList li.cmt03:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_top_03.png);}
.tenComment .tenCmtList li.cmt04:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_top_04.png);}
.tenComment .tenCmtList li.cmt05:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_cmt_top_05.png);}
.tenComment .tenCmtList li .num {color:#333;}
.tenComment .tenCmtList li p {min-height:3rem; margin:1rem 0 1.2rem; color:#666; font-size:1rem; line-height:1.4;}
.tenComment .tenCmtList li .writer {color:#999;}
.tenComment .tenCmtList li .btnDelete {display:inline-block; position:absolute; right:9%; top:13%; width:4.4rem; height:2.1rem; text-align:center; font-size:1.1rem; line-height:2.1rem; font-weight:bold; border:1px solid #cbcbcb; background:#fff; border-radius:0.2rem;}
.tenComment .tenCmtList li .mobile {display:inline-block; width:0.7rem; height:1.1rem; margin-left:0.4rem; text-indent:-999em; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/ico_mobile.png) 0 0 no-repeat; background-size:100%;}
.tenComment .pagingV15a {padding-top:1rem;}
</style>
<script type="text/javascript">
$(function(){
	$('.btnCoupon').click(function(){
		<% if Not(IsUserLoginOK) then %>
			jsEventLogin();
			return false;
		<% Else %>
			$('#lyrCoupon').fadeIn();
			window.parent.$('html,body').animate({scrollTop:$(".teN15thMain").offset().top},500);
			jsUserCountT();
		<% End IF %>
	});
	$('#lyrCoupon .close').click(function(){
		$('#lyrCoupon').fadeOut();
	});
	$('#lyrCoupon .mask').click(function(){
		$('#lyrCoupon').fadeOut();
	});

	$(".tenComment .tenCmtList li:nth-child(1)").addClass("cmt01");
	$(".tenComment .tenCmtList li:nth-child(2)").addClass("cmt02");
	$(".tenComment .tenCmtList li:nth-child(3)").addClass("cmt03");
	$(".tenComment .tenCmtList li:nth-child(4)").addClass("cmt04");
	$(".tenComment .tenCmtList li:nth-child(5)").addClass("cmt05");

	$('html,body').animate({scrollTop:$(".teN15thMain").offset().top}, 0);
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}


function js15thCouponDown(){
<% If vIsEnd Then %>
	alert("이벤트가 종료되었습니다.");
	return false;
<% End If %>

<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/event/15th/doeventsubscript/index_proc.asp",
		data: "mode=G",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				alert(res[1]);
				top.location.reload();
				return false;
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				top.location.reload();
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
<% else %>
	jsEventLogin();
	return false;
<% end if %>
}

function jsEventLogin(){
<% if isApp=1 then %>
	parent.calllogin();
	return false;
<% else %>
	parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
	return false;
<% end if %>
}

function jsUserCountT(){
	$.ajax({
		type: "GET",
		url: "/event/15th/doeventsubscript/usercount.asp",
		cache: false,
		success: function(str) { }
	});
}
</script>
<div class="teN15thMain">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/tit_ten15th.gif" alt="" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_story.png" alt="텐바이텐만의 다양한 이야기!" /></p>
	<div class="coupon">
		<button type="button" class="btnCoupon"><em></em><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/img_coupon.gif" alt="15주년 쿠폰/타임쿠폰 다운받기" /></button>
	</div>

	<div id="lyrCoupon" style="display:none;">
		<div class="couponCont">
		<% if IsUserLoginOK then %>
		<%
			Dim vDownImg
			If vState = "2" Then
				vDownImg = "btn_download_off.png"
			ElseIf vState = "4" Then
				vDownImg = "btn_soldout.png"
			Else
				vDownImg = "btn_download_02.png"
			End If
		%>
			<div class="anniverCoupon">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/img_15th_counpon.png" alt="15주년 할인쿠폰" /></p>
				<% If Not vIsEnd Then %>
				<a href="javascript:jsDownCoupon('prd,prd,prd','11960,11961,11962');" class="btn1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_download_01.png" alt="발급" /></a>
				<% End If %>
			</div>
			<div class="timeCoupon">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/img_time_counpon.png" alt="매일 15시에 찾아오는 타임쿠폰" /></p>
				<span class="limit">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_limit_<%=vCouponMaxCount+2%>.png" alt="쿠폰" />
				</span>
				<% If Not vIsEnd Then %>
				<a href="" class="btn2" onClick="<% If vState="1" OR vState = "3" OR vState = "2" Then %>js15thCouponDown();return false;<% Else %>return false;<% End If %>"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/<%=vDownImg%>" alt="타임쿠폰 발급받기" /></a>
				<% End If %>
			</div>
		<% End IF %>
		</div>
		<button type="button" class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_close.png" alt="닫기" /></button>
		<div class="mask"></div>
	</div>

	<!-- navigation 수정예정 -->
	<div class="tenNav">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_night_01.png" alt="" /></div>
		<ul>
			<li><a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014/","")%>/event/eventmain.asp?eventid=73063"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/nav_walk.gif" alt="매일매일 출석체크 [워킹맨]" /></a></li>
			<li><a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014/","")%>/event/eventmain.asp?eventid=73064"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/nav_discount.gif" alt="매일 오전 10시 할인에 도전하라 [비정상할인]" /></a></li>
			<li><a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014/","")%>/event/eventmain.asp?eventid=73068"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/nav_gift.gif" alt="팡팡 터지는 구매사은품 [사은품을 부탁해]" /></a></li>
			<li><a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014/","")%>/event/eventmain.asp?eventid=73065"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/nav_video.gif" alt="특급 콜라보레이션! [전국 영상자랑]" /></a></li>
			<li><a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014/","")%>/event/eventmain.asp?eventid=73067"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/nav_tv.gif" alt="일상을 담아라 [나의 리틀텔레비전]" /></a></li>
		</ul>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bg_night_02.png" alt="" /></div>
	</div>
	<!--// navigation -->

	<!-- SNS 공유 -->
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_share.png" alt="텐바이텐 15주년 이야기, 친구와 함께라면!" /></p>
		<ul>
			<li class="btnKakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_kakao.png" alt="텐바이텐 15주년 이야기 카카오톡으로 공유" /></a></li>
			<li class="btnFb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_facebook.png" alt="텐바이텐 15주년 이야기 페이스북으로 공유" /></a></li>
		</ul>
	</div>
	<!--//  SNS 공유 -->
	<!-- #include virtual="/event/15th/comment.asp" -->
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->