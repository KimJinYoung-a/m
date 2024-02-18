<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%

'###########################################################
' Description : 10원의 기적!
' History : 2014.07.21 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21246"
		linkeCode = "21246"
	Else
		eCode 		= "53592"
		linkeCode = "53592"
	End If


Dim vIdx, vSdate, vEdate, vSviewdate, vEviewdate, vProductCode, vProductName, vProductBigImg, vPRoductSmallImg, vProductPrice, vAuctionMinPrice
Dim vAuctionMaxPrice, vWinnerPrice, vWinneruserid, vRegdate, vstatus, WinnerUserIdLength, vWinneruseridView, endtime, nowtime
Dim im_tmpuserPrice, tmpuserPrice, userPrice1, userPrice2, userPrice3

	'// 현재 일자, 시간에 맞는 상품값을 불러온다.(viewdate기준)
	sqlstr = " Select idx, sdate, edate, sviewdate, eviewdate, productCode, productName, productBigImg, productSmallImg, productPrice, auctionMinPrice, auctionMaxPrice, " &_
				" winnerPrice, winneruserid, regdate From db_temp.dbo.tbl_MiracleOf10Won " &_
				" Where getdate() >= sviewdate And  getdate() <= eviewdate "
	rsget.Open sqlStr,dbget,1

	If Not(rsget.bof Or rsget.eof) Then
		vIdx = rsget("idx")
		vSdate = rsget("sdate") '// 실제 경매 시작 일, 시간
		vEdate = rsget("edate") '// 실제 경매 종료 일, 시간
		vSviewdate = rsget("sviewdate") '// 페이지에 보여지는 시작 일, 시간
		vEviewdate = rsget("eviewdate") '// 페이지에 보여지는 종료 일, 시간
		vProductCode = rsget("productCode") '// 상품코드
		vProductName = rsget("productName") '// 상품명
		vProductBigImg = rsget("productBigImg") '// 상품 메인 이미지
		vPRoductSmallImg = rsget("productSmallImg") '// 상품 작은 이미지(기적의 상품보기 리스트에 들어가는 이미지)
		vProductPrice = rsget("productPrice") '// 상품 원래 가격
		vAuctionMinPrice = rsget("auctionMinPrice") '// 최저 경매가
		vAuctionMaxPrice = rsget("auctionMaxPrice") '// 최고 경매가
		vWinnerPrice = rsget("winnerPrice") '// 당첨됐다면 당첨된 금액
		vWinneruserid = rsget("winneruserid") '// 당첨됐다면 당첨된자 아이디
		vRegdate = rsget("regdate") '// 등록일
		vstatus = True '// 현재 활성화 여부
	Else
		vstatus = False
	End If
	rsget.Close


	'// 당첨된 유저 아이디는 끝에 2자리를 *표로 표시
	If vWinneruserid <> "" Then
		WinnerUserIdLength = Len(vWinneruserid)
		vWinneruseridView = Left(vWinneruserid, (WinnerUserIdLength-2))&"**"
	End If

	'// 종료시간 표시
	If vEdate <> "" Then
		endtime = GetTranTimer(vEdate)	'종료 시간
		nowtime = GetTranTimer(now())												'현재 시간
	End If


If IsUserLoginOK Then

	'// 해당 경매별 개인 응모횟수를 가져온다.
	 sqlstr = " Select count(sub_opt1) From db_event.dbo.tbl_event_subscript " &_
					" Where evt_code='"&eCode&"' And sub_opt1='"&vIdx&"' And userid='"&GetLoginUserID&"' "
	rsget.Open sqlStr,dbget,1
		cnt = rsget(0)
	rsget.close

	'// 해당 경매별 개인 작성금액 값을 가져온다.
	 sqlstr = " Select sub_opt2 From db_event.dbo.tbl_event_subscript " &_
					" Where evt_code='"&eCode&"' And sub_opt1='"&vIdx&"' And userid='"&GetLoginUserID()&"' order by regdate desc "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		Do Until rsget.eof
			tmpuserPrice = rsget("sub_opt2")&"|"&tmpuserPrice
		rsget.movenext
		Loop
	End If
	rsget.close

	'// 개인별 작성금액값 정렬
	If cnt >= 0 Then
		im_tmpuserPrice = Split(tmpuserPrice,"|")
		If cnt=1 Then
			userPrice1 = im_tmpuserPrice(0)
		End If
		If cnt=2 Then
			userPrice1 = im_tmpuserPrice(0)
			userPrice2 = im_tmpuserPrice(1)
		End If
		If cnt=3 Then
			userPrice1 = im_tmpuserPrice(0)
			userPrice2 = im_tmpuserPrice(1)
			userPrice3 = im_tmpuserPrice(2)
		End If
	End If
End If



'// 시간을 타이머용으로 변환
Function GetTranTimer(tt)
	if (tt="" or isNull(tt)) then Exit Function
	GetTranTimer = Num2Str(Year(tt),4,"0","R") & Num2Str(Month(tt),2,"0","R") & Num2Str(Day(tt),2,"0","R") &_
					Num2Str(Hour(tt),2,"0","R") & Num2Str(Minute(tt),2,"0","R") & Num2Str(Second(tt),2,"0","R")
end Function


'// 기적의 상품보기 리스트 호출 함수
Function GetProductInfo(vpd, gubun)
	Dim strsql, Rs, fProductPrice, fWinnerPrice, fWinneruserid, fWinnerUserIdLength, fWinneruseridView
	strsql = " Select idx, sdate, edate, sviewdate, eviewdate, productCode, productName, productBigImg, productSmallImg, productPrice, auctionMinPrice, auctionMaxPrice, " &_
				" winnerPrice, winneruserid, regdate From db_temp.dbo.tbl_MiracleOf10Won " &_
				" Where productCode='"&vpd&"' "
	rsget.Open strsql,dbget,1
		If Not(rsget.bof Or rsget.eof) Then

			fProductPrice = rsget("productPrice")
			fWinnerPrice = rsget("winnerPrice")
			fWinneruserid = rsget("winneruserid")
		Else
			fProductPrice = 0
			fWinnerPrice = 0
			fWinneruserid = 0
		End If
	rsget.close

	Select Case Trim(gubun)
		Case "op" '// 본래가격
			GetProductInfo = fProductPrice

		Case "sp" '// 당첨가격
			GetProductInfo = fWinnerPrice

		Case "ui" '// 당첨아이디
			If fWinneruserid <> "" Then
				fWinnerUserIdLength = Len(fWinneruserid)
				fWinneruseridView = Left(fWinneruserid, (fWinnerUserIdLength-2))&"**"
			End If
			GetProductInfo = fWinneruseridView

		Case "st" '// 당첨여부
			If fWinnerPrice <> "0" And fWinneruserid <> "0" Then
				GetProductInfo = True
			Else
				GetProductInfo = False
			End If
	End Select

End Function


%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 10원의 기적!</title>
<style type="text/css">
.mEvt53592 {position:relative; text-align:center;}
.mEvt53592 img {vertical-align:top; width:100%;}
.mEvt53592 p {max-width:100%;}
.mEvt53592 .miracle10won {background:#fff9e3;}
.mEvt53592 .miracle10won .onSale {width:92%; margin:0 auto; padding-bottom:25px; border:1px solid #ddd; border-radius:12px; background:#fff;}
.mEvt53592 .miracle10won .onSale .time {padding-top:12px; font-size:46px; line-height:46px; font-weight:bold;}
.mEvt53592 .miracle10won .limit {font-size:13px; font-weight:bold; color:#333; padding:14px 0 12px;}
.mEvt53592 .miracle10won .limit span {display:block; font-size:18px; padding-top:6px;}
.mEvt53592 .miracle10won .limit span em {font-size:20px; font-style:normal;}
.mEvt53592 .finalPrice {width:92%; margin:0 auto; font-weight:bold; padding-top:10px; border-bottom:1px dashed #fff;}
.mEvt53592 .finalPrice .t01 {font-size:17px; color:#333;}
.mEvt53592 .finalPrice .t01 strong {font-size:35px; color:#dc0610;}
.mEvt53592 .finalPrice .t02 {display:inline-block; border-bottom:1px solid #666; font-size:15px; padding-top:12px; margin-bottom:14px; color:#666;}
.mEvt53592 .finalPrice .t03 {font-size:13px; padding-bottom:18px; color:#888; border-bottom:1px dashed #e7d28b;}
.mEvt53592 .miracle10won .writePrice {overflow:hidden; width:92%; margin:0 auto;}
.mEvt53592 .miracle10won .writePrice .fl {position:relative; float:left; width:73%; z-index:0;}
.mEvt53592 .miracle10won .writePrice .fl input {display:block; position:absolute; left:5%; top:15%; width:90%; height:30px; color:#333; font-weight:bold; font-size:30px; text-align:right; vertical-align:middle; border:0; background:#fff; text-indent:0; z-index:100;}
.mEvt53592 .miracle10won .writePrice .fr {float:right; width:26%;}
.mEvt53592 .miracle10won .writePrice .fr input {width:100%; vertical-align:middle;}
.mEvt53592 .miracle10won .myPrice {position:relative; width:92%; margin:0 auto; padding-top:16px;}
.mEvt53592 .miracle10won .myPrice ol {overflow:hidden; position:absolute; left:0; bottom:10%; width:100%;}
.mEvt53592 .miracle10won .myPrice li {float:left; width:33.33333%; font-size:23px; font-weight:bold; color:#ff675f;}
.mEvt53592 .miracle10won .viewPdt {width:50%; margin:0 auto; padding-top:20px;}
.mEvt53592 .layerWrap {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.65);}
.mEvt53592 .mPdtList {display:none; position:relative; width:90%; margin:40px auto 0; border-radius:12px; padding-bottom:25px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_layer.png) left top repeat; background-size:24px 24px;}
.mEvt53592 .mPdtList .close {position:absolute; right:-20px; top:-15px; width:44px; height:44px;}
.mEvt53592 .mPdtList h4 {width:142px; margin:0 auto;}
.mEvt53592 .mPdtList .saleItem {position:relative; width:86%; margin:0 auto; padding:8px 12px 15px; border-radius:12px; background:#fff; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt53592 .mPdtList dl {position:relative; margin-top:20px;}
.mEvt53592 .mPdtList dl:after {content:" "; display:block; height:0; clear:both; visibility:hidden;}
.mEvt53592 .mPdtList dt {position:absolute; left:50%; top:0px; width:72px; margin:-14px 0 0 -36px; z-index:20;}
.mEvt53592 .mPdtList dd {position:relative; float:left; width:50%;margin:0;}
.mEvt53592 .mPdtList dd a {display:block; width:100%; height:100%; position:absolute; left:0; top:0; z-index:20;}
.mEvt53592 .mPdtList .winResult {overflow:hidden; position:absolute; left:0; bottom:0; width:100%; font-size:14px; line-height:18px;}
.mEvt53592 .mPdtList .winResult .winPrice {color:#999; font-size:14px; line-height:18px;}
.mEvt53592 .mPdtList .winResult .winPrice strong {color:#dc0610; padding-left:3px;}
.mEvt53592 .mPdtList .winResult .winner {color:#333; font-size:14px; line-height:18px;}
.mEvt53592 .mPdtList .winResult .winnerIs {position:absolute; left:0; bottom:15%; width:100%;}
.mEvt53592 .mPdtList .nowOn {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%;}
.mEvt53592 .myPriceLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.65);}
.mEvt53592 .myPriceLayer .mPriceonly {display:none; position:absolute; left:0; top:200px;}
.mEvt53592 .myPriceLayer .mPriceonly .close {position:absolute; left:50%; top:0px; width:44px; height:44px; margin-left:50px;}
.mEvt53592 .myPriceLayer .mPriceonly .status {position:absolute; left:0; top:45%; width:100%;}
.mEvt53592 .myPriceLayer .mPriceonly .status em {font-size:56px; color:#fff600; border-bottom:5px solid #fff600;}
.mEvt53592 .myPriceLayer .mPriceonly .status span img {display:inline-block; width:21px; padding:0 4px;}
.mEvt53592 .myPriceLayer .mPriceonly .status p {font-size:26px; margin-top:24px; color:#fff; font-weight:bold; line-height:36px;}

.mEvt53592 .myPriceLayer .mPricesame {display:none; position:absolute; left:0; top:200px;}
.mEvt53592 .myPriceLayer .mPricesame .close {position:absolute; left:50%; top:0px; width:44px; height:44px; margin-left:50px;}
.mEvt53592 .myPriceLayer .mPricesame .status {position:absolute; left:0; top:45%; width:100%;}
.mEvt53592 .myPriceLayer .mPricesame .status em {font-size:56px; color:#fff600; border-bottom:5px solid #fff600;}
.mEvt53592 .myPriceLayer .mPricesame .status span img {display:inline-block; width:21px; padding:0 4px;}
.mEvt53592 .myPriceLayer .mPricesame .status p {font-size:26px; margin-top:24px; color:#fff; font-weight:bold; line-height:36px;}

@media all and (max-width:480px){
	.mEvt53592 .finalPrice .t01 {font-size:15px;}
	.mEvt53592 .finalPrice .t01 strong {font-size:33px;}
	.mEvt53592 .finalPrice .t02 {font-size:13px; padding-top:8px;}
	.mEvt53592 .finalPrice .t03 {font-size:11px; padding-bottom:14px;}
	.mEvt53592 .miracle10won .writePrice .fl input {font-size:22px;}
	.mEvt53592 .miracle10won .myPrice ol {bottom:14%;}
	.mEvt53592 .miracle10won .myPrice li {font-size:16px;}
	.mEvt53592 .mPdtList .close {right:-12px; top:-12px; width:34px; height:34px;}
	.mEvt53592 .mPdtList dt {width:52px; margin:-10px 0 0 -26px;}
	.mEvt53592 .mPdtList .winResult {font-size:9px; line-height:11px;}
	.mEvt53592 .mPdtList .winResult .winPrice {font-size:9px; line-height:11px;}
	.mEvt53592 .mPdtList .winResult .winner {font-size:9px; line-height:11px;}
	.mEvt53592 .myPriceLayer .mPriceonly .status em {font-size:46px;}
	.mEvt53592 .myPriceLayer .mPriceonly .status span img {width:11px; padding:0 2px;}
	.mEvt53592 .myPriceLayer .mPriceonly .status p {font-size:16px; margin-top:18px; line-height:20px;}

	.mEvt53592 .myPriceLayer .mPricesame .status em {font-size:46px;}
	.mEvt53592 .myPriceLayer .mPricesame .status span img {width:11px; padding:0 2px;}
	.mEvt53592 .myPriceLayer .mPricesame .status p {font-size:16px; margin-top:18px; line-height:20px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/tencommon.js?v=1.1"></script>
<script type="text/javascript" src="/lib/js/base64.js"></script>

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



function checkform() {
<% if datediff("d",date(),"2014-07-31")>=0 then %>
	<% If IsUserLoginOK Then %>
		<% if cnt > 3 then %>
		alert('상품당 3회까지만 가격입력이 가능합니다.');
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
					url:"doEventSubscript53592.asp",
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
							alert("상품당 3회까지만 가격입력이 가능합니다.");
							return;
						}
						else if (result.stcode=="11")
						{
							alert("상품금액을 10원 단위로 입력해주세요.");
							return;
						}
						else if (result.stcode=="66")
						{
							alert("상품가격은 기적의 범위 내 금액으로 입력해주세요.");
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
							else if (result.userpriceCnt=="3")
							{
								document.getElementById("userPriceValue3").innerHTML=setComma(result.userprice);
							}

							document.getElementById("userprice").value="";

							if (result.samepricecnt > 1)
							{
									document.getElementById("chgPriceUser").innerHTML=setComma(result.userprice)+" ";
									document.getElementById("sameUserCnt").innerHTML="현재 "+ (result.samepricecnt-1) +"명의<br />동일가가 있습니다 "
									$('.myPriceLayer,.mPricesame').show();
									window.parent.$('html,body').animate({scrollTop:200}, 800);
									return false;
							}
							else
							{
									document.getElementById("onlyPriceUser").innerHTML=setComma(result.userprice)+" ";
									$('.myPriceLayer,.mPriceonly').show();
									window.parent.$('html,body').animate({scrollTop:200}, 800);
									return false;
							}

						}
					}
				});
			}
		<% end if %>
	<% Else %>
		alert('로그인 후에 응모하실 수 있습니다.');
		calllogin();
		return;
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


$(function(){
	$('.viewPdt a').click(function(){
		$('.layerWrap,.mPdtList').show();
		window.parent.$('html,body').animate({scrollTop:20}, 800);
		return false;
	});
	$('.mPdtList .close').click(function(){
		$('.layerWrap,.mPdtList').hide();
		return false;
	});

	$('.mPriceonly .close').click(function(){
		$('.myPriceLayer,.mPriceonly').hide();
		return false;
	});
	$('.mPricesame .close').click(function(){
		$('.myPriceLayer,.mPricesame').hide();
		return false;
	});
	$('.mPdtList dd:first-child .winResult').append('<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_result_left.png" alt="" /></span>');
	$('.mPdtList dd .winResult').append('<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_result_right.png" alt="" /></span>');
	$('.mPdtList dd.currentA').append('<span class="nowOn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_today_left.png" alt="" /></span>');
	$('.mPdtList dd.currentB').append('<span class="nowOn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_today_right.png" alt="" /></span>');
});

countdown();

</script>
</head>
<body>
<form name="frm" id="frm" method="get" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="linkeventid" value="<%=linkeCode%>">
<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
<input type="hidden" name="idx" value="<%=vidx%>">
<input type="hidden" name="productcode" value="<%=vProductCode%>">
<input type="hidden" name="productname" value="<%=vProductName%>">

	<!-- 10원의 기적(M) -->
	<div class="mEvt53592">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/tit_10won_miracle.png" alt="10원의 기적 - 매일 2번씩 찾아오는 10원의 기적! 입력한 가격이 상품의 유일한 최저가가 되면 기적이 일어납니다!" /></h3>

	<% If vstatus Then %>
		<!-- 이벤트 응모 -->
		<div class="miracle10won">
			<div class="onSale">
				<p><img src="<%=vProductBigImg%>" alt="" /></p>
				<% '// 실제 경매 시작, 종료시간 기준으로 시간이 완료되면 타이머 숨김 %>
				<% If Now() >= vSdate And Now() <= vEdate Then %>
					<p class="time" id="lyrCounter"></p>
				<% End If %>
			</div>

		<% '// 최종 당첨자 가격과 당첨자 아이디를 입력하면 표시 아니면 입력폼 표시 %>
		<% If vWinnerPrice <> "" And vWinneruserid <> "" Then %>
			<!-- 기적의 가격(이벤트 마감 후) -->
			<div class="finalPrice">
				<p class="t01">기적의 가격 : <strong><%=FormatNumber(vWinnerPrice, 0)%></strong>원</p>
				<p class="t02">ID : <%=vWinneruseridView%></p>
				<p class="t03">당첨자에게는 개별적으로 연락드립니다.</p>
			</div>
			<!--// 기적의 가격 -->
			<div class="myPrice">
				<ol>
					<li><span id="userPriceValue1"><% If userPrice1<>"" Then  response.write FormatNumber(userPrice1, 0) Else response.write "-" End If %></span></li>
					<li><span id="userPriceValue2"><% If userPrice2<>"" Then  response.write FormatNumber(userPrice2, 0) Else response.write "-" End If %></span></li>
					<li><span id="userPriceValue3"><% If userPrice3<>"" Then  response.write FormatNumber(userPrice3, 0) Else response.write "-" End If %></span></li>
				</ol>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_my_price.png" alt="" /></span>
			</div>
		<% Else %>
			<div class="limit">
				기적의 범위 <span><em><%=FormatNumber(vAuctionMinPrice, 0)%></em> 원 ~ <em><%=FormatNumber(vAuctionMaxPrice, 0)%></em> 원</span>
			</div>
			<% '// 실제 경매 시작, 종료시간 기준으로 시간이 완료되면 입력부 숨김 %>
			<% If Now() >= vSdate And Now() <= vEdate Then %>
				<!-- 가격 입력 -->
				<div class="writePrice">
					<p class="fl"><input type="tel" name="userprice" id="userprice" maxlength="8"/><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_input_price.png" alt="" /></p>
					<p class="fr"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/53592/btn_submit.png" alt="입력" class="submitB" onclick="checkform();return false;" /></p>
				</div>
			<% End If %>
			<div class="myPrice">
				<ol>
					<li><span id="userPriceValue1"><% If userPrice1<>"" Then  response.write FormatNumber(userPrice1, 0) Else response.write "-" End If %></span></li>
					<li><span id="userPriceValue2"><% If userPrice2<>"" Then  response.write FormatNumber(userPrice2, 0) Else response.write "-" End If %></span></li>
					<li><span id="userPriceValue3"><% If userPrice3<>"" Then  response.write FormatNumber(userPrice3, 0) Else response.write "-" End If %></span></li>
				</ol>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_my_price.png" alt="" /></span>
			</div>
			<!--// 가격 입력 -->
		<% End If %>
			<p class="viewPdt"><a href="#"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/btn_view_product.png" alt="기적의 상품보기" /></a></p>
		</div>
		<!--// 이벤트 응모 -->
	<% End If %>
		<!-- 레이어 팝업 (기적의 상품 보기) -->
		<div class="layerWrap">
			<div class="mPdtList">
				<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/btn_layer_close01.png" alt="닫기" /></span>
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/tit_product.png" alt="기적의 상품" /></h4>
				<div class="saleItem">
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0723.png" alt="7월 23일" /></dt>
						<dd <% If vProductCode="1062995" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0723_01.png" alt="7월 23일" /></p>
							<% If GetProductInfo("1062995", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("1062995", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1062995", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("1062995", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1062995" target="_top"></a>
						</dd>
						<dd <% If vProductCode="1046025" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0723_02.png" alt="7월 23일" /></p>
							<% If GetProductInfo("1046025", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("1046025", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1046025", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("1046025", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1046025" target="_top"></a>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0724.png" alt="7월 24일" /></dt>
						<dd <% If vProductCode="884073" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0724_01.png" alt="7월 24일" /></p>
							<% If GetProductInfo("884073", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("884073", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("884073", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("884073", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=884073" target="_top"></a>
						</dd>
						<dd <% If vProductCode="962111" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0724_02.png" alt="7월 24일" /></p>
							<% If GetProductInfo("962111", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("962111", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("962111", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("962111", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=962111" target="_top"></a>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0725.png" alt="7월 25일" /></dt>
						<%' 현재 진행중인 상품 : 오전일경우 클래스 currentA, 오후일 경우 currentB 넣어주세요 %>
						<dd <% If vProductCode="963413" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0725_01n.png" alt="7월 25일" /></p>
							<% If GetProductInfo("963413", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("963413", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("963413", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("963413", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=963413" target="_top"></a>
						</dd>
						<dd <% If vProductCode="120420" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0725_02.png" alt="7월 25일" /></p>
							<% If GetProductInfo("120420", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("120420", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("120420", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("120420", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=120420" target="_top"></a>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0728.png" alt="7월 28일" /></dt>
						<dd <% If vProductCode="621748" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0728_01.png" alt="7월 28일" /></p>
							<% If GetProductInfo("621748", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("621748", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("621748", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("621748", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=621748" target="_top"></a>
						</dd>
						<dd <% If vProductCode="1046028" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0728_02n.png" alt="7월 28일" /></p>
							<% If GetProductInfo("1046028", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("1046028", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1046028", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("1046028", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1046028" target="_top"></a>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0729.png" alt="7월 29일" /></dt>
						<dd <% If vProductCode="1062997" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0729_01.png" alt="7월 29일" /></p>
							<% If GetProductInfo("1062997", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("1062997", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1062997", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("1062997", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1062997" target="_top"></a>
						</dd>
						<dd <% If vProductCode="1095345" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0729_02.png" alt="7월 29일" /></p>
							<% If GetProductInfo("1095345", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("1095345", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1095345", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("1095345", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1095345" target="_top"></a>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0730.png" alt="7월 30일" /></dt>
						<dd <% If vProductCode="1090245" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0730_01.png" alt="7월 30일" /></p>
							<% If GetProductInfo("1090245", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("1090245", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1090245", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("1090245", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1090245" target="_top"></a>
						</dd>
						<dd <% If vProductCode="957974" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0730_02.png" alt="7월 30일" /></p>
							<% If GetProductInfo("957974", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("957974", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("957974", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("957974", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=957974" target="_top"></a>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_date0731.png" alt="7월 31일" /></dt>
						<dd <% If vProductCode="894718" Then %>class="currentA"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0731_01n.png" alt="7월 31일" /></p>
							<% If GetProductInfo("894718", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("894718", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("894718", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("894718", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=894718" target="_top"></a>
						</dd>
						<dd <% If vProductCode="661461" Then %>class="currentB"<% End If %>>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_product_0731_02.png" alt="7월 31일" /></p>
							<% If GetProductInfo("661461", "st") Then %>
								<div class="winResult">
									<div class="winnerIs">
										<p class="winPrice"><%=FormatNumber(GetProductInfo("661461", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("661461", "sp"), 0)%></strong></p>
										<p class="winner"><%=GetProductInfo("661461", "ui")%></p>
									</div>
								</div>
							<% End If %>
							<a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=661461" target="_top"></a>
						</dd>
					</dl>
				</div>
			</div>
		</div>
		<!--// 레이어 팝업 (기적의 상품 보기) -->

		<!-- 레이어 팝업 (응모 결과) -->
		<div class="myPriceLayer">
			<!-- 현재까지 유일가 -->
			<div class="mPriceonly" id="onlyPriceDiv">
				<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/btn_layer_close02.png" alt="닫기" /></span>
				<div class="status">
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/blt_mark01.png" alt="따옴표" /><em><span id="onlyPriceUser">0</span></em><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/blt_mark02.png" alt="따옴표" /></span>
					<p>현재까지 유일가입니다<br />기대하세요!</p>
				</div>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_layer_price.png" alt="" /></span>
			</div>
			<!--// 현재까지 유일가 -->

			<!-- 동일가 있을 경우 -->
			<div class="mPricesame" id="samePriceDiv">
				<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/btn_layer_close03.png" alt="닫기" /></span>
				<div class="status">
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/blt_mark01.png" alt="따옴표" /><em><span id="chgPriceUser">0</span></em><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/blt_mark02.png" alt="따옴표" /></span>
					<p><span id="sameUserCnt"></span></p>
				</div>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/bg_layer_price02.png" alt="" /></span>
			</div>
			<!--// 동일가 있을 경우 -->
		</div>
		<!--// 레이어 팝업 (응모 결과) -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_process.png" alt="10원의 기적 참여방법" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/txt_notice.png" alt="이벤트 유의사항" /></p>
	</div>
	<!-- //10원의 기적(M) -->

</form>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->