<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_ordercls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%
	dim myorder, userid, giftorderserial, MasterCardCode, temp, tmpUserid, IsValidOrder
	userid = getEncLoginUserID()
	MasterCardCode = requestCheckVar(request("gc"),20)
	MasterCardCode = rdmSerialDec(MasterCardCode)		'Rnd복호화
	
	if MasterCardCode="" then Call Alert_move("텐바이텐 기프트카드 번호가 없거나 잘못된 번호입니다.\n\n텐바이텐 메인으로 이동합니다.","/")
	
	temp = fnGetGiftOrderSerial(MasterCardCode)
	If temp <> "" Then
		giftorderserial = Split(temp,"|||")(0)
		tmpUserid = Split(temp,"|||")(1)
	End If
	
	if temp="" then Call Alert_move("텐바이텐 기프트카드 번호가 없거나 잘못된 번호입니다.\n\n텐바이텐 메인으로 이동합니다.","/")

	set myorder = new cGiftcardOrder
	myorder.FUserID = CHKIIF(userid="",tmpUserid,userid)
	myorder.Fgiftorderserial = giftorderserial
	myorder.getGiftcardOrderDetail
	
	
	If myorder.FResultcount > 0 Then
		IsValidOrder = true
	Else
		Response.Write "<script language='javascript'>alert('잘못된 주문번호 입니다.');</script>"
		dbget.close()
		Response.End
	End If

	Dim vCardImg
	If myorder.FOneItem.FUserImage <> "" Then
		vCardImg = staticImgUrl & myorder.FOneItem.FUserImage
	Else
		If myorder.FOneItem.FdesignId < 600 Then
			vCardImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png"
		Else
			vCardImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_" & Right(CStr(myorder.FOneItem.FdesignId),2) & ".png"
		End IF
	End IF

	'head.asp에서 출력
	strOGMeta = "<meta property=""og:title"" content=""" & myorder.FOneItem.Fbuyname & "님이 기프트카드를 선물하셨습니다."">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/giftcard/"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & vCardImg & """>" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:description"" content=""텐바이텐 기프트 카드로 마음을 받아보세요."">" & vbCrLf

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 기프트카드</title>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<script>
function chkRegForm(frm){
<% If userid = "" Then %>
	parent.jsChklogin_mobile('','<%=Server.URLencode("/giftcard/view.asp?gc="&request("gc")&"")%>');
	return false;
<% Else %>
	if(frm.masterCardCd1.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		return false;
	}
	if(frm.masterCardCd2.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		return false;
	}
	if(frm.masterCardCd3.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		return false;
	}
	if(frm.masterCardCd4.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		return false;
	}
<% End If %>
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgPink">
			<div class="content" id="contentArea">
				<div class="giftcardDoneV15a">
					<p class="sender"><%=myorder.FOneItem.Fbuyname%>님이 <span class="cRd1">기프트카드를 선물</span>하셨습니다.</p>

					<div class="giftcardViewV15a">
						<div class="giftcardPrice">
							<img src="http://fiximage.10x10.co.kr/m/2016/giftcard/tit_10x10_giftcard.png" alt="10X10 GIFT CARD" />
							<b><%=FormatNumber(myorder.FOneItem.FcardSellCash,0)%></b><span>원</span>
						</div>
						<%
							If myorder.FOneItem.FUserImage <> "" Then
								Response.Write "<div class=""design designTypeA"">"
							Else
								Response.Write "<div class=""design"">"
							End IF
						%>
						<img src="<%=vCardImg%>" alt="" />
						<div class="frame"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/bg_photo_frame.png" alt="" /></div>
						</div>
						<div class="giftcardMsg">
							<%=Replace(CHKIIF(myorder.FOneItem.FMMSContent="",myorder.FOneItem.FemailContent,myorder.FOneItem.FMMSContent),chr(10),"<br />")%>
						</div>
					</div>

					<div class="giftcardRegiFormV15a">
						<form name="frmReg" method="POST" action="/my10x10/giftcard/do_giftcardReg.asp" target="iframeProc" onsubmit="return chkRegForm(this)" style="margin:0px;">
						<input type="hidden" name="masterCardCd" value="<%=MasterCardCode%>" />
							<fieldset>
							<legend>기프트카드 등록</legend>
								<div class="field">
									<input type="number" readonly="readonly" name="masterCardCd1" value="<%=Left(MasterCardCode,4)%>" /> -
									<input type="number" readonly="readonly" name="masterCardCd2" value="<%=Mid(MasterCardCode,5,4)%>" /> -
									<input type="number" readonly="readonly" name="masterCardCd3" value="<%=Mid(MasterCardCode,9,4)%>" /> -
									<input type="number" readonly="readonly" name="masterCardCd4" value="<%=Right(MasterCardCode,4)%>" />
								</div>

								<div class="btnGroupV15a">
									<div class="button btB1 btRed cWh1 w100p"><button type="submit">등록하기</button></div>
									<div class="button btB1 btRedBdr cWh1 w100p"><a href="/giftcard/usageNotice.asp?reurl=/giftcard/view.asp?gc=<%=request("gc")%>">이용안내 및 유의사항</a></div>
								</div>
							</fieldset>
						</form>
					</div>

					<div class="listBox">
						<ul>
							<li>기프트카드의 유효기간은 구매일로부터 5년입니다.</li>
							<li>인증번호 등록 후 기프트카드 금액을 현금처럼 사용할 수 있으며, 다른 결제 수단과 중복으로 사용 가능합니다.</li>
							<li>온라인 카드사용등록 전 기프트카드 메시지 또는 인증번호를 분실하신 경우 보내는 사람에게 재전송을 요청하실 수 있으며 재전송은 2회까지 가능합니다.</li>
						</ul>
					</div>

				</div>
			</div>
			<!-- //content area -->

			<footer class="giftcardFooter">
				<p>
					<span class="logo"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/img_logo.png" alt="10X10" /></span>
					<span class="cs"> | 고객행복센터 : <a href="tel:1644-6030">1644-6030</a></span>
				</p>
			</footer>
		</div>
	</div>
	<iframe src="about:blank" name="iframeProc" width="0" height="0" frameborder="0" ></iframe>
</div>
</body>
</html>
<% Set myorder = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->