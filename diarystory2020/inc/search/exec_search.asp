<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 다이어리 2020 검색 exe파일
' History : 2019-08-29 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.05" />
<script type="text/javascript">
$(function() {
    // filter fold and unfold
    $( ".filter-list" ).hide();
	$(".btn-finder").on("click", function(){
        $(this).hide();
        $('.search-head').addClass('on');
        $( ".filter-list" ).slideDown();
		return false;
    });
	$(".filter-list .icon").on("click", function(){
        unfold();
        return false;
    });
	$(".filter-list button").on("click", function(){
        unfold();
        return false;
    });
    function unfold (){
        $('html,body').animate({ scrollTop : window.top },300);
        $(".btn-finder").show();
        $('.search-head').removeClass('on');
        $('.filter-list').slideUp();
    }
	$(".filter ul li input:checkbox").on("click", function(){
        $(this).next().toggleClass("on");
    });
    $(".sort-area .slt-area input").click(function(){
        getDiaryItems(1)
    })
});
</script>
<script>
var isloading = true;
var isNomoreResult = false;

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
        color: getParameterByName('col')
    }
    history.replaceState({}, null, location.pathname); //파라미터 제거
    setCheckBox(options);
    return (options.att == '' && options.color == '') ? '' : options
}
function setCheckBox(optionsObj){
    if(optionsObj.att == '' && optionsObj.color == '' ) return false;

    var attArr = optionsObj.att.split(',')
    var colorArr = optionsObj.color.split(',')

	$('.diary-attr input:checkbox').each(function(){
        // console.log(attArr)
        var tmpVal = $(this).val()

        // $("#all_items").prop("checked",false)
    })
    attArr.forEach(function(item){
        $(".diary-attr [value="+ item +"]").prop("checked", true).next().toggleClass("on")
    })
    colorArr.forEach(function(item){
        $(".colorchips [value="+ item +"]").prop("checked", true).next().toggleClass("on")
    })

	$('.colorchips input:checkbox').each(function(){
        // $("#all_items").prop("checked",false)
    })

    // console.log(attArr, colorArr)
    // attArr.forEach(function(item){
    //     console.log(item)
    // })
}

$(function(){
    getDiaryItems();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 150){
          if (!isloading && !isNomoreResult){
            isloading=true;
			var pg = $("#pagefrm input[name='cpg']").val();
			pg++;
			$("#pagefrm input[name='cpg']").val(pg);
            setTimeout(getDiaryItems, 300);
          }
      }
    });
});
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
	$('.diary-attr input:checkbox:checked').each(function(){
        var attr = $(this).val();
        if(attr == "") return true
		attTempArr.push(attr)
	})

	$('.colorchips input:checkbox:checked').each(function(){
        var colorChip = $(this).val();
        if(colorChip == "") return true
		colorTempArr.push(colorChip)
    })
    return {
        att: generateAttr(attTempArr),
        color: generateAttr(colorTempArr)
    }
}

function getDiaryItems(vpage){
    var optinosFromMain = getOptionsFromMain()
    var searchParam = optinosFromMain == '' ? getSearchParam() : optinosFromMain
    var srm         = $("#sortmet").val();
    var attribCd    = searchParam.att
    var deliType    = $('input:checkbox[id="deliType"]').is(':checked') ? $("#deliType").val() : ""
    var giftdiv     = $('input:checkbox[id="giftdiv"]').is(':checked') ? $("#giftdiv").val() : ""
    var colorCd     = searchParam.color
    var pageSize    = 24
    var SubShopCd   = 100
    var page = 1

    // console.log(attribCd)
    // console.log('page : ',vpage)
    if(vpage != undefined) {
        $("#pagefrm input[name='cpg']").val(vpage)
        isNomoreResult = false //스크롤 이벤트 초기화
    }

    page = $("#pagefrm input[name='cpg']").val()

    var items = []

    $.ajax({
		type: "POST",
		url: "/diarystory2020/api/diaryItems.asp",
		data: {
            srm: srm,
            cpg: page,
            pageSize: pageSize,
            SubShopCd: SubShopCd,
            deliType: deliType,
            giftdiv: giftdiv,
            attribCd: attribCd,
            colorCd: colorCd
        },
		dataType: "json",
        success: function(Data){
            items = Data.items
            // console.log(items)
            renderItems(items)
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            // console.log(e)
            $("#listContainer").empty();
        }
	})
}
function renderItems(items){
    var cpage = $("#pagefrm input[name='cpg']").val()

    // console.log(cpage)
    if(items.length < 1 && cpage == 1){
        var noResultHtml ='<div class="nodiary-area">\
                            <p>만족하는 다이어리가 없습니다</p>\
                            <button class="btn-nodiary" onclick="window.location.reload()">다이어리 전체보기</button>\
                          </div>'

        $("#listContainer").html(noResultHtml);
        return false;
    }
    if(cpage > 1 && items.length < 1) isNomoreResult = true
    var listHtmlStr = ''
    var bestBadge = ''
    var newBadge = ''
    var giftBadge = ''
    var freeDelBadge = ''
    var sellYN = ''

    listHtmlStr += cpage == 1 ? '<div class="items type-list"><ul id="lySearchResult">' : ''
    items.forEach(function(item){
        bestBadge = item.bestYn == 'Y' ? '<div class="badge-best">BEST</div>' : ''
        newBadge = item.newYn == 'Y' ? '<div class="badge-new">NEW</div>' : ''
        if(item.bestYn == 'Y' && item.newYn == 'Y') newBadge = ''

        sellYN = item.sellYN == 'N' ? '<span class="soldout"><span class="ico-soldout">일시품절</span></span>' : ''
        giftBadge = item.giftDiv == 'R' ? '<div class="badge badge-count2 badge-count2-gift"><em>사은품증정</em></div>' : ''
        freeDelBadge = item.isFreeDelivery == "Y" ? '<div class="badge badge-count2"><em>무료배송</em></div>' : ''

        listHtmlStr += '<li>\
                            <% if isapp = 1 then %>\
                            <a href="javascript:fnAPPpopupProduct('+ item.itemid +')">\
                            <% else %>\
                            <a href="/category/category_itemPrd.asp?itemid='+ item.itemid +'">\
                            <% end if %>\
                                <div class="thumbnail">\
                                    <img src="'+ item.itemImg +'" alt="" />\
                                    ' + sellYN + '\
									<div class="badge-group">\
                                    ' + giftBadge + freeDelBadge + '\
									</div>\
                                </div>\
                                ' + bestBadge + newBadge + '\
                                <div class="desc">\
                                    <div class="price-area">\
                                        <span class="price">'+ item.price +'</span>\
                                        <b class="discount sale">'+ item.saleStr +'</b>\
                                        <b class="discount coupon">'+ item.couponStr +'</b>\
                                    </div>\
                                    <p class="name">'+ item.itemName +'</p>\
                                    <span class="brand">'+ item.brandName +'</span>\
                                </div>\
                            </a>\
                        </li>'
    })
    listHtmlStr += cpage == 1 ? '</ul></div>' : ''
    if(cpage == 1){
        $("#listContainer").html(listHtmlStr);
    }else{
        $('#lySearchResult').append(listHtmlStr)
    }
    isloading=false;
}
</script>
</head>
    <div id="content" class="content diary-main diary-search">
        <section class="search-head">
            <h2>다이어리 찾기</h2>
            <button class="btn-all ico-chk" onclick="window.location.reload()">모든 다이어리 보기</button> <!-- for dev msg 모든 다이어리보기 -->
            <button class="btn btn-finder">찾으시는 디자인을 선택해주세요<span class="icon"></span></button>
        </section>

		<!-- 내가 원하는 다이어리찾기 -->
		<div class="filter-list">
			<div class="inner">
				<p class="tit">내가 원하는 다이어리 찾기</p>
				<p class="sub">디자인을 선택 후 아래의 ‘찾기’ 버튼을 눌러주세요. </p>
                <span class="icon"></span>
                <div class="filter">
                    <p>구분</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="301001" id="optS1-1" /> <label for="optS1-1">다이어리</label></li>
                        <li><input type="checkbox" value="301002" id="optS1-2" /> <label for="optS1-2">스터디</label></li>
                        <li><input type="checkbox" value="301003" id="optS1-3" /> <label for="optS1-3">가계부</label></li>
                        <li></li>
                    </ul>
                </div>
                <div class="filter">
                    <p>스타일</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="302001" id="optS2-1" /> <label for="optS2-1">심플</label></li>
                        <li><input type="checkbox" value="302002" id="optS2-2" /> <label for="optS2-2">일러스트</label></li>
                        <li><input type="checkbox" value="302003" id="optS2-3" /> <label for="optS2-3">패턴</label></li>
                        <li><input type="checkbox" value="302004" id="optS2-4" /> <label for="optS2-4">포토</label></li>
                    </ul>
                </div>
                <div class="filter">
                    <p>날짜</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="303001" id="optCt3-1" /> <label for="optCt3-1">2020 날짜형</label></li>
                        <li><input type="checkbox" value="303002" id="optCt3-2" /> <label for="optCt3-2">만년형</label></li>
                    </ul>
                </div>
                <div class="filter">
                    <p>기간</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="304001" id="optCt4-1" /> <label for="optCt4-1">1개월</label></li>
                        <li><input type="checkbox" value="304002" id="optCt4-2" /> <label for="optCt4-2">3개월</label></li>
                        <li><input type="checkbox" value="304003" id="optCt4-3" /> <label for="optCt4-3">6개월</label></li>
                        <li><input type="checkbox" value="304004" id="optCt4-4" /> <label for="optCt4-4">1년</label></li>
                        <li><input type="checkbox" value="304005" id="optCt4-5" /> <label for="optCt4-5">1년 이상</label></li>
                    </ul>
                </div>
                <div class="filter">
                    <p>내지 구성</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="305001" id="optCt5-1" /> <label for="optCt5-1">먼슬리</label></li>
                        <li><input type="checkbox" value="305002" id="optCt5-2" /> <label for="optCt5-2">위클리</label></li>
                        <li><input type="checkbox" value="305003" id="optCt5-3" /> <label for="optCt5-3">데일리</label></li>
                        <li></li>
                    </ul>
                </div>
                <div class="filter">
                    <p>재질</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="306001" id="optCt6-1" /> <label for="optCt6-1">소프트커버</label></li>
                        <li><input type="checkbox" value="306002" id="optCt6-2" /> <label for="optCt6-2">하드커버</label></li>
                        <li><input type="checkbox" value="306003" id="optCt6-3" /> <label for="optCt6-3">가죽</label></li>
                        <li><input type="checkbox" value="306004" id="optCt6-4" /> <label for="optCt6-4">PVC</label></li>
                        <li><input type="checkbox" value="306005" id="optCt6-5" /> <label for="optCt6-5">패브릭</label></li>
                    </ul>
                </div>
                <div class="filter">
                    <p>제본</p>
                    <ul class="option-list diary-attr">
                        <li><input type="checkbox" value="307006" id="optCt7-1" /> <label for="optCt7-1">양장/무선</label></li>
                        <li><input type="checkbox" value="307007" id="optCt7-2" /> <label for="optCt7-2">스프링</label></li>
                        <li><input type="checkbox" value="307008" id="optCt7-3" /> <label for="optCt7-3">6공 (바인더류)</label></li>
                        <li></li>
                    </ul>
                </div>
                <div class="filter filter-color">
                    <p>컬러</p>
                    <ul class="option-list colorchips">
                        <li class="wine"><input type="checkbox"      value="023" id="wine" /><label for="wine">Wine</label></li>
                        <li class="red"><input type="checkbox"       value="001" id="red" /><label for="red">Red</label></li>
                        <li class="orange"><input type="checkbox"    value="002" id="orange" /><label for="orange">Orange</label></li>
                        <li class="brown"><input type="checkbox"     value="010" id="brown" /><label for="brown">Brown</label></li>
                        <li class="camel"><input type="checkbox"     value="021" id="camel" /><label for="camel">Camel</label></li>
                        <li class="green"><input type="checkbox"     value="005" id="green" /><label for="green">Green</label></li>
                        <li class="khaki"><input type="checkbox"     value="019" id="khaki" /><label for="khaki">Khaki</label></li>
                        <li class="beige"><input type="checkbox"     value="004" id="beige" /><label for="beige">Beige</label></li>
                        <li class="yellow"><input type="checkbox"    value="003" id="yellow" /><label for="yellow">Yellow</label></li>
                        <li class="ivory"><input type="checkbox"     value="024" id="ivory" /><label for="ivory">Ivory</label></li>
                        <li class="mint"><input type="checkbox"      value="016" id="mint" /><label for="mint">Mint</label></li>
                        <li class="skyblue"><input type="checkbox"   value="006" id="skyblue" /><label for="skyblue">Sky Blue</label></li>
                        <li class="blue"><input type="checkbox"  	 value="007" id="blue" /><label for="blue">Blue</label></li>
                        <li class="navy"><input type="checkbox" 	 value="020" id="navy" /><label for="navy">Navy</label></li>
                        <li class="violet"><input type="checkbox"    value="008" id="violet" /><label for="violet">Violet</label></li>
                        <li class="lightgrey"><input type="checkbox" value="012" id="lightgrey" /><label for="lightgrey">Light Grey</label></li>
                        <li class="white"><input type="checkbox"     value="011" id="white" /><label for="white">White</label></li>
                        <li class="pink"><input type="checkbox"      value="009" id="pink" /><label for="pink">Pink</label></li>
                        <li class="babypink"><input type="checkbox"  value="017" id="babypink" /><label for="babypink">Baby Pink</label></li>
                        <li class="lilac"><input type="checkbox"     value="018" id="lilac" /><label for="lilac">Lilac</label></li>
                        <li class="charcoal"><input type="checkbox"  value="022" id="charcoal" /><label for="charcoal">Charcoal</label></li>
                        <li class="black"><input type="checkbox"     value="013" id="black" /><label for="black">Black</label></li>
                        <li class="silver"><input type="checkbox"    value="014" id="silver" /><label for="silver">Silver</label></li>
                        <li class="gold"><input type="checkbox"      value="015" id="gold" /><label for="gold">Gold</label></li>
                    </ul>
                </div>
			</div>
			<button class="btn btn-block" onclick="getDiaryItems(1)">다이어리 찾기</button>
        </div>

        <!-- sort 0902추가변경 -->
        <div class="sort-area">
            <ul class="slt-area">
                <li><input type="checkbox" name="type" name="deliType" value="FD" id="deliType"><label for="deliType">무료배송</label></li>
                <li><input type="checkbox" name="type" name="giftdiv"  value="R" id="giftdiv"><label for="giftdiv">사은품 증정</label></li>
            </ul>
            <div class="filter">
                <select id="sortmet" onchange="getDiaryItems(1)">
                    <option value="be">인기상품순</option>
                    <option value="ne">신상품순</option>
                    <option value="lp">낮은가격순</option>
                    <option value="hs">높은할인율순</option>
                </select>
                <span></span>
            </div>
        </div>

        <!-- 검색결과 -->
        <div class="diary-list best" id="listContainer">
        </div>
	</div>
    <form id="pagefrm" name="pagefrm">
        <input type="hidden" name="cpg" value="1" />
    </form>