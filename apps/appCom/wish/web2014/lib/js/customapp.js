var C_APPURL = "http://m.10x10.co.kr/apps/appcom/wish/web2014";
var C_APPURLSSL = "http://m.10x10.co.kr/apps/appcom/wish/web2014";

const tenAppInfo = {
	any() {
		return this.Android() || this.iOS();
	},
	Android() {
		return navigator.userAgent.match(/Android/i) != null;
	},
	iOS() {
		return navigator.userAgent.match(/iPhone|iPad|iPod/i) != null;
	},
	version() {
		const index = navigator.userAgent.indexOf('tenapp');
		if( index === -1 ) {
			return 0;
		} else {
			const version = Number(navigator.userAgent.substr(index + 'tenapp '.length).substr(1));
			return isNaN(version) ? 0 : version;
		}
	},
	isAboveIOSSpecificVersion(version) {
		return this.iOS() && this.version() >= version;
	},
	isAboveAndroidSpecificVersion(version) {
		return this.Android() && this.version() >= version;
	}
};
function callNativeFunction(funcname, args) {
    if ( !args ) { args = {} }
    args['funcname'] = funcname;
	registerCallback(funcname, args);

	// 새로운 콜네이티브 함수 테스트 할 수 있도록 현재 버전보다 많이 높게 설정(현재 4점대) - 22.01.25
	if( tenAppInfo.isAboveIOSSpecificVersion(14.000) || tenAppInfo.isAboveAndroidSpecificVersion(14.000) ) {
		const messageValue = encodeURIComponent(JSON.stringify(args));
		if( tenAppInfo.Android() ) {
			tinterface.postMessage(messageValue);
		} else if ( tenAppInfo.iOS() ) {
			window.webkit.messageHandlers.tinterface.postMessage(messageValue);
		}
	} else {
		console.log("callNativeFunction", funcname);
		window.location = 'callnativefunction:' + encodeURIComponent(JSON.stringify(args));
	}
}

var _callbacks = [];

function registerCallback(funcname, args) {
    if ( !args['callback'] ) { return; }
    _callbacks[funcname] = args['callback'];
    delete args['callback'];
}

function callback(funcname, jsonString) {
    _callbacks[funcname](JSON.parse(decodeURIComponent(jsonString)));
}

function getDeviceAndVersion() {
	const navigatorVersion = window.navigator.appVersion;
	const index = navigatorVersion.indexOf('tenapp');
	if( index === -1 ) {
		return { device:'A', version:0 };
	} else {
		const info = navigatorVersion.substr(index + 'tenapp '.length);
		const device = info.substr(0,1);
		const version = Number(info.substr(1));
		return { device:device, version:version };
	}
}

//FROM_BOTTOM 추가 2014/09/20
var OpenType = {
    FROM_BOTTOM: "OPEN_TYPE__LNB_FROM_GNB",
    FROM_RIGHT: "OPEN_TYPE__FROM_RIGHT",
    FROM_BOTTOM: "OPEN_TYPE__FROM_BOTTOM"
}

var BtnType = {
    SEARCH: "BTN_TYPE__SEARCH",
    CART: "BTN_TYPE__CART",
    RESET: "BTN_TYPE__RESET",
    SHARE: "BTN_TYPE__SHARE",
    LNB: "BTN_TYPE__LNB",
    HOME: "BTN_TYPE__HOME"
}

var HeaderType = {
	DEFAULT: "HEADER_TYPE__DEFAULT", // 기본
	BLACK: "HEADER_TYPE__BLACK",
	WHITE: "HEADER_TYPE__WHITE",
	TRANSPARENT: "HEADER_TYPE__TRANSPARENT",
	TRANSPARENT_SHOW_CONTENT : "HEADER_TYPE__TRANSPARENT_SHOW_CONTENT", // 투명 배경 흰버튼 투명 타이틀 -> 스크롤 다운 하면 검은 배경 흰 타이틀 흰 버튼 (play 에서 사용)
	TRANSPARENT_WHITE_TITLE_IMAGE : "HEADER_TYPE__TRANSPARENT_WHITE_TITLE_IMAGE_V2", // 투명 배경 흰 버튼 타이틀 이미지1 -> 스크롤 다운 하면 검정 버튼 타이틀 이미지2
	TRANSPARENT_SHOW_BLACKCONTENT : "HEADER_TYPE__TRANSPARENT_SHOW_BLACKCONTENT" // 투명 배경 투명 타이틀 -> 스크롤 다운 하면 비어있게 처리
}

//카트수량
function fnAPPsetCartNum(num) {
    callNativeFunction('setCartNum', {"num": num});
    return false;
}

//주문수량
function isIntVal(value) {
  if (isNaN(value)) {
    return false;
  }
  var x = parseFloat(value);
  return (x | 0) === x;
}

function fnAPPsetOrderNum(num) {
    if (!isIntVal(num)) num=0;
    callNativeFunction('setOrderNum', {"num": num});
    return false;
}
//아이콘
function fnAPPsetMyIcon(myIconId) {
    callNativeFunction('setMyIcon', {"myIconId": myIconId});
    return false;
}
//쿠폰
function fnAPPsetMyCouponNum(num) {
    callNativeFunction('setMyCouponNum', {"num": num});
    return false;
}
//마일
function fnAPPsetMyMileageNum(num) {
    callNativeFunction('setMyMileageNum', {"num": num});
    return false;
}
//최근본상품
function fnAPPaddRecentlyViewedProduct(itemid) {
    callNativeFunction('addRecentlyViewedProduct', {"itemid": itemid});
    return false;
}

//최근본상품 받아오기
function fnAPPgetRecentlyViewedProducts() {
    callNativeFunction('getRecentlyViewedProducts', {"callback": getRecentlyViewedProductsApp});
    return false;
}

//메뉴이동
function fnAPPselectGNBMenu(menuid, url) {
    callNativeFunction('selectGNBMenu', {"menuid": menuid, "url": url});
    return false;
}

//메뉴이동 -- 다음버전 부터 적용 2017-06-23 이후버전
function fnAPPselectGNBMenuWithTop(menuid) {
    callNativeFunction('selectGNBMenuWithTop', {"menuid": menuid});
    return false;
}

//검색 초기화면 이동
function fnAPPpopupInit() {
   callNativeFunction('popupInit', {});
   return false;
}

//검색 TOP 이동
function fnAPPpopupScrollToTOP() {
   callNativeFunction('scrolltotop', {});
   return false;
}

//외부브라우져
function fnAPPpopupExternalBrowser(url) {
    callNativeFunction('popupExternalBrowser', {"url": url});
    return false;
}
//로그인 backpath 가 없으면 부모창 refresh ,backpath none 이면 액션 없음
function fnAPPpopupLogin(backpath) {
	// alert(backpath);
    if (!backpath) backpath="";

    callNativeFunction('popupLogin', {
    	"openType": OpenType.FROM_BOTTOM,
    	"ltbs": [],
    	"title": "로그인",
    	"rtbs": [],
    	"backpath": backpath
    });
    return false;
}

//purchase 로그인창 전용
function fnAPPpopupLoginDescription(backpath, des) {
    if (!backpath) backpath="";

	callNativeFunction('popupLogin', {
		  "openType": OpenType.FROM_BOTTOM,
		  "ltbs": [],
		  "title": "로그인",
		  "rtbs": [],
		  "backpath": backpath,
		  "description" : des // v2.18 에서 추가됨.
	});
	return false;
}

//로그인 처리후 ScriptFunc 실행용(v2.21 에서 추가됨.)
function fnAPPpopupLoginScriptFunc(scriptfunc) {
    if (!scriptfunc) scriptfunc="";

	callNativeFunction('popupLogin', {
		  "openType": OpenType.FROM_BOTTOM,
		  "ltbs": [],
		  "title": "로그인",
		  "rtbs": [],
		  "scriptfunc": scriptfunc
	});
	return false;
}

//purchase 로그인창 로그인 처리 후 ScriptFunc 실행용(v2.21에서 추가됨.)
function fnAPPpopupLoginDescriptionScriptFunc(scriptfunc, des, qp) {
    if (!scriptfunc) scriptfunc="";

	callNativeFunction('popupLogin', {
		  "openType": OpenType.FROM_BOTTOM,
		  "ltbs": [],
		  "title": "로그인",
		  "rtbs": [],
		  "scriptfunc": scriptfunc,
		  "description" : des, // v2.18 에서 추가됨.
		  "queryParam" : qp
	});
	return false;
}

//로그아웃
function fnAPPLogout() {
    callNativeFunction('callLogout');
    return false;
}

// 비밀번호 변경 요청 완료시 호출
function fnChangedPassWord() {
    callNativeFunction('changedPassWord', { });
	return false;
}

//카테고리 displaytype param 추가 //"ne","be","re","hp","lp",("sale") 
function fnAPPpopupCategory(categoryid,displaytype) {
    if (!displaytype) displaytype="be";
    categoryid=categoryid+''; //2015/11/09
    callNativeFunction('popupCategory', {
    	"openType": OpenType.FROM_RIGHT,
    	"ltbs": [],
    	"title": "카테고리",
    	"rtbs": [BtnType.CART],
    	"categoryid": categoryid,
    	"displaytype": displaytype
    });
    return false;
}

//브랜드
function fnAPPpopupBrand(brandid){
    callNativeFunction('popupBrand', {
    	"openType": OpenType.FROM_RIGHT,
    	"ltbs": [],
    	"title": "브랜드",
    	"rtbs": [BtnType.SEARCH, BtnType.CART],
    	"brandid": brandid
	});
	if ($(".modalV20.show").length) {
		$("body").removeClass("noscroll");
		$(".modalV20").removeClass('show');
		setTimeout(function(){
			if (location.search.indexOf('gnbflag=1') > -1) {
				// alert('fnAPPpopupBrand\nsetGnbTabbarDim');
				fnSetGnbTabbarDim(false);
			} else {
				// alert('fnAPPpopupBrand\nsetHeaderDim');
				fnSetHeaderDim(false);
			}
		},10);
	}
    return false;
}

//검색
function fnAPPpopupSearch(rect, search_type){
    callNativeFunction('popupSearch', {"rect": rect, "search_type" : search_type != null ? search_type : "all"});
    return false;
}

//검색 - 하위팝업창 유지 (piece 에서 쓰임)
function fnAPPpopupSearchOnNormal(rect, search_type) {
	callNativeFunction('popupSearchOnNormal', {"rect": rect, "search_type" : search_type != null ? search_type : "product"});
	return false;
 }

//현재 팝업 닫기
function fnAPPclosePopup(){
    callNativeFunction('closePopup');
    return false;
}
//부모창 닫기
function fnCloseParentBrowserPopup(){
	callNativeFunction('closeParentBrowserPopup');
    return false;
}
//팝업
function fnAPPpopupBrowser(openType, leftToolBarBtns, title, rightToolBarBtns, iurl, pageType) {
    if (!pageType) pageType="";
    callNativeFunction('popupBrowser', {
    	"openType": openType,
    	"ltbs": leftToolBarBtns,
    	"title": title,
    	"rtbs": rightToolBarBtns,
    	"url": iurl,
    	"pageType": pageType
    });
    return false;
}

// 리뉴얼 팝업
function fnAPPpopupBrowserRenewal(openType, title, url, pageType, headerType) {
	if (!pageType) pageType="";

	/**
	 * 오픈 구분
	 * 참고: http://confluence.tenbyten.kr:8090/pages/viewpage.action?pageId=59030927
	 */
	switch (openType) {
		case 'push' : openType = OpenType.FROM_RIGHT; break;
		default : openType = OpenType.FROM_BOTTOM;
	}

	// 헤더구분
	switch(headerType) {
		case 'white' : headerType = HeaderType.WHITE; break;
		case 'blank' : headerType = HeaderType.TRANSPARENT_SHOW_BLACKCONTENT; break;
		default : headerType = HeaderType.WHITE
	}

	callNativeFunction('popupBrowser', {
		"openType": openType,
		"ltbs": [],
		"title": title,
		"rtbs": [BtnType.SEARCH, BtnType.CART],
		"url": url,
		"pageType": pageType,
		"headerType" : headerType,
		"scrollTitle" : "on"
	});

	// 모달 닫기
	if ($(".modalV20.show").length) {
		$("body").removeClass("noscroll");
		$(".modalV20").removeClass('show');
		// $('html').removeClass('not_scroll');
		// $('html').animate({scrollTop : currentY}, 0);
		setTimeout(function(){
			if (location.search.indexOf('gnbflag=1') > -1) {
				// alert('fnAPPpopupBrowserRenewal\nsetGnbTabbarDim');
				fnSetGnbTabbarDim(false);
			} else {
				// alert('fnAPPpopupBrowserRenewal\nsetHeaderDim');
				fnSetHeaderDim(false);
			}
		},10);
	}
	return false;
}

// 리뉴얼 모달 (헤더 + 상태바)
function fnSetHeaderDim(show_flag) {
	callNativeFunction('setHeaderDim', {
		"show": show_flag.toString(),
	});
}

// 리뉴얼 모달 - 메인 (GNB 헤더 + 상태바 + 탭바)
function fnSetGnbTabbarDim(show_flag) {
	callNativeFunction('setGnbTabbarDim', {
		"show": show_flag.toString(),
	});
}

//팝업withURL
function fnAPPpopupBrowserURL(title,url,drt,pType,rtbs){
    var url = url;

//	var searchString = url.substring(url.indexOf('?')+1),
//	i, val, params = searchString.split("&");
//	var paramName = ["eventid","itemid","disp","makerid","rect"]

    var vDrt;
	var vRtbs;
    if (!pType) pType="";
    if(drt=="right") {
    	vDrt = OpenType.FROM_RIGHT;
    } else {
    	vDrt = OpenType.FROM_BOTTOM;
    }
	if(rtbs=="sc") {
    	vRtbs = [BtnType.SEARCH, BtnType.CART];
    } else if (rtbs=="vc"){
		vRtbs = [BtnType.SHARE, BtnType.CART];
    } else if (rtbs=="so"){
		vRtbs = [BtnType.SHARE];
    } else {
		vRtbs = [];
//		for (i=0;i<params.length;i++) {
//			val = params[i].split("=");
//			if (paramName.indexOf(val[0]) == 1){
//				vRtbs = [BtnType.SHARE];
//			}
//		}
    }
	fnAPPpopupBrowser(vDrt, [], title, vRtbs, url, pType);
	return false;
}

// piece 팝업
function fnAPPpopupPiece(title,url,drt,htype){
	var vDrt;
	var vHtype;

	if(drt=="right") {
    	vDrt = OpenType.FROM_RIGHT
    } else {
    	vDrt = OpenType.FROM_BOTTOM
    }

	if (htype=="share"){
		vHtype = HeaderType.TRANSPARENT
	} else {
		vHtype = HeaderType.BLACK
	}

	callNativeFunction('popupBrowser', {
    	"openType": vDrt,
    	"ltbs": [],
    	"title": title,
    	"rtbs": [],
    	"url": url,
    	"pageType": "",
		"headerType" : vHtype
    });
	return false;
}

// 팝업 header 상단 사용 
// tenfuluencer .. 등 
function fnAPPpopupTransparent(title,titleimageurl,url,drt,rtbs,htype){
	var vDrt;
	var vHtype;
	var vRtbs;
	var imageFormat = "\\.(bmp|gif|jpg|jpeg|png)$";
	var vUrl = C_APPURL + url;

	titleimageurl = ((new RegExp(imageFormat, "i")).test(titleimageurl)) ? btoa(titleimageurl) : titleimageurl ;
	vDrt = (drt=="right") ? OpenType.FROM_RIGHT : OpenType.FROM_BOTTOM ;

	switch (htype) {
		case "share" :
			vHtype = HeaderType.TRANSPARENT;
			break;
		case "titleimage" :
			vHtype = HeaderType.TRANSPARENT_WHITE_TITLE_IMAGE;
			break;
		default :
			vHtype = HeaderType.BLACK;
	}

	switch (rtbs) {
		case "sc" :
			vRtbs = [BtnType.SEARCH, BtnType.CART];
			break;
		case "vc" :
			vRtbs = [BtnType.SHARE, BtnType.CART];
			break;
		case "so" :
			vRtbs = [BtnType.SHARE];
			break;
		default :
			vRtbs = [];
	}

	callNativeFunction('popupBrowser', {
    	"openType": vDrt,
    	"ltbs": [],
		"title": title,
		"titleImageUrl" : titleimageurl,
    	"rtbs": vRtbs,
    	"url": vUrl,
    	"pageType": "",
		"headerType" : vHtype
    });
	return false;
}

//상품페이지 팝업
function fnAPPpopupProduct(itemid){
	var logparam;
	logparam = "";
	if (getParameter("eventid")){
		logparam = logparam + "&pEtr="+getParameter("eventid");
	}else if (getParameter("makerid")){
		logparam = logparam + "&pBtr="+getParameter("makerid");
	}else if (getParameter("pNtr")){
		logparam = logparam + "&pNtr="+getParameter("pNtr");
	}else if (getParameter("pEtr")){
		logparam = logparam + "&pEtr="+getParameter("pEtr");
	} else {
		logparam = "";
	}
    var url = C_APPURL+"/category/category_itemPrd.asp?itemid="+itemid+logparam;
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "상품정보", [BtnType.SHARE, BtnType.CART], url, "prd");
	return false;
}

// 2020 Renewal 상품페이지 팝업
function fnAPPpopupProductRenewal(itemid){
	// 모달 닫기
	if ($(".modalV20.show").length) {
		$("body").removeClass("noscroll");
		$(".modalV20").removeClass('show');
		// $('html').removeClass('not_scroll');
		// $('html').animate({scrollTop : currentY}, 0);
		if (location.search.indexOf('gnbflag=1') > -1) {
			// alert('fnAPPpopupProductRenewal\nsetGnbTabbarDim');
			fnSetGnbTabbarDim(false);
		} else {
			// alert('fnAPPpopupProductRenewal\nsetHeaderDim');
			fnSetHeaderDim(false);
		}
	}
	setTimeout("fnAPPpopupProduct("+itemid+")",10);
}

// 상품페이지 팝업 with Url
function fnAPPpopupProduct_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "상품정보", [BtnType.SHARE, BtnType.CART], url, "prd");
	return false;
}

//이벤트 팝업
function fnAPPpopupEvent(evtid){
    var url = C_APPURL+"/event/eventmain.asp?eventid="+evtid;
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "기획전", [BtnType.SHARE, BtnType.CART], url, "event");
	return false;
}

//주년 이벤트 전용
function fnAPPpopupEvent_14th(evtid){
    var url = C_APPURL+"/event/eventmain.asp?eventid="+evtid;
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "이벤트", [BtnType.SHARE, BtnType.CART], url, "14thevent");
	return false;
}

//이벤트 팝업 with Url
function fnAPPpopupEvent_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "기획전", [BtnType.SHARE, BtnType.CART], url, "event");
	return false;
}

//PLAY 팝업 with Url
function fnAPPpopupPlay_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "PLAYing", [BtnType.SHARE, BtnType.CART], url, "playing");
	//fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "PLAY", [BtnType.CART], url, "play");
	return false;
}

//PLAY 팝업 with Url
function fnAPPpopupPlayMore_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "PLAYing", [BtnType.SEARCH, BtnType.CART], url, "playing");
	//fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "PLAY", [BtnType.CART], url, "play");
	return false;
}

//브랜드 팝업 with Url
function fnAPPpopupBrend_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "브랜드", [BtnType.SEARCH, BtnType.CART], url, "brand");
	return false;
}

//CHANCE 팝업 with Url
function fnAPPpopupChance_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "CHANCE", [], url, "chance");
	return false;
}

//MDPICK 팝업 with Url
function fnAPPpopupMdPick_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "MD'S PICK", [BtnType.SEARCH, BtnType.CART], url, "mdpick");
	return false;
}

//컬쳐스테이션 팝업 with Url
function fnAPPpopupCulture_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "컬쳐스테이션", [BtnType.SEARCH, BtnType.CART], url, "culture");
	return false;
}

//wish 팝업 with Url
function fnAPPpopupWish_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "WISH", [BtnType.SEARCH, BtnType.CART], url, "wish");
	return false;
}

//gift 팝업 with Url
function fnAPPpopupGift_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "GIFT", [BtnType.SEARCH, BtnType.CART], url, "gift");
	return false;
}

//BEST 팝업 with Url
function fnAPPpopupBest_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "BEST", [BtnType.SEARCH,BtnType.CART], url, "best");
	return false;
}

// ALL 이벤트 팝업 with Url
function fnAPPpopupAllEvent_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "이벤트", [], url, "event");
	return false;
}

// ALL 이벤트 메인 이동 with Title & Url
function fnAPPMoveEvent_URL(sTit,url){
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [BtnType.HOME], sTit, [BtnType.SEARCH,BtnType.CART], url, "event");
	return false;
}

//gifttoday 팝업 with Url
function fnAPPpopupGiftToday_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [BtnType.HOME], "GIFT", [BtnType.SEARCH,BtnType.CART], url, "gifttalk");
	return false;
}

//gifttoday 팝업 with Url
function fnAPPpopupCouponBook_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [BtnType.HOME], "쿠폰북", [BtnType.SEARCH,BtnType.CART], url, "couponbook");
	return false;
}

//playtoday 팝업 with Url
function fnAPPpopupPlayToday_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [BtnType.HOME], "PLAY", [BtnType.SEARCH,BtnType.CART], url, "play");
	return false;
}

//NEW 팝업 with Url
function fnAPPpopupNEW_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "NEW", [BtnType.SEARCH,BtnType.CART], url, "mdpick");
	return false;
}

//SALE 팝업 with Url
function fnAPPpopupSALE_URL(url){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "SALE", [BtnType.SEARCH,BtnType.CART], url, "mdpick");
	return false;
}

//ClearanceSALE 팝업 with Url
function fnAPPpopupClearance_URL(url){
	var outurl = C_APPURL+url;
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "CLEARANCE", [BtnType.SEARCH,BtnType.CART], outurl, "mdpick");
	return false;
}

//my10x10
function fnAPPpopupMy10x10(){
	var url = C_APPURL+"/my10x10/mymain.asp";
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "마이텐바이텐", [BtnType.SEARCH, BtnType.CART], url, "my10x10");
	return false;
}

//상품후기
function fnAPPpopupMyGoodsusing(){
	var url = C_APPURL+"/my10x10/goodsusing.asp";
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "상품후기", [], url, "my10x10");
	return false;
}

//쿠폰 팝업 상품 정보
function fnAPPpopupCouponItem(url){
	var outurl = C_APPURL+url;
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "쿠폰 적용상품", [], outurl, "my10x10");
	return false;
}

//리뉴얼이후 EVENT 팝업홈
function fnAPPpopupEventMain(){
	var url = C_APPURL+"/shoppingtoday/shoppingchance_allevent.asp";
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "기획전", [], url, "allevent");
	return false;
}

//리뉴얼이후 EVENT 팝업홈
function fnAPPpopupEventMain_S(a){
	var addparam , addname
	if (a == 1){
		addparam = "?scTgb=planevt&gaparam=today_menu_salepromo";
		addname = "기획전";
	}else if (a == 2){
		addparam = "?scTgb=mktevt&gaparam=today_menu_event";
		addname = "이벤트";
	}else if (a == 3){ //마감임박기획전
		addparam = "?scTgb=planevt&selOP=1";
		addname = "기획전";
	}
	var url = C_APPURL+"/shoppingtoday/shoppingchance_allevent.asp"+addparam;
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], addname, [BtnType.SEARCH, BtnType.CART], url, "allevent");
	return false;
}

//선택 링크 팝업
function fnAPPpopupCustomUrl(url,appdiv){
	if (appdiv == "2"){//이벤트
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupEvent_URL(url2);
	} else if (appdiv == "1"){//상품상세
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupProduct_URL(url2);
	} else if (appdiv == "3"){//브랜드
		url = url.replace(/\makerid=/g, "");
		fnAPPpopupBrand(url);
	} else if (appdiv == "4"){//카테고리
		var categoryid = url;
		fnAPPpopupCategory(categoryid);
	} else if (appdiv == "5"){//ground
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupPlay_URL(url2);
	} else if (appdiv == "6"){//style+
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupPlay_URL(url2);
	} else if (appdiv == "7"){//fingers
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupPlay_URL(url2);
	} else if (appdiv == "8"){//t-episode
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupPlay_URL(url2);
	} else if (appdiv == "9"){//gift
		var url2 = "http://m.10x10.co.kr"+url;
		fnAPPpopupGift_URL(url2);
		//fnAPPselectGNBMenu('gift',url2);
	}
}

//장바구니 팝업
function fnAPPpopupBaguni(){
    var url = C_APPURL+"/inipay/ShoppingBag.asp";
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "장바구니", [], url, "cart");
	return false;
}

//바로구매 팝업
function fnAPPpopupBaguniUserinfo(param){
    var url = C_APPURLSSL+"/inipay/UserInfo.asp";
    if (param) url=url+param;
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], "장바구니", [], url, "cart");
	return false;
}

//function fnAPPRCVpopSNS(){
//alert('SNS 오픈 pop');
//return false;
//}

//위시 수량 변경
function fnAPPaddWishCnt(itemid,n){
	callNativeFunction('addWishCnt', {"itemid": itemid,"addcnt": n});
    return false;
}

//현재 팝업창 캡션 변경
function fnAPPchangPopCaption(caption){
	callNativeFunction('changPopCaption', {"caption": caption});
    return false;
}

//현재 팝업 타이틀 감추기
function fnAPPhideTitle(){
    callNativeFunction('hideTitle');
    return false;
}

//현재 팝업 타이틀 보이기
function fnAPPshowTitle(){
    callNativeFunction('showTitle');
    return false;
}

//오픈 창 Js호출
function fnAPPopenerJsCall(jsfunc){
    callNativeFunction('openerJsCall', {"jsfunc": jsfunc});
    return false;
}

//현재 창 닫으면서 오픈 창 Js호출
function fnAPPopenerJsCallClose(jsfunc){
    callNativeFunction('openerJsCallClose', {"jsfunc": jsfunc});
    return false;
}

//현재 팝업 LEFT 버튼hidtory 감추기
function fnAPPhideLeftBtns(){
    callNativeFunction('hideLeftBtns');
    return false;
}

//기존 버전 고려
//앱 로그인창 호출
function calllogin(){
    fnAPPpopupLogin('');
}
// gotoday
function callgotoday(){
    fnAPPselectGNBMenu("today",C_APPURL+"/today/index.asp");
}
//앱 메인페이지로 이동
function callmain(){
    callgotoday();
}
//앱 이벤트로 이동
function callevent(){
    fnAPPselectGNBMenu("event",C_APPURL+"/shoppingtoday/shoppingchance_allevent.asp");
}

//앱 이벤트에서 gnb로 이동 2015-06-01 유태욱
function callgnb(gname,gurl){
    fnAPPselectGNBMenu(gname,gurl);
}

//앱 메뉴이동
function seltopmenu(id){
    fnAPPselectGNBMenu(id,"");
}
//장바구니 숫자 변경
function cartnum(num){
    fnAPPsetCartNum(num);
}
//외부브라우저 호출
function openbrowser(url){
    fnAPPpopupExternalBrowser(url);
}

//이벤트 링크 이동
function openevent(url){
    fnAPPselectGNBMenu("event",url);
}

//이벤트 링크 이동
function fnLoadUrl(url) {
    callNativeFunction('loadUrl', {
        "url": C_APPURL+url
	});
	return false;
}

//track 2016-09-29 원승현 수정
function fnAPPsetTrackLog(trackType,trackval1,trackval2,trackval3){
    if (!trackval2) trackval2="";
    if (!trackval3) trackval3="";
    callNativeFunction('setTrackLog', {"tracktype": trackType, "trackval1":trackval1, "trackval2":trackval2, "trackval3":trackval3 });
    return false;
}

//appboy 커스텀 이벤트
function fnAPPappBoyCustomEvent(evtnm, properties){
	console.log("fnAPPappBoyCustomEvent");
	if (!evtnm) evtnm="";
	if (!properties) properties="";

	callNativeFunction('appboyCustomEvent', {"appboyCustomEventName":evtnm, "appboyProperties":JSON.stringify(properties)});
}

//appboy결제로그
function fnAPPappBoyLogPurChase(purchaseVal){

	console.log("fnAPPappBoyLogPurChase");
	callNativeFunction('appboyLogPurchase', {
		"appboyLogPurchase": purchaseVal
	});
}

function fnAppBoyPurchasedd(v)
{
	v = JSON.parse(v);
	fnAPPappBoyLogPurChase(v);
}

//appboyCustomAttributes
function fnAPPappboyCustomUserAttributes(attributesVal) {
    console.log("fnAPPappboyCustomUserAttributes");
    callNativeFunction('appboyCustomUserAttributes', {
        "appboyCustomUserAttributes" : attributesVal
    });
}

//appboyUserAttributes
function fnAPPappboyUserAttributes(userAttributesVal) {
    console.log("fnAPPappboyUserAttributes");
    callNativeFunction('appboyUserAttributes', {
        "appboyUserAttributes" : userAttributesVal
    });
}

//amplitudeCustomAttributes
function fnAmplitudeCustomUserAttributes(attributesVal) {
    console.log("fnAmplitudeCustomUserAttributes");
    callNativeFunction('amplitudeCustomUserAttributes', {
        "amplitudeCustomUserAttributes" : attributesVal
    });
}

//amplitudeLogEventProperties
function fnAmplitudeLogEventProperties(eventType, propertiesJson) {
	console.log("fnAmplitudeLogEventProperties");
	if (!eventType) eventType="";
	if (!propertiesJson) propertiesJson="";

	callNativeFunction('amplitudeLogEventProperties', {
		'amplitudeLogEventProperties' : {
			"eventType" : eventType,
			"properties" : propertiesJson
		}
	});
}

//amplitudeRevenue
function fnAmplitudeRevenue(JsonValue) {
	console.log("fnAmplitudeRevenue");
	callNativeFunction('amplitudeRevenue', {
		'amplitudeRevenue' : {
			products : JsonValue
		}
	});
}

//Revenue EventSend
function fnAPPRevenueEventSend(valuesJson) {
    console.log("fnAPPRevenueEventSend");
    if (!valuesJson) valuesJson="";
	valuesJson = JSON.parse(valuesJson);
    callNativeFunction('RevenueEventSend', {
        'ValuesJson' :  valuesJson
    });
}

//Moloco Event Send
function fnAPPmolocoEventSend(EvtType, Data) {
	console.log("fnAPPmolocoEventSend");
	if (!EvtType) EvtType="";
	if (!Data) Data="";

	callNativeFunction('molocoEventSend', {
		"MolocoEvtType" : EvtType,
		"MolocoEvtData" : Data
	});
}

//SwipeCancelArea
function fnSetSwipeCancelArea(x1,y1,x2,y2,width){
    callNativeFunction('setSwipeCancelArea', {"x1":x1, "y1":y1, "x2":x2, "y2":y2, "width":width});
    return false;
}

//SwipeCancelArea(복수)
function fnSetSwipeCancelAreas(vAreas){
    callNativeFunction('setSwipeCancelAreas', {'item':vAreas});
    return false;
}

//ngTrack
function fnAPPsetNudgeTrack(cmdType,idx,param1,param2){
    callNativeFunction('setNudgeTrack', {"cmdType": cmdType, "idx":idx, "param1":param1, "param2":param2 });
    return false;
}

//SNS 로그인 연동 수정 (연결/해제)
function fnAPPChgSNSLoginConn(snsgubun,stype){
    callNativeFunction('changeSNSLogin', {"gubun": snsgubun, "type": stype});
    return false;
}

//SNS 로그인 연동 회원가입 호출
function fnAPPSNSJoin(snsgubun){
    callNativeFunction('callSNSJoin', {"gubun": snsgubun});
    return false;
}

// 2015-11-19 파라미터 체크용
function getParameter(paramName) {
  var searchString = window.location.search.substring(1),
      i, val, params = searchString.split("&");

  for (i=0;i<params.length;i++) {
    val = params[i].split("=");
    if (val[0] == paramName) {
      return val[1];
    }
  }
  return null;
}

//마이텐바이텐 정보 설정
function fnAPPpopupSetting(){
    callNativeFunction('popupSetting', {});
    return false;
}
//마이텐바이텐 소식 보기
function fnAPPpopupNotiList(){
    callNativeFunction('popupNotiList', {});
    return false;
}
//마이텐바이텐 주문조회
function fnAPPmoveTabMenu(tabId){
    callNativeFunction('moveTabMenu', {"tabId": tabId});
    return false;
}

//자동 링크 팝업 파라메터체크
function getParam(url) {
	var searchString = url.substring(url.indexOf('?')+1),
	  i, val, params = searchString.split("&");
	var paramName = ["eventid","itemid","disp","makerid","rect","brandid","keyword"]
	var outurl = C_APPURL+url;

	for (i=0;i<params.length;i++) {
		val = params[i].split("=");
		if (paramName[paramName.indexOf(val[0])] == val[0] ) {
			if (paramName.indexOf(val[0]) == 0){
				if(outurl.indexOf('93354') != -1){
					//100원의 기적 예외처리	
					outurl = outurl.replace("93354", "93355");
				}
				fnAPPpopupEvent_URL(outurl); // 이벤트
				return false;
			}else if (paramName.indexOf(val[0]) == 1){
				fnAPPpopupProduct_URL(outurl); // 상품
				return false;
			}else if (paramName.indexOf(val[0]) == 2){
					if (url.indexOf("/shoppingtoday/") != -1) {
						fnAPPpopupBrowserURL('기획전',outurl);
					} else {
						fnAPPpopupCategory(val[1]); // 카테고리
					}
				return false;
			}else if (paramName.indexOf(val[0]) == 3){
				fnAPPpopupBrand(val[1]); // 브랜드
				return false;
			}else if (paramName.indexOf(val[0]) == 4){
				fnAPPpopupSearch(val[1]); // 검색
				return false;
			}else if (paramName.indexOf(val[0]) == 5){
				fnAPPpopupBrand(val[1]); // 브랜드
				return false;
			}else if (paramName.indexOf(val[0]) == 6){
				fnAPPpopupSearch(val[1]); // 검색
				return false;
			}
		}else{
			if (url.indexOf("/dramazone/") != -1 && params.length == 1) {
				fnAPPselectGNBMenu('dramazone',outurl);
				return false;
			}else if(url.indexOf("/tenquiz/") != -1 ) {
				fnAPPpopupBrowserURL('텐퀴즈',outurl);
				return false;
			}else if(url.indexOf("/snsitem/") != -1 ) {
				fnAPPpopupBrowserURL('sns 인기템',outurl);
				return false;
			}else if(url.indexOf("/salelife/") != -1 ) {
				fnAPPpopupBrowserURL('세라밸',outurl);
				return false;
			}else if(url.indexOf("/tenfluencer/") != -1 ) {
				fnAPPpopupTransparent('tenfluencer','http://fiximage.10x10.co.kr/m/2019/platform/tenfluencer.png',url,'right','sc','titleimage');
				return false;
			}else if(url.indexOf("/diarystory2020/") != -1) {
				fnAPPpopupBrowserURL('다이어리 스토리',outurl,'right','','sc');
				return false;
			}else if(url.indexOf("/my10x10/couponbook.asp") != -1) {
				fnAPPpopupBrowserURL('쿠폰북',outurl,'right','','sc');
				return false;
			}else if(url.indexOf("/event/apple/") != -1) {
				fnAPPpopupBrowserURL('애플관',outurl,'right','','sc');
				return false;
			}else if(url.indexOf("/tenten_exclusive/") != -1) {
				fnAPPpopupBrowserURL('텐텐단독상점',outurl,'right','','sc');
				return false;
			}else{
				fnAPPpopupEvent_URL(outurl);
				return false;
			}
		}
	}
  return null;
}

//자동 링크 팝업
function fnAPPpopupAutoUrl(url){
	getParam(url);
	return false;
}

//sns를 이용한 콘텐츠 공유
function fnAPPShareSNS(snsgubun, url, item_id, item_name, kind){
	 console.log("fnAPPShareSNS", snsgubun, url, item_id, item_name, kind);    
	 callNativeFunction('shareSNS', {
	 	"gubun": snsgubun,
		 "url": url,
		 'itemid' : item_id,
		 'itemname': item_name,
		 'kind': kind
	 });
}

// 차후 위 스크립트로 합칠 예정 임시 분리
// line을 이용한 콘텐츠 공유
function fnAPPShareLine(title, url, item_id, item_name, kind){
    console.log("fnAPPShareLine", title, url, item_id, item_name, kind);
    callNativeFunction('shareLine', {
    	"title": title,
		"url": url,
		'itemid': item_id,
		'itemname': item_name,
		'kind' : kind
    });
}

//  twitter을 이용한 콘텐츠 공유
function fnAPPShareTwitter(title, url, item_id, item_name, kind){
    console.log("fnAPPShareTwitter", title, url, item_id, item_name, kind);
    callNativeFunction('shareTwitter', {
    	"title": title,
		"url": url,
		'itemid': item_id,
		'itemname': item_name,
		'kind': kind
    });
}

//딜 상품 상세 열기
function fnAPPpopupDealProduct(itemid){
	var logparam;
	logparam = "";
	if (getParameter("eventid")){
		logparam = logparam + "&pEtr="+getParameter("eventid");
	}else if (getParameter("makerid")){
		logparam = logparam + "&pBtr="+getParameter("makerid");
	}else if (getParameter("pNtr")){
		logparam = logparam + "&pNtr="+getParameter("pNtr");
	}else if (getParameter("pEtr")){
		logparam = logparam + "&pEtr="+getParameter("pEtr");
	} else {
		logparam = "";
	}
    var url = C_APPURL+"/deal/deal.asp?itemid="+itemid+logparam;
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "텐텐딜", [BtnType.SHARE, BtnType.CART], url, "prd");
	return false;
}

// kakao를 이용한 콘텐츠 공유 
function fnAPPshareKakao(type, title,  weburl, mobileweburl, appurl, imageurl, regularprice, discountprice, discountrate, desc, item_id, item_name, kind){
	console.log("fnAPPshareKakao", type, title,  weburl, mobileweburl, appurl, imageurl, regularprice, discountprice, discountrate, desc, item_id, item_name, kind);
	callNativeFunction('shareKakao', {
		"shareKakaoInfo" : {
			"type" : type,
			"title" : title,
			"weburl" : weburl,
			"mobileweburl" : mobileweburl,
			"appurl" : appurl,
			"imageurl" : imageurl,
			"regularprice" : regularprice,
			"discountprice" : discountprice,
			"discountrate" : discountrate,
			"desc" : desc,
			'itemid' : item_id,
			'itemname' : item_name,
			'kind' : kind
		}
	});
}

//instagram을 이용한 콘텐츠 공유
function fnAPPShareInstagram(imageurl, item_id, item_name, kind){
	console.log("fnAPPShareInstagram", imageurl, item_id, item_name, kind);
	imageurl = btoa(imageurl);
    callNativeFunction('shareInstagram', {
    	"imageurl": imageurl,
		'itemid': item_id,
		'itemname': item_name,
		'kind': kind
    });
}

// Pinterest 이용한 콘텐츠 공유
function fnAPPSharePinterest(item_id, item_name, kind){
	console.log('fnAPPSharePinterest', item_id, item_name, kind)
	callNativeFunction('sharePinterest', {
		'itemid': item_id,
		'itemname': item_name,
		'kind': kind
	});
}

// SignUpEvent For Fabric
function fnAPSignUpEvent(uq) {
    console.log("SignUp");
    callNativeFunction('signUpEvent', {"retrieved_user_id":uq});
}

// play 상세형 상세 페이지 - 전체보기 버튼
function fnPopupPlayContentsHome(contentName, cidx) {
	console.log("fnPopupPlayContentsHome");
	callNativeFunction('popupPlayContentsHome', {
		"contentName" : contentName,
		"cidx" : cidx 
	});
}

// play 상세형 상세 페이지 - Record처리
function fnSetPlayRecord(pidx, record) {
	console.log("fnSetPlayRecord");
	callNativeFunction('setPlayRecord', {
		"contents_pidx" : pidx,
		"record" : record    
	});
}

// 상품상세 이미지 native 전달 (히스토리 최근본 상품 이미지 1개)
function fnRecentItemImage(img) {
	console.log("fnRecentItemImage");
    callNativeFunction('recentItemImage', {
        "img" : img
    });
}

// 스토어 별점리뷰 등록 유도 팝업
function fnShowStoreReview() {
    console.log("fnShowStoreReview");
    callNativeFunction('showStoreReview', {
    });
}

//function fnUpdateCookieForWKWebView() {
//	window.webkit.messageHandlers.wish_updateCookies.postMessage(document.cookie);
//	console.log('UPDATE COOKIE (Document -> HTTP)');
//	console.log(document.cookie);
//}
// 성인 인증이 성공한 시점에 호출
function fnValidationAdult() {
	callNativeFunction('validationAdult', {
	})
}
function fnAPPcloseParentBrowserPopup(isAdult){
    callNativeFunction('closeParentBrowserPopup', {
		"validationAdult" : isAdult // 성인 인증 상태		
	});
	return false;
}
function fnSetAlwaysFixHeader() {
    callNativeFunction('setAlwaysFixHeader', {
    });
}

// 상품상세 데이터 전송(브랜치 이벤트용)
function fnViewProduct(itemid, price, product_name, quantity, currency, product_category) {
	callNativeFunction('viewProduct', {
		"itemid":itemid,
		"quantity":quantity,
		"price":price,
		"currency":currency,
		"product_name":product_name,
		"category":product_category
	});
}

// 상품상세 장바구니 담기 데이터 전송(브랜치 이벤트용)
function fnAddToCart(itemid, price, product_name, quantity, currency, product_category) {
	callNativeFunction('addToCart', {
		"itemid":itemid,
		"quantity":quantity,
		"price":price,
		"currency":currency,
		"product_name":product_name,
		"category":product_category
	});
}

// SNS 로그인 이후 텐바이텐 계정연결 팝업 호출
function fnPopupSnsJoin() {
    callNativeFunction('popupSnsJoin', {});
	return false;
}

// 로딩 이미지 컨트롤
function fnSetLoadingIndicator(flag) {
	callNativeFunction('setLoadingIndicator', {
		"show": flag.toString(),
	});
}

// 상품 위시(datadive)
function fnSetWishProduct(item_id, item_name, is_wish) {
	callNativeFunction('setWishProduct', {
		"item_id": item_id,
		"item_name": item_name,
		"wish" : is_wish
	});
}

// 브랜드 위시(datadive)
function fnSetWishBrand(brand_id, brand_name, is_wish) {
	callNativeFunction('setWishBrand', {
		"brand_id": brand_id,
		"brand_name": brand_name,
		"wish" : is_wish }
	);
}

// 기획전/이벤트 뷰 호출(datadive)
function fnViewEvent(event_id, event_name) {
	callNativeFunction('viewEvent', {
		"event_id": event_id,
		"event_name": event_name
	});
}

// 기획전/이벤트 참가(datadive)
function fnApplyEvent(event_id, event_name) {
	callNativeFunction('applyEvent', {
		"event_id": event_id,
		"event_name": event_name
	});
}

//외부 브라우저 열기(url : base64 Encoding)
function fnOpenExternalBrowser(url) {
	callNativeFunction('openExternalBrowser', {
		"url": url
	});
}

// 상품 위시(datadive)
function fnShowToast() {
	callNativeFunction('showToast', {
		"message": "toast"
	});
}

//웹뷰에서 로그인 요청시 호출
function fnRequestLogin(userid,pwd,autologin) {
	callNativeFunction('requestLogin', {
	"user_id": userid,
	"user_pw": pwd,
	"autologin" : autologin });
}

//히치하이커 구독 팝업
function fnAPPpopupHitchhikerSubscribe(){
	const url = C_APPURL+"/category/category_itemPrd.asp?itemid=1496196&hAmpt=sub";
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], "상품정보", [BtnType.SHARE, BtnType.CART], url, "prd");
	return false;
}

//회원가입시 인증 문자 감지 실행
//caller : 인증 문자 발신 번호('-' 없는 숫자만) (기본 : 16446030) 
function fnRunSMSDetect() {
    callNativeFunction('runSMSDetect', {
    "caller": ""});
}

// 베스트 팝업
// IOS(4.043) or Android(4.048) 이상만 네이티브 베스트 팝업. 그 외는 기존 웹뷰 베스트페이지 팝업
function fnPopupBest(oldBestUrl) {
	const versionInfo = getDeviceAndVersion();
	if( (versionInfo.device === 'I' && versionInfo.version >= 4.043)
		|| (versionInfo.device === 'A' && versionInfo.version >= 4.048) ) {
		callNativeFunction('popupBest', {});
	} else {
		fnAPPpopupBrowserRenewal('push', 'BEST', oldBestUrl);
	}
}

//애피어 이벤트 로그 전송
function fnAppierLogEventProperties(eventType, propertiesJson) {
	console.log("fnAppierLogEventProperties :", eventType);
	console.log(propertiesJson);
	callNativeFunction('appierLogEventProperties', {
		'appierLogEventProperties' : {
			"eventType": eventType
			, "properties" : propertiesJson
		}
	});
}

function fnAppierProductsLogEventProperties(eventType, propertiesJson) {
	console.log("fnAppierProductsLogEventProperties :", eventType);
	console.log(propertiesJson);
	callNativeFunction('appierProductsLogEventProperties', {
		"appierLogEventProperties" : {
			"eventType" :  eventType
			, "products": propertiesJson
		}
	});
}

function makeItemDynamicLongLink(itemid){
	let url = "https://tenbyten.page.link/?";
	let link = "https://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=" + itemid + "&isFIRDynamicLink=true";

	/*IOS*/
	url += "link=" + encodeURIComponent(link);
	url += "&ibi=kr.co.10x10.wish";
	url += "&isi=864817011";
	url += "&ius=tenwishapp";
	url += "&efr=1";
	/*Android*/
	url += "&apn=kr.tenbyten.shopping";
	url += "&amv=99251";

	$.ajax({
		type: "POST",
		url: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyDSNXV6tYgTBetChYR8NU2jKxCI_ldVMcM",
		data: {"longDynamicLink" : url},
		ContentType: "json",
		crossDomain: true,
		success: function(data){
			//console.log(data);
			url = data.shortLink;
		}
	});

	return url;
}