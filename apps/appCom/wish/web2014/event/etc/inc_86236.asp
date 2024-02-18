<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 5월 매일리지
' History : 2018-05-10 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-05-14 ~ 2018-05-22
'   - 오픈시간 : 24시간
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
	'// 기본은 매일 출석체크
	Dim eCode, userid, vQuery, currenttime, vEventStartDate, vEventEndDate
	Dim i, numTimes, TodayCount, TotalMileage, TodayDateCheck

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  68518
	Else
		eCode   =  86236
	End If

	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30) 

	If isapp <> "1" Then 
		Response.redirect "/event/eventmain.asp?eventid=86237&gaparam="&gaparamChkVal
		Response.End
	End If

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-05-22 오전 10:03:35"

	vEventStartDate = "2018-05-14"
	vEventEndDate = "2018-05-22"


	'// 연속출석 체크
	TodayCount = 0
	numTimes = datediff("d", vEventStartDate, currenttime)
	'Response.write "numTimes : "&datediff("d", vEventStartDate, currenttime)&"<br>"

	If IsUserLoginOK() Then
		' 현재날짜를 기준으로 이벤트 시작일로 부터 몇일째인지 가져온 후 루프돈다.
		For i=1 To numTimes
			'Response.write Left(dateadd("d", ((numTimes+1)-i)*-1, currenttime), 10)&"<br>"
			vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(dateadd("d", ((numTimes+1)-i)*-1, currenttime), 10)&"' ORDER BY sub_idx ASC "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			IF Not(rsget.Bof Or rsget.Eof) Then
				TodayCount = TodayCount + 1
			Else
				TodayCount = 0
			End If
			'Response.write TodayCount&"<br>"
			rsget.close
		Next

		' 현재까지 발급받은 총 마일리지값을 가져온다.
		vQuery = "SELECT isnull(sum(sub_opt2), 0) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		TotalMileage = rsget(0)
		rsget.close

		' 오늘 출석체크를 했는지 확인한다.
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(currenttime, 10)&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		TodayDateCheck = rsget(0)
		rsget.close
	End If

%>
<style type="text/css">
.maeileage {background:#7000bb;}
.get-mileage {position:relative;}
.get-mileage span {position:absolute; right:18%; top:50%; margin-top:-1.185rem; color:#222; font-size:2.35rem; text-align:right; letter-spacing:-1px; font-weight:600;}
.get-mileage span em {font-family:'AvenirNext-Regular', 'AppleSDGothicNeo-Light'; font-size:2.82rem;}
.attendance button {width:100%;}
.today-noti {background:#c48eff url(http://webimage.10x10.co.kr/eventIMG/2018/86236/m/bg_replay.png) no-repeat 50% 0; background-size:100%;}
.today-noti img {animation:bounce 1s 50;}
.lyr-daily-chk {display:none; position:absolute; top:7%; left:0; z-index:50; width:100%;}
.lyr-daily-chk > div {position:relative; vertical-align:top;}
.lyr-daily-chk > div img {display:inherit;}
.lyr-daily-chk .today-chk {position:absolute; top:8%; left:0; width:100%; text-align:center; font-size:2.47rem; color:#222; letter-spacing:-0.5px; line-height:1.3; font-weight:bold; font-family:'apple gothic', sans-serif;}
.lyr-daily-chk .today-chk span {color:#0face7;}
.lyr-daily-chk .point {display:block; position:absolute; left:0; top:35%; width:100%; text-align:center; color:#222; font-family:'apple gothic', sans-serif; font-size:1.45rem; line-height:2.7rem; font-weight:bold;}
.lyr-daily-chk .point span {font-size:2.99rem; font-weight:normal; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; letter-spacing:-1.5px;}
.lyr-daily-chk .tomorrow-chk {position:absolute; left:0; top:60%; width:100%; text-align:center; color:#a95dfc; font-size:1.37rem;}
.lyr-daily-chk .tomorrow-chk strong {font-weight:normal; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-size:1.45rem; letter-spacing:-0.5px;}
.lyr-daily-chk .tip {position:absolute; left:12%; top:66%; width:76%; text-align:center;}
.lyr-daily-chk .btn-noti-request {position:absolute; left:12%; top:74%; width:76%; background-color:transparent;}
.lyr-daily-chk .btnClose {position:absolute; top:2%; right:9%; width:10%; height:10%; text-indent:-9999em; background-color:transparent;}
.lyr-daily-chk .lyr-finish .today-chk {top:10%;}
.lyr-daily-chk .lyr-finish .point {top:43%;}
.lyr-daily-chk .lyr-finish .txt-finish {display:block; position:absolute; left:0; top:74%; width:100%; text-align:center; color:#8541d1; font-family:'apple gothic', sans-serif; font-size:1.45rem; line-height:1.7rem; font-weight:600;}
.detail-view {padding:1.54rem 0; background-color:#7126c2; text-align:center;}
.detail-view span {display:inline-block; position:relative; padding-right:1.5rem; color:#ace6fb; font-size:1.24rem;}
.detail-view span:after {display:block; position:absolute; right:0; top:50%; width:0.85rem; height:0.47rem; margin-top:-0.235rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/86236/m/ico_arrow_btm.png) no-repeat 50% 50%; background-size:100%; content:''; z-index:10;}
.detail-view span.open:after {background:url(http://webimage.10x10.co.kr/eventIMG/2018/86236/m/ico_arrow_top.png) no-repeat 50% 50%; background-size:100%;}
.daily-board {overflow:hidden; width:100%; background-color:#2d2e3d;}
.daily-board li {position:relative; float:left; width:33.3%; padding-bottom:24%; border:1px solid #383a53;}
.daily-board li:nth-child(1), .daily-board li:nth-child(2), .daily-board li:nth-child(3) {border-top:2px solid #383a53;}
.daily-board li:nth-child(13), .daily-board li:nth-child(14), .daily-board li:nth-child(15) {border-bottom:none;}
.daily-board li:nth-child(3n) {border-right:none;}
.daily-board li:nth-child(3n+1) {border-left:none;}
.daily-board li .daily-box {position:absolute; left:0; top:50%; width:100%; margin-top:-1.9rem; text-align:center;}
.daily-board li .daily-box p {color:#46b9e4; font-size:1.32rem;}
.daily-board li .daily-box p em {font-size:0;}
.daily-board li .daily-box strong {display:block; padding-top:0.85rem; color:#fff; font-size:1.62rem; font-weight:normal; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium';}
.daily-board li.current:before {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-top:3px solid #fdf355; z-index:10; transform-origin:100% 0;}
.daily-board li.current:after {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-right:3px solid #fdf355; z-index:10; transform-origin:0 100%;}
.daily-board li.current:nth-child(13) .current-fr:before, .daily-board li.current:nth-child(14) .current-fr:before, .daily-board li.current:nth-child(15) .current-fr:before {bottom:0;}
.daily-board li.current:nth-child(3n):after {right:0;}
.daily-board li.current:nth-child(3n+1) .current-fr:after {left:0;}
.daily-board li.current .daily-box p {color:#46b9e4;}
.daily-board li.current .daily-box strong {color:#fff;}
.daily-board li.current .current-fr {position:absolute; left:0; top:0; width:100%; height:100%;}
.daily-board li.current .current-fr:before {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-bottom:3px solid #fdf355; z-index:10; transform-origin:0 100%;}
.daily-board li.current .current-fr:after {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-left:3px solid #fdf355; z-index:10; transform-origin:0 0;}
.daily-board li.line-motion:before, .daily-board li.line-motion .current-fr:before {animation:lineX 1s ease both ;}
.daily-board li.line-motion:after, .daily-board li.line-motion .current-fr:after {animation:lineY 1s ease both ;}
.daily-board li.previous .daily-box p {color:#595d83;}
.daily-board li.previous .daily-box strong {color:#595d83;}
.daily-board li.done .daily-box p em, .daily-board li.pass .daily-box p em {font-size:1.32rem; letter-spacing:-0.75px;}
.daily-board li.done .daily-box strong {text-decoration:line-through;}
.push-request {position:relative;}
.push-request h3 {position:absolute; left:0; top:23%; width:38%; animation:bounce .8s 50;}
.push-request button {position:absolute; left:0; top:50%; width:100%; background-color:transparent; z-index:1;}
.noti {background:#2d2e3d;}
.noti ul {padding:2% 9% 10%;}
.noti li {padding:1rem 0 0 0.65rem; color:#fff; font-size:1.02rem; line-height:1.45rem; text-indent:-0.65rem;}
.noti li:first-child {padding-top:0;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
@keyframes lineX {
	from {transform:scaleX(0)}
	to {transform:scaleX(1)}
}
@keyframes lineY {
	from {transform:scaleY(0)}
	to {transform:scaleY(1)}
}
#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.55);}
</style>
<script type="text/javascript">
	$(function() {
		$('.daily-board .done div').children('p').append('<em> (지급완료)</em>');
		$('.daily-board .pass div').children('p').append('<em> (출석실패)</em>');
		$('.daily-board .current').append('<div class="current-fr"></div>');

		var isVisible = false;
		$(window).on('scroll',function() {
			if (checkVisible($('.step-process'))&&!isVisible) {
				$(".daily-board li.current").addClass("line-motion");
				isVisible=true;
			}
		});
		function checkVisible( elm, eval ) {
			eval = eval || "object visible";
			var viewportHeight = $(window).height(),
				scrolltop = $(window).scrollTop(),
				y = $(elm).offset().top,
				elementHeight = $(elm).height();
			if (eval == "object visible") return ((y < (viewportHeight + scrolltop)) && (y > (scrolltop - elementHeight)));
			if (eval == "above") return ((y < (viewportHeight + scrolltop)));
		}

		/* layer */
		$("#btnClose").click(function(){
			$("#lyrDailyChk").hide();
			$("#mask").fadeOut();
			$(".step-process .detail-view").children("span").removeClass('open');
			$(".step-process .daily-board").hide();
		});

		$("#mask").click(function(){
			$("#lyrDailyChk").hide();
			$("#mask").fadeOut();
			$(".step-process .detail-view").children("span").removeClass('open');
			$(".step-process .daily-board").hide();
		});

		$(".step-process .detail-view").click(function(){
			if($(this).children("span").hasClass('open')) {
				$(this).children("span").removeClass('open');
				$(this).children("span").html('상세 지급내역 확인하기');
				$(".step-process .daily-board").hide();
			} else {
				$(this).children("span").addClass('open');
				$(this).children("span").html('상세 지급내역 접기');
				$(".step-process .daily-board").show();
			}
		});
	});
	function jsMaeilageSubmit(){
		<% If not(IsUserLoginOK) Then %>
			parent.calllogin();
			return false;
		<% end if %>

		<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
			alert("이벤트 응모기간이 아닙니다.");
			return false;
		<% end if %>

		$.ajax({
			type:"GET",
			url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript86236.asp?mode=add",
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							//str = str.replace("undefined","");
							res = Data.split("|");
							if (res[0]=="OK")
							{
								$("#MileagePointCurrent").empty().html(res[3]);
								$("#chkAttendance").hide();
								$("#attendancecheckok").show();
								$("#today-mileage-value").empty().html(res[4]+"p");
								$("#tomorrow-mileage-value").empty().html(res[1]);
								$("#maeliageDate<%=left(currenttime, 10)%>").addClass("done");
								$("#maeliageStatus<%=left(currenttime, 10)%>").append('<em> (지급완료)</em>');
								$("#lyrDailyChk").show();
								$("#mask").show();
								$("#detail-view-area").removeClass('open');
								$("#detail-view-area").html('상세 지급내역 확인하기');
								var val = $('#lyrDailyChk').offset();
								$('html,body').animate({scrollTop:val.top-88},200);
								return false;
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg);
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							document.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){

					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;

			}
		});
	}

	function jsMaeilagePushSubmit(){
		<% If not(IsUserLoginOK) Then %>
			parent.calllogin();
			return false;
		<% end if %>

		<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
			alert("이벤트 응모기간이 아닙니다.");
			return false;
		<% end if %>

		$.ajax({
			type:"GET",
			url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript86236.asp?mode=pushadd",
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							//str = str.replace("undefined","");
							res = Data.split("|");
							if (res[0]=="OK")
							{
								alert("신청되었습니다.");
								$("#lyrDailyChk").hide();
								$("#mask").fadeOut();
								$(".step-process .detail-view").children("span").removeClass('open');
								$(".step-process .daily-board").hide();
								$('html, body').animate({scrollTop : $("#pushManual").offset().top}, 400);
								//return false;
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg);
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							document.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){

					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;

			}
		});
	}

</script>
<%' 5월 매일리지 %>
	<div class="mEvt86236 maeileage">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_maeileage.png" alt="매일리지" /></h2>

		<div class="attendance">
			<%' for dev msg : 마이텐바이텐 마일리지 내역화면으로 이동 %>
			<div class="get-mileage" onclick="fnAPPpopupBrowserURL('마일리지 내역','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/mileagelist.asp','right','','sc');return false;">
				<span><em id="MileagePointCurrent"><%=FormatNumber(TotalMileage, 0)%></em>p</span>
				<img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/bg_now_mileage.png" alt="현재까지 받은 마일리지" />
			</div>
			<button type="button" id="chkAttendance" class="chk-attendance" onclick="jsMaeilageSubmit();return false;" <% If TodayDateCheck > 0 Then %>style="display:none"<% Else %><% End If %>><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/btn_attendance.png" alt="출석 체크하기" /></button>
			<span class="chk-attendance-ok" id="attendancecheckok" <% If TodayDateCheck > 0 Then %><% Else %>style="display:none"<% End If %>><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/btn_attendance_ok.png" alt="출석체크 완료" /></span>
			<div class="today-noti">
				<img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/txt_replay_noti.png" alt="하루라도 놓치면 100p 부터 다시 시작" />
			</div>
		</div>

		<%' 출석체크 버튼을 누르면 출력되는 레이어 영역 %>
		<div id="lyrDailyChk" class="lyr-daily-chk">
			<% If Not(Left(currenttime, 10) >= vEventEndDate) Then %>
				<div>
					<p class="today-chk" id="today-chk-value"><span><%=CInt(Mid(currenttime, 6, 2))%>월 <%=CInt(Mid(currenttime, 9, 2))%>일</span><br />출석체크 완료!</p>
					<strong class="point"><span id="today-mileage-value"></span><br />지급 완료</strong>
					<p class="tomorrow-chk">내일 받을 마일리지는 <strong id="tomorrow-mileage-value"></strong> 입니다.</p>
					<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/txt_tip.png" alt="TIP 잊지 않게 알림 신청하고 마일리지 받아가세요!" /></p>
					<button type="button" class="btn-noti-request" onClick="jsMaeilagePushSubmit();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/btn_tomorrow_push2.png" alt="내일의 매일리지 알림 신청" /></button>
					<button type="button" id="btnClose" class="btnClose">닫기</button>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/lyr_bg.png" alt="" />
				</div>
			<% Else %>
				<div class="lyr-finish">
					<p class="today-chk"><span><%=CInt(Mid(currenttime, 6, 2))%>월 <%=CInt(Mid(currenttime, 9, 2))%>일</span><br />출석체크 완료!</p>
					<strong class="point"><span id="today-mileage-value"></span><br />지급 완료</strong>
					<p class="txt-finish">매일매일 찾아와주셔서<br />감사합니다!</p>
					<button type="button" id="btnClose" class="btnClose">닫기</button>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/lyr_bg_finish.png" alt="" />
				</div>
			<% End If %>
		</div>
		<div id="mask"></div>
		<%'// 출석체크 버튼을 누르면 출력되는 레이어 영역 %>

		<div class="step-process">
			<div class="detail-view"><span class="open" id="detail-view-area">상세 지급 내역 접기</span></div>
			<% If IsUserLoginOK() Then %>
				<ul class="daily-board">
				<%
					Dim FutureValMileage
					FutureValMileage = TodayCount + 1
					vQuery = " Select CONVERT(VARCHAR(10), m.maeliageDate, 120) as maeliageDate, " + vbCrlf
					vQuery = vQuery & "	( " + vbCrlf
					vQuery = vQuery & "			Select top 1 sub_opt2 From db_event.dbo.tbl_event_subscript " + vbCrlf
					vQuery = vQuery & "			Where convert(varchar(10), regdate, 120) = convert(varchar(10), m.maeliageDate, 120) And evt_code='"&eCode&"' And userid='"&userid&"' " + vbCrlf
					vQuery = vQuery & "	) as point " + vbCrlf
					vQuery = vQuery & "	From db_temp.[dbo].[tbl_maeliageDateMay] m "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.eof) Then
						Do Until rsget.eof
				%>
							<li id="maeliageDate<%=rsget("maeliageDate")%>" class="
							<% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
							 previous
								<% If isnull(rsget("point")) Then %>
								 pass
								<% Else %>
								 done
								<% End If %>
							<% End If %>
							<% If rsget("maeliageDate") = Left(currenttime, 10) Then %>
							 current
								<% If Not(isnull(rsget("point"))) Then %>
									 done
								<% End If %>
							<% End If %>
							">
								<div class="daily-box">
									<p id="maeliageStatus<%=rsget("maeliageDate")%>"><%=CInt(Mid(rsget("maeliageDate"), 6, 2))%>월 <%=CInt(Mid(rsget("maeliageDate"), 9, 2))%>일</p>
									<% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
										<strong>
											<% If isnull(rsget("point")) Then %>
												0p
											<% Else %>
												<%=rsget("point")%>p
											<% End If %>
										</strong>
									<% ElseIf rsget("maeliageDate") = Left(currenttime, 10) Then %>
										<strong>
											<% If isnull(rsget("point")) Then %>
												<% If TodayDateCheck = 0 Then %>
													<%=(TodayCount+1)*100%>p
												<% Else %>
													0p
												<% End If %>
											<% Else %>
												<%=rsget("point")%>p
											<% End If %>
										</strong>
									<% Else %>
										<strong><%=FutureValMileage*100%>p</strong>
									<% End If %>
								</div>
							</li>
				<%
						If rsget("maeliageDate") >= Left(currenttime, 10) Then
							FutureValMileage = FutureValMileage + 1
						End If
						rsget.movenext
						Loop
					End If
					rsget.close
				%>
				</ul>
			<% Else %>
				<ul class="daily-board">
				<%
					Dim FutureValMileageNoMember
					FutureValMileageNoMember = TodayCount + 1
					vQuery = " Select CONVERT(VARCHAR(10), m.maeliageDate, 120) as maeliageDate " + vbCrlf
					vQuery = vQuery & "	From db_temp.[dbo].[tbl_maeliageDateMay] m "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.eof) Then
						Do Until rsget.eof
				%>
							<li class="
							<% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
							 previous
							<% End If %>
							<% If rsget("maeliageDate") = Left(currenttime, 10) Then %>
							 current
							<% End If %>
							">
								<div class="daily-box">
									<p><%=CInt(Mid(rsget("maeliageDate"), 6, 2))%>월 <%=CInt(Mid(rsget("maeliageDate"), 9, 2))%>일</p>
									<% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
										<strong>0p</strong>
									<% ElseIf rsget("maeliageDate") = Left(currenttime, 10) Then %>
										<strong><%=(TodayCount+1)*100%>p</strong>
									<% Else %>
										<strong><%=FutureValMileageNoMember*100%>p</strong>
									<% End If %>
								</div>
							</li>
				<%
						If rsget("maeliageDate") >= Left(currenttime, 10) Then
							FutureValMileageNoMember = FutureValMileageNoMember + 1
						End If
						rsget.movenext
						Loop
					End If
					rsget.close
				%>
				</ul>
			<% End If %>
		</div>
		<% If Not(currenttime >= vEventEndDate) Then %>
			<div class="push-request">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_tip.png" alt="TIP!" /></h3>
				<img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_push_request.png" alt="푸시 신청하고 매일 불어나는 마일리지를 놓치지 마세요!" />
				<button type="button" onClick="jsMaeilagePushSubmit();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/btn_tomorrow_push.png" alt="내일의 매일리지 알림 신청" /></button>
			</div>
		<% End If %>
		<div id="pushManual">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_push_check.png" alt="푸시 수신 확인 방법" /></h3>
			<ul>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/img_push_step1.png" alt="STEP 01" /></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/img_push_step2.png" alt="STEP 02" /></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/img_push_step3.png" alt="STEP 03" /></li>
			</ul>
		</div>
		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_noti.png" alt="유의사항" /></h3>
			<ul>
				<li>- 본 이벤트는 하루에 한 번씩만 참여할 수 있습니다.</li>
				<li>- 이벤트 참여 이후에 연속으로 출석하지 않았을 시, 100p부터 다시 시작됩니다.</li>
			</ul>
		</div>
	</div>
<%'// 5월 매일리지 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->