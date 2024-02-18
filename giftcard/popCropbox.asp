<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
	dim tmpUpFile
	tmpUpFile = staticImgUrl & "/giftcard/temp/" & Request("fnm")
%>
<link rel="stylesheet" type="text/css" href="/lib/css/jquery.cropbox.css" />
<script type="text/javascript" src="/lib/js/hammer.1.0.5.min.js"></script>
<script type="text/javascript" src="/lib/js/jquery.cropbox.min.js"></script>
<script type="text/javascript" defer>
$(function() {
	$('.cropimage').each(function() {
		var image = $(this),
		cropwidth = image.attr('cropwidth'),
		cropheight = image.attr('cropheight'),
		results = image.next('.results' ),
		x = $('.cropX', results),
		y = $('.cropY', results),
		w = $('.cropW', results),
		h = $('.cropH', results),
		download = results.next('.download').find('a');

		image.cropbox( {width: cropwidth, height: cropheight, showControls: 'auto' } )
		.on('cropbox', function( event, results, img ) {
			$("#fileCrpX").val(results.cropX);
			$("#fileCrpY").val(results.cropY);
			$("#fileCrpW").val(results.cropW);
			$("#fileCrpH").val(results.cropH);
		});
	});
});
</script>
<div class="layerPopup bgPink">
	<div class="container popWin">
		<div class="header">
			<h1>사진 등록</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="giftcardCropimage">
				<p class="instruction">드래그를 이용해 사진 영역을 지정해주세요</p>
				<div class="cropWrap">
					<img class="cropimage" src="<%=tmpUpFile%>?rv=<%=FormatDate(now,"00000000000000")%>" cropwidth="300" cropheight="182" alt="" />
				</div>

				<div class="floatingBar">
					<div class="btnWrap">
						<span onclick="fnCheckCropProc();" class="button btB1 btRed cWh1 w100p"><button type="button">등록하기</button></span>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>