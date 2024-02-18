<%
If request("itemid") <> "" Then
	Dim nvitemid 
	nvitemid  = "?backpath="&Server.URLEncode("/category/category_itemPrd.asp?itemid=")&request("itemid")
End If
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
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/naver/common/txt_naver_shopping_mo.png" alt="네이버 전용 텐바이텐 할인쿠폰! 텐바이텐 COUPON 3,000원 3만원 이상 구매 시" /></p>
				<p>2018. 01. 01 ~ 01. 07까지 사용가능<br /> 일부 상품 제외 <span class="symbol">|</span> 중복발행 불가</p>
				<div class="btnArea">
				<% If IsUserLoginOK() Then %>
					<span class="button btB1 btRed cWh1" onclick="hideLayer('lg', '')"><em>쿠폰 다운받기</em></span>
				<% Else %>
					<span class="button btB1 btRed cWh1" onclick="hideLayer('one', '/login/login.asp<%=nvitemid%>')"><em>쿠폰 다운받기</em></span>
				<% End If %>
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
