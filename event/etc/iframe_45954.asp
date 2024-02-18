<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20975
Else
	eCode   =  45886
End If

dim userid, sql, lp, ordList, cnt1, cnt2, cnt3, cnt4
userid  = GetLoginUserID

if IsUserLoginOK then
	'// 응모가능 주문번호 목록 접수
	sql = "select m.orderserial " &_
		" 	,m.subtotalPrice as ttPrice " &_
		" 	,min(d.itemname) as itemname, m.ipkumdate " &_
		" from db_order.dbo.tbl_order_master as m " &_
		" 	join db_order.dbo.tbl_order_detail as d " &_
		" 		on m.orderserial=d.orderserial " &_
		" where m.regdate between '2012-10-10 00:00:00.000' and '2013-10-22 00:00:00.000' " &_
		" 	and m.ipkumdiv>3 " &_
		" 	and m.cancelyn='N' " &_
		" 	and m.userid='" & userid & "' " &_
		" 	and d.itemid<>0 " &_
		" 	and d.cancelyn<>'Y' " &_
		" 	and m.jumundiv<>'9' " &_
		" 	and m.orderserial not in ( " &_
		" 		select sub_opt1 " &_
		" 		from db_event.dbo.tbl_event_subscript " &_
		" 		where evt_code='" & eCode & "' " &_
		" 	) " &_
		" group by m.orderserial, m.subtotalPrice, m.ipkumdate" &_
		" order by ipkumdate"

		rsget.open sql,dbget,1

		if Not(rsget.EOF or rsget.BOF) then
			redim ordList(rsget.RecordCount,4)
			for lp=1 to rsget.RecordCount
				ordList(lp,1) = rsget("orderserial")
				ordList(lp,2) = rsget("ttPrice")
				ordList(lp,3) = rsget("itemname")
				ordList(lp,4) = rsget("ipkumdate")
				rsget.MoveNext
			next
		else
			redim ordList(0)
		end if
		rsget.Close
else
	redim ordList(0)
end if

	sql ="select count(case when sub_opt2='1' then sub_idx end) as item1," &_
		"	count(case when sub_opt2='2' then sub_idx end) as item2," &_
		"	count(case when sub_opt2='3' then sub_idx end) as item3," &_
		"	count(case when sub_opt2='4' then sub_idx end) as item4" &_
		"	from db_event.dbo.tbl_event_subscript where evt_code='"& eCode &"'"
		rsget.Open sql,dbget,1
			cnt1 = rsget(0)
			cnt2 = rsget(1)
			cnt3 = rsget(2)
			cnt4 = rsget(3)
		rsget.Close

If cnt1="" then cnt1=0
If cnt2="" then cnt2=0
If cnt3="" then cn3t=0
If cnt4="" then cnt4=0
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 12th ANNIVERSARY 행운의 번호 보물 찾기!</title>
	<style type="text/css">
	.mEvt45954 img {vertical-align:top;}
	.mEvt45954 .radio {width:12px; height:12px;}
	.mEvt45954 .entry {padding:0 25px;}
	.mEvt45954 .entry table {text-align:center; color:#656565; font-size:11px;}
	.mEvt45954 .entry caption {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
	.mEvt45954 .entry table th {padding:10px 0; background-color:#ffcdc1; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45886/bg_bar.gif); background-position:right 50%; background-repeat:no-repeat;}
	.mEvt45954 .entry table th.first {width:8%;}
	.mEvt45954 .entry table th.first, .mEvt45954 .entry table th.last {background-image:none;}
	.mEvt45954 .entry table td {padding:5px 0; background-color:#f9f9f9;}
	.mEvt45954 .entry table tr.bg td {background-color:#f4f4f4;}
	.mEvt45954 .entry table tr.finish td {background-color:#fff6e1;}
/*	.mEvt45954 .entry table tbody td:first-child {text-align:right;} */
	.mEvt45954 .entry .list {/*overflow:auto; height:125px;*/ border-top:1px solid #fff;}
	/*.mEvt45954 .entry .list table {*width:98%;}*/
	.mEvt45954 .freebie ul {overflow:hidden; padding:0 15px;}
	.mEvt45954 .freebie ul li {float:left; width:46%; padding:0 2%; margin-bottom:20px; text-align:center;}
	.mEvt45954 .freebie ul li img {width:100%;}
	.mEvt45954 .freebie ul li .rate {margin-top:5px;}
	.mEvt45954 .freebie ul li .rate em {display:inline-block; padding:1px 5px; background:#fff7d0; color:#968842; font-size:11px; line-height:12px;}
	.mEvt45954 .notice {position:relative; padding:20px 10px; background:#f0f0f0; text-align:left;}
	.mEvt45954 .notice ul {padding-top:5px;}
	.mEvt45954 .notice ul li {padding-left:8px; font-size:11px; line-height:16px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blt_arrow.png) left 6px no-repeat; color:#7d7d7d; background-size:4px auto;}
</style>
<script type="text/javascript">
<!--
	//주문번호 선택
	function selOrdNo(ono) {
		document.chkForm.sub_opt1.value = ono;
	}

	//응모
	function subreg(frm){
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
			return false;
		}
		if(frm.sub_opt1.value==""){
			alert('응모하실 주문번호를 선택해주세요.');
			return false;
		}

	   if(!(frm.sub_opt2[0].checked||frm.sub_opt2[1].checked||frm.sub_opt2[2].checked||frm.sub_opt2[3].checked)){
			alert('응모하실 상품을 선택해주세요.');
			return false;
		}
			frm.action = 'doEventSubscript45954.asp';
			frm.target = 'ifrProc';
			return true;
	}
//-->
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt45954">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/tit_treasure_hunt.gif" alt="무심코 버린 주문번호, 후회해야 소용없다 보물번호 찾기 in 주문번호 : 쇼핑의 즐거움은 택배가 온 후에도 계속된다!! 이벤트 기간 동안 쇼핑하고 받았던 주문 번호를 확인해주세요 행운의 번호가 숨겨져 있는 100분에게 특별한 선물을 드립니다. ※한 주문 번호당 한 번만 응모가 가능합니다." style="width:100%;" /></p>

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/tit_order_num_check.gif" alt="나의 쇼핑 주문번호 확인하기" style="width:100%;" /></p>

					<form name="chkForm" method="post" onSubmit="return subreg(this);">
					<fieldset>
						<div class="entry">
							<table>
							<caption>주문목록</caption>
							<colgroup>
								<col width="8%" /><col width="30%" /><col width="30%" /><col width="*" />
							</colgroup>
							<thead>
							<tr>
								<th scope="col" class="first"></th>
								<th scope="col"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/th_order_date.gif" style="width:36px;" alt="주문 일자" /></th>
								<th scope="col"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/th_order_num.gif" style="width:38px;" alt="주문 번호" /></th>
								<th scope="col" class="last"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/th_order_pay.gif" style="width:37px;" alt="주문 금액" /></th>
							</tr>
							</thead>
							</table>

							<div class="list">
								<table>
								<colgroup>
									<col width="8%" /><col width="30%" /><col width="30%" /><col width="*" />
								</colgroup>
								<tbody>
					            <% if Not(IsUserLoginOK) then %>
					            <tr height="50px">
					              <td colspan="4">로그인 해주세요.</td>
					            </tr>
								<%
								else
									if ubound(ordList)>0 then
										for lp=1 to ubound(ordList)
								%>
								<tr class="<% IF lp mod 2 = 0 Then response.write "bg" End If %>">
									<td><input type="radio" name="rdoOrdNo" id="rdoOrd<%=lp%>" value="<%=ordList(lp,1)%>" onclick="selOrdNo(this.value)" class="radio" /></td>
									<td><%=left(ordList(lp,4),10)%></td>
									<td><%=ordList(lp,1)%></td>
									<td><%=formatNumber(ordList(lp,2),0)%>원</td>
								</tr>
								<%
										Next
									Else
								%>
								<tr>
									<td colspan="4" height="50px">참여가능한 주문 내역이 없습니다.</td>
								</tr>
								<%
									end if
								end If
								 %>


								</tbody>
								</table>
							</div>
						</div>

						<div class="freebie">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/tit_present_select.gif" alt="갖고 싶은 선물을 고르면 응모 완료!" style="width:100%;" /></p>
							<ul>
								<li>
									<img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/img_freebie_01.jpg" alt="아이코닉 큐브백" />
									<div class="rate"><em>현재 경쟁률 <%= round(cnt1/35,0)%>:1</em></div>
									<input type="radio" name="sub_opt2" value="1" class="radio" />
								</li>
								<li>
									<img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/img_freebie_02.jpg" alt="EPISODE PASS WALLET" />
									<div class="rate"><em>현재 경쟁률 <%= round(cnt2/35,0)%>:1</em></div>
									<input type="radio" name="sub_opt2" value="2" class="radio" />
								</li>
								<li>
									<img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/img_freebie_03.jpg" alt="아이띵소 북파우치" />
									<div class="rate"><em>현재 경쟁률 <%= round(cnt3/35,0)%>:1</em></div>
									<input type="radio" name="sub_opt2" value="3" class="radio" />
								</li>
								<li>
									<img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/img_freebie_04.jpg" alt="서커스보이밴드 Daily Pocket" />
									<div class="rate"><em>현재 경쟁률 <%= round(cnt4/35,0)%>:1</em></div>
									<input type="radio" name="sub_opt2" value="4" class="radio" />
								</li>
							</ul>
						</div>

						<div class="btnArea">
							<input type="hidden" name="sub_opt1" class="orderInput" value="" readonly />
							<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/45954/btn_entry.gif" style="width:100%;" alt="응모하기" />
						</div>
					</fieldset>
					</form>

					<div class="notice">
						<div><strong><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_tit_notice.png" alt="이벤트 유의사항" style="width:67px;" /></strong></div>
						<ul>
							<li>한 주문번호 당 한 번만 응모가 가능합니다.</li>
							<!-- 2013.10.08 -->
							<li>이벤트 기간 (2013년 10월 10일~10월 21일)까지 구매한 상품의 주문번호만 유효합니다.</li>
							<!-- //2013.10.08 -->
							<li>환불이나 교환 시 당첨이 취소될 수 있습니다.</li>
							<li>Gift 카드 구매 시에는 이벤트 응모가 되지 않습니다.</li>
							<li>당첨되시는 분에게는 세무 신고를 위해 개인정보를 요청할 수 있습니다.</li>
						</ul>
					</div>
 <iframe name="ifrProc" id="ifrProc" src="about:blank" width="0" height="0" frameborder="0"></iframe>
					<!-- 12.10.08 -->
					<div><a href="/event/eventmain.asp?eventid=
45951" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45954/btn_go.gif" style="width:100%;" alt="보물은 이 곳에만 있는게 아니랍니다. 홀짝게임으로 마일리지를 쌓아보세요! 홀짝 게임하러 바로가기" /></a></div>
					<!-- //12.10.08 -->
				</div>
			</div>
			<!-- //content area -->

</body>
</html>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->