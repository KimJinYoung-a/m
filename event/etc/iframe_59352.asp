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
' Description : 텐바이텐 처음이라면서요(!)
' History : 2015.02.06 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, vUserID, EventJoinChk, sqlStr, EventTotalChk
	vUserID = GetLoginUserID()
	
	IF application("Svr_Info") = "Dev" Then
		eCode = "21467"
	Else
		eCode = "59352"
	End If

	EventTotalChk = 0

	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' "
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수
	rsget.Close

	EventTotalChk = 1000-EventTotalChk

	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부
		rsget.Close
	End If
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mileageView {background:#fff1c8 url(http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_bg.png) center top repeat-y; background-size:100%; padding-bottom:8%}
.mileageBox {background-color:#f4dbad; border-radius:5px; width:75%; margin:0 auto; padding:18px 0;}
.remain {padding:5% 12.5% 0 12.5%; text-align:center; }
.remain em {display:inline-block; width:50%; vertical-align:middle;}
.remain span {width:41%; margin-left:5px; display:inline-block; vertical-align:middle; padding:5px 7px; box-shadow:0 0 2px 2px rgba(239,211,166,0.5); background-color:#fff; font-size:20px; color:#434343; font-family:verdana, tahoma, sans-serif; text-align:right; font-weight:bold; letter-spacing:-0.05em;}
.noti {padding-top:6%; padding-bottom:6%; background-color:#f4f7f7;}
.noti ul {padding:3% 4.2% 0 4.2%;}
.noti ul li {margin-top:6px; color:#444; font-size:11px; line-height:1.25em;}

@media all and (min-width:480px){
	.mileageBox {padding:27px 0; border-radius:7px;}
	.remain span {margin-left:7px; padding:7px 10px; box-shadow:0 0 3px 3px rgba(239,211,166,0.5); font-size:30px;}
	.noti ul li {font-size:16px;}
}
</style>
<script type="text/javascript">
function jsSubmitComment(){
	var frm = document.frmcom;
	
	<% If vUserID = "" Then %>
		parent.jsevtlogin();
	<% End If %>

	<% If vUserID <> "" Then %>
		<% if EventJoinChk > 0 then %>
			alert("이미 마일리지를 발급 받으셨습니다.");
			return false;
		<% end if %>

		<% if EventTotalChk > 1000 then %>
			alert("마일리지가 모두 소진되었습니다.");
			return false;
		<% end if %>


		$.ajax({
			url: "/event/etc/doEventSubscript59352.asp",
			cache: false,
			success: function(message) {

				if (message=="99")
				{
					alert('잘못된 접속 입니다.');
					return;
				}
				else if (message=="88")
				{
					alert('로그인을 해주세요');
					return;
				}
				else if (message=="77")
				{
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}
				else if (message=="66")
				{
					alert('마일리지가 모두 소진되었습니다.');
					return;
				}
				else if (message=="55")
				{
					alert('이벤트 대상자가 아닙니다.');
					return;
				}
				else if (message=="44")
				{
					alert('이미 마일리지를 발급 받으셨습니다.');
					return;
				}
				else if (message=="00")
				{
					alert('마일리지가 발급되었습니다.\n2월15일 이후 사용하지 않은 마일리지는\n소멸될 예정입니다.');
					parent.location.reload();
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	<% End If %>
}
</script>
</head>
<body>

<!--신규고객 마일리지 지급 -->
<div class="mEvt59352">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_tit.png" alt ="텐바이텐 처음이라면서요?" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_mileage.png" alt ="MILEAGE - 3,000 (3만원 이상 구매시 사용가능)" /></p>
	<p><a href="" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_btn.png" alt ="마일리지 즉시 받기" /></a></p>

	<div class="mileageView">
		<div class="mileageBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_txt1.png" alt ="선착순 : 1,000명" /></p>
			<p class="remain">
				<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_txt2.png" alt ="마일리지 잔여 수량" /></em>
				<span><%=FormatNumber(EventTotalChk, 0)%></span>
			</p>
		</div>
	</div>

	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/59352/59352_txt3.png" alt ="이벤트 유의사항" /></h3>
		<ul>
			<li>- 텐바이텐 신규가입자 대상입니다.</li>
			<li>- ID당 1회 이며 문자로 이벤트 안내를 받은 고객에게만 해당됩니다.</li>
			<li>- 선착순 지급이므로, 마일리지 발급이 조기 종료 될 수 있습니다.</li>
			<li>- 3만원 이상 구매시 사용할 수 있으며, 쿠폰과 중복 사용 가능합니다.</li>
			<li>- 발급받은 마일리지는 2월15일(일) 까지 사용 가능합니다.</li>
			<li>- 이후 사용하지 않은 마일리지는 일괄 소멸 될 예정입니다.<br />&nbsp;&nbsp;&nbsp;기간 내 꼭 사용해주세요!</li>
		</ul>
	</div>

</div>
<!--//신규고객 마일리지 지급 -->

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->