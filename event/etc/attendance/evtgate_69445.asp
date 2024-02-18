<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 별 세는 밤 - 브릿지 페이지 for mobile
' History : 2016-03-02 유태욱
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
 <!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
Dim userid : userid = getencloginuserid()
Dim prize1 , prize2 , prize3
Dim eCode , strSql

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66053
	Else
		eCode   =  69445
	End If

	If userid = "baboytw" Or userid = "greenteenz" Or userid = "cogusdk" Or userid = "helele223" OR userid="kjy8517" Then
		strSql = " select "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize1 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 7 then 1 else 0 end),0) as prize3  "

		strSql = strSql & "	from db_event.dbo.tbl_event_subscript "
		strSql = strSql & "	where evt_code = '" & eCode & "' "
		rsget.Open strSql,dbget,1
		'Response.write strSql
		IF Not rsget.Eof Then
			prize1	= rsget("prize1")	'// 2일차 응모 - 마일리지 200p 응모 3/15 일괄지급
			prize2	= rsget("prize2")	'//	4일차 응모 - 3만/5천 쿠폰 발급
			prize3	= rsget("prize3")	'//	7일차 응모 - 더어스램프30명 응모 3/15 추첨
		End IF
		rsget.close()
	End If

%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body>
<!-- 별 세는 밤  -->
<% If userid = "baboytw" Or userid = "greenteenz" Or userid = "cogusdk" Or userid = "helele223" OR userid="kjy8517" Then %>
	<style type="text/css">
	html {font-size:11px;}
	@media (max-width:320px) {html{font-size:10px;}}
	@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
	@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
	@media (min-width:750px) {html{font-size:16px;}}
	
	img {vertical-align:top;}
	
	.hidden {visibility:hidden; width:0; height:0;}
	
	.mEvt69445 button {background-color:transparent;}
	
	.countStar {position:relative;}
	.countStar .btnClick {position:absolute; top:47%; left:0; width:100%; height:19.941%;}
	.countStar .btnClick .bg {position:absolute; top:0; left:43%; width:19.68%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_light.png) no-repeat 50% 50%; background-size:100% 100%;}
	
	.painting {animation-name:painting; animation-duration:2.2s; animation-fill-mode:both; animation-iteration-count:3;}
	.painting {-webkit-animation-name:painting; -webkit-animation-duration:2.2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:3;}
	@keyframes painting {
		0% {background-size:70% 70%;}
		100% {background-size:100% 100%;}
	}
	@-webkit-keyframes painting {
		0% {background-size:70% 70%;}
		100% {background-size:100% 100%;}
	}
	
	.countStar .btnClick .hand {position:absolute; top:36.5%; left:53.5%; width:12.65%;}
	.countStar .star {position:absolute; width:4.68%;}
	.countStar .star {animation-name:twinkle; animation-iteration-count:3; animation-duration:2.5s; animation-fill-mode:both;}
	.countStar .star {-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:2.5s; -webkit-animation-fill-mode:both;}
	.countStar .star1 {top:60%; left:43%;}
	.countStar .star2 {top:46%; right:30%; animation-delay:0.2s; -webkit-animation-delay:0.2s;}
	.countStar .star3 {top:42%; left:34%; animation-delay:0.4s; -webkit-animation-delay:0.4s;}
	.countStar .star4 {top:50%; left:15%; animation-delay:0.6s; -webkit-animation-delay:0.6s;}
	.countStar .star5 {top:58%; right:9%; animation-delay:0.2s; -webkit-animation-delay:0.2s;}
	.countStar .star6 {top:40%; right:13%; animation-delay:0.4s; -webkit-animation-delay:0.4s;}
	.countStar .star7 {top:41%; left:5%; animation-delay:0.6s; -webkit-animation-delay:0.6s;}
	
	@-webkit-keyframes twinkle {
		0% {opacity:0;}
		100% {opacity:1;}
	}
	@keyframes twinkle {
		0% {opacity:0;}
		100% {opacity:1;}
	}
	
	.countStar .count {position:absolute; bottom:6%; left:50%; width:75.156%; margin-left:-37.578%; padding:2% 0; border-radius:2rem; background-color:#312815; color:#fff; font-size:1.3rem; text-align:center;}
	.countStar .count span {color:#ffef68; border-bottom:1px solid #ffef68;}
	
	.gift {position:relative;}
	.gift ol {overflow:hidden; position:absolute; top:23%; left:50%; width:95.312%; height:59%; margin-left:-47.656%; /*background-color:red; opacity:0.2;*/}
	.gift ol li {float:left; position:relative; width:33.333%; height:100%;}
	.gift ol li p {color:transparent;}
	.gift ol li button {position:absolute; bottom:10%; left:50%; width:82.17%; margin-left:-41.085%;}
	
	.noti {padding:8% 8.4375%; background-color:#272727;}
	.noti h3 {color:#fff; font-size:1.4rem; font-weight:bold;}
	.noti ul {margin-top:1.5rem;}
	.noti ul li {position:relative; padding-left:1rem; color:#fff; font-size:1.1rem; line-height:1.688em;}
	.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#a78223;}
	.noti ul li strong {color:#ffef68; font-weight:normal;}
	</style>
	<table class="table" style="width:90%;">
		<colgroup>
			<col width="8%" />
			<col width="*" />
			<col width="*" />
			<col width="*" />
			<col width="*" />
			<col width="*" />
			<col width="*" />
		</colgroup>
		<tr align="center" bgcolor="#E6E6E6">
			<th><strong>1Day</strong></th>
			<th><strong>2Day</strong></th>
			<th><strong>3Day</strong></th>
			<th><strong>4Day</strong></th>
			<th><strong>5Day</strong></th>
			<th><strong>6Day</strong></th>
			<th><strong>7Day</strong></th>
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
			<td colspan="3" style="text-align:right;">마일리지:<%=prize1%></td>
			<td colspan="2" style="text-align:right;">쿠폰:<%=prize2%></td>
			<td colspan="2" style="text-align:right;">램프:<%=prize3%></td>
		</tr>
	</table>
<% End If %>
<div class="mEvt69445">
	<article>
		<h2 class="hidden">별 헤는 밤</h2>

		<section class="countStar">
			<h3 class="hidden">매일 한 번 씩 밤하늘을 클릭해주세요!</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/txt_count_star.jpg" alt="매일 당신이 올 때 마다 하나의 별이 뜹니다. 별이 많아지면 깜짝 선물이 찾아옵니다!" /></p>
		</section>
	</article>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->