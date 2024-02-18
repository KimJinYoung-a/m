<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [시크릿] 마일리지는돌아오는거야
' History : 2015-10-28 유태욱
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
'Dim prveCode
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, eLinkCode, prvCount, prvTotalcount, tempNum, vmigcnt
	vUserID = GetencLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	Dim vQuery, vCount, commentcount

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64940"
	Else
		eCode = "67032"
	End If

	vTotalCount = 0
	vTotalSum = 0
	If vUserID <> "" Then
		'//특정기간(10/30-11/2) 구매 내역 체킹
		vQuery = " Select count(*) From ( Select top 10 m.orderserial "
		vQuery = vQuery & " From db_order.dbo.tbl_order_master m "
		vQuery = vQuery & " left join [db_event].[dbo].[tbl_event_subscript] s on m.userid = s.userid And m.orderserial = s.sub_opt1 "
		vQuery = vQuery & " And s.evt_code="&eCode&" "
		vQuery = vQuery & " Where  "
		vQuery = vQuery & " m.regdate >= '2015-10-30' and m.regdate < '2015-11-03' "
		vQuery = vQuery & " and m.jumundiv not in (6,9) "
		vQuery = vQuery & " and m.ipkumdiv>3 "
'		vQuery = vQuery & " and s.evt_code is null "
		vQuery = vQuery & " and m.userid='"&userid&"' "
		vQuery = vQuery & " and m.cancelyn='N' And m.sitename='10x10'  "
'		vQuery = vQuery & " And s.sub_opt1 is null  "
		vQuery = vQuery & " And m.subtotalprice <> 0 "
		vQuery = vQuery & " order by m.orderserial asc )AA "
		rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
			vTotalCount = rsget(0)
		rsget.Close

		vQuery = " Select count(userid) From db_event.dbo.tbl_event_subscript Where userid='"&userid&"' And evt_code='"&eCode&"' And sub_opt1 <> '' "
		rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
			vmigcnt = rsget(0)
		rsget.close
		vTotalCount = vTotalCount - vmigcnt

	End If
%>
<style type="text/css">
img {vertical-align:top;}
.mileageBack {background-color:#fff;}
.mileageBack .topic h2 {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.mileageBack .desc {text-align:center;}
.mileageBack .desc .chance {display:table; position:relative; z-index:10; width:92.8%; height:62px; margin:5% auto 0; border:2px solid #fbe8ca; background-color:#fff1da; color:#6c6c6c; font-size:12px; line-height:1.438em;}
.mileageBack .desc .chance p {display:table-cell; position:relative; z-index:10; background-color:#fff1da; vertical-align:middle;}
.mileageBack .desc .chance p strong {color:#d60000;}
.mileageBack .desc .chance em {color:#1b1b1b; font-weight:bold;}
.mileageBack .desc .before strong {font-weight:normal;}

.mileageBack .desc .chance:after {content:' '; position:absolute; left:50%; bottom:-8px; z-index:5; width:10px; height:10px; margin-left:-5px; border:2px solid #fbe8ca; background-color:#fff1da; transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}

.mileageBack legend, .mileageBack table caption {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.mileageBack .tablewrap {margin:5% 12px 0;}
.mileageBack .tablewrap .thead {overflow:hidden; width:100%; background-color:#646464;}
.mileageBack .tablewrap .thead span {float:left; padding:8px 0; background:#646464 url(http://webimage.10x10.co.kr/eventIMG/2015/65686/bg_bar.png) no-repeat 100% 50%; background-size:2px 12px; color:#fff; font-size:12px;}
.mileageBack .tablewrap .thead span:nth-child(1) {width:38%;}
.mileageBack .tablewrap .thead span:nth-child(2) {width:31%;}
.mileageBack .tablewrap .thead span:nth-child(3) {width:31%; background:none; background-color:#646464;}

.mileageBack .table {overflow-y:auto; height:93px; -webkit-overflow-scrolling:touch;}
.mileageBack .table table {width:100%;}
.mileageBack .table table thead {display:none;}
.mileageBack .table table thead th {display:block; visibility:hidden; width:0; height:0;}
.mileageBack .table table td:nth-child(1) {width:38%;}
.mileageBack .table table td:nth-child(2) {width:31%;}
.mileageBack .table table td:nth-child(3) {width:31%;}

.mileageBack table td {padding:8px 0; line-height:1.375em;}
.mileageBack table td {position:relative; background-color:#f1f1f1; color:#656565; font-size:11px; font-weight:normal;}
.mileageBack table td input {position:absolute; top:50%; left:5px; margin-top:-8px;}
.mileageBack table td input[type=radio] {width:16px; height:16px; border-radius:20px;}
.mileageBack table td input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/65686/bg_input_radio_checked.png) no-repeat 50% 50%; background-size:8px 8px;}
.mileageBack table tr:nth-child(even) td {background-color:#f8f8f8;}
.mileageBack table .nodata {padding:30px 0;}
.mileageBack table tr.done td {color:#c8c8c8;}
.mileageBack .note {margin:3% 0 9%; color:#999; font-size:11px;}

.mileageBack .btnsubmit {width:78.6%; margin:6% auto 0;}
.mileageBack .btnsubmit input {width:100%;}

.noti {padding:5% 5.5%; background-color:#fff3bf;}
.noti h3 {color:#222; font-size:13px;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:2px; left:0; width:0; height:0; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:6px solid #000;}

@media all and (min-width:480px){
	.mileageBack .desc .chance {height:93px; font-size:17px; line-height:1.313em;}
	.mileageBack .tablewrap .thead span {padding:12px 0; font-size:17px;}

	.mileageBack .table {height:138px;}
	.mileageBack table td {width:33.333%; padding:12px 0;}
	.mileageBack table td {font-size:16px;}
	.mileageBack table td input {left:10px;}
	.mileageBack .note {font-size:16px}

	.noti ul {margin-top:16px;}
	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script>
function checkform()
{
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}
	<% End If %>

	<% If Now() > #11/02/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #10/30/2015 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If vUserID <> "" Then %>
			if (typeof $('input:radio[name="orderNum"]:checked').val()=="undefined")
			{
				alert("주문내역을 선택 한 후 마일리지를 신청하세요!");
				return false;
			}
			else
			{
				$.ajax({
					type:"GET",
					url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript67032.asp?orderNum="+$('input:radio[name="orderNum"]:checked').val(),
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
										$("#tr"+res[1]).addClass("done");
										$("#orderNum"+res[1]).attr("disabled","disabled");
										alert("신청되었습니다. 마일리지는 11월11일 지급됩니다.");
										document.location.reload();
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg );
										document.location.reload();
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
		<% end if %>
	<% End If %>
}
</script>
	<!-- [APP] 67032 마일리지는 돌아오는거야 -->
	<div class="mEvt67032">
		<article class="mileageBack">
			<div class="topic">
				<h2>마일리지는 돌아오는거야</h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67032/txt_mileage_back.gif" alt="주문 횟수만큼 천마일리지가 지급됩니다! 이벤트 기간은 10월 30일부터 11월 2일까지 진행됩니다. 이벤트기간 고객님의 주문건수에 따른 주문내역이 보여지며 주문내역 1개 당 1,000마일리지 지급됩니다." /></p>
			</div>

			<div class="desc">
				<% If vUserID = "" Then %>
					<div class="chance before"><p>이벤트는 <strong>로그인 후에 참여</strong>하실 수 있습니다</p></div>
				<% Else %>
					<div class="chance after">
						<p><em><%=printUserId(userid, 2, "*")%></em> 주문내역은 <strong><%=vTotalCount%></strong>개<br />
						지급 가능한 마일리지는 총 <strong><%=FormatNumber((vTotalCount*1000), 0)%></strong>마일리지 입니다.</p>
					</div>
				<% End If %>
					<fieldset>
					<legend>주문내역 선택하고 신청하기</legend>
						<div class="tablewrap">
							<p class="thead">
								<span>주문 번호</span>
								<span>주문 일자</span>
								<span>총 구매금액</span>
							</p>

							<div class="table">
								<table>
								<caption>나의 주문내역</caption>
								<thead>
								<tr>
									<th scope="col">주문 번호</th>
									<th scope="col">주문 일자</th>
									<th scope="col">총 구매금액</th>
								</tr>
								</thead>
								<tbody>
								<% If userid="" Then %>
									<tr>
										<td colspan="3" class="nodata">주문내역이 없습니다.</td>
									</tr>
								<% Else %>
									<%
										vQuery = " Select top 10 "
										vQuery = vQuery & " m.orderserial, convert(varchar(10), m.regdate, 111) as regdate, m.subtotalprice, s.sub_opt1 "
										vQuery = vQuery & " From db_order.dbo.tbl_order_master m "
										vQuery = vQuery & " left join [db_event].[dbo].[tbl_event_subscript] s on m.userid = s.userid And m.orderserial = s.sub_opt1 "
										vQuery = vQuery & " And s.evt_code="&eCode&" "
										vQuery = vQuery & " Where  "
										vQuery = vQuery & " m.regdate >= '2015-10-30' and m.regdate < '2015-11-03' "
										vQuery = vQuery & " and m.jumundiv not in (6,9) "
										vQuery = vQuery & " and m.ipkumdiv>3 "
				'						vQuery = vQuery & " and s.evt_code is null "
										vQuery = vQuery & " and m.userid='"&userid&"' "
										vQuery = vQuery & " and m.cancelyn='N' And m.sitename='10x10'  "
				'						vQuery = vQuery & " And s.sub_opt1 is null "
										vQuery = vQuery & " And m.subtotalprice <> 0 "
										vQuery = vQuery & "  order by m.orderserial asc  "
										rsget.Open vQuery,dbget, adOpenForwardOnly, adLockReadOnly
										IF Not rsget.Eof Then
											Do Until rsget.eof
									%>
										<tr <% If rsget("sub_opt1") <> "" Then %>class="done" <% End If %> id="tr<%=rsget("orderserial")%>">
											<td><input type="radio" id="orderNum<%=rsget("orderserial")%>" name="orderNum" <% If rsget("sub_opt1") <> "" Then %>disabled="disabled"<% End If %> value="<%=rsget("orderserial")%>"> <label for="orderNum<%=rsget("orderserial")%>"><%=rsget("orderserial")%></label></td>
											<td><%=rsget("regdate")%></td>
											<td><%=FormatNumber(rsget("subtotalprice"), 0)%></td>
										</tr>
									<%
											rsget.movenext
											Loop
										Else
									%>
									<%' for dev msg : 주문내역이 없을 경우 및 로그인전 %>
										<tr>
											<td colspan="3" class="nodata">주문내역이 없습니다.</td>
										</tr>
									<%
										End IF
										rsget.close	
									%>
								<% End If %>
								</tbody>
								</table>
							</div>
						</div>

						<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/65686/btn_submit.png" alt="더블 마일리지 신청하기" onclick="checkform();return false;" /></div>
						<p class="note">※ 주문 내역을 선택하고 마일리지 받기 버튼을 눌러주세요.</p>
					</fieldset>
			</div>

			<div class="noti">
				<h3><strong>이벤트 유의사항</strong></h3>
				<ul>
					<li>신청하신 마일리지는 11월11일 지급됩니다.</li>
					<li>이벤트 기간 동안 구매내역이 있는 고객만 신청 가능합니다.</li>
					<li>최대 10개, 총 1만 마일리지까지 신청이 가능합니다.</li>
					<li>구매취소 및 환불 내역은 포함되지 않습니다.</li>
					<li>지급되는 마일리지는 3만원 이상 구매 시 사용 할 수 있습니다.</li>
					<li>마일리지샵 상품 구매내역에 대해서는 주문건수에 포함되지 않아 마일리지를 받을 수 없습니다.</li>
					<li>이벤트는 조기 종료 될 수 있습니다.</li>
				</ul>
			</div>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->