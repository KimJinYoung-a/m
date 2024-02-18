<%
'///// 첫구매자에게 개인추천(YOU)이벤트 안내 배너 노출 (로그인 필수); 2017-09-08; 허진원 /////

If Date() >="2017-09-08" And  Date() <= "2017-12-31" Then 
If not( InStr(Request.ServerVariables("url"),"79281") > 0) Then '//이벤트 페이지 내에선 안뜸 그외엔 다뜸
If request.Cookies("evt79281")<>"x" then

'// 첫구매자 확인!!
dim sSql, chkFirstOrdUsr
chkFirstOrdUsr = false

If Trim(request.cookies("Evt79281FirstOrder")) = "1" Then
	If IsUserLoginOK Then
		chkFirstOrdUsr = True
	End If
End If

if chkFirstOrdUsr then
%>
<style type="text/css">
#boxes79281 {display:none;}
#mask79281 {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.5;}
.youBnr {position:absolute; left:50%; top:100px; z-index:100000; width:88%; margin-left:-44%;}
.youBnr .btnGroup {overflow:hidden; border-top:1px solid #dbdbdb; background:#fff;}
.youBnr .btnGroup button {display:block; float:left; width:50%; height:3.6rem; font-size:1.3rem; background:transparent;}
.youBnr .btnGroup button:first-child {color:#999; border-right:1px solid #dbdbdb;}
</style>
<script type="text/javascript">
$(function(){
	var maskHeight = $(document).height();
	var maskWidth =	$(window).width();
	$('#mask79281').css({'width':maskWidth,'height':maskHeight});
	$('#boxes79281').show();
	$('#mask79281').show();
	$('#boxes79281 .btnClose').click(function(e) {
		e.preventDefault();
		$('#boxes79281').hide();
		$('#boxes79281 .window').hide();
		var todayDate = new Date('2018/01/01 00:00:00'); 
		document.cookie = "evt79281=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";" 
	});
	$('#mask79281').click(function () {
		$('#boxes79281').hide();
		$('#boxes79281 .window').hide();
		var todayDate = new Date('2018/01/01 00:00:00'); 
		document.cookie = "evt79281=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";" 
	});
	$(window).resize(function () {
		var box = $('#boxes79281 .window');
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		$('#mask79281').css({'width':maskWidth,'height':maskHeight});

		var winH = $(window).height();
		var winW = $(window).width();
		box.css('top', winH/2 - box.height()/2);
		box.css('left', winW/2 - box.width()/2);
	});
});

function hideLayer79281(){
	$('#boxes79281').hide();
	$('#boxes79281 .window').hide();
	$('#mask').hide();

    var todayDate = new Date('2018/01/01 00:00:00'); 
    document.cookie = "evt79281=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";" 
}

function go79281Move()
{
    var todayDate = new Date('2018/01/01 00:00:00'); 
    document.cookie = "evt79281=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";" 
	top.location.href='/event/eventmain.asp?eventid=79281';
}

</script>
<div id="boxes79281">
	<div id="mask79281"></div>
	<div class="window">
		<div class="youBnr">
			<div class="naver">
				<a href="" onclick="go79281Move();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79281/m/txt_first.jpg" alt="텐바이텐에서의 첫 구매는 만족하셨나요?" /></a>
				<div class="btnGroup">
					<button type="button" class="btnNomore" onclick="hideLayer79281();">다시 보지 않기</button>
					<button type="button" class="btnClose">닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
<%
End If
End If
End If 
End If 
%>