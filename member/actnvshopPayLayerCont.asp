<%
If isNaverOpen AND (Left(request.Cookies("rdsite"), 13) = "mobile_nvshop") AND (request.Cookies("nvshop")("mode") = "o") Then
%>
<style type="text/css">
.window {display:none;}
#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.5;}
.lyNaver {position:absolute; left:50%; top:100px; z-index:100000; width:280px; margin-left:-140px; background-color:#fff;}
.lyNaver p {color:#888; font-size:12px; line-height:1.438em; font-weight:bold;}
.lyNaver img {width:100%; vertical-align:top;}
.lyNaver .naver {position:relative; padding:38px 0 67px; text-align:center;}
.lyNaver .naver .symbol {display:inline-block; padding:0 4px; font-size:11px;}
.lyNaver .naver .close {position:absolute; left:0; top:0; width:100%; padding:10px 0; background-color:#c40000; text-align:right;}
.lyNaver .naver .close .lyrClose {width:20px; height:20px; margin-right:13px; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/naver/common/btn_close_mo.png) 0 0 no-repeat; background-size:100% 100%; text-indent:-999em; cursor:pointer;}
.lyNaver .naver .btnArea {padding-top:20px;}
.lyNaver .naver .btnArea .button {width:60%; text-align:center;}
.lyNaver .naver .btnArea .button a {padding-right:0; padding-left:0; text-align:center;}
.lyNaver .naver .btnArea .button a em {padding-right:15px; background:transparent url(http://fiximage.10x10.co.kr/m/2014/common/blt_arrow_rt5.png) right 50% no-repeat; background-size:7px 12px;}
.lyNaver .naver .anymore {position:absolute; left:0; bottom:0; width:100%; padding:9px 0 8px; background-color:#ececec; color:#777; font-size:12px; font-weight:bold; text-align:right;}
.lyNaver .naver .anymore input {vertical-align:top;}
.lyNaver .naver .anymore label {padding:0 15px 0 2px; vertical-align:-4px;}
@media all and (min-width:480px){
	.lyNaver {width:360px; margin-left:-180px;}
	.lyNaver p {font-size:16px;}
	.lyNaver .naver .symbol {font-size:14px;}
	.lyNaver .naver .anymore {font-size:15px; line-height:1.438em;}
}
</style>
<script type="text/javascript">
function hideLayer(due, ref){
	if(ref != ""){
		document.getElementById('boxes').style.display = "none";
		document.getElementById('due').value = due;
		document.getElementById('gourl').value = ref;
		document.nvfrm.action = '/member/nvshopCookie_process.asp';
		document.nvfrm.target = 'view';
		document.nvfrm.submit();
	}else{
		document.getElementById('boxes').style.display = "none";
		document.getElementById('due').value = due;
		document.getElementById('gourl').value = "";
		document.nvfrm.action = '/member/nvshopCookie_process.asp';
		document.nvfrm.target = 'view';
		document.nvfrm.submit();
	}
}
</script>
<div id="boxes">
	<div id="mask"></div>
	<div class="window">
		<div class="lyNaver">
			<div class="naver">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/naver/0808/txt_naver_pay_mo.png" alt="텐바이텐에서 네이버페이로 첫 결제 시 네이버 포인트 2,000 포인트 적립!" /></p>
				<p>이벤트 기간 : 2016년 08월 12일 ~ 08월 25일<br /> 1인당 기간 내 1회에 한하여 적용</p>
				<div class="btnArea">
					<%' for dev msg : N-pay OPEN EVENT! 이벤트로 연결 / 이벤트 코드 72336 %>
					<span class="button btB1 btRed cWh1"><a href="/event/eventmain.asp?eventid=72336" title="네이버페이 오픈 이벤트로 이동"><em>이벤트 자세히 보기</em></a></span>
				</div>
				<div class="close"><button type="button" class="lyrClose">닫기</button></div>
				<div class="anymore"><input type="checkbox" id="todayNomore" class="check" onclick="hideLayer('one', '');" /> <label for="todayNomore">오늘 하루 그만 보기</label></div>
			</div>
		</div>
	</div>
</div>
<iframe name="view" id="view" frameborder="0" width="0" height="0" style="display:block;"></iframe>
<form name="nvfrm" method="post" style="margin:0px; display:inline;">
	<input type="hidden" id="due" name="due">
	<input type="hidden" id="gourl" name="gourl">
</form>
<% End If %>
