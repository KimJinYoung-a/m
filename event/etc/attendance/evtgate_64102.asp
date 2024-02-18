<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 별 세는 밤 - 브릿지 페이지 for mobile
' History : 2015-06-24 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
Dim userid : userid = getloginuserid()
Dim prize1 , prize2 , prize3 , prize4 , prize5 , prize6
Dim win2 , win4 , win6 , eCode , strSql

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63799
	Else
		eCode   =  64101
	End If

	If userid = "motions" Or userid = "stella0117" Or userid = "bborami" Then
		strSql = " select "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 1 then 1 else 0 end),0) as prize1 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 and sub_opt2 = 1 then 1 else 0 end),0) as win2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 3 then 1 else 0 end),0) as prize3 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize4 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 and sub_opt2 = 1 then 1 else 0 end),0) as win4 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 5 then 1 else 0 end),0) as prize5 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 then 1 else 0 end),0) as prize6 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 and sub_opt2 = 1 then 1 else 0 end),0) as win6  "
		strSql = strSql & "	from db_event.dbo.tbl_event_subscript "
		strSql = strSql & "	where evt_code = '" & eCode & "' "
		rsget.Open strSql,dbget,1
		'Response.write strSql
		IF Not rsget.Eof Then
			prize1	= rsget("prize1")	'// 3일차 응모 - 마일리지 500point - 전원지급
			prize2	= rsget("prize2")	'//	5일차 응모 - 미니무드등 - 200명 - 5%
			win2	= rsget("win2")		'// 당첨여부
			prize3	= rsget("prize3")	'//	7일차 응모 - 마일리지 1,000point - 전원지급
			prize4	= rsget("prize4")	'//	10일차 응모 - 에코백 - 100명 - 5%
			win4	= rsget("win4")		'// 당첨여부
			prize5	= rsget("prize5")	'//	11일차 응모 - 마일리지 1,000point -  전원지급
			prize6	= rsget("prize6")	'//	12일차 응모 - THE LAMP - 10명 - 1%
			win6	= rsget("win6")		'// 당첨여부
		End IF
		rsget.close()
	End If

%>
<style type="text/css">
img {vertical-align:top;}
.evtNoti {padding:21px 17px 0;}
.evtNoti h3 strong {display:inline-block; padding:6px 10px 4px; color:#222; font-size:14px; line-height:0.9; background:#dee6e6; border-radius:12px;}
.evtNoti ul {padding-top:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.1; padding:0 0 5px 10px; color:#444;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:1px; top:4px; width:3.5px; height:3.5px; background:#8c9ace; border-radius:50%;}
@media all and (min-width:480px){
	.evtNoti {padding:31px 26px 0;}
	.evtNoti h3 strong {padding:9px 15px 6px; font-size:21px; border-radius:18px;}
	.evtNoti ul {padding-top:18px;}
	.evtNoti li {font-size:17px; padding:0 0 7px 15px;}
	.evtNoti li:after {top:6px; width:5px; height:5px;}
}
</style>
<!-- 별 세는 밤  -->
<% If userid = "motions" Or userid = "stella0117" Or userid = "bborami" Then %>
<style type="text/css">
.table {width:900px; margin:0 auto; font-family:'malgun gothic'; border-collapse:collapse;}
.table th {padding:12px 0; font-size:13px; font-weight:bold;  color:#fff; background:#444;}
.table td {padding:12px 3px; font-size:12px; border:1px solid #ddd; border-bottom:2px solid #ddd;}
.table td.lt {text-align:left; padding:12px 10px;}
.tBtn {display:inline-block; border:1px solid #2b90b6; background:#03a0db; padding:0 10px 2px; line-height:26px; height:26px; font-weight:bold; border-radius:5px; color:#fff !important;}
.tBtn:hover {text-decoration:none;}
.table td input {border:1px solid #ddd; height:30px; padding:0 3px; font-size:14px; color:#ec0d02; text-align:right;}
</style>
<table class="table" style="width:90%;">
	<colgroup>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
		<col width="*"/>
	</colgroup>
	<tr align="center" bgcolor="#E6E6E6">
		<th><strong>6/29</strong></th>
		<th><strong>6/30</strong></th>
		<th><strong>7/01</strong></th>
		<th><strong>7/02</strong></th>
		<th><strong>7/03</strong></th>
		<th><strong>7/04</strong></th>
		<th><strong>7/05</strong></th>
		<th><strong>7/06</strong></th>
		<th><strong>7/07</strong></th>
		<th><strong>7/08</strong></th>
		<th><strong>7/09</strong></th>
		<th><strong>7/10</strong></th>
	</tr>
	<tr bgcolor="#FFFFFF" align="center">
		<%
			strSql = "select "
			strSql = strSql & " convert(varchar(10),t.regdate,120) "
			strSql = strSql & " , count(*) as totcnt "
			strSql = strSql & " from db_temp.[dbo].[tbl_event_attendance] as t "
			strSql = strSql & " inner join db_event.dbo.tbl_event as e "
			strSql = strSql & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
			strSql = strSql & "	where t.evt_code = '"& eCode &"' " 
			strSql = strSql & "	group by convert(varchar(10),t.regdate,120) " 
			strSql = strSql & "	order by convert(varchar(10),t.regdate,120) " 
			rsget.Open strSql,dbget,1
			If Not rsget.Eof Then
				Do Until rsget.eof
		%>
		<td bgcolor="">참여<br/><%= rsget("totcnt") %></td>
		<%
				rsget.movenext
				Loop
			End IF
			rsget.close
		%>
	</tr>
	<tr>
		<td colspan="3" style="text-align:right;">응:<%=prize1%></td>
		<td colspan="2" style="text-align:right;">응:<%=prize2%><br/>당:<%=win2%></td>
		<td colspan="2" style="text-align:right;">응:<%=prize3%></td>
		<td colspan="3" style="text-align:right;">응:<%=prize4%><br/>당:<%=win4%></td>
		<td style="text-align:center;">응:<%=prize5%></td>
		<td style="text-align:center;">응:<%=prize6%><br/>당:<%=win6%></td>
	</tr>
	<tr align="center" bgcolor="#E6E6E6">
		<th><strong>누적<br/>1회</strong></th>
		<th><strong>누적<br/>2회</strong></th>
		<th><strong>누적<br/>3회</strong></th>
		<th><strong>누적<br/>4회</strong></th>
		<th><strong>누적<br/>5회</strong></th>
		<th><strong>누적<br/>6회</strong></th>
		<th><strong>누적<br/>7회</strong></th>
		<th><strong>누적<br/>8회</strong></th>
		<th><strong>누적<br/>9회</strong></th>
		<th><strong>누적<br/>10회</strong></th>
		<th><strong>누적<br/>11회</strong></th>
		<th><strong>누적<br/>12회</strong></th>
	</tr>
	<tr bgcolor="#FFFFFF">
	<%
		strSql = " WITH A AS "
		strSql = strSql & " ( "
		strSql = strSql & " SELECT 1 seq, count(t.totcnt) as totcnt from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 1 ) as t "
		strSql = strSql & " UNION ALL SELECT 2,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 2 ) as t "
		strSql = strSql & " UNION ALL SELECT 3,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 3 ) as t "
		strSql = strSql & " UNION ALL SELECT 4,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 4 ) as t "
		strSql = strSql & " UNION ALL SELECT 5,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 5 ) as t "
		strSql = strSql & " UNION ALL SELECT 6,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 6 ) as t "
		strSql = strSql & " UNION ALL SELECT 7,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 7 ) as t "
		strSql = strSql & " UNION ALL SELECT 8,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 8 ) as t "
		strSql = strSql & " UNION ALL SELECT 9,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 9 ) as t "
		strSql = strSql & " UNION ALL SELECT 10,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 10 ) as t "
		strSql = strSql & " UNION ALL SELECT 11,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 11 ) as t "
		strSql = strSql & " UNION ALL SELECT 12,  count(t.totcnt) from ( select count(*) totcnt , userid from db_temp.dbo.tbl_event_attendance	group by userid having count(*) = 12 ) as t "
		strSql = strSql & " ) "
		strSql = strSql & " SELECT * FROM A "
		rsget.Open strSql,dbget,1
		If Not rsget.Eof Then
			Do Until rsget.eof
	%>
	<td bgcolor="" style="text-align:center">참여<br/><%= rsget("totcnt") %></td>
	<%
			rsget.movenext
			Loop
		End IF
		rsget.close
	%>
	</tr>
</table>
<% End If %>
<div class="mEvt64102">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64102/tit_count_stars.gif" alt="초능력자들을 기다립니다! 별 세는 밤" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64102/txt_click_sky.gif" alt="매일 한 번씩 밤하늘을 클릭해주세요!" /></p>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64102/img_star_gift.gif" alt="별 세고 선물받기- 별의 개수에 따라서 응모하실 수 있어요!" /></div>
	<p><a href="" onclick="location.href='http://m.10x10.co.kr/apps/link/?7520150626';return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64102/btn_go_app.gif" alt="텐바이텐 APP으로 가기" /></a></p>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다.</li>
			<li>텐바이텐 APP에서만 참여할 수 있습니다.</li>
			<li>하루 한 개의 별만 켤 수 있습니다.</li>
			<li>별을 쌓은 개수에 따라서 각 미션에 응모할 수 있습니다.</li>
			<li>이벤트 기간 후에 응모하실 수 없습니다.</li>
			<li>이벤트를 통해 받으실 마일리지는 2015년 7월 15일(수)에 일괄 지급됩니다.</li>
			<li>이벤트 경품에 당첨되신 고객님은 2015년 7월 15일(수)에 배송지 주소를 입력해주세요.</li>
			<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
		</ul>
	</div>
</div>
<!--// 별 세는 밤  -->
<!-- #include virtual="/lib/db/dbclose.asp" -->