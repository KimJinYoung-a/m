<script type="text/javascript" src="/lib/js/jquery.lazyload.min.js"></script>
<script>
	$(function() {
	    $("#tab01 img.lazy").lazyload().removeClass("lazy");
	});
</script>

<!-- 상세설명 TAB -->
<ul class="commonTabV16a">
<% If IsPresentItem then 'Present상품 %>
	<li class="current" name="tab01" tno="1" style="width:33.3%;">상품설명</li>
	<li name="tab02" tno="2" style="width:33.3%;">기본정보</li>
	<li name="tab03" tno="3" style="width:33.4%;">후기<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
<% ElseIf IsTicketItem Then '티켓상품 %>
	<li class="current" name="tab01" tno="1" style="width:25%;">설명</li>
	<li name="tab02" tno="2" style="width:25%;">기본정보</li>
	<li name="tab03" tno="3" style="width:25%;">관람평<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
	<li name="tab04" tno="5" style="width:25%;">공연장 정보</li>
	<!--li name="tab04" tno="6">취소환불/수령</li-->
<%
	Else
		'//일반상품
		If oItem.Prd.IsSpecialBrand Then
%>
	<li class="current" name="tab01" tno="1" style="width:25%;">상품설명</li>
	<li name="tab02" tno="2" style="width:25%;">기본정보</li>
	<li name="tab03" tno="3" style="width:25%;">상품후기<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
	<li name="tab04" tno="4" style="width:25%;">Q&amp;A<%=chkIIF(oQna.FTotalCount>0,"("&oQna.FTotalCount&")","")%></li>
<%		Else %>
	<li class="current" name="tab01" tno="1" style="width:33.3%;">상품설명</li>
	<li name="tab02" tno="2" style="width:33.3%;">기본정보</li>
	<li name="tab03" tno="3" style="width:33.4%;">상품후기<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
<%
		end if
	end if
%>
</ul>


<div class="itemDetailContV16a">
	<div class="tabCont">
		<!-- tab.01: 설명 -->
		<div id="tab01" class="pdtExplainV16a">
			<%
			''브랜드 공지 2017-02-03 유태욱
			''브랜드 공지(일반,배송) 2017-01-31 유태욱 작업중
				
			dim oBrandNotice
			set oBrandNotice = new CatePrdCls
			oBrandNotice.Frectmakerid=vMakerid
			oBrandNotice.GetBrandNoticeData
			Dim vBrandNotice

			if oBrandNotice.FResultCount > 0 then
				For i= 0 to oBrandNotice.FResultCount-1
					vBrandNotice=""
					' 배송공지
					vBrandNotice = vBrandNotice & "	<div class="&chkIIF(oBrandNotice.FItem(i).FBrandNoticeGubun = 2,"""notiV17 notiDelivery""","""notiV17 notiGeneral""")&">" & vbCrLf
					vBrandNotice = vBrandNotice & "		<h3>"&oBrandNotice.FItem(i).FBrandNoticeTitle&"</h3>" & vbCrLf
					vBrandNotice = vBrandNotice & "		<div class='texarea'>" & vbCrLf
					vBrandNotice = vBrandNotice & "			<p>" & vbCrLf
					vBrandNotice = vBrandNotice & 				nl2br(oBrandNotice.FItem(i).FBrandNoticeText) & vbCrLf
					vBrandNotice = vBrandNotice & "			</p>" & vbCrLf
					vBrandNotice = vBrandNotice & "		</div>" & vbCrLf
					vBrandNotice = vBrandNotice & "	</div>" & vbCrLf
					Response.Write vBrandNotice
				next
			End If

			Set oBrandNotice = Nothing
			%>
			<div class="pdtCaptionV16a">
				<p><strong>상품코드 : <%=itemid%></strong></p>
				<% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
				<!-- 주의사항 -->
				<dl class="odrNoteV16a">
					<dt><strong>주문 유의사항</strong></dt>
					<dd><%= oItem.Prd.getDeliverNoticsStr %><br><%= nl2br(oItem.Prd.FOrderComment) %></dd>
				</dl>
				<% end if %>
			</div>

			<!-- 상세설명 -->
			<%
				'## 설명이미지 표시 (1순위:모바일상품설명이미지, 2순위:캡쳐 이미지, 3순위: html이미지+상품설명이미지)
				dim itemContImg, tmpExtImgArr, mtmpAddImgChk, vCaptureExist, adjs, isUseCaptureView, VCaptureImgArr, itemVideos

				adjs = 0
				mtmpAddImgChk = False
				isUseCaptureView = False

				'추가이미지
				IF oAdd.FResultCount > 0 THEN
					FOR i= 0 to oAdd.FResultCount-1
						IF oAdd.FADD(i).FAddImageType=2 Then
							If oAdd.FADD(i).FIsExistAddimg Then
								mtmpAddImgChk = True
								If adjs > 0 Then
									itemContImg = itemContImg & "<img data-original='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;' class='lazy'>"
								Else
									itemContImg = itemContImg & "<img src='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;'>"
								End If
								adjs = adjs + 1
							End If
						End If
					NEXT
				end If
				
				'캡쳐이미지
				oItem.sbDetailCaptureViewCount itemid
				vCaptureExist = oItem.FCaptureExist

				If vCaptureExist = "1" Then
					isUseCaptureView = true
					VCaptureImgArr = oItem.sbDetailCaptureViewImages(itemid)
				End If

				'// 상품상세설명 동영상 추가
				Set itemVideos = New catePrdCls
					itemVideos.fnGetItemVideos itemid, "video1"

'				'상품 설명 업로드 이미지
'				if itemContImg="" then
'					if ImageExists(oItem.Prd.FImageMain) then
'						itemContImg = oItem.Prd.FImageMain
'					elseif ImageExists(oItem.Prd.FImageMain2) then
'						itemContImg = oItem.Prd.FImageMain2
'					elseif ImageExists(oItem.Prd.FImageMain3) then
'						itemContImg = oItem.Prd.FImageMain3
'					end if
'				end if
'
'				'HTML내 이미지
'				if itemContImg="" then
'					tmpExtImgArr = RegExpArray("[^=']*\.(gif|jpg|bmp|png)", lCase(oItem.Prd.FItemContent))
'					if isArray(tmpExtImgArr) then
'						itemContImg = Replace(tmpExtImgArr(0),"""","")
'					end if
'				end if
			%>
			<div class="pdtImgViewV16a">
				<% If mtmpAddImgChk Then %>
					<%' 모바일 상품상세 이미지가 있을경우 그냥 펼침 %>
					<div class="pdtImgViewV16a">
						<%=itemContImg%>
					</div>
					<%'// 상품상세설명 동영상 추가 %>
					<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
						<center>
							<p>&nbsp;</p>
							<iframe class="youtube-player" type="text/html" width="320" height="180" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
						</center>
					<% End If %>
				<% ElseIf ((isUseCaptureView)) Then %>
					<%' 캡쳐 이미지가 있을 경우에도 그냥 펼침 %>
					<div class="pdtImgViewV16a">
						<% if isArray(VCaptureImgArr) then %>
							<% for i=0 to UBound(VCaptureImgArr,2) %>
								<% if i<3 then %>
									<img src="<%= VCaptureImgArr(2,i) %>" border="0" style="width:100%;" />
								<% else %>
									<img data-original="<%= VCaptureImgArr(2,i) %>" border="0" style="width:100%;" class="lazy" />
								<% end if %>
							<% next %>
						<% end if %>
					</div>
					<%'// 상품상세설명 동영상 추가 %>
					<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
						<center>
							<p>&nbsp;</p>
							<iframe class="youtube-player" type="text/html" width="320" height="180" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
						</center>
					<% End If %>
				<% Else %>
					<%' 모바일 이미지도 캡쳐 이미지도 없을 경우엔 걍 숨기고 html보여줌 %>
					<div class="btnAreaV16a">
						<p><button type="button" class="btnV16a btnDGryV16a" onclick="location.href='/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>';">상품상세 보기<img src="http://fiximage.10x10.co.kr/m/2016/common/ico_zoom.png" alt="" /></button></p>
					</div>
				<% End If %>

				<%
					Dim vDescriptionGubun: vDescriptionGubun = "itemdetail"
					If IsSpcTravelItem Then	'### 스페셜 항공권 상품인경우
				%>
				<!-- #include virtual="/category/inc_TravelItem_description_jinair.asp" -->
				<% End If %>
			</div>
		</div>
		<!-- 추가 tab -->
		<div id="tab02" class="pdtBasicInfoV16a" style="display:none;"></div>
		<div id="tab03" class="postTxtV16a" style="display:none;"></div>
		<div id="tab04" class="pdtQnaV16a" style="display:none;"></div>
		<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
		<!-- //추가 tab -->
	</div>
</div>