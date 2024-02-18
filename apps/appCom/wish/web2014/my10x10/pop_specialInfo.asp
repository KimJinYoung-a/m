<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10</title>
<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon">
<link rel="icon" href="../favicon.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="../css/style.css">
<script type="text/javascript" src="../js/jquery-latest.js"></script>
<script type="text/javascript" src="../js/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<body class="mypage">
<div style="color:#696969; line-height: 18px; font-size: 12px;">
    <div class="inner">
        <table class="member-grade rounded">
            <colgroup>
                <col width="80"/>
                <col/>
                <col/>
            </colgroup>
            <thead>
                <tr>
                    <th>등급</th>
                    <th>선정기준</th>
                    <th>등급혜택</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="t-c"><strong class="gold">VIP Gold</strong></td>
                    <td>주문 12회 이상 또는 구매금액 100만원 이상</td>
                    <td>
                        <ul class="txt-list">
                            <li>10% 할인쿠폰 2장</li>
                            <li>3천원 할인쿠폰 2장</li>
                            <li>1만원 할인쿠폰 1장(10만원 이상 구매 시)</li>
                            <li>3개월 연속 VIP GOLD 유지시 7천원 할인 쿠폰 1장(5만원 이상 구매시)</li>
                            <li>텐바이텐 배송상품 무료배송</li>
                            <li>우수회원샵 25% 할인</li>
                            <li>히치하이커 무료지급 (신청기간 내 주소확인시)</li>
                            <li>핑거스 아카데미 10% 할인쿠폰 1장</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td class="t-c"><strong class="silver">VIP SILVER</strong></td>
                    <td>주문 6회~12회 미만 또는 결제금액 50만원 이상 ~ 100만원 미만</td>
                    <td>
                        <ul class="txt-list">
                            <li>10% 할인쿠폰 2장</li>
                            <li>3천원 할인쿠폰 2장</li>
                            <li>무료배송쿠폰 3장</li>
                            <li>3개월 연속 VIP SILVER 유지시 5천원 할인쿠폰 1장 (4만원 이상 구매시)</li>
                            <li>1만원 이상 무료 배송</li>
                            <li>우수회원샵 20% 할인</li>
                            <li>히치하이커 무료지급 (신청기간 내 주소 확인시)</li>
                            <li>핑거스 아카데미 7% 할인쿠폰 1장</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td class="t-c"><strong class="blue2">BLUE</strong></td>
                    <td>주문 4회~6회 미만 또는 결제금액 30만원 이상 ~ 50만원 미만</td>
                    <td>
                        <ul class="txt-list">
                            <li>10% 할인쿠폰 1장</li>
                            <li>무료배송쿠폰 2장</li>
                            <li>2만원 이상 무료 배송</li>
                            <li>우수회원샵 15% 할인</li>
                            <li>핑거스 아카데미 5% 할인쿠폰 1장</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td class="t-c"><strong class="green2">GREEN</strong></td>
                    <td>주문 1회~4회 미만 또는 결제금액 10만원 이상 ~ 30만원 미만</td>
                    <td>
                        <ul class="txt-list">
                            <li>5% 할인쿠폰 2장</li>
                            <li>무료배송쿠폰 1장</li>
                            <li>3만원 이상 무료 배송</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td class="t-c"><strong class="yellow">YELLOW</strong></td>
                    <td>5개월 이내 구매경험이 없는 고객</td>
                    <td>
                        <ul class="txt-list">
                            <li>5% 할인쿠폰 1장</li>
                            <li>무료배송쿠폰 1장</li>
                            <li>3만원 이상 무료 배송</li>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td class="t-c"><strong class="orange">ORANGE</strong></td>
                    <td>신규가입회원, 구매경험이 없는 고객</td>
                    <td>
                        <ul class="txt-list">
                            <li>2천원 할인쿠폰 1장</li>
                            <li>무료배송쿠폰 1장</li>
                            <li>3만원 이상 무료 배송</li>
                        </ul>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="diff-10"></div>
        <div class="well">
            <h1>확인해주세요.</h1>
            <ul class="txt-list">
                <li>등급은 최근 5개월 간의 이용내역을 반영하여 매월 1일 새로운 회원등급이 부여됩니다.</li>
                <li>무료배송 쿠폰은 텐바이텐 배송상품을 기준으로 사용하실 수 있습니다.</li>
                <li>1만원 미만의 구매내역은 구매횟수로 계산되는 선정기준에서 제외됩니다.</li>
                <li>구매금액 산정기준은 실결제액 + 마일리지 사용액으로 산정됩니다.</li>
                <li>무료배송쿠폰은 텐바이텐 배송상품일 때 적용됩니다.</li>
            </ul>
        </div>
	</div>
</div>
</body>
</html>
