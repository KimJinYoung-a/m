<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
dim cEComment ,eCode ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt

	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	iCPerCnt = 10		'보여지는 페이지 간격
	iCPageSize = 15		'한 페이지의 보여지는 열의 수

	IF blnFull = "" THEN blnFull = True
	IF blnBlogURL = "" THEN blnBlogURL = False
	IF iCCurrpage = "" THEN	iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21053"
	Else
		eCode = "48606"
	End If

	'데이터 가져오기
	set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = GetLoginUserID
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	'arrCList = cEComment.fnGetComment		'리스트 가져오기
	'iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
		
	'---------------------------------------------------------------------------------
	Dim vQuery, i, vUserID, vIsAllChk1, vMyCnt1, vIsAllChk2, vMyCnt2, vMyOrderCnt, vRemainCnt, vArr, vArr2, vOrderSR(4), vImage
	vUserID = GetLoginUserID
	vIsAllChk1 = "x"
	vIsAllChk2 = "x"
	vMyCnt1 = 0
	vMyCnt2 = 0
	vMyOrderCnt = 0
	vRemainCnt = 0
	
	If vUserID <> "" Then

		'######### 막걸리 gubun = 2
		vQuery = "SELECT sub_opt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' AND evt_code = '" & eCode & "' order by sub_opt1 asc"
		rsget.Open vQuery,dbget,1
		vMyCnt2 = rsget.RecordCount
		IF vMyCnt2 > 4 Then
			vIsAllChk2 = "o"
		End IF
		If Not rsget.Eof Then
			vArr = rsget.getRows()
		End If
		rsget.close
		
		
		vQuery = "SELECT count(m.orderserial) FROM [db_order].[dbo].[tbl_order_master] as m WHERE m.userid = '" & vUserID & "' AND m.regdate > '2014-01-01 00:00:00' AND m.ipkumdiv>3 AND m.jumundiv<>9"
		rsget.Open vQuery,dbget,1
		If Not rsget.Eof Then
			vMyOrderCnt = rsget(0)
		End If
		rsget.close
		
		
		If vIsAllChk2 = "x" Then
			vQuery = "SELECT Top 5 m.orderserial FROM [db_order].[dbo].[tbl_order_master] as m WHERE m.userid = '" & vUserID & "' AND m.regdate > '2014-01-01 00:00:00' AND m.ipkumdiv>3 AND m.jumundiv<>9 ORDER BY m.orderserial DESC"
			rsget.Open vQuery,dbget,1
			If Not rsget.Eof Then
				vArr2 = rsget.getRows()
				
				For i=0 To UBound(vArr2,2)
					vOrderSR(i) = vArr2(0,i)
				Next
			Else
				vMyOrderCnt = 0
			End If
			rsget.close
			
			IF vMyOrderCnt < 5 Then
				vRemainCnt = vMyOrderCnt - vMyCnt2
			Else
				vRemainCnt = 5 - vMyCnt2
			End IF
		End IF
	End IF
	
	Function fnIsChecked(arr,a)
		Dim gg, i
		gg = "x"
		If IsArray(arr) Then
			For i=0 To UBound(arr,2)
				If CStr(arr(0,i)) = CStr(a) Then
					gg = "o"
					Exit For
				End IF
			Next
		End IF
		fnIsChecked = gg
	End Function
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 선물이 막걸립니다</title>
<style type="text/css">
.mEvt48607 img {vertical-align:top;}
.mEvt48607 p {max-width:100%;}
.mEvt48607 .riceWineEvt .selectWine {padding:14px 6%; background:url('http://webimage.10x10.co.kr/eventIMG/2014/48607/bg_rice_wine_01.png') left top no-repeat; background-size:100% 100%;}
.mEvt48607 .riceWineEvt .selectWine .buyCounting {padding:2px; border:2px solid #fff;}
.mEvt48607 .riceWineEvt .selectWine .buyCounting p {padding:11px; line-height:14px; color:#836861; text-align:center; font-size:11px; background:#fff;}
.mEvt48607 .riceWineEvt .selectWine .buyCounting p em {font-weight:bold;}
.mEvt48607 .riceWineEvt .selectWine .buyCounting p strong {color:#ff7022; text-decoration:underline;}
.mEvt48607 .riceWineEvt .ricewineDrink {overflow:hidden; padding-top:18px;}
.mEvt48607 .riceWineEvt .ricewineDrink li {float:left; width:30.3%; padding:0 1.5%; margin-bottom:13px; text-align:center;}
.mEvt48607 .riceWineEvt .ricewineDrink li input {margin-top:4px;}
.mEvt48607 .riceWineEvt .selectGift {padding:0 2%; background:url('http://webimage.10x10.co.kr/eventIMG/2014/48607/bg_rice_wine_02.png') left top no-repeat; background-size:100% 100%;}
.mEvt48607 .riceWineEvt .selectGift ul {overflow:hidden; padding-bottom:13px;}
.mEvt48607 .riceWineEvt .selectGift li {float:left; width:33.3%; margin-bottom:13px; text-align:center;}
.mEvt48607 .riceWineEvt .selectGift li:first-child {margin-left:16%;}
.mEvt48607 .riceWineEvt .selectGift li img {width:75% !important;}
.mEvt48607 .riceWineEvt .selectGift li label {display:block;}
.mEvt48607 .riceWineEvt .selectGift li input {margin-top:4px;}
.mEvt48607 .riceWineEvt .btnEnter {padding-bottom:58px; background:url('http://webimage.10x10.co.kr/eventIMG/2014/48607/bg_rice_wine_03.png') left top no-repeat; background-size:100% 100%;}
.mEvt48607 .riceWineEvt .btnEnter p {width:86%; margin:0 auto;}
.mEvt48607 .riceWineEvt .btnEnter input {-webkit-border-radius:0;}
.mEvt48607 .note {padding:20px 4% 35px; background:url('http://webimage.10x10.co.kr/eventIMG/2014/48607/bg_rice_wine_04.png') left top no-repeat; background-size:100% 100%;}
.mEvt48607 .note .tit {font-size:12px; padding:0 0 12px 10px; font-weight:bold; color:#907765;}
.mEvt48607 .note li {font-size:11px; line-height:14px; color:#666; padding:0 0 3px 10px; background:url('http://webimage.10x10.co.kr/eventIMG/2014/48607/blt_round.png') left 5px no-repeat; background-size:3px 3px;}
.mEvt48607 .goCarrot {margin-top:-26px;}
</style>
<script type="text/javascript">
function jsGogubun2(){
<% If vUserID <> "" Then %>
	<% If vRemainCnt > 0 Then %>
	if($(":radio[name=orderserial]:checked").length < 1){
		alert("막걸리를 선택하세요.");
		return;
	}
	if($(":radio[name=spoint]:checked").length < 1){
		alert("사은품을 선택하세요.");
		return;
	}
	frmGubun2.submit();
	<% Else %>
	alert("막걸리를 마실 수 있는 남은 횟수가 0회 입니다.");
	return;
	<% End If %>
<% Else %>
	alert('로그인 후에 응모하실 수 있습니다.');
	return;
<% End If %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt48607">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_head.png" alt="선물이 막걸립니다" style="width:100%" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_evt_guide.png" alt="응모방법" style="width:100%" /></p>
		<div class="riceWineEvt">
			<!-- 막걸리 마시기 -->
			<form name="frmGubun2" method="post" action="doEventSubscript48606.asp" style="margin:0px;" target="prociframe">
			<input type="hidden" name="gubun" value="2">
			<div class="selectWine">
				<% If vUserID <> "" Then %>
				<div class="buyCounting">
					<p>
						<em><%=printUserId(vUserID,2,"*")%></em> 님의<br />
						2014년 01월 01일 이후 구매 횟수 : <strong><%=vMyOrderCnt%>회</strong><br />
						막걸리를 마실 수 있는 남은 횟수 : <strong><%=vRemainCnt%>회</strong>
					</p>
				</div>
				<% End If %>
				<ul class="ricewineDrink">
				<%
					If vOrderSR(0) = "" Then
						vImage = "off"
					Else
						If fnIsChecked(vArr,vOrderSR(0)) = "o" Then
							vImage = "end"
						Else
							vImage = "on"
						End If
					End If
					If vIsAllChk2 = "o" Then vImage = "end" End If
				%>
					<li style="margin-left:16%;">
						<label for="ricewine01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_<%=vImage%>.png" style="width:100%" alt="막걸리" <%=CHKIIF(vImage="on","style=""cursor:pointer;""","")%> /></label>
						<% If vImage = "on" Then %><input type="radio" id="ricewine01" name="orderserial" value="<%=vOrderSR(0)%>" /><% End If %>
					</li>
				<%
					If vOrderSR(1) = "" Then
						vImage = "off"
					Else
						If fnIsChecked(vArr,vOrderSR(1)) = "o" Then
							vImage = "end"
						Else
							vImage = "on"
						End If
					End If
					If vIsAllChk2 = "o" Then vImage = "end" End If
				%>
					<li>
						<label for="ricewine02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_<%=vImage%>.png" style="width:100%" alt="막걸리" <%=CHKIIF(vImage="on","style=""cursor:pointer;""","")%> /></label>
						<% If vImage = "on" Then %><input type="radio" id="ricewine02" name="orderserial" value="<%=vOrderSR(1)%>" /><% End If %>
					</li>
				</ul>
				<ul class="ricewineDrink">
				<%
					If vOrderSR(2) = "" Then
						vImage = "off"
					Else
						If fnIsChecked(vArr,vOrderSR(2)) = "o" Then
							vImage = "end"
						Else
							vImage = "on"
						End If
					End If
					If vIsAllChk2 = "o" Then vImage = "end" End If
				%>
					<li>
						<label for="ricewine03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_<%=vImage%>.png" style="width:100%" alt="막걸리" <%=CHKIIF(vImage="on","style=""cursor:pointer;""","")%> /></label>
						<% If vImage = "on" Then %><input type="radio" id="ricewine03" name="orderserial" value="<%=vOrderSR(2)%>" /><% End If %>
					</li>
				<%
					If vOrderSR(3) = "" Then
						vImage = "off"
					Else
						If fnIsChecked(vArr,vOrderSR(3)) = "o" Then
							vImage = "end"
						Else
							vImage = "on"
						End If
					End If
					If vIsAllChk2 = "o" Then vImage = "end" End If
				%>
					<li>
						<label for="ricewine04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_<%=vImage%>.png" style="width:100%" alt="막걸리" <%=CHKIIF(vImage="on","style=""cursor:pointer;""","")%> /></label>
						<% If vImage = "on" Then %><input type="radio" id="ricewine04" name="orderserial" value="<%=vOrderSR(3)%>" /><% End If %>
					</li>
				<%
					If vOrderSR(4) = "" Then
						vImage = "off"
					Else
						If fnIsChecked(vArr,vOrderSR(4)) = "o" Then
							vImage = "end"
						Else
							vImage = "on"
						End If
					End If
					If vIsAllChk2 = "o" Then vImage = "end" End If
				%>
					<li>
						<label for="ricewine05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_<%=vImage%>.png" style="width:100%" alt="막걸리" <%=CHKIIF(vImage="on","style=""cursor:pointer;""","")%> /></label>
						<% If vImage = "on" Then %><input type="radio" id="ricewine05" name="orderserial" value="<%=vOrderSR(4)%>" /><% End If %>
					</li>
				</ul>
			</div>
			<!--// 막걸리 마시기 -->

			<!-- 사은품 선택 -->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/tit_rice_wine_gift.png" alt="막걸리 마시고 간다 간다 숑~ 간다! 사은품!" style="width:100%" /></p>
			<div class="selectGift">
				<ul>
					<li>
						<label for="choiceGift01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_gift_01.png" alt="영화보러 영화관 CGV 영화 예매권 주말 (2인) 40명" style="width:100%" /></label>
						<input type="radio" id="choiceGift01" name="spoint" value="1" />
					</li>
					<li>
						<label for="choiceGift02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_gift_02.png" alt="커피 마시러 스타벅스 아메리카노 40명" style="width:100%" /></label>
						<input type="radio" id="choiceGift02" name="spoint" value="2" />
					</li>
					<li>
						<label for="choiceGift03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_gift_03.png" alt="오늘은 내가 쏘러 죠스떡볶이 떡+튀+순 10명" style="width:100%" /></label>
						<input type="radio" id="choiceGift03" name="spoint" value="3" />
					</li>
					<li>
						<label for="choiceGift04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_gift_04.png" alt="동심의 세계로 롯데월드 자유이용권 (2매) 10명" style="width:100%" /></label>
						<input type="radio" id="choiceGift04" name="spoint" value="4" />
					</li>
					<li>
						<label for="choiceGift05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/img_rice_wine_gift_05.png" alt="허기를 달래러 CU 편의점 모바일상품권 (2천원) 100명" style="width:100%" /></label>
						<input type="radio" id="choiceGift05" name="spoint" value="5" />
					</li>
				</ul>
			</div>
			<!--// 사은품 선택 -->
			<div class="btnEnter"><p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/btn_submit.png" alt="응모하기" onClick="jsGogubun2();" style="cursor:pointer;width:100%;" /></p></div>
			</form>
		</div>
		<div class="note">
			<p class="tit">유의사항</p>
			<ul>
				<li>텐바이텐 회원을 대상으로 한 이벤트 입니다.</li>
				<li>구매 횟수 1번 당, 1잔의 막걸리를 마실 수 있습니다.</li>
				<li>구매 금액에 상관없이 구매 횟수 당 1잔의 막걸리가 주어집니다.</li>
				<li>응모횟수가 많을 수록 (막걸리를 많이 마실 수록) 당첨확률이 높아집니다!</li>
				<li>당첨자 경품은 1월 29일 (수)에 개인정보에 등록된 전화번호로 모바일 사용권이 발송될 예정입니다.</li>
				<li>경품지급 후 구매 취소 시, 경품은 사용이 불가합니다. 사용 후에는 해당 금액을 제하고 환불됩니다.</li>
				<li>당첨자 발표 후, 경품의 교환 및 양도는 불가합니다.</li>
				<li>당첨되시는 분에게는 세무 신고를 위해 개인정보를 요청할 수 있습니다.</li>
			</ul>
		</div>
		<p class="goCarrot"><a href="/event/eventmain.asp?eventid=<%=CHKIIF(application("Svr_Info")="Dev","21057","48651")%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48607/btn_go_carrot.png" alt="2014년에 만나는 新당연하지! 말이야 당근이야 이벤트 보러가기" style="width:100%" /></a></p>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->