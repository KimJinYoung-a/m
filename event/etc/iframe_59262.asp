<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 10초의 기적 모바일 페이지
' History : 2015.02.09 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, vUserID, EventJoinChk, EventTotalChk, sqlstr, vEvt_name, vEvtStartdate, vEvtEnddate, vMasterIdx, vMiracleDate, vMiraclePrice, vMiracleGiftItemId, vToday, LoginUserid, lpi
	vUserID = GetLoginUserID()
	
	IF application("Svr_Info") = "Dev" Then
		eCode = "21470"
	Else
		eCode = "59262"
	End If



	vToDay = left(Now(), 10) '// 오늘 날짜 값..
'	vToday = "2015-02-11"
	LoginUserid = getLoginUserid() '// 회원아이디
	lpi = 1 '// style값 순차번호등에 쓰임..


	'// 날짜값을 기준으로 메인정보를 가져온다.
	sqlstr = " Select idx, miracledate, miracleprice, miraclegiftitemid, regdate " &_
				 " From db_temp.dbo.tbl_MiracleOf10sec_Master " &_
				" Where convert(varchar(10), miracledate, 120) = '"&vToDay&"' "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		vMasterIdx = rsget("idx")
		vMiracleDate = Left(rsget("miracledate"), 10)
		vMiraclePrice = CLng(getNumeric(rsget("miracleprice")))
		vMiracleGiftItemId = CLng(getNumeric(rsget("miraclegiftitemid")))
	Else
		response.write "<script>alert('이벤트 기간이 아닙니다.');parent.location.href='/shoppingtoday/shoppingchance_allevent.asp';</script>"
		response.End		
	End If
	rsget.close
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.tenSecondsMiracle .todayBox {position:relative; padding:0 0 25px;  background-size:100% auto; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59261/bg_dot_0209.gif) left top repeat-y;}
.tenSecondsMiracle .todayBox ul {overflow:hidden; padding:0 8px 10px;}
.tenSecondsMiracle .todayBox li {float:left; width:50%; text-align:center;}
.tenSecondsMiracle .todayBox li a {display:block; margin:1px; padding:8px 0; background:#add2ee;}
.tenSecondsMiracle .todayBox li a img {padding:0 10px;}
.tenSecondsMiracle .todayBox li a span {display:inline-block; vertical-align:top; font-size:10px; letter-spacing:-0.05em; margin:7px 2px 0; font-weight:bold; color:#383838; padding:3px 5px 1px; border-radius:8px; white-space:nowrap; background:#75adde;}
.tenSecondsMiracle .goBtn {display:block; margin:0 auto;}
.tenSecondsMiracle .goMiracle {width:100%;}
.tenSecondsMiracle .goNext {width:36%; margin-top:20px;}
.finish {position:absolute; left:0; top:0; width:100%; height:92.5%; background:rgba(0,0,0,.5); z-index:80;}
.finish p {padding-top:60%;}
@media all and (min-width:480px){
	.tenSecondsMiracle .todayBox {padding:0 0 38px;}
	.tenSecondsMiracle .todayBox ul {padding:0 12px 15px;}
	.tenSecondsMiracle .todayBox li a {margin:2px; padding:12px 0;}
	.tenSecondsMiracle .todayBox li a img {padding:0 15px;}
	.tenSecondsMiracle .todayBox li a span {font-size:15px; margin:11px 3px 0; padding:4px 7px 2px; border-radius:12px;}
}
</style>
<script type="text/javascript">

function go_bannerLog(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/event/etc/doEventSubscript59262.asp",
		data: "mode=mobilebanner",
		dataType: "text",
		async: false
	}).responseText;
	if (rstStr == "OK"){
		parent.top.location.href='http://m.10x10.co.kr/apps/link/?2520150201';
		return false;
	}else{
		alert('관리자에게 문의');
		return false;
	}
}

</script>
</head>
<body>

<div class="evtCont">
	<!-- 10초의 기적(M) -->
	<div class="mEvt59262">
		<!-- 오늘의 상품 -->
		<div class="tenSecondsMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59262/tit_ten_miracle.gif" alt="10초의 기적" /></h2>
			<div class="todayBox">
				<ul>
					<%
						'// masteridx값을 기준으로 해당월에 맞는 상품을 가져온다.
						sqlstr = " Select idx, masteridx, itemid1, itemname1, itemprice1, itemid2, itemname2, itemprice2 " &_
									 " From db_temp.dbo.tbl_miracleof10sec_product " &_
									" Where masteridx='"&vMasterIdx&"' order by orderby "
						rsget.Open sqlStr,dbget,1
						If Not(rsget.bof Or rsget.eof) Then
							Do Until rsget.eof
					%>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=<%=rsget("itemid1")%>" target="_blank">
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid1")%>.jpg" alt="<%=rsget("itemname1")%>" />
									<span><%=rsget("itemname1")%></span>
								</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=<%=rsget("itemid2")%>" target="_blank">
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid2")%>.jpg" alt="<%=rsget("itemname2")%>" />
									<span><%=rsget("itemname2")%></span>
								</a>
							</li>
					<%
							rsget.movenext
							Loop
						End If
						rsget.close
					%>
				</ul>
				<a href="" onclick="go_bannerLog();return false;" class="goBtn goMiracle"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59262/btn_go_app.png" alt="텐바이텐 APP으로 가기" /></a>
			</div>
		</div>
		<!--// 오늘의 상품 -->
	</div>
	<!--// 10초의 기적(M) -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->