<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2016-11-29 이종화 생성
'	Description : [★★2016 크리스마스] 산타의 선물
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim mileagecnt, eventPossibleDate, TodayMaxCnt
Dim vUserID, eCode, vQuery, vCheck
vUserID = GetEncLoginUserID()
TodayMaxCnt = 500		'하루 5백명 선착순 지급
vCheck = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "66247"
Else
	eCode = "74320"
End If

'당일 이벤트 참여수
vQuery = "SELECT COUNT(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"' And convert(varchar(10),regdate,120) = '"& Date() &"'"
rsget.Open vQuery, dbget, 1
If Not(rsget.bof Or rsget.Eof) Then
	mileagecnt = rsget(0)
End IF
rsget.Close

'마일리지 발급 여부 확인
If IsUserLoginOK() Then 
	vQuery = "SELECT COUNT(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = true
	End IF
	rsget.close()
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.christmas {background-color:#fff;}

.christmas .gift {position:relative;}
.christmas .gift .soldout {position:absolute; top:42.6%; left:0; width:100%;}
.christmas .gift .btnGet button {width:100%;}

.noti {padding:2rem 0 2.5rem 1.4rem; background:#efefef;}
.noti h3 {position:relative; padding:0.2rem 0 0.4rem 2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74320/m/blt_exclamation_mark.png) no-repeat 0 0; background-size:1.9rem 1.85rem; color:#434545; font-size:1.4rem; font-weight:bold;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; margin-top:0.1rem; padding-left:1rem; color:#989898; font-size:1.1rem; line-height:1.5em; }
.noti ul li:after {display:block; content:' '; position:absolute; top:0.6rem; left:0; width:0.4rem; height:0.1rem; background-color:#989898;}
</style>
<script type="text/javascript">
function jsSubmitC(){
<% If IsUserLoginOK() Then %>
	<% If not(date()>="2016-12-19" and date()<"2016-12-24") then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		<% if mileagecnt >= TodayMaxCnt then %>
			alert("금일 마일리지 받기가 종료 되었습니다.\n내일 다시 받으러 와주세요!");
			return;
		<% else %>
			<% if vCheck then %>
				alert('이미 다운로드 받으셨습니다.');
				return;
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript74320.asp",
					data: "mode=evtgo",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('마일리지가 발급 되었습니다.\n12월 25일 일요일까지\n사용하세요!');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 기간이 아닙니다.');
					return false;		
				}else if (str1[0] == "04"){
					alert('본 이벤트는\nID당 한 번씩만 참여할 수 있어요.');
					return false;
				}else if (str1[0] == "05"){
					alert('낮 12시부터 다운이 가능합니다.');
					return false;
				}else if (str1[0] == "06"){
					alert('오늘 마일리지가 모두 소진되었습니다.');
					return false;
				}else if (str1[0] == "07"){
					alert('이미 마일리지를 받으셨습니다.\n마이텐바이텐에서 확인 해주세요');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
<% End IF %>
}
</script>
<div class="mEvt74320 christmas">
	<div class="bnr">
		<a href="eventmain.asp?eventid=74315"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/bnr_wish.jpg" alt="TURN ON YOUR Christmas" /></a>
	</div>

	<div class="gift">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74320/m/txt_santa_gift.png" alt="크리스마스에 놀러온 산타의 Gift 매일 낮 12시 선착순 500명 산타의 마일리지를 받으세요! 발급 기간은 2016년 12월 19일부터 12월 23일까지 매일 낮 12시 입니다." /></p>

		<!-- for dev mg : 2016/12/19~12/22 소진시 보여주세요 -->
<%
	If Date() < "2016-12-24" Then
		If mileagecnt >= TodayMaxCnt Then
%>
		<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74320/m/txt_soldout<%=chkiif(Date() = "2016-12-23","_last","")%>.png" alt="금일 마일리지가 종료 되었습니다.<%=chkiif(Date() <> "2016-12-23"," 내일 낮 12시에 다시 받으러 와주세요!","")%>"/></p>
<%
	
		End If
	End If
%>
		<div class="btnGet">
			<button type="button" onClick="<% If Date() < "2016-12-24" Then %>jsSubmitC();<% End If %>return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74320/m/btn_get.gif" alt="삼천마일리지 발급받기" /></button>
		</div>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74320/m/txt_extinction.gif" alt="다음 주 월요일 낮 12시가 되면 사용하지 않은 마일리지는 소멸 됩니다" /></p>
	</div>

	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>텐바이텐 회원 대상이며, 1일 500명씩 선착순으로 발급됩니다.</li>
			<li>이벤트 기간 중 ID당 1회만 발급 받을 수 있습니다.</li>
			<li>마일리지는 3만원 이상 구매 시 사용 가능하며, 보너스쿠폰과 중복 사용이 가능합니다. (일부 상품 제외)</li>
			<li>발급 받은 마일리지는 12/25(일)까지 사용가능하며, 미사용시 12/26(월) 소멸됩니다.</li>
			<li>반품/교환/구매취소 시 사용한 마일리지는 추가 소멸됩니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->