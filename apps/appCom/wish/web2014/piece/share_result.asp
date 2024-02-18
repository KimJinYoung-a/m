<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/piece/piececls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
'####################################################
' Description :  피스 SHARE-RESULT
' History : 2017-09-21 이종화
'####################################################
Dim cPs , t , p , vItemID , vBasicimage , vWishArr
Dim idx : idx = getNumeric(requestCheckVar(request("idx"),5))
Dim vLinkItemID
Dim vAdminID
Dim piecepop : piecepop = "on"
Dim RvSelPiece

If Isnull(idx) Or idx = "" Then 
	Call Alert_Return("잘못된 접근 입니다.")
	response.End
End If 

	SET cPs = New Cgetpiece
	cPs.FRectIdx = idx
	cPs.getPieceview()

	If cPs.FOnePiece.Fitemid <> "" then
		vLinkItemID = Split(cPs.FOnePiece.Fitemid,",")(0)
	End If 
%>
<!-- #include virtual="/apps/appcom/wish/web2014/lib/head.asp" -->

<script type="text/javascript">
<!-- #include file="./index_javascript.asp" -->
</script>
</head>
<body class="default-font body-poup piece bg-black">
	<div id="content" class="content bg-black">
		<%'!-- piece : 오늘의 조각 --%>
		<section class="a-piece">
			<div class="topic">
				<div class="thumbnail"><span class="inner"><a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=<%=vLinkItemID%>&gaparam=piece_main');return false;"><img src="<%=cPs.FOnePiece.Flistimg%>" alt="" /></a></span></div>
				<div class="desc">
					<h3 class="headline"><%=nl2br(cPs.FOnePiece.Fshorttext)%></h3>
					<div class="writer"><a href=""  onclick="fnAPPpopupPiece('조각모음','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/?adminid=<%=cPs.FOnePiece.Fadminid%>&piecepop=on','right');return false;"><span class="iam"><%=cPs.FOnePiece.Foccupation%>.</span> <span class="nickname"><%=cPs.FOnePiece.Fnickname%>의 조각</span></a></div>
					<div class="btn-group">
						<a href="" onclick="fnAPPpopupPiece('조각 공유하기','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/share.asp?idx=<%=cPs.FOnePiece.Fidx%>','','share');return false;" class="btn-share"><span class="icon icon-share">공유</span><% If cPs.FOnePiece.Fsnsbtncnt > 9 Then %><span class="counting" id="sns<%=cPs.FOnePiece.Fidx%>"><%=FormatNumber(cPs.FOnePiece.Fsnsbtncnt,0)%></span><% End If %></a>
					</div>
				</div>
			</div>
			<div class="textarea">
				<p><%=nl2br(cPs.FOnePiece.Flisttext)%></p>
			</div>
			<div class="tag-and-items typeA">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<div class="list-box list-box-grey">
								<%
								If cPs.FOnePiece.Ftagtext <> "" Then 
									'split(cPs.FOnePiece.Ftagtext,"$$")(0)->tagtext텍스트, split(cPs.FOnePiece.Ftagtext,"$$")(1)->tagcnt카운트
									For t=0 To UBound(Split(cPs.FOnePiece.Ftagtext,","))
'										If vAdminID = "" Then 
'											If piecepop = "on" Then
'												Response.Write "<a href="""" onclick=""fnAPPpopupPiece('조각 검색','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/index.asp?rect="&server.urlencode(fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0))&"&piecepop=on&focusout=Y','right');return false;"">#" & fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0) & "</a>" & vbCrLf
'											Else 
'												Response.Write "<a href="""" onclick=""fnAPPpopupPiece('조각 검색','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/index.asp?rect="&server.urlencode(fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0))&"&piecepop=on&tagSearchYN=Y','right');return false;"">#" & fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0) & "</a>" & vbCrLf
'											End If 
'										Else
'											Response.Write "<a href="""" onclick=""fnAPPpopupPiece('조각 검색','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/index.asp?rect="&server.urlencode(fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0))&"&piecepop=on&tagSearchYN=Y','right');return false;"">#" & fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0) & "</a>" & vbCrLf												
'										End If 
										Response.Write "<a href="""" onclick=""fnAPPpopupSearch('"&fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0)&"');return false;"">#" & fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0) & "</a>" & vbCrLf
									Next
								End If 
								%>
							</div>
						</div>
						<%' 위시등록 시 위시리스트내 Piece폴더 생성, 폴더팝업을 노출하지않고 자동으로 해당 폴더안에 저장 %>
						<%
							For p=0 To UBound(Split(cPs.FOnePiece.Fpitem,","))
								vItemID 		= fnSplitTxt(Split(cPs.FOnePiece.Fpitem,",")(p),0)
								vBasicImage 	= fnSplitTxt(Split(cPs.FOnePiece.Fpitem,",")(p),1)
								
								Response.Write "<div class=""swiper-slide"">"
								Response.Write "<div class=""thumbnail"" onclick=""fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid="&vItemID&"&gaparam=piece_sub');return false;"">"
								Response.Write "<img src=""http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(vItemID) & "/" & getThumbImgFromURL(vBasicImage,60,60,"true","false") & """ alt="""" /></div>"
								
								If fnIsMyFavItem(vWishArr,vItemID) Then
									Response.Write "<button type=""button"" class=""btn-wish on"" id=""wish"&vItemID&""" onClick=""jsPieceItemWish('"&vItemID&"','wish"&vItemID&"');"">위시등록 해제하기</button>"
								Else
									Response.Write "<button type=""button"" class=""btn-wish"" id=""wish"&vItemID&""" onClick=""jsPieceItemWish('"&vItemID&"','wish"&vItemID&"');"">위시등록 하기</button>"
								End If
								
								Response.Write "</div>" & vbCrLf
							Next
						%>
					</div>
				</div>
			</div>
		</section>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
	Set cPs = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->