<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim ckUserID : ckUserID = getEncLoginUserID
	dim notice, importantNoticeSplit
	If Trim(fnGetImportantNotice) <> "" Then
		importantNoticeSplit = split(fnGetImportantNotice,"|||||")
	End If
	dim logStore : logStore = requestCheckVar(Request("store"),16)
%>

<script>
$(function() {
	// 사이드 메뉴 (aside_wrap)
	var noticeFlag = $('.notice_item').width() < $('.notice_item .txt').width();
	$('.header_opener').on('click', function() {
		$('body').addClass('aside_on');
		if (noticeFlag)	$('.notice_item .txt').addClass('mq');
	});
	$('.header_closer, .aside_dim').on('click', function() {
		$('body').removeClass('aside_on');
		$('.notice_item .txt').removeClass('mq');
	});
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	}
};
</script>
<!-- 모바일 헤더 (header_wrap) -->
<div id="header" class="header_wrap">
	<header class="tenten_header header_main">
		<div class="header_inner">
			<button type="button" class="header_opener"><span class="blind">메뉴 열기</span></button>
			<h1 class="header_logo"><a href="/"><span class="blind">텐바이텐</span></a></h1>
			<div class="util">
				<a href="/search/search_entry2020.asp" class="btn_search"><i class="i_magnify"></i><span class="blind">검색</span></a>
				<a href="<%=wwwUrl%>/inipay/ShoppingBag.asp" class="btn-shoppingbag">
					<span class="blind">장바구니</span><i class="i_bag"></i>
					<% If GetCartCount > 0 Then %>
						<span class="badge"><%= GetCartCount %><%=chkiif(GetCartCount > 99,"+","")%></span>
					<% End If %>
				</a>
			</div>
		</div>
	</header>
</div>
<!-- 사이드 메뉴 (aside_wrap) -->
<aside class="aside_wrap">
	<div class="aside_dim"></div>
	<div class="aside_inner">
		<div class="aside_header">
			<button type="button" class="header_closer"><i class="i_close"></i><span class="blind">메뉴 닫기</span></button>
		</div>
		<nav class="aside_nav">
			<ul class="depth1">
				<li><a href="/">텐바이텐 홈</a></li>
				<li><a href="/category/category_main2020.asp?disp=102">카테고리</a></li>
				<li><a href="/my10x10/mymain.asp">마이텐바이텐</a></li>
				<li><a href="/my10x10/order/myorderlist.asp">주문조회</a></li>
				<li><a href="/my10x10/myrecentview.asp">히스토리</a></li>
				<li><a href="/cscenter/">고객행복센터</a></li>
			</ul>
		</nav>
		<% If (Trim(fnGetImportantNotice) <> "") Then %>
			<div class="aside_notice">
				<article class="notice_item">
					<span class="txt"><%=importantNoticeSplit(1)%></span>
					<a href="/common/news/news_view.asp?idx=<%=importantNoticeSplit(0)%>" class="notice_link"><span class="blind">공지사항 바로가기</span></a>
				</article>
			</div>
		<% End If %>
		<div class="aside_footer">
			<ul class="aside_user">
				<% If (ckUserID<>"") Then %>
				<li><a onclick="cfmLoginout();return false;">로그아웃</a></li>
				<% Else %>
				<li><a href="/login/login.asp">로그인</a></li>
				<li><a href="/member/join.asp">회원가입</a></li>
				<% End If %>
			</ul>
			<a href="" class="aside_install">
				<figure class="ico"></figure>
				<span onclick="gotoDownload(); return false;" class="txt">APP 다운로드<i class="i_arw_r1"></i></span>
			</a>
		</div>
	</div>
</aside>
<!-- #include virtual="/lib/db/dbclose.asp" -->