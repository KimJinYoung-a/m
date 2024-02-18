<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<%
dim userid, userlevel
dim giftOrderserial, IsSuccess, myorder
Dim IsValidOrder : IsValidOrder = False   '''정상 주문 여부
Dim vSendCnt

userid          = GetLoginUserID
userlevel       = GetLoginUserLevel

giftOrderserial = request.cookies("shoppingbag")("before_GiftOrdSerial")
IsSuccess   = request.cookies("shoppingbag")("before_GiftisSuccess")

'' cookie is String
if LCase(CStr(IsSuccess))="true" then
    IsSuccess=true
else
    IsSuccess = false
end if

'''테섭용==============================
IF (application("Svr_Info")="Dev") then
    IF (request("osi")<>"") then
        giftOrderserial = request("osi")
        IsSuccess = true
    end if
End IF
''''===================================

set myorder = new cGiftcardOrder
myorder.FUserID = userid
myorder.Fgiftorderserial = giftorderserial
myorder.getGiftcardOrderDetail

vSendCnt = getGiftCardSMSsendcnt(giftorderserial)

If myorder.FResultcount > 0 Then
	IsValidOrder = true
Else
	Response.Write "<script type='text/javascript'>alert('잘못된 접속입니다.');self.location='/giftcard/';</script>"
	dbget.close()
	Response.End
End If
%>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<title>10x10: 기프트카드 주문결과</title>
<script type="text/javascript">
$(function(){
	/* layer */
	$("#lyGiftcardUrl").hide();

	$(".giftcardSnsV15a ul li.url a").click(function(){
		$("#lyGiftcardUrl").show();
		$("#mask").show();
		var val = $("#lyGiftcardUrl").offset();
		$("html,body").animate({scrollTop:val.top},200);
	});

	$("#lyGiftcardUrl .btnclose, #mask").click(function(){
		$("#lyGiftcardUrl").hide();
		$("#mask").slideUp();
	});

	$("#shareUrl").blur(function(){
		$(this).val($(this).attr("cpval"));
	});
});
</script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgPink">
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="giftcardDoneV15a">
				<% if Not (IsSuccess) then %>
				<!-- // 주문 실패 -->
					<div class="description orderFailure">
						<span class="figure"></span>
						<p><strong>기프트카드 주문이 실패하였습니다.</strong></p>
						<p class="errorMsg cRd1"><b>오류내용</b> : <%= myorder.FOneItem.FResultmsg %></p>
					</div>

					<p class="contact">텐바이텐 고객행복센터 <a href="tel:1644-6030" class="cRd1">1644-6030</a> <span>l</span> <a href="mailto:ustomer@10x10.co.kr">customer@10x10.co.kr</a></p>

					<div class="btnGroupV15a" style="padding:0 1rem;">
						<div class="button btB1 btRed cWh1 w100p"><a href="<%=M_SSLUrl%>/giftcard/">다시 주문하기</a></div>
					</div>
				<% else %>
				<!-- // 주문 성공 -->
					<div class="description">
						<span><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/img_giftcard.png" alt="" /></span>
						<p><b>정상적으로 발송되었습니다.</b></p>
						<p>&apos;마이텐바이텐&apos;에서 주문내역을 확인 하실 수 있습니다.</p>
						<div class="orderNo"><b>주문번호 : <%=myorder.FOneItem.FgiftOrderSerial%></b></div>

						<% if myorder.FOneItem.Faccountdiv="7" then %>
						<p class="bankAccount">
							<b>입금하실 금액 : <%=formatNumber(myorder.FOneItem.FsubtotalPrice,0)%>원</b>
							입금자명 : <%=myorder.FOneItem.FaccountName%><br />
							입급계좌 : <strong><%=myorder.FOneItem.Faccountno%></strong>
						</p>
						<% end if %>
					</div>

					<%
						'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
						Dim vTitle, vLink, vPre, vImg
						vTitle = myorder.FOneItem.Fbuyname & "님이 텐바이텐 기프트카드를 보내셨습니다."
						vLink = wwwUrl & "/giftcard/view.asp?gc=" & rdmSerialEnc(myorder.FOneItem.FmasterCardCode) & ""

						If myorder.FOneItem.FUserImage <> "" Then
							vImg = staticImgUrl & myorder.FOneItem.FUserImage
						Else
							If myorder.FOneItem.FdesignId < 600 Then
								vImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png"
							Else
								vImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_" & Right(CStr(myorder.FOneItem.FdesignId),2) & ".png"
							End IF
						End IF

						dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
						snpTitle = Server.URLEncode(vTitle)
						snpLink = Server.URLEncode(vLink)
						snpImg = Server.URLEncode(vImg)
					%>
					<div class="giftcardSnsV15a">
						<ul>
							<li class="kakaotalk"><a href="" onClick="return false;" id="kakaoa"><span></span>카카오톡</a></li>
							<script>
							$(function(){
								//카카오 SNS 공유
								Kakao.init('c967f6e67b0492478080bcf386390fdd');
							
								// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
								Kakao.Link.createTalkLinkButton({
								  //1000자 이상일경우 , 1000자까지만 전송 
								  //메시지에 표시할 라벨
								  container: '#kakaoa',
								  label: '<%=vTitle%>',
								  image: {
									//500kb 이하 이미지만 표시됨
									src: '<%=vImg%>',
									width: '200',
									height: '121'
								  },
								  webButton: {
									text: '기프트카드 등록하기',
									url: '<%=vLink%>'
								  }
								});
							});
							</script>
							<li class="line"><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span></span>라인</a></li>
							<li class="url"><a href="#lyGiftcardUrl"><span></span>URL</a></li>
						</ul>
						<p class="note">※ 지금 보낸 기프트카드를 위에 방법으로도 보내실 수 있습니다.</p>
					</div>

					<div id="lyGiftcardUrl" class="lyGiftcardUrlV15a">
						<fieldset>
							<div class="field">
								<label for="shareUrl">URL을 길게 눌러 전체 선택 후 복사해주세요</label>
								<input type="text" id="shareUrl" value="http://m.10x10.co.kr/giftcard/view.asp?gc=<%=rdmSerialEnc(myorder.FOneItem.FmasterCardCode)%>"  cpval="http://m.10x10.co.kr/gc_id=<%=rdmSerialEnc(myorder.FOneItem.FmasterCardCode)%>" onkeydown="event.preventDefault();event.stopPropagation();return false;" oncut="event.preventDefault();event.stopPropagation();return false;" />
								<div class="button btB1 btRed cWh1 btnclose"><button type="button">닫기</button></div>
							</div>
						</fieldset>
					</div>
					<div id="mask" style="display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);"></div>

					<div class="btnGroupV15a" style="padding:0 1rem;">
						<div class="button btB1 btRed cWh1 w100p"><a href="<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/giftcard/giftcardOrderlist.asp">주문확인 하기</a></div>
						<div class="button btB1 btRedBdr cWh1 w100p"><a href="<%=M_SSLUrl%>/giftcard/">추가 선물하기</a></div>
					</div>
				<% end if %>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/webview/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->