<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 새해복 마일리지
' History : 2018-02-14 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-02-14 ~ 2018-02-18
'   - 오픈시간 : 24시간
'   - 일별한정갯수 : 무제한
'   - 지급마일리지 : 5,000 마일리지
'   - 마일리지소멸일자 : 2018년 2월 28일 오전내 소멸
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
	Dim eCode, userid, vQuery, vTotalCount, vBoolUserCheck, vMaxEntryCount, vNowEntryCount, vEventStartDate, vEventEndDate, currenttime

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67509
	Else
		eCode   =  84659
	End If

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-02-18 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-02-14"

	'// 이벤트종료시간
	vEventEndDate = "2018-02-18"

	'마일리지 응모수량
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' "
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
.evt84659 {background:#ffedb5;}
.noti {padding:4.27rem 0 4.69rem; background:#333;}
.noti h3 {padding:0 34.67% 1.83rem;}
.noti ul {padding:0 2.39rem; color:#fff; text-align:left;}
.noti ul li {position:relative; padding-left:1.07rem; font-size:1.19rem; line-height:1.61;}
.noti ul li:before {content:' '; display:inline-block; position:absolute; top:.7rem; left:0; width:.51rem; height:.13rem; background:#fff;}
</style>
<script type="text/javascript">
	function jsMileage2018Submit(){
		<% If IsUserLoginOK() Then %>
			<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return false;
			<% else %>
				<% if vBoolUserCheck then %>
					alert("이미 마일리지를 발급받으셨습니다.\n마일리지는 ID당 1회만 발급 받을 수 있습니다.");
					return;
				<% end if %>

				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript84659.asp",
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
										alert("스페셜 마일리지를 발급받았습니다.\n기간 내에 꼭 사용하세요 :)");
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
<%' 새해복 마일리지! %>
<div class="evt84659">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84659/m/tit_mileage.jpg" alt="새해복 마일리지!" /></h2>
	<div class="mileage">
		<img src="http://webimage.10x10.co.kr/eventIMG/2018/84659/m/txt_mileage.jpg" alt="2월 14일부터 18일까지 5일간 5000마일리지 지급합니다. 본마일리지는 미사용 시 소멸되는 스페셜 마일리지 입니다." />
		<%' 마일리지 다운 받기 버튼 %> 
		<% If vBoolUserCheck Then %>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84659/m/btn_get_mileage_comp.jpg" alt="마일리지 발급완료" /></div>		
		<% Else %>
			<button onclick="jsMileage2018Submit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84659/m/btn_get_mileage.jpg" alt="마일리지받기" /></button>
		<% End If %>
	</div>
	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84659/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>본 이벤트는 로그인 후에 참여할 수 있습니다. </li>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다. </li>
			<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
			<li>기간 내에 사용하지 않은 마일리지는 2월 28일에 수요일 오전 내에 사전 통보 없이 자동 소멸합니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<% If Trim(userid)="thensi7" or Trim(userid)="greenteenz" or Trim(userid)="10x10blue" or Trim(userid)="yangpa" or Trim(userid)="ley330" Then %>
	<div>총 발급 수 : <%=vTotalCount%>개</div>
<% End If %>
<%'// 새해복 마일리지! %>
<%
	Set myMileage = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->