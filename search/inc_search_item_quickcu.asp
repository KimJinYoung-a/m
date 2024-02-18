<%
If search_on = "" Then	'### 초기 로딩시에만 퀵링크, 큐레이터 나타남.
	
	'################################### 퀵링크 ###################################
	Dim cQ, vArrQ, vQuickCnt, vQuickType, vQuickBody
	Set cQ = New CDBSearch
	cQ.FRectKeyword = SearchText
	cQ.FRectIDX = 0
	vArrQ = cQ.fnSearchQuickLink()
	vQuickCnt = cQ.FResultCount
	Set cQ = Nothing
	
	If vQuickCnt > 0 Then
		If isArray(vArrQ) Then
			'type:1, name:2, brandid:3, subcopy:4, url_m:6, btnname:10, btn_mlink:12, btn_color:13, bggubun:14, bgcolor:15, bgimgm:17, qimg_useyn:18, qimgm:20, htmlcont:21
			vQuickType = vArrQ(1,0)
			
			If vQuickType = "txt" Then	'### 텍스트형
				vQuickBody = "<aside class=""search-quicklink-ad type-quicklink-text"">" & vbCrLf
				vQuickBody = vQuickBody & "	<a href=""" & vArrQ(6,0) & CHKIIF(InStr(vArrQ(6,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0") & """ onclick=fnAmplitudeEventMultiPropertiesAction('click_search_result_quicklink','keyword','"&Replace(SearchText, " ","")&"');>" & vbCrLf
				vQuickBody = vQuickBody & "		<div class=""desc"">" & vbCrLf
				vQuickBody = vQuickBody & "			<h2>" & db2html(vArrQ(2,0)) & "</h2>" & vbCrLf
				vQuickBody = vQuickBody & "			<p>" & db2html(vArrQ(4,0)) & "</p>" & vbCrLf
				vQuickBody = vQuickBody & "		</div>" & vbCrLf
				vQuickBody = vQuickBody & "	</a>" & vbCrLf
				vQuickBody = vQuickBody & "</aside>"
			ElseIf vQuickType = "nor" Then	'### 기본형
				vQuickBody = "<aside class=""search-quicklink-ad type-quicklink-default"&CHKIIF(vArrQ(14,0)="c","-full","")&""" style="""
				If vArrQ(14,0) = "c" Then
					vQuickBody = vQuickBody & "background-color:#" & vArrQ(15,0) & ";"
				ElseIf vArrQ(14,0) = "i" Then
					vQuickBody = vQuickBody & "background-image:url(" & vArrQ(17,0) & ");"
				End If
				vQuickBody = vQuickBody & """>" & vbCrLf
				vQuickBody = vQuickBody & "	<div class=""desc"">" & vbCrLf
				vQuickBody = vQuickBody & "		<a href=""" & vArrQ(6,0) & CHKIIF(InStr(vArrQ(6,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0") & """ onclick=fnAmplitudeEventMultiPropertiesAction('click_search_result_quicklink','keyword','"&Replace(SearchText, " ","")&"');>" & vbCrLf
				vQuickBody = vQuickBody & "			<h2>" & db2html(vArrQ(2,0)) & "</h2>" & vbCrLf
				vQuickBody = vQuickBody & "			<p>" & db2html(vArrQ(4,0)) & "</p>" & vbCrLf
				vQuickBody = vQuickBody & "		</a>" & vbCrLf
				If vArrQ(10,0) <> "" Then
					vQuickBody = vQuickBody & "		<div class=""btn-group"">" & vbCrLf
					vQuickBody = vQuickBody & "			<a href=""" & vArrQ(12,0) & CHKIIF(InStr(vArrQ(12,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0") & """ class=""btn-flat"">" & db2html(vArrQ(10,0)) & "</a>" & vbCrLf
					vQuickBody = vQuickBody & "		</div>" & vbCrLf
				End If
				vQuickBody = vQuickBody & "	</div>" & vbCrLf
				vQuickBody = vQuickBody & "</aside>"
			ElseIf vQuickType = "set" OR vQuickType = "brd" Then	'### 설정형 or 브랜드형
				vQuickBody = "<aside class=""search-quicklink-ad type-quicklink-"&CHKIIF(vQuickType="set","setting","brand")&""" style="""
				If vArrQ(14,0) = "c" Then
					vQuickBody = vQuickBody & "background-color:#" & vArrQ(15,0) & ";"
				ElseIf vArrQ(14,0) = "i" Then
					vQuickBody = vQuickBody & "background-image:url(" & vArrQ(17,0) & ");"
				End If
				vQuickBody = vQuickBody & """>" & vbCrLf
				vQuickBody = vQuickBody & "	<div class=""desc"">" & vbCrLf
				vQuickBody = vQuickBody & "		<a href=""" & vArrQ(6,0) & CHKIIF(InStr(vArrQ(6,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0") & """ onclick=fnAmplitudeEventMultiPropertiesAction('click_search_result_quicklink','keyword','"&Replace(SearchText, " ","")&"');>" & vbCrLf
				vQuickBody = vQuickBody & "			<h2>" & db2html(vArrQ(2,0)) & "</h2>" & vbCrLf
				vQuickBody = vQuickBody & "			<p>" & db2html(vArrQ(4,0)) & "</p>" & vbCrLf
				vQuickBody = vQuickBody & "		</a>" & vbCrLf
				If vArrQ(10,0) <> "" Then
					vQuickBody = vQuickBody & "		<div class=""btn-group"">" & vbCrLf
					vQuickBody = vQuickBody & "			<a href=""" & vArrQ(12,0) & CHKIIF(InStr(vArrQ(12,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0") & """ class=""btn-flat"" style=""color:#" & vArrQ(13,0) & ";"">" & db2html(vArrQ(10,0)) & "</a>" & vbCrLf
					vQuickBody = vQuickBody & "		</div>" & vbCrLf
				End If
				vQuickBody = vQuickBody & "	</div>" & vbCrLf
				If vArrQ(20,0) <> "" Then	'### 퀵링크이미지
				vQuickBody = vQuickBody & "	<div class=""thumbnail""><img src=""" & vArrQ(20,0) & """ alt="""" /></div>" & vbCrLf
				End If
				vQuickBody = vQuickBody & "</aside>"
			ElseIf vQuickType = "cus" Then	'### 커스텀형
				vQuickBody = "<aside class=""search-quicklink-ad type-quicklink-customizing"">" & vbCrLf
				vQuickBody = vQuickBody & vArrQ(21,0)
				vQuickBody = vQuickBody & "</aside>"
			End If
		End If
		
		Response.Write vQuickBody
	End If
	'################################### 퀵링크 ###################################

	'################################### 큐레이터 ###################################
	Dim cCu, vCuLink, vAmplitudeItemType
	Set cCu = New CDBSearch
	cCu.FRectKeyword = SearchText
	cCu.fnSearchCuratorList()
	
	If cCu.FResultCount > 0 Then
	%>
	<aside id="keywordCurator" class="keyword-curator type-color-<%=cCu.FItemList(0).Fbgclass%>">
		<h2><%=cCu.FItemList(0).Ftitle%></h2>
		<div class="swiper-container items type-card">
			<ul class="swiper-wrapper">
				<%
				For i = 0 To cCu.FResultCount - 1
					If cCu.FItemList(i).Fitemgubun = "item" Then
						Response.Write "<li class=""swiper-slide item"">"
						vCuLink = "/category/category_itemPrd.asp?itemid=" & cCu.FItemList(i).FItemID & "&pRtr="&server.URLEncode(SearchText)&"&rc=qrt_1_"&(i)&""
						vAmplitudeItemType = "product"
					ElseIf cCu.FItemList(i).Fitemgubun = "event" Then
						If cCu.FItemList(i).Fevt_kind = "28" Then	'### 마케팅 이벤트
							Response.Write "<li class=""swiper-slide event"">"
							vAmplitudeItemType = "event"
						Else	'### MD 기획전
							Response.Write "<li class=""swiper-slide exhibition"">"
							vAmplitudeItemType = "planning"
						End If
						
						IF cCu.FItemList(i).Fevt_LinkType="I" and cCu.FItemList(i).Fevt_bannerLink<>"" THEN		'#별도 링크타입
							vCuLink = """ onClick=""top.location.href='" & cCu.FItemList(i).Fevt_bannerLink & "'; return false;"
						Else
							vCuLink = """ onClick=""top.location.href='/event/eventmain.asp?eventid=" & cCu.FItemList(i).FItemID & "&pNtr=qr_"&server.URLEncode(SearchText)&"&rc=qrt_1_"&(i)&"';fnAmplitudeEventMultiPropertiesAction('click_search_result_curation','keyword|item_type|index','"&Replace(SearchText," ","")&"|"&vAmplitudeItemType&"|"&i+1&"'); return false;"
						End If
					End If
				%>
					<a href="<%=vCuLink%>" onClick="fnAmplitudeEventMultiPropertiesAction('click_search_result_curation','keyword|item_type|index','<%=Replace(SearchText," ","")%>|<%=vAmplitudeItemType%>|<%=i+1%>');">
						<div class="thumbnail"><img src="<%=cCu.FItemList(i).FImageBasic %>" alt="" /></div>
						<div class="desc">
							<span class="label">
							<%
								If cCu.FItemList(i).Fitemgubun = "item" Then
									Response.Write "상품"
								ElseIf cCu.FItemList(i).Fitemgubun = "event" Then
									If cCu.FItemList(i).Fevt_kind = "28" Then
										Response.Write "이벤트"
									Else
										Response.Write "기획전"
									End If
								End If
							%>
							</span>
							<p class="name"><%=fnEventNameSplit(cCu.FItemList(i).FItemName,"name") %></p>
							<% If cCu.FItemList(i).Fitemgubun = "item" Then %>
							<div class="price">
								<% IF cCu.FItemList(i).IsSaleItem or cCu.FItemList(i).isCouponItem Then %>
									<% IF cCu.FItemList(i).IsSaleItem AND Not (cCu.FItemList(i).isCouponItem) Then %>
										<b class="sum"><% = FormatNumber(cCu.FItemList(i).getRealPrice,0) %><span class="won">원</span></b> <b class="discount color-red"><% = cCu.FItemList(i).getSalePro %></b>
									<% End IF %>
									<% IF cCu.FItemList(i).IsCouponItem AND Not (cCu.FItemList(i).IsSaleItem) AND cCu.FItemList(i).GetCouponDiscountStr <> "무료배송" Then %>
										<b class="sum"><% = FormatNumber(cCu.FItemList(i).GetCouponAssignPrice,0) %><span class="won">원</span></b> <b class="discount color-green"><% = cCu.FItemList(i).GetCouponDiscountStr %></b>
									<% End IF %>
									<% IF cCu.FItemList(i).IsCouponItem AND cCu.FItemList(i).IsSaleItem AND cCu.FItemList(i).GetCouponDiscountStr <> "무료배송" Then %>
										<b class="sum"><% = FormatNumber(cCu.FItemList(i).GetCouponAssignPrice,0) %><span class="won">원</span></b> <b class="discount color-red"><% = cCu.FItemList(i).getSalePro %></b>
										<% If cCu.FItemList(i).Fitemcoupontype = "1" Then %>
											&nbsp;<b class="discount color-green"><% = cCu.FItemList(i).GetCouponDiscountStr %></b>
										<% Else %>
											&nbsp;<b class="discount color-green">쿠폰</b>
										<% End IF %>
									<% End IF %>
								<% Else %>
									<b class="sum"><% = FormatNumber(cCu.FItemList(i).getRealPrice,0) %><span class="won"><% if cCu.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></span></b>
								<% End if %>
							</div>
							<% End If %>
						</div>
					</a>
				</li>
				<%
				Next %>
			</ul>
		</div>
	</aside>
	<%
	End If
	Set cCu = Nothing
	'################################### 큐레이터 ###################################
End If	'### 초기 로딩시에만 퀵링크, 큐레이터 나타남.
%>