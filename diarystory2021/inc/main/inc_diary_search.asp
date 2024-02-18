<%'<!-- 다이어리 찾기 --> <!-- 다이어리 찾기 필터 모달(/html/diarystory2021/modal_filter.asp)-->%>
<section class="sect_srch">
    <p class="sub">텐바이텐이 도와드릴게요!</p>
    <h2>취향에 맞는 다이어리를 <br>찾아드립니다&nbsp&nbsp&nbsp</h2>
    <div class="srch_guide">
        <!-- for dev msg 
            기본 세팅 값 : 다이어리, 심플, 6공, 만년형
            [selected_not] 클래스 : 필터 안 걸려 있을 경우
            [selected_multi] 클래스 : 2개 이상 필터 걸렸을 경우
        -->
        저는<button data-subfilter="filter_sub1" id="btn1">다이어리</button>를 찾고 있어요.<br>
        <button data-subfilter="filter_sub2" id="btn2">심플</button>스타일에
        <button data-subfilter="filter_sub3" id="btn3">소프트커버</button>의<br>
        <button data-subfilter="filter_sub4" id="btn4">만년형</button>이(가) 좋겠어요.
    </div>
    <button class="btn_dr_srch" onclick="linkToSearch();">다이어리 찾기</button>
</section>

<div class="modal_type3 mdl_filter" id="modal">
	<div class="modal_overlay"></div>
	<div class="modal_inner">
		<div class="modal_head">
			<button class="btn_close"><i class="i_close"></i>모달닫기</button>
			<!-- for dev msg 필터 적용 되어있을 경우 [on] 클래스 추가 -->
			<button class="btn_type2 btn_wht on" onclick="fnResetFilter();">초기화<i class="i_refresh2"></i></button>
		</div>
		<div class="modal_cont">
			<div class="modal_cont_inner">
				<section class="filter_type1">
					<ul class="filter_main">
						<li class="on selected" id="sub1" data-subfilter="filter_sub1"><span>종류</span></li>
						<li class="on selected" id="sub2" data-subfilter="filter_sub2"><span>스타일</span></li>
						<li class="on selected" id="sub3" data-subfilter="filter_sub3"><span>커버</span></li>
						<li class="on selected" id="sub4" data-subfilter="filter_sub4"><span>날짜</span></li>
					</ul>
					<div  class="filter_sub">
						<!-- 종류 -->
						<div id="filter_sub1" class="filter_sub_cont on">
							<ul class="diary-attr">
								<li>
									<div class="checkbox"><input type="checkbox" value="301001" id="opt1_a1" checked="checked"><label for="opt1_a1">다이어리</label></div>
								</li>
								<li>
									<div class="checkbox"><input type="checkbox" value="301002" id="opt1_a2"><label for="opt1_a2">스터디</label></div>
								</li>
								<li>
									<div class="checkbox"><input type="checkbox" value="301003" id="opt1_a3"><label for="opt1_a3">가계부</label></div>
								</li>
							</ul>
						</div>
						<!-- 스타일 -->
						<div id="filter_sub2" class="filter_sub_cont">
							<ul class="diary-attr">
								<li>
									<div class="checkbox"><input type="checkbox" value="302001" id="opt2_a1" checked="checked"><label for="opt2_a1">심플</label></div>
								</li>
								<li>
									<div class="checkbox"><input type="checkbox" value="302002" id="opt2_a2"><label for="opt2_a2">일러스트</label></div>
								</li>
								<li>
									<div class="checkbox"><input type="checkbox" value="302003" id="opt2_a3"><label for="opt2_a3">패턴</label></div>
								</li>
								<!--<li>
									<div class="checkbox"><input type="checkbox" value="302004" id="opt2_a4"><label for="opt2_a4">포토</label></div>
								</li>-->
							</ul>
						</div>
						<!-- 커버 (재질, 제본, 컬러) -->
						<div id="filter_sub3" class="filter_sub_cont">
							<div class="filter_sub_inner">
								<p class="sub_tit">재질</p>
								<ul class="diary-attr">
									<li>
										<div class="checkbox"><input type="checkbox" value="306001" id="opt3_a1" checked="checked"><label for="opt3_a1">소프트커버</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="306002" id="opt3_a2"><label for="opt3_a2">하드커버</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="306003" id="opt3_a3"><label for="opt3_a3">가죽</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="306004" id="opt3_a4"><label for="opt3_a4">PVC</label></div>
									</li>
								</ul>
							</div>
							<div class="filter_sub_inner">
								<p class="sub_tit">제본</p>
								<ul class="diary-attr">
									<li>
										<div class="checkbox"><input type="checkbox" value="307006" id="opt3_b1"><label for="opt3_b1">양장/무선</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="307007" id="opt3_b2"><label for="opt3_b2">스프링</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="307008" id="opt3_b3"><label for="opt3_b3">6공 (바인더류)</label></div>
									</li>
								</ul>
							</div>
							<div class="filter_sub_inner filter_color">
								<p class="sub_tit">컬러</p>
								<ul class="colorchips">
									<li class="wine"><input type="checkbox" value="023" id="wine" /><label for="wine">Wine</label></li>
									<li class="red"><input type="checkbox" value="001" id="red" /><label for="red">Red</label></li>
									<li class="orange"><input type="checkbox" value="002" id="orange" /><label for="orange">Orange</label></li>
									<li class="brown"><input type="checkbox" value="010" id="brown" /><label for="brown">Brown</label></li>
									<li class="camel"><input type="checkbox" value="021" id="camel" /><label for="camel">Camel</label></li>
									<li class="green"><input type="checkbox" value="005" id="green" /><label for="green">Green</label></li>
									<li class="khaki"><input type="checkbox" value="019" id="khaki" /><label for="khaki">Khaki</label></li>
									<li class="beige"><input type="checkbox" value="004" id="beige" /><label for="beige">Beige</label></li>
									<li class="yellow"><input type="checkbox" value="003" id="yellow" /><label for="yellow">Yellow</label></li>
									<li class="ivory"><input type="checkbox" value="024" id="ivory" /><label for="ivory">Ivory</label></li>
									<li class="mint"><input type="checkbox" value="016" id="mint" /><label for="mint">Mint</label></li>
									<li class="skyblue"><input type="checkbox" value="006" id="skyblue" /><label for="skyblue">Sky Blue</label></li>
									<li class="blue"><input type="checkbox" value="007" id="blue" /><label for="blue">Blue</label></li>
									<li class="navy"><input type="checkbox" value="020" id="navy" /><label for="navy">Navy</label></li>
									<li class="violet"><input type="checkbox" value="008" id="violet" /><label for="violet">Violet</label></li>
									<li class="lightgrey"><input type="checkbox" value="012" id="lightgrey" /><label for="lightgrey">Light Grey</label></li>
									<li class="white"><input type="checkbox" value="011" id="white" /><label for="white">White</label></li>
									<li class="pink"><input type="checkbox" value="009" id="pink" /><label for="pink">Pink</label></li>
									<li class="babypink"><input type="checkbox" value="017" id="babypink" /><label for="babypink">Baby Pink</label></li>
									<li class="lilac"><input type="checkbox" value="018" id="lilac" /><label for="lilac">Lilac</label></li>
									<li class="charcoal"><input type="checkbox" value="022" id="charcoal" /><label for="charcoal">Charcoal</label></li>
									<li class="black"><input type="checkbox" value="013" id="black" /><label for="black">Black</label></li>
									<li class="silver"><input type="checkbox" value="014" id="silver" /><label for="silver">Silver</label></li>
									<li class="gold"><input type="checkbox" value="015" id="gold" /><label for="gold">Gold</label></li>
								</ul>
							</div>
						</div>
						<!-- 날짜 (날짜, 기간, 내지구성)-->
						<div id="filter_sub4" class="filter_sub_cont">
							<div class="filter_sub_inner">
								<p class="sub_tit">날짜</p>
								<ul class="diary-attr">
									<li>
										<div class="checkbox"><input type="checkbox" value="303003" id="opt4_a1"><label for="opt4_a1">2021 날짜형</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="303002" id="opt4_a2" checked="checked"><label for="opt4_a2">만년형</label></div>
									</li>
								</ul>
							</div>
							<div class="filter_sub_inner">
								<p class="sub_tit">기간</p>
								<ul class="diary-attr">
									<li>
										<div class="checkbox"><input type="checkbox" value="304001" id="opt4_b1"><label for="opt4_b1">1개월</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="304002" id="opt4_b2"><label for="opt4_b2">3개월</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="304003" id="opt4_b3"><label for="opt4_b3">6개월</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="304004" id="opt4_b4"><label for="opt4_b4">1년</label></div>
									</li>
								</ul>
							</div>
							<div class="filter_sub_inner">
								<p class="sub_tit">내지구성</p>
								<ul class="diary-attr">
									<li>
										<div class="checkbox"><input type="checkbox" value="305001" id="opt4_c1"><label for="opt4_c1">먼슬리</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="305002" id="opt4_c2"><label for="opt4_c2">위클리</label></div>
									</li>
									<li>
										<div class="checkbox"><input type="checkbox" value="305003" id="opt4_c3"><label for="opt4_c3">데일리</label></div>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</section>
			</div>
		</div>
		<div class="btn_b_type1">
			<button class="btn_ten" onclick="fnSetFilter();">적용하기</button>
		</div>
	</div>
</div>
<script>
var _cateno1="301001";
var _cateno2="302001";
var _cateno3="306001";
var _cateno4="303002";
var _cateno5="028";
var _cnt1=1;
var _cnt2=1;
var _cnt3=1;
var _cnt4=1;
var categoryinfo1 = [
    {code:'301100',name:'모든종류'},
    {code:'301001',name:'다이어리'}, 
    {code:'301002',name:'스터디'}, 
    {code:'301003',name:'가계부'}
]

var categoryinfo2 = [
    {code:'302100',name:'모든'}, 
    {code:'302001',name:'심플'}, 
    {code:'302002',name:'일러스트'}, 
    {code:'302003',name:'패턴'}, 
    {code:'302004',name:'포토'}
]

var categoryinfo3 = [
    {code:'307100',name:'모든커버'},
    {code:'306001',name:'소프트커버'}, 
    {code:'306002',name:'하드커버'}, 
    {code:'306003',name:'가죽'}, 
    {code:'306004',name:'PVC'}, 
    {code:'307006',name:'양장/무선'},
    {code:'307007',name:'스프링'},
    {code:'307008',name:'6공'},
    {code:'023',name:'wine'},
    {code:'001',name:'red'},
    {code:'002',name:'orange'},
    {code:'010',name:'brown'},
    {code:'021',name:'camel'},
    {code:'005',name:'green'},
    {code:'019',name:'khaki'},
    {code:'004',name:'beige'},
    {code:'003',name:'yellow'},
    {code:'024',name:'ivory'},
    {code:'016',name:'mint'},
    {code:'006',name:'skyblue'},
    {code:'007',name:'blue'},
    {code:'020',name:'navy'},
    {code:'008',name:'violet'},
    {code:'012',name:'lightgrey'},
    {code:'011',name:'white'},
    {code:'009',name:'pink'},
    {code:'017',name:'babypink'},
    {code:'018',name:'lilac'},
    {code:'022',name:'charcoal'},
    {code:'013',name:'black'},
    {code:'014',name:'silver'},
    {code:'015',name:'gold'},
    {code:'028',name:'모든커버'}
]

var categoryinfo4 = [
    {code:'305100',name:'모든날짜형'}, 
	{code:'303001',name:'2021 날짜형'}, 
    {code:'303002',name:'만년형'}, 
    {code:'304001',name:'1개월'}, 
    {code:'304002',name:'3개월'}, 
    {code:'304003',name:'6개월'},
    {code:'304004',name:'1년'},
    {code:'305001',name:'먼슬리'},
    {code:'305002',name:'위클리'},
    {code:'305003',name:'데일리'}
]

$(function(){
	// 메인 필터 선택
	$('.filter_main li').click(function(){
		$(".filter_sub").animate({'scrollTop':0}, 10);
		var subfilter_id = $(this).attr('data-subfilter');

		$('.filter_main li').removeClass('on');
		$('.filter_sub_cont').removeClass('on');
		$(this).addClass('on');
		$("#" + subfilter_id).addClass('on');
	});

    // 모달 닫기
    $('.modal_overlay, #modal .btn_close').click(function () { 
        $('#modal').hide();
        toggleScrolling();
	});
	
	// 메인 '다이어리 찾기 영역' 버튼 클릭시
	$('.srch_guide button').click(function(){
		fnCallModal();
		$(".filter_sub").animate({'scrollTop':0}, 10);
		var subfilter_id = $(this).attr('data-subfilter');

		$('.filter_main li').removeClass('on');
		$('.filter_sub_cont').removeClass('on');
		$('.filter_main li[data-subfilter='+ subfilter_id +']').addClass('on');
		$("#" + subfilter_id).addClass('on');
    })

    $("#filter_sub1 input:checkbox").click(function(){
        var catename='';
        if($(this).prop('checked')){
            _cnt1=_cnt1+1;
            if(Number(_cateno1)>Number($(this).val())){
                _cateno1=$(this).val();
            }
            $("#btn1").removeClass("selected_not");
            $("#btn1").addClass("selected_multi");
            $("#sub1").addClass('on').addClass('selected');
        }
        else{
            _cateno1="301100";
            if(_cnt1!=0){
                _cnt1=_cnt1-1;
            }
            $('#filter_sub1 input:checkbox:checked').each(function(){
                if(Number(_cateno1)>Number($(this).val())){
                    _cateno1=$(this).val();
                }
            });
            if(_cateno1=="301100"){
                $("#btn1").removeClass("selected_multi");
                $("#btn1").addClass("selected_not");
            }
        }
        categoryinfo1.forEach(function(item){
		    if(item.code==_cateno1){
                catename=item.name;
            }
        });
        if(_cnt1==0){
            $("#btn1").empty().html(catename);
            $("#sub1").removeClass('selected');
        }
        else if(_cnt1==1){
            $("#btn1").empty().html(catename);
            $("#btn1").removeClass("selected_multi");
        }
        else{
            $("#btn1").empty().html(catename + "<i class='cnt'>+"+(_cnt1-1)+"</i>");
        }
    });
    $("#filter_sub2 input:checkbox").click(function(){
        var catename='';
        if($(this).prop('checked')){
            _cnt2=_cnt2+1;
            if(Number(_cateno2)>Number($(this).val())){
                _cateno2=$(this).val();
            }
            $("#btn2").removeClass("selected_not");
            $("#btn2").addClass("selected_multi");
            $("#sub2").addClass('on').addClass('selected');
        }
        else{
            _cateno2="302100";
            if(_cnt2!=0){
                _cnt2=_cnt2-1;
            }
            $('#filter_sub2 input:checkbox:checked').each(function(){
                if(Number(_cateno2)>Number($(this).val())){
                    _cateno2=$(this).val();
                }
            });
            if(_cateno2=="302100"){
                $("#btn2").removeClass("selected_multi");
                $("#btn2").addClass("selected_not");
            }
        }
        categoryinfo2.forEach(function(item){
		    if(item.code==_cateno2){
                catename=item.name;
            }
        });
        if(_cnt2==0){
            $("#btn2").empty().html(catename);
            $("#sub2").removeClass('selected');
        }
        else if(_cnt2==1){
            $("#btn2").empty().html(catename);
            $("#btn2").removeClass("selected_multi");
        }
        else{
            $("#btn2").empty().html(catename + "<i class='cnt'>+"+(_cnt2-1)+"</i>");
        }
    });
    $("#filter_sub3 input:checkbox").click(function(){
        var catename='';
        var colorCode='';

        if($(this).val().length<4){ //코드 길이 체크
            colorCode = true;
        }
        
        if($(this).prop('checked')){
            _cnt3=_cnt3+1; //카운트 +1
            if(colorCode){
                if(Number(_cateno5)>Number($(this).val())){
                    _cateno5=$(this).val();
                    //alert(_cateno5);
                }
            }else{
                if(Number(_cateno3)>Number($(this).val())){
                    _cateno3=$(this).val();
                }
            }
            
            //$("#btn3").removeClass("selected_not");
            //$("#btn3").addClass("selected_multi");
            $("#sub3").addClass('on').addClass('selected');
        }
        else{
            //alert("변수");
            if(_cateno3==$(this).val()){
                _cateno3="307100";
            }
            if(_cnt3!=0){
                _cnt3=_cnt3-1;
            }
            
            $('#filter_sub3 input:checkbox:checked').each(function(){
                if(colorCode){
                    if(Number(_cateno5)>Number($(this).val())){
                        _cateno5=$(this).val();
                        //alert("선택2");
                    }
                }else{
                    if(Number(_cateno3)>Number($(this).val())){
                        _cateno3=$(this).val();
                    }
                }
            });
            
        }
        
        categoryinfo3.forEach(function(item){
		    if(item.code==_cateno3){
                catename=item.name;
            }
        });
        if(_cateno3=="307100"){
            $("#btn3").removeClass("selected_multi");
            $("#btn3").addClass("selected_not");
            if(_cnt3==0){
                _cateno5="028";
            }
            categoryinfo3.forEach(function(item){
                if(item.code==_cateno5){
                    catename=item.name;
                    $("#btn3").removeClass("selected_not");
                    $("#btn3").addClass("selected_multi");
                }
                
            });
        }else{
            $("#btn3").removeClass("selected_not");
            $("#btn3").addClass("selected_multi");
        }
        // /alert(_cateno5);
        if(_cnt3==0){
            $("#btn3").empty().html(catename);
            $("#sub3").removeClass('selected');
            $("#btn3").removeClass("selected_multi");
            $("#btn3").addClass("selected_not");
        }
        else if(_cnt3==1){
            $("#btn3").empty().html(catename);
            $("#btn3").removeClass("selected_multi");
        }
        else{
            $("#btn3").empty().html(catename + "<i class='cnt'>+"+(_cnt3-1)+"</i>");
        }
    });
    $("#filter_sub4 input:checkbox").click(function(){
        var catename='';
        if($(this).prop('checked')){
            _cnt4=_cnt4+1;
            if(Number(_cateno4)>Number($(this).val())){
                _cateno4=$(this).val();
            }
            $("#btn4").removeClass("selected_not");
            $("#btn4").addClass("selected_multi");
            $("#sub4").addClass('on').addClass('selected');
        }
        else{
            _cateno4="305100";
            if(_cnt4!=0){
                _cnt4=_cnt4-1;
            }
            $('#filter_sub4 input:checkbox:checked').each(function(){
                if(Number(_cateno4)>Number($(this).val())){
                    _cateno4=$(this).val();
                }
            });
            if(_cateno4=="305100"){
                $("#btn4").removeClass("selected_multi");
                $("#btn4").addClass("selected_not");
            }
        }
        categoryinfo4.forEach(function(item){
		    if(item.code==_cateno4){
                catename=item.name;
            }
        });
        if(_cnt4==0){
            $("#btn4").empty().html(catename);
            $("#sub4").removeClass('selected');
        }
        else if(_cnt4==1){
            $("#btn4").empty().html(catename);
            $("#btn4").removeClass("selected_multi");
        }
        else{
            $("#btn4").empty().html(catename + "<i class='cnt'>+"+(_cnt4-1)+"</i>");
        }
    });
});
// 모달 오픈
function fnCallModal() {
    $('#modal').show();
    toggleScrolling();
}

// 모달 호출될 때, 부모창 스크롤 방지
function toggleScrolling() {
    if ($('#modal').is(':visible')) {
        currentY = $(window).scrollTop();
        fnAPPpopupScrollToTOP();
        $('html, body').addClass('not_scroll');
    } else {
        $('html, body').removeClass('not_scroll');
        $('html, body').animate({scrollTop:currentY}, 0);
    }
}

function linkToSearch(){		
	var link = "/diarystory2021/search.asp?attr=" + getSearchParam().att + "&col=" + getSearchParam().color
	// console.log(link)
	<% if isapp > 0 then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 검색', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + link)
	<% else %>
	window.document.location.href = link
	<% end if %>
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

function generateAttr(targetArr){
    var result = ""
	targetArr.forEach(function(item){
		result += item + ','
	});

    return $.trim(result)
}

function fnResetFilter(){
    $("#btn1").removeClass("selected_multi");
    $("#btn1").addClass("selected_not");
    $("#btn1").empty().html("모든종류");
    _cateno1="301100";
    _cnt1=0;
    $("#btn2").removeClass("selected_multi");
    $("#btn2").addClass("selected_not");
    $("#btn2").empty().html("모든");
    _cateno2="302100";
    _cnt2=0;
    $("#btn3").removeClass("selected_multi");
    $("#btn3").addClass("selected_not");
    $("#btn3").empty().html("모든커버");
    _cateno3="307100";
    _cnt3=0;
    $("#btn4").removeClass("selected_multi");
    $("#btn4").addClass("selected_not");
    $("#btn4").empty().html("모든날짜형");
    _cateno4="305100";
    _cnt4=0;
    $('.filter_main li').removeClass('on').removeClass('selected'); // 텝 영역 css 제거
    $('#filter_sub1 input:checkbox:checked').each(function(){
        $(this).prop("checked", false);
    });
    $('#filter_sub2 input:checkbox:checked').each(function(){
        $(this).prop("checked", false);
    });
    $('#filter_sub3 input:checkbox:checked').each(function(){
        $(this).prop("checked", false);
    });
    $('#filter_sub4 input:checkbox:checked').each(function(){
        $(this).prop("checked", false);
    });
    $('#modal').hide();
    toggleScrolling();    
}

function fnSetFilter(){
    $('#modal').hide();
    toggleScrolling();
}
</script>