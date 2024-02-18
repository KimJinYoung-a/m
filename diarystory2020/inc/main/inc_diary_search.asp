<script>
$(function() {
	$(".filter ul li input:checkbox").on("click", function(){
        $(this).next().toggleClass("on");
	});
});
function test(){
    console.log(getSearchParam())
    // console.log($('input:checkbox[id="optS1-1"]').is(':checked'))
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
function linkToSearch(){		
	var link = "/diarystory2020/search.asp?attr=" + getSearchParam().att + "&col=" + getSearchParam().color
	// console.log(link)
	<% if isapp > 0 then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 검색', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + link)
	<% else %>
	window.document.location.href = link
	<% end if %>
}
</script>
		<section class="diary-finder" id="diaryNav3">
			<div class="diary-nav">
				<ul>
					<li><a href="#diaryNav1">추천 문구템</a></li>
					<li><a href="#diaryNav2">기획전</a></li>
					<li class="on"><a href="#diaryNav3">다이어리 찾기</a></li>
				</ul>
			</div>
			<div class="all-diary">
				<span><img src="//fiximage.10x10.co.kr/m/2019/diary2020/img_search.png" alt="Diary All day"></span>
				<a href="javascript:linkToSearch()" class="btn-block">다이어리 모두 보기</a>
			</div>
			<!-- 다이어리 필터 -->
			<div class="filter-list main-filter">
				<div class="inner">
					<div>
						<p class="tit">내가 원하는 다이어리 찾기</p>
						<p class="sub">디자인을 선택 후 아래의 ‘찾기’ 버튼을 눌러주세요. </p>
					</div>
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
				<a href="javascript:void(0)" onclick="linkToSearch()" class="btn-block">다이어리 찾기</a>
			</div>
		</section>