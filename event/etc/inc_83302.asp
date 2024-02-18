<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마일리지 2018
' History : 2017-12-27 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-01-02 ~ 2018-01-07
'   - 오픈시간 : 매일오전 10시
'   - 일별한정갯수 : 2018개
'   - 지급마일리지 : 5,000 마일리지
'   - 마일리지소멸일자 : 2018년 1월 22일 오전내 소멸
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
	'// tbl_event_subscript에 마일리지 신청내역 저장 후 실제 보너스 마일리지로 지급
	'// 해당 이벤트는 진행기간중 무조건 1회까지만 참여가능(중복참여불가)
	'// 일자별로 오전 10시에 오픈 되는걸 반드시 적용할 것
	Dim eCode, userid, vQuery, vTotalCount, vBoolUserCheck, vMaxEntryCount, vNowEntryCount, vEventStartDate, vEventEndDate, currenttime

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67497
	Else
		eCode   =  83302
	End If

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-01-07 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-01-02"

	'// 이벤트종료시간
	vEventEndDate = "2018-01-07"

	'해당 일자의 마일리지 응모수량
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE convert(varchar(10), regdate, 120) = '" & Left(Trim(currenttime), 10) & "' AND evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	rsget.close

	'로그인 한 유저가 해당 이벤트를 참여 했는지 확인.
	If IsUserLoginOK() Then
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			If rsget(0) > 0 Then
				vBoolUserCheck = True
			Else
				vBoolUserCheck = False
			End If
		End IF
		rsget.close
	End If

	'// 최대 응모수량 1월 2일부터 7일까지 매일 2,018명
	vMaxEntryCount = 2018

	'// 현재 응모 가능수량
	vNowEntryCount = vMaxEntryCount - vTotalCount
	'vNowEntryCount = 0

	'// 로그인한 유저의 현재 마일리지
	dim myMileage
	set myMileage = new TenPoint
	myMileage.FRectUserID = userid
	if (userid<>"") then
		myMileage.getTotalMileage

		Call SetLoginCurrentMileage(myMileage.FTotalmileage)
	end If
	'response.write FormatNumber(getLoginCurrentMileage(),0)
	'response.write vNowEntryCount
	'response.write DateAdd("d", 1, trim(vEventEndDate))

%>
<style type="text/css">
.mileage-conts {position:relative; background-color:#6a47df;}
.mileage-conts .mileage {position:relative;}
.mileage-conts .left-mileage,
.mileage-conts .sold-out,
.mileage-conts .hurry {position:absolute;}
.mileage-conts .left-mileage {top:62.2%; left:50%; min-width:41.3%; padding:0 .5rem; margin-left:-20%; background-color:#79b023; border-radius:.85rem; color:#fff; font-size:1.28rem; line-height:2.13rem; font-weight:600; text-align:center;}
.mileage-conts .sold-out {width:100%; top:-.85rem; padding:0 2%; z-index:10;}
.mileage-conts .hurry {top:-2.73rem; right:2.1%; width:19.86%; animation:bounce 1s 20;}
.mileage-conts .your-mileage {padding:3.66rem 0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/83302/m/bg_ur_mileage.jpg)0 0 no-repeat; background-size:100%; text-align:center; font-size:1.81rem; line-height:2.73rem; font-weight:bold; color: #fff;}
.mileage-conts .your-mileage span {color:#b6e93d;}
.mileage-conts button{width:100%; background-color:transparent;}
.event-noti {padding:3.84rem 1.9rem 5.12rem 2.13rem ; background-color:#d4d4d4;}
.event-noti h3 {position:relative; color:#482ba8; font-size:1.62rem; font-weight:bold; text-align:center; letter-spacing:.01rem;}
.event-noti h3:after {content:' '; display:block; position:absolute; bottom:-0.6rem; left:50%; width:11.8rem; height:2px; margin-left:-5.9rem; background-color:#482ba8;}
.event-noti ul {margin-top:3.58rem;}
.event-noti ul li {position:relative; padding-left:1.45rem; color:#3b3b3b; font-size:1.28rem; line-height:1.68em; font-weight:600;}
.event-noti ul li:after {content:' '; display:block; position:absolute; top:.8rem; left:0; width:.6rem; height:2px; background-color:#3b3b3b;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
	function jsMileage2018Submit(){
		<% If IsUserLoginOK() Then %>
			<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return false;
			<% else %>
				<% if vBoolUserCheck then %>
					alert("이미 마일리지를 발급받으셨습니다.");
					return;
				<% end if %>
				<% if vNowEntryCount < 1 then %>
					alert("오늘의 마일리지가 모두 소진되었습니다.");
					return;
				<% end if %>

				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript83302.asp",
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
									str = str.replace("undefined","");
									res = str.split("|");
									if (res[0]=="OK")
									{
										alert("마일리지 지급 완료\n\n현금처럼 사용 가능한 마일리지!\n오늘 자정까지 꼭 사용하세요!");
										document.location.reload();
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
						/*
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
						*/
					}
				});
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				alert("로그인 후 마일리지를 받을 수 있습니다!");
				calllogin();
				return false;
			<% else %>
				alert("로그인 후 마일리지를 받을 수 있습니다!");
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
			return false;
		<% End IF %>
	}
</script>

<%' [M] 2018 마일리지 83302 %>
<div class="evt83302 mileage2018">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/tit_2018_mileage.jpg" alt="2018마일리지" /></h2>
	<div class="mileage-conts">
		<div class="mileage">
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/txt_5000_mileage.jpg" alt="2,018명 에게 쇼핑지원금을 드려요! 새해에는 망설임없이 쇼핑하세요! 2018.01.02 ~ 01.07" />
			<p class="left-mileage">현재 남은수량 : <span class="num"><%=FormatNumber(vNowEntryCount, 0)%></span></p>
		</div>
		<%' 마일리지 받기 버튼 %>
		<button onclick="jsMileage2018Submit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/btn_get_mileage_v2.jpg" alt="마일리지 받기" /></button>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/txt_noti.jpg" alt="본 마일리지는 미사용 시 소멸되는 스페셜 마일리지입니다." /></p>

		<%' 이미 참여한 인원일경우 %>
		<% If vBoolUserCheck Then %>
			<div class="sold-out"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/txt_already.png" alt="이미 이벤트에 참여하셨습니다 다음을 기대해주세요 :)  감사합니다" /></div>
		<% Else %>
			<%' 마일리지 2,018개 제공 완료시 %>
			<% If vNowEntryCount < 1 Then %>
				<div class="sold-out">
					<%'화(1/2)~토(1/6) sold out %>
					<% If Left(Trim(currenttime), 10) >= Trim(vEventStartDate) And Left(Trim(currenttime), 10) < Trim(vEventEndDate) Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/txt_sold_out_tmr.png" alt="오늘의 마일리지가 모두 소진되었습니다  내일 아침 10시를 기다려주세요!" />
					<% End If %>
					<%' 월(1/7) 노출 sold out %>
					<% If Left(Trim(currenttime), 10) = Trim(vEventEndDate) Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/txt_sold_out_thx.png" alt="오늘의 마일리지가 모두 소진되었습니다  감사합니다" />
					<% End If %>
				</div>
			<% End If %>

			<%' 마감 임박 %>
			<% If vNowEntryCount >= 1 And vNowEntryCount < 100 Then %>
				<div class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83302/m/txt_hurry.png" alt="마감 임박" /></div>
			<% End If %>
		<% End If %>

		<% If IsUserLoginOK() Then %>
			<div class="your-mileage"><span class="user-id"><%=printUserId(userid,2,"*")%></span> 님의 현재 마일리지는<br/ ><span class="mileage"> <%=FormatNumber(getLoginCurrentMileage(),0)%>M</span> 입니다.</div>
		<% End If %>
	</div>
	<div class="event-noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다. </li>
			<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용가능합니다.</li>
			<li>기간 내에 사용하지 않은 마일리지는 1월 22일 월요일 오전 내에 사전 통보 없이 자동 소멸합니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<%'// [M] 2018 마일리지 83302 %>

<%
	Set myMileage = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->