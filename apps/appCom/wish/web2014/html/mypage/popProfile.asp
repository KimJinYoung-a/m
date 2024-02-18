<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.profileList li').click(function(){
		$('.profileList li').find('em').hide();
		$(this).find('em').show();
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>프로필 이미지</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="profileImage">
				<p class="tip">원하는 프로필 이미지를 선택해 주세요.<br />프로필 이미지는 언제든지 변경이 가능합니다.</p>
				<ul class="profileList">
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member01.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member02.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member03.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member04.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member05.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member06.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member07.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member08.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member09.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member10.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member11.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member12.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member13.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member14.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member15.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member16.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member17.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member18.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member19.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member20.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member21.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member22.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member23.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member24.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member25.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member26.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member27.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member28.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member29.png" alt="" /></p></li>
					<li><p><em></em><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member30.png" alt="" /></p></li>
				</ul>
			</div>
		</div>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" value="저장" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>