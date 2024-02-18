<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [직방] 살림살이, 도와드릴게요
' History : 2014.08.28 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/event/etc/event54443Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
Function newCordYN()
	IF application("Svr_Info")="Dev" THEN
		If Date() >= "2014-10-15" Then
			newCordYN = "Y"
		Else
			newCordYN = "N"
		End If
	Else
		If Date() >= "2014-10-16" Then
			newCordYN = "Y"
		Else
			newCordYN = "N"
		End If		
	End If
End Function
'// 가격 할인율 계산 //
Function GetPricePercent(Sprice,Oprice,pt)
	if Sprice="" or Oprice="" or isNull(Sprice) or isNull(Oprice) then Exit Function
	if Sprice < Oprice then
		GetPricePercent = FormatNumber(100-(Clng(Sprice)/Clng(Oprice)*100),pt) & "%"
	else
		GetPricePercent = FormatNumber(0,pt) & "%"
	end if
End Function

dim eCode, blnitempriceyn, giftlimitcnt, i, j
dim ename, cEvent, emimg, smssubscriptcount, usercell, userid
	eCode=54443
	userid = getloginuserid()


	dim oJustCal, oJustItem, JustDate, eTime, nTime, lp, sp, strLink1, strLink2, strImg, salePrice, goPreDt, goNextDt, vSelectDay, chkHoly
	JustDate = requestCheckVar(Request("JustDate"),10)

	IF application("Svr_Info")="Dev" THEN
		webImgUrl = "http://testwebimage.10x10.co.kr"
	else
		webImgUrl = "http://webimage.10x10.co.kr"
	end if

	'// 날짜 검사 및 지정
	if JustDate="" then
		JustDate = cStr(Date())
	else
		if Not(isDate(JustDate)) then
			Call Alert_return("날자형식이 잘못되었습니다.")
			dbget.close()	:	response.End
		end if
	end if

	if DateDiff("d",date(),JustDate)>0 then
		Call Alert_return("오늘 이후의 날짜는 보실 수 없습니다.")
		dbget.close()	:	response.End
	elseif DateDiff("m",justDate,date)>2 then
		Call Alert_return("최근 3개월까지 보실 수 있습니다.")
		dbget.close()	:	response.End
	end if

	'// 달력 접수
	set oJustCal = New CJustOneDay
	oJustCal.FRectDate = Left(JustDate,7)
	oJustCal.GetJustOneDayCalendar

	'// 오늘의 상품 접수
	set oJustItem = New CJustOneDay
	oJustItem.FRectDate = date
	oJustItem.GetJustOneDayItemInfo



	If 	oJustItem.FResultCount > 0 Then
		'// 추가 이미지
		dim oADD
		set oADD = new CJustOneDay
		oADD.getAddImage oJustItem.FItemList(0).Fitemid
	End If 

	'// 이전 1Day 상품(오늘자 기준으로 하루전꺼 까지)
	Dim oPrev1DayItem
	set oPrev1DayItem = New CJustOneDay
	oPrev1DayItem.getPrev1DayProduct

	If 	oJustItem.FResultCount > 0 Then
		if oJustItem.FItemList(0).FJustDate<JustDate then
			chkHoly = true
		else
			chkHoly = false
		end if
	End If

	if oJustItem.FResultCount=0 then
		'// 시간 정리
		eTime = GetTranTimer(date() & " 00:00:00")	'종료 시간
		nTime = GetTranTimer(now())					'현재 시간
	else
		'// 시간 정리
		eTime = GetTranTimer(oJustItem.FItemList(0).FJustDate & " 23:59:59")	'종료 시간
		nTime = GetTranTimer(now())												'현재 시간

		'//옵션 HTML생성 
		dim ioptionBoxHtml
		IF (oJustItem.FItemList(0).FOptionCnt>0) then
		    ioptionBoxHtml = GetOptionBoxHTML(oJustItem.FItemList(0).Fitemid, false)
		End IF
	end if

	'//이전/다음달 이동 날짜 지정(2008.05.02; 허진원 추가)
	'이전달 마지막날 지정
	goPreDt = DateSerial(Year(JustDate), month(JustDate),0)
	'다음달 첫날 지정
	goNextDt = DateSerial(Year(JustDate), month(JustDate)+1,1)
	
	If 	oJustItem.FResultCount > 0 Then	
		Dim vSoldOut, vTimerDate
		vSoldOut = "x"
		If DateDiff("n",oJustItem.FItemList(0).FJustDate & " 23:59:59",now()) > 0 Then
			vSoldOut = "o"
		ElseIf (oJustItem.FItemList(0).FlimitYn="Y" and (oJustItem.FItemList(0).FlimitNo-oJustItem.FItemList(0).FlimitSold)<=0) or ((oJustItem.FItemList(0).FSellYn<>"Y")) Then
			vSoldOut = "o"
		End If
		vTimerDate = DateAdd("d",1,oJustItem.FItemList(0).FJustDate)

		Dim vSalePercent
		'가격설정(진행중이면 현재 상품가격, 종료라면 지정할인가 표시)
		if datediff("d",JustDate,date())=0 then
			salePrice = oJustItem.FItemList(0).FsalePrice
		else
			salePrice = oJustItem.FItemList(0).justSalePrice
		end if
		
		vSalePercent = Replace(GetPricePercent(salePrice,oJustItem.FItemList(0).ForgPrice,0),"%","")
	End If

	'// 추가 이미지-메인 이미지
	Function getFirstAddimage()
		if ImageExists(oJustItem.Prd.FImageBasic) then
			getFirstAddimage= oJustItem.Prd.FImageBasic
		elseif ImageExists(oJustItem.Prd.FImageMask) then
			getFirstAddimage= oJustItem.Prd.FImageMask
		elseif (oAdd.FResultCount>0) then
			if ImageExists(oAdd.FADD(0).FAddimage) then
				getFirstAddimage= oAdd.FADD(0).FAddimage
			end if
		else
			getFirstAddimage= oJustItem.Prd.FImageMain
		end if
	end Function


	Function Ceil(ByVal intParam)  

	 Ceil = -(Int(-(intParam)))  

	End Function  
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [직방] 살림살이, 도와드릴게요</title>
<style type="text/css">
<% If newCordYN = "N" Then %>
.mEvt54443 {background-color:#f2f2f2; text-align:left;}
<% Else %>
.mEvt54443 {background-color:#fff; text-align:left;}
<% End If %>
.mEvt54443 img {vertical-align:middle; width:100%;}
.mEvt54443 p {max-width:100%;}
.pagination {height:auto; padding-top:0;}
.household .section, .household .section h3 {margin:0; padding:0;}
.household .heading {position:relative;}
.household .heading .angel {position:absolute; top:62%; left:0; width:100%;}
/* new */
<% If newCordYN = "Y" Then %>
.household .oneday {background-color:#f2f2f2;}
<% End If %>
.household .time {background-color:#ffcc1b; padding:10px 0; color:#000; text-align:center;}
.household .time strong img {width:122px;}
.household .time em {display:inline-block; position:relative; width:30px; height:30px; margin:0 4px 0 12px; padding-top:5px; border-radius:5px; background-color:#ff9001; box-shadow:2px 2px rgba(0,0,0,0.1); vertical-align:middle;}
.household .time em:after {content:' '; position: absolute; top:50%; width:10px; height:10px; margin-top:-5px; background-color:#ff9001; left:-3px;transform:rotate(45deg);-moz-transform:rotate(45deg);-webkit-transform:rotate(45deg);}
.household .time em img {width:18px;}
.household .time span {display:inline-block; width:30px; height:30px; border-radius:5px; background-color:#fff; box-shadow:2px 2px rgba(0,0,0,0.1); font-size:20px; line-height:30px; vertical-align:middle;}
.discount-wrap {position:relative; width:320px; margin:0 auto;}
.discount {display:block; position:absolute; top:10px; right:10px; z-index:50; width:57px; height:57px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54443/ico_tag_discount.png) no-repeat 100% 0; background-size:57px auto; font-weight:normal;}
.discount em {display:block; position:absolute; top:7px; right:0; color:#fff; transform:rotate(45deg);-moz-transform:rotate(45deg);-webkit-transform:rotate(45deg); font-size:23px; font-style:normal; line-height:1.125em;}
.discount em span {font-size:16px;}
.household-swiper {position:relative; width:320px; margin:0 auto; padding:10px 10px 15px;}
.household-swiper .swiper {position:relative;}
.household-swiper .swiper .swiper-container {overflow:hidden; width:300px; height:320px; margin:0 auto;}
.household-swiper .swiper .swiper-slide {float:left; height:300px;}
.household-swiper .swiper .swiper-slide a {display:block; width:300px;}
.household-swiper .swiper .swiper-slide img {width:300px; height:300px; vertical-align:top;}
.household-swiper .swiper .pagination {position:absolute; bottom:0; z-index:200; left:0; width:100%; text-align:center;}
.household-swiper .swiper .pagination span {display:inline-block; position:relative; width:10px; height:10px; margin:0 4px; border:2px solid #000; border-radius:20px; background:transparent; cursor:pointer;}
.household-swiper .swiper .pagination .swiper-active-switch {background-color:#000;}
.household .goods {margin:10px; padding-top:6px; border-top:3px solid #dcdcdc;}
.household .goods .brand {padding:0 8px; color:#888; font-size:0.9em;}
.household .goods h3 {margin-top:7px; padding:0 8px; color:#000; font-weight:bold; font-size:16px;}
.household .goods ul {margin-top:10px; padding-bottom:6px; border-bottom:1px solid #dcdcdc;}
.household .goods ul li {margin-top:7px; padding:0 8px; font-size:12px;}
.household .goods ul li em {color:#000;}
.household .goods ul li span {display:inline-block; width:60px;}
.household .goods ul li img {vertical-align:middle;}
.household .goods ul li:nth-child(1) img {width:32px;}
.household .goods ul li:nth-child(2) img {width:52px;}
.household .goods ul li:nth-child(3) img {width:42px;}
.household .goods ul li:nth-child(3) strong {color:#000;}
.household .goods ul li strong {color:#d70c0c;}
<% If newCordYN = "N" Then %>
.household .goods .btnView {margin:30px 5px 0; text-align:center;}
.household .goods .btnView img {width:277px;}
<% Else %>
.household .goods .btnView {margin:30px 5px; text-align:center;}
.household .goods .btnView img {width:100%;}
<% End If %>
.household .previous, .household .noti {margin-top:30px; padding:0 20px;}
.household .previous h3, .household .noti h3 {padding-bottom:5px; border-bottom:3px solid #dcdcdc;}
.household .previous h3 img {width:86px;}
.previous-swiper .swiper {position:relative;}
.previous-swiper .swiper .swiper-container {overflow:hidden; position:static; width:282px; height:188px; margin:0 auto;}
.previous-swiper .swiper .swiper-slide {float:left; height:188px;}
.previous-swiper .swiper-slide ul {overflow:hidden;}
.previous-swiper .swiper-slide ul li {float:left; width:88px; margin:6px 3px 0; text-align:center;}
.previous-swiper .swiper-slide ul li img {width:88px; height:88px;}
.previous-swiper .swiper .pagination {position:absolute; top:-20px; left:0; width:100%; text-align:right;}
.previous-swiper .swiper .pagination span {display:inline-block; position:relative; width:8px; height:8px; margin:0 4px; border-radius:20px; background-color:#bdbdbd; cursor:pointer;}
.previous-swiper .swiper .pagination span:last-child {margin-right:8px;}
.previous-swiper .swiper .pagination .swiper-active-switch {background-color:#000;}
.household .noti {padding-bottom:20px;}
.household .noti h3 img {width:72px;}
.household .noti ul {margin-top:10px;}
.household .noti ul li {margin-top:3px; padding-left:8px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54443/blt_arrow.gif) no-repeat 0 4px; background-size:4px auto; color:#000; font-size:11px; line-height:1.25em;}
.household .noti ul li em {color:#d70c0c;}
@media all and (min-width:600px){
	.household .time {padding:20px 0;}
	.household .time strong img {width:183px;}
	.household .time em {width:45px; height:45px; padding-top:8px;}
	.household .time em img {width:27px;}
	.household .time span {width:45px; height:45px; font-size:30px; line-height:45px;}
	.discount-wrap {position:relative; width:540px; margin:0 auto;}
	.discount-wrap .discount {width:86px; height:86px; top:30px; right:20px; background-size:86px auto;}
	.discount-wrap .discount em {font-size:35px;}
	.discount-wrap .discount em span {font-size:25px;}
	.household-swiper {width:540px; padding:30px 20px 45px;}
	.household-swiper .swiper .swiper-container {width:500px; height:500px}
	.household-swiper .swiper .swiper-slide {height:500px;}
	.household-swiper .swiper .swiper-slide a {width:500px;}
	.household-swiper .swiper .swiper-slide img {width:500px; height:500px;}
	.household-swiper .swiper .pagination {bottom:-40px;}
	.household .goods {margin:20px 10px; padding-top:12px;}
	.household .goods .brand {font-size:1.313em;}
	.household .goods h3 {margin-top:15px; padding:0 8px; font-size:25px; line-height:1.25em;}
	.household .goods ul {padding-bottom:15px;}
	.household .goods ul li {margin-top:15px; font-size:16px;}
	.household .goods ul li span {width:90px;}
	.household .goods ul li em {color:#000;}
	.household .goods ul li:nth-child(1) img {width:48px;}
	.household .goods ul li:nth-child(2) img {width:78px;}
	.household .goods ul li:nth-child(3) img {width:63px;}
	<% If newCordYN = "N" Then %>
	.household .goods .btnView {margin-top:40px;}
	.household .goods .btnView img {width:390px;}
	<% Else %>
	.household .goods .btnView {margin:40px 5px;}
	.household .goods .btnView img {width:100%;}
	<% End If %>
	.previous-swiper .swiper .swiper-container {width:432px; height:288px;}
	.previous-swiper .swiper-slide ul li {width:132px; margin:12px 6px 0;}
	.previous-swiper .swiper-slide ul li img {width:132px; height:132px;}
	.household-swiper .swiper .pagination span {width:12px; height:12px;}
	.previous-swiper .swiper .pagination span {width:12px; height:12px;}
	.household .previous, .household .noti {margin-top:50px;}
	.household .previous h3, .household .noti h3 {padding-bottom:10px;}
	.household .previous h3 img {width:129px;}
	.household .noti {padding-bottom:40px;}
	.household .noti h3 img {width:108px;}
	.household .noti ul li {margin-top:7px; padding-left:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54443/blt_arrow.gif) no-repeat 0 4px; background-size:6px auto; font-size:15px;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-20px);}
	60% {-webkit-transform: translateY(-15px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-20px);}
	60% {transform: translateY(-15px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script src="/lib/js/swiper-2.1.min.js?d=1"></script>
<script type="text/javascript">


var yr = "<%=Year(vTimerDate)%>";
var mo = "<%=TwoNumber(Month(vTimerDate))%>";
var da = "<%=TwoNumber(Day(vTimerDate))%>";
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
		futurestring=montharray[mo-1]+" "+da+", "+yr+" 00:00:00";

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		if(dday < 0)
		{
			$(".justTime").hide();
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

		$("#lyrCounter1").html(dhour);
		$("#lyrCounter2").html(dmin);
		$("#lyrCounter3").html(dsec);
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}



function goDate(dt) {
	if(dt<"<%=dateSerial(year(date),month(date)-2,1)%>") {
		alert("최근 3개월까지 보실 수 있습니다.");
		return;
	}
	if(dt>"<%=date()%>") {
		alert("현재 날짜 이후로는 보실 수 없습니다.");
		return;
	}
	self.location="<%=CurrUrl()%>?justDate=" + dt;
}

$(function() {
	//counter
	countdown();


	showSwiper1 = new Swiper('.swiper1', {
		pagination : '.pagination1',
		loop:false,
		resizeReInit:true,
		calculateHeight:true,
		paginationClickable:true,
		speed:180

	});

	showSwiper2 = new Swiper('.swiper2', {

		pagination : '.pagination2',
		loop:false,
		resizeReInit:true,
		calculateHeight:true,
		paginationClickable:true,
		speed:180
	});
});

</script>

</head>
<body>
<%' [직방] 살림살이, 도와드릴게요 %>
<div class="mEvt54443">
	<div class="household">
	<% If newCordYN = "Y" Then %>
		<div class="section heading">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_zigbang.gif" alt="방 구하고, 방 꾸미고 살림살이, 직방에서!" /></p>
		</div>
	<% Else %>
		<div class="section heading">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_help_household.gif" alt="방 고객님들을 위한 텐바이텐의 특별한 혜택! 살림살이, 도와드릴게요" /></p>
			<span class="angel animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/img_angel.png" alt="" /></span>
		</div>
	<% End If %>
	<% If oJustItem.FResultCount > 0 Then %>
		<div class="section oneday">
			<%' for dev msg : 남은시간 %>
		<% If newCordYN = "N" Then %>
			<div class="time">
				<strong><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_just_one_day.gif" alt="" /></strong>
				<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_time.gif" alt="남은시간" /></em>
				<span id="lyrCounter1"></span> :	
				<span id="lyrCounter2"></span> :	
				<span id="lyrCounter3"></span>
			</div>
		<% End If %>
			<%' for dev msg : 상품 스와이프 영역 %>
			<div class="discount-wrap">
				<strong class="discount"><em><%=vSalePercent%><span>%</span></em></strong>
				<div class="household-swiper">
					<div class="swiper">
						<div class="swiper-container swiper1">
							<div class="swiper-wrapper">
								<%
									'//기본 이미지
									Response.Write "<div class=""swiper-slide""><img src=""" & oJustItem.FItemList(0).FBasicImage & """ alt=""" & oJustItem.FItemList(0).FItemName & """  /></div>"
									'//누끼 이미지
									if Not(isNull(oJustItem.FItemList(0).FImageMask) or oJustItem.FItemList(0).FImageMask="") then
										Response.Write "<div class=""swiper-slide""><img src=""" & oJustItem.FItemList(0).FImageMask & """ alt=""" & oJustItem.FItemList(0).FItemName & """ /></div>"
									end if
									'//추가 이미지
									IF oAdd.FResultCount > 0 THEN
										FOR i= 0 to oAdd.FResultCount-1
											'If i >= 3 Then Exit For
											IF oAdd.FADD(i).FAddImageType=0 THEN
												Response.Write "<div class=""swiper-slide""><img src=""" & oAdd.FADD(i).FAddimage & """ alt=""" & oJustItem.FItemList(0).FItemName & """ style=""width:100%;"" /></div>"
											End IF
										NEXT
									END IF
								%>
							</div>
							<div class="pagination pagination1"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="goods">
				<em class="brand"><%=oJustItem.FItemList(0).Fbrandname%></em>
				<h3><%=oJustItem.FItemList(0).Fitemname%></h3>
				<ul>
					<% If (oJustItem.FItemList(0).ForgPrice>oJustItem.FItemList(0).FsalePrice) Then %>
						<li>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_price.gif" alt="판매가" /></span>
							<em><%=FormatNumber(oJustItem.FItemList(0).ForgPrice,0)%>원</em>
						</li>
						<li>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_discount_price.gif" alt="할인판매가" /></span>
							<strong><%=FormatNumber(salePrice,0)%>원 [<%=vSalePercent%>%]</strong>
						</li>
					<% Else %>
						<li>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_price.gif" alt="판매가" /></span>
							<em><%=FormatNumber(oJustItem.FItemList(0).ForgPrice,0)%>원</em>
						</li>
					<% End If %>
					<%' 한정상품일 경우 %>
					<% If oJustItem.FItemList(0).FlimitYn="Y" and oJustItem.FItemList(0).FLimitDispYn="Y" AND DateDiff("n",oJustItem.FItemList(0).FJustDate & " 23:59:59",now()) < 0 Then %>
						<li>
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/txt_limit.gif" alt="한정상품" /></span>
							<strong><%=chkIIF((oJustItem.FItemList(0).FlimitNo-oJustItem.FItemList(0).FlimitSold<1),"0",FormatNumber(oJustItem.FItemList(0).FlimitNo-oJustItem.FItemList(0).FlimitSold,0))%></strong>개 남았습니다.
						</li>
					<% End If %>
				</ul>
			<% If (oJustItem.FItemList(0).FlimitYn="Y" and (oJustItem.FItemList(0).FlimitNo-oJustItem.FItemList(0).FlimitSold)<=0) or ((oJustItem.FItemList(0).FSellYn<>"Y")) Then %>
				<% If newCordYN = "N" Then %>
				<div class="btnView"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/btn_soldout.gif" alt="재고없음" /></div>
				<% Else %>
				<div class="btnView"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/btn_soldout_new.gif" alt="재고없음" /></div>
				<% End If %>
			<% Else %>
				<% If newCordYN = "N" Then %>
				<div class="btnView"><a href="/category/category_itemPrd.asp?itemid=<%=oJustItem.FItemList(0).Fitemid%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/btn_view.gif" alt="오늘 원데이 상품 상세보기" /></a></div>
				<% Else %>
				<div class="btnView"><a href="/category/category_itemPrd.asp?itemid=<%=oJustItem.FItemList(0).Fitemid%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/btn_buy.gif" alt="구매하러 가기" /></a></div>
				<% End If %>
			<% End If %>
			</div>
		<% If newCordYN = "Y" Then %>
			<div class="goods-detail">
				<img src="<%= oJustItem.FItemList(0).FcontentImgUrl %>" alt="상세이미지" />
			</div>
		<% End If %>
		</div>
		<%' 이전 1 DAY 상품 %>
		<% If newCordYN = "N" AND oPrev1DayItem.FResultCount > 0 Then %>
		<div class="section previous">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/tit_just_one_day_prev.gif" alt="이전 원데이 상품" /></h3>
			<div class="previous-swiper">
				<div class="swiper">
					<div class="swiper-container swiper2">
						<div class="swiper-wrapper">
							<%' for dev msg : swiper-slide가 한 묶음 입니다. %>
							<div class="swiper-slide">
								<ul>
									<%' for dev msg : 아직 오픈전인 상품은 _yet.jpg이 붙고 오픈한 상품은 _open.jpg 네이밍 했어요 %>
									<% If oPrev1DayItem.FResultCount > 0 Then %>
										<% For i = 0 To oPrev1DayItem.FResultCount-1 %>
											<li><a href="/category/category_itemPrd.asp?itemid=<%=oPrev1DayItem.FItemList(i).Fitemid%>" target="_top"><img src="<%=oPrev1DayItem.FItemList(i).Flistimage150%>" alt="<%=oPrev1DayItem.FItemList(i).FItemName%>"  /></a></li>
											<% If oPrev1DayItem.FResultCount-1 = i Then %>
													<% For j = 1 To (Ceil(oPrev1DayItem.FResultCount/6)*6-oPrev1DayItem.FResultCount) %>
														<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/img_small_08_yet.jpg" alt="커밍순" /></li>
													<% Next %>
													</ul>
												</div>
											<% Else %>
												<% If (i+1) Mod 6 = 0 Then %>
													</ul>
												</div>
												<div class="swiper-slide">
													<ul>
												<% End If %>
											<% End If %>
										<% Next %>
									<% End If %>
						</div>
						<div class="pagination pagination2"></div>
					</div>
				</div>
			</div>
		</div>
		<% End If %>
	<% End If %>
		<%' 유의사항 %>
	<% If newCordYN = "N" Then %>
		<div class="section noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/tit_noti.gif" alt="구매유의사항" /></h3>
			<ul>
				<li>Just 1 Day 상품은 텐바이텐에서 만나 볼 수 있습니다.</li>
				<li>텐바이텐 아이디 및 비회원주문이 모두 가능합니다.</li>
				<li><em>한정수량인 경우 실시간 결제로만 구매</em>하실 수 있습니다.</li>
				<li>상품은 결제순으로 판매/배송 처리되며, 초과될 경우 결제순으로 환불처리 됩니다.</li>
				<li>상품 정보 및 교환/환불 정책은 <em>상품 상세 페이지의 안내를 반드시 확인</em>해 주시기 바랍니다.</li>
			</ul>
		</div>
	<% Else %>
		<div class="section noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54443/tit_noti_new.gif" alt="구매유의사항" /></h3>
			<ul>
				<li>본 이벤트는 당사 사정에 의해 예고없이 종료될 수 있으며, 준비된 상품과 수량이 변경될 수 있습니다.</li>
				<li>이벤트 기간 종료 시 혜택 및 가격이 변경될 수 있습니다.</li>
				<li>텐바이텐 아이디 및 비회원 주문이 모두 가능합니다.</li>
				<li><em>한정수량인 경우 실시간 결제</em>로만 구매하실 수 있습니다.</li>
				<li>상품은 결제순으로 판매/배송 처리되며, 초과될 경우 결제순으로 환불처리 됩니다.</li>
				<li>상품 정보 및 교환/환불 정책은 <em>상품 상세 페이지의 안내</em>를 반드시 확인해 주시기 바랍니다. </li>
			</ul>
		</div>
	<% End If %>
	</div>
</div>
<%' //[직방] 살림살이, 도와드릴게요 %>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->