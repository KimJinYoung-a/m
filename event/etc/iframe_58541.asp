<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'########################################################
'# 어벤져박스의 기적 - for mobile
'# 2015-01-14 이종화 작성
'########################################################
Dim eCode , weekDate
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21435
Else
	eCode   =  58539
End If

Dim vEdate : vEdate = "2015-01-25 23:59:59" '//주말

weekDate = weekDayName(weekDay(now)) '// 요일 구하기 내장 함수


%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt58541 {text-align:center;}
.mEvt58541 img {vertical-align:top;}
.mEvt58541 .goApp a {position:absolute; left:10%; bottom:3%; display:block; width:80%;}
.avgPdt li {position:absolute; width:36%;}
.avgPdt li a,
.avgPdt li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.todayBox {position:relative;}
.todayBox li {position:absolute; width:35%; height:19%;}
.todayBox li a,
.todayBox li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.todayBox li.p01 {left:21%; top:13%; width:58%; height:28%;}
.todayBox li.p02 {left:10%; top:43.5%;}
.todayBox li.p03 {right:10%; top:43.5%;}
.todayBox li.p04 {left:10%; top:66%;}
.todayBox li.p05 {right:10%;  top:66%;}

.nextBox li {height:20%;}
.nextBox li.p01 {left:21%; top:11%; width:58%; height:28%;}
.nextBox li.p02 {left:10%; top:42%;}
.nextBox li.p03 {right:10%; top:42%;}
.nextBox li.p04 {left:10%; top:66%;}
.nextBox li.p05 {right:10%;  top:66%;}

/* 추가 */
.weekend .making {text-align:center; padding:11% 0; background:#242e51;}
.weekend .making .timer {padding:5% 0 6%;}
.weekend .making .timer em {display:inline-block; width:34px; height:34px; line-height:36px; font-size:23px; font-weight:bold; background:#fff;}
.weekend .making .timer span {display:inline-block; line-height:36px; font-size:23px; font-weight:bold; color:#fff; padding:0 2px;}
.weekend .promotion {background:#545f87;}
.weekend .promotion p {padding:0 3% 4.5%;}
.weekend .promotion {padding-bottom:3.5%;}
.weekend .goNext {display:block; width:53%; margin:0 auto;}
/* 추가 */

.avengerLayer {display:none; position:absolute; left:0; z-index:40;}
.viewNext {top:5%; }
.layerCont {padding-top:5%;}
.layerCont .lyBtn {display:block; position:absolute; left:20%; bottom:4%; width:60%;}
.mask {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:30;}

@media all and (min-width:480px){
	/* 추가 */
	.weekend .making .timer em {width:51px; height:51px; line-height:54px; font-size:35px;}
	.weekend .making .timer span {line-height:54px; font-size:35px;padding:0 3px;}
	/* 추가 */
}
</style>
<script type="text/javascript">
<!--
$(function(){
	$(".goNext").click(function(){
		$(".viewNext").show();
		$(".mask").show();
	});

	$(".lyBtn").click(function(){
		$(".viewNext").hide();
		$(".mask").hide();
	});

	$(".mask").click(function(){
		$(".viewNext").hide();
		$(".mask").hide();
	});
});

 	function goApp_event(){
		<% if Not(IsUserLoginOK) then %>
			parent.jsevtlogin();
			return;
		<% end if %>
		
		//chk_click
		var rstStr = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript58541.asp",
			data: "mode=mo_main",
			dataType: "text",
			async: false
		}).responseText;
			alert
			if (rstStr == "OK"){
				top.location.href = "http://m.10x10.co.kr/apps/link/?2420150114";
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
	}

	function go_Etcevent(v){
		//chk_click
		var modename
		var url
		if (v == "1"){
			modename = "mode=banner1";
			url = "/event/eventmain.asp?eventid=56864";
		}else if(v == "2"){
			modename = "mode=banner2";
			url = "/event/eventmain.asp?eventid=58600";
		}else{
			return;
		}

		var rstStr = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript58541.asp",
			data: modename,
			dataType: "text",
			async: false
		}).responseText;
			if (rstStr == "OK"){
				top.location.href = url;
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
	}

<% If now() > #01/24/2015 00:00:00# and now() < #01/26/2015 00:00:00# Then %>
var yr = "<%=Year(vEdate)%>";
var mo = "<%=TwoNumber(Month(vEdate))%>";
var da = "<%=TwoNumber(Day(vEdate))%>";
var hh = "<%=TwoNumber(hour(vEdate))%>";
var mm = "<%=TwoNumber(minute(vEdate))%>";
var ss = "<%=TwoNumber(second(vEdate))%>";
var tmp_hh = "99";
var tmp_mm = "99";
var tmp_ss = "99";
var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		

		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";
		futurestring=montharray[mo-1]+" "+da+", "+yr+" "+hh+":"+mm+":"+ss;

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		if (dday == 1){
			dhour = dhour + 24
		}

		if(dhour < 0)
		{
			$("#lyrCounter").hide();
			return;
		}

		if(dhour < 10) {
			dhour = "0" + dhour;
		}
		if(dmin < 10) {
			dmin = "0" + dmin;
		}
		if(dsec < 10) {
			dsec = "0" + dsec;
		}

		$("#lyrCounter").html("<em>"+Left(dhour,1)+ "</em> <em>"+ Right(dhour,1)+ "</em> <span>:</span> <em>"+ Left(dmin,1) +"</em> <em>"+ Right(dmin,1)+ "</em> <span>:</span> <em>"+ Left(dsec,1) + "</em> <em>"+ Right(dsec,1)+ "</em>");
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}

countdown();

//left
function Left(Str, Num){
	if (Num <= 0)
		return "";
	else if (Num > String(Str).length)
		return Str;
	else
		return String(Str).substring(0,Num);
}

//right
function Right(Str, Num){
	if (Num <= 0)
		return "";
	else if (Num > String(Str).length)
		return Str;
	else
		var iLen = String(Str).length;
		return String(Str).substring(iLen, iLen-Num);
}
<% end if %>
//-->
</script>
</head>
<body>
<div class="mEvt58541">
	<% If now() > #01/19/2015 00:00:00# and now() < #01/20/2015 00:00:00# Then %>
	<!-- 1월 19일 -->
	<div class="avengersMiracle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0119.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0119.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=801326" target="_top">카이젤 가정용 토스터기 TO-20S</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1171539" target="_top">써모머그 엄브렐러 보틀</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1181201" target="_top">어벤져스 스마트폰 컨트롤톡 이어폰</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1146493" target="_top">반8 미니거울</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<!--// 1월 19일 -->
	<% End If %>

	<% If now() > #01/20/2015 00:00:00# and now() < #01/21/2015 00:00:00# Then %>
	<!-- 1월 20일 -->
	<div class="avengersMiracle" >
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0120.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0120.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=425856" target="_top">클래식 턴테이블</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1161808" target="_top">꽃송이가습기</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=457154" target="_top">양키캔들</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=234933" target="_top">모빌</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<!--// 1월 20일 -->
	<% End If %>

	<% If now() > #01/21/2015 00:00:00# and now() < #01/22/2015 00:00:00# Then %>
	<!-- 1월 21일 -->
	<div class="avengersMiracle" >
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0123.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0123.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1077842" target="_top">심슨 캐릭터 USB 메모리</a></li>
				<li class="p03"><span>2015 몰스킨</span></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=865506" target="_top">파우치</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1030004" target="_top">후치코</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<!--// 1월 21일 -->
	<% End If %>

	<% If now() > #01/22/2015 00:00:00# and now() < #01/23/2015 00:00:00# Then %>
	<!-- 1월 22일 -->
	<div class="avengersMiracle" >
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0122.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0122.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><span>일본 온천 패키지</span></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1151190" target="_top">스마트빔 큐브 미니빔</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1130755" target="_top">비밀의 정원</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=822463" target="_top">메탈웍스</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1115073" target="_top">자동스탬프</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<!--// 1월 22일 -->
	<% End If %>

	<% If now() > #01/23/2015 00:00:00# and now() < #01/24/2015 00:00:00# Then %>
	<!-- 1월 23일 -->
	<div class="avengersMiracle" >
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0121.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0121.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1153845" target="_top">문스케일 디자인 체중계</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=949903" target="_top">collinette 미니 지압기</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1135607" target="_top">달콤한 노라인 줄넘기 캔디</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1042723" target="_top">삐약이계란비누세트</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<!--// 1월 23일 -->
	<% End If %>

	<% If now() > #01/26/2015 00:00:00# and now() < #01/27/2015 00:00:00# Then %>
	<!--// 1월 26일 -->
	<div class="avengersMiracle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0126.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0126.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=801326" target="_top">카이젤 가정용 토스터기 TO-20S</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1171539" target="_top">써모머그 엄브렐러 보틀</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1181201" target="_top">어벤져스 스마트폰 컨트롤톡 이어폰</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1146493" target="_top">반8 미니거울</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<% End If %>

	<% If now() > #01/27/2015 00:00:00# and now() < #01/28/2015 00:00:00# Then %>
	<!--// 1월 27일 -->
	<div class="avengersMiracle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0127.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0127.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=425856" target="_top">클래식 턴테이블</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1161808" target="_top">꽃송이가습기</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=457154" target="_top">양키캔들</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=234933" target="_top">모빌</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<% End If %>

	<% If now() > #01/28/2015 00:00:00# and now() < #01/29/2015 00:00:00# Then %>
	<!--// 1월 28일 -->
	<div class="avengersMiracle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0130.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0130.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1176161" target="_top">애플 맥북에어 13형</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1077842" target="_top">심슨 캐릭터 USB 메모리</a></li>
				<li class="p03"><span>2015 몰스킨</span></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=865506" target="_top">파우치</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1030004" target="_top">후치코</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<% End If %>

	<% If now() > #01/29/2015 00:00:00# and now() < #01/30/2015 00:00:00# Then %>
	<!--// 1월 29일 -->
	<div class="avengersMiracle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0129.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0129.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><span>일본 온천 패키지</span></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1151190" target="_top">스마트빔 큐브 미니빔</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1130755" target="_top">비밀의 정원</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=822463" target="_top">메탈웍스</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1115073" target="_top">자동스탬프</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<% End If %>

	<% If now() > #01/30/2015 00:00:00# and now() < #01/31/2015 00:00:00# Then %>
	<!--// 1월 30일 -->
	<div class="avengersMiracle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_0128.gif" alt="오늘의 HELP" /></h2>
		<div class="todayBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58541/img_box_0128.jpg" alt="오늘의 어벤져박스" /></p>
			<ul>
				<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
				<li class="p02"><a href="/category/category_itemPrd.asp?itemid=1153845" target="_top">문스케일 디자인 체중계</a></li>
				<li class="p03"><a href="/category/category_itemPrd.asp?itemid=949903" target="_top">collinette 미니 지압기</a></li>
				<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1135607" target="_top">달콤한 노라인 줄넘기 캔디</a></li>
				<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1042723" target="_top">삐약이계란비누세트</a></li>
			</ul>
		</div>
		<p class="goApp"><a href="" onclick="goApp_event();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	</div>
	<% End If %>

	<% If now() > #01/24/2015 00:00:00# and now() < #01/26/2015 00:00:00# Then  'weekDate = "토요일" Or weekDate = "일요일" Then '// 주말용%>
	<!-- 주말노출(24,25)-->
	<div class="avengersMiracle weekend">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_avenger_weekend.gif" alt="" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_making_box.gif" alt="" /></p>
		<div class="making">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/txt_monday_open.gif" alt="월요일 오전 10시! OPEN!" /></p>
			<div class="timer" id="lyrCounter">
				<em>0</em>
				<em>0</em>
				<span>:</span>
				<em>0</em>
				<em>0</em>
				<span>:</span>
				<em>0</em>
				<em>0</em>
			</div>
			<a href="#" class="goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_next_box02.gif" alt="NEXT 어벤져박스 보기" /></a>
		</div>
		<div class="promotion">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/tit_ten_weekend.gif" alt="" /></h3>
			<p><a href="" onclick="go_Etcevent('1');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/bnr_event01.jpg" alt="PROJECT 2015" /></a></p>
			<p><a href="" onclick="go_Etcevent('2');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/bnr_event02.jpg" alt="첫 눈에 반해 먹었어요" /></a></p>
		</div>
	</div>
	<!--// 주말노출 -->

	<!-- 레이어팝업 (NEXT 어벤져박스) 주말노출 -->
	<div id="viewNext" class="avengerLayer viewNext">
		<div class="layerCont">
			<div class="avgPdt nextBox">
				<ul>
					<li class="p01"><a href="/category/category_itemPrd.asp?itemid=1182606" target="_top">애플 아이패드 미니3</a></li>
					<li class="p02"><a href="/category/category_itemPrd.asp?itemid=801326" target="_top">카이젤 가정용 토스터기 TO-20S</a></li>
					<li class="p03"><a href="/category/category_itemPrd.asp?itemid=1171539" target="_top">써모머그 엄브렐러 보틀</a></li>
					<li class="p04"><a href="/category/category_itemPrd.asp?itemid=1181201" target="_top">어벤져스 스마트폰 컨트롤톡 이어폰</a></li>
					<li class="p05"><a href="/category/category_itemPrd.asp?itemid=1146493" target="_top">반8 미니거울</a></li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_next_weekend.png" alt="NEXT 어벤져박스" /></p>
				<p class="lyBtn closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/btn_confirm.gif" alt="확인" /></p>
			</div>
		</div>
	</div>
	<% End If %>
	<!--// 레이어팝업 (NEXT 어벤져박스) -->
</div>
<!--// 어벤져박스의 기적(M) -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->