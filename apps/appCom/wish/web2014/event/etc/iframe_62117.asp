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
' Description : 도와줘요! 히어로
' History : 2015.05.04 원승현 생성
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
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr, EventTotalChk, nowDate, buyCheck
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel

	IF application("Svr_Info") = "Dev" THEN
		eCode = "61775"
	Else
		eCode = "62117"
	End If

	buyCheck = False



	If IsUserLoginOK Then

		sqlStr = ""
		sqlStr = sqlStr & " select count(m.userid) from db_order.dbo.tbl_order_master as m " &VBCRLF
		sqlStr = sqlStr & " 	inner join db_order.dbo.tbl_order_detail as d " &VBCRLF
		sqlStr = sqlStr & " 	on m.orderserial=d.orderserial " &VBCRLF
		sqlStr = sqlStr & " 	where m.jumundiv<>'9' and m.ipkumdiv > 3 and m.cancelyn = 'N' " &VBCRLF
		sqlStr = sqlStr & " 	and d.cancelyn<>'Y' and d.itemid<>'0' And m.userid='"&vUserID&"' " &VBCRLF
		sqlStr = sqlStr & " 	and m.regdate between '2015-05-06 00:00:00' and '2015-05-12 23:59:59' " &VBCRLF
		rsget.Open sqlStr, dbget, 1
		If rsget(0) > 0 Then
			buyCheck = True
		End If
		rsget.Close

		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & vUserID & "' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부 1인 1번응모가능
		rsget.Close
	Else
		'// 회원가입이 안되어 있음 쿠키 굽는다.(추후 가입완료시 이벤트 페이지 이동을 위해)
		response.cookies("etc").domain="10x10.co.kr"
		response.cookies("etc")("evtcode") = 62117
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt62117 img {vertical-align:top;}
.mEvt62117 .evtApply {position:relative;}
.mEvt62117 .evtApply a {display:block; position:absolute; left:20%; top:10%; width:60%; height:55%; color:transparent;}
.mEvt62117 .evtNoti {padding:20px 14px; background:#fff;}
.mEvt62117 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt62117 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px; letter-spacing:-0.035em;}
.mEvt62117 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.mEvt62117 .evtNoti {padding:30px 21px;}
	.mEvt62117 .evtNoti dt {font-size:21px; margin-bottom:20px; border-bottom:3px solid #222;}
	.mEvt62117 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt62117 .evtNoti li:after {top:5px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript">


function jsSubmitComment(){
	var frm = document.frmcom;

	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% if EventJoinChk > 0 then %>
			alert("이미 응모하셨습니다.");
			return false;
		<% end if %>

		<% if not(buyCheck) then %>
			alert("이벤트 기간 중 구매내역이 있어야 응모하실 수 있습니다.");
			return false;
		<% end if %>

		$.ajax({
			url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript62117.asp",
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
					alert('이벤트 기간 중 구매내역이 있어야 응모하실 수 있습니다.');
					return;
				}
				else if (message=="55")
				{
					alert('이벤트 대상자가 아닙니다.');
					return;
				}
				else if (message=="44")
				{
					alert('이미 응모하셨습니다.');
					return;
				}
				else if (message=="00")
				{
					alert("이벤트 응모가 완료되었습니다.");
					parent.location.reload();
					return;
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
<div class="evtCont">
	<!-- 도와줘요! 히어로 -->
	<div class="mEvt62117">
		<h2>
			<%' for dev msg : 날짜별로 타이틀 이미지 변경됩니다 %>
			<% If Left(Now(), 10) >= "2015-05-04" And Left(Now(), 10) < "2015-05-09" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62117/tit_hero_ver02.gif" alt="도와줘요! 히어로" />
			<% Else %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62117/tit_hero_ver02.gif" alt="도와줘요! 히어로" />
			<% End If %>
		</h2>
		<div class="evtApply">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62117/btn_apply.gif" alt="" /></p>
			<% If Not(IsUserLoginOK) Then %>
				<a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');return false;">응모하기</a>
			<% Else %>
				<a href="" onclick="jsSubmitComment();return false;">응모하기</a>
			<% End If %>
		</div>
		<!--p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62117/txt_mileage.gif" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다. 일반쿠폰과 차원이 다른 헤택을 경험하세요!" /></p-->
		<% If Left(Now(), 10) >= "2015-05-04" And Left(Now(), 10) < "2015-05-06" Then %>
			<% If isApp="1" Then %>
				<p><a href="" onclick="parent.fnAPPpopupEvent('62061');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62117/bnr_avenger_card.gif" alt="어벤져카드 뽑기 이벤트 바로가기" /></a></p>
			<% Else %>
				<p><a href="/event/eventmain.asp?eventid=62061" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62117/bnr_avenger_card.gif" alt="어벤져카드 뽑기 이벤트 바로가기" /></a></p>
			<% End If %>
		<% End If %>
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>이벤트 기간 구매내역이 있어야 응모하기가 가능합니다.</li>
					<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동으로 취소 됩니다.</li>
					<li>이벤트는 조기 종료 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!--// 도와줘요! 히어로 -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->