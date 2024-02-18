<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "20902"
	Else
		eCode 		= "42365"
	End If

If IsUserLoginOK Then
	sqlstr = "Select count(sub_idx) as totcnt" &_
			"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "'"
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		totalsum = rsget(0)
		cnt = rsget(1)
	rsget.Close

	sqlstr= "select (select couponkey from db_temp.dbo.tbl_innisfree_coupon as c where c.userid = s.userid and c.idx = s.sub_opt1) as couponkey, s.regdate, s.sub_opt2, s.userid  " &_
		" FROM db_event.dbo.tbl_event_subscript as s " &_
		" where s.evt_code='" & eCode &"' and s.userid='" & GetLoginUserID()  & "'"
		'response.write sqlstr
	rsget.Open sqlStr,dbget
	IF Not rsget.EOF THEN
		arrList = rsget.getRows()
	END IF
	rsget.Close
End If

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > You are so Beautiful</title>
	<style type="text/css">
	.mEvt42366 img {vertical-align:top;}
	.mEvt42366 input {border-radius:0;}
	.mEvt42366 .myWin {background:url("http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_bg01.png") left top repeat-y; background-size:100% 100%;}
	.mEvt42366 .myWin table {width:100%; font-size:0.5em;}
	.mEvt42366 .myWin table th {background:#b1c986 url("http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_bg02.png") right center no-repeat; background-size:1px 8px; text-align:center; padding:4px 0 5px; color:#555; font-weight:bold; vertical-align:middle;}
	.mEvt42366 .myWin table th:last-child {background-image:none;}
	.mEvt42366 .myWin table td {background-color:#fff; padding:5px 0; margin:0; text-align:center; vertical-align:middle; color:#777;;}
	.mEvt42366 .myWin table tbody tr:first-child td {padding-top:10px !important;}
	.mEvt42366 .myWin table tbody tr:last-child td {padding-bottom:10px !important;}
	.mEvt42366 .myWin table tr.kit td:nth-child(2),
	.mEvt42366 .myWin table tr.kit td:nth-child(3) {font-weight:bold; color:#86ab00;}
	.mEvt42366 input {vertical-align:top;}
	.mEvt42366 .apply {width:100%; height:148px; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42365/42365_bg02.jpg) left top no-repeat;}
	</style>
<script type="text/javascript">
		function checkform(frm) {
		<% if datediff("d",date(),"2013-05-30")>=0 then %>
			<% If IsUserLoginOK Then %>
				<% if cnt >= 1 then %>
				alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
				return;
				<% else %>
					frm.action = "doEventSubscript42366.asp?evt_code=<%=eCode%>";
					return true;
				<% end if %>
			<% Else %>
				alert('로그인 후에 응모하실 수 있습니다.');

				return;
			<% End If %>
		<% else %>
				alert('이벤트가 종료되었습니다.');
				return;
		<% end if %>
		}
</script>
</head>

			<!-- content area -->

				<div class="mEvt42366">
					<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img01.png" alt="You are so Beautiful" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img02.png" alt="GIFT 01 : 하나로 예뻐지는 BEAUTY KIT - 1,000명" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img03.png" alt="GIFT 02 : 이니스프리 COUPON" style="width:100%;" /></p>
					<p><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img04.png" alt="응모하기" style="width:100%;" style="cursor:pointer;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img05.png" alt="" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img06.png" alt="" style="width:55%;" /><a href="http://www.innisfree.co.kr/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img07.png" alt="이니스프리 할인쿠폰 등록하러 가기" style="width:45%;" /></a></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img08.png" alt="이니스프리 로그인→마이페이지&gt;내 보유쿠폰→온라인 쿠폰조회&gt;난수쿠폰 등록→당첨된 쿠폰금액 선택 후 번호 입력하여 발급받기" style="width:100%;" /></p>
					</form>
					<!-- 나의 당첨 내역 -->
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img09.png" alt="나의 당첨 내역" style="width:100%;" /></p>
					<div class="inner myWin">
						<table cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="25%" /><col width="30%" /><col width="" />
							</colgroup>
							<thead>
								<tr>
									<th>응모 일시</th>
									<th>당첨 내역</th>
									<th>내용 / 쿠폰 번호</th>
								</tr>
							</thead>
							<tbody>
								<% If totalsum=0 Then %>
								<tr><td colspan="3"><% response.write "당첨내역이 없습니다." %></td></tr>
								<% else %>
								<% For i = 0 To totalsum-1 %>
								<tr <% If arrLIst(2,i)="1" or arrLIst(2,i)="2" Then response.write "" else response.write "class='kit'" end if %>><!-- for dev msg : 뷰티키트 당첨일 경우 tr클래스 kit 추가 -->
									<td><%= Left(arrLIst(1,i),10)%></td>
									<td><% If arrLIst(2,i)="1" Then response.write "3,000원 할인 쿠폰" else if arrLIst(2,i)="2" then response.write "5,000원 할인 쿠폰" else  response.write "BEAUTY KIT" End If %></td>
									<td><% If arrLIst(2,i)="1" or arrLIst(2,i)="2" Then response.write arrLIst(0,i)  else response.write "5월 30일 (목) 게시판 별도 공지됩니다." end If  %></td>
								</tr>
								<% next %>
								<% End If %>
							</tbody>
						</table>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img11.png" alt="당첨되신 쿠폰번호는 개인정보에 있는 e-mail로도 전송됩니다. 개인정보의 메일주소를 확인하세요." style="width:100%;" /></p>
					<!--// 나의 당첨 내역 -->

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42366/42366_img12.png" alt="이벤트 안내-한 ID 당 매일 1회 참여 가능합니다./BEAUTY KIT 는 이벤트종료 후, 주소 확인을 통해 일주일 내로 배송됩니다.( 5월 30일 목요일, 게시판 별도 공지 )/BEAUTY KIT 내의 파우치, 손거울의 색상은 랜덤으로 발송됩니다." style="width:100%;" /></p>
				</div>

			<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->