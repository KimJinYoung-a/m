<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'#######################################################
'	Description : 회원가입 Step1
'	History	:  2013.02.12 강준구 신규 회원가입 로직 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim vQuery, vIdx, vResult, vOrderserial, vCouponNo, vSellCash, vItemID, vSoldOUT, vItemName
	vIdx 		= requestCheckVar(request("idx"),20)
	vSoldOUT	= requestCheckVar(request("soldout"),10)
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND IsPAy = 'N'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vCouponNo 	= rsget("couponno")
		vItemID		= rsget("itemid")
		rsget.close
	Else
		rsget.close
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		Response.End
	End IF

	vQuery = "SELECT sellcash, itemname From [db_item].[dbo].[tbl_item] Where itemid = '" & vItemID & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vSellCash = rsget("sellcash")
		vItemName = rsget("itemname")
	End IF
	rsget.close


	Dim vValue, vImage, i, vNowDate, v60LaterDate
	vImage 	= ""
	vValue = vSellCash
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>10x10: 기프팅 교환하기</title>
<script language="javascript">
function goGetGiftCard()
{
	<% If IsUserLoginOK() = "False" Then %>
	alert("기프트카드 교환 및 사용을 위해서는\n로그인 및 회원가입이 필요합니다.");
	<% Else %>
	document.frm1.submit();
	<% End If %>
}

function blockornone()
{
	document.getElementById("isok0").style.display = "block";
	document.getElementById("isok1").style.display = "none";
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--카카오톡기프팅 START-->
				<div id="kakao_gifting">
				<form name="frm1" method="post" action="get_giftcard_proc.asp">
				<input type="hidden" name="idx" value="<%=vIdx%>">
				</form>
					<h2>기프팅 교환하기</h2>
					<!--상품정보 START-->
				<div id="isok0" style="display:none">
					<div class="gifting_product">
						<ul>
							<li class="cNum">
								<table width="95%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<th width="70px" class="lt"><label for="coupon_num">인증번호</label></th>
										<td><input name="coupon_num" id="coupon_num" type="text" class="text cc91314" value="<%=vCouponNo%>" style="width:90%;" /></td>
									</tr>
									<tr>
										<th class="lt">상품명</th>
										<td><strong><%=vItemName%></strong></td>
									</tr>
								</table>
							</li>
						</ul>
						<div class="ct tMar15">
							<p class="cc91314">텐바이텐 상품 및 텐바이텐 Gift 카드는 텐바이텐 온라인샵 및<br />모바일에서만 교환, 사용이 가능 합니다.</p>
							<p class="tMar10"><span class="btn btn1 redB w90B"><a href="javascript:goGetGiftCard()">교환하기</a></span></p>
						</div>
						<% If IsUserLoginOK() = "" Then %>
						<div class="mem_join">
							<div class="mem_message">쿠폰 교환 및 사용을 위해서는 회원가입이 필요합니다.</div>
							<div class="mem_btn"><span class="btn btn4 whtB w90B"><a href="/member/join.asp">회원가입하기</a></span></div>
						</div>
						<% End If %>
					</div>
					<!--상품정보 END-->

					<!--정보-->
					<div class="gifting_info">
						<ul class="bulArr round">
							<li>기프팅은 상품교환권과 Gift카드교환권 2가지로 구분됩니다.</li>
							<li>Gift카드 기프팅을 사용하시려면 텐바이텐 로그인이 필요합니다.</li>
							<li>옵션이 있는 상품의 경우 텐바이텐에서 기프팅을 상품으로 교환할 때 원하시는 옵션을 선택해주셔야 합니다.</li>
							<li>기프팅으로 받은 상품이 <span class="strong_red">품절일 경우 동일 금액의 텐바이텐 쿠폰(텐바이텐 온라인 및 모바일에서 사용가능)으로 교환</span>해드립니다.</li>
							<li>기프팅을 텐바이텐의 상품으로 교환하시는 경우 단독구매만 가능하시며 텐바이텐의 다른 상품들과 같이 구매 및 결제할 수 없습니다.</li>
							<li><span class="strong_red">기프팅을 텐바이텐 상품 또는 텐바이텐 Gift 카드로 교환한 경우, 취소 및 반품이 불가</span>합니다.</li>
							<li>기프팅 이용 시, 할인 및 기타 제휴 할인 및 마일리지 적립 불가합니다.</li>
							<li>인증번호 오류 시 기프팅 고객센터로 문의 바랍니다. (1666-5046)</li>
						</ul>
					</div>

					<!--CS연결-->
					<div class="cs_center">
						<p><strong>기타 문의사항은 고객센터로 연락주세요.</strong></p>
						<div class="btn_cs">
							<span class="btn btn1 whtB w100B"><a href="tel:1644-6040">1644-6040</a></span>
							<span class="btn btn1 gryB w100B"><a href="/my10x10/qna/myqnalist.asp">1:1 상담</a></span>
						</div>
						<p class="time">AM 09:00~ PM 06:00 (점심시간 : PM 12:00~01:00)<br />주말 공휴일 휴무</p>
					</div>
				</div>
					<div id="isok1" style="display:block">
						<div class="giftcard_apply">
							<div class="giftcard_terms">
							<textarea name="" cols="40" rows="10" class="terms_cont">
< 텐바이텐 Gift카드 약관 >

제1조 (텐바이텐 Gift 카드 정의)
① 텐바이텐 Gift 카드(이하 “Gift 카드”라 합니다)」는 텐바이텐 주식회사(이하 “회사”라 합니다)에서 발행한 무기명 선불카드로 일정 금액(이하 “권면가”라 합니다)만큼 사용하실 수 있는 카드 입니다.
② 텐바이텐 Gift 카드는 휴대폰으로 전송되는 무기명 선불카드입니다.
③ "회원"이라 함은 이 약관을 승인하고 텐바이텐(주)에 Gift 카드의 발급을 신청하여 회사로부터 Gift 카드를 구매하고 해당 Gift 카드를 발급 받은 분을 말합니다.
							</textarea>
							<p class="agree"><input type="checkbox" name="checkbox111" id="checkbox111" onClick="blockornone()"> <label for="checkbox111">Gift카드 이용약관에 동의합니다.</label></p>
							</div>
						</div>
					<div class="gifting_info">
						<h3>Gift 카드 등록 및 사용 안내</h3>
						<ul class="bulArr round tMar15">
							<li>사용등록이 완료된 Gift 카드는 교환 및 환불이 되지 않으며, <span class="strong_red">텐바이텐 온라인 및 모바일에서만 사용이 가능</span>합니다.</li>
							<li><span class="strong_red">유효기간은 구매일로부터 5년</span> 입니다. 유효기간이 지난 경우 환불이 불가합니다.</li>
							<li>Gift 카드 금액이 1만원 초과일 경우 100분의 60 이상, 1만원 이하일 경우 100분의 80 이상 사용하면 남은 금액은 온라인 예치금으로 전환이 가능합니다.</li>
							<li>인증번호 등록이 완료된 Gift카드는 상품 구매 시 결제 페이지에서 현금처럼 사용할 수 있으며, 다른 결제 수단과 중복으로 사용 가능합니다.</li>
							<li>인증번호 오류 시 기프팅 고객센터로 문의 바랍니다. (1666-5046)</li>
						</ul>
					</div>
				</div>
				</div>
				<!--카카오톡기프팅 END-->
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	 <!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->