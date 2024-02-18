<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 백지수표
' History : 2016-02-29 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->


<%
Dim eCode, userid, vTotalCount, sqlstr, vCount, vTotalSum, currenttime, vTCount, evtLimitCnt, vQuery


IF application("Svr_Info") = "Dev" THEN
	eCode   =  66052
Else
	eCode   =  69392
End If

userid = GetEncLoginUserID()
currenttime = now()


'나의 참여수
vCount = getevent_subscriptexistscount(eCode, userid, "", "", "")

'이벤트 전체 참여수
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE convert(varchar(10), regdate, 120) = '" & Left(Trim(currenttime), 10) & "' AND evt_code = '" & eCode & "' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vTCount = rsget(0)
End IF
rsget.close

'//구매 내역 체킹 (응모는 3월 2일부터 4일까지 구매고객만 가능)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-03-02', '2016-03-05', '10x10', '', 'issue' "

'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vTotalCount = rsget("cnt")
	vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
rsget.Close


'// 일자별 응모횟수제한
Select Case Left(Trim(currenttime), 10)
	Case "2016-03-02"
		evtLimitCnt = 100

	Case "2016-03-03"
		evtLimitCnt = 150

	Case "2016-03-04"
		evtLimitCnt = 100

	Case Else
		evtLimitCnt = 0
End Select

%>
<style type="text/css">
html {font-size:11.71px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12.93px;}}
@media (min-width:480px) and (max-width:639px) {html{font-size:15px;}}
@media (min-width:640px) and (max-width:735px) {html{font-size:20px;}}
@media (min-width:736px) {html{font-size:23px;}}

img {vertical-align:top;}
.blankCheck {padding-bottom:3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69392/m/bg_pattern.png) 0 0 repeat-y; background-size:100% auto;}
.blankCheck .step01 {position:relative;}
.blankCheck .step01 .history {position:absolute; left:44%; top:41%; width:43%;}
.blankCheck .step01 .history dl {overflow:hidden; width:100%; color:#fff; font-size:1.2rem; line-height:1; font-weight:bold;}
.blankCheck .step01 .history dl:first-child {padding:1rem 0 0.5rem; border-top:1px solid rgba(255,255,255,.2);}
.blankCheck .step01 .history dl:nth-child(2) {padding-bottom:0.7rem; border-bottom:1px solid rgba(255,255,255,.2);}
.blankCheck .step01 .history dt {float:left;}
.blankCheck .step01 .history dd {float:right; text-align:right;}
.blankCheck .step01 .history dd strong {color:#ffed89;}
.blankCheck .step01 .history p {padding-top:0.7rem; text-align:center; font-size:0.9rem; color:#5d75a7; font-weight:600;}
.blankCheck .step02 {position:relative;}
.blankCheck .step02 .limit {position:absolute; right:0; top:17%; width:18.5%; z-index:40;}
.blankCheck .step02 .writeNum {position:absolute; left:24.21875%; top:51.6%; width:65.625%; height:16%;}
.blankCheck .step02 .writeNum em {display:block; float:left; width:25%; height:100%; padding-right:5.9%;}
.blankCheck .step02 .writeNum input {display:block; width:100%; height:100%; border:0; color:#fa484c; font-size:3rem; text-align:center; font-weight:bold; background:rgba(0,0,0,0);}
.blankCheck .step02 .finish {position:absolute; left:0; top:0; width:100%; z-index:20;}
.blankCheck .applyMg {display:block; width:74.4%; margin:0 auto;}
.blankCheck .evtNoti {position:relative; padding-top:5.4rem;}
.blankCheck .evtNoti .deco {position:absolute; left:0; top:3.7%; width:5.2rem; z-index:20;}
.blankCheck .evtNoti div {width:94%; padding:1.5rem 5.3% 1rem; text-align:center; margin:0 auto; background:rgba(96,130,215,.6);}
.blankCheck .evtNoti h3 {width:10.2rem; margin:0 auto; padding-bottom:1.5rem;}
.blankCheck .evtNoti li {position:relative; text-align:left; padding-left:0.8rem; color:#fff; font-size:1rem; line-height:1.4;}
.blankCheck .evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.3rem; height:1px; background:#fff;}
</style>
<script type="text/javascript">
function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-03-02" and left(currenttime,10)<"2016-03-05" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if vCount > 0 then %>
				alert("이미 응모하셨습니다.");
				return;
			<% elseif vTCount >= evtLimitCnt then %>
				alert("금일 신청이 마감되었습니다.");
				return;

			<% elseif not(vTotalSum >= 100000) then %>
				alert("본 이벤트는 3월 2일 이후\n10만원이상 구매이력이 있는\n고객대상으로 참여가 가능합니다.");
				return;

			<% else %>

				if ($("#num1v").val()=="")
				{
					alert("마일리지 금액을 입력해주세요.");
					return false;
				}

				if ($("#num2v").val()=="")
				{
					alert("마일리지 금액을 입력해주세요.");
					return false;
				}

				if ($("#num3v").val()=="")
				{
					alert("마일리지 금액을 입력해주세요.");
					return false;
				}

				if ($("#num4v").val()=="")
				{
					alert("마일리지 금액을 입력해주세요.");
					return false;
				}
				var totalusermiligeVal;
				totalusermiligeVal = $("#num1v").val()+$("#num2v").val()+$("#num3v").val()+$("#num4v").val()

				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript69392.asp?milval="+totalusermiligeVal,
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
										alert("신청되었습니다!\n\n마일리지는 구매 완료된 고객분에 한하여\n3월15일에 발급될 예정입니다.");
										document.location.reload();
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg );
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
		return false;
	<% End IF %>
}

function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		//alert("숫자만 입력가능합니다.");
		return;
}
function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}
</script>


<%' 백지수표 %>
<div class="mEvt69392">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/tit_blank_check.png" alt="백지수표" /></h2>
	<div class="blankCheck">
		<%' 구매내역 확인 %>
		<div class="step01">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/txt_step_01.png" alt="구매내역을 확인하세요" /></h3>
			<div class="history">
				<dl>
					<dt>구매횟수 :</dt>
					<dd><strong><% If IsUserLoginOK() Then %><%=vTotalCount%><% Else %>*<% End If %></strong> 회</dd>
				</dl>
				<dl>
					<dt>구매금액 :</dt>
					<dd><strong><% If IsUserLoginOK() Then %><%=FormatNumber(vTotalSum, 0)%><% Else %>*<% End If %></strong> 원</dd>
				</dl>
				<% If Not(IsUserLoginOK()) Then %>
					<p>* 로그인후에 확인 할 수 있습니다.</p>
				<% End If %>
			</div>
		</div>
		<%'// 구매내역 확인 %>

		<%' 마일리지 입력 %>
		<div class="step02">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/txt_step_02.png" alt="금액을 입력해주세요" /></h3>
			<p class="limit"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/txt_limit.png" alt="선착순 100명" /></p>
			<div class="writeNum">
				<em><input type="text" name="num1" id="num1v" value="" title="마일리지 입력" maxLength="1" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' style='ime-mode:disabled;' /></em>
				<em><input type="text" name="num2" id="num2v" value="" title="마일리지 입력" maxLength="1" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' style='ime-mode:disabled;' /></em>
				<em><input type="text" name="num3" id="num3v" value="" title="마일리지 입력" maxLength="1" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' style='ime-mode:disabled;' /></em>
				<em><input type="text" name="num4" id="num4v" value="" title="마일리지 입력" maxLength="1" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' style='ime-mode:disabled;' /></em>
			</div>
			<% If vTCount >= evtLimitCnt Then %>
				<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/txt_finish.png" alt="금일 신청이 마감되었습니다" /></p>
			<% End If %>
		</div>
		<% If Not(vTCount >= evtLimitCnt) Then %>
			<button class="applyMg" onclick="jsSubmit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/btn_mileage.png" alt="마일리지 신청하기" /></button>
		<% End If %>
		<%'// 마일리지 입력 %>

		<div class="evtNoti">
			<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/img_deco_mileage.png" alt="" /></p>
			<div>
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69392/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>본 이벤트는 3월 2일부터 4일까지 구매이력이 있는 고객 대상으로 참여가 가능합니다.</li>
					<li>ID 당 1회만 신청이 가능합니다.</li>
					<li>신청된 마일리지는 지급일인 3월 15일 기준으로 구매 완료된 분에 한하여 지급될 예정입니다. (주문 취소 및 환불 제외)</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<%'// 백지수표 %>

<!-- #include virtual="/lib/db/dbclose.asp" -->