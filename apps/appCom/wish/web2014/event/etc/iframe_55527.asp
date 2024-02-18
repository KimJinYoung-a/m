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
' History : 2014.10.16 이종화 
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21344"
		linkeCode = "21344"
	Else
		eCode 		= "55527"
		linkeCode = "55527"
	End If


Dim vIdx, vSdate, vEdate, vSviewdate, vEviewdate, vProductCode, vProductName, vProductBigImg, vPRoductSmallImg, vProductPrice, vAuctionMinPrice
Dim vAuctionMaxPrice, vWinnerPrice, vWinneruserid, vRegdate, vstatus, WinnerUserIdLength, vWinneruseridView, endtime, nowtime
Dim im_tmpuserPrice, tmpuserPrice, userPrice1, userPrice2, userPrice3

	'// 현재 일자, 시간에 맞는 상품값을 불러온다.(viewdate기준)
	sqlstr = " Select idx, sdate, edate, sviewdate, eviewdate, productCode, productName, productBigImg, productSmallImg, productPrice, auctionMinPrice, auctionMaxPrice, " &_
				" winnerPrice, winneruserid, regdate From db_temp.dbo.tbl_MiracleOf10Won " &_
				" Where getdate() >= sviewdate And  getdate() <= eviewdate and isusing = 'Y' "
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
		nowtime = GetTranTimer(now())	'현재 시간
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
				" Where productCode='"&vpd&"' and isusing = 'Y' "
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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
.mEvt55527 {position:relative; text-align:center; background:#fff;}
.mEvt55527 img {vertical-align:top; width:100%;}
.mEvt55527 p {max-width:100%;}
.mEvt55527 .miracle10won {background:url(http://webimage.10x10.co.kr/eventIMG/2014/55527/bg_product.png) left top no-repeat #fff9e3; background-size:100% auto;}
.mEvt55527 .miracle10won .onSale {width:92%; margin:0 auto; padding-bottom:15px; border:1px solid #ddd; border-radius:12px; background:#fff;}
.mEvt55527 .miracle10won .onSale .time {padding-top:12px; font-size:46px; line-height:46px; font-weight:bold;}
.mEvt55527 .miracle10won .onSale img {border-radius:12px;}
.mEvt55527 .miracle10won .limit {font-size:13px; font-weight:bold; color:#333; padding:14px 0 12px;}
.mEvt55527 .miracle10won .limit span {display:block; font-size:18px; padding-top:6px;}
.mEvt55527 .miracle10won .limit span em {font-size:20px;}
.mEvt55527 .miracle10won .writePrice {overflow:hidden; width:92%; margin:0 auto;}
.mEvt55527 .miracle10won .writePrice .fl {position:relative; float:left; width:73%;}
.mEvt55527 .miracle10won .writePrice .fl input {display:inline-block; position:absolute; left:50%; top:18%; width:94%; height:70%; color:#333; font-weight:bold; font-size:24px; text-align:right; line-height:1; margin:0 0 0 -47%; vertical-align:middle; border:0;}
.mEvt55527 .miracle10won .writePrice .fl input::-webkit-input-placeholder {position:relative; top:5px; font-size:14px; font-weight:normal; color:#bbb;}
.mEvt55527 .miracle10won .writePrice .fl input::-moz-placeholder {position:relative; top:5px; font-size:14px; font-weight:normal; color:#bbb;}
.mEvt55527 .miracle10won .writePrice .fl input:-moz-placeholder {position:relative; top:5px; font-size:14px; font-weight:normal; color:#bbb;}
.mEvt55527 .miracle10won .writePrice .fl input:-ms-input-placeholder {position:relative; top:5px; font-size:14px; font-weight:normal; color:#bbb;}
.mEvt55527 .miracle10won .writePrice .fr {float:right; width:26%;}
.mEvt55527 .miracle10won .writePrice .fr input {width:100%; vertical-align:middle;}
.mEvt55527 .miracle10won .myPrice {position:relative; width:92%; margin:0 auto; padding-top:16px;}
.mEvt55527 .miracle10won .myPrice ol {overflow:hidden; position:absolute; left:0; bottom:13%; width:100%;}
.mEvt55527 .miracle10won .myPrice li {float:left; width:33.33333%; font-size:14px; font-weight:bold; color:#ff675f;}
.mEvt55527 .miracle10won .viewPdt {width:72%; margin:0 auto; padding-top:20px;}
.mEvt55527 .finalPrice {width:92%; margin:0 auto; font-weight:bold; padding-top:10px; border-bottom:1px dashed #fff;}
.mEvt55527 .finalPrice .t01 {font-size:17px; color:#333;}
.mEvt55527 .finalPrice .t01 strong {font-size:35px; color:#dc0610;}
.mEvt55527 .finalPrice .t02 {display:inline-block; border-bottom:1px solid #666; font-size:15px; padding-top:12px; margin-bottom:14px; color:#666;}
.mEvt55527 .finalPrice .t03 {font-size:13px; padding-bottom:18px; color:#888; border-bottom:1px dashed #e7d28b;}

.mEvt55527 .layerWrap {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.65); z-index:20;}
.mEvt55527 .mPdtList {position:relative; margin-top:20%; padding:0 4% 5%; background:#ff9600; border-radius:10px;}
.mEvt55527 .mPdtList .close {position:absolute; right:2%; top:1.2%; width:10%;  cursor:pointer;}
.mEvt55527 .mPdtList .saleItem {padding:6% 4%; border-radius:10px; background:#fff;}
.mEvt55527 .mPdtList .saleItem dl {position:relative; border:1px solid #ddd; border-radius:10px; margin-bottom:8%;}
.mEvt55527 .mPdtList .saleItem dl:last-child {margin-bottom:0;}
.mEvt55527 .mPdtList .saleItem dl img {border-radius:10px;}
.mEvt55527 .mPdtList .saleItem dl:before {content:" "; display:inline-block; position:absolute; left:50%; top:0; width:1px; height:100%; margin-left:-1px; border-right:1px solid #ddd; z-index:40;}
.mEvt55527 .mPdtList .saleItem dl:after {content:" "; display:block; clear:both;}
.mEvt55527 .mPdtList .saleItem dt {position:absolute; left:50%; top:-6.5%; width:14%; margin-left:-7%; z-index:50;}
.mEvt55527 .mPdtList .saleItem dd {position:relative; float:left; width:50%;}
.mEvt55527 .mPdtList .saleItem dd.nowOn:after {content:" "; display:inline-block; position:absolute; right:-1px; top:0; width:101%; height:100%; border:4px solid #ff5f57; box-sizing:border-box; z-index:45;}
.mEvt55527 .mPdtList .saleItem dd:nth-child(even).nowOn:after {left:-1px; border-radius:10px 0 0 10px;}
.mEvt55527 .mPdtList .saleItem dd:nth-child(odd).nowOn:after {left:0px; border-radius:0 10px 10px 0;}
.mEvt55527 .mPdtList .saleItem dd .winResult {position:absolute; width:100%; height:35px; left:0; bottom:0; font-size:11px; padding-top:6px; text-align:center; background:rgba(69,255,214,.1);}
.mEvt55527 .mPdtList .saleItem dd:nth-child(even) .winResult {border-radius:0 0 0 10px;}
.mEvt55527 .mPdtList .saleItem dd:nth-child(odd) .winResult {border-radius:0 0 10px 0;}
.mEvt55527 .mPdtList .saleItem dd .winResult .winnerIs {color:#999; line-height:1.1;}
.mEvt55527 .mPdtList .saleItem dd .winResult .winPrice strong {color:#dc0610;}
.mEvt55527 .mPdtList .saleItem dd .winResult .winner {color:#333;}
.mEvt55527 .mPdtList .saleItem dd a {display:inline-block; width:100%; height:100%; position:absolute; left:0; top:0; z-index:40; text-indent:-9999em; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55526/bg_blank.png) left top repeat; background-size:100% 100%;}

.mEvt55527 .myPriceLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.65); z-index:1000;}
.mEvt55527 .myPriceLayer .mPrice {display:none; position:absolute; left:0; top:250px;}
.mEvt55527 .myPriceLayer .mPrice .close {position:absolute; left:50%; top:0px; width:44px; height:44px; margin-left:50px; cursor:pointer;}
.mEvt55527 .myPriceLayer .mPrice .status {position:absolute; left:0; top:38%; width:100%;  line-height:1.2;}
.mEvt55527 .myPriceLayer .mPrice .status em {font-size:46px; vertical-align:top; color:#fff600; border-bottom:5px solid #fff600;}
.mEvt55527 .myPriceLayer .mPrice .status span img {display:inline-block; width:16px; padding:0 4px;}
.mEvt55527 .myPriceLayer .mPrice .status p {font-size:16px; margin-top:18px; color:#fff; font-weight:bold;}

.mEvt55527 .evtNoti {padding:27px 14px; text-align:left;}
.mEvt55527 .evtNoti dt {padding-bottom:10px;}
.mEvt55527 .evtNoti dt img {width:84px;}
.mEvt55527 .evtNoti dd li {position:relative; padding-left:12px; font-size:11px; line-height:1.4; color:#333;}
.mEvt55527 .evtNoti dd li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:4px; background:#b4b4b4; border-radius:50%;}

@media all and (min-width:480px){
	.mEvt55527 .miracle10won .onSale {padding-bottom:23px;  border-radius:18px;}
	.mEvt55527 .miracle10won .onSale .time {padding-top:18px; font-size:69px; line-height:69px;}
	.mEvt55527 .miracle10won .onSale img {border-radius:18px;}

	.mEvt55527 .miracle10won .limit {font-size:13px; font-weight:bold; color:#333; padding:14px 0 12px;}
	.mEvt55527 .miracle10won .limit span {display:block; font-size:18px; padding-top:6px;}
	.mEvt55527 .miracle10won .limit span em {font-size:20px;}

	.mEvt55527 .mPdtList .saleItem {border-radius:15px;}
	.mEvt55527 .mPdtList .saleItem dd .winResult {font-size:17px; height:53px; padding-top:9px;}

	.mEvt55527 .miracle10won .myPrice {padding-top:24px;}
	.mEvt55527 .miracle10won .myPrice ol {bottom:16%;}
	.mEvt55527 .miracle10won .myPrice li {font-size:21px;}

	.mEvt55527 .myPriceLayer .mPrice .close {width:66px; height:66px; margin-left:75px;}
	.mEvt55527 .myPriceLayer .mPrice .status {top:38%;}
	.mEvt55527 .myPriceLayer .mPrice .status em {font-size:69px;}
	.mEvt55527 .myPriceLayer .mPrice .status span img {width:24px; padding:0 6px;}
	.mEvt55527 .myPriceLayer .mPrice .status p {font-size:24px; margin-top:27px;}

	.mEvt55527 .evtNoti dt {padding-bottom:15px;}
	.mEvt55527 .evtNoti dt img {width:125px;}
	.mEvt55527 .evtNoti dd li {padding-left:18px; font-size:17px;}
	.mEvt55527 .evtNoti dd li:after {top:6px; width:6px; height:6px;}

}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>

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
<% if datediff("d",date(),"2014-10-25")>=0 then %>
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
					url:"doEventSubscript55527.asp",
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
									$('.myPriceLayer,#samePriceDiv').show();
									window.parent.$('html,body').animate({scrollTop:200}, 800);
									return false;
							}
							else
							{
									document.getElementById("onlyPriceUser").innerHTML=setComma(result.userprice)+" ";
									$('.myPriceLayer,#onlyPriceDiv').show();
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

countdown();

</script>
<script>
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
	$('.mPrice .close').click(function(){
		$('.myPriceLayer,.mPrice').hide();
		return false;
	});
});
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
<div class="mEvt55527">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/tit_miracle_10won.png" alt="내가 전생에 나라를 구했나?! 10원의 기적" /></h2>
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
		<!-- 가격 입력 -->
		<div class="limit">
			기적의 범위 <span><em><%=FormatNumber(vAuctionMinPrice, 0)%></em> 원 ~ <em><%=FormatNumber(vAuctionMaxPrice, 0)%></em> 원</span>
		</div>
		<% '// 실제 경매 시작, 종료시간 기준으로 시간이 완료되면 입력부 숨김 %>
		<% If Now() >= vSdate And Now() <= vEdate Then %>
		<div class="writePrice">
			<p class="fl"><input type="tel" name="userprice" id="userprice" maxlength="8" placeholder="10원 단위로 가격을 입력하세요."/><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/bg_input_price.png" alt="" /></p>
			<p class="fr"><a href="" onclick="checkform();return false;"><img class="submitB" src="http://webimage.10x10.co.kr/eventIMG/2014/55527/btn_submit.png" alt="입력" /></a></p>
		</div>
		<% End If %>
		<!--// 가격 입력 -->
		<div class="myPrice">
			<ol>
				<li><span id="userPriceValue1"><% If userPrice1<>"" Then  response.write FormatNumber(userPrice1, 0) Else response.write "-" End If %></span></li>
				<li><span id="userPriceValue2"><% If userPrice2<>"" Then  response.write FormatNumber(userPrice2, 0) Else response.write "-" End If %></span></li>
				<li><span id="userPriceValue3"><% If userPrice3<>"" Then  response.write FormatNumber(userPrice3, 0) Else response.write "-" End If %></span></li>
			</ol>
			<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/53592/img_my_price.png" alt="" /></span>
		</div>
	<% End If %>
		<p class="viewPdt"><a href="#"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/btn_view_product.png" alt="기적의 상품보기" /></a></p>
	</div>
	<!--// 이벤트 응모 -->
	<% End If %>
	<!-- 레이어 팝업 (기적의 상품 보기) -->
	<div class="layerWrap">
		<div class="mPdtList">
			<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/btn_layer_close01.png" alt="닫기" /></span>
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/tit_product.png" alt="기적의 상품" /></h4>
			<div class="saleItem">
				<!-- 21일 -->
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1021.png" alt="10월 21일" /></dt>
					<dd <% If vProductCode="339040" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1021_01.png" alt="10월 21일 1차상품" /></p>
						<% If GetProductInfo("339040", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("339040", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("339040", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("339040", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('339040');return false;">비토 민트</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=339040" target="_top">비토 민트</a>
						<% End If %>
					</dd>
					<dd <% If vProductCode="1111966" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1021_02.png" alt="10월 21일 2차상품" /></p>
						<% If GetProductInfo("1111966", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("1111966", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1111966", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("1111966", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('1111966');return false;">모두시스 트윙글빔</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1111966" target="_top">모두시스 트윙글빔</a>
						<% End If %>
					</dd>
				</dl>
				<!--// 21일 -->

				<!-- 22일 -->
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1022.png" alt="10월 22일" /></dt>
					<dd <% If vProductCode="1112074" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1022_01.png" alt="10월 22일 1차상품" /></p>
						<% If GetProductInfo("1112074", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("1112074", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1112074", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("1112074", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('1112074');return false;">폴러스터프 2MAN TENT</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1112074" target="_top">폴러스터프 2MAN TENT</a>
						<% End If %>
					</dd>
					<dd <% If vProductCode="962111" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1022_02.png" alt="10월 22일 2차상품" /></p>
						<% If GetProductInfo("962111", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("962111", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("962111", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("962111", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('962111');return false;">라이카 C Dark red set</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=962111" target="_top">라이카 C Dark red set</a>
						<% End If %>
					</dd>
				</dl>
				<!--// 22일 -->

				<!-- 23일 -->
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1023.png" alt="10월 23일" /></dt>
					<dd <% If vProductCode="993520" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1023_01.png" alt="10월 23일 1차상품" /></p>
						<% If GetProductInfo("993520", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("993520", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("993520", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("993520", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('993520');return false;">하만카돈 블루투스 스피커</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=993520" target="_top">하만카돈 블루투스 스피커</a>
						<% End If %>
					</dd>
					<dd <% If vProductCode="1046023" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1023_02.png" alt="10월 23일 2차상품" /></p>
						<% If GetProductInfo("1046023", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("1046023", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("1046023", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("1046023", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('1046023');return false;">애플 맥북프로 레티나 15형</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1046023" target="_top">애플 맥북프로 레티나 15형</a>
						<% End If %>
					</dd>
				</dl>
				<!--// 23일 -->

				<!-- 24일 -->
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1024.png" alt="10월 24일" /></dt>
					<dd <% If vProductCode="816426" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1024_01.png" alt="10월 24일 1차상품" /></p>
						<% If GetProductInfo("816426", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("816426", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("816426", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("816426", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('816426');return false;">바이빔 비트 장 스탠드(에쉬)</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=816426" target="_top">바이빔 비트 장 스탠드(에쉬)</a>
						<% End If %>
					</dd>
					<dd <% If vProductCode="621748" Then %>class="nowOn"<% End If %>>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1024_02.png" alt="10월 24일 2차상품" /></p>
						<% If GetProductInfo("621748", "st") Then %>
						<div class="winResult">
							<div class="winnerIs">
								<p class="winPrice"><%=FormatNumber(GetProductInfo("621748", "op"), 0)%>→<strong><%=FormatNumber(GetProductInfo("621748", "sp"), 0)%></strong></p>
								<p class="winner"><%=GetProductInfo("621748", "ui")%></p>
							</div>
						</div>
						<% End If %>
						<% If isApp="1" Then %>
							<a href="" onclick="parent.fnAPPpopupProduct('621748');return false;">오리지널 등나무 그네</a>
						<% Else %>
							<a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=621748" target="_top">오리지널 등나무 그네</a>
						<% End If %>
					</dd>
				</dl>
				<!--// 24일 -->

			</div>
		</div>
	</div>
	<!--// 레이어 팝업 (기적의 상품 보기) -->

	<!-- 레이어 팝업 (응모 결과) -->
	<div class="myPriceLayer">
		<!-- 현재까지 유일가 -->
		<div class="mPrice" style="display:none;" id="onlyPriceDiv">
			<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/btn_layer_close02.png" alt="닫기" /></span>
			<div class="status">
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/blt_mark01.png" alt="따옴표" /><em><span id="onlyPriceUser">0</span></em><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/blt_mark02.png" alt="따옴표" /></span>
				<p>현재까지 유일가입니다<br />기대하세요!</p>
			</div>
			<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/bg_layer_price.png" alt="" /></span>
		</div>
		<!--// 현재까지 유일가 -->

		<!-- 동일가 있을 경우 -->
		<div class="mPrice" id="samePriceDiv">
			<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/btn_layer_close03.png" alt="닫기" /></span>
			<div class="status">
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/blt_mark01.png" alt="따옴표" /><em><span id="chgPriceUser">0</span></em><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/blt_mark02.png" alt="따옴표" /></span>
				<p><span id="sameUserCnt"></span></p>
			</div>
			<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/bg_layer_price02.png" alt="" /></span>
		</div>
		<!--// 동일가 있을 경우 -->
	</div>
	<!--// 레이어 팝업 (응모 결과) -->
	
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55527/img_event_process.png" alt="기적의 주인공이 되는 방법!" /></p>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/tit_notice.png" alt="이벤트 유의사항" /></dt>
		<dd>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
				<li>텐바이텐 APP을 통해 이벤트 응모 후, 당첨이 되신 고객님에 한하여 구매 혜택이 주어집니다.</li>
				<li>당첨 시 세금신고를 위해 개인정보 수집 후 쿠폰이 지급됩니다. </li>
				<li>주문 후 결제 시 '상품 쿠폰'을 꼭 적용해주세요.</li>
				<li>이벤트 상품은 구매 후 환불 및 옵션 교환이 불가합니다.</li>
				<li>당첨되신 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			</ul>
		</dd>
	</dl>
</div>
</form>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->