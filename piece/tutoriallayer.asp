<%'// Piece 튜토리얼 %>
<%
	If request.Cookies("piecetutorial")<>"x" then
%>
<style type="text/css">
#boxes {display:block;}
#mask {display:block; position:fixed; left:0; top:0; bottom:0; width:100%; height:100%; z-index:900; background-color:#000; opacity:0.7;}
<% if isapp = "1" then %>
.piece-start {margin:-14.5rem 0 0 -12.375rem;}
<% end if %>
</style>
<script>
function fnhideLayerPiece(){
	$("#boxes").hide();
	$('#mask').hide();

    var todayDate = new Date('2222/01/01 23:59:59');
    document.cookie = "piecetutorial=x; path=/; domain=10x10.co.kr; expires=" + todayDate.toGMTString() + ";"
}
</script>
<div id="boxes" onclick="fnhideLayerPiece();">
	<div id="mask"></div>
	<div class="window">
		<div class="piece-start">
			<div class="lyCont">
				<dl>
					<dt>
						<p class="headline">텐바이텐의</p>
						<p class="iam">Masterpiece<span>,<span></p>
						<p class="headline">바로 여기에</p>
					</dt>
					<dd class="tMar1-8r">조각(Piece)은 텐바이텐에 숨어있는 <br />마스터피스를 한 조각, 한 조각씩 <br />소개해주는 <strong class="cBk1">상품 추천 서비스</strong>입니다.</dd>
					<dd>매일 꾸준히 업데이트 되는 <br />텐바이텐의 마스터피스들을 만나세요!</dd>
					<dd class="btn-start"><button type="button" onclick="fnhideLayerPiece();">시작하기</button></dd>
				</dl>
				<img src="http://fiximage.10x10.co.kr/m/2018/piece/bg_tutorial.jpg" srcset="http://fiximage.10x10.co.kr/m/2018/piece/bg_tutorial@2x.jpg 2x, http://fiximage.10x10.co.kr/m/2018/piece/bg_tutorial@3x.jpg 3x" alt="" />
			</div>
		</div>
	</div>
</div>
<%'// Piece 튜토리얼 %>
<% End If %>
