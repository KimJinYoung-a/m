<div class="modal_type3 mdl_filter" id="modal">
	<div class="modal_overlay"></div>
	<div class="modal_inner">
		<div class="modal_head">
			<button class="btn_close"><i class="i_close"></i>모달닫기</button>
			<%'!-- for dev msg 필터 적용 되어있을 경우 [on] 클래스 추가 --%>
			<button class="btn_type2 btn_wht filterclear">초기화<i class="i_refresh2"></i></button>
		</div>
		<div class="modal_cont">
			<div class="modal_cont_inner">
				<section class="filter_type1">
					<ul class="filter_main">
						<%'!-- for dev msg 현재 선택 [on]클래스 / 필터 적용 [selected]클래스 --%>
						<li data-subfilter="filter_sub1" class="on"><span>날짜</span></li> <%'!-- 다이어리 날짜 --%>
						<li data-subfilter="filter_sub2"><span>재질</span></li> <%'!-- 다이어리 재질 --%>
						<li data-subfilter="filter_sub3"><span>제본</span></li> <%'!-- 다이어리 제본 --%>
						<li data-subfilter="filter_sub4"><span>컬러</span></li> <%'!-- 다이어리 컬러 --%>
					</ul>
					<div class="filter_sub">
						<%'!-- 날짜 (날짜, 기간, 내지구성)--%>
						<div id="filter_sub1" class="filter_sub_cont on diary-attr">
							<div class="filter_sub_inner diary-attr">
								<p class="sub_tit">날짜</p>
								<ul>
									<li><div class="checkbox"><input type="checkbox" value="303004" id="opt4_a1"><label for="opt4_a1">2022날짜형</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="303002" id="opt4_a2"><label for="opt4_a2">만년형</label></div></li>
								</ul>
							</div>
							<div class="filter_sub_inner diary-attr">
								<p class="sub_tit">기간</p>
								<ul>
									<li><div class="checkbox"><input type="checkbox" value="304001" id="opt4_b1"><label for="opt4_b1">1개월</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="304002" id="opt4_b2"><label for="opt4_b2">3개월</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="304003" id="opt4_b3"><label for="opt4_b3">6개월</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="304004" id="opt4_b4"><label for="opt4_b4">1년</label></div></li>
								</ul>
							</div>
							<div class="filter_sub_inner diary-attr">
								<p class="sub_tit">내지구성</p>
								<ul>
									<li><div class="checkbox"><input type="checkbox" value="305001" id="opt4_c1"><label for="opt4_c1">먼슬리</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="305002" id="opt4_c2"><label for="opt4_c2">위클리</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="305003" id="opt4_c3"><label for="opt4_c3">데일리</label></div></li>
								</ul>
							</div>
						</div>
						<%'!-- 커버 (재질) --%>
						<div id="filter_sub2" class="filter_sub_cont">
							<div class="filter_sub_inner diary-attr">
								<p class="sub_tit">재질</p>
								<ul>
									<li><div class="checkbox"><input type="checkbox" value="306001" id="opt3_a1"><label for="opt3_a1">소프트커버</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="306002" id="opt3_a2"><label for="opt3_a2">하드커버</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="306003" id="opt3_a3"><label for="opt3_a3">가죽</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="306004" id="opt3_a4"><label for="opt3_a4">PVC</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="306005" id="opt3_a5"><label for="opt3_a5">패브릭</label></div></li>
								</ul>
							</div>
						</div>
						<%'!-- 커버 (제본) --%>
						<div id="filter_sub3" class="filter_sub_cont">
							<div class="filter_sub_inner diary-attr">
								<p class="sub_tit">제본</p>
								<ul>
									<li><div class="checkbox"><input type="checkbox" value="307006" id="opt3_b1"><label for="opt3_b1">양장/무선</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="307007" id="opt3_b2"><label for="opt3_b2">스프링</label></div></li>
									<li><div class="checkbox"><input type="checkbox" value="307008" id="opt3_b3"><label for="opt3_b3">6공 (바인더류)</label></div></li>
								</ul>
							</div>
						</div>
						<%'!-- 커버 (컬러) --%>
						<div id="filter_sub4" class="filter_sub_cont">
							<div class="filter_sub_inner filter_color">
								<p class="sub_tit">컬러</p>
								<ul class="colorchips">
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
					</div>
				</section>
			</div>
		</div>
		<div class="btn_b_type1">
			<button class="btn_ten" onclick="{getDiaryItems(1); $('#modal').hide(); toggleScrolling(); fnFilterTitleChance();}">적용하기</button>
		</div>
	</div>
</div>
<script>
$(function(){
	// 메인 필터 선택
	$('.filter_main li').click(function(){
		$(".filter_sub").animate({'scrollTop':0}, 10);
		var subfilter_id = $(this).attr('data-subfilter');

		$('.filter_main li').removeClass('on');
		$('.filter_sub_cont').removeClass('on');
        $(this).addClass('on')//.addClass('selected').siblings().removeClass('selected');
		$("#" + subfilter_id).addClass('on');
	});

	$('.filter_sub li').click(function() {
		var subFilter_id = $(this).parents('div').eq(1).attr('id');

		// 초기화 버튼 addClass = on
		$('.filterclear').addClass('on');

		$('.filter_main li').each(function() {
			var main_selector = $(this).attr('data-subfilter');
			if (subFilter_id == main_selector) {
				if($('#'+ subFilter_id +' input:checkbox:checked').length == 0) {
					$(this).removeClass('selected');
				} else {
					$(this).addClass('on').addClass('selected');
				}
			}
		})
	})
	
    // 모달 닫기
    $('.modal_overlay, #modal .btn_close').click(function () { 
        $('#modal').hide();
		<% if isApp then %>
		fnSetHeaderDim(false);
		<% end if %>
        toggleScrolling();
	});
    
    // 필터 초기화
    $('.filterclear').click(function() {
		$('.filterclear').removeClass('on'); // 초기화 버튼 css 제거
		$('.filter_main li').removeClass('on').removeClass('selected'); // 텝 영역 css 제거
        //$(".btn_dr_srch_type2").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
        $(".bbl_blk").fadeOut(3000); // 초기화
		$(".btn_type2").removeClass('on');
        fnFilterClear();
    })
});

// 모달 오픈
function fnCallModal() {
    $('#modal').show();
    <% if isApp then %>
    fnSetHeaderDim(true);
    <% end if %>
    toggleScrolling();
}

// 모달 호출될 때, 부모창 스크롤 방지
function toggleScrolling() {
    if ($('#modal').is(':visible')) {
		currentY = $(window).scrollTop();
        //$('html, body').addClass('not_scroll');
    } else {
        //$('html, body').removeClass('not_scroll');
        $('html, body').animate({scrollTop : currentY}, 0);
    }
}

// 다이어리 필터 선택 후
function fnFilterTitleChance() {
    var tempTitle = []
    var returnTitle = '';
    var returnCount = '';

    if ($('.filter_type1 input:checkbox:checked').length == 0) {
        $(".btn_dr_srch_type2").removeClass('on').text('취향에 딱! 맞는 다이어리 찾기'); // 타이틀
        $(".bbl_blk").hide(); // 초기화
        return false;
    }

    $('.filter_type1 input:checkbox:checked').each(function() {
        var attr = $(this).siblings('label').text();
        if(attr == "") return true;
		tempTitle.push(attr);
    })

    //returnTitle = tempTitle.slice(0,3).toString();
    //returnCount = tempTitle.length > 3 ? ' 외 <em class="cnt">'+ (tempTitle.length - 3).toString() +'</em>' : '';

    //var returnMessage = returnTitle + returnCount;

    $(".btn_type2").addClass('on');
    $(".bbl_blk").show();
	$('.filterclear').addClass('on');
}

function fnMainFilterStyleOn() {
	var tempidx = true ;
	$('.filter_type1 input:checkbox:checked').each(function() {
		var mainFilterId = $(this).parents('div').eq(2).attr('id');
		
		$('.filter_main li').each(function() {
			var main_selector = $(this).attr('data-subfilter');
			if (mainFilterId == main_selector) {
				if ( tempidx ) {
					$(this).addClass('on');
					tempidx = false;
				}
				$(this).addClass('selected');
			}
		})
	})
}
</script>
