<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 이용약관
' History : 2014.09.03 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<!-- #include virtual="/lib/inc/head.asp" -->

<title>10x10: 이용약관</title>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="prevPage">
					<a href="" onclick="goBack('/member/join.asp'); return false;"><em class="elmBg">이전으로</em></a>
				</div>
				<!-- 이용약관 -->
				<div class="inner5">
					<h2 class="tit01 tMar20">이용약관</h2>
					<ul class="policyList box2">
						<li><a href="#terms01">[제 1 장 총칙]</a></li>
						<li><a href="#terms02">[제 2 장 회사의 서비스]</a></li>
						<li><a href="#terms03">[제 3 장 회원가입 계약]</a></li>
						<li><a href="#terms04">[제 4 장 구매계약 및 대금 결제]</a></li>
						<li><a href="#terms05">[제 5장 계약당사자의 의무]</a></li>
						<li><a href="#terms06">[제 6장 부가서비스의 이용]</a></li>
						<li><a href="#terms07">[제 7장 기타]</a></li>
					</ul>

					<div class="policyCont">
						<section id="terms01">
							<h3>[제 1 장 총칙]</h3>
							<h4>제 1조 (목적)</h4>
							<p>이 약관은 텐바이텐주식회사(이하 "회사") 가 운영하는 인터넷 사이트를 통하여 제공하는 전자상거래 관련 서비스(이하 "서비스")를 이용함에 있어 회사와 이용자의 권리·의무 및 책임사항을 규정함을 목적으로 합니다. * PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다.</p>
							<h4>제 2조 (정의)</h4>
							<p>1. "회사"란 텐바이텐주식회사가 재화 또는 용역(이하 "재화 등"이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신 설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버 몰을 운영하는 사업자의 의미로도 사용합니다.</p>
							<p>2. "이용자"란 "회사"에 접속하여 이 약관에 따라 "회사"가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.</p>
							<p>3. 회원이라 함은 "회사"에 개인정보를 제공하여 회원 등록을 한 자로서, "회사"의 정보를 지속적으로 제공 받으며, "회사"가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.</p>
							<p>4. "비회원"이라 함은 회원에 가입하지 않고 "회사"가 제공하는 서비스를 이용하는 자를 말합니다. 5. 이외에 이 약관에서 사용하는 용어의 정의는 관계 법령 및 서비스 별 안내에서 정하는 바에 의합니다.</p>
							<p>5. 이외에 이 약관에서 사용하는 용어의 정의는 관계 법령 및 서비스 별 안내에서 정하는 바에 의합니다.</p>

							<h4>제 3조 (약관 등의 명시와 설명 및 개정)</h4>
							<p>1. "회사"는 이 약관의 내용과 상호, 영업소 소재지 주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호, 모사전송번호, 이메일주소, 사업자등록번호, 통신판매업신고번호, 개인정보관리책임자 등을 이용자가 쉽게 알 수 있도록 "회사"의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.</p>
							<p>2. "회사"는 약관의규제에관한법률, 전자상거래등에서의소비자보호에관한법률, 소비자기본법 등 관련법을 위배하지 않는 범위 에서 이 약관을 개정할 수 있습니다.</p>
							<p>3. "회사"는 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 "회사"의 초기화면이나 팝업화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 "회사"는 개정전 내용과 개정후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.</p>
							<p>4. "회사"가 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제4항에 의한 개정약관의 공지기간 내에 "회사"에 송신하여 "회사"의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.</p>
							<p>5. 이 약관에서 정하지 아니한 내용과 이 약관의 해석에 관하여는 전자상거래등에서의소비자보호에관한법률, 약관의규제등에관한법률, 공정거래위원회가 정하는 전자상거래등에서의소비자보호지침 및 관계법령 또는 상관례에 따릅니다.</p>
						</section>

						<section id="terms02">
							<h3>[제 2장 회사의 서비스]</h3>
							<h4>제 4조 (서비스의 제공 및 변경)</h4>
							<p>1. "회사"는 다음과 같은 서비스를 제공합니다.</p>
							<ul class="depth">
								<li>① 재화 또는 용역에 대한 정보 제공 및 구매 계약의 체결</li>
								<li>② 구매 계약이 체결된 재화 또는 용역의 배송</li>
								<li>③ 기타 "회사"가 정하는 업무</li>
							</ul>
							<p>2. "회사"는 상품 또는 용역이 품절되거나 기술적 사양의 변경 등으로 더 이상 제공할 수 없는 경우에는 장차 체결되는 계약에 의해 제공할 상품·용역의 내용을 변경할 수 있습니다. 이 경우에는 변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다.</p>
							<p>3. "회사"가 제공하기로 이용자와 계약을 체결한 서비스의 내용을 상품 등의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 방법으로 즉시 통지합니다.</p>
							<p>4. 전항의 경우 "회사"는 이로 인하여 이용자가 입은 손해를 배상합니다. 다만, "회사"가 고의 또는 과실이 없음을 입증한 경우에는 아무런 책임을 부담하지 않습니다.</p>

							<h4>제 5조 (서비스의 중단)</h4>
							<p>1. "회사"는 컴퓨터 등 정보통신설비의 보수점검 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.</p>
							<p>2. 제1항에 의한 서비스 중단의 경우에는 "회사"는 제8조에 정한 방법으로 이용자에게 통지합니다.</p>
							<p>3. "회사"는 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 "회사"의 고의성의 없는 경우에는 배상하지 아니합니다.</p>
						</section>

						<section id="terms03">
							<h3>[제 3장 회원가입 계약]</h3>
							<h4>제 6조 (회원가입)</h4>
							<p>1. 이용자는 무료로 회원에 가입할 수 있으며, "회사"가 정한 가입 양식에 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.</p>
							<p>2. "회사"는 제1항에 따라 회원가입을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.</p>
							<ul class="depth">
								<li>① 가입신청자가 이 약관 제7조 제3항에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 다만 제7조제3항에 의한 회원자격 상실 후 3년이 경과한 자로서 "회사"가 회원 재가입을 승낙한 경우는 예외로 합니다.</li>
								<li>② 등록 내용에 허위, 기재누락, 오기가 있는 경우</li>
								<li>③ 기타 회원으로 등록하는 것이 "회사"의 기술상 현저히 지장이 있다고 판단되는 경우</li>
								<li>④ 만14세 미만의 아동으로서 부모 등 법정대리인의 동의를 얻지 아니한 경우</li>
							</ul>
							<p>3. 회원가입은 "회사"의 승낙이 가입 신청한 이용자에게 도달한 때에 완료됩니다.</p>
							<p>4. "회원"은 "회사"에 등록한 회원정보에 변경이 있는 경우, 즉시 "회사"에서 정하는 방법에 따라 해당 변경사항을 "회사"에게 통지하거나 수정하여야 합니다.</p>

							<h4>제 7조 (회원 탈퇴 및 자격 상실 등)</h4>
							<p>1. 회원은 "회사"에 언제든지 탈퇴를 요청할 수 있으며 "회사"는 즉시 회원 탈퇴를 처리합니다.</p>
							<p>2. 회원이 다음 각호의 사유에 해당하는 경우, "회사"는 회원 자격을 제한 및 정지시킬 수 있습니다.</p>
							<ul class="depth">
								<li>① 가입 신청 시에 허위 내용을 등록한 경우</li>
								<li>② "회사"를 이용하여 구입한 재화 등의 대금, 기타 "회사" 이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우</li>
								<li>③ 타인의 ID와 비밀번호 또는 그 개인정보를 도용한 경우</li>
								<li>④ 다른 사람의 "회사" 이용을 방해하거나 그 정보를 도용하는 등 전자상거래 질서를 위협하는 경우</li>
								<li>⑤ "회사"를 이용하여 법령 또는 이 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우</li>
								<li>⑥ 기타 서비스 운영을 고의로 방해하는 행위를 하는 경우</li>
							</ul>
							<p>3. "회사"가 회원 자격을 제한, 정지 시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정 되지 아니하는 경우 "회사"는 회원 자격을 상실시킬 수 있습니다.</p>
							<p>4. "회사"가 회원 자격을 상실시키는 경우에는 회원 등록을 말소합니다. 이 경우 회원에게 이를 통지하고, 회원 등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다.</p>

							<h4>제 8조 (회원에 대한 통지)</h4>
							<p>1. 회원에 대한 통지를 하는 경우 "회사"는 회원이 등록한 e-mail 주소 또는 SMS 등으로 할 수 있습니다.</p>
							<p>2. "회사"는 불특정 다수 회원에 대한 통지의 경우 서비스 게시판 등에 게시함으로써 개별 통지에 갈음할 수 있습니다.</p>
						</section>

						<section id="terms04">
							<h3>[제 4장 구매계약 및 대금 결제]</h3>
							<h4>제 9조 (구매신청)</h4>
							<p>이용자는 "회사"에서 다음 또는 이와 유사한 방법에 의하여 구매를 신청하며, "회사"는 이용자가 구매신청을 함에 있어서 다음의 각 내용을 알기 쉽게 제공하여야 합니다. 단, 회원인 경우 제2호 내지 제4호의 적용을 제외할 수 있습니다.</p>
							<p>1. 재화 등의 검색 및 선택<br /> 2. 성명, 주소, 전화번호, 이메일 주소(또는 이동전화번호) 등의 입력<br /> 3. 약관내용, 청약 철회권이 제한되는 서비스, 배송료, 설치비 등의 비용부담과 관련한 내용에 대한 확인<br /> 4. 재화 등의 구매신청 및 이에 관한 확인 또는 "회사"의 확인에 대한 동의<br /> 5. 결제 방법의 선택<br /></p>

							<h4>제 10조 (구매계약의 성립)</h4>
							<p>1. "회사"는 제9조 구매신청에 대하여 다음 각 호에 해당하면 승낙하지 않을 수 있습니다. 다만, 미성년자와 계약을 체결하는 경우에는 법정대리인의 동의를 얻지 못하면 미성년자 본인 또는 법정대리인이 계약을 취소할 수 있다는 내용을 고지하여야 합니다.</p>
							<ul class="depth">
								<li>① 신청 내용에 허위, 기재누락, 오기가 있는 경우</li>
								<li>② 미성년자가 담배, 주류 등 청소년보호법에서 금지하는 상품 및 용역을 구매하는 경우</li>
								<li>③ 기타 구매신청을 승낙하는 것이 "회사" 기술상 현저히 지장이 있다고 판단하는 경우</li>
								<li>④ 기타 제반 법령 및 정부의 가이드라인에 위반되는 경우</li>
							</ul>
							<p>2. "회사"의 승낙이 제12조 제1항의 수신확인 통지형태로 이용자에게 도달한 시점에 구매계약이 성립한 것으로 봅니다.</p>
							<p>3. "회사"의 승낙의 의사표시에는 이용자의 구매신청에 대한 확인 및 판매가능 여부, 구매신청의 정정 취소 등에 관한 정보 등을 포함하여야 합니다.</p>
							<h4>제 11조 (지급방법)</h4>
							<p>1. "회사"에서 구매한 상품 또는 용역에 대한 대금지급방법은 다음 각 호의 방법 중 가용한 방법으로 할 수 있습니다. 단, "회사"는 이용자의 지급방법에 대하여 재화 등의 대금에 어떠한 명목의 수수료도 추가하여 징수할 수 없습니다.</p>
							<ul class="depth">
								<li>① 폰뱅킹, 인터넷뱅킹, 메일뱅킹 등의 각종 계좌이체</li>
								<li>② 선불카드, 직불카드, 신용카드 등의 각종 카드 결제</li>
								<li>③ 온라인무통장입금</li>
								<li>④ 전자 화폐에 의한 결제</li>
								<li>⑤ 마일리지 등 "회사"가 지급한 포인트에 의한 결제</li>
								<li>⑥ "회사"와 계약을 맺었거나 "회사"가 인정한 상품권에 의한 결제</li>
								<li>⑦ 기타 전자적 지급 방법에 의한 대금 지급 등</li>
							</ul>
							<p>2. 구매대금의 결제와 관련하여 이용자가 입력한 정보 및 그와 관련된 책임은 이용자에게 있으며, 재화 또는 용역의 청약 후 합리적인 일정 기간 내에 결제가 이루어 지지 않는 경우 "회사"는 이에 해당주문을 취소할 수 있습니다.</p>
							<p>3. "회사"는 구매자의 결제수단에 대하여 정당한 사용권한 보유여부를 확인할 수 있으며 필요한 경우 해당 거래진행의 정지 및 소명자료의 제출을 요청할 수 있습니다.</p>

							<h4>제 12조 (수신확인통지·구매신청 변경 및 취소)</h4>
							<p>1. "회사"는 이용자의 구매신청이 있는 경우 이용자에게 수신확인통지를 합니다.</p>
							<p>2. 수신확인 통지를 받은 이용자는 의사표시의 불일치 등이 있는 경우에는 수신확인통지를 받은 후 즉시 구매신청 변경 및 취소를 요청할 수 있고, "회사"는 배송 전에 이용자의 요청이 있는 경우에는 지체 없이 그 요청에 따라 처리하여야 합니다.</p>
							<p>3. 수신확인 통지를 받은 이용자가 대금을 지불한 경우에는 제 15조의 청약철회 등에 관한 규정에 따릅니다.</p>

							<h4>제 13조 (재화 등의 공급)</h4>
							<p>1. "회사"는 이용자와 재화 등의 공급시기에 관하여 별도의 약정이 없는 이상, 이용자가 청약을 한 날로부터 7일 이내에 재화 등을 배송할 수 있도록 주문제작, 포장 등 기타의 필요한 조치를 취합니다. 다만, "회사"가 이미 재화 등의 대금의 전부 또는 일부를 받은 날부터 2영업일 이내에 조치를 취합니다. 이때 "회사"는 이용자가 재화 등의 공급 절차 및 진행 사항을 확인 할 수 있도록 적절한 조치를 합니다.</p>
							<p>2. 공휴일 및 기타 휴무일 또는 천재지변 등의 불가항력적 사유가 발생하는 경우 그 해당기한은 배송소요기간에서 제외합니다.</p>

							<h4>제 14조 (환급)</h4>
							<p>"회사"는 이용자가 구매 신청한 재화 등이 품절 등의 사유로 인도 또는 제공을 할 수 없을 때에는 지체 없이 그 사유를 이용자에게 통지하고 사전에 재화 등의 대금을 받은 경우에는 대금을 받은 날부터 3영업일 이내에 환급하거나 환급에 필요한 조치를 취합니다.</p>

							<h4>제 15조 (청약 철회 등)</h4>
							<p>1. "회사"와 재화 등의 구매에 관한 계약을 체결한 이용자는 수신확인의 통지를 받은 날로부터 7일 이내에 청약의 철회를 할 수 있습니다. 다만, 통지를 받은 때보다 공급이 늦게 이루어진 경우에는 재화 등의 공급을 받은 날로부터 7일 이내에 청약 철회를 할 수 있습니다.</p>
							<p>2. 이용자는 재화 등을 배송 받은 경우 다음 각호에 해당하는 경우에는 반품 및 교환을 할 수 없습니다.</p>
							<ul class="depth">
								<li>① 이용자의 사용 또는 일부 소비에 의하여 재화 등의 가치가 현저히 감소한 경우</li>
								<li>② 시간의 경과에 의하여 재판매가 곤란할 정도로 재화 등의 가치가 현저히 감소한 경우</li>
								<li>③ 같은 성능을 지닌 재화 등으로 복제가 가능한 경우 그 원본인 재화 등의 포장을 훼손한 경우</li>
								<li>④ 그 밖에 거래의 안전을 위하여 대통령령이 정하는 경우</li>
							</ul>
							<p>3. 제2항제2호 내지 제4호의 경우에는 "회사"가 사전에 청약 철회 등이 제한되는 사실을 소비자가 쉽게 알 수 있는 곳에 명기하거나 시용 상품을 제공하는 등의 조치를 하지 않았다면 이용자의 청약 철회 등이 제한되지 않습니다.</p>
							<p>4. 이용자는 제1항 및 제2항의 규정에도 불구하고 재화 등의 내용이 표시, 광고 내용과 다르거나 계약 내용과 다르게 이행된 때에는 당해 재화 등을 공급받은 날부터 3월 이내, 그 사실을 안 날 또는 알 수 있었던 날부터 30일 이내에 청약 철회 등을 할 수 있습니다.</p>

							<h4>제 16조 (청약 철회 등의 효과)</h4>
							<p>1. "회사"는 이용자로부터 재화 등을 반환 받은 경우 3영업일 이내에 이미 지급받은 재화 등의 대금을 환급 합니다. 이 경우"회사"가 이용자에게 재화 등의 환급을 지연한 때에는 그 지연 기간에 대하여 공정거래 위원회가 정하여 고시하는 지연 이자율을 곱하여 산정한 지연 이자를 지급합니다.</p>
							<p>2. "회사"는 위 대금을 환급함에 있어서 구매자가 신용카드 또는 전자금융거래법 등이 정하는 결제수단으로 재화 등의 대금을 지급한 때에는 지체 없이 당해 결제수단을 제공한 사업자로 하여금 재화 등의 대금의 청구를 정지 또는 취소하도록 요청할 수 있습니다.</p>
							<p>3. 청약 철회 등의 경우 공급 받은 재화 등의 반환에 필요한 비용은 이용자가 부담합니다. "회사"는 이용자에게 청약 철회 등을 이유로 위약금 또는 손해배상을 청구하지 않습니다. 다만 재화 등의 내용이 표시, 광고 내용과 다르거나 계약 내용과 다르게 이행되어 청약 철회 등을 하는 경우 재화 등의 반환에 필요한 비용은 "회사"가 부담합니다.</p>
							<p>4. 이용자가 재화 등을 제공받을 때 발송비를 부담한 경우에 "회사"는 청약 철회 시 그 비용을 누가 부담하는지를 알기 쉽도록 명확하게 표시합니다.</p>
						</section>

						<section id="terms05">
							<h3>[제 5장 계약당사자의 의무]</h3>
							<h4>제 17조 (개인정보보호 및 이용)</h4>
							<p>1. "회사"는 이용자의 정보수집시 서비스의 제공에 필요한 최소한의 정보를 수집합니다. 다음 사항을 필수사항으로 하며 그 외 사항은 선택사항으로 합니다.</p>
							<ul class="depth">
								<li>① 성명</li>
								<li>② 성별, 생년월일 (아이핀 회원은 생년월일, 성별, 아이핀 번호)</li>
								<li>③ 주소</li>
								<li>④ 전화번호 및 이동전화번호</li>
								<li>⑤ 희망 ID (회원의 경우)</li>
								<li>⑥ 비밀번호 (회원의 경우)</li>
								<li>⑦ E-mail(전자우편) 주소</li>
								<li>⑧ 기타 "회사"가 필요하다고 인정하는 사항</li>
							</ul>
							<p>2. "회사"는 이용자의 개인 식별이 가능한 개인 정보를 수집하는 때에는 반드시 당해 이용자의 동의를 받습니다.</p>
							<p>3. 제공된 개인정보는 당해 이용자의 동의 없이 목적 외의 이용이나 제3자에게 제공할 수 없으며, 이에 대한 모든 책임은 "회사"가 집니다. 다만, 다음의 경우는 예외로 합니다.</p>
							<ul class="depth">
								<li>① 배송 업무상 배송 업체에게 배송에 필요한 최소한의 이용자의 정보(성명, 주소, 전화번호)를 알려주는 경우</li>
								<li>② 정보통신서비스의 제공에 관한 계약의 이행을 위하여 필요한 개인정보로서 경제적, 기술적인 사유로 통상의 동의를 받는 것이 현저히 곤란한 경우</li>
								<li>③ 재화 등의 거래에 따른 대금 정산을 위하여 필요한 경우</li>
								<li>④ 도용 방지를 위하여 본인 확인에 필요한 경우</li>
								<li>⑤ 법률의 규정 또는 법률에 의하여 필요한 불가피한 사유가 있는 경우</li>
								<li>⑥ 신속한 이용문의 상담 및 이용자의 불만처리 업무를 대행하는 "회사"에 상담업무에 필요한 이용자의 정보를 제공하는 경우</li>
								<li>⑦ 회원가입 시 동의하신 제휴사별 제휴 업무 진행을 위한 필요로 하는 본인확인을 위한 최소한의 정보(성명, 성별, 생년월일, 주문상품평)를 제휴사에게 제공하는 경우</li>
							</ul>
							<p>4. "회사"가 제2항과 제3항에 의해 이용자의 동의를 받아야 하는 경우에는 개인정보관리 책임자의 신원(소속, 성명 및 전화번호, 기타 연락처), 정보의 수집 목적 및 이용 목적, 제3자에 대한 정보 제공 관련 사항(제공 받은자, 제공 목적 및 제공할 정보의 내용) 등 정보통신망이용촉진등에관한법률 제22조 등에서 규정한 사항을 미리 명시하거나 고지해야 하며 이용자는 언제든지 이 동의를 철회할 수 있습니다.</p>
							<p>5. 이용자는 언제든지 "회사"가 가지고 있는 자신의 개인 정보에 대해 열람 및 오류 정정을 요구할 수 있으며 "회사"는 이에 대해 지체 없이 필요한 조치를 취할 의무를 집니다. 이용자가 오류의 정정을 요구한 경우에는 "회사"는 그 오류를 정정할 때까지 당해 개인정보를 이용하지 않습니다.</p>
							<p>6. "회사"는 개인정보 보호를 위하여 관리자를 한정하여 그 수를 최소화 하며 신용카드, 은행계좌 등을 포함한 이용자의 개인정보의 분실, 도난, 유출, 변조 등으로 인한 이용자의 손해에 대하여 모든 책임을 집니다.</p>
							<p>7. "회사" 또는 그로부터 개인 정보를 제공받는 제3자는 개인정보의 수집 목적 또는 제공받은 목적을 달성한 때에는 당해 개인정보를 지체 없이 파기합니다.</p>
							<p>8. "회사"가 회원의 개인정보를 수집, 이용, 제공 등을 할 경우에는 정보통신망 이용촉진 및 정보보호등에 관한 법률에 따라 회원의 동의를 받습니다.</p>
							<p>9. 회원은 원하는 경우 언제든 "회사"에 제공한 개인정보의 수집과 이용에 대한 동의를 철회할 수 있으며 동의의 철회는 회원 탈퇴를 하는 것으로 이루어 집니다. * 개인정보와 관련된 보다 구체적인 사항은 개인정보취급방침을 따릅니다.</p>

							<h4>제 18조 ("회사"의 의무)</h4>
							<p>1. "회사"는 이 약관이 정하는 바에 따라 지속적이고, 안정적으로 상품 또는 용역을 제공하는데 최선을 다합니다.</p>
							<p>2. "회사"는 이용자가 안전하게 서비스를 이용할 수 있도록 이용자의 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다.</p>
							<p>3. "회사"는 판매하는 상품이나 용역에 대하여 「표시·광고의공정화에관한법률」 제3조 의 규정에 위반하는 표시·광고행위를 함으로써 이용자가 손해를 입은 때에는 이를 배상할 책임을 부담합니다.</p>
							<p>4. "회사"는 수신거절의 의사를 명백히 표시한 이용자에 대해서는 영리목적의 광고성 이메일을 발송하지 않습니다.</p>

							<h4>제 19조 (회원의 ID 및 비밀번호에 대한 의무)</h4>
							<p>1. 제18조의 경우를 제외하고, 회원의 ID와 비밀번호에 관한 관리책임은 회원에게 있습니다.</p>
							<p>2. 회원은 자신의 ID 및 비밀번호를 제3자가 이용하게 해서는 안됩니다.</p>
							<p>3. 회원이 자신의 ID 및 비밀번호를 도난 당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로 "회사"에 통보하고 "회사"의 안내가 있는 경우에는 그에 따라야 합니다.</p>
							<p>4. "회사"는 회원이 상기 제1항, 제2항, 제3항을 위반하여 회원에게 발생한 손해에 대하여 아무런 책임을 부담하지 않습니다.</p>

							<h4>제 20조 (이용자의 의무)</h4>
							<p>이용자는 다음 행위를 하여서는 안됩니다.</p>
							<p>1. 개인정보의 등록(변경의 경우를 포함함)시 허위내용을 등록 <br /> 2. "회사"에 게시된 정보를 임의로 변경 <br /> 3. "회사"가 허락하지 않은 정보(컴퓨터 프로그램 등)의 송신 또는 게시<br /> 4. "회사" 기타 제3자의 저작권 등 지적재산권에 대한 침해<br /> 5. "회사" 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위<br /> 6. 외설 또는 폭력적인 메시지·화상·음성 기타 공서양속에 반하는 정보를 화면에 공개 또는 게시하는 행위</p>
						</section>

						<section id="terms06">
							<h3>[제 6장 부가서비스의 이용]</h3>
							<h4>제 21조 (마일리지)</h4>
							<p>1. "회사"는 회원이 상품을 구매하거나, 상품 후기를 작성하는 등의 경우 회원에게 일정한 마일리지를 부여할 수 있습니다. 그 구체적인 운영방법은 "회사"의 운영정책에 의합니다.</p>
							<p>2. 마일리지는 상품 구매시 사용가능 기준 하에 현금가액과 동일하게 사용할 수 있으나 (단 사용불가 사전고지품목 제외), 현금으로 환불되지는 않습니다. 또한, 마일리지 서비스는 회원에게만 제공되며 타인에게 양도할 수 없습니다.</p>
							<p>3. 부여된 마일리지는 5년간 유효하며, 기한내 사용하지 않은 마일리지는 소멸됩니다.</p>
							<p>4. 회원을 탈퇴한 경우 마일리지는 소멸됩니다.</p>
							<p>5. 부정한 방법으로 포인트를 획득한 사실이 확인될 경우 "회사"는 회원의 포인트 회수, ID(고유번호) 삭제 및 형사 고발 등 기타 조치를 취할 수 있습니다.</p>

							<h4>제 22조 (예치금)</h4>
							<p>1. "회사"에서 구입한 상품을 반품 또는 취소하였을 때 회원이 원할 경구 환불 금액을 예치금으로 환불 받을 수 있습니다.</p>
							<p>2. 예치금은 해당금액을 차후 상품 구매시 현금처럼 사용 할 수 있으며 회원이 원하는 경우 현금으로 돌려받으실 수 있습니다.</p>
							<p>3. 예치금은 사용 유효기간이 없으며 최소 구매 금액 제한없이 사용 가능합니다.</p>

							<h4>제 23조 (Gift카드)</h4>
							<p>1. 텐바이텐 Gift카드는 "회사"에서 발행한 무기명 선불카드로 일정 금액만큼 사용하실 수 있는 카드로 "회사"가 정한 소정의 방법에 의해 구매하실 수 있습니다. 지정하는 공식 판매처에서만 구매하실 수 있으며 이외의 곳에서 구매 하실 경우 어떠한 책임도 부담하지 않습니다.</p>
							<p>2. 온라인에서 물품이나 용역을 구매하기 위해서는 "회사"가 정한 방법에 따라 해당 Gift카드를 인터넷사용 등록해야 합니다.</p>
							<p>3. Gift카드 권면 금액이 1만원 초과일 경우 100분의 60 사용시, 1만원 이하일 경우 100분의 80 이상 사용시에는 텐바이텐 온라인에서는 예치금으로 전환 받을 수 있으며 이 조건을 충족하지 못할 경우에는 잔액 환급이 되지 않습니다.</p>
							<p>4. Gift카드의 유효기한은 5년이고, 유효기한이 경과된 Gif 카드는 사용하실 수 없습니다. * Gift카드와 관련된 보다 구체적인 사항은 Gift카드이용약관을 따릅니다.</p>

							<h4>제 24조 (상품쿠폰)</h4>
							<p>1. "회사"는 구매서비스를 이용하는 회원에게 지정된 상품 구매 시 일정액 또는 일정비율을 할인 받을 수 있는 상품쿠폰을 발급할 수 있습니다.</p>
							<p>2. 회원은 상품쿠폰을 회원 본인의 구매에 한해서만 사용할 수 있으며, 어떠한 경우에도 이를 타인에게 실질적으로 매매 또는 양도할 수 없습니다.</p>
							<p>3. 상품쿠폰은 일부 품목이나 금액에 따라 사용이 제한될 수 있으며, 유효기간이 지난 후에는 사용할 수 없습니다.</p>
							<p>4. 회원을 탈퇴한 경우 상품쿠폰은 소멸됩니다.</p>

							<h4>제 25조 (보너스쿠폰)</h4>
							<p>1. "회사"는 구매서비스를 이용하는 회원에게 상품 구매 시(단 사용불가 사전고지품목 제외) 일정액 또는 일정비율을 할인 받을 수 있는 보너스쿠폰을 발급할 수 있습니다.</p>
							<p>2. 회원은 보너스쿠폰을 회원 본인의 구매에 한해서만 사용할 수 있으며, 어떠한 경우에도 이를 타인에게 실질적으로 매매 또는 양도할 수 없습니다.</p>
							<p>3. 보너스쿠폰은 일부 품목이나 금액에 따라 사용이 제한될 수 있으며, 유효기간이 지난 후에는 사용할 수 없습니다.</p>
							<p>4. 회원을 탈퇴한 경우 보너스쿠폰은 소멸됩니다.</p>

							<h4>제 26조 (멤버십 카드)</h4>
							<p>1. "회사"는 회원이 매장에서 상품을 구매하는 경우 일정한 포인트를 멤버십카드에 부여할 수 있습니다. (단, 할인상품은 포인트를 부여하지 않습니다) 구체적인 운영방법은 "회사"의 운영정책에 의합니다.</p>
							<p>2. 부여된 포인트는 매장에서 사용가능 기준하에 현금과 동일하게 사용할 수 있으며 (단, 사전불가 사전고시 품목 제외) 현금으로 환불되지는 않습니다. 또한 포인트 서비스는 회원에게만 제공되며 타인에게 양도할 수 없습니다.</p>
							<p>3. 부여된 포인트는 5년간 유효하며, 기한 내 사용하지 않은 포인트는 소멸됩니다.</p>
							<p>4. 회원 탈퇴시 포인트는 소멸됩니다.</p>
							<p>5. 부정한 방법으로 포인트를 획득한 사실이 확인될 경우 "회사"는 회원의 포인트 회수, ID(고유번호) 삭제 및 형사 고발 등 기타 조치를 취할 수 있습니다.</p>
						</section>

						<section id="terms07">
							<h3>[제 7장 기타]</h3>
							<h4>제 27조 (저작권의 귀속 및 게시물 이용 제한)</h4>
							<p>1. "회사"가 작성한 저작물에 대한 저작권 기타 지적 재산권은 "회사"에 귀속합니다.</p>
							<p>2. 이용자는 서비스를 이용함으로써 얻은 정보를 "회사"의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.</p>
							<p>3. "회사"는 약정에 따라 이용자에게 귀속된 저작권을 사용하는 경우 당해 이용자에게 통보하여야 합니다.</p>
							<p>4. 회사는 회원이 서비스 내에 게시한 게시물이 타인의 저작권, 프로그램저작권 등을 침해하였음을 이유로 "회사"가 타인으로부터 손해배상청구 등 이의 제기를 받은 경우 회원은 "회사"의 면책을 위하여 노력하여야 하며, "회사"가 면책되지 못한 경우 회원은 그로 인해 "회사"에 발생한 모든 손해를 부담하여야 합니다.</p>
							<p>5. "회사"는 회원이 서비스 내에 게시한 게시물(회원간 전달 포함)이 다음 각 호의 경우에 해당한다고 판단되는 경우 사전통지 없이 삭제, 변경할 수 있으며, 이에 대해 "회사"는 어떠한 책임도 지지 않습니다.</p>
							<ul class="depth">
								<li>① 스팸(spam)성 게시물 및 상업성 게시물 (예: 행운의 편지, 특정사이트 광고 등)</li>
								<li>② 타인을 비방할 목적으로 허위 사실을 유포하여 타인의 명예를 훼손하는 글</li>
								<li>③ 동의 없는 타인의 신상공개, 제3자의 저작권 등 권리를 침해하는 내용, 기타 게시판 주제와 다른 내용의 게시물</li>
								<li>④ 기타 관계 법령 및 "회사"의 지침 등에 위반된다고 판단되는 경우</li>
							</ul>

							<h4>제 28조 (면책)</h4>
							<p>1. "회사"는 천재지변, 불가항력 기타 "회사"의 합리적인 통제범위를 벗어난 사유로 인하여 서비스를 제공할 수 없는 경우에는 그에 대한 책임을 부담하지 않습니다.</p>
							<p>2. "회사"는 이용자의 귀책사유로 인하여 서비스를 제공할 수 없는 경우에는 그에 대한 책임을 부담하지 않습니다.</p>
							<p>3. "회사"는 이용자가 서비스를 이용함으로써 기대되는 수익을 얻지 못하거나 서비스를 통해 얻은 자료를 이용하여 발생한 손해에 대해서는 책임을 부담하지 않습니다.</p>
							<p>4. 이용자가 화면에 게재한 정보, 자료, 사실 등의 내용에 관한 신뢰도 또는 정확성에 대하여는 해당 이용자가 책임을 부담하며, "회사"는 내용의 부정확 또는 허위로 인해 이용자 또는 제3자에게 발생한 손해에 대하여는 아무런 책임을 부담하지 않습니다.</p>
							<p>5. "회사"는 서비스 이용과 관련하여 이용자의 고의 또는 과실로 인하여 이용자 또는 제3자에게 발생한 손해에 대하여는 아무런 책임을 부담하지 않습니다.</p>

							<h4>제 29조 (사이트의 연결)</h4>
							<p>1. 타 사이트에 하이퍼링크(하이퍼링크의 대상에는 문자, 그림 및 동화상 등이 포함됨)방식 등에 의해 연결시킬 수 있습니다.</p>
							<p>2. "회사"는 이용자가 해당 연결사이트와 독자적으로 상품 또는 용역을 거래한 행위에 대해서는 아무런 책임을 부담하지 않습니다.</p>

							<h4>제 30조 (정보의 제공 및 광고의 게재)</h4>
							<p>1. "회사"는 서비스를 운영함에 있어 각종 정보를 서비스 화면에 게재하거나 e-mail 및 서신우편 등의 방법으로 회원에게 제공할 수 있습니다.</p>
							<p>2. "회사"는 서비스의 운영과 관련하여 홈페이지, 서비스 화면, SMS, e-mail등에 광고 등을 게재할 수 있습니다.</p>
							<p>3. 회원이 서비스상에 게재되어 있는 광고를 이용하거나 서비스를 통한 광고주의 판촉활동에 참여하는 등의 방법으로 교신 또는 거래를 하는 것은 전적으로 회원과 광고주 간의 문제입니다. 만약 회원과 광고주간에 문제가 발생할 경우에도 회원과 광고주가 직접 해결하여야 하며, 이와 관련하여 "회사"는 어떠한 책임도 지지 않습니다.</p>

							<h4>제 31조 (분쟁해결)</h4>
							<p>1. "회사"는 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구인 고객행복센터를 설치·운영합니다.</p>
							<p>2. "회사"는 이용자로부터 제출되는 불만사항 및 의견을 우선적으로 처리합니다. 다만, 신속한 처리가 곤란한 경우에는 이용자에게 그 사유와 처리일정을 즉시 통보합니다.</p>
							<p>3. "회사"와 이용자간에 발생한 전자상거래 분쟁과 관련하여 이용자의 피해구제신청이 있는 경우에는 공정거래위원회 또는 시.도지사가 의뢰하는 분쟁조정기관의 조정에 따를 수 있습니다.</p>

							<h4>제 32조 (재판권 및 준거법)</h4>
							<p>1. "회사"와 이용자간에 발생한 전자상거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.</p>
							<p>2. "회사"와 이용자간에 제기된 전자상거래 소송에는 대한민국법을 적용합니다.</p>

							<h4>부칙(2015.6.8)</h4>
							<p>본 약관은 2015년 6월 15일부터 적용됩니다.</p>
							<p class="tPad05"><a href="viewUsageTerms_20150605.asp" style="text-decoration:underline;">이전약관 보기</a></p>
						</section>
					</div>
				</div>
				<!--// 이용약관 -->
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>