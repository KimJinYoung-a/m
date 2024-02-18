<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
'####################################################
' Description : 정기세일 메인
' History : 2020-03-20 이종화
'####################################################
dim currentDate
dim aType : aType = Request.Cookies("sale2020")("atype")
dim vDisp : vDisp = Request.Cookies("sale2020")("disp")
dim dateGubun : dateGubun = Request.Cookies("sale2020")("dategubun")
dim page : page = 1
dim dataUrl
dim eCode

currentDate = date()
'currentDate = "2020-04-20"

IF application("Svr_Info") = "Dev" THEN
	eCode   =  101593
Else
	eCode   =  101722
End If

dim iscouponeDown, vQuery, eventCoupons
iscouponeDown = false
IF application("Svr_Info") = "Dev" THEN
	eventCoupons = "22245,22246,22247,22248,22244,22249,22250"	
Else
	eventCoupons = "89651,89652,89653,89655,89656,89657,89658"	
End If

vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & getencLoginUserid() & "'"
vQuery = vQuery + " and itemcouponidx in ("&eventCoupons&") "
vQuery = vQuery + " and usedyn = 'N' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
If rsget(0) = 7 Then
	iscouponeDown = true
End IF
rsget.close
'####################################################
' dt : 기간별
' ne : 신상품
' st : 스테디
' vi : 후기
' ex : 기획전
' js : 방금판매된
' lx : 럭셔리
' md : MDPICK
' wi : 위시
' "" : 혜택
' em : 기획전 & mdpick
'####################################################
%>
<% if currentDate <= "2020-04-12" then %>
<link rel="stylesheet" href="/event/sale2020/sale2020.css">
<% elseif currentDate >= "2020-04-13" then %>
<link rel="stylesheet" href="/event/sale2020/sale2020_0413.css">
<% end if %>
<script>
var vPg = "<%=page%>", vScrl=true;
var menuScrollTop = "";
$(function() {
	// sticky tab
	var menuTab = $(".tab-wrap").offset().top;
	menuScrollTop = menuTab;
	$(window).scroll(function(){
		if( $(window).scrollTop()>=menuTab ) {
			$(".tab-wrap").addClass("sticky");
		} else {
			$(".tab-wrap").removeClass("sticky");
		}
	});
	
	// Init
	init('<%=atype%>','<%=page%>','<%=vDisp%>');
	initTabDisplay('<%=atype%>');
	
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				var getType = document.frmSale2020.atype.value;
				var getDisp = document.frmSale2020.disp.value;            
				fnGetDataLists(getType,vPg,getDisp);
			}
		}
	});

	$(".tab-wrap ul li").click(function() {
		if($(this).closest("ul").hasClass("tab")) {
			$(".tab-wrap li").removeClass("on");
			$(this).addClass("on");

			$(this).index() == 0 ? init("",1,"") : "";
			$(this).index() == 1 ? function() {
				$(".best-sub").show();
				$(".best-sub").find("li").eq(0).addClass("on");
				init("dt",1,"");
			}()
			:
			$(".best-sub").hide();

			$(this).index() == 2 ? function() {
				$(".event-sub").show();
				$(".event-sub").find("li").eq(0).addClass("on");
				//init("ex",1,"");
				init("em",1,"");
			}()
			:
			$(".event-sub").hide();
			$(this).index() == 3 ? init("js",1,"") : "";
		}

		if($(this).closest("ul").hasClass("best-sub")) {
			$(".best-sub li").removeClass("on");
			$(this).addClass("on"); 
			//Best SubLink
			$(this).index() == 0 ? init("dt",1,"") : "";
			$(this).index() == 1 ? init("ne",1,"") : "";
			$(this).index() == 2 ? init("st",1,"") : "";
			$(this).index() == 3 ? init("wi",1,"") : "";
			$(this).index() == 4 ? init("vi",1,"") : "";
			$(this).index() == 5 ? init("lx",1,"") : "";
		}

		if($(this).closest("ul").hasClass("event-sub")) {
			$(".event-sub li").removeClass("on");
			$(this).addClass("on"); 
			//기획전 SubLink
			// $(this).index() == 0 ? init("ex",1,"") : "";
			// $(this).index() == 1 ? init("md",1,"") : "";
			$(this).index() == 0 ? $("html, body").animate({ scrollTop: menuScrollTop},400) : "" ;
			$(this).index() == 1 ? $("html, body").animate({ scrollTop: $(".item-head").offset().top-120 },400) : "";
			
		}
	});

	// draw hole
	$(".items-slide li a").append('<i class="hole"></i>');    
});

function init(aType, page , vDisp) {
	aType != "" ? $("html, body").animate({ scrollTop: menuScrollTop },400) : "";
	fnGetParentElement(aType);
	fnGetDataLists(aType,page,vDisp);
	vPg = 1;
	document.frmSale2020.atype.value = aType;
	document.frmSale2020.disp.value = vDisp;
}

function initTabDisplay(aType) {
	$(".tab li").removeClass("on");
	var tabsArray1 = ["","dt","ex","js"],
		tabsArray2 = ["dt","ne","st","wi","lx","vi"],
		tabsArray3 = ["ex","md","em"];

	var aTypeIndex1 = tabsArray1.indexOf(aType),
		aTypeIndex2 = tabsArray2.indexOf(aType),
		aTypeIndex3 = tabsArray3.indexOf(aType);

	aTypeIndex1 >= 0 ? $(".tab li").eq(aTypeIndex1).addClass("on") : "";
	aTypeIndex2 >= 0 ? function() {
							$(".tab li").eq(1).addClass("on");
							$(".best-sub").show().find("li").eq(aTypeIndex2).addClass("on");
						}()
						: "";
	aTypeIndex3 >= 0 ? function() {
							$(".tab li").eq(2).addClass("on");
							//$(".event-sub").show().find("li").eq(aTypeIndex3).addClass("on")
							$(".event-sub").show().find("li").eq(0).addClass("on")
						}()
						: "";
}

function fnGetParentElement(aType) {
	var className = "";
	var parentElement = "";
	var $rootEl = $("#itemLists");
	var categorySearchFlag = false;
	switch (aType) {
		case "dt" :
		case "ne" :
		case "st" :
		case "wi" :
		case "lx" :
		case "vi" : // BEST
			className = "conts cont-best";
			categorySearchFlag = aType == "lx" ? false : true;
			ulClassName = aType == "vi" ? "items type-list tenten-best-default tenten-best-new tenten-best-review" : "items type-list";
			break;
		case "ex" :
		case "md" :
		case "em" : // 기획전
			className = "conts cont-event";
			categorySearchFlag = false;
			ulClassName = "";
			break;
		case "js" : // 방금 판매된
			className = "conts cont-now";
			categorySearchFlag = true;
			ulClassName = "items type-list";
			break;
		default: // 혜택
			className = "conts cont-benefit";
			categorySearchFlag = false;
			ulClassName = "item-card";
			break;
	}
	
	parentElement = '<div class="'+ className +'">'
	if (categorySearchFlag) {
		parentElement = parentElement + '<div class="filter-wrap">'
		parentElement = parentElement + '    <div class="filter">'
		parentElement = parentElement + '         <select class="select" onchange="fnChgDisp(this.value);">'
		parentElement = parentElement + '				<option <% if vDisp="" then %>selected<% end if %> value="">전체 카테고리</option>'
		parentElement = parentElement + '				<option <% if vDisp="101" then %>selected<% end if %> value="101">디자인문구</option>'
		parentElement = parentElement + '				<option <% if vDisp="102" then %>selected<% end if %> value="102">디지털/핸드폰</option>'
		parentElement = parentElement + '				<option <% if vDisp="104" then %>selected<% end if %> value="104">토이/취미</option>'
		parentElement = parentElement + '				<option <% if vDisp="124" then %>selected<% end if %> value="124">디자인가전</option>'
		parentElement = parentElement + '				<option <% if vDisp="121" then %>selected<% end if %> value="121">가구/수납</option>'
		parentElement = parentElement + '				<option <% if vDisp="122" then %>selected<% end if %> value="122">데코/조명</option>'
		parentElement = parentElement + '				<option <% if vDisp="120" then %>selected<% end if %> value="120">패브릭/생활</option>'
		parentElement = parentElement + '				<option <% if vDisp="112" then %>selected<% end if %> value="112">키친</option>'
		parentElement = parentElement + '				<option <% if vDisp="119" then %>selected<% end if %> value="119">푸드</option>'
		parentElement = parentElement + '				<option <% if vDisp="117" then %>selected<% end if %> value="117">패션의류</option>'
		parentElement = parentElement + '				<option <% if vDisp="116" then %>selected<% end if %> value="116">패션잡화</option>'
		parentElement = parentElement + '				<option <% if vDisp="125" then %>selected<% end if %> value="125">주얼리/시계</option>'
		parentElement = parentElement + '				<option <% if vDisp="118" then %>selected<% end if %> value="118">뷰티</option>'
		parentElement = parentElement + '				<option <% if vDisp="115" then %>selected<% end if %> value="115">베이비/키즈</option>'
		parentElement = parentElement + '				<option <% if vDisp="110" then %>selected<% end if %> value="110">Cat &amp; Dog</option>'
		parentElement = parentElement + '		 </select>'
		parentElement = parentElement + '        <span></span>'
		parentElement = parentElement + '    </div>'
		
		if (aType == "dt") {
			parentElement = parentElement + '    <div class="filter">'
			parentElement = parentElement + '        <select onchange="fnChgDate(this.value);">'
			parentElement = parentElement + '                <option <% if dateGubun="w" then %>selected<% end if %> value="w">주간</option>'
			parentElement = parentElement + '                <option <% if dateGubun="d" then %>selected<% end if %> value="d">일간</option>'
			parentElement = parentElement + '                <option <% if dateGubun="m" then %>selected<% end if %> value="m">월간</option>'
			parentElement = parentElement + '        </select>'
			parentElement = parentElement + '        <span></span>'
			parentElement = parentElement + '    </div>'
		}
		parentElement = parentElement + '</div>'
	}

	if (aType == "ex" || aType == "md" || aType == "" || aType == "em") {
		parentElement = parentElement + '<div class="list-wrap" id="dataList"></div>'    
	} else {
		parentElement = parentElement + '<div class="list-wrap"><ul class="'+ ulClassName +'" id="dataList"></ul></div>'
	}
	parentElement = parentElement + '</div>'

	$rootEl.empty().append(parentElement);
}

function fnGetDataLists(aType , page , vDisp) {
	if (page == 1) {
		$("#dataList").empty();
	}

	if (page > 1 && (aType == "md" || aType == "ex" || aType == "" || aType == "em")) {
		return false;
	}

	var dataUrl = "";
	switch (aType) {
		case "ne":
		case "st":
		case "vi":
		case "dt":
			dataUrl = "/event/sale2020/act_bestlists.asp"
			break;
		case "ex" :
			dataUrl = "/event/sale2020/act_exhibition.asp"
			break;
		case "js" :
			dataUrl = "/event/sale2020/act_justsold.asp"
			break;
		case "lx" :
			dataUrl = "/event/sale2020/act_luxury.asp"
			break;
		case "md" :
			dataUrl = "/event/sale2020/act_mdpick.asp"
			break;
		case "wi" :
			dataUrl = "/event/sale2020/act_wish.asp"
			break;
		case "em" :
			dataUrl = "/event/sale2020/act_eventandmdpick.asp"
			break;
		default :
			dataUrl = "/event/sale2020/act_benefit.asp"
			break;
	}

	$.ajax({
		url: dataUrl,
		data : {
			cpg : page,
			vdisp : vDisp,
			atype : aType,
			dategubun : document.frmSale2020.dategubun.value,
		},
		cache: false,
		success: function(message) {
			if(message!="") {
				$("#dataList").append(message);
				vScrl=true; // 스크롤 초기화
			} 
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

// 카테고리 검색
function fnChgDisp(disp) {
	var frm = document.frmSale2020;
	frm.disp.value = disp;
	vPg = 1;

	fnGetDataLists(frm.atype.value,1,disp);
}

// 기간별 일자 검색
function fnChgDate(dt) {
	var frm = document.frmSale2020;
	frm.dategubun.value = dt;

	fnGetDataLists(frm.atype.value,1,'');
}

function jsDownCouponSale2020(stype,idx){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
		return false;
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
					$(".coupon-section").hide();
					$('.lyr-pop').fadeIn();                    
				} else {
					alert(message.message);
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}
function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
<% end if %>
	return;
}

function couponPopupCloseSale2020() {
	$('.lyr-pop').fadeOut();
}
</script>
<div class="sale2020">
	<div class="top">
		<div class="inner">
		<h2>
			<span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_1.png" alt="365일"></span>
			<span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_2.png" alt="꿈꾸던"></span>
			<span class="t3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_3.png" alt="바로 그 세일"></span>
		</h2>
		<% if currentDate >= "2020-04-13" and currentDate <= "2020-04-17" then %>
			<h2 class="tit-plus">
				<span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_4.png" alt="세일 상품이"></span>
				<span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_5.png" alt="추가"></span>
				<span class="t3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_6.png" alt="되었습니다"></span>
			</h2>
		<% elseif currentDate >= "2020-04-18" then %>
			<h2 class="tit-plus">
				<span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/tit_7.png" alt="세일이 곧 끝납니다."></span>
			</h2>
		<% end if %>

		<p class="total-items">
		<% if currentDate <= "2020-04-12" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_total_item_v2.png" alt="지금 509160개  상품 할인 중">
		<% elseif currentDate >= "2020-04-13" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_total_item_v3.png" alt="지금 716007개  상품 할인 중">
		<% end if %>
		</p>

		<button class="total-sale" onclick="jsDownCouponSale2020('prd,prd,prd,prd,prd,prd,prd','<%=eventCoupons%>');return false;">
		<% if currentDate <= "2020-04-12" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_total_sale_v2.png" alt="50%">
		<% elseif currentDate >= "2020-04-13" and currentDate <= "2020-04-19" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_total_sale_v3.png" alt="50%">
		<% elseif currentDate = "2020-04-20" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_total_sale_v4.png" alt="오늘이 마지막">
		<% end if %>
		</button>

		<span class="dday">
		<% if currentDate = "2020-04-18" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_dday2.png" alt="d-day2">
		<% elseif currentDate = "2020-04-19" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_dday1.png" alt="d-day1">
		<% elseif currentDate = "2020-04-20" then %>
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/txt_dday.png" alt="d-day">
		<% end if %>
		</span>

		<% if currentDate <= "2020-04-12" then %>
		<div class="items-slide items-slide1">
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2655011');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item1.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2744330');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1867137');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item3.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2175347');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item4.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2604910');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item5.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2189594');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item6.png?v=1.02" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2384245');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item7.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2707489');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item8.png" alt=""></span></a></li>
			</ul>
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2331349');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item9.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1113434');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item10.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2622363');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item11.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2759149');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item12.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2574519');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item13.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2708511');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item14.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2488689');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item15.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2710001');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item16.png" alt=""></span></a></li>
			</ul>
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1726011');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item17.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1555093');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item18.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('556050');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item19.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2142561');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item20.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2024918');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item21.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2515825');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item22.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2134616');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item23.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1900168');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item24.png" alt=""></span></a></li>
			</ul>
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2686983');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item25.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2780520');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item26.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2580510');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item27.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2689404');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item28.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2703551');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item29.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2420183');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item30.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2624995');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item31.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2712265');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item32.png" alt=""></span></a></li>
			</ul>
		</div>        
        <% elseif currentDate >= "2020-04-13" then %>
		<div class="items-slide items-slide1">
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1981656');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item1_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('722620');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item2_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2134616');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item3_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2736582');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item4_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2510835');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item5_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2750463');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item6_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1689964');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item7_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2662083');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item8_v2.png" alt=""></span></a></li>
			</ul>
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2597804');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item9_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2273878');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item10_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2655011');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item11_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2774963');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item12_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2373969');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item13_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2601239');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item14_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2203135');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item15_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2638712');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item16_v2.png" alt=""></span></a></li>
			</ul>
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1878042');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item17_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('1961651');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item18_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2652045');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item19_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2795303');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item20_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2708338');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item21_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2793271');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item22_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2576498');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item23_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2497605');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item24_v2.png" alt=""></span></a></li>
			</ul>
			<ul>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2601239');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item25_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2720976');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item26_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2774290');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item27_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2720817');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item28_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2556569');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item29_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2689530');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item30_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2545429');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item31_v2.png" alt=""></span></a></li>
				<li><a href="" onclick="<%=chkiif(isapp = "1" , "fnAPPpopupProduct","TnGotoProduct")%>('2701024');return false;"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/img_item32_v2.png" alt=""></span></a></li>
			</ul>
		</div>
        <% end if %>
	</div>

	<%'<!-- for dev msg 쿠폰 발급 받았을 경우 숨겨주세요 -->%>
	<% If not(iscouponeDown) Then %>
		<div class="coupon-section">
			<button onclick="jsDownCouponSale2020('prd,prd,prd,prd,prd,prd,prd','<%=eventCoupons%>');return false;">
			<% if currentDate <= "2020-04-12" then %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_coupon_v2.png?v=1.01" alt="잠깐, 쿠폰과 함께 즐거운 쇼핑하세요!">
			<% elseif currentDate >= "2020-04-13" then %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_coupon_v3.png" alt="잠깐, 쿠폰과 함께 즐거운 쇼핑하세요!">
			<% end if %>
			</button>
		</div>
	<% End If %>
	<div class="lyr-pop" style="display:none;">
		<div class="inner">
			<a href="/my10x10/couponbook.asp" class="mWeb">
			<% if currentDate <= "2020-04-12" then %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_lyr_coupon_v2.png" alt="쿠폰함 바로가기">
			<% elseif currentDate >= "2020-04-13" then %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_lyr_coupon_v3.png" alt="쿠폰함 바로가기">
			<% end if %>
			</a>
			<a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','https://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;" target="_blank" class="mApp">
			<% if currentDate <= "2020-04-12" then %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_lyr_coupon_v2.png" alt="쿠폰함 바로가기">
			<% elseif currentDate >= "2020-04-13" then %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/sale2020/index/m/img_lyr_coupon_v3.png" alt="쿠폰함 바로가기">
			<% end if %>
			</a>
			<button class="btn-close" onclick="couponPopupCloseSale2020();return false;">닫기</button>
		</div>
	</div>

	<%'!-- 탭 --%>
	<div class="tab-wrap">
		<ul class="tab">
			<li class="on">혜택</li>
			<li>BEST</li>
			<li>기획전</li>
			<li>방금판매된</li>
		</ul>
		<%'!-- BEST 서브 탭 --%>
		<ul class="tab-sub best-sub" style="display:none;">
			<li>기간별</li>
			<li>신상품</li>
			<li>스테디셀러</li>
			<li>급상승위시</li>
			<li>후기</li>
			<li>명품</li>
		</ul>
		<%'!-- 기획전 서브 탭 --%>
		<ul class="tab-sub event-sub" style="display:none;">
			<li>기획전</li>
			<li>MD Pick</li>
		</ul>
	</div>

	<div id="itemLists"></div>
</div>
<form name="frmSale2020" id="frmSale2020">
	<input type="hidden" name="disp" value="<%=vDisp%>" />
	<input type="hidden" name="atype" value="<%=aType%>" />
	<input type="hidden" name="dategubun" value="<%=dateGubun%>" />
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->