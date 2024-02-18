var itemSwiper;
var isloading=false;

$(function(){
	/* floating button control */
	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;
	var floatingbuttonHeight = $(".btn-floating").outerHeight();
	
	$(window).scroll(function () {
		didScroll = true;

		setInterval(function() {
			if (didScroll) {
				hasScrolled();
				didScroll = false;
			}
		}, 250);

		function hasScrolled() {
			var st = $(this).scrollTop();

			if(Math.abs(lastScrollTop - st) <= delta)
				return;

			if (st > lastScrollTop && st > floatingbuttonHeight){
				$(".btn-floating").removeClass('nav-down').addClass('nav-up');
			} else {
				if(st + $(window).height() < $(document).height()) {
					$(".btn-floating").removeClass('nav-up').addClass('nav-down');
				}
			}
			lastScrollTop = st;
		}
		
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-375){
			if (isloading==false){
				isloading=true;
				
				$("#lyLoading").show();
				
				var pg = $("#listSFrm input[name='cpg']").val();
				
				pg++;
				$("#listSFrm input[name='cpg']").val(pg);
				jsSearchListAjax();
				
				if(!$("#lyCompare").is(":hidden")){
					$(".items .btn-compare-add").show();
				}
				
				$("#lyLoading").hide();
				
				<% If vListOption = "all" or vListOption = "item" Then	'### 리스트 내 비교버튼 셋팅 %>
				jsCompareBtnSetting();
				<% End If %>
			}
		}
	});

	/* relate keyword */
	var relatedKeywordSwiper = new Swiper("#relatedKeyword .swiper-container", {
		slidesPerView:"auto"
	});

	/* keyword curator */
	var keywordCuratorSwiper = new Swiper("#keywordCurator .swiper-container", {
		slidesPerView:"auto"
	});

	/* filiter list */
	var filterSwiper = new Swiper("#filterList .swiper-container", {
		slidesPerView:"auto"
	});

	$("#filterList .btn-del").on("click", function(e){
		$(this).parent().remove();
	});

/*
	$("select.select").each(function(){
		var title = $(this).attr("title");
		if( $('option:selected', this).val() != "" ) title = $("option:selected",this).text();
		$(this)
		.css({"z-index":10, "opacity":0, "-khtml-appearance":"none"})
		.after('<span class="select">' + title + '</span>')
		.change(function(){
			val = $("option:selected",this).text();
			$(this).next().text(val);
		})
	});
*/
	/* view option */
	$(".viewoption .value button").on("click", function(){
		$(".viewoption .value button").removeClass("on");
		if ($(this).hasClass("on")){
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
	
	/* category */

	/* price */
	$(".price .textfield .itext input").on("keyup", function(){
		$(this).next().show();
	});
	$(".price .textfield .itext .btn-reset").on("click", function(){
		$(this).parent().find("input").val('');
	});
	
	<% If IsUserLoginOK() Then	'### 로그인 한 경우 비교한거 있으면 on, 없으면 db 읽어서 있으면 on %>
		if(jsCompareItem("get","") != ""){
			$(".btn-compare").addClass("on");
		}else{
			if(jsCompareItemSetting("count","") > 0){
				$(".btn-compare").addClass("on");
			}
		}
	<% Else %>
		if(jsCompareItem("get","") != ""){
			$(".btn-compare").addClass("on");
		}
	<% End If %>

	<%' amplitude 이벤트 로깅 %>
		<% If Trim(SearchText)<>"" Then %>
			//setTimeout("tagScriptSend('SearchText', '<%=SearchText%>', '', 'amplitudeProperties')", 100);
		<% End If %>
	<%'// amplitude 이벤트 로깅 %>
});

/* layer popup */
function showLayer(v) {
	var $layer = $("#"+v+"");
	
	$layer.show();
	$layer.find(".btn-close").one("click",function () {
		jsResearchTxtProc();
		jsPriceSearchProc();
		$("#cpg").val("1");
		$("#listSFrm").submit();
		$layer.hide();
		$("#mask").hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});
	
	$layer.find(".btn-close-down").one("click",function () {
		$layer.hide();
		$("#mask").hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});

	$("#mask").on("click",function () {
		$layer.hide();
		$(this).hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});

	if(v == "lyCompare"){
		jsCompareLoad();	// 초기 셋팅
		setTimeout(function(){
			$(".popover").fadeOut();
		},1500);
		/* 비교 버튼 활성화 */
		$(".items .btn-compare-add").show();

	} else if(v == "searchFilter"){
		$("#mask").show().css({"z-index":"25"});
		$("body").css({"overflow":"hidden"});

	} else if(v == "quickview"){
		$("#mask").show().css({"z-index":"25"});
	}
}

function jsQuickViewItem(i){
	$.ajax({
		url: "/search/search_item_quickview.asp?itemid="+i+"&rect=<%=DocSearchText%>",
		cache: false,
		async: false,
		success: function(message) {
			$("#quickview").empty().html(message);
			$("#quickview").show();
			jsSwiperReset();
			$("#mask").show().css({"z-index":"25"});
		}
	});
}

function jsSwiperReset(){
	if ($("#itemSwiper .swiper-slide").length > 1) {
		itemSwiper = new Swiper("#itemSwiper.swiper-container", {
			loop:true,
			pagination:"#itemSwiper .pagination-dot"
		});
	}
}

function jsSearchLayerClose(v){
	$("#"+v+"").hide();
	$("#mask").hide().css({"z-index":"10"});
}

function jsSearchLayerCloseCom(v){
	$("#mask").hide().css({"z-index":"10"});
}

function jsSearchListAjax(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	
	var str = $.ajax({
			type: "GET",
			<% If vListOption = "all" or vListOption = "item" Then %>
	        url: "/search/act_search_item.asp",
	       <% ElseIf vListOption = "event" Then %>
	        url: "/search/act_search_event.asp",
	       <% ElseIf vListOption = "playing" Then %>
	        url: "/search/act_search_playing.asp",
	   		<% End If %>
	        data: formData,
	        dataType: "text",
	        async: false
	}).responseText;
	<%'// 실제 컨텐츠 유무 확인을 위한 체크 추가 %>
	if(str!="" && str.indexOf("</li>") > 0) {
		
    	if($("#listSFrm input[name='cpg']").val()=="1") {
			isloading=false;
        } else {
       		$str = $(str)
       		$('#lyrSrcpdtList').append($str);
        }
        isloading=false;
    } else {
		console.log("contents End...");
    	//$(window).unbind("scroll");
    }
}

function goWishPop(i){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	var wishpop = window.open('/common/popWishFolder.asp?gb=search2017&itemid='+i+'','wishpop','')
	
	//document.sFrm.itemid.value = i;
	//document.sFrm.action = "/common/popWishFolder.asp";
	//sFrm.submit();
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

function jsAfterWishBtn(i){
	if($("#wish"+i+"").hasClass("on")){
		
	}else{
		$("#wish"+i+"").addClass("on");
		
		var cnt = $("#cnt"+i+"").text();

		if(cnt == ""){
			$("#wish"+i+"").empty();
			$("#cnt"+i+"").empty().text("1");
		}else{
			cnt = parseInt(cnt) + 1;
			if(cnt > 999){
				$("#cnt"+i+"").empty().text("999+");
			}else{
				$("#cnt"+i+"").empty().text(cnt);
			}
		}
	}
}

function jsGoSort(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.srm.value = a;
	document.sFrm.action = "/search/search_item.asp";
	sFrm.submit();
}

function jsGoListOption(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.listoption.value = a;
	document.sFrm.action = "/search/search_item.asp";
	sFrm.submit();
}



//####### 필터 관련 스크립트 #######

//필터 선택하면 값 넣고 css on 하고 text 표시.
function jsSelectFilterSomething(gubun,thing,title,realvalue){
	var m = $("#"+realvalue+"").val();
	var t = "";

	if($("#"+thing+"").hasClass("on")){	//이미선택된것
		$("#"+thing+"").removeClass("on");
		t = m.replace(","+title+",", ",");
		
		if(t == ","){
			t = "";
		}
		
		$("#"+realvalue+"").val(t);
	}else{
		$("#"+thing+"").addClass("on");
		if(m == ""){
			$("#"+realvalue+"").val(","+title+",");
		}else{
			$("#"+realvalue+"").val(m+title+",");
		}
	}
	
	var l = $("#filter"+gubun+"list li").length;
	var a = $("#filter"+gubun+"list li a");
	var tit = "";
	var tit2 = "";
	var titcnt = 0;
	for(var i=0; i<l; i++){
		if(a.eq(i).hasClass("on")){
			if(tit == ""){
				tit = $("#filter"+gubun+"list li a").eq(i).text();
			}
			titcnt = titcnt + 1;
		}
	}
	
	if(titcnt > 1){
		tit2 = " 외 " + (titcnt-1) + "건";
	}
	
	tit = tit.replace(" BEST","")
	
	$("#filter"+gubun+"title").text(tit+tit2);
	
	jsResultTotalCount();
}

//보기옵션. 리스트형 격자형
function jsViewoption(m){
	$("#mode").val(m);
}

//결과내검색
function jsResearchTxtProc(){
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi
	if(regExp.test($("#sMtxt").val())){
		alert("특수문자는 입력할 수 없습니다.");
		$("#sMtxt").val("");
		return false;
	}
	$("#rstxt").val($("#sMtxt").val());
	$("#chkr").val("true");
}

function jsResearchTxt(){
	jsResearchTxtProc();
	
	$("#cpg").val("1");
	$("#listSFrm").submit();
}

//빠른메뉴 구분에 따라 값 저장
function jsFastSearch(g){
	if(g == "pum"){ //품절상품 포함
		if($("#sscp").val() == "N"){
			$("#sscp").val("");
		}else{
			$("#sscp").val("N");
		}
	}else if(g == "tendeli"){ //텐바이텐 배송
		if($("#deliType").val() == "TN"){
			$("#deliType").val("");
		}else{
			$("#deliType").val("TN");
		}
	}else if(g == "sale"){ //세일중인 상품
		if($("#sflag").val() == "sc"){
			$("#sflag").val("");
		}else{
			$("#sflag").val("sc");
		}
	}else if(g == "pojang"){ //선물포장 가능
		if($("#pojangok").val() == "o"){
			$("#pojangok").val("");
		}else{
			$("#pojangok").val("o");
		}
	}
}

//빠른메뉴 버튼 온오프. 값 저장하고 css on off
function jsFastOnOff(v){
	jsFastSearch(v);
	if($("#fast"+v+"").hasClass("on")){
		$("#fast"+v+"").removeClass("on");
	}else{
		$("#fast"+v+"").addClass("on");
	}
	
	jsResultTotalCount();
}

//배송필터액션
function jsDeliverySearch(v,title){
	if($("#deliType").val() == v){
		$("#deliType").val("");
		jsDeliOff();
		$("#deliverytitle").text("");
	}else{
		if(v == "TN"){
			if($("#fasttendeli").hasClass("on")){
				$("#deliType").val("");
				jsDeliOff();
			}else{
				$("#deliType").val("TN");
				jsDeliOff();
				$("#deli_TN").addClass("on");
				$("#fasttendeli").addClass("on");
			}
		}else{
			jsDeliOff();
			$("#deliType").val(v);
			$("#deli_"+v+"").addClass("on");
		}
		
		$("#deliverytitle").text(title);
	}
	
	jsResultTotalCount();
}

//배송필터 버튼 클릭시 css on off
function jsDeliOff(){
	$("#deli_FD").removeClass("on");
	$("#deli_TN").removeClass("on");
	$("#deli_FT").removeClass("on");
	$("#deli_WD").removeClass("on");
	//해외직구배송작업추가
	$("#deli_QT").removeClass("on");
	$("#deli_DT").removeClass("on");

	$("#fasttendeli").removeClass("on");
}

//가격검색
function jsPriceSearchProc(){
	if($("#minprice").val() == "" || isNaN($("#minprice").val().replace(/,/gi, ""))){
		alert("가격대 범위 최저가를 숫자만로 입력해주세요.");
		$("#minprice").focus();
		return;
	}
	if($("#maxprice").val() == "" || isNaN($("#maxprice").val().replace(/,/gi, ""))){
		alert("가격대 범위 최고가를 숫자만로 입력해주세요.");
		$("#maxprice").focus();
		return;
	}
	$("#minPrc").val($("#minprice").val());
	$("#maxPrc").val($("#maxprice").val());
}

function jsPriceSearch(){
	jsPriceSearchProc();
	
	$("#cpg").val("1");
	$("#listSFrm").submit();
}

function jsPriceComma(g,p){
	var v = $("#"+p+"price").val();

	if(!IsDigit(v.replace(/,/gi, "")) || v == ""){
		alert("금액은 숫자로만 입력하셔야 합니다.");
		$("#"+p+"price").val($("#"+p+"pricehidden").val());
		return;
	}

	if(g == "up"){
		v = v.replace(/,/gi, "");
		$("#"+p+"price").val(v);
	}else if(g == "down"){
		v = getMoneyFormat(v);
		$("#"+p+"price").val(v);
	}
}

function getMoneyFormat(m){
	var a,b;

	if(m.toString().indexOf('.') != -1) {
		var nums = m.toString().split('.');
		a = nums[0];
		b = '.' + nums[1];
	} else {
		a = m;
		b = "";
	}

	return a.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + b;
}

//카테고리 리스트 가져옴.
function jsGetDispCate(cd){
	var dispid = "";
	
	if(cd == ""){
		dispid = "navCategory";
	}else{
		var ddep = cd.length/3;
		dispid = "disp"+cd+"";
		
		if(ddep == 1){
			$(".depth1 > li > ul").hide();
		} else if(ddep == 2){
			$(".depth2 > li > ul").hide();
		}
		
		if($("#"+dispid+"").is(":hidden")){
			$("#"+dispid+"").show();
		}else{
			$("#"+dispid+"").hide();
		}

	}
	
	$.ajax({
		url: "/search/act_searchDispcate2017.asp?rect=<%=DocSearchText%>&clickdisp="+cd+"",
		cache: false,
		async: false,
		success: function(message) {
			$("#"+dispid+"").empty().html(message);
		}
	});
}

//카테고리검색
function jsDispSearch(d,t){
	jsGetDispCate(d);
	
	jsjsDispClassInsert(d);
	
	<% If dispcate <> "" AND Len(dispcate) = 3 Then %>
		if(d == "<%=dispcate%>"){
			$("#dispCate").val("");
		}
	<% End If %>
	
	if($("#dispCate").val() == d){
		$("#dispCate").val("");
		$("#disptitle").text("");
		jsDispListClassAllDel();
		$("#disp"+d+"").hide();
	}else{
		$("#dispCate").val(d);
		$("#disptitle").text(t);
	}

	jsResultTotalCount();
}

//선택한 카테고리 클래스주입
function jsjsDispClassInsert(d){
	jsDispListClassAllDel();
	
	$(".category"+d+" > a").addClass("on");
	if(d.length == 6){
		$(".category"+d.substring(0,3)+" > a").addClass("on");
	} else if(d.length == 9){
		$(".category"+d.substring(0,3)+" > a").addClass("on");
		$(".category"+d.substring(0,6)+" > a").addClass("on");
	}
	
	$(".category"+d+" > a").addClass("selected");
}

//선택된 클래스 삭제
function jsDispListClassAllDel(){
	$(".depth1 > li > a").removeClass("on");
	$(".depth1 > li > a").removeClass("selected");
	$(".depth1 > li > ul > li > a").removeClass("on");
	$(".depth1 > li > ul > li > a").removeClass("selected");
	$(".depth1 > li > ul > li > ul > li > a").removeClass("on");
	$(".depth1 > li > ul > li > ul > li > a").removeClass("selected");
}

//필터 액션에 따라 즉시 결과카운트 표시
function jsResultTotalCount(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	
	var rstr = $.ajax({
			type: "GET",
	        url: "/search/act_search_item_totalcount.asp",
	        data: formData,
	        dataType: "text",
	        async: false
	}).responseText;

	if(rstr!="") {
		$("#resulttotalcount").text(rstr);
    }
}

//필터 펼치기
function jsFilterShow(f){
	if(f == "Category"){
		jsGetDispCate("");
	}

	if($("#filter"+f+" .panelcont").is(":hidden")){
		$("#filter"+f+" .panelcont").show();
	}else{
		$("#filter"+f+" .panelcont").hide();
	}
	
	if(f != "Category"){
		$("#filterCategory .panelcont").hide();
	}
	if(f != "Brand"){
		$("#filterBrand .panelcont").hide();
	}
	if(f != "Style"){
		$("#filterStyle .panelcont").hide();
	}
	if(f != "Color"){
		$("#filterColor .panelcont").hide();
	}
	if(f != "Shipping"){
		$("#filterShipping .panelcont").hide();
	}

	return false;
}

//필터 검색한 값들 클릭시 초기값변경
function jsSelectedFilter(g){
	if(g == "pum"){
		$("#sscp").val("");
	}else if(g == "TN" || g == "FD" || g == "FT" || g == "WD" || g == "QT" || g == "DT" ){
		$("#deliType").val("");
	}else if(g == "sale"){
		$("#sflag").val("");
	}else if(g == "pojang"){
		$("#pojangok").val("");
	}else if(g == "disp"){
		$("#dispCate").val("");
	}else if(g == "brand"){
		$("#mkr").val("");
	}else if(g == "style"){
		$("#styleCd").val("");
	}else if(g == "color"){
		$("#iccd").val("");
	}else if(g == "price"){
		$("#minPrc").val("");
		$("#maxPrc").val("");
	}else if(g == "researchtxt"){
		$("#rstxt").val("");
	}
	
	
	$("#listSFrm").submit();
}

//####### 필터 관련 스크립트 #######

//####### 비교 관련 스크립트 #######

function jsCompareGetItem(){	//가져오기
	var getitem = "";
	getitem = localStorage.getItem('10x10searchcompareitem');
	if(getitem == null){
		getitem = ""
	}
	return getitem;
}

function jsCompareSetItem(ni){	//상품저장
	if(ni == ""){
		jsCompareRemove();
	}else{
		<% '### 상품코드는 i상품코드i,i상품코드i 형태로 저장됨. %>
		localStorage.setItem('10x10searchcompareitem', ni);
	}
}

function jsCompareRemove(){	//날림
	localStorage.removeItem('10x10searchcompareitem');
}

function jsCompareCall(g,i){	//콜
	var result = "";
	$.ajax({
		url: "/search/act_Compare_item.asp?gubun="+g+"&itemid="+i,
		cache: false,
		async: false,
		success: function(message) {
			result = message;
		}
	});
	return result;
}

//비교하기 클릭.
function jsCompareItem(g,i){
	var bd = $("#comparelist").html();
	var item = jsCompareGetItem();
	var newitem = "";
	
	var itemcount;
	if(item == ""){
		itemcount = 0;
	}else{
		itemcount = item.split(",").length;
	}

	if(g == "set"){	//상품클릭시
		if($("#comparelist").children().is("#compareitem"+i+"")){	//클릭한 상품이 이미 담겨있는 경우.
			newitem = jsCompareNewItem(item,itemcount,i);
			
			if(newitem != ""){	//담긴거 지우고 남은것.
				jsCompareSetItem(newitem);
				jsCompareItemSetting("reset",newitem);
			}else{	//담긴거 지우고 비어있을때
				jsCompareItemSetting("del","");
				$(".btn-compare").removeClass("on");
			}
			jsCompareItemReset("off",i);
			jsOnlyQuickViewAlert("d");
		}else{	//담긴게 없는경우
			if(itemcount == 0){	//처음 넣을때
				jsCompareSetItem('i'+i+'i');
				jsCompareItemSetting("reset",'i'+i+'i');
				$(".btn-compare").addClass("on");
			}else if(itemcount > 2){
				alert("3개 상품까지만 비교가능합니다.");
				return;
			}else{
				newitem = jsCompareNewItem(item,itemcount,i);
				jsCompareSetItem(newitem);
				jsCompareItemSetting("reset",newitem);
			}
			jsCompareItemReset("on",i);
			jsOnlyQuickViewAlert("i");
		}
	}else if(g == "get"){
		return item;
	}
}

//비교 상품이 들어와서 기존꺼와 새롭게 셋팅.
function jsCompareNewItem(itm,ic,i){
	var newitem = "";
	var olditem = itm;
	var tmpitem = "";
	
	if(ic == 0){	//비교상품 하나도 없을때.
		newitem = "i" + i + "i";
	}else{
		if(olditem.indexOf("i"+i+"i") < 0){	//비교상품에 클릭한상품 없을때.
			newitem = olditem + ",i" + i + "i";
		}else{		//비교상품에 클릭한상품 있을때. 기존꺼 replace 후 목록 다시 셋팅.
			olditem = olditem.replace("i"+i+"i","");
			
			for(var a=0; a<olditem.split(",").length; a++){
				if(olditem.split(",")[a] != ""){
					if(tmpitem != ""){
						tmpitem = tmpitem + ",";
					}
					tmpitem = tmpitem + olditem.split(",")[a];
				}
			}
			
			if(tmpitem == ""){	//없으면 아에 날림.
				jsCompareRemove();
				$(".btn-compare").removeClass("on");
				newitem = "";
			}else{
				newitem = tmpitem;
			}
		}
	}
	
	return newitem;
}

//비교 보내고 값 받아 처리.
function jsCompareItemSetting(g,iitem){
	var callbody = "";
	
	callbody = jsCompareCall(g,iitem);
	
	if(g == "count"){
		return callbody;
	}else if(g == "load"){
		return callbody;
	}else if(g == "userload"){
		return callbody;
	}
}

function jsCompareLoad(){	//비교버튼 오픈시.
	var litem = jsCompareGetItem();
	var loadbody = "";
	if(litem == ""){	//저장된 상품 없을때		
		<% if IsUserLoginOK then 'DB서 받아옴.	%>
			loadbody = jsCompareItemSetting("userload","");
			if(loadbody != ""){
				jsCompareSetItem(loadbody.split("$$")[0]);
				$("#comparelist").html(loadbody.split("$$")[1]);
				jsCompareBtnSetting();
			}
		<% end if %>
	}else{		
		loadbody = jsCompareItemSetting("load",litem);

		jsCompareSetItem(loadbody.split("$$")[0]);
		$("#comparelist").html(loadbody.split("$$")[1]);
		jsCompareBtnSetting();
	}
}

//localStorage.removeItem('10x10searchcompareitem');
//alert(localStorage.getItem('10x10searchcompareitem'));

//상품비교 리스트박스에 넣고빼기.
function jsCompareItemReset(g,i){
	if(g == "on"){
		var img = jsCompareGetImg(i);				
		bd = '<li id="compareitem'+i+'"><div class="thumbnail"><img src="'+img+'" alt="" /></div><button type="button" class="btn-del" onclick="jsCompareItem('+String.fromCharCode(39)+'set'+String.fromCharCode(39)+','+i+');">삭제</button></li>';
		$("#comparelist").append(bd);
		$("#comparebtn"+i+"").addClass("on");
	}else{
		$("#compareitem"+i+"").remove();
		$("#comparebtn"+i+"").removeClass("on");
	}
}

//상품이미지 가져오기.
function jsCompareGetImg(i){
	var img = "";
	$.ajax({
		url: "/search/act_Compare_image.asp?itemid="+i,
		cache: false,
		async: false,
		success: function(message) {
			var result = JSON.parse(message);			
			console.log(result.data.adultType)
			img = result.data.adultType == true ? "http://fiximage.10x10.co.kr/m/2019/common/img_adult_300.gif" : result.data.img;			
		}
	});
	return img;
}

//상품체크버튼 활성화.
function jsCompareBtnSetting(){
	var tmp = jsCompareGetItem();
	var tmpitem = "";
	
	if(tmp != ""){
		for(a=0; a<tmp.split(",").length; a++){
			tmpitem = (tmp.split(",")[a]).replace(/i/gi, "");
			
			if($("#lyrSrcpdtList").children().children().is("#comparebtn"+tmpitem+"")){
				$("#comparebtn"+tmpitem+"").addClass("on");
			}
		}
	}
}

//상품 비교 결과
function jsCompareItemResult(){
	var ritem = jsCompareGetItem();
	
	if(ritem.split(",").length < 2){
		alert("비교하기는 비교추가된 상품이 2개 이상일때 가능합니다.");
		return;
	}
	
	fnOpenModal("pop_compare_result.asp?itemid="+ritem+"&rect=<%=DocSearchText%>");
	jsCompareCall("statistic",ritem);
	return false;
}

//퀵뷰서 비교담기한뒤 alert
function jsOnlyQuickViewAlert(g){
	if($("#lyCompare").is(":hidden")){
		if(g == "d"){
			alert("비교담기상품에서 제거되었습니다.");
		}else{
			alert("비교담기상품에 추가되었습니다.");
		}
	}
}