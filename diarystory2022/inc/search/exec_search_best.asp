<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 다이어리 2021 검색 exec
'####################################################
dim giftCheck : giftCheck = False '사은품 표기 온오프
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<style>
/* 2022 다이어리스토리 */
.sortbar .sort_l {position:relative; height:2.05rem;}
.sortbar .sort_l::before {content:"\e901"; display:inline-block; position:absolute; top:50%; right:0; margin-top:-.8rem; font-family:'tencon' !important; font-size:1.37rem; line-height:1;}
.sortbar .sort_l select {position:relative; width:100%; padding:0 1.75rem 0 0; margin:0; background-color:transparent; font-family:var(--sb); font-size:1.71rem; line-height:2.05rem; border:0; direction:rtl; text-align:right; vertical-align:top; outline:none; -webkit-appearance:none; border-radius:0;}
</style>
<div id="content" class="content diary2021 dr_list_prd new-type">


	<section class="cat-top">
		<header class="sect_head">
            <h2 class="ttl" id="besttitle">잘 나가는<br/>베스트 아이템</h2>
		</header>
		<div class="cate_swiper swiper-container sub-swiper">
			<div class="swiper-wrapper">
                <div class="swiper-slide" id="c100100" onclick="setSubShopGroupCode2('');return false;"><a href=""><span>전체</span></a></div>
				<div class="swiper-slide cat-prd01" id="c100101" onclick="setSubShopGroupCode('100101');return false;"><a href=""><span>다이어리</span></a></div>
				<div class="swiper-slide cat-prd06" id="c100102" onclick="setSubShopGroupCode('100102');return false;"><a href=""><span>3공﹒6공</span></a></div>
				<div class="swiper-slide cat-prd07" id="c100107" onclick="setSubShopGroupCode('100107');return false;"><a href=""><span>스터디플래너</span></a></div>
                <div class="swiper-slide cat-prd08" id="c100108" onclick="setSubShopGroupCode('100108');return false;"><a href=""><span>가계부</span></a></div>
                <div class="swiper-slide cat-prd09" id="c100103" onclick="setSubShopGroupCode('100103');return false;"><a href=""><span>캘린더</span></a></div>
                <div class="swiper-slide cat-prd10" id="c100106" onclick="setSubShopGroupCode('100106');return false;"><a href=""><span>팬/색연필</span></a></div>
                <div class="swiper-slide cat-prd11" id="c100104" onclick="setSubShopGroupCode('100104');return false;"><a href=""><span>스티커</span></a></div>
                <div class="swiper-slide cat-prd12" id="c100105" onclick="setSubShopGroupCode('100105');return false;"><a href=""><span>떡메모지</span></a></div>
			</div>
		</div>
	</section>

	<!-- 필터영역 -->
    <section class="dr_filter_area">
		<ul class="etc-cat" id="dc_cate"></ul>
	</section>

	<!-- 정렬바 -->
    <div class="sortbar">
        <div class="sort_l">
            <label for="select">신규순</label>
            <select id="sortmet">
                <option value="ne">신규순</option>
                <option value="be">인기순</option>
                <option value="hs">높은할인율순</option>
                <option value="hp">높은가격순</option>
                <option value="lp">낮은가격순</option>
            </select>
        </div> 
        <div class="sort_r">
            <button class="btn_type2 btn_wht" onclick="fnCallModal()">꼼꼼하게 찾기</button>
            <p class="bbl_blk bbl_t filterclear" style="display:none;"><i class="i_refresh2"></i>초기화 할까요?</p>
        </div>          
    </div>

	<div class="sort_bar type-01">
		<div class="sort_l">
			<div class="sort_group">
				<div class="checkbox"><input type="checkbox" name="deliType" value="FD" id="deliType"><label for="deliType">무료배송</label></div>
                <% if giftCheck then %>
				<div class="checkbox"><input type="checkbox" name="giftdiv" value="R" id="giftdiv"><label for="giftdiv">사은품</label></div>
                <% end if %>
			</div>
		</div>
	</div>

    <div id="listContainer"></div>
    <!-- #include virtual="/diarystory2022/inc/search/inc_filter.asp" -->
</div>
<form id="diaryfrm" name="diaryfrm">
    <input type="hidden" name="cpg" value="1"/>
    <input type="hidden" name="subshopgroupcode" id="subshopgroupcode"/>
    <input type="hidden" name="listtype" id="listtype"/>
</form>
<script type="text/javascript">
$(function() {
    // 무료배송 _ 사은품 클릭
    $(".sort_bar .sort_group input").click(function(){
        getDiaryItems(1);
    })

    $('.cate_swiper .swiper-slide').click(function(){
		$(this).addClass('on').siblings().removeClass('on');
    })
    
    $('#sortmet').on('change',function() {
        getDiaryItems(1);
    })

    // 카테고리
	var ctySwiper = new Swiper('.cate_swiper', {
		slidesPerView:'auto',
	})

	// 하위 카테고리 더보기
	$('.btn_more_cate').click(function (e) {
		e.preventDefault();
		$('.etc-cat').addClass('on');
		$(this).hide();
    });

    var selectTarget = $('.sort_l select');

    selectTarget.change(function(){
        var select_name = $(this).children('option:selected').text();
        $(this).siblings('label').text(select_name);
    });

    getDiaryItems(1);
});

var dataObject = {
    subshopgroupcode : '',
    listtype : 'best',
    catecode : '',
    diarytype : 'di',
    listall : '',
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    return Array.isArray(results) ? results[2] : "" ;
}

function getOptionsFromMain(){
    var options = {
        att: getParameterByName('attr'),
        color: getParameterByName('col'),
        subshopgroupcode : getParameterByName('subshopgroupcode'),
        listtype : getParameterByName('listtype'),
        catecode : getParameterByName('catecode'),
        diarytype : getParameterByName('diarytype'),
        listall : getParameterByName('listall')
    }
    
    history.replaceState({}, null, location.pathname); //파라미터 제거

    if (options.subshopgroupcode != '' && options.subshopgroupcode != undefined) {
        dataObject.subshopgroupcode = options.subshopgroupcode;
    } else {
        options.subshopgroupcode = dataObject.subshopgroupcode
    }
    
    if (options.listtype != '' && options.listtype != undefined) {
        dataObject.listtype = options.listtype;
    } else {
        options.listtype = dataObject.listtype;
    }

    if (options.catecode != '' && options.catecode != undefined) {
        dataObject.catecode = options.catecode;
    } else {
        options.catecode = dataObject.catecode;
    }
    
    if (options.diarytype != '' && options.diarytype != undefined) {
        dataObject.diarytype = options.diarytype;
    } else {
        options.diarytype = dataObject.diarytype;
    }

    if (options.listall != '' && options.listall != undefined) {
        dataObject.listall = options.listall;
    } else {
        options.listall = dataObject.listall;
    }
 
    setCheckBox(options);
    return (options.att == '' && options.color == '') ? '' : options
}

function setCheckBox(optionsObj){
    if(optionsObj.att == '' && optionsObj.color == '' ) return false;

    var attArr = optionsObj.att.split(',')
    var colorArr = optionsObj.color.split(',')

    attArr.forEach(function(item){
        $(".diary-attr [value="+ item +"]").prop("checked", true).next().toggleClass("on")
    })
    colorArr.forEach(function(item){
        $(".colorchips [value="+ item +"]").prop("checked", true).next().toggleClass("on")
    })

    fnFilterTitleChance() // 서브 필터
    fnMainFilterStyleOn() // 메인 필터
}

function generateAttr(targetArr){
    var result = ""
	targetArr.forEach(function(item){
		result += item + ','
	});

    return $.trim(result)
}

function getSearchParam(){
	var attTempArr = []
    var colorTempArr = []
	$('.diary-attr input:checkbox:checked').each(function() {
        var attr = $(this).val();
        if(attr == "") return true
		attTempArr.push(attr)
	})

	$('.colorchips input:checkbox:checked').each(function() {
        var colorChip = $(this).val();
        if(colorChip == "") return true
		colorTempArr.push(colorChip)
    })

    // console.log(generateAttr(attTempArr));
    // console.log(generateAttr(colorTempArr));
    // console.log(dataObject.catecode);
    // console.log(dataObject.subshopgroupcode);

    return {
        att: generateAttr(attTempArr),
        color: generateAttr(colorTempArr),
        catecode : dataObject.catecode,
        subshopgroupcode : dataObject.subshopgroupcode
    }
}

function getInitFilter(subShopGroupCode) {
    switch (subShopGroupCode) {
        case "" :
            //console.log(subShopGroupCode);
            $("#c100100").addClass("on");
             break;
        case "100101" :
            $('#giftdiv').parent('div').show();
            dataObject.listtype == "best" ? function() {
                $('.sort_bar').hide();
                $('.sortbar').hide();
                $('.btn_type2 ,.bbl_blk').hide()
            }() : function() {
                $('.btn_type2').show()
            }()
            //$('.cate_swiper .swiper-slide').eq(0).addClass('on').siblings().removeClass('on');
            break;
        case "100102" :
            $('#giftdiv').parent('div').show();
            $('.btn_type2 ,.bbl_blk').hide();
            dataObject.listtype == "best" ? $('.sort_bar').hide() : ''
            dataObject.listtype == "best" ? $('.sortbar').hide() : ''
            //$('.cate_swiper .swiper-slide').eq(1).addClass('on').siblings().removeClass('on');
            $(".diary-attr input:checkbox").prop("checked", false);
            $(".colorchips input:checkbox").prop("checked", false);
            //$(".btn_wht").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
            break;
        case "100103" :
            $('#giftdiv').parent('div').hide();
            $('.btn_type2 ,.bbl_blk').hide();
            dataObject.listtype == "best" ? $('.sort_bar').hide() : ''
            dataObject.listtype == "best" ? $('.sortbar').hide() : ''
            //$('.cate_swiper .swiper-slide').eq(2).addClass('on').siblings().removeClass('on');
            $(".diary-attr input:checkbox").prop("checked", false);
            $(".colorchips input:checkbox").prop("checked", false);
            //$(".btn_wht").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
            break;
        case "100104" :
            $('#giftdiv').parent('div').hide();
            $('.btn_type2 ,.bbl_blk').hide();
            dataObject.listtype == "best" ? $('.sort_bar').hide() : ''
            dataObject.listtype == "best" ? $('.sortbar').hide() : ''
            //$('.cate_swiper .swiper-slide').eq(3).addClass('on').siblings().removeClass('on');
            $(".diary-attr input:checkbox").prop("checked", false);
            $(".colorchips input:checkbox").prop("checked", false);
            //$(".btn_wht").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
            break;
        case "100106" :
            $('#giftdiv').parent('div').hide();
            $('.btn_type2 ,.bbl_blk').hide();
            dataObject.listtype == "best" ? $('.sort_bar').hide() : ''
            dataObject.listtype == "best" ? $('.sortbar').hide() : ''
            //$('.cate_swiper .swiper-slide').eq(4).addClass('on').siblings().removeClass('on');
            $(".diary-attr input:checkbox").prop("checked", false);
            $(".colorchips input:checkbox").prop("checked", false);
            //$(".btn_wht").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
            break;
        case "100105" :
            $('giftdiv').parent('div').hide();
            $('.btn_type2 ,.bbl_blk').hide();
            dataObject.listtype == "best" ? $('.sort_bar').hide() : ''
            dataObject.listtype == "best" ? $('.sortbar').hide() : ''
            //$('.cate_swiper .swiper-slide').eq(5).addClass('on').siblings().removeClass('on');
            $(".diary-attr input:checkbox").prop("checked", false);
            $(".colorchips input:checkbox").prop("checked", false);
            //$(".btn_wht").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
            break;
        case "100107" :
            $('#giftdiv').parent('div').show();
            dataObject.listtype == "best" ? function() {
                $('.sort_bar').hide();
                $('.sortbar').hide();
                $('.btn_type2 ,.bbl_blk').hide()
            }() : function() {
                $('.btn_type2').show()
            }()
            break;
        case "100108" :
            $('#giftdiv').parent('div').show();
            dataObject.listtype == "best" ? function() {
                $('.sort_bar').hide();
                $('.sortbar').hide();
                $('.btn_type2 ,.bbl_blk').hide()
            }() : function() {
                $('.btn_type2').show()
            }()
            break;
        default :
            break;
    }
}

function fnFilterClear() {
    $(".diary-attr input:checkbox").prop("checked", false);
    $(".colorchips input:checkbox").prop("checked", false);
    getDiaryItems(1);
}

var categoryname = [
    {code:'',name:'전체'},
    {code:'100101',name:'다이어리'}, 
    {code:'100102',name:'3공/6공'}, 
    {code:'100107',name:'스터디플래너'}, 
    {code:'100108',name:'가계부'}, 
    {code:'100103',name:'캘린더'},
    {code:'100104',name:'스티커'},
    {code:'100106',name:'펜/색연필'},
    {code:'100105',name:'떡메모지'}
]

function getDiaryItems(vpage){
    var optinosFromMain = getOptionsFromMain();
    var searchParam = optinosFromMain == '' ? getSearchParam() : optinosFromMain;
    var srm         = $("#sortmet").val();
    var attribCd    = searchParam.att;
    var colorCd     = searchParam.color;
    var pageSize    = 50;
    var SubShopCd   = 100;
    var subShopGroupCode = searchParam.subshopgroupcode;
    var cateCode = searchParam.catecode;
    var catename='';

    categoryname.forEach(function(item){
        if(item.code==subShopGroupCode){
            catename=item.name;
        }
    });

    fnAmplitudeEventMultiPropertiesAction('view_diarystory_best','category_code|category_name|paging_index',subShopGroupCode + '|' + catename + '|' + vpage);

    if (dataObject.listtype == "best") {
        srm = "be"
        pageSize = 100
    }
    //console.log(searchParam.listall);
    fnMenuActiveCheck();
    getInitFilter(subShopGroupCode);

    var deliType    = $('input:checkbox[id="deliType"]').is(':checked') ? $("#deliType").val() : "";
    var giftdiv     = $('input:checkbox[id="giftdiv"]').is(':checked') ? $("#giftdiv").val() : "";
   
    var items = []
    var totalpages = ''

    $.ajax({
		type: "POST",
		url: "/diarystory2022/api/diaryItems.asp",
		data: {
            srm: srm,
            cpg: vpage,
            pageSize: pageSize,
            SubShopCd: subShopGroupCode == '100102' ? '' : SubShopCd,
            deliType: deliType,
            giftdiv: giftdiv,
            attribCd: attribCd,
            colorCd: colorCd,
            subShopGroupCode : subShopGroupCode == '100102' ? '' : subShopGroupCode,
            cateCode : cateCode == '' ? subShopGroupCode == '100102' ? "101102101109,101102101106,101102101105" : '' : cateCode,
        },
		dataType: "json",
        success: function(Data){
            items = Data.items
            totalpages = Data.totalpage
            renderItems(items,vpage,totalpages)
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            $("#listContainer").empty();
        }
	})
}

function renderItems(items,currentpage,totalpages){

    var listHtmlStr = ''
    var bestBadge = ''
    var newBadge = ''
    var giftBadge = ''
    var freeDelBadge = ''
    var rankBadge = ''
    var soldout = ''
    var salecouponString = ''
    var evalCountString = ''
    var evalPointString = ''
    var listType = dataObject.listtype;
    var subShopGroupFilter = ''
    var subShopGroupCode = dataObject.subshopgroupcode;
    var catecode = dataObject.catecode;

    listHtmlStr += '<section class="sect_prd"><div class="prd_list type_basic">'
    items.forEach(function(item,index){
        soldout = item.sellYN == 'N' ? 'soldout' : ''
        <% if giftCheck then %>
        giftBadge = item.giftDiv == 'R' ? '<i class="badge_gift">선물</i>' : ''
        <% end if %>
        freeDelBadge = item.isFreeDelivery == "Y" ? '<i class="badge_delivery">무료배송</i>' : ''
        rankBadge = listType == "best" ? '<i class="badge_rank">'+ parseInt(parseInt(index+1) + parseInt(50*(currentpage-1))) +'</i>' : ''

        evalPointString = item.evaltotalpoint > 79 ? '<span class="user_eval"><dfn>평점</dfn><i style="width:'+ item.evaltotalpoint +'%">'+ item.evaltotalpoint +'점</i></span>' : ''
        evalCountString = item.evalcount > 4 ? ' <span class="user_comment"><dfn>상품평</dfn>'+ item.evalcount +'</span>' : ''
        evalCountString = evalPointString != '' ? evalCountString : ''

        if (item.saleStr != "" && item.couponStr != "" ) {
            salecouponString = "더블할인"
        } else if (item.saleStr != "") { 
            salecouponString = item.saleStr;
        } else if (item.couponStr != "") {
            salecouponString = item.couponStr;
        } else {
            salecouponString = ""
        }

        listHtmlStr += '<article class="prd_item '+ soldout +'">\
                            <figure class="prd_img">\
                                <img src="'+ item.itemImg +'" alt="'+ item.itemName +'">\
                            </figure>\
                            <div class="prd_info">\
                                <div class="prd_price">\
                                    <span class="set_price"><dfn>판매가</dfn>'+ item.price +'</span>\
                                    <span class="discount"><dfn>할인율</dfn>'+ salecouponString +'</span>\
                                </div>\
                                <div class="prd_name">'+ item.itemName +'</div>\
                                <div class="prd_brand">'+ item.brandName +'</div>\
                                <div class="user_side">\
                                    ' + evalPointString + evalCountString + '\
                                </div>\
                                <div class="prd_badge">\
                                    ' + giftBadge + freeDelBadge + '\
                                </div>\
                                '+ rankBadge +'\
                            </div>\
                            <% if isapp = 1 then %>\
                            <a href="javascript:fnAPPpopupProduct('+ item.itemid +')" class="prd_link"><span class="blind">상품 바로가기</span></a>\
                            <% else %>\
                            <a href="/category/category_itemPrd.asp?itemid='+ item.itemid +'" class="prd_link"><span class="blind">상품 바로가기</span></a>\
                            <% end if %>\
                        </article>'
    })
    if (listType == "cate") {
        listHtmlStr += '</div>\
                        <div class="pagingV20">\
                            <button class="btn_paging btn_paging_prev">이전페이지</button>\
                            <span class="paging_num"><em class="paging_current">'+ currentpage +'</em>/<span class="paging_total">'+ totalpages +'</span></span>\
                            <button class="btn_paging btn_paging_next">다음페이지</button>\
                        </div>\
                    </section>'
    }

    switch (subShopGroupCode) {
        case '100101': // 다이어리
            subShopGroupFilter = '<li><input type="radio" name="dc_cate" value="" id="dc_cate1" onclick="setCateCode(this.value);"><label for="dc_cate1">전체</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101101" id="dc_cate2" onclick="setCateCode(this.value);"><label for="dc_cate2" >심플</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101102" id="dc_cate3" onclick="setCateCode(this.value);"><label for="dc_cate3">일러스트</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101104" id="dc_cate4" onclick="setCateCode(this.value);"><label for="dc_cate4">패턴</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101103" id="dc_cate5" onclick="setCateCode(this.value);"><label for="dc_cate5">포토</label></li>';
            break;
        case '100102': // 6공
            subShopGroupFilter = '<li><input type="radio" name="dc_cate" value="" id="dc_cate1" onclick="setCateCode(this.value);"><label for="dc_cate1">전체</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101109" id="dc_cate2" onclick="setCateCode(this.value);"><label for="dc_cate2" >3공 / 6공 다이어리</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101106" id="dc_cate3" onclick="setCateCode(this.value);"><label for="dc_cate3">다이어리 커버</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102101105" id="dc_cate4" onclick="setCateCode(this.value);"><label for="dc_cate4">리필속지</label></li>';
            break;
        case '100103': // 캘린더
            subShopGroupFilter = '<li><input type="radio" name="dc_cate" value="" id="dc_cate1" onclick="setCateCode(this.value);"><label for="dc_cate1">전체</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104101" id="dc_cate2" onclick="setCateCode(this.value);"><label for="dc_cate2" >탁상 달력</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104102" id="dc_cate3" onclick="setCateCode(this.value);"><label for="dc_cate3" >벽걸이달력</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104105" id="dc_cate4" onclick="setCateCode(this.value);"><label for="dc_cate4" >일력</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104106" id="dc_cate5" onclick="setCateCode(this.value);"><label for="dc_cate5" >포스터/엽서 달력</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104107" id="dc_cate6" onclick="setCateCode(this.value);"><label for="dc_cate6" >디데이 달력</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104108" id="dc_cate7" onclick="setCateCode(this.value);"><label for="dc_cate7" >프로젝트 달력</label></li>\
                                <li><input type="radio" name="dc_cate" value="101102104103" id="dc_cate8" onclick="setCateCode(this.value);"><label for="dc_cate8" >스티커 달력</label></li>';
            break;
        case '100104': // 스티커
            subShopGroupFilter = '<li><input type="radio" name="dc_cate" value="" id="dc_cate1"><label for="dc_cate1">전체</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102101" id="dc_cate2" onclick="setCateCode(this.value);"><label for="dc_cate2" >스티커 세트</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102102" id="dc_cate3" onclick="setCateCode(this.value);"><label for="dc_cate3" >빅 포인트 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102103" id="dc_cate4" onclick="setCateCode(this.value);"><label for="dc_cate4" >스몰 데코 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102104" id="dc_cate5" onclick="setCateCode(this.value);"><label for="dc_cate5" >손글씨 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102105" id="dc_cate6" onclick="setCateCode(this.value);"><label for="dc_cate6" >패턴/그래픽 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102106" id="dc_cate7" onclick="setCateCode(this.value);"><label for="dc_cate7" >포토 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102107" id="dc_cate8" onclick="setCateCode(this.value);"><label for="dc_cate8" >라벨/인덱스 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107102111" id="dc_cate9" onclick="setCateCode(this.value);"><label for="dc_cate9" >네임 스티커</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107103101" id="dc_cate10" onclick="setCateCode(this.value);"><label for="dc_cate10" >마스킹 테이프</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107103102" id="dc_cate11" onclick="setCateCode(this.value);"><label for="dc_cate11" >종이 테이프</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107103103" id="dc_cate12" onclick="setCateCode(this.value);"><label for="dc_cate12" >박스 테이프</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107103104" id="dc_cate13" onclick="setCateCode(this.value);"><label for="dc_cate13" >패브릭 테이프</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107103106" id="dc_cate14" onclick="setCateCode(this.value);"><label for="dc_cate14" >레이스 테이프</label></li>\
                                <li><input type="radio" name="dc_cate" value="101107103105" id="dc_cate15" onclick="setCateCode(this.value);"><label for="dc_cate15" >다이모 / 리필</label></li>';
            break;
        case '100106': // 펜/색연필
            subShopGroupFilter = '<li><input type="radio" name="dc_cate" value="" id="dc_cate1" onclick="setCateCode(this.value);"><label for="dc_cate1">전체</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101105" id="dc_cate2" onclick="setCateCode(this.value);"><label for="dc_cate2">필기구 세트</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101102" id="dc_cate3" onclick="setCateCode(this.value);"><label for="dc_cate3">볼펜</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101104" id="dc_cate4" onclick="setCateCode(this.value);"><label for="dc_cate4">색연필</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101107" id="dc_cate5" onclick="setCateCode(this.value);"><label for="dc_cate5">형광펜</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101109" id="dc_cate6" onclick="setCateCode(this.value);"><label for="dc_cate6">데코펜</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101108" id="dc_cate7" onclick="setCateCode(this.value);"><label for="dc_cate7">지워지는 펜</label></li>\
                                <li><input type="radio" name="dc_cate" value="101104101114" id="dc_cate8" onclick="setCateCode(this.value);"><label for="dc_cate8">네임펜/보드마카</label></li>';
            break;
        case '100105': // 떡메모지
            subShopGroupFilter = '<li><input type="radio" name="dc_cate" value="" id="dc_cate1" onclick="setCateCode(this.value);"><label for="dc_cate1">전체</label></li>\
                                <li><input type="radio" name="dc_cate" value="101103108101" id="dc_cate2" onclick="setCateCode(this.value);"><label for="dc_cate2">떡메모지</label></li>\
                                <li><input type="radio" name="dc_cate" value="101103108102" id="dc_cate3" onclick="setCateCode(this.value);"><label for="dc_cate3">점착메모지</label></li>';
            break;
        default:
            subShopGroupFilter="";
            break;
    }

    if(subShopGroupFilter!=""){
        $(".dr_filter_area").show();
    }else{
        $(".dr_filter_area").hide();
    }

    // title
    if (listType == "best") {
        $(".dr_filter_area").hide();
    } else {
        $("#dc_cate").empty().append(subShopGroupFilter);
    }
    const swiper2 = document.querySelector('.cate_swiper').swiper;
    swiper2.update();
    //console.log(subShopGroupFilter);

    $('.etc-cat input:radio').each(function(index){
        var subcatecode = $(this).val();
        catecode == subcatecode ? $(this).prop("checked", true) : '';
    });

    $("#listContainer").empty().append(listHtmlStr);
    if(items.length < 1){
        var noResultHtml ='<section class="nodata nodata_search">\
                            <p><b>아쉽게도 일치하는 내용이 없습니다</b></p>\
                            <p>품절 또는 종료된 경우에는 검색되지 않습니다</p>\
                          </section>'

        $("#listContainer").empty().append(noResultHtml);
        return false;
    }
    // paging
    $('.btn_paging').click(function() {
        var currentPageNumber = $('.paging_current').text()
        var totalPageNumber = $('.paging_total').text()
        var actPageNumber = 0
        if ($(this).hasClass('btn_paging_prev')) {
            // 이전
            actPageNumber = parseInt(currentPageNumber) == 1 ? parseInt(currentPageNumber) : parseInt(currentPageNumber) - 1
        } else if ($(this).hasClass('btn_paging_next')) {
            // 다음
            actPageNumber = parseInt(currentPageNumber) < parseInt(totalPageNumber) ? parseInt(currentPageNumber) + 1 : parseInt(totalPageNumber)
        }
        window.$('html,body').animate({scrollTop:0},300);

        getDiaryItems(actPageNumber);
    })
}

function setCateCode(code) {
    //console.log(dataObject.subshopgroupcode);
    dataObject.catecode = code;

    setTimeout(function() {
        getDiaryItems(1);    
    }, 300);
}

function setSubShopGroupCode(code) {
    dataObject.subshopgroupcode = code;
    dataObject.catecode = "";
    dataObject.listall = "";

    // 카테고리 선택시 sorting 체크 박스 해제
    $(".sort_group input:checkbox").prop("checked", false);
    $("#c"+code).addClass("on");
    //console.log(code);

    setTimeout(function() {
        getDiaryItems(1);    
    }, 300);
}

function setSubShopGroupCode2(type) {

    const swiper = document.querySelector('.cate_swiper').swiper;
    swiper.slideTo(-1);
    swiper.update();
    if(type==""){
        type = dataObject.diarytype;
    }
    $("#c"+dataObject.subshopgroupcode).removeClass("on");
    if(type=="di"){
        dataObject.listall = "all";
        dataObject.diarytype = "di";
        dataObject.subshopgroupcode = "";
        dataObject.catecode = "101102101101,101102101102,101102101104,101102101103,101102101109,101102101106,101102101105,101102103106,101102103107,101102104101,101102104102,101102104105,10110210410,101102104107,101102104108,101102104103";
        $('.btn_type2').show();
    }else{
        dataObject.listall = "all";
        dataObject.diarytype = "dk";
        dataObject.subshopgroupcode = "";
        dataObject.catecode = "101107102101,101107102102,101107102103,101107102104,101107102105,101107102106,101107102107,101107102111,101107103101,101107103102,101107103103,101107103104,10110710316,101107103105,101104101105,101104101102,101104101104,101104101107,101104101109,101104101108,101104101114,101103108101,101103108102";
        $('.btn_type2 ,.bbl_blk').hide();
    }

    // 카테고리 선택시 sorting 체크 박스 해제
    //$(".sort_group input:checkbox").prop("checked", false);
    //
    //console.log(dataObject.subshopgroupcode);

    setTimeout(function() {
        getDiaryItems(1);
    }, 300);
}

function fnMenuActiveCheck(){
    if(dataObject.subshopgroupcode=="" && dataObject.diarytype=="di"){
        dataObject.listall = "all";
        dataObject.catecode = "101102101101,101102101102,101102101104,101102101103,101102101109,101102101106,101102101105,101102103106,101102103107,101102104101,101102104102,101102104105,10110210410,101102104107,101102104108,101102104103";
        $("#di").addClass("active");
        $("#dk").removeClass("active");
    }else if(dataObject.subshopgroupcode=="" && dataObject.diarytype=="dk"){
        dataObject.listall = "all";
        dataObject.catecode = "101107102101,101107102102,101107102103,101107102104,101107102105,101107102106,101107102107,101107102111,101107103101,101107103102,101107103103,101107103104,10110710316,101107103105,101104101105,101104101102,101104101104,101104101107,101104101109,101104101108,101104101114,101103108101,101103108102";
        $("#dk").addClass("active");
        $("#di").removeClass("active");
    }else if(dataObject.subshopgroupcode=="100106" || dataObject.subshopgroupcode=="100104" || dataObject.subshopgroupcode=="100105"){
        $("#dk").addClass("active");
        $("#di").removeClass("active");
    }else{
        $("#di").addClass("active");
        $("#dk").removeClass("active");
    }
    if(dataObject.listall == "all"){
        $("#c100100").addClass("on");
    }else{
        $("#c"+dataObject.subshopgroupcode).addClass("on");
    }
    //console.log(dataObject.subshopgroupcode);
}
</script>
