<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">

			<!-- #content -->
			<div id="content">
				<div class="inner">
					<div class="diff"></div>
					<div class="main-title">
						<h1 class="title"><span class="label">주문 상세내역</span></h1>
					</div>
				</div>
				<div class="well type-b">
					<ul class="txt-list">
						<li>최근 2개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
						<li>2개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다. </li>
					</ul>
				</div>
				<div class="inner">
					<div class="bordered-box">
						<div class="box-meta">
							<span class="date">2013.12.12</span>
							<span class="box-title">주문번호(1234123)</span>
						</div>
					</div>
					<div class="diff"></div>
					<div class="tabs type-c four">
						<a href="#">주문상품</a>
						<a href="#">구매자</a>
						<a href="#" class="active">결제</a>
						<a href="#">배송지</a>
					</div>

					<div class="diff-10"></div>
					<table class="filled">
						<colgroup>
							<col width="140"/>
							<col/>
						</colgroup>
						<tr>
							<th>결제방법</th>
							<td class="t-l">신용카드</td>
						</tr>
						<tr>
							<th>결제확인일시</th>
							<td class="t-l">2014-01-01 오후 02:11:11</td>
						</tr>
						<tr>
							<th>마일리지 사용금액</th>
							<td class="t-l">0<span class="unit">Point</span></td>
						</tr>
						<tr>
							<th>할인권 사용금액</th>
							<td class="t-l">0<span class="unit">원</span></td>
						</tr>
						<tr>
							<th>총 결제금액</th>
							<td class="t-l">14,400<span class="unit">원</span></td>
						</tr>
						<tr>
							<th>마일리지 적립금액</th>
							<td class="t-l">144<span class="unit">Point</span></td>
						</tr>
					</table>
					
					<div class="diff"></div>
				</div>
			</div><!-- #content -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>