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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: 기프티콘 교환하기 </title>
<script language="javascript">
function goGetGiftCard()
{
	<% If IsUserLoginOK() = "False" Then %>
	alert("기프트카드 교환 및 사용을 위해서는\n로그인 및 회원가입이 필요합니다.");
	<% Else %>
	document.frm1.submit();
	<% End If %>
}
</script>
<script>
	$(function() {
	/* agree check */
		$("#agree-yes").on("click", function(e){
			$(this).parent().toggleClass("btn-line-red");
			$(".nonmember-notice .artcle").slideToggle();
			$(this).closest('.btn').next('.btn').toggleClass('btn-grey')
			$("#mask").toggle();
		});
		$('#submit').click(function(e){
			if($('#agree-yes[type=checkbox]').prop('checked')==true){
				$(this).attr({'href':'javascript:goGetGiftCard()'})
			}
			else{
				$(this).attr({'href':''})
				return false;
			}
		})
	});
	</script>
</head>
<body class="default-font body-sub bg-grey category-item">
	<!-- contents -->
	<div id="content" class="content gifticon giftcon-terms">
		<form name="frm1" method="post" action="get_giftcard_proc.asp">
			<input type="hidden" name="idx" value="<%=vIdx%>">
		</form>
		<div class="gifticon-section">
			<div class="gift-card">
				<img src="//fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_38.png" alt="">
				<p><em><%=FormatNumber(vSellCash,0)%></em>원</p>
			</div>
			<h2>기프트카드 약관 동의</h2>
			<!-- 텐바이텐 기프트카드 이용약관 -->
			<div class="cardTerms">
				<div class="policyCont">
					<section id="terms01">
						<h3>제1조 - 텐바이텐 기프트카드 정의</h3>
						<ol>
							<li>① 텐바이텐 기프트카드(이하 “기프트카드”라 합니다)」는 텐바이텐 주식회사(이하 “회사”라 합니다)에서 발행한 무기명 선불카드로 일정 금액(이하 “권면가”라 합니다)만큼 사용하실 수 있는 카드 입니다.</li>
							<li>② 텐바이텐 기프트카드는 휴대폰으로 전송되는 무기명 선불카드입니다.</li>
							<li>③ “회원”이라 함은 이 약관을 승인하고 텐바이텐㈜에 기프트카드의 발급을 신청하여 회사로부터 기프트카드를 구매하고 해당 기프트카드를 발급 받은 분을 말합니다.</li>
						</ol>
					</section>
					<section id="terms02">
						<h3>제2조 - 기프트카드의 구매 및 관리</h3>
						<ol>
							<li>① 기프트카드의 구매는 회사가 정한 소정의 방법에 의해 구매하실 수 있습니다. 지정하는 공식 판매처에서만 구매하실 수 있으며 이외의 곳에서 구매 하실 경우 어떠한 책임도 부담하지 않습니다.</li>
							<li>② 회원은 기프트카드를 제3자에게 담보로 제공할 수 없고, 선량한 관리자로서의 주의를 다하여 기프트카드를 이용,관리하여야 합니다.</li>
							<li>③ 회원은 유효기간이 경과한 기프트카드는 사용할 수 없습니다.</li>
							<li>④ 기프트카드 재전송시 이전에 발급된 기프트카드와 인증번호는 이용할 수 없습니다.</li>
							<li>⑤ 회원은 기프트카드 구매를 위장한 현금융통 등의 부당한 행위를 하여서는 안됩니다.</li>
							<li>⑥ 각 항을 위반 또는 해태 함으로써 발생하는 모든 책임은 회원에게 귀속됩니다.</li>
						</ol>
					</section>
					<section id="terms03">
						<h3>제3조 - 기프트카드의 이용 및 제한</h3>
						<ol>
							<li>① 기프트카드는 잔액 내에서 횟수에 제한 없이 자유롭게 사용하실 수 있습니다.</li>
							<li>② 기프트카드는 일시불 결제로만 사용 가능하며 할부 구매 및 현금서비스는 사용하실 수 없습니다.</li>
							<li>③ 기프트카드는 권면금액만큼 사용할 수 있고, 지정된 사용처에서 물품의 구매나 용역의 결제 시 결제금액만큼 즉시 차감됩니다.</li>
							<li>④ 회사는 기프트카드가 사용중지 상태이거나, 아래 기타 사용제한이 요구되는 중대한 사유가 발생한 경우에는 고객의 기프트카드 사용을 제한할 수 있습니다.</li>
							<li>⑤ 포토 기프트카드를 전송함에 있어 사용/보관되는 수신자의 미디어 정보는 텐바이텐㈜ '이용약관' 및 '개인정보 취급방침'에 준수하여 보관됩니다.
								<ol class="lPad10">
									<li>1. 약관 또는 관계법령에서 정한 사항을 위반한 경우</li>
									<li>2. 기프트카드를 이용하여 공공질서와 선량한 풍속에 반하는 행위를 한 경우</li>
								</ol>
							</li>
							<li>⑤ 기프트카드의 최대 구매금액 및 구매방법은 관계법령에 의해 제한될 수 있습니다.</li>
						</ol>
					</section>
					<section id="terms04">
						<h3>제4조 - 포토 기프트카드의 이용 및 제한</h3>
						<ol>
							<li>① 구매자(발신자)의 미디어 정보(사진, 일러스트 등 이미지 파일로 구성된 데이터)를 기프트 카드에 첨부하여 수신자에게 전송하는 것을 '포토 기프트카드'라 말합니다.</li>
							<li>② 포토 기프트카드를 이용하기 위해서는 발신자의 미디어 정보를 활용하여 수신자에게 전송한다는 본 약관에 동의해야 합니다.</li>
							<li>③ 포토 기프트카드에 첨부되는 이미지 파일은 타인 또는 법인의 저작권, 지적 재산권, 초상권 등을 침해하지 않는 순수한 발신자 본인 소유의 이미지 파일이어야 하며 이를 어길 시 텐바이텐㈜은 어떠한 책임을 지지 않습니다.</li>
							<li>④ 제4조 ①항, ②항, ③은 포토 기프트카드를 이용하기 위한 필수 사항이며 이를 동의하지 않을 시 해당 기능을 이용하실 수 없습니다.</li>
							<li>⑤ 포토 기프트카드를 전송함에 있어 사용/보관되는 수신자의 미디어 정보는 텐바이텐㈜ '이용약관' 및 '개인정보 취급방침'에 준수하여 보관됩니다.</li>
							<li>⑥ 회사는 포토 기프트카드가 사용중지 상태이거나, 아래 기타 사용 제한이 요구되는 중대한 사유가 발생한 경우에 고객의 기프트카드 사용을 제한할 수 있습니다.
								<ol class="lPad10">
									<li>1. 약관 또는 관계법령에서 정한 사항을 위반한 경우</li>
									<li>2. 기프트카드를 이용하여 공공질서와 선량한 풍속에 반하는 행위를 한 경우</li>
									<li>3. 저작권, 지적 재산권, 초상권 등 타인 또는 법인의 재산이나 권리를 침해할 경우</li>
								</ol>
							</li>
						</ol>
					</section>
					<section id="terms05">
						<h3>제5조 - 기프트카드의 인터넷사용 등록</h3>
						<ol>
							<li>온라인에서 물품이나 용역을 구매하기 위해서는 회사가 정한 방법에 따라 해당 기프트카드를 인터넷사용 등록해야 합니다.</li>
						</ol>
					</section>
					<section id="terms06">
						<h3>제6조 - 기프트카드의 소득공제 등록</h3>
						<ol>
							<li>① 무기명 선불카드인 기프트카드를 회사가 정한 소정의 소득공제 등록 절차를 거쳐서 기명화할 수 있습니다.</li>
							<li>② 기프트카드 사용액에 대한 연말소득공제를 받기 위해서는 회사가 정한 방법에 따라 해당 기프트카드를 소득공제 등록해야 합니다.</li>
							<li>③ 기프트카드 소득공제 등록을 하신 후라도, 기프트카드의 환불 및 대체입금에 대해서는 소득공제가 되지 않습니다.</li>
						</ol>
					</section>
					<section id="terms07">
						<h3>제7조 - 기프트카드의 환불 및 잔액환급</h3>
						<ol>
							<li>① 환불은 구매일로부터 7일 이내에 가능하며, 온라인 등록이 완료되었거나, 온라인과 오프라인에서 금액의 일부라도 사용된 기프트카드는 환불이 되지 않습니다.</li>
							<li>② 기프트카드 권면 금액이 1만원 초과일 경우 100분의 60 사용시, 1만원 이하일 경우 100분의 80 이상 사용시에는 텐바이텐 온라인에서는 예치금으로 전환 받을 수 있으며 이 조건을 충족하지 못할 경우에는 잔액 환급이 되지 않습니다.</li>
							<li>③ 온라인에서는 여러 개의 Gift카드를 등록하신 경우, 등록한 순서에 따라 사용되며 잔액의 예치금 전환의 경우에도 이 조건이 적용됩니다.</li>
						</ol>
					</section>
					<section id="terms08">
						<h3>제8조 - 기프트카드의 유효기한</h3>
						<ol>
							<li>① 기프트카드의 유효기한은 5년이고, 유효기한이 경과된 기프트카드는 사용하실 수 없습니다.</li>
							<li>② 5년이 지난 경우 환불 불가하며, 5년 이내에는 제 6조 잔액 환불 규정에 따라 온라인 예치금 전환이 가능합니다.</li>
						</ol>
					</section>
					<section id="terms09">
						<h3>제9조 - 기프트카드의 재발급</h3>
						<ol>
							<li>① 메시지 또는 인증번호 분실 시, 정해진 횟수에 한해 재전송이 가능합니다.</li>
							<li>② 단, 기프트카드가 이미 온라인에 등록이 완료된 경우 재전송이 되지 않습니다.</li>
						</ol>
					</section>
					<section id="terms10">
						<h3>제10조 - 기프트카드의 도난ㆍ분실 등에 따른 책임</h3>
						<p>회원이 잘못된 휴대폰 번호 혹은 이메일로 기프트카드 관련 정보(인증번호)를 전송하거나 회원의 부주의로 타인에게 노출 되어 타인에 의해 온라인 등록 또는 사용된 경우, 회사는 책임을 지지 아니하며, 고객이 책임을 부담합니다.</p>
					</section>
					<section id="terms11">
						<h3>제11조 - 기프트카드 위/변조 등에 대한 책임</h3>
						<ol>
							<li>① 위,변조로 인하여 발생된 불법매출에 대한 책임은 회사에 있습니다.</li>
							<li>② 제①항의 규정에도 불구하고 다음 각 호의 사유로 인하여 발생한 불법매출에 대하여는 회원이 그 책임의 전부 또는 일부를 부담하여야 합니다.
								<ol class="lPad10">
									<li>1. 회원의 고의 또는 중대한 과실로 인해 문제가 발생한 경우</li>
									<li>2. 기프트카드를 제 3자에게 대여하거나 사용위임, 양도 또는 담보 목적으로 제공한 경우</li>
									<li>3. 제 3자가 권한 없이 회원의 기프트카드를 이용하여 거래를 할 수 있음을 알았거나 쉽게 알 수 있었음에도 불구하고 기프트카드 관련 정보(인증번호)를 누설 또는 노출하거나 방치한 경우</li>
								</ol>
							</li>
						</ol>
					</section>
					<section id="terms12">
						<h3>제12조 - 이용약관의 효력 및 변경</h3>
						<ol>
							<li>① 이 약관의 내용은 특별한 규정이 없는 한 회사 및 제휴사가 제공하는 서비스 화면상에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력을 발생합니다.</li>
							<li>② 회사는 영업상의 중요한 사유 또는 기타 필요하다고 인정되는 합리적인 사유가 발생할 경우에는 약관의 일부 또는 전부를 변경할 수 있으며, 이 경우 해당 변경 내용을 인터넷상 서비스 공지화면에 적용 예정일로부터 1개월 이전에 공지합니다.</li>
							<li>③ 전항의 방법으로 약관이 변경ㆍ고지된 이후에도 계속적으로 서비스를 이용하는 회원은 약관의 변경사항에 동의한 것으로 간주하며, 이는 기존의 회원에게도 동일하게 적용됩니다.</li>
						</ol>
					</section>
					<section id="terms13">
						<h3>제13조 - 이 약관에서 정하지 아니한 사항</h3>
						<p>이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 관계법령 또는 일반 상관례에 따릅니다.</p>
					</section>
					<section id="terms14">
						<h3>제14조 - 관할법원</h3>
						<p>이 약관에 따른 거래에 대하여 분쟁이 발생한 경우에는 회사의 본점 또는 영업소 소재지, 회원의 주소지를 관할하는 법원을 제1심 관할법원으로 합니다.</p>
					</section>
					<!-- p class="startDate">(부칙) 2009년 8월 1일부터 시행합니다.</p -->
				</div>
			</div>
			<!-- // 텐바이텐 기프트카드 이용약관 -->
			<div class="btn-group">
				<p class="btn btn-block btn-xlarge btn-line-grey">
					<input type="checkbox" id="agree-yes">
					<label for="agree-yes">이용약관을 확인하였으며 이에 동의합니다.</label>
				</p>
				<a class="btn btn-block btn-xlarge btn-red btn-grey tMar0-8r" id="submit">교환하기</a>
			</div>
			<% If IsUserLoginOK() = "" Then %>
			<div class="mem_join">
				<div class="mem_message">쿠폰 교환 및 사용을 위해서는 회원가입이 필요합니다.</div>
				<div class="mem_btn"><span class="btn btn4 whtB w90B"><a href="/member/join.asp">회원가입하기</a></span></div>
			</div>
			<% End If %>
		</div>
		<div class="gifticon-noti">
			<h3>유의사항</h3>
			<ul id="more-noti" class="more-noti" style="display:block;">
				<li>사용 등록이 완료된 기프트카드는 교환 및 환불이 되지 않으며, 텐바이텐 온라인 및 모바일에서만 사용이 가능합니다.</li>
				<li>기프트카드 유효기간은 구매일로부터 5년입니다. 유효기간이 지난 경우 환불이 불가합니다.</li>
				<li>기프트카드 금액이 1만원 초과일 경우 100분의 60이상, 1만원 이하의 경우 100분의 80 이상 사용하면 예치금으로 전환이 가능합니다.</li>
				<li>인증번호 등록이 완료된 기프트카드는 상품 구매시 결제 페이지에서 현금처럼 사용하실 수 있으며 다른 결제 수단과 중복 사용이 가능합니다.</li>
			</ul>
		</div>
	</div>
	<!-- //contents -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->