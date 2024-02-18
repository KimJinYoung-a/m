<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
	function optHCtrl(){
		var optH = $('.pdtOptBox').height();
		$('.floatingBar .inner').css('padding-top',optH+24);
	}

	$(function() {
		//상품 이미지 롤링
		var mySwiper = new Swiper('.pdtBigImg .swiper-container',{
			pagination:'.pagination',
			paginationClickable:true,
			loop:false,
			resizeReInit:true,
			calculateHeight:true
		});

		//상품 고시정보 더 보기 버튼 컨트롤
		$('.productSpec .extendBtn').click(function(){
			$('.productSpec > ul').toggleClass('extend');
			$(this).toggleClass('cut');
			if ($(this).hasClass('cut')) {
				$(this).html('상품 고시정보 닫기');
			} else {
				$(this).html('상품 고시정보 더보기');
			};
		});

		//상품 상세정보 보기 버튼 컨트롤
		$('.detailView .extendBtn').click(function(){
			$('.detailView > div').toggleClass('extend');
			$(this).toggleClass('cut');
			if ($(this).hasClass('cut')) {
				$(this).html('상품 상세정보 닫기');
			} else {
				$(this).html('상품 상세정보 보기');
			};
		});

		//상품 상세 탭 컨트롤
		$('.detailCont').hide();
		$('#detail01').show();
		$('.detailTab li').click(function() {
			$('.detailTab li').removeClass('selected');
			$(this).addClass('selected');
			$('.detailTab li').children('p').css('border-right','1px solid #fff');
			$(this).prev().children('p').css('border-right','0');
			var tabView = $(this).attr('name');
			$(".detailCont").hide();
			$("[class|='detailCont'][id|='"+ tabView +"']").show();
		});

		//하단 플로팅바 컨트롤
		$(".floatingHandler").click(function(){
			if ($('.pdtOptBox').is(":hidden")) {
				$('.pdtOptBox').show();
				var optH = $('.pdtOptBox').outerHeight();
				$('.floatingBar .inner').css('padding-top',optH);
				$('.floatingWrap').show();
			} else {
				$('.floatingBar .inner').css('padding-top',0);
				$('.pdtOptBox').hide();
				$('.floatingWrap').hide();
			}
			//옵션닫기
			$(".floatingWrap").click(function(){
				$('.floatingBar .inner').css('padding-top',0);
				$('.pdtOptBox').hide();
				$('.floatingWrap').hide();
				$(".optForm dd").hide();
				$(".optForm dt").removeClass("over");
			});
		});

		var vSpos, vChk;
		$(window).on({
			'touchstart': function(e) {
				vSpos = $(window).scrollTop()
				vChk = false;
			}, 'touchmove': function(e) {
				if(vSpos!=$(window).scrollTop()) {
					$('.floatingBar').css('display','none');
					vChk = true;
				}
			}, 'touchend': function(e) {
				if(vChk) $('.floatingBar').fadeIn("fast");
			}
		});

		$(".optForm dt").click(function(){
			if($(this).parent().children('dd').is(":hidden")){
				$(".optForm dd").hide();
				$(".optForm dt").removeClass("over");
				$(this).parent().children('dd').show();
				$(this).addClass("over");
				//옵션선택
				$(".optForm dd li").click(function(e){
					e.preventDefault();
					var evtName = $(this).text();
					$(".optForm dt").removeClass("over");
					$(this).parent().parent().hide();
					$(this).parent().parent().parent().children('dt').text(evtName);
				});
			} else {
				$(this).parent().children('dd').hide();
				$(this).removeClass("over");
			};
			$(".oderNum").click(function(){
				if($(".optForm dd").is(":visible")){
					$(".optForm dd").hide();
					$(".optForm dt").removeClass("over");
				};
			});
		});
	});
</script>
</head>
<body>
<div class="wrapper pdtDetail" id="btwCtgy"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<div class="cont">
			<div class="pdtBigImg">
				<div class="swiper-container pdtBigImg">
					<div class="swiper-wrapper">
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p><!-- for dev msg : 상품 이미지명 alt값으로 넣어주세요(이하동일) -->
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p>
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p>
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p>
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p>
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p>
						<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/common/@temp_pdt_img01.png" alt="Mini Instant Photo Album image" /></a></p>
					</div>
					<div class="pagination"></div>
				</div>
			</div>
			<div class="inPad01">
				<div class="pdtInfo boxMdl">
					<h1><p class="pdtName">Mini Instant Photo Album 상품명 상품명 상품명 상품명 상품명 상품명 상품명 상품명</p></h1>
					<p class="pdtBrand"><a href="">MARTHA IN THE GARRET</a></p>
					<div class="price">
						<del>1,000,000원</del> <span class="txtSaleRed">1,000,000원</span> 
						<p class="pdtTag saleRed">30%</p>
						<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절일때 노출 -->
					</div>
					<p class="pdtLimit">한정수량 <strong class="txtBlk">00개</strong> 남았습니다.</p>
				</div>
				<div class="pdtContWrap">
					<ul class="detailTab boxMdl">
						<li class="detail01 selected" name="detail01"><p onclick="">상품설명</p></li>
						<li class="detail02" name="detail02"><p onclick="">배송/교환/환불규정</p></li>
						<li class="detail03" name="detail03"><p onclick="">고객센터</p></li>
					</ul>
					<div class="detailCont" id="detail01">
						<p class="txtBlk"><strong>상품코드 : 0000000</strong> [텐바이텐 배송상품]</p>
						<div class="inPad01 gry243 productSpec">
							<ul>
								<li><span class="txtBlk">제조사 |</span> 미국 ore originals Inc. /쿠치무역</li>
								<li><span class="txtBlk">원산지 |</span> 중국 oem</li>
								<li><span class="txtBlk">배송구분 |</span> 업체무료배송</li>
								<li><span class="txtBlk">A/S 책임자/전화번호 |</span> 텐바이텐 고객행복센터 1644-6030</li>
								<li><span class="txtBlk">식품의 유형 |</span> 건강기능식품</li>
								<li><span class="txtBlk">생산자 및 소재지 |</span> Laboratoires Vitarmonyl / France</li>
								<li><span class="txtBlk">제조연월일(유통기한) |</span> 2012년 8월 1일 (제조일로부터 24개월) / 2013년 1월 1일(제조일로부터 2년 이내) 용량(중량), 수량, 크기 | 42g(750mg x 56정) / 46.2g (3.3g X 14포)</li>
								<li><span class="txtBlk">주원료, 함량, 원료산지 |</span> 가르시니아 캄보지아열매껍질 추출물(총(-)-HCA75%),D-소르비톨,포도과피추출물,오렌지필추출물,스테아린산마그네슘</li>
								<li><span class="txtBlk">안심하고 드세요. 질병 예방, 치료의약품 아님 명시 |</span> 본 제품은 질병의 예방 및 치료를 위한 의약품이 아닙니다.</li>
								<li><span class="txtBlk">유전자 재조합 식품 여부 |</span> 해당없음</li>
								<li><span class="txtBlk">표시광고 사전심의번호 |</span> 해당없음</li>
								<li><span class="txtBlk">수입식품여부 |</span> 식품위생법에 따른 수입신고 필함</li>
								<li><span class="txtBlk">소비자상담 관련 전화번호 |</span> 텐바이텐 고객행복센터 1644-6030</li>
							</ul>
							<p class="extendBtn">상품 고시정보 더보기</p>
						</div>
						<dl class="detailShort">
							<dt>주문시 유의사항</dt>
							<dd>
								<div class="inPad01 gry243">
									일본 수입되어 배송되므로 2~5일 소요 (주말제외)
								</div>
							</dd>
						</dl>

						<dl class="detailShort">
							<dt>상품상세 정보</dt>
							<dd class="detailInfo">
								<div class="detailView">
									<div><iframe src="about:blank" id="" title="" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" class="autoheight"></iframe></div>
									<p class="extendBtn">상품 상세정보 보기</p>
								</div>
							</dd>
						</dl>
					</div>
					<div class="detailCont" id="detail02">
						<dl class="detailShort">
							<dt>배송정보</dt>
							<dd class="inPad01 gry243">
								<ul class="txtList01 txtBlk">
									<li>배송기간은 주문일(무통장입금은 결제완료일)로부터 1일(24시간) ~ 5일정도 걸립니다.</li>
									<li>업체배송 상품은 무료배송 되며, 업체조건배송 상품은 특정 브랜드 배송 기준으로 배송비가 부여되며 업체착불배송은 특정 브랜드 배송기준으로 고객님의 배송지에 따라 배송비가 착불로 부과됩니다.</li>
									<li>제작기간이 별도로 소요되는 상품의 경우에는 상품설명에 있는 제작기간과 배송시기를 숙지해 주시기 바랍니다.</li>
									<li>가구 등의 상품의 경우에는 지역에 따라 추가 배송비용이 발생할 수 있음을 알려드립니다.</li>
								</ul>
							</dd>
						</dl>
						<dl class="detailShort">
							<dt>교환/환불/AS 안내</dt>
							<dd class="inPad01 gry243">
								<ul class="txtList01 txtBlk">
									<li>상품 수령일로부터 7일 이내 반품/환불 가능합니다.</li>
									<li>변심 반품의 경우 왕복배송비를 차감한 금액이 환불되며, 제품 및 포장 상태가 재판매 가능하여야 합니다.</li>
									<li>상품 불량인 경우는 배송비를 포함한 전액이 환불됩니다.</li>
									<li>출고 이후 환불요청 시 상품 회수 후 처리됩니다.</li>
									<li>주문제작(쥬얼리 포함)/카메라/밀봉포장상품/플라워 등은 변심으로 반품/환불 불가합니다.</li>
									<li>완제품으로 수입된 상품의 경우 A/S가 불가합니다.</li>
									<li>특정브랜드의 교환/환불/AS에 대한 개별기준이 상품페이지에 있는 경우 브랜드의 개별기준이 우선 적용 됩니다.</li>
								</ul>
							</dd>
						</dl>
						<dl class="detailShort">
							<dt>기타 기준사항</dt>
							<dd class="inPad01 gry243">
								<ul class="txtList01 txtBlk">
									<li>구매자가 미성년자인 경우에는 상품 구입시 법정대리인이 동의하지 아니하면 미성년자 본인 또는 법정대리인이 구매취소 할 수 있습니다.</li>
								</ul>
							</dd>
						</dl>
					</div>
					<div class="detailCont" id="detail03">
						<div class="tenCs">
							<p><strong>텐바이텐 고객행복센터</strong></p>
							<p class="csTel"><strong>1644-6030</strong></p>
							<p class="csMail"><strong><a href="mailto:between@10x10.co.kr">between@10x10.co.kr</a></strong></p>
							<p><strong>AM 09:00 ~ PM 06:00</strong><br />(점심시간 : PM 12:00 ~ 01:00)<br />토, 일, 공휴일 휴무</p>
						</div>
					</div>
				</div>
			</div>

			<div class="ctgyBest">
				<h2><strong>카테고리 베스트</strong></h2>
				<ul class="pdtList list01 boxMdl">
					<li>
						<div>
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
								<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
								<p class="price">1,000,000원</p>
							</a>
						</div>
					</li>
					<li>
						<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
								<p class="pdtName">카라 웨딩 테이블 세트</p>
								<p class="price">1,000,000원</p>
								<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
							</a>
						</div>
					</li>
					<li>
						<div>
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
								<p class="pdtName">매스큘린 프라이드 서스펜더 [3color] aa767</p>
								<p class="price">1,000,000원</p>
							</a>
						</div>
					</li>
				</ul>
				<span class="moreBtn"><a href="">더보기</a></span>
			</div>

			<div class="inPad01 ltGry">
				<table class="tbl ctgyList">
					<colgroup>
						<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
					</colgroup>
					<tbody>
						<tr>
							<td><a href="">커플</a></td>
							<td class="on"><a href="">소품/취미</a></td>
							<td><a href="">디지털</a></td>
							<td><a href="">푸드</a></td>
						</tr>
						<tr>
							<td><a href="">패션</a></td>
							<td><a href="">뷰티</a></td>
							<td><a href="">SALE</a></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="floatingBar boxMdl cartIn optIs"><!-- for dev msg : 옵션이 있는 경우 optIs 클래스 추가해주세요 -->
			<div class="inner">
				<div class="btnWrap">
					<p class="btn01 btnCart"><a href="" class="btw">장바구니<em class="newIco tenRed">78</em></a></p>
					<p class="btn01 btnOrder"><a href="" class="edwPk">구매하기</a></p>
					<!-- p class="btn01 btnSoldOut"><span class="cnclGry">품절</span></p --><!-- for dev msg : 품절일때 노출 -->
				</div>
				<!-- for dev msg : 옵션이 있는 경우 노출 -->
				<div class="pdtOptBox">
					<p class="copyInput"><textarea>[문구입력란] 문구를 입력해 주세요.</textarea></p>
					<select class="optSelect">
						<option>옵션1을 선택해주세요.</option>
						<option>옵션1-1</option>
						<option>옵션1-2</option>
						<option>옵션1-3</option>
					</select>
					<select class="optSelect">
						<option>옵션2을 선택해주세요.</option>
					</select>
					<select class="optSelect">
						<option>옵션3을 선택해주세요.</option>
					</select>
					<!--
					<dl class="optForm">
						<dt>옵션1을 선택해주세요.</dt>
						<dd>
							<ul>
								<li>옵션1-a</li>
								<li>옵션1-b</li>
								<li>옵션1-c</li>
								<li>옵션1-d</li>
							</ul>
						</dd>
					</dl>
					<dl class="optForm">
						<dt>옵션2을 선택해주세요.</dt>
						<dd>
							<ul>
								<li>옵션2-a</li>
								<li>옵션2-b</li>
								<li>옵션2-c</li>
								<li>옵션2-d</li>
							</ul>
						</dd>
					</dl>
					<dl class="optForm">
						<dt>옵션3을 선택해주세요.</dt>
						<dd>
							<ul>
								<li>옵션3-a</li>
								<li>옵션3-b</li>
								<li>옵션3-c</li>
								<li>옵션3-d</li>
								<li>옵션3-e</li>
								<li>옵션3-f</li>
								<li>옵션3-g</li>
								<li>옵션3-h</li>
							</ul>
						</dd>
					</dl>
					-->
					<div class="oderNum">
						<span class="down" onclick="">-</span>
						<span class="up" onclick="">+</span>
						<input type="text" class="numInput" value="1" />
					</div>
				</div>
				<!-- //for dev msg : 옵션이 있는 경우 노출 -->
			</div>
			<span class="floatingHandler">열기</span>
			<div class="floatingWrap"></div>
		</div>

	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>