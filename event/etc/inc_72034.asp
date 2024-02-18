<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마일리지 돌려받기
' History : 2016-07-19 유태욱
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
		eCode = "66172"
	Else
		eCode = "72034"
	End If

	vTotalCount = 0
	vTotalSum = 0
	If vUserID <> "" Then
		'//특정기간(07/01-07/31) 구매 내역 체킹
		vQuery = " Select count(*) From ( Select top 7 m.orderserial "
		vQuery = vQuery & " From db_order.dbo.tbl_order_master m "
		vQuery = vQuery & " left join [db_event].[dbo].[tbl_event_subscript] s on m.userid = s.userid And m.orderserial = s.sub_opt1 "
		vQuery = vQuery & " And s.evt_code="&eCode&" "
		vQuery = vQuery & " Where  "
		vQuery = vQuery & " m.regdate >= '2016-07-01' and m.regdate < '2016-08-01' "
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

.mileageBack .desc {padding:5% 0 9%; background-color:#f9f9f9; text-align:center;}
.mileageBack .desc .chance {display:table; position:relative; z-index:10; width:92.8%; height:5.3rem; margin:0 auto; background-color:#d8e8ff; border-radius:0.6rem; color:#6c6c6c; font-size:1.2rem; line-height:1.688em;}
.mileageBack .desc .chance p {display:table-cell; position:relative; z-index:10; width:100%; vertical-align:middle;}
.mileageBack .desc .chance b span {color:#d50c0c; font-weight:bold;}
.mileageBack .desc .before b {color:#d50c0c;}
.mileageBack .desc .after {padding-left:6rem; background:#d8e8ff url(http://webimage.10x10.co.kr/eventIMG/2016/72034/bg_shopping_bag.png) no-repeat 1.3rem 50%; background-size:3.6rem 2.9rem; text-align:left;}
.mileageBack .desc .after b {padding:0.1rem 0.4rem 0; background-color:#b2d2ff; color:#2d2d2d;}

.mileageBack .desc .chance:after {content:' '; position:absolute; left:50%; bottom:-1.4rem; z-index:5; width:0; height:0; border-style:solid; border-width:1rem 0 1rem 1.4rem; border-color:transparent transparent transparent #d8e8ff; transform:rotate(-270deg); -webkit-transform:rotate(-270deg);}

.mileageBack legend, .mileageBack table caption {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.mileageBack .tablewrap {margin:5% 1.2rem 0;}
.mileageBack .tablewrap .thead {overflow:hidden; width:100%; background-color:#646464;}
.mileageBack .tablewrap .thead span {float:left; padding:0.8rem 0; background:#646464 url(http://webimage.10x10.co.kr/eventIMG/2015/65686/bg_bar.png) no-repeat 100% 50%; background-size:0.2rem 1.2ren; color:#fff; font-size:1.2rem;}
.mileageBack .tablewrap .thead span:nth-child(1) {width:38%;}
.mileageBack .tablewrap .thead span:nth-child(2) {width:31%;}
.mileageBack .tablewrap .thead span:nth-child(3) {width:31%; background:none; background-color:#646464;}

.mileageBack .table {overflow-y:auto; max-height:17.5rem; -webkit-overflow-scrolling:touch;}
.mileageBack .table table {width:100%;}
.mileageBack .table table thead {display:none;}
.mileageBack .table table thead th {display:block; visibility:hidden; width:0; height:0;}
.mileageBack .table table td:nth-child(1) {width:38%;}
.mileageBack .table table td:nth-child(2) {width:31%;}
.mileageBack .table table td:nth-child(3) {width:31%;}

.mileageBack table td {position:relative; height:3.5rem; background-color:#efefef; color:#656565; font-size:1.1rem; font-weight:normal; line-height:1.375em; vertical-align:middle;}
.mileageBack table td input {position:absolute; top:50%; left:0.5rem; margin-top:-0.8rem;}
.mileageBack table td input[type=radio] {width:16px; height:16px; border-radius:20px;}
.mileageBack table td input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/65686/bg_input_radio_checked.png) no-repeat 50% 50%; background-size:8px 8px;}
.mileageBack table tr:nth-child(even) td {background-color:#f5f5f5;}
.mileageBack table tr.done td {color:#bfbfbf;}
.mileageBack table tr td.nodata {height:10.5rem;}

.mileageBack .btnsubmit {width:78.6%; margin:6% auto 0;}
.mileageBack .btnsubmit input {width:100%;}

.noti {padding:7% 5.5%; background-color:#fdf3e4;}
.noti h3 {color:#222; font-size:1.3rem;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1.2rem; color:#444; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.3rem; left:0; width:0; height:0; border-top:0.4rem solid transparent; border-bottom:0.4rem solid transparent; border-left:0.6rem solid #000;}
.noti ul li b {color:#d50c0c;}

.bnr ul li {margin-top:4%;}
.bnr ul li:first-child {margin-top:5.5%;}
</style>
<script type="text/javascript">
function pop_Benefit(){
	var pop_Benefit = window.open('/my10x10/userinfo/pop_Benefit.asp','addreg','width=400,height=400,scrollbars=yes,resizable=yes');
	pop_Benefit.focus();
}

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

	<% If Now() > #07/31/2016 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #07/27/2016 00:00:00# Then %>
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
					url:"/event/etc/doeventsubscript/doEventSubscript72034.asp?orderNum="+$('input:radio[name="orderNum"]:checked').val(),
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
										alert("마일리지가 발급되었습니다.");
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
	<!-- [M/A] 72034 친절한 마일리지 -->
	<div class="mEvt72034 mileageBack">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72034/txt_mileage.gif" alt="7월 주문 횟수만큼 마일리지로 돌려드려요! 주문 내역 1개당, 1,000원의 마일리지가 지급되며 최대 7개의 주문내역까지 표기됩니다." /></p>
		</div>

		<div class="desc">
			<% If vUserID = "" Then %>
				<div class="chance before"><p>이벤트는 <b>로그인 후에 참여</b>하실 수 있습니다</p></div>
			<% else %>
				<div class="chance after">
					<p>7월 현재까지 주문내역은 <b>총 <span><%=vTotalCount%></span> 개</b> ,<br />
					지급 가능한 마일리지는 <b>총 <span><%=FormatNumber((vTotalCount*1000), 0)%></span> 원</b></p>
				</div>
			<% end if %>

			<form action="">
				<fieldset>
				<legend>주문내역 선택하고 응모하기</legend>
					<div class="tablewrap">
						<p class="thead">
							<span>주문 번호</span>
							<span>주문 일자</span>
							<span>구매금액</span>
						</p>

						<div class="table">
							<table>
							<caption>나의 주문내역</caption>
							<thead>
							<tr>
								<th scope="col">주문 번호</th>
								<th scope="col">주문 일자</th>
								<th scope="col">구매금액</th>
							</tr>
							</thead>
							<tbody>
							<% If userid="" Then %>
								<tr>
									<td colspan="3" class="nodata">주문내역이 없습니다.</td>
								</tr>
							<% else %>
								<%
									vQuery = " Select top 7 "
									vQuery = vQuery & " m.orderserial, convert(varchar(10), m.regdate, 111) as regdate, m.subtotalprice, s.sub_opt1 "
									vQuery = vQuery & " From db_order.dbo.tbl_order_master m "
									vQuery = vQuery & " left join [db_event].[dbo].[tbl_event_subscript] s on m.userid = s.userid And m.orderserial = s.sub_opt1 "
									vQuery = vQuery & " And s.evt_code="&eCode&" "
									vQuery = vQuery & " Where  "
									vQuery = vQuery & " m.regdate >= '2016-07-01' and m.regdate < '2016-08-01' "
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

					<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/72034/btn_submit.png" onclick="checkform();return false;" alt="더블 마일리지 응모하기" /></div>
				</fieldset>
			</form>
		</div>

		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li><b>7월 구매내역</b>이 있는 고객 대상 이벤트입니다.</li>
				<li>최대 <b>7,000 마일리지</b>까지 발급받을 수 있습니다.</li>
				<li>구매 후 취소 및 환불된 내역은 포함되지 않습니다.</li>
				<li>지급된 마일리지는 <b>3만 원 이상 구매 시</b> 사용할 수 있습니다.</li>
				<li>이벤트는 조기 종료될 수 있습니다.</li>
			</ul>
		</div>

		<div class="bnr">
			<ul>
				<li><a href="eventmain.asp?eventid=72002"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72034/img_bnr_01.png" alt="8월1일, 텐바이텐 회원등급이 변경됩니다 이벤트 보러가기" /></a></li>
				<% If isApp=1 Then %>
					<li><a href="" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72034/img_bnr_02.png" alt="나의 8월 예상 회원 등급은? 텐바이텐 등급혜택 페이지로 이동" /></a></li>
				<% Else %>
					<li><a href="/my10x10/userinfo/pop_Benefit.asp" onclick="pop_Benefit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72034/img_bnr_02.png" alt="나의 8월 예상 회원 등급은? 텐바이텐 등급혜택 페이지로 이동" /></a></li>
				<% End If %>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->