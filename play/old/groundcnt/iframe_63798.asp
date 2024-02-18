<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
Dim eCode, userid, vQuery, vIDX, vContentsIDX
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "63791"
	vIDX	= "20"
	vContentsIDX	= "1077"
Else
	eCode   =  "63798"
	vIDX	= "21"
	vContentsIDX	= "88"
End If

userid = getloginuserid()

Dim strSql, enterCnt, sakuraCnt, overseasCnt, i, totalCnt

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		enterCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totalCnt = rsget(0)
	End IF
	rsget.close

	i = 0

%>
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">
img {vertical-align:top;}
.swiper {position:relative; overflow:hidden;}
.swiper .swiper-container {width:100%;}
.swiper .swiper-slide {overflow:hidden;}
.swiper .swiper-slide p {position:absolute; left:0; top:10px; opacity:0; width:100%;}
.swiper .numbering {position:absolute; left:0; bottom:7%; width:100%; text-align:center;}
.swiper .numbering span {display:inline-block; width:8px; height:8px; margin:0 8px; border:1px solid #000; border-radius:50%;}
.swiper .numbering span.swiper-active-switch {background:#000;}
.purpose {position:relative;}
.purpose .goLaundry {position:absolute; left:30%; bottom:11%; width:40%; height:31%; color:transparent;}
.applyPackage {position:relative;}
.applyPackage .goLaundry {position:absolute; left:14%; bottom:11%; width:72%; height:19%; color:transparent;}
.laundryList {padding-bottom:42px; background:#fff;}
.laundryList .total {text-align:center; padding:28px 0; color:#c80000; font-size:15px;}
.laundryList .total strong {display:inline-block; position:relative; top:2px; color:#000; font-size:22px; padding:0 3px;}
.laundryList ul {overflow:hidden; width:100%; padding:0 7px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150622/bg_line.gif) 0 2.5% repeat-x; background-size:100% 2px;}
.laundryList li {position:relative; float:left; width:33%; padding:0 2px;}
.laundryList li div {text-align:center; color:#000; font-size:11px; background-position:0 0; background-repeat:no-repeat; background-size:100% 100%;}
.laundryList li.s01 div {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150622/bg_shirt01.png)}
.laundryList li.s02 div {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150622/bg_shirt02.png)}
.laundryList li.s03 div {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150622/bg_shirt03.png)}
.laundryList li p.num {position:absolute; left:0; top:35%; width:100%;}
.laundryList li p.writer {position:absolute; left:0; top:52%; width:100%; font-weight:500; letter-spacing:-0.025em;}
.laundryList li p.writer strong {display:block; color:#d32a2a; padding-bottom:3px;}
.brandStory {position:relative;}
.brandStory a {display:block; position:absolute; bottom:11%; width:37%; height:7%; color:transparent;}
.brandStory a.goPdt01 {left:9%;}
.brandStory a.goPdt02 {right:9%;}
@media all and (min-width:480px){
	.swiper .swiper-slide p {top:15px;}
	.swiper .numbering span {width:12px; height:12px; margin:0 12px;}
	.laundryList {padding-bottom:63px;}
	.laundryList .total {padding:42px 0; font-size:23px;}
	.laundryList .total strong {top:3px; font-size:33px; padding:0 4px;}
	.laundryList ul { padding:0 11px;}
	.laundryList li {padding:0 4px;}
	.laundryList li div {font-size:16px;}
}
</style>
<script type="text/javascript">
function jsSubmit(){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround_review.asp?idx="&vIDX&"&contentsidx="&vContentsIDX&"")%>');
			return false;
		<% end if %>
	<% end if %>
	var rstStr = $.ajax({
		type: "POST",
		url: "/play/groundcnt/doEventSubscript63798.asp",
		dataType: "text",
		async: false
	}).responseText;
	if (rstStr!=""){
		var enterCnt;
		var strArray;
		strArray = rstStr.split('!/!');

		if (strArray[0]=="01")
		{
			$("#uCnt").empty().html(strArray[1]);
			$("#uCleaning").empty();
			$("#uCleaning").html(""+strArray[2]+"");
			var randomMan = [ 's01', 's02', 's03'];
			var manSort = randomMan.sort(function(){
				return Math.random() - Math.random();
			});
			$('.laundryList li').each( function(index,item){
				$(this).addClass(manSort[index]);
			});
			return false;
		}
		else
		{
			alert(strArray[1]);
			return false;
		}
	}else{
		alert('관리자에게 문의');
		return false;
	}
}

$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.numbering',
		speed:600,
		autoplay:false
	});

	$(".goLaundry").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
	var randomMan = [ 's01', 's02', 's03'];
	var manSort = randomMan.sort(function(){
		return Math.random() - Math.random();
	});
	$('.laundryList li').each( function(index,item){
		$(this).addClass(manSort[index]);
	});
});

</script>
</head>
<body>

		<div class="mPlay20150622">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/tit_play_laundry.jpg" alt="PLAY LAUNDRY" /></h2>
			<div class="purpose">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20150622/txt_laundry.gif" alt="텐바이텐과 LG생활건강이 함께하는 즐거운 세탁소!" />
				<a href="#applyPackage" class="goLaundry">빨래하러 가기</a>
			</div>
			<div class="interview">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/txt_interview01.gif" alt="빨래는 해도 해도 부족하다" /></p>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/txt_interview02.gif" alt="빨래는 어렵다" /></p>
			</div>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/txt_package.gif" alt="고객행복우선세탁소 ‘PLAY LAUNDRY’가 빨래로 인해 지친 마음의 소리에 귀 기울이고, 모든 엄마들의 마음과 유행어를 연구한 끝에 탄생한 맞춤 PACKAGE" /></p>
			<div>
				<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/tit_package.gif" alt="내가 못살아 진짜 PACKAGE" /></h3>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_composition.gif" alt="패키지 구성" /></div>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_package.gif" alt="패키지 이미지" /></div>
			</div>
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_slide01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_slide02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_slide03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_slide04.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_slide05.jpg" alt="" /></div>
					</div>
				</div>
				<div class="numbering"></div>
			</div>

			<%' 패키지 신청하기 %>
			<div class="applyPackage" id="applyPackage">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/txt_event.jpg" alt="" /></p>
				<a href="#laundryList" onclick="jsSubmit();return false;" class="goLaundry">빨래하기</a>
			</div>
			<div class="laundryList" id="laundryList">
				<p class="total">지금까지 <strong><span id="uCnt"><%=enterCnt%></span></strong>명이 빨래를 신청하셨습니다.</p>
				<ul id="uCleaning">
					<%
						vQuery = " Select top 3 * From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' order by sub_idx desc "
						rsget.Open vQuery,dbget,1
						IF Not rsget.Eof Then
							Do Until rsget.eof
					%>
						<li>
							<div>
								<p class="num">NO.<% If i = 0 Then response.write totalCnt Else response.write totalCnt - i%></p>
								<p class="writer"><%' 아이디는 12자까지 노출되게 해주세요(**포함) %><strong><%=chrbyte(printUserId(rsget("userid"),2,"*"),12,"N")%></strong>님의 빨래</p>
								<p class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/bg_blank.png" alt="" /></p>
							</div>
						</li>
					<%
							rsget.movenext
							i = i + 1
							Loop
						End IF
						rsget.close
					%>
				</ul>
			</div>
			<%'// 패키지 신청하기 %>
			<div class="brandStory">
				<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/tit_brand_story.gif" alt="BRAND STORY" /></h3>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150622/txt_lg_care.gif" alt="LG생활건강 - 고객의 아름다움과 꿈을 실현하는 최고의 생활문화 기업" /></p>
				<div>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20150622/img_lg_product_v2.jpg" alt="LG생활건강 - 고객의 아름다움과 꿈을 실현하는 최고의 생활문화 기업" />
					<% If isApp=1 Then %>
						<a href="" onclick="openbrowser('http://www.beliving.co.kr/web/product/productList.jsp?cate=PD0100&brand=PD0101');return false;" class="goPdt01">테크</a>
						<a href="" onclick="openbrowser('http://www.beliving.co.kr/web/product/productList.jsp?cate=PD0200&brand=PD0201');return false;" class="goPdt02">샤프란</a>
					<% Else %>
						<a href="http://www.beliving.co.kr/web/product/productList.jsp?cate=PD0100&brand=PD0101" class="goPdt01" target="_blank">테크</a>
						<a href="http://www.beliving.co.kr/web/product/productList.jsp?cate=PD0200&brand=PD0201" class="goPdt02" target="_blank">샤프란</a>
					<% End If %>
				</div>
			</div>
		</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->