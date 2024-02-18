<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'####################################################################
' Description : 텐바이텐 X ETUDE HOUSE의 만남 for Mobile-Web & Wish APP
' History : 2014-09-18 이종화
'####################################################################

Dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum , mytotcount

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21279"
	Else
		eCode 		= "54652"
	End If

If IsUserLoginOK Then
	sqlstr = "Select count(sub_idx) as totcnt" &_
			"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "'"
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		totalsum = rsget(0)
		cnt = rsget(1)
	rsget.Close

	'//전체 당첨
	If totalsum > 0 then
		sqlstr= "select regdate , sub_opt1, sub_opt2 " &_
			" FROM db_event.dbo.tbl_event_subscript " &_
			" where evt_code='" & eCode &"' and userid='" & GetLoginUserID()  & "' and sub_opt2 = '3' "
		'response.write sqlstr
		rsget.Open sqlStr,dbget
		IF Not rsget.EOF Then
			mytotcount = rsget.RecordCount
			arrList = rsget.getRows()
		END IF
		rsget.Close
	End If 

	Dim todaysel1 , todaysel2
	'//오늘 응모
	If cnt = 1 then
		sqlstr= "select regdate , sub_opt1, sub_opt2 " &_
			" FROM db_event.dbo.tbl_event_subscript " &_
			" where evt_code='" & eCode &"' and userid='" & GetLoginUserID()  & "' and convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' "
		'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			todaysel1 = rsget(1) '선택 상품
			todaysel2 = rsget(2) '당첨 여부 1:꽝 3:당첨
		rsget.Close
	End If 
End If

Function imgreturn(v)
	Dim returncode
	If todaysel2 = "1" Then '비당첨
		If CInt(v) = CInt(todaysel1) Then
			If left(now(),10) = "2014-10-01" Then
			returncode = "_last"
			else
			returncode = "_fail"
			End If 
		Else
			returncode = "_off"
		End If 
	ElseIf todaysel2 = "3" Then
		If CInt(v) = CInt(todaysel1) Then
			returncode = "_win"
		Else
			returncode = "_off"
		End If 
	Else
		returncode = "_on"
	End If 
	Response.write returncode
End Function 

Function itemname(v)
	Dim returnname
	Select Case v
		Case "1"
			Returnname = "촉촉 탱탱 패키지 (에뛰드하우스 선물 3종+텐바이텐 테이프 디스펜서)"
		Case "2"
			Returnname = "촉촉 탱탱 패키지 (에뛰드하우스 선물 3종+텐바이텐 리본 미니거울)"
		Case "3"
			Returnname = "촉촉 탱탱 패키지 (에뛰드하우스 선물 3종+텐바이텐 휴대용 스피커)"
		Case "4"
			Returnname = "촉촉 탱탱 패키지 (에뛰드하우스 선물 3종+텐바이텐 mmmg 머그컵)"
	End Select 

	Response.write Returnname
End Function

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [텐바이텐 X 에뛰드하우스] 촉촉! 수분이 필요한 순간</title>
<style type="text/css">
.mEvt54653 {position:relative;}
.mEvt54653 img {vertical-align:top; width:100%;}
.mEvt54653 p {max-width:100%;}
.needmoisture .section, .needmoisture .section h3 {margin:0; padding:0;}
.needmoisture .heading {position:relative;}
.needmoisture .heading h2 {position:absolute; top:15%; left:0; z-index:10; width:100%;}
.needmoisture .heading .water {position:absolute; top:38%; right:8.5%; z-index:5; width:8.85416%;}
.needmoisture .heading .cream {position:absolute; bottom:5%; right:3%; width:20.20833%;}
.needmoisture .when {position:relative;}
.needmoisture .when .scene {overflow:hidden; position:absolute; bottom:12%; left:0; width:100%; padding:0 3.75%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.needmoisture .when .scene li {float:left; width:50%; margin-top:1%; padding:0 1%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.needmoisture .when .btnMy {position:absolute; bottom:3.5%; left:0; width:100%;}
.needmoisture .when .btnMy a {display:block; padding:0 29.8%;}
.needmoisture .package {position:relative;}
.needmoisture .intro {position:relative;}
.needmoisture .intro .tenten-goods {overflow:hidden; position:absolute; bottom:20%; left:0; width:100%; padding:0 3%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.needmoisture .intro .tenten-goods li {float:left; width:25%;}
.needmoisture .intro .tenten-goods li a {display:block; margin:0 8%;}
.moisture-swiper {position:absolute; top:14.5%; left:0; width:100%; padding:10px 10px 25px; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.moisture-swiper .swiper {position:relative; width:285px; height:157px; margin:0 auto; padding:4px; background-color:#fff; box-shadow: 0 0 5px 5px rgba(217,127,87,0.1);}
.moisture-swiper .swiper .swiper-container {overflow:hidden; width:285px; height:157px; margin:0 auto;}
.moisture-swiper .swiper .swiper-slide {float:left; height:157px;}
.moisture-swiper .swiper .swiper-slide a {display:block; width:285px;}
.moisture-swiper .swiper .swiper-slide img {width:285px; height:157px; vertical-align:top;}
.moisture-swiper .swiper button {display:block; position:absolute; top:50%; z-index:10; width:20px; height:27px; margin-top:-13px; text-indent:-9999px; border:0; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:20px auto;}
.moisture-swiper .swiper .arrow-left {left:-10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_nav_prev.png);}
.moisture-swiper .swiper .arrow-right {right:-10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_nav_next.png);}
.moisture-swiper .swiper .pagination {position:absolute; bottom:5px; left:0; width:100%; text-align:center;}
.moisture-swiper .swiper .pagination span {display:inline-block; width:6px; height:8px; margin:0 3px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_paging.png); background-repeat:no-repeat; background-position:0 0; background-size:100% auto; cursor:pointer;}
.moisture-swiper .swiper .pagination .swiper-active-switch {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_paging_on.png);}
@media all and (min-width:360px){
	.moisture-swiper {top:15.8%;}
}
@media all and (min-width:480px){
	.moisture-swiper .swiper {width:424px; height:234px;}
	.moisture-swiper .swiper .swiper-container {width:424px; height:234px;}
	.moisture-swiper .swiper .swiper-slide {height:234px;}
	.moisture-swiper .swiper .swiper-slide img {width:424px; height:234px;}
	.moisture-swiper .swiper button {width:30px; height:41px; margin-top:-15px; background-size:30px auto;}
	.moisture-swiper .swiper .arrow-left {left:-15px;}
	.moisture-swiper .swiper .arrow-right {right:-15px;}
	.moisture-swiper .swiper .pagination span {width:9px; height:12px;}
}
@media all and (min-width:640px){
	.moisture-swiper .swiper {width:580px; height:320px;}
	.moisture-swiper .swiper .swiper-container {width:580px; height:320px;}
	.moisture-swiper .swiper .swiper-slide {height:320px;}
	.moisture-swiper .swiper .swiper-slide img {width:580px; height:320px;}
	.moisture-swiper .swiper button {width:30px; height:41px; margin-top:-15px; background-size:30px auto;}
	.moisture-swiper .swiper .arrow-left {left:-15px;}
	.moisture-swiper .swiper .arrow-right {right:-15px;}
	.moisture-swiper .swiper .pagination span {width:9px; height:12px;}
}
.needmoisture .package .btnEtude {position:absolute; bottom:3%; left:0; width:100%;}
.needmoisture .package .btnEtude a {display:block; padding:0 8%; text-align:center;}
.needmoisture .noti {padding:5% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/bg_graph_paper.gif) repeat 0 0; background-size:3px auto; text-align:left;}
.needmoisture .noti ul {padding:5% 5% 0;}
.needmoisture .noti ul li {margin-top:3px; padding-left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/blt_dot.png); background-repeat:no-repeat; background-position:0 6px; background-size:4px auto; color:#333; font-size:11px; line-height:1.5em;}
@media all and (min-width:480px){
	.needmoisture .noti ul li {margin-top:9px; padding-left:15px; font-size:16px; background-position:0 10px; background-size:6px auto;}
}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.65);}
.ly-win-list {display:none; position:fixed; top:40%; left:50%; z-index:300; width:300px; margin-left:-150px;}
.win-list {position:relative; padding:15px; background-color:#ff6a48; border-radius:10px; vertical-align:middle;}
.win-list strong {display:block; padding-bottom:5px; border-bottom:1px solid #fff;}
.win-list strong img {width:129px;}
.win-list ul {margin-top:10px;}
.win-list ul li {position:relative; margin-top:5px; padding:0 0 0 50px; color:#fff; font-size:12px; line-height:1.5em; text-align:left;}
.win-list ul li span {position:absolute; top:0; left:0;}
.win-list ul li em {font-style:normal;}
.win-list p {margin-top:15px; color:#fff; font-size:12px;}
.win-list .btn-close {position:absolute; top:10px; right:15px; z-index:300; width:20px; height:20px; border:0; background-color:transparent; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_close.png) repeat 50% 50%; background-size:20px auto; text-indent:-9999em; cursor:pointer;}
@media all and (min-width:600px){
	.ly-win-list {width:500px; margin-left:-250px;}
	.win-list strong {padding-bottom:10px;}
	.win-list strong img {width:193px;}
	.win-list ul li {font-size:15px;}
	.win-list p {font-size:15px;}
	.win-list .btn-close {width:26px; height:26px; background-size:26px auto;}
}
</style>
<script src="/lib/js/swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	function moveCream() {
		$(".water").animate({"margin-top":"10px"},1000).animate({"margin-top":"5px"},1000, moveCream);
	}
	moveCream();

	var mySwiper = new Swiper('.swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:300,
		autoplay: false,
		autoplayDisableOnInteraction: true,
	})

	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});

	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	/* layer popup */
	$(".mask").hide();
	$(".ly-win-list").hide();
	$(".btnMy").click(function(){
		$(".mask").show();
		$(".ly-win-list").show();
		return false;
	});

	$(".mask").click(function(){
		$(".mask").hide();
		$(".ly-win-list").hide();
	});

	$(".ly-win-list .btn-close").click(function(){
		$(".mask").hide();
		$(".ly-win-list").hide();
		return false;
	});

	//상품 링크 수정
	var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
		isAndroid = navigator.userAgent.match('Android');

		if (isiOS || isAndroid) {
			$("#item1").attr("href","/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=792061");
			$("#item2").attr("href","/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=659260");
			$("#item3").attr("href","/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=888302");
			$("#item4").attr("href","/apps/appCom/wish/webview/test/appurl.asp?param1=3&param2=makerid=mmmg"); //앱 브랜드 페이지
		} else {
			$("#item1").attr("href","/category/category_itemPrd.asp?itemid=792061");
			$("#item2").attr("href","/category/category_itemPrd.asp?itemid=659260");
			$("#item3").attr("href","/category/category_itemPrd.asp?itemid=888302");
			$("#item4").attr("href","/street/street_brand.asp?makerid=mmmg");
		}
});

function checkform(frm,v) {
	<% if datediff("d",date(),"2014-10-02")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% if cnt >= 1 then %>
			alert('하루 1회만 응모 가능합니다.\n내일 다시 응모해주세요. :)');
			return;
			<% else %>
				frm.action = "doEventSubscript54653.asp?spoint="+v;
				frm.submit();
			<% end if %>
		<% Else %>
			var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
			isAndroid = navigator.userAgent.match('Android'),
			tenwishApp = navigator.userAgent.match('tenwishApp');

			if (tenwishApp) {
				parent.calllogin();
				return false;
			} else {
				parent.jsevtlogin();
				return;
			}
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
}
</script>
</head>
<body>
<div class="mEvt54653">
	<div class="needmoisture">
		<div class="section heading">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tit_need_moisture.png" alt="텐바이텐과 에뛰드 하우스의 만남 촉촉! 수분이 필요한 순간" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/txt_need_moisture.gif" alt="수분가득 콜라겐 크림의 10번째 생일을 맞아 텐바이텐과 에뛰드하우스가 만났어요! 1,000명을 추첨해 촉촉 패키지를 선물합니다. 이벤트기간은 9월 22일 월요일부터 10월 1일 수요일 10일간입니다." /></p>
			<span class="water"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_water.png" alt="" /></span>
			<span class="cream"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_collagen_cream.png" alt="" /></span>
		</div>

		<!-- 참여 -->
		<form name="frm" method="POST" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<div class="section when">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tit_when.gif" alt="수분 가득이 필요한 순간, 언제인가요?" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/txt_gift.gif" alt="아래 상황 중 수분가득이 필요한 순간을 선택해 주세요. 각 상황별로 250분씩 추첨해 텐바이텐과 에뛰드하우스의 촉촉 패키지를 선물로 드립니다" /></p>
			<ul class="scene">
				<li><a href="javascript:;" onclick="
					checkform(frm,1);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tab_sscene_01<%=imgreturn(1)%>.png" alt="A 갑갑한 사무실에서 메말라가는 나를 발견한 순간" /></a></li>
				<li><a href="javascript:;" onclick="
					checkform(frm,2);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tab_sscene_02<%=imgreturn(2)%>.png" alt="B 남자친구와의 데이트, 자꾸 거울을 들여다 보는 순간" /></a></li>
				<li><a href="javascript:;" onclick="
					checkform(frm,3);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tab_sscene_03<%=imgreturn(3)%>.png" alt="C 소풍이나 캠핑 등 야외 활동이 많아지는 순간" /></a></li>
				<li><a href="javascript:;" onclick="
					checkform(frm,4);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tab_sscene_04<%=imgreturn(4)%>.png" alt="D 찬바람에 몸도 마음도 건조해지는 순간" /></a></li>
			</ul>

			<div class="btnMy"><a href="#ly-win-list"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_my.png" alt="나의 당첨내역" /></a></div>
		</div>
		</form>

		<div id="ly-win-list" class="ly-win-list">
			<div class="win-list">
				<strong><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/txt_my_win_list.gif" alt="나의 당첨내역 확인하기" /></strong>
				<% If mytotcount = 0 Then %>
					<p>당첨내역이 없습니다.</p>
				<% Else %>
					<ul>
					<% For i = 0 To mytotcount-1 %>
						<li><span><%=FormatDate(Left(arrList(0,i),10),"00/00")%></span> <em><% If arrList(2,i) = "3" Then %><%=itemname(arrList(1,i)) %><% End If %></em></li>
					<% next %>
					</ul>
				<% End If %>
				<button type="button" class="btn-close" id="btn-close">닫기</button>
			</div>
		</div>
		<div class="mask"></div>

		<div class="section package">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tit_package.gif" alt="수분 가득 일상을 만드는 촉촉 패키지" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/txt_package.gif" alt="10살을 맞이한 에뛰드하우스 수분가득 콜라겐 크림 오직 텐바이텐에서만 만날 수 있는 알찬 구성의 촉촉 패키지에 도전하세요!" /></p>

			<!-- swipe -->
			<div class="moisture-swiper">
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_01.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_04.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_05.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_06.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_07.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_slide_08.jpg" alt="" /></div>
						</div>
						<div class="pagination"></div>
					</div>
					<button type="button" class="arrow-left">이전</button>
					<button type="button" class="arrow-right">다음</button>
				</div>
			</div>

			<div class="intro">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/txt_package_introduce_01.jpg" alt="수분가득 콜라겐 크림, 에뛰드하우스 스페셜 에코백, 수분가득 콜라겐 3종 KIT로 구성된 에뛰드하우스 3종 선물을 드리며" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/txt_package_introduce_02.jpg" alt="텐바이텐 솔루션 아이템은 드리밍 웨일티 인퓨저, 잼스튜디오 리본 손거울, 메모렛 아이스크림 휴대용 스피커, 샤인 머그시리즈 4종 중 당첨된 상품 1개만 랜덤으로 증정됩니다." /></p>
				<!--for dev msg : 모바일과 앱이랑 상품링크 앞에 경로 붙는거만 달라요 -->
				<ul class="tenten-goods">
					<li><a href="/category/category_itemPrd.asp?itemid=792061" target="_top" id="item1"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_goods_blank.png" alt="공드린 월요일 테이프 디스펜서" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=659260" target="_top" id="item2"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_goods_blank.png" alt="잼스튜디오 리본 손거울" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=888302" target="_top" id="item3"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_goods_blank.png" alt="메모렛 아이스크림 휴대용 스피커" /></a></li>
					<li><a href="/street/street_brand.asp?makerid=mmmg" target="_top" id="item4"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/img_goods_blank.png" alt="샤인 머그시리즈" /></a></li>
				</ul>
			</div>

			<div class="btnEtude"><a href="http://bit.ly/etudelinks" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/btn_etude.png" alt="에뛰드하우스 수분가득 콜라겐 크림 자세히 보기" /></a></div>
		</div>

		<div class="section noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54653/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>텐바이텐 로그인 후 이벤트에 참여하실 수 있습니다.</li>
				<li>한 ID 당 매일 1회 참여 가능합니다.</li>
				<li>이벤트 당첨 후, 안내 공지는 10월 6일 (월) 텐바이텐 홈페이지에서 확인하실 수 있습니다.</li>
				<li>촉촉 탱탱 패키지는 이벤트 종료 후 주소확인을 거쳐 배송될 예정입니다. (1주일가량 소요예정)</li>
				<li>촉촉 탱탱 패키지 속 &apos;텐바이텐 솔루션 아이템&apos;은 4종 중 1개만 증정되며, 옵션은 랜덤입니다.</li>
				<li>촉촉 탱탱 패키지는 양도, 교환 및 현금성 환불이 불가합니다.</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->