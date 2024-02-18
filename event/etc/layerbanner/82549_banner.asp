<%
	If request.Cookies("evt82549")<>"x" then
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

function hideLayer82549(){
	$('#boxes').hide();
	$('#boxes .window').hide();
	$('#mask').hide();

    var todayDate = new Date('2017/12/03 23:59:59'); 
    document.cookie = "evt82549=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";" 
}
</script>
<div id="content" class="content">
	<div id="boxes">
		<div id="mask"></div>
		<div class="window">
			<div class="lyFrontBnr">
				<div class="lyCont">
					<a href="/event/eventmain.asp?eventid=82549&gaparam=today_layerbanner_82549"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82549/m/bnr_front.jpg" alt="주말특가 ~79%" /></a>
				</div>
				<div class="lyBtm">
					<div class="anymore"><input type="checkbox" id="closeToday" class="check" onclick="hideLayer82549();"/> <label for="closeToday">오늘 하루 보지 않기</label></div>
					<button type="button" class="lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75100/m/btn_close.png" alt="닫기" /></button>
				</div>
			</div>
		</div>
	</div>
</div>
<%
	End if
%>