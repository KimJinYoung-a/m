<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : [마케팅 이벤트] 마타하리 응모하리 vip 이벤트
' History : 2017-06-21 원승현 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
	Dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66348
	Else
		eCode   =  78602
	End If

	dim userid, i, UserAppearChk
		userid = GetEncLoginUserID()

	'// 응모여부 확인
	Dim vQuery
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		UserAppearChk = rsget(0)
	End IF
	rsget.close
%>
<style type="text/css">
.evtNoti {background-color:#757575; padding:8.9% 7.9% 8.5% 9.8%; color:#f8f8f8; font-size:1rem; line-height:1.6rem; text-indent:-.8rem;}
.evtNoti h3 {width:28.75%; margin:0 auto;}
.evtNoti ul {margin-top:1.5rem;}
</style>

<script>
function goMatahariIns()
{
	<% If IsUserLoginOK() Then %>
		<% If Not(GetLoginUserLevel = 3 Or GetLoginUserLevel = 4 Or GetLoginUserLevel = 6) Then %>
			alert("VIP SILVER, VIP GOLD, VVIP 회원만 신청 가능합니다.");
			return false;
		<% else %>
			<% If not( left(now(),10)>="2017-06-23" and left(now(),10)<"2017-07-01" ) Then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return false;
			<% else %>
				<% if UserAppearChk > 0 then %>
					alert('이미 응모하셨습니다.\n발표일을 기다려주세요 : )');
					return false;
				<% else %>
					$.ajax({
						type:"GET",
						url:"/event/etc/doEventSubscript78602.asp?mode=ins",
						dataType: "text",
						async:false,
						cache:true,
						success : function(Data, textStatus, jqXHR){
							if (jqXHR.readyState == 4) {
								if (jqXHR.status == 200) {
									if(Data!="") {
										res = Data.split("|");
										if (res[0]=="OK")
										{
											alert("응모가 완료되었습니다.");
											parent.location.reload();
											return false;
										}
										else
										{
											errorMsg = res[1].replace(">?n", "\n");
											alert(errorMsg);
											parent.location.reload();
											return false;
										}
									} else {
										alert("잘못된 접근 입니다.");
										parent.location.reload();
										return false;
									}
								}
							}
						},
						error:function(jqXHR, textStatus, errorThrown){
							alert("잘못된 접근 입니다.");
							<% if false then %>
								//var str;
								//for(var i in jqXHR)
								//{
								//	 if(jqXHR.hasOwnProperty(i))
								//	{
								//		str += jqXHR[i];
								//	}
								//}
								//alert(str);
							<% end if %>
							parent.location.reload();
							return false;
						}
					});
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>

<div class="mEvt78602">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78602/m/tit_vip.jpg" alt="마타하리 응모하리" /></h2>
	<div class="evntTxt">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/78602/m/txt_event.jpg" alt="뮤지컬 <마타하리>예매권에 응모해주세요 추첨을 통해 총 20분께 R석 예매권 1장을 드립니다 이벤트 기간은 2017년 6월 23일 부터 6월 30일 까지입니다. 당첨자 발표일은 2017년 7월. 3일 월요일입니다." />
		<%' 응모하기 버튼 %>
		<a href="" onclick="goMatahariIns();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78602/m/btn_submit.jpg" alt="마타하리 응모하기" /></a>
	</div>
	<div class="evtNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/78602/m/tit_evnt_notice.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>- 텐바이텐 VIP SILVER, VIP GOLD, VVIP 등급 고객님을 위한 이벤트입니다.</li>
			<li>- ID당 한번씩만 응모하실 수 있습니다.</li>
			<li>- 예매권은 택배 발송될 예정입니다.</li>
			<li>- 예매권의 사용기간은 2017년 8월 6일까지입니다.</li>
			<li>- 당첨이 된 고객님께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
			<li>- 제세공과금은 텐바이텐 부담입니다.</li>
		</ul>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->