<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : 최 저 가 왕 for mobile & app (구 10원의 기적)
' History : 2015.07.06 이종화 
'###########################################################
dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "64819"
		linkeCode	= "64819"
	Else
		eCode 		= "64636"
		linkeCode	= "64636"
	End If

reDim tIdx(2), tSdate(2), tEdate(2), tSviewdate(2), tEviewdate(2), tProductCode(2), tProductName(2), tProductPrice(2), tAuctionMinPrice(2)
reDim tAuctionMaxPrice(2), tWinnerPrice(2), tWinneruserid(2), tRegdate(2), tstatus(2)

Dim vIdx, vSdate, vEdate, vSviewdate, vEviewdate, vProductCode, vProductName, vProductPrice, vAuctionMinPrice
Dim vAuctionMaxPrice, vWinnerPrice, vWinneruserid, vRegdate, vstatus
Dim WinnerUserIdLength, vWinneruseridView, endtime, nowtime
Dim im_tmpuserPrice, tmpuserPrice, userPrice11 , userPrice12 , userPrice21 , userPrice22
Dim tempi

	'// 현재 일자, 시간에 맞는 상품값을 불러온다.(viewdate기준)
	sqlstr = " Select idx, sdate, edate, sviewdate, eviewdate, productCode, productName, productPrice, auctionMinPrice, auctionMaxPrice, " &_
				" winnerPrice, winneruserid, regdate From db_temp.dbo.tbl_MiracleOf10Won " &_
				" Where getdate() >= sviewdate And  getdate() <= eviewdate and isusing = 'Y' order by roundnum asc "
	'Response.write sqlstr &"<br/>"
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		tempi = 0
		Do Until rsget.eof
			tIdx(tempi) = rsget("idx")
			tSdate(tempi) = rsget("sdate") '// 실제 경매 시작 일, 시간
			tEdate(tempi) = rsget("edate") '// 실제 경매 종료 일, 시간
			tSviewdate(tempi) = rsget("sviewdate") '// 페이지에 보여지는 시작 일, 시간
			tEviewdate(tempi) = rsget("eviewdate") '// 페이지에 보여지는 종료 일, 시간
			tProductCode(tempi) = rsget("productCode") '// 상품코드
			tProductName(tempi) = rsget("productName") '// 상품명
			tProductPrice(tempi) = rsget("productPrice") '// 상품 원래 가격
			tAuctionMinPrice(tempi) = rsget("auctionMinPrice") '// 최저 경매가
			tAuctionMaxPrice(tempi) = rsget("auctionMaxPrice") '// 최고 경매가
			tWinnerPrice(tempi) = rsget("winnerPrice") '// 당첨됐다면 당첨된 금액
			tWinneruserid(tempi) = rsget("winneruserid") '// 당첨됐다면 당첨된자 아이디
			tRegdate(tempi) = rsget("regdate") '// 등록일
		rsget.movenext
		tempi = tempi + 1
		Loop

	End If
	rsget.Close

	'//시간 구간별로 변수 변경
	If Now() >= tSdate(0) And Now() <= tEdate(0) Then
		vIdx			=	tIdx(0)
		vSdate			=	tSdate(0)
		vEdate			=	tEdate(0)
		vProductCode	=	tProductCode(0)
		vProductName	=	tProductName(0)
		tstatus(0)		=	True
		vstatus			=	tstatus(0)	
	Else
		tstatus(0)		=	False
		vstatus			=	tstatus(0)
	End If 

	If Now() >= tSdate(1) And Now() <= tEdate(1) Then
		vIdx			=	tIdx(1)
		vSdate			=	tSdate(1)
		vEdate			=	tEdate(1)
		vProductCode	=	tProductCode(1)
		vProductName	=	tProductName(1)
		tstatus(1)		=	True
		vstatus			=	tstatus(1)	
	Else
		tstatus(1)		=	False
		vstatus			=	tstatus(1)	
	End If 

'	Response.write now() &"<br/>"
'	Response.write tSdate(1) &"<br/>"
'	Response.write tSdate(0) &"<br/>"

	'// 종료시간 표시
	If vEdate <> "" Then
		endtime = GetTranTimer(vEdate)	'종료 시간
		nowtime = GetTranTimer(now())	'현재 시간
	End If

	If IsUserLoginOK Then
		'//1라운드 현황		
		'// 해당 경매별 개인 응모횟수를 가져온다.
		sqlstr = " Select count(userid) From db_temp.dbo.tbl_MiracleOf10Won_list " &_
						" Where evt_code='"&eCode&"' And prizecode='"&tIdx(0)&"' And userid='"&GetLoginUserID&"' "
		rsget.Open sqlStr,dbget,1
			cnt = rsget(0)
		rsget.close

		'// 해당 경매별 개인 작성금액 값을 가져온다.
		sqlstr = " Select lprice From db_temp.dbo.tbl_MiracleOf10Won_list " &_
						" Where evt_code='"&eCode&"' And prizecode='"&tIdx(0)&"' And userid='"&GetLoginUserID()&"' order by regdate desc "
		rsget.Open sqlStr,dbget,1
		If Not(rsget.bof Or rsget.eof) Then
			Do Until rsget.eof
				tmpuserPrice = rsget("lprice")&"|"&tmpuserPrice
			rsget.movenext
			Loop
		End If
		rsget.close

		'// 개인별 작성금액값 정렬
		If cnt >= 0 Then
			im_tmpuserPrice = Split(tmpuserPrice,"|")
			If cnt=1 Then
				userPrice11 = im_tmpuserPrice(0)
			End If
			If cnt=2 Then
				userPrice11 = im_tmpuserPrice(0)
				userPrice12 = im_tmpuserPrice(1)
			End If
		End If
		'//2라운드 현황	
		'// 해당 경매별 개인 응모횟수를 가져온다.
		sqlstr = " Select count(userid) From db_temp.dbo.tbl_MiracleOf10Won_list " &_
						" Where evt_code='"&eCode&"' And prizecode='"&tIdx(1)&"' And userid='"&GetLoginUserID&"' "
		rsget.Open sqlStr,dbget,1
			cnt = rsget(0)
		rsget.close

		'// 해당 경매별 개인 작성금액 값을 가져온다.
		sqlstr = " Select lprice From db_temp.dbo.tbl_MiracleOf10Won_list " &_
						" Where evt_code='"&eCode&"' And prizecode='"&tIdx(1)&"' And userid='"&GetLoginUserID()&"' order by regdate desc "
		rsget.Open sqlStr,dbget,1
		If Not(rsget.bof Or rsget.eof) Then
			Do Until rsget.eof
				tmpuserPrice = rsget("lprice")&"|"&tmpuserPrice
			rsget.movenext
			Loop
		End If
		rsget.close

		'// 개인별 작성금액값 정렬
		If cnt >= 0 Then
			im_tmpuserPrice = Split(tmpuserPrice,"|")
			If cnt=1 Then
				userPrice21 = im_tmpuserPrice(0)
			End If
			If cnt=2 Then
				userPrice21 = im_tmpuserPrice(0)
				userPrice22 = im_tmpuserPrice(1)
			End If
		End If
	End If

'//어제 당첨자 리스트 2일부터 마지막 날까지
reDim tmpprice(2) , tempwinid(2) , roundnum(2)
If Date() >= "2015-07-13" And Date() <= "2015-07-22" Then
	sqlstr = " select T.winnerprice , T.winneruserid , T.roundnum from " &_
			"	( " &_
			"		select top 2 * from  db_temp.dbo.tbl_MiracleOf10Won " &_
			"		where isusing = 'Y' and winnerprice <>'' and winneruserid <> '' " &_
			"		and convert(varchar(10),sdate,120) < '"& Date() &"' " &_
			"		order by idx desc "&_
			"	) as T " &_
			"	order by T.roundnum asc "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		tempi = 0
		Do Until rsget.eof
			tmpprice(tempi) = rsget("winnerprice")
			tempwinid(tempi) = rsget("winneruserid")
			roundnum(tempi) = rsget("roundnum")
		rsget.movenext
		tempi = tempi + 1
		Loop
	End If
End If 

'// 시간을 타이머용으로 변환
Function GetTranTimer(tt)
	if (tt="" or isNull(tt)) then Exit Function
	GetTranTimer = Num2Str(Year(tt),4,"0","R") & Num2Str(Month(tt),2,"0","R") & Num2Str(Day(tt),2,"0","R") &_
					Num2Str(Hour(tt),2,"0","R") & Num2Str(Minute(tt),2,"0","R") & Num2Str(Second(tt),2,"0","R")
end Function

'//친구찬스 URL
Dim kakaourl
If isapp = "1" Then
	kakaourl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="& eCode
Else
	kakaourl = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
End If 
%>
<style>
img {vertical-align:top;}
.mEvt64636 {position:relative; text-align:center;}
.priceKing {padding-top:15px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_pattern.gif) 0 0 repeat-y; background-size:100% 100%}
.priceKing .itemCont {position:relative; padding:0 12.5% 35px; margin-bottom:15px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_pdt_box.png) 0 100% no-repeat; background-size:100% auto;}
.itemCont .soon10am {position:absolute; left:6.2%; top:-6px; width:87.7%; height:98.8%; padding-top:40%; background:rgba(0,0,0,.75); z-index:30;}
.todayItem .pic {padding-bottom:13px;}
.todayItem .time span {display:inline-block; font-size:40px; color:#000; font-weight:900; padding-left:40px; line-height:33px; letter-spacing:2px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/ico_time.gif) 0 0 no-repeat; background-size:33px auto; font-family:helveticaNeue, helvetica, sans-serif !important;}
.todayItem .king {font-size:13px; font-weight:600;}
.todayItem .king strong {display:inline-block; font-family:helveticaNeue, helvetica, sans-serif !important;}
.todayItem .king .t01 { color:#d50c0c; }
.todayItem .king .t01 strong {position:relative; top:2px; padding-right:2px; font-size:26px;}
.todayItem .king .t02 {color:#333; padding-top:7px;}
.todayItem .king .t02 strong {padding:0 2px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_line.gif) 0 100% repeat-x; background-size:100% 90%;}
.todayItem .tabNav1_1:after {content:" "; display:block; clear:both;}
.todayItem .tabNav1_1 li {position:relative; float:left; width:50%; background-position:0 0; background-repeat:no-repeat; background-size:100% 200%;}
.todayItem .tabNav1_1 li.r01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/tab_round01.png);}
.todayItem .tabNav1_1 li.r02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/tab_round02.png);}
.todayItem .tabNav1_1 li.current {background-position:0 100% !important;}
.todayItem .tabNav1_1 li .finish {display:inline-block; position:absolute; right:3%; top:0; width:22%;}
.limit {color:#fff; font-weight:bold;}
.enterPrice {padding:13px 0 22px;}
.enterPrice .write {display:inline-block; width:65%; height:44px; font-size:15px; color:#333; font-weight:bold; margin-right:2px; text-align:right; border:2.5px solid #5613a0; vertical-align:top; box-shadow:1px 1px 1px 0 #b66de8;}
.enterPrice .btnViewResult {display:inline-block; width:79px; vertical-align:top;}
.priceHistory {position:relative; overflow:hidden;}
.priceHistory:after {content:' '; display:inline-block; position:absolute; left:49.5%; top:0; width:1px; height:100%; background:#ab58e2;}
.priceHistory div {width:50%; padding:14px 0; font-size:14px; font-weight:600; color:#fff; text-align:center; background:#7622b7;}
.priceHistory div:first-child {float:left;}
.priceHistory div:last-child {float:right;}
.priceHistory p {position:relative; height:23px; font-size:16px; line-height:1; padding-top:5px; color:#ffe567; font-weight:bold;}
.priceHistory p:after {content:' '; display:inline-block; position:absolute; left:50%; top:50%; width:6px; height:1.5px; margin:0 0 0 -3px; background:#ffe567; z-index:10;}
.priceHistory p span {position:relative; background:#7622b7; z-index:20;}
.viewRound {padding:20px 0 30px; text-align:center;}
.viewRound a {display:inline-block; width:35%; margin:0 4px;}
.evtNoti {padding:25px 24px 0; text-align:left;}
.evtNoti h3 strong {display:inline-block; font-size:13px; padding:6px 12px 4px; color:#8645c3; border:2px solid #8645c3; border-radius:15px;}
.evtNoti ul {padding:15px 0 0 3px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.3; padding:0 0 3px 14px; color:#444;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2.5px; width:2px; height:2px; border:2px solid #8645c3; border-radius:50%;}
::-webkit-input-placeholder {text-align:center; color:#999; font-weight:normal;}
:-moz-placeholder {text-align:center; color:#999; font-weight:normal;}
::-moz-placeholder {text-align:center; color:#999; font-weight:normal;}
:-ms-input-placeholder {text-align:center; color:#999; font-weight:normal;}

/* layer popup */
.priceKingLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:80px; background:rgba(0,0,0,.65); z-index:50;}
.priceKingLayer .priceLyrCont {position:relative; margin:0 auto;}
.priceKingLayer .btnClose {cursor:pointer;}
#resultLayer .priceLyrCont {position:relative; width:78%;}
#resultLayer .priceLyrCont p {position:absolute;}
#resultLayer .priceLyrCont .price {left:0; top:42%; width:100%;}
#resultLayer .priceLyrCont .price strong {display:inline-block; padding:0 15px; font-size:30px; color:#d50c0c; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/blt_left.png),url(http://webimage.10x10.co.kr/eventIMG/2015/64636/blt_right.png); background-size:9px 23px; background-repeat:no-repeat; background-position:0 20%, 100% 20%;}
#resultLayer .priceLyrCont .msg {left:0; top:54%; width:100%; font-size:14px; line-height:1.3; color:#555; font-weight:600;}
#resultLayer .priceLyrCont .btnClose {right:11%; top:4%; width:15%;}
#resultLayer .priceLyrCont .btnConfirm {position:absolute; width:34%; left:50%; bottom:18%; margin-left:-17%;}
.viewAnother h3 {position:relative; width:92%; margin:0 auto;}
.viewAnother .priceLyrCont {position:relative; width:92%; padding:15px 0 30px; background-color:#fff; background-size:5px 4px; background-repeat:repeat-x; background-position:0 0, 0 100%;}
.viewAnother .btnClose {position:absolute; right:0; top:5px; width:12%;}
.viewAnother .date {padding-bottom:18px;}
#nextPdtLayer .priceLyrCont {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_dash02.gif),url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_dash02.gif);}
#prevPdtLayer .priceLyrCont {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_dash01.gif),url(http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_dash01.gif);}
#prevPdtLayer .winner {overflow:hidden; width:82%; margin:0 auto; padding-top:25px;}
#prevPdtLayer .winner p {position:relative; width:46%;}
#prevPdtLayer .winner p:first-child {float:left;}
#prevPdtLayer .winner p:last-child {float:right;}
#prevPdtLayer .winner p span {display:inline-block; position:absolute; left:0; bottom:10.5%; width:100%; font-size:13px; color:#b5a7c2; font-weight:600;}
#prevPdtLayer .winner em {display:inline-block; position:absolute; left:0; top:-18px; width:100%; font-size:13px; color:#d50c0c;}
@media all and (min-width:480px){
	.priceKing {padding-top:23px;}
	.priceKing .itemCont {padding:0 12.5% 53px; margin-bottom:23px;}
	.todayItem .pic {padding-bottom:20px;}
	.todayItem .time span {font-size:60px; padding-left:60px; line-height:50px; background-size:50px auto;}
	.todayItem .king {font-size:20px;}
	.todayItem .king .t01 strong {padding-right:3px; font-size:39px;}
	.todayItem .king .t02 {padding-top:11px;}
	.todayItem .king .t02 strong {padding:0 3px;}
	.enterPrice {padding:20px 0 33px;}
	.enterPrice .write {height:66px; font-size:23px; margin-right:3px; border:3px solid #5613a0;}
	.enterPrice .btnViewResult {width:118px;}
	.priceHistory div {padding:21px 0; font-size:21px;}
	.priceHistory p {height:35px; font-size:24px; padding-top:7px;}
	.priceHistory p:after {width:9px; height:2px; margin:0 0 0 -4px;}
	.viewRound {padding:30px 0 45px;}
	.viewRound a {margin:0 6px;}
	.evtNoti {padding:38px 36px 0;}
	.evtNoti h3 strong {font-size:20px; padding:9px 18px 6px; border:3px solid #8645c3; border-radius:23px;}
	.evtNoti ul {padding:23px 0 0 4px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 21px;}
	.evtNoti li:after {top:3px; width:3px; height:3px; border:3px solid #8645c3;}
	/* layer popup */
	#resultLayer .priceLyrCont .price strong {padding:0 23px; font-size:45px; background-size:14px 35px;}
	#resultLayer .priceLyrCont .msg {font-size:21px;}
	.viewAnother .priceLyrCont {padding:23px 0 45px; background-size:7px 6px;}
	.viewAnother .btnClose {top:7px;}
	.viewAnother .date {padding-bottom:27px;}
	#prevPdtLayer .winner {padding-top:38px;}
	#prevPdtLayer .winner p span {font-size:20px;}
	#prevPdtLayer .winner em {top:-27px; font-size:20px;}
}
</style>
<script type="text/javascript">
function setComma(str) {
	var retValue = "";
	for(i=0;i<str.length;i++)
	{
		if(i>0 && (i%3)==0) {
			retValue = str.charAt(str.length -i -1)+","+retValue;
		}
		else {
			retValue = str.charAt(str.length -i -1)+retValue;
		}
	}

	return retValue;
}

function chktime(){
	
	<% if date()>="2015-07-18" and date()<="2015-07-19" then %>
		alert('20일 오전 10시! 기적이 찾아갑니다.');
		return false;
	<% end if %>

	<% if now()< tSdate(0) then %>
		alert('오전 10시! 기적이 찾아갑니다.');
		return false;
	<% end if%>

	<% if now()> tedate(1) then %>
		alert('금일 이벤트가 종료되었습니다.\n내일 다시 도전 해주세요!');
		return false;
	<% end if%>
}

function checkform() {
<% if datediff("d",date(),"2015-07-22")>=0 then %>
	<% if date()>="2015-07-18" and date()<="2015-07-19" then %>
		alert('20일 오전 10시! 기적이 찾아갑니다.');
		return false;
	<% end if %>
	<% if now()< tSdate(0) then %>
		alert('오전 10시! 기적이 찾아갑니다.');
		return false;
	<% end if%>
	<% if now()> tedate(1) then %>
		alert('금일 이벤트가 종료되었습니다.\n내일 다시 도전 해주세요!');
		return false;
	<% end if%>
	<% If IsUserLoginOK Then %>
		<% if cnt > 2 then %>
		alert('상품당 2회까지만 가격입력이 가능합니다.');
		<% else %>
			if (document.frm.userprice.value=="")
			{
				alert("상품가격을 입력해주세요.");
				document.frm.userprice.focus();
				return;
			}
			else
			{
				var result;
				$.ajax({
					type:"GET",
					url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript64636.asp",
					data: $("#frm").serialize(),
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data){
						result = jQuery.parseJSON(Data);

						if (result.stcode=="77")
						{
							alert("이벤트에 응모를 하려면 로그인이 필요합니다.");
							return;
						}
						else if (result.stcode=="55")
						{
							alert("잘못된 접근입니다.");
							return;
						}
						else if (result.stcode=="99")
						{
							alert("존재하지 않는 이벤트 입니다.");
							return;
						}
						else if (result.stcode=="88")
						{
							alert("죄송합니다. 이벤트 기간이 아닙니다.");
							return;
						}
						else if (result.stcode=="888")
						{
							alert("금일 이벤트가 종료되었습니다.\n내일 다시 도전 해주세요!");
							return;
						}
						else if (result.stcode=="44")
						{
							alert("가격 입력 시간이 지났습니다.");
							return;
						}
						else if (result.stcode=="33")
						{
							alert("기존에 한번 입력한 가격과 동일한 가격은 입력하실 수 없습니다.");
							return;
						}
						else if (result.stcode=="22")
						{
							alert("상품당 2회까지만 가격입력이 가능합니다.");
							return;
						}
						else if (result.stcode=="11")
						{
							alert("상품금액을 10원 단위로 입력해주세요.");
							return;
						}
						else if (result.stcode=="66")
						{
							alert("상품가격은 최저가 범위 내 금액으로 입력해주세요.");
							return;
						}
						else if (result.stcode=="999")
						{
							alert("다시 도전하고 싶을땐, 친구찬스!\n친구에게 최저가왕을 알려주고, 응모기회 한 번 더 받으세요!");
							return;
						}
						else if (result.stcode=="00")
						{
							if (result.userpriceCnt=="1")
							{
								document.getElementById("userPriceValue1").innerHTML=setComma(result.userprice);
							}
							else if (result.userpriceCnt=="2")
							{
								document.getElementById("userPriceValue2").innerHTML=setComma(result.userprice);
							}
							document.getElementById("userprice").value="";

							if (result.samepricecnt > 1)
							{
									document.getElementById("chgPriceUser").innerHTML=setComma(result.userprice)+" 원";
									document.getElementById("sameUserCnt").innerHTML="현재 "+ (result.samepricecnt-1) +"명의 동일한<br />최저가가 있습니다 "
									$('#resultLayer,#samePriceDiv').show();
									$('html,body').animate({scrollTop:0}, 800);
									return false;
							}
							else
							{
									document.getElementById("onlyPriceUser").innerHTML=setComma(result.userprice)+" 원";
									$('#resultLayer,#onlyPriceDiv').show();
									$('html,body').animate({scrollTop:0}, 800);
									return false;
							}
						}
					}
				});
			}
		<% end if %>
	<% Else %>
		alert('로그인 후에 응모하실 수 있습니다.');
		<% if isApp=1 then %>
			calllogin();
			return;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
			return;
		<% end if %>
	<% End If %>
<% else %>
		alert('이벤트가 종료되었습니다.');
		return;
<% end if %>
}

var yr = "<%=Year(vEdate)%>";
var mo = "<%=TwoNumber(Month(vEdate))%>";
var da = "<%=TwoNumber(Day(vEdate))%>";
var hh = "<%=TwoNumber(hour(vEdate))%>";
var mm = "<%=TwoNumber(minute(vEdate))%>";
var ss = "<%=TwoNumber(second(vEdate))%>";
var tmp_hh = "99";
var tmp_mm = "99";
var tmp_ss = "99";
var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		
		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";
		futurestring=montharray[mo-1]+" "+da+", "+yr+" "+hh+":"+mm+":"+ss;

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		if(dhour < 0)
		{
			$(".lyrCounter").hide();
			return;
		}

		if(dhour < 10) {
			dhour = "0" + dhour;
		}
		if(dmin < 10) {
			dmin = "0" + dmin;
		}
		if(dsec < 10) {
			dsec = "0" + dsec;
		}

		$("#lyrCounter").html(dhour +":"+ dmin +":"+ dsec);
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}

countdown();

</script>
<script>
$(function(){
	$('.btnViewPrev').click(function(){
		<% if date() <= "2015-07-13" then '첫날 (당첨자없음) %>
		alert('이전 당첨자가 없습니다.');
		return false;
		<% else %>
		$('#prevPdtLayer').show();
		window.$('html,body').animate({scrollTop:80}, 300);
		return false;
		<% end if %>
	});
	$('.btnViewNext').click(function(){
		<% if date() >= "2015-07-22" then '마지막날은 없음 %>
		alert('본 이벤트 금일 종료 됩니다.');
		return false;
		<% elseif date() >= "2015-07-13" and date() <= "2015-07-21" then %>
		$('#nextPdtLayer').show();
		window.$('html,body').animate({scrollTop:80}, 300);
		return false;
		<% end if %>
	});

	$('.btnClose,.btnConfirm').click(function(){
		$('.priceKingLayer').hide();
		$('#onlyPriceDiv').hide();
		$('#samePriceDiv').hide();
	});

	// tab
	$(".tabContent").hide();
<% if now() < tSdate(1) then %>
	$(".tabContainer").find(".tabContent:first").show();
	$("#userPriceValue1").text("<%=chkiif(userPrice11<>"",formatnumber(userPrice11,0),"")%>"); //'입찰가격 기본노출
	$("#userPriceValue2").text("<%=chkiif(userPrice12<>"",formatnumber(userPrice12,0),"")%>"); //'입찰가격 기본노출
	$(".tabNav1_1 li").click(function() {
		<% if date()>= "2015-07-18" and date()<= "2015-07-19" then %>
		alert('20일 오전 10시! 기적이 찾아갑니다.');
		return false;
		<% elseif now()< tSdate(0) then %>
		alert('오전 10시! 기적이 찾아갑니다.');
		return false;
		<% else %>
			$(this).siblings("li").removeClass("current");
			$(this).addClass("current");
			$(this).closest(".tabNav1_1").nextAll(".tabContainer:first").find(".tabContent").hide();
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).show();
			if ( $(this).attr("class") == "r01 current"){
				$("#userPriceValue1").text("<%=chkiif(userPrice11<>"",formatnumber(userPrice11,0),"")%>"); //'입찰가격 기본노출
				$("#userPriceValue2").text("<%=chkiif(userPrice12<>"",formatnumber(userPrice12,0),"")%>"); //'입찰가격 기본노출
			}else{
				$("#userPriceValue1").text("<%=chkiif(userPrice21<>"",formatnumber(userPrice21,0),"")%>"); //'입찰가격 기본노출
				$("#userPriceValue2").text("<%=chkiif(userPrice22<>"",formatnumber(userPrice22,0),"")%>"); //'입찰가격 기본노출
			}
			return false;
		<% end if %>
	});
<% else %>
	$(".tabContainer").find(".tabContent:last").show();
	$("#userPriceValue1").text("<%=chkiif(userPrice21<>"",formatnumber(userPrice21,0),"")%>"); //'입찰가격 기본노출
	$("#userPriceValue2").text("<%=chkiif(userPrice22<>"",formatnumber(userPrice22,0),"")%>"); //'입찰가격 기본노출
	$(".tabNav1_1 li").click(function() {
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".tabNav1_1").nextAll(".tabContainer:last").find(".tabContent").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		if ( $(this).attr("class") == "r01 current"){
			$("#userPriceValue1").text("<%=chkiif(userPrice11<>"",formatnumber(userPrice11,0),"")%>"); //'입찰가격 기본노출
			$("#userPriceValue2").text("<%=chkiif(userPrice12<>"",formatnumber(userPrice12,0),"")%>"); //'입찰가격 기본노출
		}else{
			$("#userPriceValue1").text("<%=chkiif(userPrice21<>"",formatnumber(userPrice21,0),"")%>"); //'입찰가격 기본노출
			$("#userPriceValue2").text("<%=chkiif(userPrice22<>"",formatnumber(userPrice22,0),"")%>"); //'입찰가격 기본노출
		}
		return false;
	});
<% end if %>
});

<%'카카오 친구 초대(재도전용)%>
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If (date() >="2015-07-13" and date() <="2015-07-17") or (date() >="2015-07-20" and date() <="2015-07-22") Then %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript64636.asp",
				data: "mode=kakao&eventid=<%=eCode%>&idx=<%=vidx%>",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.stcode=="11")
					{
						alert("최저가왕을 먼저 확인하고 친구에게 알려주세요!");
						return;
					}
					else if (result.stcode=="22")
					{
						parent_kakaolink('[텐바이텐] 최저가왕\n\n텐바이텐과 함께하는\n진짜 득템찬스 이벤트!\n\n최저가를 입력해보세요!\n유일한 최저가를 입력한\n당신에게 기적같은 선물이 찾아갑니다!\n\n지금 텐바이텐에서 도전하세요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/64636/kakaobanner.jpg' , '200' , '200' , '<%=kakaourl%>' );
						return false;
					}
					else if (result.stcode=="33")
					{
						alert("이번 라운드 친구 찬스를 모두 사용 하셨습니다.");
						return;
					}
					else if (result.stcode=="55")
					{
						alert("라운드 시작후 친구 찬스를 사용 하실 수 있습니다.");
						return;
					}
					else if (result.stcode=="888")
					{
						alert("금일 이벤트가 종료되었습니다.\n내일 다시 도전 해주세요!");
						return;
					}
					else if (result.stcode=="99")
					{
						alert("라운드 시작후 친구 찬스를 사용 하실 수 있습니다.");
						return;
					}
				}
			});
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		alert('로그인 후에 응모하실 수 있습니다.');
		<% if isApp=1 then %>
			calllogin();
			return;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
			return;
		<% end if %>
	<% End If %>
}
</script>
<form name="frm" id="frm" method="get" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="linkeventid" value="<%=linkeCode%>">
<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
<input type="hidden" name="idx" value="<%=vidx%>">
<input type="hidden" name="productcode" value="<%=vProductCode%>">
<input type="hidden" name="productname" value="<%=vProductName%>">
<input type="hidden" name="mode" value="insert">
<!-- 최저가왕 -->
<div class="mEvt64636">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/tit_price_king.gif" alt="이것이야말로 진짜 득템! 최저가왕 - 유일한 최저가를 입력한 당신에게 기적같은 선물이 찾아갑니다." /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_process.gif" alt="1.상품확인→2.최저가입력→3.결과확인" /></p>
	<div class="priceKing">
		<!-- 오늘의 상품 -->
		<div class="todayItem">
			<ul class="tabNav1_1">
				<li class="r01 <%=chkiif(now() < tSdate(1)," current","")%>">
					<% If now() > tEdate(0) then %>
					<em class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_finish.png" alt="종료" /></em>
					<% End If %>
					<a href="#round1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/tab_blank.png" alt="1라운드:오전10시~오후1시" /></a>
				</li>
				<li class="r02 <%=chkiif(now() > tSdate(1)," current","")%>">
					<% If now() > tEdate(1) then %>
					<em class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_finish.png" alt="종료" /></em>
					<% End If %>
					<a href="#round2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/tab_blank.png" alt="2라운드:오후2시~오후5시" /></a>
				</li>
			</ul>
			<div class="tabContainer">
				<div id="round1" class="tabContent">
					<div class="itemCont">
						<% If now() < tSdate(0) Then '//10시 이전 %>
						<div class="soon10am">
							<% If Date()>= "2015-07-18" And Date() <= "2015-07-19" Then '//주말 추가 %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_next_week.png" alt="다음주 월요일 오전 10시! 기적이 찾아갑니다." /></p>
							<% Else %>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_soon_10am.png" alt="오전 10시! 기적이 찾아갑니다." /></p>
							<% End If %>
						</div>
						<% End If %>
						<div class="pic">
							<% If Date() = "2015-07-13" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0713_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0713_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-14" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0714_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0714_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-15" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0715_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0715_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-16" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0716_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0716_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-17" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0717_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0717_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() >= "2015-07-18" And Date() <= "2015-07-20" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0720_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0720_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-21" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0721_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0721_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-22" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(0)<>"","fnAPPpopupProduct('"& Trim(tProductCode(0)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0722_01.jpg" alt="1라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(0)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(0))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0722_01.jpg" alt="1라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
						</div>
						<!-- 경우에 따라 노출(남은시간/준비중/최저가왕) -->
						<% If Now() >= tSdate(0) And Now() <= tEdate(0) Then %>
						<div class="time"><span id="lyrCounter"></span></div>
						<% Else %>
							<% If tWinnerPrice(0) <> "" And tWinneruserid(0) <> "" then %>
							<div class="king">
								<p class="t01"><strong><%=FormatNumber(tWinnerPrice(0),0)%></strong>원</p>
								<p class="t02">최저가왕! <strong>ID <%=printUserId(tWinneruserid(0),2,"*")%></strong></p>
							</div>
							<% Else %>
							<div class="soon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_soon.gif" alt="준비중입니다" /></div>
							<% End If %>
						<% End If %>
						<!--// 경우에 따라 노출 -->
					</div>
					<div class="limit">
						<% If Now() >= tSdate(0) And Now() <= tEdate(0) Then %>
						<p>최저가 범위: <span><%=FormatNumber(tAuctionMinPrice(0),0)%>원~<%=FormatNumber(tAuctionMaxPrice(0),0)%>원</span></p>
						<% Else %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_winner.png" alt="당첨자에게는 개별적으로 연락 드립니다" /></p>
						<% End If %>
					</div>
				</div>
				<div id="round2" class="tabContent">
					<div class="itemCont">
						<div class="pic">
							<% If Date() = "2015-07-13" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0713_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0713_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-14" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0714_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0714_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-15" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0715_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0715_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-16" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0716_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0716_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-17" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0717_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0717_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() >= "2015-07-18" And Date() <= "2015-07-20" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0720_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0720_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-21" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0721_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0721_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
							<% If Date() = "2015-07-22" then '//일자별 노출 이미지%>
								<% if isApp=1 then %>
								<a href="#" onclick="<%=chkiif(tProductCode(1)<>"","fnAPPpopupProduct('"& Trim(tProductCode(1)) &"');","")%>return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0722_02.jpg" alt="2라운드 상품이미지" /></a>
								<% Else %>
								<a href="<%=chkiif(tProductCode(1)<>"","/category/category_itemprd.asp?itemid="&Trim(tProductCode(1))&"","#")%>" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_item_0722_02.jpg" alt="2라운드 상품이미지" /></a>
								<% End If %>
							<% End If %>
						</div>
						<!-- 경우에 따라 노출(남은시간/준비중/최저가왕) -->
						<% If Now() >= tSdate(1) And Now() <= tEdate(1) Then %>
						<div class="time"><span id="lyrCounter"></span></div>
						<% Else %>
							<% If tWinnerPrice(1) <> "" And tWinneruserid(1) <> "" then %>
							<div class="king">
								<p class="t01"><strong><%=FormatNumber(tWinnerPrice(1),0)%></strong>원</p>
								<p class="t02">최저가왕! <strong>ID <%=printUserId(tWinneruserid(1),2,"*")%></strong></p>
							</div>
							<% Else %>
							<div class="soon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_soon.gif" alt="준비중입니다" /></div>
							<% End If %>
						<% End If %>
						<!--// 경우에 따라 노출 -->
					</div>
					<div class="limit">
						<% If Now() >= tSdate(1) And Now() <= tEdate(1) Then %>
						<p>최저가 범위: <span><%=FormatNumber(tAuctionMinPrice(1),0)%>원~<%=FormatNumber(tAuctionMaxPrice(1),0)%>원</span></p>
						<% Else %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_winner.png" alt="당첨자에게는 개별적으로 연락 드립니다" /></p>
						<% End If %>
					</div>
				</div>
			</div>
		</div>
		<!--// 오늘의 상품 -->

		<!-- 가격 입력 -->
		<div class="enterPrice">
			<input type="tel" name="userprice" id="userprice" maxlength="8" placeholder="10원 단위로 가격을 입력하세요" class="write" onclick="chktime();"/>
			<a href="" onclick="checkform();return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_submit.png" alt="입력" class="btnViewResult" /></a>
		</div>
		<div class="priceHistory">
			<div>1차 입력가<p><span id="userPriceValue1"></span></p></div>
			<div>2차 입력가<p><span id="userPriceValue2"></span></p></div>
		</div>
		<!--// 가격 입력 -->
		<div class="viewRound">
			<a href="#prevPdtLayer" class="btnViewPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_view_prev.png" alt="어제 당첨자 보기" /></a>
			<a href="#nextPdtLayer" class="btnViewNext">
				<% If Date()>="2015-07-17" And Date()<="2015-07-19" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_view_next02.png" alt="다음주 상품 보기" />
				<% Else %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_view_next.png" alt="내일의 상품 보기" />
				<% End If %>
			</a>
		</div>
	</div>
	<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_kakao.gif" alt="카카오톡으로 친구에게 최저가왕 알려주기" /></a></p>
	<div class="evtNoti">
		<h3><strong>이벤트 안내</strong></h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 모바일과 app에서만 참여 가능합니다.</li>
			<li>본 이벤트는 각 라운드별로 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
			<li>본 이벤트는 주말(토, 일)에는 진행되지 않습니다.</li>
			<li>당첨된 고객께는 개별적으로 연락을 드립니다.</li>
			<li>당첨 시 세무신고를 위해 개인정보를 요청 할 수 있습니다. 상품에 대한 제세공과금은 고객 부담입니다.</li>
		</ul>
	</div>

	<!-- 응모결과 레이어팝업 -->
	<div class="priceKingLayer" id="resultLayer">
		<div class="priceLyrCont">
			<p class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_close.png" alt="닫기" /></p>
			<!-- 유일가 일 경우 -->
			<div class="viewPrice" style="display:none;" id="onlyPriceDiv">
				<p class="price"><strong id="onlyPriceUser">0</strong></p>
				<p class="msg">현재까지 유일한 최저가입니다.<br />기대하세요!</p>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_result01.png" alt="" /></div>
			</div>
			<!--// 유일가 일 경우 -->

			<!-- 동일가 있을 경우 -->
			<div class="viewPrice" style="display:none;" id="samePriceDiv">
				<p class="price"><strong id="chgPriceUser">0</strong></p>
				<p class="msg" id="sameUserCnt"></p>
				<p class="btnConfirm"></p>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/bg_result02.png" alt="" /></div>
			</div>
			<!--// 동일가 있을 경우 -->
			<p class="btnConfirm"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_confirm.png" alt="확인" /></p>
		</div>
	</div>
	<!--// 응모결과 레이어팝업 -->

	<!-- 이전 라운드 레이어팝업 -->
	<div class="priceKingLayer viewAnother" id="prevPdtLayer">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/tit_prev.png" alt="어제 당첨자" /></h3>
		<div class="priceLyrCont">
			<p class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_close02.gif" alt="닫기" /></p>
		<% If Date()="2015-07-14" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0713.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0713.jpg" alt="" /></div>
		<% End If %>
		<% If Date()="2015-07-15" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0714.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0714.jpg" alt="" /></div>
		<% End If %>
		<% If Date()="2015-07-16" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0715.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0715.jpg" alt="" /></div>
		<% End If %>
		<% If Date()="2015-07-17" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0716.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0716.jpg" alt="" /></div>
		<% End If %>
		<% If Date()>="2015-07-18" And Date()<="2015-07-20" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0717.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0717.jpg" alt="" /></div>
		<% End If %>
		<% If Date()="2015-07-21" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0720.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0720.jpg" alt="" /></div>
		<% End If %>
		<% If Date()="2015-07-22" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0721.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0721.jpg" alt="" /></div>
		<% End If %>
			<div class="winner">
				<% If roundnum(0) = 1 then %>
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_layer_win01.gif" alt="1R 최저가왕" />
					<em><%=FormatNumber(tmpprice(0),0)%>원</em>
					<span><%=printUserId(tempwinid(0),2,"*")%></span>
				</p>
				<% End If %>
				<% If roundnum(1) = 2 then %>
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_layer_win02.gif" alt="2R 최저가왕" />
					<em><%=FormatNumber(tmpprice(1),0)%>원</em>
					<span><%=printUserId(tempwinid(1),2,"*")%></span>
				</p>
				<% End If %>
			</div>
		</div>
	</div>
	<!--// 이전 라운드 레이어팝업 -->

	<!-- 다음 라운드 레이어팝업 -->
	<div class="priceKingLayer viewAnother" id="nextPdtLayer">
		<h3>
			<% If Date()>="2015-07-17" And Date()<="2015-07-19" then%>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/tit_next02.png" alt="다음주 상품" />
			<% Else %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/tit_next.png" alt="내일의 상품" />
			<% End If %>
		</h3>
		<div class="priceLyrCont">
			<p class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/btn_close02.gif" alt="닫기" /></p>
			<% If Date()="2015-07-13" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0714.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0714.jpg" alt="" /></div>
			<% End If %>

			<% If Date()="2015-07-14" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0715.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0715.jpg" alt="" /></div>
			<% End If %>

			<% If Date()="2015-07-15" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0716.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0716.jpg" alt="" /></div>
			<% End If %>

			<% If Date()="2015-07-16" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0717.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0717.jpg" alt="" /></div>
			<% End If %>

			<% If Date()>="2015-07-17" And Date()<="2015-07-19" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0720.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0720.jpg" alt="" /></div>
			<% End If %>

			<% If Date()="2015-07-20" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0721.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0721.jpg" alt="" /></div>
			<% End If %>

			<% If Date()="2015-07-21" Then %>
			<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/txt_date_0722.gif" alt="닫기" /></p>
			<div class="item"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_layer_item_0722.jpg" alt="" /></div>
			<% End If %>
		</div>
	</div>
	<!--// 다음 라운드 레이어팝업 -->
</div>
</form>
<!--// 최저가왕 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->