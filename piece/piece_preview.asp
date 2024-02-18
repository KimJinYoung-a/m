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
' Description :  피스 SCM 미리보기
' History : 2018-01-08 이종화
'####################################################
Dim cPs , t , p , vItemID , vBasicimage , vWishArr , piecepop
Dim idx : idx = getNumeric(requestCheckVar(request("idx"),5))
Dim vLinkItemID
Dim vAdminID
'// A/B 테스트용
Dim RvSelPiece : RvSelPiece=Session.SessionID Mod 2

If Isnull(idx) Or idx = "" Then
	Call Alert_Return("잘못된 접근 입니다.")
	Response.write "<script>self.close();</script>"
	response.End
End If

	SET cPs = New Cgetpiece
	cPs.FRectIdx = idx
	cPs.getPiecepreview()

	If cPs.FOnePiece.Fitemid <> "" then
		vLinkItemID = Split(cPs.FOnePiece.Fitemid,",")(0)
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
<!-- #include file="./index_javascript.asp" -->
</script>
</head>
<body class="default-font body-popup bg-black piece">
	<div id="content" class="content bg-black">
		<%'!-- piece : 오늘의 조각 --%>
		<section class="a-piece">
			<div class="topic">
				<div class="thumbnail"><span class="inner"><a href="javascript:alert('상품코드 : <%=vLinkItemID%> 로 이동');"><img src="<%=cPs.FOnePiece.Flistimg%>" alt="" /></a></span></div>
				<div class="desc">
					<h3 class="headline"><%=nl2br(cPs.FOnePiece.Fshorttext)%></h3>
					<div class="writer"><a href="javascript:alert('<%=cPs.FOnePiece.Fnickname%> 의 조각 이동');"><span class="iam"><%=cPs.FOnePiece.Foccupation%>.</span> <span class="nickname"><%=cPs.FOnePiece.Fnickname%>의 조각</span></a></div>
					<div class="btn-group">
						<a href="javascript:alert('공유');" class="btn-share"><span class="icon icon-share">공유</span><% If cPs.FOnePiece.Fsnsbtncnt > 9 Then %><span class="counting" id="sns<%=cPs.FOnePiece.Fidx%>"><%=FormatNumber(cPs.FOnePiece.Fsnsbtncnt,0)%></span><% End If %></a>
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
										Response.Write "<a href=""javascript:alert('키워드 : "&fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0)&" 검색');"">#" & fnSplitTxt(Split(cPs.FOnePiece.Ftagtext,",")(t),0) & "</a>" & vbCrLf
									Next
								End If
								%>
							</div>
						</div>
						<%' 위시등록 시 위시리스트내 Piece폴더 생성, 폴더팝업을 노출하지않고 자동으로 해당 폴더안에 저장 %>
						<%
						if Not IsNull(cPs.FOnePiece.Fpitem) then
							For p=0 To UBound(Split(cPs.FOnePiece.Fpitem,","))
								vItemID 		= fnSplitTxt(Split(cPs.FOnePiece.Fpitem,",")(p),0)
								vBasicImage 	= fnSplitTxt(Split(cPs.FOnePiece.Fpitem,",")(p),1)

								Response.Write "<div class=""swiper-slide"">"
								Response.Write "<div class=""thumbnail"" onclick=""alert('상품코드 : "&vItemID&" 로 이동');""><a href="""">"
								Response.Write "<img src=""http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(vItemID) & "/" & getThumbImgFromURL(vBasicImage,60,60,"true","false") & """ alt="""" /></a></div>"

								If fnIsMyFavItem(vWishArr,vItemID) Then
									Response.Write "<button type=""button"" class=""btn-wish on"" id=""wish"&vItemID&""" onClick=""alert('위시해제 하기');"">위시등록 해제하기</button>"
								Else
									Response.Write "<button type=""button"" class=""btn-wish"" id=""wish"&vItemID&""" onClick=""alert('위시등록 하기');"">위시등록 하기</button>"
								End If

								Response.Write "</div>" & vbCrLf
							Next
						end if
						%>
					</div>
				</div>
			</div>
		</section>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
	Set cPs = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
