<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : [13주년] 즐겨라,텐바이텐_ 게릴라! 앱 쇼 
' History : 2014.10.02 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/13th/03/event55082Cls.asp" -->

<%'쇼핑찬스 이벤트 내용보기
dim eCode
	eCode   = getevt_code
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate, bimg, eItemListType
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply, edispcate
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt, isMyFavEvent, clsEvt
Dim j
Dim evtmolistbanner

Dim upin '카카오 이벤트 key값 parameter
	upin = requestCheckVar(Request("upin"),200)

IF eCode = "" THEN 
	'response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
	Call Alert_Return("이벤트번호가 없습니다.11")
	dbget.close()	:	response.End
elseif Not(isNumeric(eCode)) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
END IF

egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
IF egCode = "" THEN egCode = 0
	
	itemlimitcnt = 105	'상품최대갯수
	'이벤트 개요 가져오기			
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode
		
		cEvent.fnGetEvent
		
		eCode		= cEvent.FECode			
		ekind		= cEvent.FEKind		
		emanager	= cEvent.FEManager 	
		escope		= cEvent.FEScope 	
		eName		= cEvent.FEName 		
		esdate		= cEvent.FESDate 	
		eedate		= cEvent.FEEDate 	
		estate		= cEvent.FEState 	
		eregdate	= cEvent.FERegdate 	
		epdate		= cEvent.FEPDate  	
		ecategory	= cEvent.FECategory
		ecateMid	= cEvent.FECateMid
		blnsale		= cEvent.FSale 		
		blngift		= cEvent.FGift 		
		blncoupon	= cEvent.FCoupon   	
		blncomment	= cEvent.FComment 	
		blnbbs		= cEvent.FBBS	 	
		blnitemps	= cEvent.FItemeps 	
		blnapply	= cEvent.FApply 		
		etemplate	= cEvent.FTemplate 	
		emimg		= cEvent.FEMimg 		
		ehtml		= cEvent.FEHtml 		
		eitemsort	= cEvent.FItemsort 	
		ebrand		= cEvent.FBrand 
		gimg		= cEvent.FGimg
		blnFull		= cEvent.FFullYN
		blnItemifno = cEvent.FIteminfoYN
		blnitempriceyn = cEvent.FItempriceYN
		LinkEvtCode = cEvent.FLinkEvtCode
		blnBlogURL	= cEvent.FblnBlogURL
		edispcate	= cEvent.FEDispCate
		eItemListType = cEvent.FEItemListType
		evtmolistbanner = cEvent.FEmolistbanner
		
		If Not(cEvent.FEItemImg="" or isNull(cEvent.FEItemImg)) then
			bimg		= cEvent.FEItemImg
		ElseIf cEvent.FEItemID<>"0" Then
			If cEvent.Fbasicimg600 <> "" Then
				bimg		= "http://webimage.10x10.co.kr/image/basic600/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg600 & ""
			Else
				bimg		= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg & ""
			End IF
		Else
			bimg		= ""
		End IF
		
		IF etemplate = "3" THEN	'그룹형(etemplate = "3")일때만 그룹내용 가져오기		
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup					
		END IF
		
		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt
	set cEvent = nothing
		cdl_e = ecategory	
		cdm_e = ecateMid
		
		IF cdl_e = "" THEN blnFull= True	'카테고리가 없을경우 전체페이지로		
		IF eCode = "" THEN 
		Alert_return("유효하지 않은 이벤트 입니다.")
		dbget.close()	:	response.End
		END IF
		
	'// 내 관심 이벤트 확인
	if IsUserLoginOK then
		set clsEvt = new CMyFavoriteEvent
			clsEvt.FUserId = getEncLoginUserID
			clsEvt.FevtCode = eCode
			isMyFavEvent = clsEvt.fnIsMyFavEvent
		set clsEvt = nothing
	end If
	
	'// 쇼셜서비스로 글보내기 (2014-09-24 이종화)
	dim snpTitle, snpLink, snpPre, snpImg
	snpTitle = Server.URLEncode(eName)
	snpLink = Server.URLEncode(wwwUrl&CurrURLQ())
	snpPre = Server.URLEncode("10x10 이벤트")
	If evtmolistbanner <> "" Then 
	snpImg = Server.URLEncode(evtmolistbanner)
	End If

dim userid, subscriptcount, totalsubscriptcount, bonuscouponcount, totalbonuscouponcount
	userid = getloginuserid()

subscriptcount = 0
totalsubscriptcount = 0
bonuscouponcount = 0
totalbonuscouponcount = 0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, datecouponval(left(currenttime,10)), "", "", left(currenttime,10))
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "", "")
totalbonuscouponcount = getbonuscoupontotalcount(datecouponval(left(currenttime,10)), "", "", left(currenttime,10))
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
.mEvt55084 {background-color:#fff;}
.appshow .heading {padding-bottom:6%; position:relative;}
.appshow .heading .topic {padding:7% 0 4%;}
.appshow .heading .mobil {position:absolute; top:1%; left:0; width:100%;}

.appshow .appshow-swipe {margin:0 15px; box-shadow:7px 7px 3px rgba(0,0,0,0.1);}
.appshow .item {position:absolute; left:0; bottom:7px; z-index:50; width:100%;}
.appshow .item span {display:block; height:20px; margin:0 7px; padding-top:5px; background-color:rgba(0,0,0,0.4); color:#fff; text-align:center; font-size:10px; font-weight:bold;}
.appshow .oneplus {position:absolute; right:7px; top:-1px; z-index:50; width:27px;}
.appshow .sold-out {position:absolute; top:0; left:0; z-index:49; width:100%;}
.appshow .btnBuy {margin:10% 15% 0;}
.appshow .swiper {position:relative; padding:7px; border:1px solid #d9d9d9; background-color:#fff;}
.appshow .swiper-wrapper img {vertical-align:top; display:inline;}
.appshow .pagination {position:absolute; bottom:-20px; left:0; width:100%; height:16px; font-size:3px; line-height:3px; text-align:center;}
.appshow .pagination .swiper-pagination-switch {display:inline-block; width:7px; height:7px; margin:0 3px; background-color:#999; border-radius:50%; -webkit-border-radius:50%; }
.appshow .pagination .swiper-visible-switch,
.appshow .pagination .swiper-active-switch {background-color:#dc0610;}
.appshow .swiper button {display:block; position:absolute; top:50%; z-index:10; width:20px; height:33px; margin-top:-13px; text-indent:-9999px; border:0; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:20px auto;}
.appshow .swiper .arrow-left {left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/55083/btn_nav_prev.png);}
.appshow .swiper .arrow-right {right:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/55083/btn_nav_next.png);}
.appshow .scheduleArea {background:#eeeadc url(http://webimage.10x10.co.kr/eventIMG/2014/55083/bg_pattern_icon.gif) no-repeat 50% 0; background-size:100%;}
.appshow .scheduleList {position:relative; padding:0 10px 20px 10px;}
.appshow .scheduleList ol {overflow:hidden; width:100%;}
.appshow .scheduleList ol li {float:left; position:relative; width:33.33333%; border-left:1px solid #eee; border-bottom:1px solid #eee;}
.appshow .scheduleList ol li .today, .appshow .scheduleList ol li .end {position:absolute; top:0; left:0; width:100%;}
.appshow .schedule {position:relative; border:6px solid #00d0b9; background-color:#fff;}
.appshow .evtInfo {background-color:#fffce9;}
.appshow .evtInfo ul {padding:14px 12px;}
.appshow .evtInfo ul li {margin:3px 0; padding-left:9px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55083/blt_guerrilla_show.png) left 2px no-repeat; background-size:4px 4px; font-size:12px; color:#333;}

@media all and (min-width:480px){
	.appshow .item span {height:30px; padding-top:7px; font-size:15px;}
	.appshow .oneplus {right:7px; width:41px;}
	.appshow .pagination {bottom:-35px; height:24px;}
	.appshow .pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 4px;}
	.appshow .swiper button {width:29px; height:48px; background-size:29px auto;}
	.appshow .swiper .arrow-left {left:20px;}
	.appshow .swiper .arrow-right {right:20px;}
	.appshow .scheduleList {padding:0 15px 30px 15px;}
	.appshow .schedule {border:9px solid #00d0b9;}
	.appshow .evtInfo ul {padding:21px 18px;}
	.appshow .evtInfo ul li {margin-top:12px; padding-left:13px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55083/blt_guerrilla_show.png) left 6px no-repeat; background-size:6px 6px; font-size:18px;}
}
.bnrAnniversary13th {position:relative;}
.bnrAnniversary13th .mobil {position:absolute; top:15%; left:0; width:100%;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Bounce animation */
@-webkit-keyframes bounce {
	40% {-webkit-transform: translateY(10px);}
}
@keyframes bounce {
	40% {transform: translateY(10px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function fnMyEvent() {
<% If IsUserLoginOK Then %>
	$.ajax({
		url: "/my10x10/myfavorite_eventProc.asp?hidM=U&eventid=<%=eCode%>",
		cache: false,
		async: false,
		success: function(message) {
			if($("#myfavoriteevent").attr("class") == "circleBox wishView wishActive"){
				$("#myfavoriteevent").removeClass("wishActive");
				alert("선택하신 이벤트가 삭제 되었습니다.");
			}else{
				$("#myfavoriteevent").addClass("wishActive");
				alert("관심 이벤트로 등록되었습니다.");
			}
		}
	});
<% Else %>
	calllogin();
	return false;
<% End If %>
}

var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
isAndroid = navigator.userAgent.match('Android');

//처리페이지후 리로드용
function pagereload(itemid){
	location.reload();
	
	//아이폰은 심사중 구형 주소로 보내버림
	if (isiOS) {
		top.location.href='/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid='+itemid
	} else {
		fnAPPpopupProduct(itemid)
	}
}

function goitempage(itemid){

	//아이폰은 심사중 구형 주소로 보내버림
	if (isiOS) {
		top.location.href='/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid='+itemid
	} else {
		fnAPPpopupProduct(itemid)
	}
}

function jseventSubmit(frm){
	<% If not( IsUserLoginOK() ) Then %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% Else %>
		<% If not( left(currenttime,10)>="2014-10-06" and left(currenttime,10)<"2014-10-21" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% If left(currenttime,10)="2014-10-11" or left(currenttime,10)="2014-10-12" or left(currenttime,10)="2014-10-18" or left(currenttime,10)="2014-10-19" Then %>
				alert("주말에는 참여 하실수 없습니다.");
				return;
			<% else %>
				<% if subscriptcount>0 or bonuscouponcount>0 then %>
					alert("한 개의 아이디당 하루 한 번만 응모하실 수 있습니다.");
					return;
				<% else %>
					<% if totalsubscriptcount>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then %>
						alert("오늘의 상품이 전부 소진되었습니다.");
						return;
					<% else %>
						<% if dateopenyn(currenttime)<>"Y" then %>
							alert("오늘의 앱쇼는 아직 오픈 전입니다.\n9시~12시 사이에 랜덤으로 오픈됩니다.\n앱쇼를 기다려주세요!");
							return;
						<% else %>
							<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
								alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
								return;
							<% else %>
								frm.action="/apps/appcom/wish/web2014/event/13th/03/doEventSubscript55082.asp";
								frm.target="evtFrmProc";
								frm.mode.value='iteminsert';
								frm.submit();
							<% end if %>
						<% end if %>
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% End IF %>
}

$(function() {
	mySwiper = new Swiper('.appshow-swipe .swiper-container',{
		pagination:'.appshow-swipe .pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});

	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});

	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
});

</script>

</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtView" id="contentArea">
			<div class="evtViewHead">
				<h2><%=eName%></h2>
				<p class="date"><%=Replace(esdate,"-",".")%> ~ <%=Replace(eedate,"-",".")%></p>
				<div class="btnWrap">
					<% If evtmolistbanner <> "" Then %><p id="myfavoriteevent" class="circleBox wishView<%=chkIIF(isMyFavEvent," wishActive","")%>" onclick="fnMyEvent()"><span>찜하기</span></p><% End If %>
				</div>
			</div>
			<!-- 이벤트 배너 등록 영역 -->
			<div class="evtCont">
				<%
				IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
					Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
				END IF
				%>
				<div class="mEvt55084">
					<div class="anniversary13th appshow">
						<div class="heading">
							<p class="topic"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/txt_app_show.png" alt="평범한 오전 특별한 쇼! 평일 오전 9시부터 12시 사이 랜덤으로  마켓이 오픈되며, 선착순 100명에게 한 개 가격에, 두 개 상품을! 친구에게 하나를 선물하면, 우정도 2배 UP!" /></p>
							<span class="mobil animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_mobil.png" alt="" /></span>

							<!-- for dev msg : 슬라이드 -->
							<div class="appshow-swipe">
								<div class="swiper">
									<p class="item"><%= dateitemcontents(left(currenttime,10)) %></p>
									<p class="oneplus"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/flag_guerrilla_show.png" alt="하나 더!" /></p>
									<%' for dev msg : 해당 날짜의 투데이 아이템 슬라이드 이미지로 바꿔주세요 img_slide_01_0x.png ~ img_slide_11_0x.jpg %>
									<div class="swiper-container">
										<div class="swiper-wrapper">
											<div class="swiper-slide">
												<a href="" onclick="goitempage(<%= dateitemval(left(currenttime,10)) %>); return false;">
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_slide_<%= datenumber(left(currenttime,10)) %>_01.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" /></a>
											</div>
											<div class="swiper-slide">
												<a href="" onclick="goitempage(<%= dateitemval(left(currenttime,10)) %>); return false;">
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_slide_<%= datenumber(left(currenttime,10)) %>_02.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" /></a>
											</div>
											<div class="swiper-slide">
												<a href="" onclick="goitempage(<%= dateitemval(left(currenttime,10)) %>); return false;">
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_slide_<%= datenumber(left(currenttime,10)) %>_03.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" /></a>
											</div>
										</div>
										
										<%' for dev msg : 솔드아웃 될 경우 style="display:block;"으로 바꿔주세요. %>
										<p class="sold-out" style="display:<% if subscriptcount>0 or bonuscouponcount>0 or totalsubscriptcount>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then %><%else%>none<% end if %>;">
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/txt_sold_out.png" alt="솔드아웃 오늘의 게릴라 앱쇼 상품이 품절 되었습니다. 다음 게일라앱쇼를 기다려 주세요!" /></p>
									</div>
									<div class="pagination"></div>
									<button type="button" class="arrow-left">이전</button>
									<button type="button" class="arrow-right">다음</button>
								</div>
							</div>

							<p class="btnBuy">
								<a href="" onclick="jseventSubmit(evtFrm1); return false;">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/55084/btn_go_buy.png" alt="상품 구매하러가기 결제 시, 50프로 할인 쿠폰을 사용하세요" /></a>
							</p>
						</div>
						
						<div class="scheduleArea">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/subtit_guerrilla_show.png" alt="게릴라 앱쇼 스케줄" /></p>
							<div class="scheduleList">
								<div class="schedule">
									<ol>
										<%' for dev msg : 커밍순 상품 _off.jpg / 투데이 상품 _on.jpg + <strong class="today">...</strong> / <strong class="end">...</strong> / 내일 오픈예정인 상품 _next.jpg %>
										<li>
											<!-- 6일 -->
											<% if left(currenttime,10)="2014-10-06" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_01_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-05" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_01_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-06" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_01_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_01_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% end if %>
										</li>
										<li>
											<!-- 7일 -->
											<% if left(currenttime,10)="2014-10-07" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_02_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-06" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_02_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-07" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_02_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_02_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 8일 -->
											<% if left(currenttime,10)="2014-10-08" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_03_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-07" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_03_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-08" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_03_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_03_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 9일 -->
											<% if left(currenttime,10)="2014-10-09" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_04_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-08" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_04_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-09" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_04_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_04_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 10일 -->
											<% if left(currenttime,10)="2014-10-10" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_05_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-09" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_05_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-10" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_05_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_05_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 13일 -->
											<% if left(currenttime,10)="2014-10-13" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_06_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-10" or left(currenttime,10)="2014-10-11" or left(currenttime,10)="2014-10-12" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_06_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-13" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_06_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_06_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 14일 -->
											<% if left(currenttime,10)="2014-10-14" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_07_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-13" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_07_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-14" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_07_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_07_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 15일 -->
											<% if left(currenttime,10)="2014-10-15" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_08_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-14" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_08_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-15" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_08_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_08_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 16일 -->
											<% if left(currenttime,10)="2014-10-16" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_09_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-15" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_09_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-16" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_09_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_09_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 17일 -->
											<% if left(currenttime,10)="2014-10-17" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_10_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-16" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_10_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-17" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_10_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_10_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<!-- 20일 -->
											<% if left(currenttime,10)="2014-10-20" then %>
												<strong class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_today.png" alt="투데이" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_11_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)="2014-10-17" or left(currenttime,10)="2014-10-18" or left(currenttime,10)="2014-10-19" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_11_next.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% elseif left(currenttime,10)<"2014-10-20" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_11_off.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />
											<% else %>
												<strong class="end"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/ico_end.png" alt="종료" /></strong>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_item_11_on.jpg" alt="<%= dateitemval(left(currenttime,10)) %>" />												
											<% end if %>
										</li>
										<li>
											<img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/img_gift_box.gif" alt="" />
										</li>
									</ol>
								</div>
							</div>
						</div>

						<div class="evtInfo">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55083/info_guerrilla_show.png" alt="이벤트 안내" /></p>
							<ul>
								<li>게릴라 앱쇼 상품은 오직 텐바이텐 APP에서만 구매할 수 있습니다.</li>
								<li>게릴라 앱쇼 이벤트는 평일 오전 9~12시 사이에 랜덤으로 오픈 합니다.</li>
								<li>게릴라 앱쇼 상품 결제 시, 50% 게릴라 쿠폰을 사용해주세요.</li>
								<li>본 쿠폰은 다른 쿠폰과 함께 사용할 수 없습니다.</li>
								<li>50% 게릴라 쿠폰은 다운 후, 24시간 후 자동 소멸됩니다.</li>
							</ul>
						</div>

						<!-- main banner -->
						<div class="bnrAnniversary13th">
							<a href="/apps/appcom/wish/web2014/event/13th/">
								<%' for dev msg : 메인으로 링크 걸어주세요 %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_bnr_main.gif" alt="즐겨라 YOUR 텐바이텐 이벤트 메인으로 가기" />
								<span class="mobil animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_small_mobil.png" alt="" /></span>
							</a>
						</div>

					</div>
				</div>
			</div>
			<!--// 이벤트 배너 등록 영역 -->
		</div>
		<!-- //content area -->
		<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
			<input type="hidden" name="mode">
		</form>
		<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>		
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
<% If requestCheckVar(Request("comm"),1) = "o" Then %>
<script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
<% End If %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->