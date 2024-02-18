<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
dim deliveryDIV : deliveryDIV = request("deliverydiv")
%>
<div class="layerPopup">
	<div class="popWin">
        <header class="tenten-header header-popup">
            <div class="title-wrap">
                <h1>배송 안내</h1>
                <button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
            </div>
        </header>
        <!-- contents -->
        <div id="layerScroll" class="content" style="top:0;overflow-y:scroll;">
            <div class="delivery-guide">
                <% if deliveryDIV="D" then %>
                <div class="section">
                    <h2>오늘 출고가 되지 않는다면<br>쇼핑지원 마일리지 <em>2,500P</em>를 선물할게요🎁</h2>
                    <div>오후 3시 이전에 결제를 완료하신 모든 분들께 빠르게 상품을 보내 드리고 싶지만, 부득이한 사정으로 인해 출고가 지연되는 경우가 있습니다.<br>이런 경우 텐텐의 아쉬운 마음을 담아 쇼핑지원 마일리지를 선물해드리고 있으니 잊지 말고 꼭 사용해 주세요 :)</div>
                </div>
                <div class="section noti">
                    <h3>유의사항 안내</h3>
                    <ul>
                        <li>'텐바이텐 배송 - 오후 3시 이전 결제완료 시 오늘 출고' 메시지가 표기된 상품에만 적용됩니다.</li>
                        <li>평일 오후 3시 이전 결제를 완료하였지만 결제 당일 출고되지 않은 주문 1건에 1회만 적용됩니다. (상품 1건당 1회 적용이 아닌 주문 1건당 1회 적용임을 유의해 주세요)</li>
                        <li>예약배송 및 주문/제작 상품은 당일출고를 지원하지 않습니다.</li>
                        <li>텐바이텐 배송이지만 당일출고 지원 상품과 미지원 상품을 함께 묶어 주문할 경우 당일출고를 지원하지 않습니다.</li>
                        <li>'무통장 입금'의 경우 '입금'이 아닌 '입금확인' 상태를 '결제완료' 시점으로 보고 있습니다.</li>
                        <li>주말을 포함한 공휴일 및 업무 진행이 불가한 텐바이텐 휴일에는 당일출고 서비스를 지원하지 않습니다.</li>
                        <li>쇼핑지원 마일리지의 사용 기한은 지급일로부터 30일입니다.</li>
                        <li>당일출고가 되더라도 택배사의 사정으로 인해 배송이 지연되는 경우가 있습니다. 이 점 양해 부탁드립니다.</li>
                    </ul>
                </div>
                <div class="section">
                    <h2>도서산간지역 배송 안내</h2>
                    <div>도서산간지역의 경우 추가 운임료가 부과되며 1~3일의 배송일이 더 소요 될 수 있습니다.</div>
                </div>
                <div class="section">
                    <h2>텐바이텐 해외배송 안내</h2>
                    <div>텐바이텐 배송 상품은 우체국 EMS를 통한 해외배송 서비스를 지원하고 있습니다. 해외배송 이용 방법은 다음과 같습니다.</div>
                    <ol>
                        <li>1. 텐바이텐 배송 상품을 장바구니에 담기</li>
                        <li>2. 장바구니로 이동하기</li>
                        <li>3. 상단의 해외배송 버튼을 선택하기</li>
                        <li>4. 주문/결제 진행하기</li>
                    </ol>
                </div>
                <% else %>
                <div class="section">
                    <h2>도서산간지역 배송 안내</h2>
                    <div>도서산간지역의 경우 추가 운임료가 부과되며 1~3일의 배송일이 더 소요 될 수 있습니다.</div>
                </div>
                <div class="section">
                    <h2>텐바이텐 해외배송 안내</h2>
                    <div>텐바이텐 배송 상품은 우체국 EMS를 통한 해외배송 서비스를 지원하고 있습니다. 해외배송 이용 방법은 다음과 같습니다.</div>
                    <ol>
                        <li>1. 텐바이텐 배송 상품을 장바구니에 담기</li>
                        <li>2. 장바구니로 이동하기</li>
                        <li>3. 상단의 해외배송 버튼을 선택하기</li>
                        <li>4. 주문/결제 진행하기</li>
                    </ol>
                </div>
                <% end if %>
            </div>
        </div>
	</div>
</div>