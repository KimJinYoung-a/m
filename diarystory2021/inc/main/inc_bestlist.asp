<script>
function getDiaryItems(subshopgroupcode){
    var srm         = "be";
    var deliType    = "";
    var giftdiv     = "";
    var pageSize    = 30;
    var SubShopCd   = subshopgroupcode == '100102' ? '' : 100;
    var page = 1;
    var subShopGroupCode = subshopgroupcode == '100102' ? '' : subshopgroupcode;
    var cateCode = subshopgroupcode == '100102' ? "101102101109,101102101106,101102101105" : '';
    var items = [];

    $.ajax({
		type: "POST",
		url: "/diarystory2021/api/diaryItems.asp",
		data: {
            srm: srm,
            cpg: page,
            pageSize: pageSize,
            SubShopCd: SubShopCd,
            deliType: deliType,
            giftdiv: giftdiv,
            subShopGroupCode : subShopGroupCode,
            cateCode : cateCode,
        },
		dataType: "json",
        success: function(Data){
            items = Data.items;
            //console.log(items);
            renderItems(items,subshopgroupcode);
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.');
        }
    })
}

function linkToSearchType(subShopGroupCode,listtype){		
	var link = "/diarystory2021/search.asp?subshopgroupcode=" + subShopGroupCode + "&listtype=" + listtype;
	<% if isapp = 1 then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐문구점', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + link);
    <% else %>
	window.document.location.href = link
	<% end if %>
}

function renderItems(items,subShopGroupCode){
    var listHtmlStr = '',
        listTitleNameStr = '',
        salecouponString = '',
        bestBadge = '',
        newBadge = '',
        giftBadge = '',
        freeDelBadge = '',
        sellYN = ''

    switch (subShopGroupCode) {
        case '100101':
            listTitleNameStr = "다이어리";
            break;
        case '100102':
            listTitleNameStr = "6공";
            break;
        case '100103':
            listTitleNameStr = "플래너";
            break;
        case '100104':
            listTitleNameStr = "스티커";
            break;
        case '100105':
            listTitleNameStr = "떡메모지";
            break;
        case '100106':
            listTitleNameStr = "펜/색연필";
            break;
        default:
            break;
    }

    listHtmlStr += "<h3><a href='javascript:linkToSearchType("+ subShopGroupCode +", \"best\");'>"+ listTitleNameStr +"<i class='i_arw_r2'></i></a></h3>"
    listHtmlStr += "<div class='prd_slider_type2'><div class='swiper-container'><div class='swiper-wrapper'>"
    items.forEach(function(item , index){
        <% if giftCheck then %>
        giftBadge = item.giftDiv == 'R' ? '<i class="badge_gift">선물</i>' : ''
        <% end if %>
        freeDelBadge = item.isFreeDelivery == "Y" ? '<i class="badge_delivery">무료배송</i>' : ''
        if (item.saleStr != "" && item.couponStr != "" ) {
            salecouponString = "더블할인"
        } else if (item.saleStr != "") { 
            salecouponString = item.saleStr;
        } else if (item.couponStr != "") {
            salecouponString = item.couponStr;
        } else {
            salecouponString = "";
        }
        

        listHtmlStr += '<article class="swiper-slide prd_item">\
                            <figure class="prd_img">\
                                <img src="'+ item.itemImg +'" alt="'+ item.itemName +'">\
                                <span class="mask"></span>\
                            </figure>\
                            <div class="prd_info">\
                                <div class="prd_price">\
                                    <span class="set_price"><dfn>판매가</dfn>'+ item.price +'</span>\
                                    <span class="discount"><dfn>할인율</dfn>'+ salecouponString +'</span>\
                                </div>\
                                <div class="prd_name ellipsis2">'+ item.itemName +'</div>\
                                <div class="prd_badge">\
                                    ' + giftBadge + freeDelBadge + '\
                                </div>\
                                <i class="badge_rank">'+ parseInt(index+1) +'</i>\
                            </div>\
                            <% if isapp = 1 then %>\
                            <a href="javascript:fnAPPpopupProduct('+ item.itemid +')" class="prd_link"><span class="blind">상품 바로가기</span></a>\
                            <% else %>\
                            <a href="/category/category_itemPrd.asp?itemid='+ item.itemid +'" class="prd_link"><span class="blind">상품 바로가기</span></a>\
                            <% end if %>\
                        </article>'
    })
    listHtmlStr += "</div></div></div>"

    return $("#cate"+subShopGroupCode).html(listHtmlStr);
}

$(function() {
    getDiaryItems('100101'); // 다이어리
    getDiaryItems('100102'); // 6공
    getDiaryItems('100103'); // 캘린더
    getDiaryItems('100104'); // 스티커
    getDiaryItems('100105'); // 떡메모지
    getDiaryItems('100106'); // 펜/색연필

    // 베스트 상품
    setTimeout(function() {
        var prdSwiper2 = new Swiper('.prd_slider_type2 .swiper-container', {
            slidesPerView: 'auto',
            // loop: true,
            // autoplay: true,
            speed: 500,
            freeMode:true,
			freeModeMomentumRatio:0.5
        });
    },2000)
})

</script>
<section class="sect_best">
    <h2>잘 나가는<br/>베스트 아이템</h2>
    <div id="cate100101"></div>
    <div id="cate100102"></div>
    <div id="cate100103"></div>
    <div id="cate100104"></div>
    <div id="cate100105"></div>
    <div id="cate100106"></div>
</section>