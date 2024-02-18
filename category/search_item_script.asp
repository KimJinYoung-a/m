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
		
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-350){
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
			//	jsCompareBtnSetting();
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
		$("#navCategory li a").on("click", function(e){
			e.stopPropagation();
			var $this = $(this),
			$depthTarget = $this.next(),
			$siblings = $this.parent().siblings();

			$("#navCategory li a").removeClass("selected");
			$this.addClass("on");
			$this.addClass("selected");
			$siblings.children().removeClass("on");
			$siblings.find("ul").slideUp();

			if($depthTarget.hasClass("depth3") || $depthTarget.css("display") == "none") {
				$depthTarget.children().find("a").removeClass("on");
			}
			if($depthTarget.css("display") == "none") {
				$depthTarget.slideDown();
			} else {
				$depthTarget.slideUp();
			}
			return false;
		});

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
});

/* layer popup */
function showLayer(v) {
	var $layer = $("#"+v+"");
	
	$layer.show();
	$layer.find(".btn-close").one("click",function () {
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
		url: "/search/search_item_quickview.asp?itemid="+i,
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

function jsSearchListAjax(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	var str = $.ajax({
			type: "GET",
			<% If vListOption = "all" or vListOption = "item" Then %>
	        url: "/category/act_category_list.asp",
	       <% ElseIf vListOption = "event" Then %>
	        url: "/search/act_search_event.asp",
	       <% ElseIf vListOption = "playing" Then %>
	        url: "/search/act_search_playing.asp",
	   		<% End If %>
	        data: formData,
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
		
    	if($("#listSFrm input[name='cpg']").val()=="1") {
			isloading=false;
        } else {
       		$str = $(str)
       		$('#lyrSrcpdtList').append($str);
        }
        isloading=false;
    } else {
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
	document.sFrm.action = "/category/category_list.asp";
	sFrm.submit();
}

function jsGoListOption(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.listoption.value = a;
	document.sFrm.action = "/category/category_list.asp";
	sFrm.submit();
}


//####### 필터 관련 스크립트 #######
<%	'###	inc_search_item_filter.asp 안에 들어가있음 %>
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
			img = message;
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
	
	fnOpenModal("pop_compare_result.asp?itemid="+ritem+"");
	jsCompareCall("statistic",ritem);
	return false;
}