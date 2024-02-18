<script>
    function getDiaryItems(subshopgroupcode){
        api_url = "//fapi.10x10.co.kr/api/web/v1/diary/items";
        //api_url = "http://localhost:8080/api/web/v1/diary/items";

        $.ajax({
            type: "GET",
            url: api_url,
            data: {
                method : "list"
                , pageSize : 30
                , srm : "best"
                , subShopGroupCode : subshopgroupcode
            },
            dataType: "json",
            success: function(data){
                let items = data.items;
                //console.log(items);
                renderItems(items,subshopgroupcode);
            },
            error: function(e){
                console.log('데이터를 받아오는데 실패하였습니다.');
            }
        });
    }

function linkToSearchType(subShopGroupCode,listtype,diarytype,listall){
    var link="";
    if(listtype=="best"){	
	    link = "/diarystory2022/search_best.asp?subshopgroupcode=" + subShopGroupCode + "&listtype=" + listtype + "&diarytype="+diarytype + "&listall="+listall;
    }else{
        link = "/diarystory2022/search.asp?subshopgroupcode=" + subShopGroupCode + "&listtype=" + listtype + "&diarytype="+diarytype + "&listall="+listall;
    }

	<% if isapp = 1 then %>
	setTimeout(fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + link),1000);
    <% else %>
	setTimeout(window.document.location.href = link,1000);
	<% end if %>
}

function linkToSearchType2(subShopGroupCode,listtype,catecode,diarytype){		
	var link = "/diarystory2022/search.asp?subshopgroupcode=" + subShopGroupCode + "&listtype=" + listtype + "&catecode=" + catecode + "&diarytype="+diarytype;
	<% if isapp = 1 then %>
	setTimeout(fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + link),1000);
    <% else %>
	setTimeout(window.document.location.href = link,1000);
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
        sellYN = '',
        twoBadge = ''

    switch (subShopGroupCode) {
        case '100101':
            listTitleNameStr = "다이어리";
            break;
        case '100102':
            listTitleNameStr = "3공/6공";
            break;
        case '100103':
            listTitleNameStr = "캘린더";
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
        case '100107':
            listTitleNameStr = "스터디플래너";
            break;
        case '100108':
            listTitleNameStr = "가계부";
            break;
        default:
            break;
    }

    listHtmlStr += "<h3><a href='javascript:linkToSearchType("+ subShopGroupCode +", \"best\", \"\", \"\");'>"+ listTitleNameStr +"<i class='i_arw_r2'></i></a></h3>"
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
        if(giftBadge!="" && freeDelBadge!=""){
            twoBadge=" badge_two"
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
                                <div class="prd_badge' + twoBadge + '">\
                                    ' + freeDelBadge + giftBadge + '\
                                </div>\
                                <i class="badge_rank">'+ parseInt(index+1) +'</i>\
                            </div>\
                            <% if isapp = 1 then %>\
                            <a href="javascript:TnGotoAPPDiaryProduct('+ item.itemid +');" class="prd_link" onclick="fnAmplitudeEventMultiPropertiesAction(\'click_diarystory_best\',\'category_name|item_id\',\'' + listTitleNameStr + '|' + item.itemid +'\');"><span class="blind">상품 바로가기</span></a>\
                            <% else %>\
                            <a href="javascript:TnGotoDiaryProduct('+ item.itemid +');" class="prd_link" onclick="fnAmplitudeEventMultiPropertiesAction(\'click_diarystory_best\',\'category_name|item_id\',\'' + listTitleNameStr + '|' + item.itemid +'\');"><span class="blind">상품 바로가기</span></a>\
                            <% end if %>\
                        </article>'
    })
    listHtmlStr += "</div></div></div>"

    return $("#cate"+subShopGroupCode).html(listHtmlStr);
}

$(function() {
    getDiaryItems('100101'); // 다이어리
    getDiaryItems('100102'); // 3공/6공
    getDiaryItems('100103'); // 캘린더
    getDiaryItems('100107'); // 스터디플래너
    getDiaryItems('100108'); // 가계부
    getDiaryItems('100104'); // 스티커
    getDiaryItems('100106'); // 펜/색연필
    getDiaryItems('100105'); // 떡메모지

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
    <div id="cate100107"></div>
    <div id="cate100108"></div>
    <div id="cate100104"></div>
    <div id="cate100106"></div>
    <div id="cate100105"></div>
</section>