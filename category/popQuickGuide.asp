<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<div class="layerPopup">
	<div class="popWin">
		<header class="tenten-header header-popup">
			<div class="title-wrap">
				<h1>바로배송 안내</h1>
				<button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
			</div>
		</header>
		<div id="layerScroll" class="content" style="top:0;">
			<div id="scrollarea">
			    <div class="quick-guide">
            		<div class="info">
            			<span class="icon icon-quick"></span>
            			<h2>바로배송이란?</h2>
            			<p>오전에 주문한 상품을 그날 오후에 바로 받자!<br />서울 전 지역 한정, 오후 1시까지 주문/결제를 완료할 경우<br />신청할 수 있는 퀵배송 서비스입니다.</p>
						<% IF (now()<#19/07/2018 00:00:00#) then %>																
<!-- 배송료 할인 이벤트 기간 중 노출 --><p class="price">바로배송 배송료 : <s>5,000원</s> <em class="color-red">2,500원</em><br /><span>(오픈기념 이벤트 할인중, 2018년 7월 18일까지)</span></p>										
						<%Else%>
							<p class="price">바로배송 배송료 : 5,000원</p>										
						<%End if%>
            			<a href="/shoppingtoday/quick_list.asp" class="btn btn-xsmall color-black btn-radius btn-icon">바로배송 상품 전체보기<span class="icon icon-arrow"></span></a>
            		</div>
            		<div class="noti">
            			<h2>유의사항</h2>
            			<ul>
            				<li>바로배송은 배송지가 서울 지역일 경우 가능합니다.</li>
            				<li>주문 당일 오후 1시전 결제완료된 주문에만 신청 가능하며,<br />오후 1시 이후 신청 시 다음날 배송이 시작됩니다.</li>
            				<li>더욱 더 빠른 배송 서비스를 위해 주말/공휴일에는 쉽니다.</li>
            				<li>상품의 부피/무게에 따라 배송 유/무 또는 요금이 달라질 수 있습니다.</li>
            				<li>바로배송 서비스에는 무료배송쿠폰을 적용할 수 없습니다.</li>
            				<li>회사 또는 사무실로 주문하시는 경우, 퇴근 시간 이후 배송될 수도 있습니다. 오후 늦게라도 상품 수령이 가능한 주소지를 입력해주시면 감사하겠습니다.</li>
            			</ul>
            		</div>
            	</div>
            	
			</div>
		</div>
	</div>
</div>