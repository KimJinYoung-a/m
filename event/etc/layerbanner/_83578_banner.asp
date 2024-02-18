<%
	If request.Cookies("evt83578")<>"x" then
%>
<style type="text/css">
.window {display:none;}
#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.7;}
.lyFrontBnr {position:absolute; left:50%; top:100px; z-index:100000; width:90%; margin-left:-45%;}
.lyFrontBnr .lyBtm {position:relative; padding:1rem 1.5rem; background:#f2f2f2;}
.lyFrontBnr .lyBtm .lyrClose {position:absolute; right:4%; top:1rem; width:5.3%; background-color:transparent;}
.lyFrontBnr .lyBtm .anymore label {padding-left:0.5rem; color:#616161; font-size:1.3rem; font-weight:bold; vertical-align:middle;}
</style>
<script type="text/javascript">
$(function(){
	var maskHeight = $(document).height();
	var maskWidth =	$(window).width();
	$('#mask').css({'width':maskWidth,'height':maskHeight});
	$('#boxes').show();
	$('#mask').show();
	$('.window').show();
	$('.lyrClose').click(function(e) {
		e.preventDefault();
		$('#boxes').hide();
		$('.window').hide();
	});
	$('#mask').click(function () {
		$('#boxes').hide();
		$('.window').hide();
	});
	$(window).resize(function () {
		var box = $('#boxes .window');
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		$('#mask').css({'width':maskWidth,'height':maskHeight});

		var winH = $(window).height();
		var winW = $(window).width();
		box.css('top', winH/2 - box.height()/2);
		box.css('left', winW/2 - box.width()/2);
	});
});

function hideLayer83578(){
	$('#boxes').hide();
	$('#boxes .window').hide();
	$('#mask').hide();

    var todayDate = new Date('2018/01/16 23:59:59'); 
    document.cookie = "evt83578=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";" 
}
</script>
<div id="content" class="content">
	<div id="boxes">
		<div id="mask"></div>
		<div class="window">
			<div class="lyFrontBnr">
				<div class="lyCont">
					<a href="/event/eventmain.asp?eventid=83578&gaparam=today_layerbanner_83578"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/bnr_front_m.jpg" alt="레드 썬! 데이 단 2일! 마법에 걸린 특급세일 이벤트 자세히 보기" /></a>
				</div>
				<div class="lyBtm">
					<div class="anymore"><input type="checkbox" id="closeToday" class="check"  onclick="hideLayer83578();"/> <label for="closeToday">다시보지 않기</label></div>
					<button type="button" class="lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75100/m/btn_close.png" alt="닫기" /></button>
				</div>
			</div>
		</div>
	</div>
</div>
<%
	End if
%>