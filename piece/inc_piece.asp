<section class="a-piece">
	<div class="topic">
		<div class="thumbnail"><span class="inner"><img src="<%=oPi.FItemList(i).Flistimg%>" alt="" /></span></div>
		<div class="desc">
			<%' 오프닝으로 설정할 경우 --%>
			<% If oPi.FItemList(i).FnoticeYN = "Y" Then %>
			<span class="label label-ribon"><em>Opening</em></span>
			<% End If %>
			<h2 class="headline"><%=nl2br(oPi.FItemList(i).Fshorttext)%></h2>
			<div class="writer"><a href="?adminid=<%=oPi.FItemList(i).Fadminid%>&piecepop=on"><span class="iam"><%=oPi.FItemList(i).Foccupation%>.</span> <span class="nickname"><%=oPi.FItemList(i).Fnickname%>의 조각</span></a></div>
			<div class="btn-group">
				<button type="button" class="btn-wish wish<%=vLinkItemID%> <%=chkiif(fnIsMyFavItem(vWishArr,vLinkItemID)," on","")%>" onClick="jsPieceItemWish('<%=vLinkItemID%>','wish<%=vLinkItemID%>');">위시등록 하기</button>
				<a href="/piece/share.asp?idx=<%=oPi.FItemList(i).Fidx%>" class="btn-share"><span class="icon icon-share">공유</span><% If oPi.FItemList(i).Fsnsbtncnt > 9 Then %><span class="counting" id="sns<%=oPi.FItemList(i).Fidx%>"><%=FormatNumber(oPi.FItemList(i).Fsnsbtncnt,0)%></span><% End If %></a>
			</div>
		</div>
		<a href="/category/category_itemPrd.asp?itemid=<%=vLinkItemID%>&gaparam=piece_main_typeB" class="go-detail">상품 상세페이지로 연결</a>
	</div>
	<div class="textarea">
		<p><%=nl2br(oPi.FItemList(i).Flisttext)%></p>
	</div>
	<div class="tag-and-items">
		<div class="list-box list-box-grey">
			<%
			If oPi.FItemList(i).Ftagtext <> "" Then
				'split(oPi.FItemList(i).Ftagtext,"$$")(0)->tagtext텍스트, split(oPi.FItemList(i).Ftagtext,"$$")(1)->tagcnt카운트
				For t=0 To UBound(Split(oPi.FItemList(i).Ftagtext,","))
					'Response.Write "<a href=""/piece/?rect="&fnSplitTxt(Split(oPi.FItemList(i).Ftagtext,",")(t),0)&"&piecepop=on&tagSearchYN=Y"">#" & fnSplitTxt(Split(oPi.FItemList(i).Ftagtext,",")(t),0) & "</a>" & vbCrLf
					Response.Write "<a href=""/search/search_item.asp?rect="&fnSplitTxt(Split(oPi.FItemList(i).Ftagtext,",")(t),0)&""">#" & fnSplitTxt(Split(oPi.FItemList(i).Ftagtext,",")(t),0) & "</a>" & vbCrLf
				Next
			End If
			%>
		</div>
		<% If UBound(Split(oPi.FItemList(i).Fpitem,",")) >= 2 Then %>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<%' 위시등록 시 위시리스트내 Piece폴더 생성, 폴더팝업을 노출하지않고 자동으로 해당 폴더안에 저장 %>
				<%
					For p=0 To UBound(Split(oPi.FItemList(i).Fpitem,","))
						vItemID 		= fnSplitTxt(Split(oPi.FItemList(i).Fpitem,",")(p),0)
						vBasicImage 	= fnSplitTxt(Split(oPi.FItemList(i).Fpitem,",")(p),1)

						Response.Write "<div class=""swiper-slide"">"
						Response.Write "<div class=""thumbnail"" onclick=""location.href='/category/category_itemPrd.asp?itemid="&vItemID&"&gaparam=piece_sub_typeB';""><a href="""">"
						Response.Write "<img src=""http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(vItemID) & "/" & getThumbImgFromURL(vBasicImage,60,60,"true","false") & """ alt="""" /></a></div>"

						If fnIsMyFavItem(vWishArr,vItemID) Then
							Response.Write "<button type=""button"" class=""btn-wish on wish"&vItemID&""" _id="""" onClick=""jsPieceItemWish('"&vItemID&"','wish"&vItemID&"');"">위시등록 해제하기</button>"
						Else
							Response.Write "<button type=""button"" class=""btn-wish wish"&vItemID&""" _id="""" onClick=""jsPieceItemWish('"&vItemID&"','wish"&vItemID&"');"">위시등록 하기</button>"
						End If

						Response.Write "</div>" & vbCrLf
					Next
				%>
			</div>
		</div>
		<% End If %>
	</div>
</section>