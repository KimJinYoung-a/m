<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<style>
.modalV20.discount .modal_wrap{height:101%;border-radius: 0;}
.discount .modal_body{padding:0 1rem;overflow:scroll;}
.discount .boardList{font-size:.9rem;margin:1rem 0;}
.discount .boardList table{text-align:center;border-top:0.3rem solid #555;border-bottom:1px solid #ccc;width:100%;}
.discount .boardList table.tb_discount02{margin-top:3rem;}
.discount .boardList table caption{text-align:left;font-size:2rem;font-weight:bold;margin-bottom:1rem;}
.discount .boardList table thead th{border-bottom:1px solid #ccc;}
.discount .boardList table th{padding:0.7rem 0;color:#555;border-top:1px solid #ccc;vertical-align:middle;line-height:1.3;border-right:1px solid #eee;}
.discount .boardList table th:last-child, .discount .Board1.row_4th table tr td:last-child{border-right:0;}
.discount .Board1.row_4th table tr td{padding:0.5rem; text-align:center; vertical-align:middle; word-break:keep-all;border-top:1px solid #eee;border-right:1px solid #eee;line-height:1.3;}
.discount .Board1.row_4th table tr td:first-child, .discount .Board1.row_4th table tr td:nth-child(2), .discount .Board1.row_4th table tr td:nth-child(3){border-right:1px solid #eee;}
.discount .Board1.row_4th table tr td b{font-weight:bold;}
.discount .discount_noti{margin:3rem 0 5rem;}
.discount .discount_noti h2{text-align:left;font-size:1.3rem;font-weight:bold;margin-bottom:1rem;}
.discount .discount_noti ul li{padding-left:1rem;position:relative;margin-bottom:0.5rem;line-height: 1.3;}
.discount .discount_noti ul li::before{content:'-';display:block;position:absolute;left:0;}
</style>
<div class="modalV20 modal_type4 show discount">
	<div class="modal_overlay"></div>
	<div class="modal_wrap">
		<div class="modal_header">
			<h2>모달</h2>
			<button class="btn_close" onclick="fnCloseModal();"><i class="i_close"></i>모달닫기</button>
		</div>
		<div class="modal_body">
			<div class="boardList Board1 row_4th">
				<table class="tb_discount">
					<caption>카드사 무이자 할부</caption>
					<colgroup>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
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
							<td rowspan="10" class="date">22.2.1~<br class="m_view">2.28</td>
							<td>롯데카드</td>
							<td rowspan="10">5만원 이상</td>
							<td>2~4개월</td>
							<td rowspan="10">자동</td>
							<td rowspan="10">PG업종만<br class="m_view">제공</td>
						</tr>
						<tr>
							<td>현대카드</td>
							<td>2~7개월</td>
						</tr>
						<tr>
							<td>KB국민카드</td>
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
							<td>NH농협카드</td>
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
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th scope="col">기간</th>
							<th scope="col">카드사</th>
							<th scope="col">할부개월</th>
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
							<td rowspan="2">KB국민카드</td>
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
								비씨 APP 및 ARS <br   class="m_view">사전 신청
								<br class="m_view">고객에 한함<br   class="m_view"><br  >(비씨카드 : <br   class="m_view">1899-5772)
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
							<td rowspan="6">NH<br   class="m_view">농협카드</td>
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
								ARS 사전 신청 <br   class="m_view">고객에 한함<br   class="m_view"><br  >(NH농협카드 : <br   class="m_view">1644-2009)
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
