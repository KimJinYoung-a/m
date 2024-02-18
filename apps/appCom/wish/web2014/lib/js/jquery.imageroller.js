/*
	## 이미지 롤러 플러그인 (버튼식)
	## 2012.08.09; 허진원 생성
	-----------------------------
	* 사용법
		<div id="banner"></div>
		<script type="text/javascript">
		$("#banner").imgRoller({iw:600, ih:400, bw:12, bh:12, bp:18, ibp:0, autostart:'true', speed:3000});
		</script>
	* 변수
		- iw : 이미지 너비(px)
		- ih : 이미지 높이(px)
		- bw : 버튼 너비(px)
		- bh : 버튼 높이(px)
		- bp : 버튼간 간격(px)
		- ibp : 이미지와 버튼 간격(px)
		- autostart : 자동롤링 여부
		- speed : 자동롤링일때 넘기는 속도(ms)
*/
(function($) {
	var nowTab=0, tabTimeOut;
	$.fn.imgRoller = function(opts) {
		return this.each(function() {
			// 변수할당
			var defaults = {iw:600, ih:400, bw:12, bh:12, bp:18, ibp:0, autostart:'true', speed:3000};
			var options = $.extend({}, defaults, opts);
			

			// 지정된 폼에서 이미지와 버튼 배열에 할당
			var arrImg = new Array(), arrBtn = new Array();

			$(this).find(".mainImage li").each(function() {
				arrImg.push($(this).html());
			});
			$(this).find(".btnImage li").each(function() {
				arrBtn.push($(this).html());
			});

			//지정된 폼 작성
			$(this).hide();
			$(this).empty();
			$(this).width(options.iw);
			$(this).height(options.ih+options.ibp+options.bh);
			$(this).css("text-align","left");

			//메인이미지
			var sItem = '<div class="mainImage" style="height:'+options.ih+'px">';
			$(arrImg).each(function(k,v){
				sItem += '<div style="position:absolute;display:none;z-index:5;">'+v+'</div>';
			});
			sItem += '</div>';

			//버튼
			var ic=0;
			sItem += '<div class="btnImage" style="text-align:center;padding-top:'+options.ibp+'px;">';
			$(arrBtn).each(function(k,v){
				sItem += '<span style="diaplay:table; display:inline-block; width:'+options.bw+'px; padding-left:'+(options.bp/2)+'px; padding-right:'+(options.bp/2)+'px;" label="'+ic+'">'+v+'</span>';
				ic++;
			});
			sItem += '</div>';

			$(this).html(sItem);
			$(this).find('.btnImage span').children('img').css('opacity', '0.2');
			$(this).show();
			
			// 버튼 활성
			$.rollBtnClick($(this),options);

			// 에니메이션 활성
			$.startAutoRolling($(this),options.speed,options.autostart);
		});
	};

	//각버튼 클릭 이벤트
	$.rollBtnClick = function(fp,opt) {
		$(fp).find('.btnImage span').children('img').each(function() {
			$(this).css('cursor', 'pointer');
			$(this).click(function() {
				nowTab = $(this).parent().attr("label");
				if(opt.autostart=="true") {
					clearTimeout(tabTimeOut);
					tabTimeOut = setTimeout(function(){
						$.startAutoRolling(fp,opt.speed,opt.autostart);
					},opt.autostart);
				} else {
					$.imgRolling(fp,nowTab);
				}
			});
		});
	};

	//이미지 롤링
	$.imgRolling = function(fp,idx) {
		$(fp).find('.mainImage').children('div').eq(idx).css("z-index",10).fadeIn("slow",function(){
			$(fp).find('.mainImage').children('div').each(function(){
				if($(this).css("z-index")!=10) {
					$(this).hide();
				}
				$(this).css("z-index",5);
			});
		});
		$(fp).find('.btnImage span').children('img').each(function(){
			$(this).css('opacity','0.2');
		});
		$(fp).find('.btnImage span').children('img').eq(idx).css('opacity','1.0');
	};

	//자동 롤링
	$.startAutoRolling = function(fp,sp,auto) {
		if(nowTab>=$(fp).find('.mainImage').children('div').length) nowTab=0;
		$.imgRolling(fp,nowTab);
		if(auto=="true") {
			tabTimeOut = setTimeout(function(){
				$.startAutoRolling(fp,sp,auto);
			},sp);
		}
		nowTab++;
	};

})(jQuery);