<script type="text/javascript" src="/lib/js/jquery.lazyload.min.js"></script>
<script>
	$(function() {
	    $("#tab01 img.lazy").lazyload().removeClass("lazy");
	});
</script>

<!-- 상세설명 TAB -->
<ul class="commonTabV16a">
<% If IsPresentItem then 'Present상품 %>
	<li class="current" name="tab01" tno="1" style="width:33%;">상품설명</li>
	<li name="tab02" tno="2" style="width:33%;">기본정보</li>
	<li name="tab03" tno="3" style="width:33%;" >후기<%=chkIIF(oEval.FTotalCount>0,"<span>("&oEval.FTotalCount&")</span>","")%></li>
<% ElseIf IsTicketItem Then '티켓상품 %>
	<li class="current" name="tab01" tno="1" style="width:25%;">설명</li>
	<li name="tab02" tno="2" style="width:25%;">기본정보</li>
	<li name="tab03" tno="3" style="width:25%;" >후기<%=chkIIF(oEval.FTotalCount>0,"<span>("&oEval.FTotalCount&")</span>","")%></li>
	<li name="tab04" tno="4" style="width:25%;">Q&amp;A<%=chkIIF(oQna.FTotalCount>0,"("&oQna.FTotalCount&")","")%></li>
	<!--<li name="tab04" tno="5" style="width:25%;">위치 정보</li>--> <%' 2019-01-17 위치정보 설명 부분으로 통합 위치정보 자리에 QnA 추가 %>
	<!--li name="tab04" tno="6">취소환불/수령</li-->
<%
	Else
		'//일반상품
		If oItem.Prd.IsSpecialBrand then
%>
	<li class="current" name="tab01" tno="1" style="width:25%;">상품설명</li>
	<li name="tab02" tno="2" style="width:25%;">기본정보</li>
	<li name="tab03" tno="3" style="width:25%;" >상품후기<%=chkIIF(oEval.FTotalCount>0,"<span>("&oEval.FTotalCount&")</span>","")%></li>
	<li name="tab04" tno="4" style="width:25%;">Q&amp;A<%=chkIIF(oQna.FTotalCount>0,"<span>("&oQna.FTotalCount&")</span>","")%></li>
<%		Else %>
	<li class="current" name="tab01" tno="1" style="width:33%;">상품설명</li>
	<li name="tab02" tno="2" style="width:33%;">기본정보</li>
	<li name="tab03" tno="3" style="width:33%;" >상품후기<%=chkIIF(oEval.FTotalCount>0,"<span>("&oEval.FTotalCount&")</span>","")%></li>
<%
		end if
	end if
%>
</ul>


<div class="itemDetailContV16a">
	<div class="tabCont">
		<!-- tab.01: 설명 -->
		<div id="tab01" class="pdtExplainV16a">
			<% if Left(oItem.Prd.FcateCode,9) = "119113" then %>
			<%'<!-- 주류 통신판매에 관한 명령위임고시 2021-09-06 태훈 -->%>
			<div class="notiV17 notiV21 notiGeneral">
				<h3>주류의 통신판매에 관한 안내</h3>
				<div class="texarea">
					<p>
						- 관계법령에 따라 19세 미만 미성년자는 주류상품을 구매할 수 없습니다.<br>
						- 19세 이상 성인인증을 하셔야 구매가능한 상품입니다.<br>
						- 사업자 회원은 구매가 불가능한 상품입니다.
					</p>
				</div>
			</div>
			<% end if %>
			<%
			''브랜드 공지 2017-02-03 유태욱
			''브랜드 공지(일반,배송) 2017-01-31 유태욱

			dim oBrandNotice
			set oBrandNotice = new CatePrdCls
			oBrandNotice.Frectmakerid=vMakerid
			oBrandNotice.GetBrandNoticeData
			Dim vBrandNotice

			'if not(oItem.Prd.FDeliverytype = "1" or oItem.Prd.FDeliverytype = "4") then	'텐배가 아닐경우만 출력
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
			'end if

			Set oBrandNotice = Nothing
			%>
			<div class="pdtCaptionV16a">
				<p><strong>상품코드 : <%=itemid%></strong></p>
				<% if oItem.Prd.FMileage then %>
				<%'// 2018 회원등급 개편%>
					<% If Not(IsRentalItem) Then %>				
						<p style="margin-top:0.43rem;"><strong>적립 마일리지 : <% = oItem.Prd.FMileage %> Point <% If Not(IsUserLoginOK()) Then %>~<% End If %></strong></p>
					<% End If %>
				<% end if %>
				<% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
				<!-- 주의사항 -->
				<dl class="odrNoteV16a">
					<dt><strong>주문 유의사항</strong></dt>
					<dd><%= oItem.Prd.getDeliverNoticsStr %><br><%= nl2br(oItem.Prd.FOrderComment) %></dd>
				</dl>
				<% end if %>

				<% '// 설 연휴 배송안내 메시지 출력 %>
				<% if now() >= "2019-01-28" And now() < "2019-02-07" Then %>
					<% if oitem.Prd.IsTenBeasong then %>
					<div class="notiV18 notiDelivery">
						<h3>설 연휴 배송 안내</h3>
						<div class="textarea">
							<p>
								<em>텐바이텐 배송</em><br/>
								1월 30일 오후 3시 마감 (도서산간 지역 29일 마감)
							</p>
							<p>
								<em>바로 배송</em><br/>
								2월 1일 오후 1시 마감
							</p>
							<br />
							<p>※ 이후 주문 건은 2월 7일부터 발송될 예정입니다.</p>
						</div>
					</div>
					<% end if %>
					<% '// 특정 택배사 배송 지연 임시 배너 2018-11-28 CJ대한통운 파업%>
				<% End If %>
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
								if (flgDevice="I") Then
									itemContImg = itemContImg & "<img src='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;'>"							
								Else
									If adjs > 0 Then
										itemContImg = itemContImg & "<img data-original='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;' class='lazy'>"
									Else
										itemContImg = itemContImg & "<img src='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%; height:auto;'>"
									End If
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
			<style>#itemPrdDetail {overflow:hidden;width:100%; vertical-align:top;min-width:100vmin; height:200vmin;}</style>
			<div class="pdtImgViewV16a">
				<% If InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"android 4.4")>0 Then %>
					<%' 킷캣은 걍 버튼으로만 보여줌 %>
					<div class="btnAreaV16a">
						<p><button type="button" class="btnV16a btnDGryV16a" onclick="fnAPPpopupBrowserURL('상품상세 보기','<%=wwwUrl%>/apps/appCom/wish/web2014/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>&viewtype=<%=vItemDtlViewType%>'); return false;">상품상세 보기<img src="http://fiximage.10x10.co.kr/m/2016/common/ico_zoom.png" alt="" /></button></p>
					</div>
				<% ElseIf InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"iphone")>0 Then %>
					<%' 아이폰 상품상세는 모바일 상품상세 이미지가 먼저 없으면 html 상품상세 보여줌 %>
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
					<% Else %>
						<div id="pdtDetailTab01">
							<iframe id="itemPrdDetail" src="/category/category_itemPrd_iframe.asp?itemid=<%=itemid%>" frameborder="0" scrolling="no"></iframe>
							<div id="prdDetailLoadingPlayer" class="loadingV21">
                                <lottie-player src="https://assets2.lottiefiles.com/private_files/lf30_sf61wl6k.json" class="inner-loading" speed="1" loop autoplay></lottie-player>
                            </div>
						</div>

						<div class="btnAreaV16a btn-moreV18">
							<p><button style="display:none;" type="button" class="btnV16a btnRed1V16a off" id="buttonProductDetailContents">상품설명 펼쳐서 보기<span class="down-open"></span></button></p>
						</div>
					<% End If %>
				<% Else %>
					<% If mtmpAddImgChk Then %>
						<%' 모바일 상품상세 이미지가 있을경우 그냥 펼침 %>
						<div class="pdtImgViewV16a" id="itemContView">
							<%=itemContImg%>
						</div>
						<script>
							(function(){
								var $contents = $("#itemContView");
								$contents.find("table").css("width","100%");
								$contents.find("div").css("width","100%");
								$contents.find("img").css("width","100%");
							})(jQuery);
						</script>
						<%'// 상품상세설명 동영상 추가 %>
						<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
							<center>
								<p>&nbsp;</p>
								<iframe class="youtube-player" type="text/html" width="320" height="180" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
							</center>
						<% End If %>
					<% Else %>
						<div id="pdtDetailTab01">
							<iframe id="itemPrdDetail" src="/category/category_itemPrd_iframe.asp?itemid=<%=itemid%>" frameborder="0" scrolling="no"></iframe>
							<div id="prdDetailLoadingPlayer" class="loadingV21">
                                <lottie-player src="https://assets2.lottiefiles.com/private_files/lf30_sf61wl6k.json" class="inner-loading" speed="1" loop autoplay></lottie-player>
                            </div>
						</div>
						<div class="btnAreaV16a btn-moreV18">
							<p><button style="display:none;" type="button" class="btnV16a btnRed1V16a off" id="buttonProductDetailContents">상품설명 펼쳐서 보기<span class="down-open"></span></button></p>
						</div>
					<% End If %>
				<% End If %>

				<%
					Dim vDescriptionGubun: vDescriptionGubun = "itemdetail"
					If IsSpcTravelItem Then	'### 스페셜 항공권 상품인경우
				%>
				<!-- #include virtual="/category/inc_TravelItem_description_jinair.asp" -->
				<% End If %>
				<%' 클래스 위치정보  %>
				<!-- #include virtual="/category/inc_placeinfo.asp" -->
			</div>

			<script>
                var itemId = '<%=itemid%>'
                var reviewUserId = '<%=GetLoginUserId%>'
            </script>
            <div id="bottomReviewApp"></div>
            <script src="/vue/item/Detail/BottomReview/store_v2.js?v=1.01"></script>
            <script src="/vue/item/Detail/BottomReview/index_v2.js?v=1.01"></script>
		</div>
		<!-- 추가 tab -->
		<div id="tab02" class="pdtBasicInfoV16a" style="display:none;"></div>
		<div id="tab03" class="postTxtV16a post-txtV18" style="display:none;">
			<div id="tabReviewApp"></div>
            <script src="/vue/item/Detail/TabReview/store_v2.js?v=1.02"></script>
            <script src="/vue/item/Detail/TabReview/index_v2.js?v=1.06"></script>
		</div>
		<div id="tab04" class="pdtQnaV16a" style="display:none;"></div>
		<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
		<!-- //추가 tab -->
		<% '// 강제 width값 100% table%>
	</div>
</div>
<script>
	$(function(){
		// 브라우저 상태에 따라 iframe 높이값 조정
		var frm = document.getElementById("itemPrdDetail");

		if( frm !== null ) {

			let timer = setInterval(function() {
                const iframeDoc = frm.contentDocument || frm.contentWindow.document;
                if (iframeDoc.readyState == 'complete') {
                    removeInvalidImage(frm.contentWindow.document);
                    iframeLoaded();
                    correctionIframeHeight(frm);
                    imageCheck(frm.contentWindow.document);
                    clearInterval(timer);
                }
			}, 500);

			function iframeLoaded() {

			    // 로딩바 있으면 제거
                if( document.getElementById('prdDetailLoadingPlayer') ) {
                    document.getElementById('prdDetailLoadingPlayer').remove();
                }

				resizeIframe(frm);

				var uagentLow = navigator.userAgent.toLocaleLowerCase(), chrome25, kitkatWebview;
				const tab01 = document.getElementById('pdtDetailTab01');
				const tab_button = document.getElementById('buttonProductDetailContents');
				const content = frm.contentWindow.document.getElementById('itemContView');

				if( content.offsetHeight > 1700 ) {
					tab01.style.overflow = 'hidden';
					tab_button.style.display = 'block';
					collapseDetailArea(tab01, tab_button);

					tab_button.addEventListener('click', function() {
						if(uagentLow.search("android") > -1){
							chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
							kitkatWebview = uagentLow.indexOf("naver") != -1 || uagentLow.indexOf("daum") != -1;
							if (chrome25 && !kitkatWebview){
								$('html, body').animate({scrollTop: $(window).scrollTop()}, 1);
							}
						}

						if( tab_button.classList.contains('off') ) {
							openDetailArea(tab01, tab_button); // 상세설명 펼치기
						} else {
							collapseDetailArea(tab01, tab_button); // 상세설명 접기
						}
					});
				} else {
					tab_button.style.display = 'none';
				}

				// 모웹 회전시
				window.addEventListener("orientationchange", function() {
					setTimeout(function() {
						resizeIframe(frm);
					}, 300);
				});
				// 상세설명 펼치기
				function openDetailArea(tab01, tab_button) {
					tab01.style.height = '100%';
					tab_button.classList.remove('off');
					tab_button.classList.add('on');
					tab_button.innerHTML = `상품설명 접기<span class='up-fold'></span>`;
				}
				// 상세설명 접기
				function collapseDetailArea(tab01, tab_button) {
					tab01.style.height = '110rem';
					tab_button.classList.remove('on');
					tab_button.classList.add('off');
					tab_button.innerHTML = `상품설명 펼쳐서 보기<span class='down-open'></span>`;
				}
			}

			// 이미지 체크
			function imageCheck(doc) {
				const imageArr = doc.querySelectorAll('img');
				for( let i=0 ; i<imageArr.length ; i++ ) {
					if( imageArr[i].naturalHeight === 0 ) {
						sendImageErrorLogOne(imageArr[i].src);
					}
				}
			}
			// 이미지 에러 logone 전송
			function sendImageErrorLogOne(src) {
			    let apiurl;
                if( unescape(location.href).includes('//localhost') || unescape(location.href).includes('//testm') || unescape(location.href).includes('//localm') ) {
                    apiurl = 'http://testfapi.10x10.co.kr/api/web/v1';
                } else {
                    apiurl = 'http://fapi.10x10.co.kr/api/web/v1';
                }

				$.ajax({
					type : 'POST',
					url: apiurl + '/logone',
					data: {
						"data": {
							"event_name": "image_load_error",
							"type": "product",
							"id": "<%=itemid%>",
							"image_url": src
						}
					},
					ContentType : "json",
					crossDomain: true,
					async: false,
					xhrFields: {
						withCredentials: true
					}
				});
			}

            function resizeIframe(obj, fix_height = 0) {
                obj.style.height = 0;
                obj.style.height = obj.contentWindow.document.body.scrollHeight + fix_height + 'px';
            }

			// 못 불러온 이미지 제거
            function removeInvalidImage(document) {
                document.querySelectorAll('img').forEach(img => {
                    if(img.naturalWidth === 0) {
                        img.remove();
                    }
                });
            }

            // Iframe height 보정
            function correctionIframeHeight(frm) {
			    setTimeout(() => {
			        const frmHeight = Number(frm.style.height.replace('px', ''));
			        const frmBodyHeight = frm.contentWindow.document.body.scrollHeight;
			        if(frmHeight + 100 < frmBodyHeight ) {
			            resizeIframe(frm, frmBodyHeight - frmHeight + 50);
			        }
			    }, 1000);
            }
		}
	})(jQuery);
</script>