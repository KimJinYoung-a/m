<%
If Date() >="2016-12-20" And  Date() <= "2016-12-21" Then 
If InStr(Request.ServerVariables("url"),"75100") > 0 Then '//이벤트 페이지 내에선 안뜸 그외엔 다뜸
else
If request.Cookies("evt75100")("mode") <> "x" then
	if InStr(request.ServerVariables("HTTP_REFERER"),"10x10.co.kr")<1 then
%>
<style type="text/css">
.window {display:none;}
#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.7;}
.lyFrontBnr {position:absolute; left:50%; top:100px; z-index:100000; width:90%; margin-left:-45%;}
.lyFrontBnr .lyBtm {position:relative; padding:1rem 1.5rem; background:#f2f2f2;}
.lyFrontBnr .lyBtm .lyrClose {position:absolute; right:4%; top:1rem; width:5.3%;}
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

function hideLayer11(due, ref){
	if(ref != ""){
		document.getElementById('boxes').style.display = "none";
		document.getElementById('due').value = due;
		document.getElementById('gourl').value = ref;
		document.evtfrm.action = '/common/Cookie_process.asp';
		document.evtfrm.target = 'view';
		document.evtfrm.submit();
	}else{
		document.getElementById('boxes').style.display = "none";
		document.getElementById('due').value = due;
		document.getElementById('gourl').value = "";
		document.evtfrm.action = '/common/Cookie_process.asp';
		document.evtfrm.target = 'view';
		document.evtfrm.submit();
	}
}
</script>
<%' 산타쿠폰 전면배너 %>
<div id="boxes">
	<div id="mask"></div>
	<div class="window">
		<div class="lyFrontBnr">
			<div class="lyCont">
				<a href="/event/eventmain.asp?eventid=75100"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75100/m/bnr_front_m.jpg" alt="해피산타쿠폰 이벤트 참여하기"/></a>
			</div>
			<div class="lyBtm">
				<div class="anymore"><input type="checkbox" id="closeToday" class="check" onclick="hideLayer11('one', '');"/> <label for="closeToday">다시 보지 않기</label></div>
				<button type="button" class="lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75100/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
	</div>
</div>
<iframe name="view" id="view" frameborder="0" width="0" height="0" style="display:block;"></iframe>
<form name="evtfrm" method="post" style="margin:0px; display:inline;">
	<input type="hidden" id="due" name="due">
	<input type="hidden" id="gourl" name="gourl">
</form>
<%' //산타쿠폰 전면배너 %>
<%
	End If 
End If
End If 
End If 
%>