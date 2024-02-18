 <%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardinfoCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardPrdCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardOptionCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<%
	Const CLimitElecInsureUnder = 0 ''현금 전주문 (5만원이상->전체;2013.11.28; 허진원) 전자보증서 발행 가능
	Const IsCyberAcctValid = TRUE  '' 가상계좌사용여부
	Const CLimitMonthlyBuy = 1000000 ''월 100만원 구매 제한

	dim userid, userlevel
	userid          = GetLoginUserID
	userlevel       = GetLoginUserLevel

	'// 파일서버 처리용 회원ID 암호화
	Dim encUsrId, tmpTx, tmpRn
	Randomize()
	tmpTx = split("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z",",")
	tmpRn = tmpTx(int(Rnd*26))
	tmpRn = tmpRn & tmpTx(int(Rnd*26))
		encUsrId = tenEnc(tmpRn & userid)

	'// 고객 정보접수
	dim oUserInfo
	set oUserInfo = new CUserInfo
	oUserInfo.FRectUserID = userid
	oUserInfo.GetUserData

	if (oUserInfo.FresultCount<1) then
		set oUserInfo.FOneItem    = new CUserInfoItem
	end if

	'// 월간 고객 주문 총 금액 접수 및 제한 검사
	dim myorder, nTotalBuy
	set myorder = new cGiftcardOrder
		myorder.FUserID = userid
		nTotalBuy = myorder.getGiftcardOrderTotalPrice
	set myorder = Nothing

	''가상계좌 입금기한 마감일
	function getVbankValue()
		dim retVal
		retVal = Left(replace(dateAdd("d",7,Now()),"-",""),8)
		getVbankValue = retVal
	end function

	'######################### cardid 상품의 옵션 html. #########################
	'//옵션 HTML생성
	dim ioptionBoxHtml: ioptionBoxHtml = GetOptionBoxHTML2016(101)
%>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<title>10x10: 기프트카드</title>
<style type="text/css">
.loadingContainer .loading {transition:all 0.5s ease-in-out; -webkit-transition:all 0.5s ease-in-out;}
.loading {
	position:absolute; top:50%; left:50%; z-index:10; width:8rem; height:8rem; margin-top:-4rem; margin-left:-4rem;
	border-radius:100%; border:2px solid transparent; border-color:transparent #fff transparent #fff;
	animation: rotate-loading 1.5s linear 0s infinite normal; transform-origin: 50% 50%;
	-webkit-animation: rotate-loading 1.5s linear 0s infinite normal; -webkit-transform-origin: 50% 50%;
}
@-webkit-keyframes rotate-loading {
	0% {-webkit-transform:rotate(0deg);}
	100% {-webkit-transform:rotate(360deg);}
}
@keyframes rotate-loading {
	0% {transform: rotate(0deg);}
	100% {transform: rotate(360deg);}
}
.loadingText {position:absolute; top:50%; left:50%; width:8rem; height:1.2rem; margin-top:-0.6rem; margin-left:-4rem; color: #fff; font-size:1.1rem; font-weight:bold; text-align:center; text-transform:uppercase;}
.loadingText {animation:loading-text-opacity 2s linear 0s infinite normal; -webkit-animation:loading-text-opacity 2s linear 0s infinite normal;}

@keyframes loading-text-opacity {
	0% {opacity:0}
	20% {opacity:0}
	50% {opacity:1}
	100%{opacity:0}
}
@-webkit-keyframes loading-text-opacity {
	0% {opacity:0}
	20% {opacity:0}
	50% {opacity:1}
	100%{opacity:0}
}
</style>
<script src="/lib/js/jquery.form.min.js"></script> 
<script type="text/javascript">
$(function(){
	/* swiper - card */
	cardSwiper = new Swiper('.swiperCard',{
		slidesPerView:"auto",
		centeredSlides:true,
		initialSlide:1,
		spaceBetween:'6%',
		onSlideChangeStart: function (cardSwiper) {
			var vActIdx = parseInt(cardSwiper.activeIndex);
			vActIdx++;
			if (vActIdx<=0) {
				vActIdx = cardSwiper.slides.length;
			} else if(vActIdx>(cardSwiper.slides.length+1)) {
				vActIdx = 1;
			}
			$(".pagination b").text(vActIdx);
			$(".swiperCard .swiper-slide").delay(0).animate({"opacity":"0.5"},50);
			$(".swiperCard .swiper-slide-active").delay(50).animate({"opacity":"1"},100);

			if($(".swiperCard .swiper-slide-active").attr("bno")=="photo") {
				document.frmorder.designid.value="900";
			} else if ($(".swiperCard .swiper-slide-active").attr("bno")) {
				document.frmorder.designid.value="6"+$(".swiperCard .swiper-slide-active").attr("bno");
			}
		}
	});
	$(".pagination b").text(cardSwiper.activeIndex+1);
	$(".pagination span").text(cardSwiper.slides.length);

	/* swiper - price */
	priceSwiper = new Swiper('.swiper2',{
		slidesPerView:"auto"
	});

	// 가격옵션 기본값
	document.frmorder.cardPrice.value="30000";
	document.frmorder.cardopt.value="0003";
	$("#txtGcPrice").html("30,000");

	$(".priceSwiper .swiper-slide button").click(function(){
		$(".priceSwiper .swiper-slide button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
		document.frmorder.cardPrice.value=$(this).attr("price");
		document.frmorder.cardopt.value=$(this).attr("cardOpt");
		$("#txtGcPrice").html(setComma($(this).attr("price")));
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			cardSwiper.reInit();
			priceSwiper.reInit();
			clearInterval(oTm);
		}, 500);
	});

	$("#paymentType #deposit").hide();
	$("#paymentType .navigator li span").click(function(){
		$("#paymentType #deposit").hide();
		$("#paymentType .navigator li span").removeClass("on");
		var thisCont = $(this).find("a").attr("href");
		document.frmorder.Tn_paymethod.value=$(this).attr("data");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
			$("#paymentType").find(thisCont).show();
			return false;
		}
	});

	/* 글자수 카운팅 */
	function frmCount(val) {
		var len = GetByteLength(val.value);		// 2byte계산
		if (len >= 201) {
			$("#giftcardMsg .limited b").addClass("cRd1").text(len);
		} else {
			$("#giftcardMsg .limited b").removeClass("cRd1").text(len);
		}
	}
	$("#giftcardMsg textarea").keyup(function() {
		frmCount(this);
	});

	//휴대폰 번호 입력
	$("#recipient, #sender").blur(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,"").replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3"));
	});


	/* 기프트카드 결제 주의사항 */
	$("#giftcardPrecautions .listBox").hide();
	$("#giftcardPrecautions .orderSummary").click(function(){
		$(this).toggleClass("on");
		$(this).next().toggle();
		return false;
	});

	/* 무통장입금 */
	$(".payMobile > label > input").click(function(){
		$(".payMobileCont").toggle();
	});
});
var vImgDomain = '<%=staticImgUrl%>';
var vSiteUrl = '<%=wwwUrl%>';
</script>
<script src="present.js?v=1.0"></script> 
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="giftcardPresentV15a">
				<!-- ### 유저이미지 ### -->
				<form name="frmUpload" id="ajaxform" action="<%=chkIIF(application("Svr_Info")="Dev",uploadImgUrl,Replace(uploadImgUrl,"http://","https://"))%>/linkweb/giftcard/doUserGiftCardImgReg.asp" method="post" enctype="multipart/form-data" style="opacity:0; height:0px;width:0px;">
				<input type="file" name="UsrPhoto" id="fileupload" onchange="fnCheckPreUpload();" accept="image/*" />
				<input type="hidden" name="mode" id="fileupmode" value="preImg">
				<input type="hidden" name="tuid" value="<%=encUsrId%>">
				<input type="hidden" name="preimg" id="filePreImg" value="">
				<input type="hidden" name="crpX" id="fileCrpX" value="">
				<input type="hidden" name="crpY" id="fileCrpY" value="">
				<input type="hidden" name="crpW" id="fileCrpW" value="">
				<input type="hidden" name="crpH" id="fileCrpH" value="">
				<input type="hidden" name="mtd" id="fileMtd" value="">
				</form>
				<!-- ### 주문서 ### -->
				<form name="frmorder" id="frmorder" method="post" style="margin:0px;">
				<!-- 앱용 -->
				<input type="hidden" name="appname" value="<%=CGLBAppName%>">
				<!-- // 구매 고객 정보 -->
				<input type="hidden" name="buyname" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>">
				<input type="hidden" name="buyemail" value="<%= oUserInfo.FOneItem.Fusermail %>">
				<input type="hidden" name="buyhp" value="<%= oUserInfo.FOneItem.Fusercell %>">
				<input type="hidden" name="buyphone" value="<%=oUserInfo.FOneItem.Fuserphone%>">

				<!-- // 기프트카드 정보 -->
				<input type="hidden" name="cardid" value="101">		<!-- 기프트카드 상품번호 -->
				<input type="hidden" name="cardopt" value="0003">	<!-- 기프트카드 금액옵션 -->
				<input type="hidden" name="cardPrice" value="0">		<!-- 기프트카드 금액 -->
				<input type="hidden" name="designid" value="601">		<!-- 기프트카드 디자인 -->
				<input type="hidden" name="userImg" value="">		<!-- 기프트카드 사용자이미지 -->

				<!-- // 수신자 정보 -->
				<input type="hidden" name="sendemail" value="<%= oUserInfo.FOneItem.Fusermail %>">
				<input type="hidden" name="reqemail" value="">
				<input type="hidden" name="emailTitle" value="">
				<input type="hidden" name="emailContent" value="">

				<input type="hidden" name="bookingDate" value="">
				<input type="hidden" name="Tn_paymethod" value="100">
				<input type="hidden" name="rdsite" value="mobile">
					<section class="giftcardSwiperV15a">
						<h2><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/tit_10x10_giftcard.png" alt="10X10 GIFT CARD" /></h2>
						<div class="giftcardPrice"><b id="txtGcPrice">30,000</b><span>원</span></div>

						<!-- swipe : 카드 선택 -->
						<div class="cardSwiper">
							<div class="swiper-container swiperCard">
								<div class="swiper-wrapper">
									<div class="swiper-slide swiper-slide-00" bno="photo">
										<img src="http://fiximage.10x10.co.kr/m/2016/giftcard/img_giftcard_type_upload.png" alt="" />
										<div class="file">
											<label for="fileupload" class="button btB2 btRed cWh1">사진 등록</label>
										</div>
										<div id="lyrPrgs" class="loadingContainer" style="display:none;">
											<div class="loading"></div>
											<div class="loadingText">loading</div>
											<div class="frame"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/bg_frame_mask.png" alt="" /></div>
										</div>

										<div id="lyrUsrImg" class="cropbox" style="display:none;">
											<img id="UsrImg" src="" alt="사용자이미지" />
											<div class="frame"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/bg_photo_frame.png" alt="" /></div>
											<button type="button" onclick="fnDelUsrImg()" class="btnDel"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/btn_delete.png" alt="삭제" /></button>
										</div>
									</div>
									<div class="swiper-slide swiper-slide-01" bno="01"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_01.png" alt="I LKIE YOU" /></div>
									<div class="swiper-slide swiper-slide-02" bno="02"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_02.png" alt="HELLO" /></div>
									<div class="swiper-slide swiper-slide-03" bno="03"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_03.png" alt="2016 HAPPY NEW YEAR" /></div>
									<div class="swiper-slide swiper-slide-04" bno="04"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_04.png" alt="LIKE IT!" /></div>
									<div class="swiper-slide swiper-slide-05" bno="05"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png" alt="You&apos;re alreay different 10X10 레드 카드" /></div>
									<div class="swiper-slide swiper-slide-06" bno="06"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_06.png" alt="TENBYTEN 그레이 카드" /></div>
									<div class="swiper-slide swiper-slide-07" bno="07"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_07.png" alt="TENBYTEN You&apos;re alreay different 10X10 옐로 카드" /></div>
									<div class="swiper-slide swiper-slide-08" bno="08"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_08.png" alt="Happy Birthday 케익" /></div>
									<div class="swiper-slide swiper-slide-09" bno="09"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_09.png" alt="HAPPY BIRTHDAY TO YOU" /></div>
									<div class="swiper-slide swiper-slide-10" bno="10"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_10.png" alt="HAPPY BIRTHDAY" /></div>
									<div class="swiper-slide swiper-slide-11" bno="11"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_11.png" alt="merci" /></div>
									<div class="swiper-slide swiper-slide-12" bno="12"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_12.png" alt="thank you 꽃 패턴" /></div>
									<div class="swiper-slide swiper-slide-13" bno="13"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_13.png" alt="thank you! 도넛 패턴" /></div>
									<div class="swiper-slide swiper-slide-14" bno="14"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_14.png" alt="두 손 모아 하트" /></div>
									<div class="swiper-slide swiper-slide-15" bno="15"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_15.png" alt="Congratulation! 곰돌이" /></div>
									<div class="swiper-slide swiper-slide-16" bno="16"><img src="http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_16.png" alt="Congratulations!" /></div>
								</div>
							</div>
							<div class="pagination"><b></b>/<span></span></div>
						</div>

						<div id="giftcardMsg" class="giftcardMsgV15a">
							<fieldset>
								<legend>기프트 카드 메시지 입력</legend>
								<input type="hidden" name="MMSTitle" value="<%=oUserInfo.FOneItem.Fusername%>님이 텐바이텐 기프트카드를 보내셨습니다.">
								<textarea name="MMSContent" title="기프트 카드 메시지 입력" cols="60" rows="5" placeholder="기프트카드와 함께 보낼 따뜻한 메시지를 입력해주세요."></textarea>
								<div class="limited"><b>0</b>/200</div>
							</fieldset>
						</div>

						<!-- swipe : 금액 선택 -->
						<div class="priceSwiper">
							<div class="swiper-container swiper2">
								<div class="swiper-wrapper"><%=ioptionBoxHtml%></div>
							</div>
						</div>
					</section>

					<div class="usageNotice">
						<p class="cBk1">텐바이텐 온라인 사이트와 오프라인 매장에서<br /> 사용 가능한 기프트카드로 여러분의 따뜻한 마음을 전해보세요!</p>
						<p>※ 실물 카드 없이 모바일 메시지를 전송받아<br /> 보다 편리하고 안전하게 사용 가능합니다.</p>
						<span class="button btB1 btBck cWh1"><a href="#" onclick="openbrowser('<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/usageNotice.asp');return false;">이용안내 및 유의사항</a></span>
					</div>

					<!-- 전송정보 -->
					<div class="giftcardOrderFormV15a">
						<fieldset>
							<legend>전송정보 입력</legend>
							<table>
								<caption>전송정보</caption>
								<tbody>
								<tr>
									<th scope="row"><label for="recipient">받는 사람</label></th>
									<td><input type="text" id="recipient" name="reqhp" pattern="[0-9]*" placeholder="휴대폰 번호를 입력해주세요" /></td>
								</tr>
								<tr>
									<th scope="row"><label for="sender">보내는 사람</label></th>
									<td>
										<input type="text" id="sender" name="sendhp" value="<%= oUserInfo.FOneItem.Fusercell %>" pattern="[0-9]*" placeholder="휴대폰 번호를 입력해주세요" />
									</td>
								</tr>
								</tbody>
							</table>

							<div class="listBox">
								<ul>
									<li>발신번호 사전등록제 시행으로 인해 메시지 발신번호가 1644-6030 (텐바이텐 고객센터)으로 표시됩니다.</li>
									<li>휴대폰 번호를 잘못 입력하실 경우 타사용자가 인증번호를 등록할 수 있으며, 이 경우 환불이 불가하오니 유의 바랍니다.</li>
								</ul>
							</div>
						</fieldset>
					</div>

					<!-- 결제수단 -->
					<div class="giftcardPayV15a">
						<fieldset>
							<legend>결제수단 입력</legend>
							<h3>결제수단</h3>

							<div id="paymentType" class="paymentType">
								<ul class="navigator">
									<li><span class="on" data="100"><button type="button">신용카드</button></span></li>
									<li><span data="20"><button type="button">실시간<br />계좌이체</button></span></li>
									<li><span data="7"><a href="#deposit">무통장입금<br /> <%= CHKIIF(IsCyberAcctValid,"(가상계좌)","(일반계좌)") %></a></span></li>
								</ul>

								<div id="giftcardPrecautions" class="giftcardPrecautionsV15a">
									<a href="#precautions" class="orderSummary box5">기프트카드 결제 주의사항</a>
									<div id="precautions" class="listBox">
										<ul>
											<li>기프트카드 구매는 상품을 구매하는 것이 아니라 무기명 선불카드를 구매하는 것이므로 비과세로 구분됩니다.</li>
											<li>신용카드로 기프트카드 구매 시 매출전표는 부과세 표시 없이 발행 되며, 거래내역서 용도로 사용 가능합니다.</li>
											<li>실시간계좌이체 및 무통장 입금으로 기프트카드 구매 시 현금영수증, 세금계산서 증빙서류는 발급이 불가하며, 기프트카드로 상품을 구매할 때 현금영수증 발행이 가능합니다.</li>
										</ul>
									</div>
								</div>

								<!-- for dev msg : 주문결제 > 주문서 작성 페이지 무통장입금 부분과 동일합니다. http://testm.10x10.co.kr/inipay/userInfo.asp -->
								<div id="deposit" class="deposit">
									<input type="hidden" name="isCyberAcct" value="<%= CHKIIF(IsCyberAcctValid,"Y","") %>">
									<input type="hidden" name="CST_PLATFORM" value="<%= CHKIIF(application("Svr_Info")= "Dev","test","") %>">
									<dl class="depositNoti">
										<dt>무통장 입금시 유의사항</dt>
										<dd class="box5">
											<ul>
												<li>무통장 입금 확인은 입금 후 1시간 이내에 확인되며, 입금 확인 후 인증번호 전송이 이루어 집니다.</li>
												<li>무통장 주문 후 7일이 지날때까지 미입금시 주문은 자동으로 취소됩니다.</li>
												<li>무통장 입금 시 사용되는 가상계좌는 매 주문 시마다 새로운 계좌번호(개인전용)가 부여되며 해당 주문에만 유효합니다.</li>
												<li>계좌번호는 주문완료 페이지에서 확인 가능하며, SMS로도 안내 드립니다.</li>
											</ul>
										</dd>
									</dl>
								</div>
							</div>
							<!-- //for dev msg : 주문결제 > 주문서 작성 페이지 무통장입금 부분과 동일 -->

							<div class="agree">
								<input type="checkbox" id="agreeYes" name="areement" value="ok" />
								<label for="agreeYes">기프트카드 약관 동의</label>
								<span class="button btS2 btGryBdr cGy1"><a href="#" onclick="openbrowser('<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/giftCardTerms.asp');return false;">약관보기</a></span>
							</div>

							<div class="btnGroupV15a">
								<div class="button btB1 btRed cWh1 w100p"><button type="button" onclick="OrderProc(document.frmorder);">결제하기</button></div>
							</div>
						</fieldset>
					</div>
				</form>
				</div>
			</div>
		</div>
		<!-- #include virtual="/apps/appCom/wish/webview/lib/inc/incFooter.asp" -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->