<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 10원의 기적
' History : 2014.07.22 원승현
' History : 2014.10.15 이종화 리스트 교체
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, vUserID, appeCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal
	vUserID = GetLoginUserID()
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21342"
		appeCode = "21344"
	Else
		eCode = "55525"
		appeCode = "55527"
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
		nowtime = GetTranTimer(now())												'현재 시간
	End If


If IsUserLoginOK Then

	'// 해당 경매별 개인 응모횟수를 가져온다.
	 sqlstr = " Select count(sub_opt1) From db_event.dbo.tbl_event_subscript " &_
					" Where evt_code='"&appeCode&"' And sub_opt1='"&vIdx&"' And userid='"&GetLoginUserID&"' "
	rsget.Open sqlStr,dbget,1
		cnt = rsget(0)
	rsget.close

	'// 해당 경매별 개인 작성금액 값을 가져온다.
	 sqlstr = " Select sub_opt2 From db_event.dbo.tbl_event_subscript " &_
					" Where evt_code='"&appeCode&"' And sub_opt1='"&vIdx&"' And userid='"&GetLoginUserID()&"' order by regdate desc "
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

function getusercell(userid)
	dim sqlstr, tmpusercell
	
	if userid="" then
		getusercell=""
		exit function
	end if
	
	sqlstr = "select top 1 n.usercell"
	sqlstr = sqlstr & " from db_user.dbo.tbl_user_n n"
	sqlstr = sqlstr & " where n.userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpusercell = rsget("usercell")
	else
		tmpusercell = ""
	END IF
	rsget.close
	
	getusercell = tmpusercell
end Function

%>

<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 10원의 기적!</title>
<style type="text/css">
.mEvt55526 {background:#fff; padding-bottom:20px; margin-bottom:-50px;}
.mEvt55526 img {vertical-align:top; width:100%;}
.mEvt55526 .mPdtList {padding:0 4%;background:#ff9600;}
.mEvt55526 .mPdtList .saleItem {padding:6% 4%; border-radius:10px; background:#fff;}
.mEvt55526 .mPdtList .saleItem dl {position:relative; border:1px solid #ddd; border-radius:10px; margin-bottom:8%;}
.mEvt55526 .mPdtList .saleItem dl:last-child {margin-bottom:0;}
.mEvt55526 .mPdtList .saleItem dl img {border-radius:10px;}
.mEvt55526 .mPdtList .saleItem dl:before {content:" "; display:inline-block; position:absolute; left:50%; top:0; width:1px; height:100%; margin-left:-1px; border-right:1px solid #ddd; z-index:40;}
.mEvt55526 .mPdtList .saleItem dl:after {content:" "; display:block; clear:both;}
.mEvt55526 .mPdtList .saleItem dt {position:absolute; left:50%; top:-6.5%; width:14%; margin-left:-7%; z-index:50;}
.mEvt55526 .mPdtList .saleItem dd {position:relative; float:left; width:50%;}
.mEvt55526 .mPdtList .saleItem dd.nowOn:after {content:" "; display:inline-block; position:absolute; right:-1px; top:0; width:101%; height:100%; border:4px solid #ff5f57; box-sizing:border-box; z-index:45;}
.mEvt55526 .mPdtList .saleItem dd:nth-child(even).nowOn:after {left:-1px; border-radius:10px 0 0 10px;}
.mEvt55526 .mPdtList .saleItem dd:nth-child(odd).nowOn:after {left:0px; border-radius:0 10px 10px 0;}
.mEvt55526 .mPdtList .saleItem dd .winResult {position:absolute; width:100%; height:35px; left:0; bottom:0; font-size:11px; padding-top:6px; text-align:center; background:rgba(69,255,214,.1);}
.mEvt55526 .mPdtList .saleItem dd:nth-child(even) .winResult {border-radius:0 0 0 10px;}
.mEvt55526 .mPdtList .saleItem dd:nth-child(odd) .winResult {border-radius:0 0 10px 0;}
.mEvt55526 .mPdtList .saleItem dd .winResult .winnerIs {color:#999; line-height:1.1;}
.mEvt55526 .mPdtList .saleItem dd .winResult .winPrice strong {color:#dc0610;}
.mEvt55526 .mPdtList .saleItem dd .winResult .winner {color:#333;}
.mEvt55526 .mPdtList .saleItem dd a {display:inline-block; width:100%; height:100%; position:absolute; left:0; top:0; z-index:40; text-indent:-9999em; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55526/bg_blank.png) left top repeat; background-size:100% 100%;}
.mEvt55526 .mPdtList .goApp {padding:25px 7%;}
.mEvt55526 .evtNoti {padding:27px 14px; text-align:left;}
.mEvt55526 .evtNoti dt {padding-bottom:10px;}
.mEvt55526 .evtNoti dt img {width:84px;}
.mEvt55526 .evtNoti dd li {position:relative; padding-left:12px; font-size:11px; line-height:1.4; color:#333;}
.mEvt55526 .evtNoti dd li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:4px; background:#b4b4b4; border-radius:50%;}

@media all and (min-width:480px){
	.mEvt55526 .mPdtList .saleItem {border-radius:15px;}
	.mEvt55526 .mPdtList .saleItem dd .winResult {font-size:17px; height:53px; padding-top:9px;}
	.mEvt55526 .mPdtList .goApp {padding:38px 7%;}
	.mEvt55526 .evtNoti dt {padding-bottom:15px;}
	.mEvt55526 .evtNoti dt img {width:125px;}
	.mEvt55526 .evtNoti dd li {padding-left:18px; font-size:17px;}
	.mEvt55526 .evtNoti dd li:after {top:6px; width:6px; height:6px;}
}
</style>
</head>
<body>
<!-- 10원의 기적!(M) -->
<div class="mEvt55526">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/tit_miracle_10won.png" alt="내가 전생에 나라를 구했나?! 10원의 기적" /></h2>
	<!-- 기적의 상품 리스트 -->
	<div class="mPdtList">
		<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/tit_product.png" alt="기적의 상품 확인하세요" /></h4>
		<div class="saleItem">
			<!-- 21일 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1021.png" alt="10월 21일" /></dt>
				<dd class="<% If vProductCode="339040" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1021_01.png" alt="10월 21일 1차상품" /></p>
					<% If GetProductInfo("339040", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("339040", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("339040", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("339040", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=339040" target="_parents">비토 민트</a>
				</dd>
				<dd class="<% If vProductCode="1111966" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1021_02.png" alt="10월 21일 2차상품" /></p>
					<% If GetProductInfo("1111966", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("1111966", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("1111966", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("1111966", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=1111966" target="_parents">모두시스 트윙글빔</a>
				</dd>
			</dl>
			<!--// 21일 -->

			<!-- 22일 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1022.png" alt="10월 22일" /></dt>
				<dd class="<% If vProductCode="1112074" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1022_01.png" alt="10월 22일 1차상품" /></p>
					<% If GetProductInfo("1112074", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("1112074", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("1112074", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("1112074", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=1112074" target="_parents">폴러스터프 2MAN TENT</a>
				</dd>
				<dd class="<% If vProductCode="962111" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1022_02.png" alt="10월 22일 2차상품" /></p>
					<% If GetProductInfo("962111", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("962111", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("962111", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("962111", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=962111" target="_parents">라이카 C Dark red set</a>
				</dd>
			</dl>
			<!--// 22일 -->

			<!-- 23일 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1023.png" alt="10월 23일" /></dt>
				<dd class="<% If vProductCode="993520" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1023_01.png" alt="10월 23일 1차상품" /></p>
					<% If GetProductInfo("993520", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("993520", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("993520", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("993520", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=993520" target="_parents">하만카돈 블루투스 스피커</a>
				</dd>
				<dd class="<% If vProductCode="1046023" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1023_02.png" alt="10월 23일 2차상품" /></p>
					<% If GetProductInfo("1046023", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("1046023", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("1046023", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("1046023", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=1046023" target="_parents">애플 맥북프로 레티나 15형</a>
				</dd>
			</dl>
			<!--// 23일 -->

			<!-- 24일 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/txt_date1024.png" alt="10월 24일" /></dt>
				<dd class="<% If vProductCode="816426" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1024_01.png" alt="10월 24일 1차상품" /></p>
					<% If GetProductInfo("816426", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("816426", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("816426", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("816426", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=816426" target="_parents">바이빔 비트 장 스탠드(에쉬)</a>
				</dd>
				<dd class="<% If vProductCode="621748" Then %>nowOn<% End If %>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_product_1024_02.png" alt="10월 24일 2차상품" /></p>
					<% If GetProductInfo("621748", "st") Then %>
					<div class="winResult">
						<div class="winnerIs">
							<p class="winPrice"><del><%=FormatNumber(GetProductInfo("621748", "op"), 0)%></del>→<strong><%=FormatNumber(GetProductInfo("621748", "sp"), 0)%></strong></p>
							<p class="winner"><%=GetProductInfo("621748", "ui")%></p>
						</div>
					</div>
					<% End If %>
					<a href="/category/category_itemPrd.asp?itemid=621748" target="_parents">오리지널 등나무 그네</a>
				</dd>
			</dl>
			<!--// 24일 -->

		</div>
		<p class="goApp"><a href="" onClick="wishAppLink('http//m.10x10.co.kr/apps/appcom/wish/webview/event/eventmain.asp?eventid=55527');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/btn_tenten_app.png" alt="텐바이텐 APP 바로가기" /></a></p>
	</div>
	<!--// 기적의 상품 리스트 -->
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55526/img_event_process.png" alt="기적의 주인공이 되는 방법!" /></p>
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
<!-- //10원의 기적!(M) -->
<iframe style="display:none" height="0" width="0" id="loader"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
