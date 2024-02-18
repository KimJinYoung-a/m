<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 개인정보 수집 이용안내
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
	    <!--
		<div class="header">
			<h1>개인정보처리방침</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnAPPclosePopup();">닫기</button></p>
		</div>
		-->
		<!-- content area -->
			<div class="content indivi-policy" id="contentArea">
				<!-- 청소년보호정책 -->
				<div class="inner5">
					<h2 class="tit01 tMar20">청소년보호정책</h2>
					<div class="policyCont">
						<div class="tPad20 lh14">(주)텐바이텐(“회사” 또는 “텐바이텐”이라 함)은 각종 청소년유해정보로부터 19세 미만의 청소년들을 보호하기 위하여 [청소년보호법], [정보통신망이용촉진및정보보호등에관한법률], [정보통신윤리위원회 심의규정 및 청소년유해매체물기준] 등 관계법률에 근거하여 만 19세 미만의 청소년들이 유해정보에 접근할 수 없도록 청소년보호정책을 시행하여 청소년에게 유익한 환경을 조성하기 위해 노력하고 있습니다.</div>
						<section id="youth1">
							<h3">제 1조 (​청소년 보호의 기본 원칙​)</h3>
							<p>회사는 유익한 환경을 조성하여 청소년이 유해한 환경으로부터 보호받도록 노력하며, 안전하게 이용할 수 있는 서비스를 제공하기 위해 청소년보호정책을 명시하고 있습니다.</p>
						</section>

						<section id="youth2">
							<h3>제 2조 (​청소년 보호장치​)</h3>
							<p>회사는 성인인증 장치운영 및 청소년 유해매체물의 표시를 적용하여 청소년에 대한 유해정보의 접근가능성 및 노출을 사전에 예방하고 있으며 청소년 유해상품(유해매체물, 유해약물, 유해물건등)의 구매도 엄격히 금지하고 있습니다.</p>
						</section>

						<section id="youth3">
							<h3>제 3조 (​유해정보로 인한 피해상담 및 고충처리​)</h3>
							<p>회사는 청소년 유해정보와 유해상품의 유통으로 인한 피해상담 및 고충처리를 위해 청소년 민원처리부서를 두고 있습니다.</p>
							<p class="tPad20">[청소년 민원처리부서]</p>
							<ul>
								<li>- 부서명 : 고객센터</li>
								<li>- 전자우편 : <a href="mailto:​customer@10x10.co.kr">​customer@10x10.co.kr</a></li>
								<li>- 전화번호 : 1644-6030(대표상담)</li>
								<li>- 팩스번호 : 02-3493-1032</li>
							</ul>
						</section>

						<section id="youth4">
							<h3>제 4조 (청소년 보호 책임자 및 담당자)</h3>
							<p>회사는 아래와 같이 청소년보호책임자 및 청소년보호담당자를 지정하여 청소년 유해정보의 차단 및 관리, 청소년 유해정보로부터의 청소년보호정책을 수립하는 등 청소년 보호업무를 수행하고 있습니다.</p>
							<div class="boardList">
								<table style="width:100%;">
									<caption>청소년보호책임자 및 청소년보호담당자</caption>
									<colgroup>
										<col width="20%" /><col width="40%" /><col width="40%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">구분</th>
											<th scope="col">청소년보호책임자</th>
											<th scope="col">청소년보호담당자</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>성명</td>
											<td>이문재</td>
											<td>허진원</td>
										</tr>
										<tr>
											<td>소속</td>
											<td>영업지원부문</td>
											<td>영업지원부문</td>
										</tr>
										<tr>
											<td>직위</td>
											<td>부문장</td>
											<td>부장</td>
										</tr>
										<tr>
											<td>전화번호</td>
											<td>02-554-2033</td>
											<td>02-554-2033</td>
										</tr>
										<tr>
											<td>팩스번호</td>
											<td>02-2179-9245</td>
											<td>02-2179-9245</td>
										</tr>
										<tr>
											<td>이메일</td>
											<td><a href="matilto:moon@10x10.co.kr">moon@10x10.co.kr</a></td>
											<td><a href="matilto:kobula@10x10.co.kr">kobula@10x10.co.kr</a></td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>
					</div>
				</div>
				<!--// 개인정보처리방침 -->
			</div>
			<!-- //content area -->
		<span id="gotop" class="goTop">TOP</span>
		<!-- //content area -->
	</div>
</div>
</body>
</html>