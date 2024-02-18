<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  [주년뒷풀이]마일리지는 돌아오는거야
' History : 2014.10.28 허진원 생성 - 모바일andApp공용
'###########################################################
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vEvtStartDt
Dim vQuery, i, vUserID, vMyCnt, vMyRetMile, vMyOrderCnt, vRemainCnt, vArr1, vArr2, vArrOrdSn
vUserID = GetLoginUserID
vMyCnt = 0
vMyOrderCnt = 0
vRemainCnt = 0
vMyRetMile = 0

IF application("Svr_Info") = "Dev" THEN
	eCode = "21347"
	vEvtStartDt = "2014-07-01 00:00:00"
Else
	eCode = "55918"
	vEvtStartDt = "2014-10-29 00:00:00"
End If

If IsUserLoginOK Then
	'// 응모현황 및 응모 마일리지 접수 - sub_opt2 : 참여 마일리지, sub_opt1 : 주문 번호
	vQuery = "SELECT sub_opt1, sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' AND evt_code = '" & eCode & "'"
	rsget.Open vQuery,dbget,1
	vMyCnt = rsget.RecordCount
	If Not rsget.Eof Then
		vArr1 = rsget.getRows()
	End If
	rsget.close

	if vMyCnt>0 then
		for i=0 to ubound(vArr1,2)
			vArrOrdSn = vArrOrdSn & chkIIF(vArrOrdSn="","",",") & vArr1(0,i)
			vMyRetMile = vMyRetMile + (vArr1(1,i)*2)
		next
		if vMyRetMile>10000 then vMyRetMile=10000			'1만 마일리지 제한
	end if

	'// 이벤트 기간 내 주문 접수
	vQuery = "SELECT Top 20 orderserial, regdate, subtotalpriceCouponNotApplied-tencardspend as ordPrice, miletotalprice "
	vQuery = vQuery & " FROM [db_order].[dbo].[tbl_order_master] as m WHERE m.userid = '" & vUserID & "' "
	vQuery = vQuery & " 	AND m.regdate between '" & vEvtStartDt & "' and '2014-11-03' AND m.ipkumdiv>3 AND m.jumundiv<>9 "
	vQuery = vQuery & " ORDER BY m.orderserial DESC"
	rsget.Open vQuery,dbget,1
	vMyOrderCnt = rsget.RecordCount
	If Not rsget.Eof Then
		vArr2 = rsget.getRows()
	End If
	rsget.close

	IF vMyOrderCnt>0 then
		'참여가능 주문수 재계산
		vMyOrderCnt = 0
		for i=0 to ubound(vArr2,2)
			if vArr2(3,i)>0 then vMyOrderCnt=vMyOrderCnt+1
		next
	end if

	IF vMyOrderCnt < 5 Then
		vRemainCnt = vMyOrderCnt - vMyCnt
	Else
		vRemainCnt = 5 - vMyCnt
	End IF
end if
%>
<script type="text/javascript">
function fnSubmit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
		return false;
	}else{
		<% if vMyCnt>=5 then %>
			alert("다섯번의 부메랑을 모두 날리셨습니다.");
			return false;
		<% else %>
		if(!$("input[name='ordsn']:checked").length) {
			alert("주문내역을 선택한 후 응모해주세요.");
			return false;
		}
		<% end if %>
	}
}
</script>
<style type="text/css">
.mEvt55919 {background-color:#fff;}
.mEvt55919 img {width:100%; vertical-align:top;}
.mileage-back .heading {position:relative;}
.mileage-back .heading .cloud {position:absolute; width:74.2%; top:26.5%; left:13%;}
.mileage-back .hands {position:absolute; top:76%; left:0; z-index:15; width:21.7%;}
.mileage-back .desc .chance-before, .mileage-back .desc .chance {position:relative; z-index:10; margin:12px; border:2px solid #fbe8ca; background-color:#fff1da; color:#6c6c6c; font-size:12px; line-height:1.438em; text-align:center;}
.mileage-back .desc .chance-before strong, .mileage-back .desc .chance strong {display:inline-block; position:relative; z-index:10; padding:15px 0; background-color:#fff1da;}
.mileage-back .desc .chance-before span {color:#d60000;}
.mileage-back .desc .chance-before:after, .mileage-back .desc .chance:after {content:''; position:absolute; left:50%; bottom:-8px; z-index:5; width:10px; height:10px; margin-left:-5px; border:2px solid #fbe8ca; background-color:#fff1da; transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}
.mileage-back .desc .chance strong {padding:7px 0;}
.mileage-back .desc .chance span:first-child {color:#1b1b1b;}
.mileage-back .desc .chance span:last-child {color:#d50c0c;}
.mileage-back .myorder {overflow:hidden; padding:3% 1% 5%;}
.mileage-back .myorder li {float:left; position:relative; width:18%; margin:0 1%;}
.mileage-back .myorder li .finish {display:none; position:absolute; top:0; left:0; width:100%;}
.mileage-back legend, .mileage-back table caption {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.mileage-back .table-wrap {margin:5% 12px 0;}
.mileage-back .table-wrap table {width:100%;}
.mileage-back table th, .mileage-back table td {padding:8px 0; line-height:1.375em;}
.mileage-back table th {background:#646464 url(http://webimage.10x10.co.kr/eventIMG/2014/55919/bg_line.gif) no-repeat 100% 50%; background-size:2px 12px; color:#fff; font-size:12px;}
.mileage-back table th:nth-child(1) {width:38%;}
.mileage-back table th:nth-child(2) {width:30%;}
.mileage-back table th:nth-child(3) {width:32%;}
.mileage-back table th:last-child {background:none; background-color:#646464;}
.mileage-back table td {position:relative; background-color:#f1f1f1; color:#656565; font-size:11px; font-weight:normal; text-align:center;}
.mileage-back table td input {position:absolute; top:50%; left:5px; margin-top:-8px;}
.mileage-back table td input[type=radio] {width:16px; height:16px; border-radius:20px;}
.mileage-back table td input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/55919/bg_input_radio_checked.png) no-repeat 50% 50%; background-size:8px 8px;}
.mileage-back table tr:nth-child(even) td {background-color:#f8f8f8;}
.mileage-back table tr.end td {color:#c8c8c8;}
.mileage-back table .no-data {padding:30px 0;}
.mileage-back .btn-submit {margin-top:5%; text-align:center;}
.mileage-back .btn-submit input {width:78%;}
.mileage-return-before, .mileage-return {margin:5% 12px 0; padding:2px; border:2px solid #897d6d; text-align:center;}
.mileage-return-before p, .mileage-return p {padding:20px 0; border:1px solid #897d6d; color:#6c6c6c; font-size:12px; line-height:1.438em;}
.mileage-return-before span {color:#d50c0c;}
.mileage-return p {padding:11px 0;}
.mileage-return span:first-child {color:#1b1b1b;}
.mileage-return span:last-child {color:#d50c0c;}

.mileage-back .btn-my10x10 {margin-top:5%;}
.mileage-back .noti {padding:5% 0; background-color:#ffb8a1;}
.mileage-back .noti ul {margin-top:10px; padding:0 6%;}
.mileage-back .noti ul li {margin-top:5px; padding-left:9px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55919/blt_arrow.gif) no-repeat 0 4px; background-size:4px 5px; color:#583d34; font-size:11px; line-height:1.375em;}

@media all and (min-width:480px){
	.mileage-back .desc .chance-before, .mileage-back .desc .chance {font-size:16px; line-height:1.313em;}
	.mileage-back .desc .chance-before strong {padding:25px 0;}
	.mileage-back .desc .chance strong {padding:15px 0;}
	.mileage-back table th {width:33.333%;}
	.mileage-back table th, .mileage-back table td {padding:12px 0;}
	.mileage-back table th {font-size:16px;}
	.mileage-back table td {font-size:14px;}
	.mileage-back table td input {left:10px;}
	.mileage-return-before p, .mileage-return p {padding:25px 0; font-size:16px;}
	.mileage-return p {padding:15px 0;}
	.mileage-back .noti ul {margin-top:20px;}
	.mileage-back .noti ul li {margin-top:10px; padding-left:15px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55919/blt_arrow.gif) no-repeat 0 6px; background-size:6px 7px; font-size:16px;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:2; animation-iteration-count:2;}
/* Shake animation */
@-webkit-keyframes shake {
	0%, 100% {-webkit-transform: translateX(0);}
	50% {-webkit-transform: translateX(10px);}
}
@keyframes shake {
	0%, 100% {transform: translateX(0);}
	50% {transform: translateX(10px);}
}
.shake {-webkit-animation-name: shake; animation-name: shake;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-name:fadeIn; animation-name:fadeIn; -webkit-animation-iteration-count:3; animation-iteration-count:3;}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content evtView" id="contentArea">
				<!-- 이벤트 배너 등록 영역 -->
				<div class="evtCont">
					<div class="mEvt55919">
						<div class="mileage-back">
							<div class="heading">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/txt_mileage_back.gif" alt="지나간 생일파티가 아쉬워서 만든 이벤트 마일리지는 돌아오는거야!" /></p>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/txt_date.gif" alt="쌓여있는 마일리지를 사용해 쇼핑을 하는 모든 분에게 사용한 마일리지를 두 배로 다시 돌려드립니다. 이벤트 기간은 2014년 10월 29일부터 31일까지 오직 3일동안만 진행됩니다. 1개의 아이디당 최대 5개의 부메랑이 지급되며, 최대 환급 한도는 만마일리지까지 가능합니다." /></p>
								<span class="cloud animated shake"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/img_cloud.png" alt="" /></span>
								<span class="hands animated fadeIn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/img_hands.png" alt="" /></span>
							</div>

							<div class="desc">
								<% if Not(IsUserLoginOK) then %>
								<p class="chance-before"><strong>이벤트는 <span>로그인 후에 참여</span>하실 수 있습니다</strong></p>
								<% else %>
								<p class="chance"><strong><span><%=vUserID%></span>님이<br /> 신청할 수 있는 기회는 총 <span><%=vRemainCnt%></span>번 입니다.</strong></p>
								<% end if %>

								<ul class="myorder">
									<% for i=1 to 5 %>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/img_order_0<%=i & chkIIF(vMyOrderCnt>=i,"_on","_off") %>.png" alt="부메랑#<%=i%>" />
										<strong class="finish" style="display:<%=chkIIF(vMyCnt>=i,"block","none")%>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/txt_finish.png" alt="응모완료" /></strong>
									</li>
									<% next %>
								</ul>

								<form name="frm" method="POST" action="doEventSubscript55919.asp" onsubmit="return fnSubmit();" target="prociframe">
									<fieldset>
									<legend>주문내역 선택하고 응모하기</legend>
										<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/txt_guide.gif" alt="※ 부메랑을 날릴 때 아래 주문 내역을 선택하고 응모하기 버튼을 눌러주세요." /></p>
										<div class="table-wrap">
											<table>
											<caption>나의 주문내역 목록</caption>
											<thead>
											<tr>
												<th scope="col">주문 일자</th>
												<th scope="col">주문 번호</th>
												<th scope="col">사용 마일리지</th>
											</tr>
											</thead>
											<tbody>
										<%
											if vMyOrderCnt>0 then
												for i=0 to ubound(vArr2,2)
										%>
											<tr class="<%=chkIIF((i mod 2)=1,"even","") & " " & chkIIF(chkArrValue(vArrOrdSn,vArr2(0,i)) or vArr2(3,i)=0,"end","")%>">
												<td>
													<input type="radio" name="ordsn" id="orderNum<%=num2str(i,2,"0","R")%>" value="<%=vArr2(0,i)%>" <%=chkIIF(chkArrValue(vArrOrdSn,vArr2(0,i)) or vArr2(3,i)=0,"disabled","")%>>
													<label for="orderNum<%=num2str(i,2,"0","R")%>"><%=FormatDate(vArr2(1,i),"0000.00.00")%></label>
												</td>
												<td><%=vArr2(0,i)%></td>
												<td><strong><%=formatNumber(vArr2(3,i),0)%></strong>p</td>
											</tr>
										<%
												Next
											else
										%>
											<tr>
												<td colspan="3" class="no-data">주문내역이 없습니다.</td>
											</tr>
										<%
											end if
										%>
											</tbody>
											</table>
										</div>

										<div class="btn-submit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/55919/btn_submit.gif" alt="더블 마일리지 응모하기" /></div>
									</fieldset>
								</form>

								<% if Not(IsUserLoginOK) then %>
								<div class="mileage-return-before">
									<p><strong>돌려받을 마일리지를 <span>로그인 후에 확인</span>해주세요!</strong></p>
								</div>
								<% else %>
								<div class="mileage-return">
									<p><strong><span><%=vUserID%></span>님이 돌려받을 마일리지는<br /> <span><%=formatNumber(vMyRetMile,0)%> point</span> 입니다.</strong></p>
								</div>
								<% end if %>

								<% if isApp then %>
								<p class="btn-my10x10"><a href="#" onclick="parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/mymain.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/btn_my10x10.gif" alt="응모의 기회는 쇼핑, 쇼핑은 쌓아둔 마일리지와 쿠폰으로! 사용할 수 있는 마일리지와 쿠폰 확인하러 가기" /></a></p>
								<% else %>
								<p class="btn-my10x10"><a href="/my10x10/mymain.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/btn_my10x10.gif" alt="응모의 기회는 쇼핑, 쇼핑은 쌓아둔 마일리지와 쿠폰으로! 사용할 수 있는 마일리지와 쿠폰 확인하러 가기" /></a></p>
								<% end if %>
							</div>

							<div class="noti">
								<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/55919/tit_noti.gif" alt="부메랑은 돌아오지만, 이것만 기억하세요!" /></h2>
								<ul>
									<li>텐바이텐 회원을 대상으로 한 이벤트 입니다</li>
									<li>10월 29일 ~ 11월 02일 (5일간) 1개의 주문 건당 구매금액에 상관없이 1개의 부메랑이 주어집니다.</li>
									<li>1개의 ID당 최대 5번까지만 신청가능하며, 최대 10,000 마일리지 까지만 환급받을 수 있습니다. (예시: 9,000마일리지 사용 → 10,000 마일리지 환급)</li>
									<li>구매취소 및 환불 시 (부분취소 포함) 신청횟수는 추가로 지급되지 않으며 지급될 마일리지 또한 변동됩니다.</li>
									<li>시스템 프로세스 상 실시간 반영이 되지 않을 수 있으며, 돌려받을 마일리지 지급 액과는 차이가 있을 수 있습니다.</li>
									<li>돌려받는 마일리지는 11월 6일 일괄 지급됩니다.</li>
									<li>마일리지샵 상풍 구매시에는 이벤트에 응모할 수 없습니다.</li>
								</ul>
							</div>
							<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0"></iframe>
						</div>
					</div>
				</div>
				<!--// 이벤트 배너 등록 영역 -->
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->