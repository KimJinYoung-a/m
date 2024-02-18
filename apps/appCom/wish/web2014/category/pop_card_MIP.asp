<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="viewport-fit=cover, width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
.discount{padding:.3rem;}
.discount table{margin-bottom:3rem;border-top:0.3rem solid #333;border-collapse: collapse;}
.discount table caption{font-size:1.6rem;font-weight:bold;text-align:left;margin-bottom:1.3rem;}
.discount table th, .discount table td{font-size:.7rem;text-align:center;padding:0.2rem;line-height:1.8;border-right:1px solid #eee;border-bottom:1px solid #eee;}
.discount table th:last-child, .discount table td.no-border{border-right:0;}
.discount table tr{border-bottom:1px solid #eee;}
.discount h2{font-size:1.6rem;font-weight:bold;text-align:left;margin-bottom:1.3rem;}
.discount ul{list-style: none;padding-left:0;}
.discount .discount_noti ul li{padding-left:1rem;position:relative;margin-bottom:0.5rem;line-height: 1.8;font-size:.8rem;}
.discount .discount_noti ul li::before{content:'-';display:block;position:absolute;left:0;}
</style>
</head>
<body>
<div class="modalV20 modal_type4 show discount">
	<div class="modal_wrap">
		<div class="modal_body">
			<div class="boardList Board1 row_4th">
				<table class="tb_discount">
					<caption>카드사 무이자 할부</caption>
					<colgroup>
						<col width="10%">
						<col width="20%">
						<col width="20%">
						<col width="22%">
						<col width="13%">
						<col width="15%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">기간</th>
							<th scope="col">카드사</th>
							<th scope="col">할부적용<br>금액</th>
							<th scope="col">할부개월</th>
							<th scope="col">신청<br>방법</th>
							<th scope="col">비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td rowspan="10" class="date">22.2.1~<br>2.28</td>
							<td>롯데카드</td>
							<td rowspan="10">5만원<br>이상</td>
							<td>2~4개월</td>
							<td rowspan="10">자동</td>
							<td class="no-border" rowspan="10">PG<br>업종만<br>제공</td>
						</tr>
						<tr>
							<td>현대카드</td>
							<td>2~7개월</td>
						</tr>
						<tr>
							<td>KB<br>국민카드</td>
							<td>2~7개월</td>
						</tr>
						<tr>
							<td>신한카드</td>
							<td>2~7개월</td>
						</tr>
						<tr>
							<td>삼성카드</td>
							<td>2~6개월</td>
						</tr>
						<tr>
							<td>비씨카드</td>
							<td>2~7개월</td>
						</tr>
						<tr>
							<td>NH<br>농협카드</td>
							<td>2~6개월 (~1.25)<br><b>2~8개월 (1.26~2.28)</b></td>
						</tr>
						<tr>
							<td>하나카드</td>
							<td>2~8개월</td>
						</tr>
						<tr>
							<td>전북카드</td>
							<td>2~5개월</td>
						</tr>
						<tr>
							<td>광주카드</td>
							<td>2~7개월</td>
						</tr>
					</tbody>
				</table>

				<table class="tb_discount tb_discount02">
					<caption>
						부분 무이자 할부
					</caption>
					<colgroup>
						<col width="5%">
						<col width="16%">
						<col width="14%">
						<col width="16%">
						<col width="17%">
						<col width="20%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">기간</th>
							<th scope="col">카드사</th>
							<th scope="col">할부<br>개월</th>
							<th scope="col">고객부담</th>
							<th scope="col">면제</th>
							<th scope="col">신청방법</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td rowspan="22" class="date">22.2.1~<br class="m_view">2.28</td>
							<td rowspan="4">삼성카드</td>
							<td>10개월</td>
							<td>1~4회차</td>
							<td>5~10회차</td>
							<td rowspan="10">별도 신청 <br   class="m_view">없이 적용</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~5회차</td>
							<td>6~12회차</td>
						</tr>
						<tr>
							<td>18개월</td>
							<td>1~7회차</td>
							<td>8~18회차</td>
						</tr>
						<tr>
							<td>24개월</td>
							<td>1~9회차</td>
							<td>10~24회차</td>
						</tr>
						<tr>
							<td rowspan="2">신한카드</td>
							<td>10개월</td>
							<td>1~4회차</td>
							<td>5~10회차</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~5회차</td>
							<td>6~12회차</td>
						</tr>
						<tr>
							<td rowspan="2">KB<br>국민카드</td>
							<td>10개월</td>
							<td>1~3회차</td>
							<td>4~10회차</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~4회차</td>
							<td>5~12회차</td>
						</tr>
						<tr>
							<td rowspan="2">하나카드</td>
							<td>10개월</td>
							<td>1~3회차</td>
							<td>4~10회차</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~4회차</td>
							<td>5~12회차</td>
						</tr>
						<tr>
							<td rowspan="6">비씨카드</td>
							<td>10개월</td>
							<td>1~3회차</td>
							<td>4~10회차</td>
							<td rowspan="2">별도 신청 <br   class="m_view">없이 적용</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~4회차</td>
							<td>5~12회차</td>
						</tr>
						<tr>
							<td>9개월</td>
							<td>1~2회차</td>
							<td>3~9회차</td>
							<td rowspan="4">
								<p>
								비씨 APP <br>및 ARS<br>사전 신청
								<br>고객에 한함<br>(비씨카드 : <br>1899-5772)
								</p>
							</td>
						</tr>
						<tr>
							<td>10개월</td>
							<td>1~2회차</td>
							<td>3~10회차</td>
						</tr>
						<tr>
							<td>11개월</td>
							<td>1~3회차</td>
							<td>4~11회차</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~3회차</td>
							<td>4~12회차</td>
						</tr>
						<tr>
							<td rowspan="6">NH<br>농협카드</td>
							<td>10개월</td>
							<td>1~3회차</td>
							<td>4~10회차</td>
							<td rowspan="2">별도 신청 <br>없이 적용</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~4회차</td>
							<td>5~12회차</td>
						</tr>
						<tr>
							<td>9개월</td>
							<td>1~2회차</td>
							<td>3~9회차</td>
							<td rowspan="4">
								<p>
								ARS 사전 <br>신청 고객에 한함<br>(NH농협카드 : 1644-2009)
								</p>
							</td>
						</tr>
						<tr>
							<td>10개월</td>
							<td>1~2회차</td>
							<td>3~10회차</td>
						</tr>
						<tr>
							<td>11개월</td>
							<td>1~3회차</td>
							<td>4~11회차</td>
						</tr>
						<tr>
							<td>12개월</td>
							<td>1~3회차</td>
							<td>4~12회차</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="discount_noti">
				<h2>유의사항</h2>
				<ul>
					<li>
					법인(기업), 체크, 선불, 기프트, 은행계열카드 (BC마크가 없는 NON
					BC카드 불가)제외 (EX&gt;수협카드 등)
					</li>
					<li>
					직계약 가맹점, 상점부담 무이자 가맹점, 특별제휴가맹점, 오프라인
					가맹점, 신규 가맹점 등 일부 제외
					</li>
					<li>본 행사는 카드사 사정에 따라 변경 또는 중단될 수 있음</li>
					<li>무이자 할부 결제시 포인트, 마일리지 적립 제외</li>
					<li>개인간 안전거래 이니 P2P 서비스 제외</li>
					<li>TASF 취급 수수료 거래 하나카드 제외</li>
					<li>
					온라인 PG업종 해당하는 무이자로 이 외 업종은 적용 불가 (제약,
					등록금, 도시가스 등)
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>