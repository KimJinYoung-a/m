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
						<a href="#">결제</a>
						<a href="#" class="active">배송지</a>
					</div>

					<div class="diff-10"></div>
					<table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>받으시는 분</th>
							<td class="t-l">홍길동</td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td class="t-l">010-1234-3494</td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td class="t-l">02-3844-3494</td>
						</tr>
						<tr>
							<th>주소</th>
							<td class="t-l">경기도 포천시 포천읍 123-11</td>
						</tr>
						<tr>
							<th>배송 유의사항</th>
							<td class="t-l">부재시 경비실에</td>
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