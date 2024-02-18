<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2015 투데이
' History : 2014.10.13 원승현 생성
'			2014.10.13 한용민 모바일웹 이전/생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/diarystory2015/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2015/lib/classes/diary_class.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->

<%
dim GiftSu, i, weekDate

GiftSu=0

dim cDiary
Set cDiary = new cdiary_list
	cDiary.getOneplusOneDaily '1+1
	
if cDiary.ftotalcount>0 then
	GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수
		if GiftSu = false then GiftSu=0
end if

dim cDiarycnt
Set cDiarycnt = new cdiary_list
	cDiarycnt.getDiaryCateCnt '상태바 count

weekDate = weekDayName(weekDay(now)) '// 요일 구하기 내장 함수
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/diary2015.css">
<script type='text/javascript'>

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
	<% if IsUserLoginOK then %>
		jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
	<% else %>
		calllogin();
		//location.href='/apps/appCom/wish/webview/login/login.asp?backpath=<%=server.URLEncode(CurrURLQ())%>';
	<% end if %>
	return;
}

</script>
</head>
<body class="diarystory2015">
	<!-- wrapper -->
	<div class="wrapper">
		<!-- #content -->
		<div id="content">

			<% If weekDate = "토요일" Or weekDate = "일요일" Then %>				
				<% ' for dev msg : 토, 일, 공휴일 %>
				<div class="holiday">
					<h1 class="hide">투데이 다이어리</h1>
					<p><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/txt_today_diary_holiday.png" alt="투데이 다이어리 오늘 쉽니다. 공휴일을 제외하고 월요일부터 금요일에만 진행됩니다." /></p>
				</div>
			<% Else %>
				<%' for dev msg : 주말, 공휴일엔 숨겨주세요. %>
				<div class="todayDiary">
					<div class="desc">
						<h1><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/tit_today_diary.png" alt="투데이 다이어리" /></h1>
						<a href="" onclick="TnGotoProduct('<%=cDiary.FOneItem.FItemid%>'); return false;">
							<div class="pPhoto">
								<img src="<%= getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid( cDiary.FOneItem.Fitemid )&"/"&db2html( cDiary.FOneItem.fbasicimage ),"400","400","true","false") %>" alt="<%=cDiary.FOneItem.Fitemname%>" />
							</div>
							
							<% If GiftSu > 0 Then %>
								<strong class="plus">
									<% if cDiary.FOneItem.fplustype="1" then %>
										1+1
									<% else %>
										1:1
									<% end if %>
								</strong>
								<% ' for dev msg : 남은 수량이 소진 될 경우 - 1+1이 모두 소진 되었습니다. %>
								<em class="countdown"><span>남은수량 <%= GiftSu %>개</span></em>
							<% end if %>

							<div class="pdtCont">
								<p class="pBrand">[<%= cDiary.FOneItem.Fsocname %>]</p>
								<p class="pName"><%= cDiary.FOneItem.Fitemname %></p>
								<p class="pPrice"><span class="cRd1">
									<%
										IF cDiary.FOneItem.IsSaleItem or cDiary.FOneItem.isCouponItem Then
											If  cDiary.FOneItem.getRealPrice <> cDiary.FOneItem.FSellCash then
												IF cDiary.FOneItem.IsSaleItem then
									%>
												<%=FormatNumber(cDiary.FOneItem.getRealPrice,0) %>원
									<%
												End If
												IF cDiary.FOneItem.IsCouponItem then
									%>
												<%= FormatNumber(cDiary.FOneItem.GetCouponAssignPrice,0)%>원
									<%
												End If
											Else
									%>
												<%= FormatNumber(cDiary.FOneItem.GetCouponAssignPrice,0)%>원
									<%
											End If
										ELSE
									%>
											<%= FormatNumber(cDiary.FOneItem.FSellCash,0)%>원
									<%
										End If
									%>
								</span></p>
							</div>
						</a>
					</div>
				</div>
			<% End If %>

			<% If weekDate = "토요일" Or weekDate = "일요일" Then %>				

				<div class="diaryList inner5">
					<!-- BEST -->
					<!-- #include virtual="/apps/appCom/wish/webview/diarystory2015/inc/inc_best.asp" -->
				</div>
			<% Else %>
				<div class="diaryList plus-slae inner5">
					<div class="hgroup">
						<h2>PLUS SALE</h2>
						<p><em>TODAY DIARY와 함께 구매하고 할인 받으세요!</em></p>
						<p>여기서 잠깐! TODAY DIARY와 PLUS SALE 상품을 함께 장바구니에 담으셔야 할인가가 적용됩니다.</p>
					</div>

					<div class="pdtListWrap">
						<ul class="pdtList">
							<%
								'메인관련 할인 상품 목록 접수/출력
								Dim oPlusSaleItem , vTmp
								set oPlusSaleItem = new CSetSaleItem
								oPlusSaleItem.FRectItemID = cDiary.FOneItem.Fitemid
								oPlusSaleItem.GetLinkSetSaleItemList

								vTmp = oPlusSaleItem.FResultCount-1

								For i=0 To vTmp
							%>

							<li <%IF oPlusSaleItem.FItemList(i).isSoldOut Then%>class="soldOut"<% End If %>>
								<a href="#" onclick="TnGotoProduct('<%=oPlusSaleItem.FItemList(i).FItemID %>');">
									<%' for dev msg : 웹 다이어리 스토리 리스트와 동일한 이미지 호출해주세요 %>
									<div class="pPhoto"><% IF oPlusSaleItem.FItemList(i).isSoldOut Then%><p><span><em>품절</em></span></p><% End If %><img src="<%=oPlusSaleItem.FItemList(i).FImageBasic%>" alt="<%=oPlusSaleItem.FItemList(i).FItemName%>"></div>
									<div class="pdtCont">
										<p class="pBrand"><a href="/street/street_brand.asp?makerid=<%=oPlusSaleItem.FItemList(i).FMakerId %>" >by <%=oPlusSaleItem.FItemList(i).FBrandName%></a></p>
										<p class="pName"><a href="#" onclick="TnGotoProduct('<%=oPlusSaleItem.FItemList(i).FItemID %>');"><%=oPlusSaleItem.FItemList(i).FItemName%></a></p>
										<p class="pPrice">
											<%
													IF oPlusSaleItem.FItemList(i).IsSaleItem or oPlusSaleItem.FItemList(i).isCouponItem Then
														If  oPlusSaleItem.FItemList(i).getRealPrice <> oPlusSaleItem.FItemList(i).FSellCash then
															IF oPlusSaleItem.FItemList(i).IsSaleItem then
											%>
															<%=FormatNumber(oPlusSaleItem.FItemList(i).getRealPrice,0) %>원
											<%
															End If
															IF oPlusSaleItem.FItemList(i).IsCouponItem then
											%>
															<%= FormatNumber(oPlusSaleItem.FItemList(i).GetCouponAssignPrice,0)%>원
											<%
															End If
														Else
											%>
															<%= FormatNumber(oPlusSaleItem.FItemList(i).GetCouponAssignPrice,0)%>원
											<%
														End If
													ELSE
											%>
														<%= FormatNumber(oPlusSaleItem.FItemList(i).FSellCash,0)%>원
											<%
													End If
											%>
										</p>
										<p class="pShare">
											<span class="cmtView"><%= FormatNumber(oPlusSaleItem.FItemList(i).Freviewcnt,0) %></span>
											<span class="wishView" onclick="TnAddFavoritePrd('<%= oPlusSaleItem.FItemList(i).FItemID %>');"><%= FormatNumber(oPlusSaleItem.FItemList(i).FFavCount,0) %></span>
										</p>
									</div>
								</a>
							</li>
							<%
								Next 

								set oPlusSaleItem = Nothing
							%>
						</ul>
					</div>
				</div>
			<% End If %>
			<div id="modalCont" style="display:none;"></div>
		</div>
		<!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			<a href="#" class="btn-top">top</a>
		</footer><!-- #footer -->

		</div>
	<!-- //wrapper -->
</body>
</html>

<%
Set cDiary = Nothing
Set cDiarycnt = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->