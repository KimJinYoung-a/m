<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/main/mainAlarmCls.asp" -->
<%
	'// 변수 선언
	Dim selDate, lp, lpDt, selTerm
	selDate = getNumeric(requestCheckVar(Request("seldt"),8))

	'날짜 확인(오늘기준으로 7일전부터 2일뒤까지; 기간 총 10일)
	if selDate="" or len(selDate)<>8 then selDate = replace(date,"-","")
	if selDate<replace(dateadd("d",-7,date),"-","") or selDate>replace(dateadd("d",2,date),"-","") then
		selDate = replace(date,"-","")
	end if
	selTerm = dateDiff("d",date,DateSerial(left(selDate,4),mid(selDate,5,2),right(selDate,2))) +7		'날짜 슬라이드 번호

	dim sDloop
	sDloop = 5 - dateDiff("d","2013-04-14",date)
	if sDloop<=0 then sDloop=0
	sDloop = 3		'과거 5일치부터 시작 (2013.10.02)
%>
<div class="alarm">
	<p class="alarmNum" style="display:none;">1</p>
	<section>
		<div class="bgSkyBl welcome" id="lyAlarmWcm" style="display:none;">
			<div class="elmBg2 rdBox1 bgWt mar10">
			<%
				If (Not IsUserLoginOK) Then
					If (IsGuestLoginOK) Then
						'## 주문번호로 로그인시
			%>
				<div>
					<p class="b ftMidSm2"><span class="c36b8cb">고객</span>님 환영합니다.</p>
					<p class="c999 ftSmall2">텐바이텐과 함께 즐거운 쇼핑을 즐겨보세요.</p>
				</div>
			<%
					else
						'## 로그인정보 없음
			%>
				<div>
					<p class="b ftMidSm2">10X10에 오신것을 환영합니다.</p>
					<p class="c999 ftSmall2">감성쇼핑의 새로운 경험을 느껴보세요.</p>
					<p class="b c555 ftSmall"><a href="/login/login.asp">로그인 &gt;</a></p>
				</div>
			<%
					end if
				else
					'## 회원 로그인 시
			%>
				<div>
					<p class="b ftMidSm2"><span class="c36b8cb"><%= GetLoginUserID %></span>님 환영합니다.</p>
					<p class="c999 ftSmall2">텐바이텐과 함께 즐거운 쇼핑을 즐겨보세요.</p>
				</div>
			<%	end if %>
			</div>
			<span class="close elmBg" opt="<%=chkIIF(IsUserLoginOK,"Wcm1","Wcm2")%>"></span>
		</div>
		<script>if ( cookiedata.indexOf("<%=chkIIF(IsUserLoginOK,"tenAlarm_Wcm1","tenAlarm_Wcm2")%>=done") < 0 ){$("#lyAlarmWcm").show();}</script>
<%	If (IsUserLoginOK) Then %>
	<% if request.cookies("uinfo")("isEvtWinner") then %>
		<div class="bgSkyBl event" id="lyAlarmEvt" style="display:none;">
			<div class="elmBg2 rdBox1 bgWt mar10">
				<div>
					<p class="b ftMidSm2">이벤트에 당첨되셨습니다.</p>
					<p class="c999 ftSmall2">당첨자 발표공지를 확인해 주세요!</p>
					<p class="b c555 ftSmall"><a href="/my10x10/myeventmaster.asp">확인하기 &gt;</a></p>
				</div>
				<span class="close elmBg" opt="ew"></span>
		</div>
		<script>if ( cookiedata.indexOf("tenAlarm_ew=done") < 0 ){$("#lyAlarmEvt").show();} </script>
	<% end if %>
	<!-- #include virtual="/lib/inc/inc_mainAlarmAnniver.asp" -->
	<!-- #include virtual="/lib/inc/inc_mainAlarmNotice.asp" -->
<%	end if %>
	</section>
</div>
<div class="dateWrap">
	<div class="dateView swiper-container swiper-car">
		<ul class="dateList swiper-wrapper">
			<li class="swiper-slide"></li>
			<li class="swiper-slide"></li>
		<%
			for lp=sDloop to 9
				lpDt = dateAdd("d",lp-7,date)
				
		%>
			<li class="swiper-slide<%=chkIIF(selDate=Replace(lpDt,"-","")," current","")%>" onclick="mainSelDate('<%=Replace(lpDt,"-","")%>')" opt="<%=Replace(lpDt,"-","")%>" >
				<p><%=Replace(right(lpDt,5),"-",".")%></p>
				<span><%=split("일,월,화,수,목,금,토",",")(datePart("w",lpDt)-1)%>요일</span>
			</li>
		<%	next %>
			<li class="swiper-slide"></li>
			<li class="swiper-slide"></li>
		</ul>
	</div>
</div>
<div class="mainWrap">
<%
	'## 메인 템플릿
	server.Execute("/chtml/main/mainLoader.asp")
%>
</div>
<script>
$(function() {
	//date control
	swiperCar = $('.swiper-car').swiper({
		slidesPerSlide : 5
		, initialSlide : <%=selTerm-sDloop%>
		, onSlideChangeEnd : function() {
			var nowAtv = swiperCar.getSlide(swiperCar.activeSlide+2);
			mainSelDate($(nowAtv).attr("opt"));
		}
	});

	//알림닫기
	$("section .close").click(function(){
		$(this).parent().fadeOut(function(){
			var aCnt = $(".bgSkyBl:visible").length;
			if(aCnt>0) {
				$(".alarmNum").html(aCnt)
				if(aCnt==1) $(".alarmNum").hide();
			} else {
				$(".alarm").hide();
			}
		});
		if($(this).attr("opt")!="") {
			setCookie("tenAlarm_"+$(this).attr("opt"), "done", 1);
		}
	});

	//알람수 지정
	if($(".bgSkyBl:visible").length>1) {
		$(".alarmNum").html($(".bgSkyBl:visible").length).fadeIn();
	} else if($(".bgSkyBl:visible").length<=0) {
		$(".alarm").hide();
	}
});
</script>