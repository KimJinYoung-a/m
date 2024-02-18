/*
	## �̹��� �ѷ� �÷����� (��ư��)
	## 2012.08.09; ������ ����
	-----------------------------
	* ����
		<div id="banner"></div>
		<script type="text/javascript">
		$("#banner").imgRoller({iw:600, ih:400, bw:12, bh:12, bp:18, ibp:0, autostart:'true', speed:3000});
		</script>
	* ����
		- iw : �̹��� �ʺ�(px)
		- ih : �̹��� ����(px)
		- bw : ��ư �ʺ�(px)
		- bh : ��ư ����(px)
		- bp : ��ư�� ����(px)
		- ibp : �̹����� ��ư ����(px)
		- autostart : �ڵ��Ѹ� ����
		- speed : �ڵ��Ѹ��϶� �ѱ�� �ӵ�(ms)
*/
(function($) {
	var nowTab=0, tabTimeOut;
	$.fn.imgRoller = function(opts) {
		return this.each(function() {
			// �����Ҵ�
			var defaults = {iw:600, ih:400, bw:12, bh:12, bp:18, ibp:0, autostart:'true', speed:3000};
			var options = $.extend({}, defaults, opts);
			

			// ������ ������ �̹����� ��ư �迭�� �Ҵ�
			var arrImg = new Array(), arrBtn = new Array();

			$(this).find(".mainImage li").each(function() {
				arrImg.push($(this).html());
			});
			$(this).find(".btnImage li").each(function() {
				arrBtn.push($(this).html());
			});

			//������ �� �ۼ�
			$(this).hide();
			$(this).empty();
			$(this).width(options.iw);
			$(this).height(options.ih+options.ibp+options.bh);
			$(this).css("text-align","left");

			//�����̹���
			var sItem = '<div class="mainImage" style="height:'+options.ih+'px">';
			$(arrImg).each(function(k,v){
				sItem += '<div style="position:absolute;display:none;z-index:5;">'+v+'</div>';
			});
			sItem += '</div>';

			//��ư
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
			
			// ��ư Ȱ��
			$.rollBtnClick($(this),options);

			// ���ϸ��̼� Ȱ��
			$.startAutoRolling($(this),options.speed,options.autostart);
		});
	};

	//����ư Ŭ�� �̺�Ʈ
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

	//�̹��� �Ѹ�
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

	//�ڵ� �Ѹ�
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