<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vQuery, vCheck, vnCnt, nDate, vViewDate, vEvtCode, vimgFileName
	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21512"
	Else
		eCode = "60432"
	End If

	'// 실 서버 적용시 주석된거 풀어야됨
	nDate = Left(Now(), 10)
	'nDate = "2015-03-23"


	'// 해당 일자에 맞는 이벤트 메인 배너 리스트와 코드를 가져온다.
	vQuery = "select top 1 viewdate, evt_code, vote_item, img_fileName from [db_temp].dbo.tbl_wedding_temp where convert(varchar(10), viewdate, 120) = '"&nDate&"' "
	rsget.Open vQuery,dbget,1
	
	If Not(rsget.bof Or rsget.eof) Then
		vViewDate = rsget("viewdate")
		vEvtCode = rsget("evt_code")
		vimgFileName = rsget("img_fileName")
	Else
		vViewDate = "2015-03-23"
		vEvtCode = "60433"
		vimgFileName = "img_wedding_brand01"
	End If
	rsget.close()

%>
<html lang="ko">
<head>

<title>웨딩 기획전</title>
<style type="text/css">
.weddingM img {width:100%; vertical-align:top;}
.weddingM a.mw, .weddingM a.ma {display:none}
.weddingM .brandSale {position:relative;}
.weddingM .brandSale h2 {position:absolute; left:0; top:0; width:100%; z-index:30;}
.weddingM .brandSale .todayBrand {position:relative;}
.weddingM .brandSale .todayBrand a {position:absolute; left:5%; bottom:7%; width:90%; height:71%; color:transparent;}
.weddingM .weddingBanner {overflow:hidden; padding:8px 5px 0;}
.weddingM .weddingBanner li:first-child {padding-top:0;}
.weddingM .weddingBanner li {overflow:hidden; padding-top:10px;}
@media all and (min-width:480px){
	.weddingM .weddingBanner {overflow:hidden; padding:8px 7px 0;}
	.weddingM .weddingBanner li {overflow:hidden; padding-top:7px;}
}
</style>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<% if isApp=1 then %>
	<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<script type="text/javascript">
	$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$('a.ma').css('display','block');
		}else{
			$('a.mw').css('display','block');
		}
	});

	function goWdTag(grp) {
		$("#iframe_60446").attr("src","/event/etc/inc_60446.asp?eGC="+grp);
	}
</script>
</head>
<body>
<div class="evtCont">
	<%' 2015 웨딩기획전 (M/APP) %>
	<div class="mEvt60432">
		<div class="weddingM">
			<div class="brandSale tPad10">
				<!--
				<h2>
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupEvent('60445'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/tit_wedding_brand_sale.png" alt="WEDDING♥BRAND SALE" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=60445" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/tit_wedding_brand_sale.png" alt="WEDDING♥BRAND SALE" /></a>
					<% End If %>
				</h2>
				-->
				<div class="todayBrand">
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupEvent('<%=vEvtCode%>'); return false;" class="ma">브랜드 할인 바로가기</a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=<%=vEvtCode%>" class="mw" target="_top">브랜드 할인 바로가기</a>
					<% End If %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/<%=vimgFileName%>.png" alt="" /><%' 일별 변경 브랜드별 이미지명 01~15 %></p>
				</div>
			</div>
			<ul class="weddingBanner">
				<li>

					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupEvent('60440'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_make_sweet_home.jpg" alt="" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=60440" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_make_sweet_home.jpg" alt="" /></a>
					<% End If %>
				</li>
				<li>
					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupEvent('60442'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_romantic_wedding.jpg" alt="" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=60442" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_romantic_wedding.jpg" alt="" /></a>
					<% End If %>
				</li>
				<li>
					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupEvent('60443'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_home_party.jpg" alt="" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=60443" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_home_party.jpg" alt="" /></a>
					<% End If %>
				</li>
				<li>
					<p class="ftLt w50p">
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupEvent('60444'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_interior_clean_up.jpg" alt="" /></a>
						<% Else %>
							<a href="/event/eventmain.asp?eventid=60444" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_interior_clean_up.jpg" alt="" /></a>
						<% End If %>
					</p>
					<p class="ftRt w50p">
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupEvent('60445'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_brand_sale.jpg" alt="" /></a>
						<% Else %>
							<a href="/event/eventmain.asp?eventid=60445" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_brand_sale.jpg" alt="" /></a>
						<% End If %>
					</p>
				</li>
			</ul>
			<div>
				<%' 태그 별 추천상품 (iframe영역) %>
					<iframe id="iframe_60446" src="/event/etc/inc_60446.asp" width="100%" height="300px" frameborder="0" scrolling="no" class="autoheight" onload="resizeIfr(this, 10)"></iframe>
				<%'// 태그 별 추천상품 (iframe영역) %>
			</div>

			<ul class="weddingBanner" style="padding-top:15px; margin-top:20px; border-top:1px solid #d2d2d2;">
				<li>
					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupEvent('60389'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_go_wish.jpg" alt="" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=60389" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60432/bnr_go_wish.jpg" alt="" /></a>
					<% End If %>
				</li>
			</ul>
		</div>
	</div>
	<%'// 2015 웨딩기획전 (M/APP) %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->