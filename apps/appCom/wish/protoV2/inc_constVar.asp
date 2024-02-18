<%
	'// 기본 상수 정의 //

	'// Domain
	Dim mDomain, webImgUrl, staticImgUrl
	IF application("Svr_Info")="Dev" THEN
		mDomain = "http://testm.10x10.co.kr"
		webImgUrl = "http://testwebimage.10x10.co.kr"
		staticImgUrl = "http://testimgstatic.10x10.co.kr"
	else
		mDomain = "http://m.10x10.co.kr"
		webImgUrl = "http://webimage.10x10.co.kr"
		staticImgUrl = "http://imgstatic.10x10.co.kr"
	end if

	'// WebView URL
	Dim cstItemPrdUrl:		cstItemPrdUrl = mDomain & "/apps/appCom/wish/web2014/category/category_itemPrd.asp"
	Dim cstBadgeInfoUrl:	cstBadgeInfoUrl = mDomain & "/apps/appCom/wish/web2014/my10x10/badge/badgeInfo.asp"
%>