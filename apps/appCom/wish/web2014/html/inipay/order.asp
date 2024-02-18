<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="shop">
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content order" id="contentArea">

<!------- 2014 frame ------------->


        <!-- #header -->
        <header id="header">
            <h1 class="page-title">주문결제</h1>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
            <form action="">
            <div class="inner">
                <a href="#" class="bordered-title show-toggle-box" target="#orderedProductList">주문리스트 확인 <small class="red">총 4개 / 129,000원</small> <i class="icon-arrow-up-down absolute-right"></i></a>
                <div class="diff-10"></div>
                <!-- ordered-product-list -->
                <ul class="ordered-product-list" id="orderedProductList">
                    <li class="bordered-box filled">
                        <div class="product-info gutter">
                            <div class="product-img">
                                <img src="../../img/_dummy-200x200.png" alt="">
                            </div>
                            <div class="product-spec">
                                <p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
                                <p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
                                <p class="product-option">옵션 : gray</p>
                            </div>
                            <div class="price">
                                <strong>23,000</strong>원 
                            </div>
                        </div>
                    </li>
                    <li class="bordered-box filled">
                        <div class="product-info gutter">
                            <div class="product-img">
                                <img src="../../img/_dummy-200x200.png" alt="">
                            </div>
                            <div class="product-spec">
                                <p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
                                <p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
                                <p class="product-option">옵션 : gray</p>
                            </div>
                            <div class="price">
                                <strong>23,000</strong>원 
                            </div>
                        </div>
                    </li>
                    <li class="bordered-box filled">
                        <div class="product-info gutter">
                            <div class="product-img">
                                <img src="../../img/_dummy-200x200.png" alt="">
                            </div>
                            <div class="product-spec">
                                <p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
                                <p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
                                <p class="product-option">옵션 : gray</p>
                            </div>
                            <div class="price">
                                <strong>23,000</strong>원 
                            </div>
                        </div>
                    </li>
                </ul><!-- ordered-product-list -->                    

                <div class="diff"></div>

                <!-- client info -->
                <div class="main-title">
                    <h1 class="title"><span class="label">주문고객 정보</span></h1>
                </div>
                <div class="input-block">
                    <label for="addressName" class="input-label">보내시는 분</label>
                    <div class="input-controls">
                        <input type="text" name="addressName" id="addressName" class="form full-size">
                    </div>
                </div>
                <div class="input-block email-block">
                    <label for="email1" class="input-label">이메일</label>
                    <div class="input-controls email-type-b">
                        
                        <input type="text" id="email1" name="buyemail_Pre" maxlength="40" value="" class="form">
                        @
                        <input type="text" name="buyemail_Tx" id="buyemail_Tx" value="" class="form" style="display:none;">
                        
                        <select name="buyemail_Bx" id="select3" onChange="jsShowMailBox('document.frmorder','buyemail_Bx','buyemail_Tx');" class="form bordered">
                            <option value="gmail.com">gmail.com</option>
                            <option value="daum.net">daum.net</option>
                            <option value="naver.com">naver.com</option>
                            <option value="etc">직접입력</option>
                        </select>
                    </div>
                </div> 
                
                <div class="input-block">
                    <label for="phone" class="input-label">휴대폰</label>
                    <div class="input-controls phone">
                        <div><input type="tel" id="phone1" class="form"></div>
                        <div><input type="tel" id="phone2" class="form"></div>
                        <div><input type="tel" id="phone3" class="form"></div>
                    </div>
                </div>
                <div class="input-block">
                    <label for="zipcode" class="input-label">주소</label>
                    <div class="input-controls zipcode">
                        <div><input type="text" id="zipcode1" class="form full-size" maxlength="3" value="123"></div>
                        <div><input type="text" id="zipcode2" class="form full-size" maxlength="3" value="123"></div>
                        <button class="btn type-c btn-findzipcode side-btn">우편번호검색</button>
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="address1" class="input-label">주소2</label>
                    <div class="input-controls">
                        <input type="text" id="address1" class="form full-size">
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="address2" class="input-label">주소3</label>
                    <div class="input-controls">
                        <input type="text" id="address2" class="form full-size">
                    </div>
                </div><!-- client info -->
                
                <div class="diff"></div>

                <!-- receiver info -->                    
                <div class="main-title">
                    <h1 class="title"><span class="label">배송지 정보 입력</span></h1>
                </div>
                <div class="well">
                    <h2>해외배송 주의사항 </h2>
                    <p class="red">배송지 관련 모든 정보는 반드시 영문으로 작성하여 주시기 바랍니다.</p>
                </div>
                <div class="diff-10"></div>
                <dl class="form">
                    <dt>총중량</dt>
                    <dd>379 g (0.38 Kg)<br>상품중량 : 179 g / 포장박스 중량 : 200 g</dd>
                </dl>
                <dl class="form">
                    <dt>배송방법 </dt>
                    <dd>EMS</dd>
                </dl>

                <dl class="form has-input">
                    <dt>국가선택</dt>
                    <dd>
                        <div class="country">
                            <div>
                                <select name="" id="country1" class="form bordered">
                                    <option value="">국가선택</option>
                                    <option value="korea">korea</option>
                                    </select>
                            </div>
                            <div><input type="text" id="country2" class="form bordered" disabled="disabled"></div>
                            <div><input type="text" id="country3" class="form bordered" disabled="disabled"></div>
                        </div>
                        <a href="#" class="btn type-e full-size">국가별 발송조건 보기</a>
                    </dd>
                </dl>
                <dl class="form ">
                    <dt>해외배송료</dt>
                    <dd>
                        13,500원 (EMS 1지역)
                        <a href="#" class="btn type-e full-size">EMS 지역요금 보기</a>
                        <em class="em red">EMS 운송자의 발송인 정보는 TEN BY TEN (www.10x10.co.kr)으로 입력됩니다.</em>
                    </dd>
                </dl>

                <div class="input-block">
                    <label for="addressName" class="input-label">NAME</label>
                    <div class="input-controls">
                        <input type="text" name="addressName" id="addressName" class="form full-size">
                    </div>
                </div>                    
                <div class="input-block">
                    <label for="email" class="input-label">E-Mail</label>
                    <div class="input-controls">
                        <input type="email" id="email" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="phone" class="input-label">TelNo</label>
                    <div class="input-controls telno">                            
                        <div><input type="tel" id="phone1" class="form full-size"></div>
                        <div><input type="tel" id="phone2" class="form full-size"></div>
                        <div><input type="tel" id="phone3" class="form full-size"></div>
                        <div><input type="tel" id="phone4" class="form full-size"></div>
                    </div>
                </div>
                <em class="em">* 국가번호 – 지역번호 – 국번 - 전화번호</em>
                <div class="input-block">
                    <label for="zipcode" class="input-label">Zip code</label>
                    <div class="input-controls">                            
                        <input type="text" id="zipcode" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="address" class="input-label">Address</label>
                    <div class="input-controls">                            
                        <input type="text" id="address" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="city" class="input-label">City / State</label>
                    <div class="input-controls">                            
                        <input type="text" id="city" class="form full-size">
                    </div>
                </div><!-- receiver info -->
                    
                <div class="diff"></div>

                <!-- discount info -->
                <div class="main-title">
                    <h1 class="title"><span class="label">할인정보 입력</span></h1>
                </div>
                <label for="useBonus" class="pull-left" style="width:100px; line-height:36px;">
                    <input type="radio" id="useBonus" name="couponType" class="form type-c"> <span class="small">보너스 쿠폰</span>
                </label>
                <div class="input-block no-label" style="margin-left:100px;">
                    <div class="input-controls">
                        <select class="form full-size">
                            <option value="">사용하실 보너스 쿠폰을 선택하세요!</option>
                        </select>
                    </div>
                </div>
                <div class="clear"></div>
                <label for="useGood" class="pull-left" style="width:100px; line-height:36px;">
                    <input type="radio" id="useGood" name="couponType" class="form type-c"> <span class="small">상품 쿠폰</span>
                </label>
                <div class="input-block no-label" style="margin-left:100px; line-height:36px;">
                    <span class="small">적용 가능한 상품쿠폰이 없습니다.</span>
                </div>
                <div class="clear"></div>
                <div class="input-block">
                    <label for="mileage" class="input-label">마일리지</label>
                    <div class="input-controls">
                        <input type="text" name="mileage" id="mileage" class="form full-size">
                    </div>
                </div>
                <em class="em">Point (보유 마일리지 : <strong class="red">1202P</strong>)</em>
                <div class="input-block">
                    <label for="cash" class="input-label">예치금</label>
                    <div class="input-controls disabled">
                        <input type="text" name="cash" id="cash" class="form full-size" disabled="disabled"> 
                    </div>
                </div>
                <em class="em">(사용 가능한 예치금이 없습니다.)</em>
                <div class="input-block">
                    <label for="giftCard" class="input-label">Gift 카드</label>
                    <div class="input-controls disabled">
                        <input type="text" name="giftCard" id="giftCard" class="form full-size" disabled="disabled">
                    </div>
                </div>
                <em class="em">(사용 가능한 Gift 카드가 없습니다.)</em>
                <!-- discount info -->

                <div class="diff"></div>

                <!-- total -->
                <div class="main-title">
                    <h1 class="title"><span class="label">결제 금액</span></h1>
                </div>
                <dl class="type-b">
                    <dt>구매 총액</dt>
                    <dd>1,100 <span class="unit">원</span></dd>
                </dl>
                <dl class="type-b">
                    <dt>배송료</dt>
                    <% '// 텐텐배송 2500으로 변경 %>
                    <% If (Left(Now, 10) >= "2019-01-01") Then %>
                        <dd>2,500 <span class="unit">원</span></dd>
                    <% Else %>
                        <dd>2,000 <span class="unit">원</span></dd>
                    <% End If %>
                </dl>
                <dl class="type-b show-toggle-box" target="#discount">
                    <dt>할인금액 <i class="icon-arrow-up-down"></i></dt>
                    <dd>1 <span class="unit">원</span></dd>
                </dl>
                <table class="discount filled" id="discount">
                    <colgroup>
                        <col width="120"/>
                        <col/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>보너스쿠폰 사용액</th>
                            <td>0 <span class="unit">원</span></td>
                        </tr>
                        <tr>
                            <th>상품쿠폰 사용액</th>
                            <td>0 <span class="unit">원</span></td>
                        </tr>
                        <tr>
                            <th>마일리지 사용</th>
                            <td>0 <span class="unit">pt</span></td>
                        </tr>
                        <tr>
                            <th>예치금 사용액</th>
                            <td>0 <span class="unit">원</span></td>
                        </tr>
                        <tr>
                            <th>Gift카드 사용액</th>
                            <td>0 <span class="unit">원</span></td>
                        </tr>
                    </tbody>
                </table>
                <dl class="type-c highlight">
                    <dt>총 합계</dt>
                    <dd><strong>8,100</strong> <span class="unit">원</span></dd>
                </dl>
                <!-- total -->
                <div class="diff"></div>


                <!-- bonus -->
                <div class="main-title">
                    <h1 class="title"><span class="label">사은품 선택</span></h1>
                </div>
    
                <div class="well type-b full-width">
                    <ul class="txt-list">
                        <li>사은품은 텐바이텐 배송상품 결제금액 기준이며 상품쿠폰 등의 사용 후 실제 결제금액 기준입니다.</li>
                        <li>결제금액별로 사은품 선택이 가능 합니다.</li>
                        <li>스티커는 5개 1세트이며, 자수 파우치는 4종 중 1종 선택 가능합니다.</li>
                        <li>환불/교환시 최종금액이 기준금액 미만일 경우 사은품은 반품하여야 합니다.</li>
                    </ul>
                </div>
                
                <div class="diff-10"></div>

                <!-- bonusbox -->
                <div class="bordered-box">
                    <a href="#bonusBox1" class="bordered-title t-l no-margin show-toggle-box" target="#bonusBox1">10,000원 이상 구매시 (텐바이텐 배송상품 금액 기준) <i class="icon-arrow-up-down absolute-right"></i></a>
                    <ul class="bonus-list" id="bonusBox1">
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                    </ul>
                    <div class="clear"></div>
                </div><!-- bonusbox -->

                <div class="diff-10"></div>
                <!-- bonusbox -->
                <div class="bordered-box">
                    <a href="#bonusBox1" class="bordered-title t-l no-margin show-toggle-box" target="#bonusBox2">30,000원 이상 구매시 (텐바이텐 배송상품 금액 기준) <i class="icon-arrow-up-down absolute-right"></i></a>
                    <ul class="bonus-list" id="bonusBox2">
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                        <li>
                            <input type="radio" name="bonus1" class="form type-c">
                            <img src="../../img/_dummy-200x200.png" alt="">
                            <span class="product-name">10X10 스티커 SET 남은 수량 10개</span>
                        </li>
                    </ul>
                    <div class="clear"></div>
                </div><!-- bonusbox -->

                <div class="diff"></div>


                <!-- agreement -->
                <div class="main-title">
                    <h1 class="title"><span class="label">해외배송 약관 동의</span></h1>
                </div>
                <div class="diff"></div>

                <div class="well full-width">
                    
                    <h2>통관/관세</h2>
                    <p class="small">해외에서 배송한 상품을 받을 때 일부 상품에 대해 해당 국가의 관세법의 기준에 따라 관세와 부가세 및 특별세 등의 세금을 징수합니다.해외의 각국들 역시 도착지의 세법에 따라 세금을 징수할 수도 있습니다. <br>그 부담은 상품을 받는 사람이 지게 됩니다.<br>하지만 특별한 경우를 제외한다면, 선물용으로 보내는 상품에 대해서는 세금이 없습니다.<br>전자제품(ex: 전압, 전류 차이) 등 사용 환경이 다른 상품의 사용 시 발생할 수 있는 모든 문제의 책임은 고객에게 있습니다.</p>
                    <div class="diff-10"></div>
                    <h2>반품</h2>
                    <p class="small">해외에서 상품을 받으신 후 반송을 해야 할 경우 고객센터에 연락 후 반품해주시길 바라며, 반품 시 발생하는 EMS요금은 고객 부담입니다.</p>
              
                </div>
                <div class="diff-10"></div>
                <label for="agree">
                    <input type="checkbox" class="form" id="agree">
                    <span class="x-small">해외 배송 서비스 이용약관을 확인하였으며 약관에 동의합니다.</span>
                </label>

                <!-- agreement -->
                <div class="diff"></div>
                <!-- payment -->
                <div class="main-title">
                    <h1 class="title"><span class="label">결제 수단</span></h1>
                </div>
                <div class="toggle form type-c grey lines three">
                    <button>신용카드</button>
                    <button>모바일결제</button>
                    <button class="active">무통장입금<br><small>(가상계좌)</small></button>
                </div>
            </div>
            <div class="form-actions highlight"> 
                <div class="well">
                    <h2>유의사항</h2>
                    <ul class="txt-list">
                        <li>장바구니는 접속 종료 후 7일 동안 보관 됩니다.</li>
                        <li>그 이상 기간 동안 상품을 보관하시려면 위시리스트 (wish list)에 넣어주세요.</li>
                        <li>상품배송비는 텐바이텐배송 / 업체배송 / 업체조건배송 / 업체착불배송 4가지 기준으로 나누어 적용됩니다.</li>
                        <li>업체배송 및 업체조건배송, 업체착불배송 상품은 해당 업체에서 별도로 배송되오니 참고하여 주시기 바랍니다.</li>
                    </ul>
                </div>        
                <div class="diff"></div>           
                <div class="two-btns">
                    <div class="col"><button class="btn type-b"><i class="icon-check"></i>주문하기</button></div>
                    <div class="col"><button class="btn type-a">장바구니</button></div>
                </div>
                <div class="clear"></div>
            </div>
            </form>
        </div><!-- #content -->

        <footer id="footer">
        </footer>


<!------- 2014 frame ------------->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>