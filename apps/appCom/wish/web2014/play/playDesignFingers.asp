<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim vIdx, vContentsIdx, vTitle, vViewNo, vViewNoTxt, vChkFav , playcode, vListImg
	vIdx = requestCheckVar(Request("idx"),10)
	vContentsIdx = requestCheckVar(Request("contentsidx"),10)

	playcode = 4 '메뉴상단 번호를 지정
	
	dim oplaydetail
		set oplaydetail = new CPlay
		oplaydetail.FPageSize = 1
		oplaydetail.FRectIdx = vIdx
		oplaydetail.fnPlaydetail_one
		
		vTitle = oplaydetail.FOneItem.ftitle
		vViewNo = oplaydetail.FOneItem.fviewno
		vViewNoTxt = oplaydetail.FOneItem.fviewnotxt
		vListImg = oplaydetail.FOneItem.flistimg
		set oplaydetail = Nothing
		
		If IsUserLoginOK() Then
			vChkFav = fnChkFav(4,vContentsIdx)
		End IF
	
	Dim clsDF, clsDFComm, ix, arrComm
	Dim iDFSeq,sTitle,txtContents,dPrizeDate, sCommentTxt, sDFType, sTopImgURL
	Dim arrImg3dv, arrImgAdd, arrWinner, intLoop, iWishListCurrentPage, iLC, sOpenDate
	Dim i, k, iComCurrentPage, iTotCnt, arrMainList, arrCateList, arrRecentComm, arrMain, arrMainWishList, iTotWishCnt
	Dim iRecentDFS, sRecentImgURL, sRecentTitle, iCate, sSort, sSearchTxt
	Dim arrProdName, arrProdSize, arrProdColor, arrProdJe, arrProdGu, arrProdSpe, sEventLeftImg, sEventRightImg
	
	IF iComCurrentPage = "" THEN iComCurrentPage = 1
	set clsDF = new CDesignFingers
		clsDF.FDFSeq = vContentsIdx
		clsDF.fnGetDFContents

		iDFSeq			= clsDF.FDFSeq
		sDFType 		= clsDF.FDFType
		sTitle 			= clsDF.FTitle
		txtContents 	= clsDF.FContents
		dPrizeDate 		= clsDF.FPrizeDate
		sCommentTxt		= clsDF.FCommentTxt
		arrProdName		= clsDF.FProdName
		arrProdSize		= clsDF.FProdSize
		arrProdColor	= clsDF.FProdColor
		arrProdJe		= clsDF.FProdJe
		arrProdGu		= clsDF.FProdGu
		arrProdSpe		= clsDF.FProdSpe
		sOpenDate		= clsDF.FOpenDate

		sTopImgURL		= clsDF.FTopImgURL
		sEventLeftImg	= clsDF.FEventLeftImg
		sEventRightImg	= clsDF.FEventRightImg
		arrImg3dv		= clsDF.FArrImg3dv
		arrImgAdd		= clsDF.FArrImgAdd
		arrWinner		= clsDF.FArrWinner
	
	If vIdx <> "" Then
		Call fnViewCountPlus(vIdx)
	End If
	
	'// 쇼셜서비스로 글보내기 (2015.10.23; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg
	snpTitle = Server.URLEncode(vTitle)
	snpLink = Server.URLEncode(wwwUrl&"/play/playDesignFingers.asp?idx="&vIdx&"&contentsidx="&vContentsIdx)
	snpPre = Server.URLEncode("10x10 PLAY DESIGN FINGERS")
	If vListImg <> "" Then 
		snpImg = Server.URLEncode(vListImg)
	End If
%>
<title>10x10: PLAY</title>
<script>
$(function() {
	//창 타이틀 변경
	fnAPPchangPopCaption("PLAY");
});
// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}
function DelComments(v){
	if (confirm('삭제 하시겠습니까?')){
		document.frmact.sM.value= "D";
		document.frmact.id.value = v;
		document.frmact.submit();
	}
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content dFingers bgGry" id="contentArea">
			<div class="playCont">
				<span class="type" onclick="fnAPPopenerJsCallClose('jsChangeType(\'<%= playcode %>\')');return false;">DESIGN FINGERS</span>
				<p class="tit"><strong><%=vTitle%></strong><span><%=vViewNo%></span></p>
				<p id="mywish<%=iDFSeq%>" class="circleBox wishView <%=chkiif(vChkFav > 0 ,"wishActive","")%>" <% If getloginuserid <> "" Then %>onclick="TnAddPlaymywish('4','<%=iDFSeq%>','');"<% Else %>onclick="calllogin();"<% End If %>><span>찜하기</span></p>
			</div>
			<div class="dFingersCont">
				<!--<p><%=txtContents%></p>//-->
				<%
					Dim vFImage, vFUseMap
					For intLoop = 1 To ubound(arrImgAdd)
						If arrImgAdd(intLoop,3) = "24" Then
							IF arrImgAdd(intLoop,1) <> "" THEN
								vFImage = vFImage & "<p><img src=""" & arrImgAdd(intLoop,1) & """ usemap=""#add" & arrImgAdd(intLoop,0) & "Map"" />"
								If arrImgAdd(intLoop,2) <> "" Then
									vFUseMap = vFUseMap & "" & arrImgAdd(intLoop,2) & "</p>"
								End If
							Else
								vFImage = vFImage & "" & arrImgAdd(intLoop,2) & "</p>"
							END IF
							
						END IF
					Next
					Response.Write vFImage
					Response.Write vFUseMap
				%>
			</div>

			<% IF clsDF.FResultCount > 0 THEN %>
			<div class="inner10">
				<h2 class="tit02 tMar30"><span>관련 상품</span></h2>
				<div class="pdtListWrap">
					<ul class="pdtList">
					<% For i = 0 To (clsDF.FResultCount-1) %>
						<li onclick="location.href='/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<% = clsDF.FCategoryPrdList(i).FItemID %>';" class="soldOut">
							<div class="pPhoto">
								<% IF clsDF.FCategoryPrdList(i).IsSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
								<img src="<% = clsDF.FCategoryPrdList(i).FImageBasic %>" alt="<% = clsDF.FCategoryPrdList(i).FItemName %>" /></div>
							<div class="pdtCont">
								<p class="pBrand"><% = clsDF.FCategoryPrdList(i).FBrandName %></p>
								<p class="pName"><% = clsDF.FCategoryPrdList(i).FItemName %></p>
								<% IF clsDF.FCategoryPrdList(i).IsSaleItem or clsDF.FCategoryPrdList(i).isCouponItem Then %>
									<% IF clsDF.FCategoryPrdList(i).IsSaleItem Then %>
										<p class="pPrice"><% = FormatNumber(clsDF.FCategoryPrdList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = clsDF.FCategoryPrdList(i).getSalePro %>]</span></p>
									<% End IF %>
									<% IF clsDF.FCategoryPrdList(i).IsCouponItem Then %>
										<p class="pPrice"><% = FormatNumber(clsDF.FCategoryPrdList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = clsDF.FCategoryPrdList(i).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(clsDF.FCategoryPrdList(i).getRealPrice,0) %><% if clsDF.FCategoryPrdList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
							</div>
						</li>
					<% Next %>
					</ul>
				</div>
			</div>
			<% end if %>

			<%
				set clsDFComm = new CDesignFingersComment
				clsDFComm.FPageSize		= 3
				clsDFComm.FCurrPage		= 1
				clsDFComm.FRectFingerID = vContentsIdx
				clsDFComm.FRectSiteName = "10x10"
				clsDFComm.GetFingerUsing
			%>
			<!-- 댓글 리스트 -->
			<div class="inner5">
				<div class="replyList box1">
					<p class="total">총 <em class="cRd1"><%=clsDFComm.FTotalCount%></em>개의 댓글이 있습니다.</p>
					<ul>
					<% if clsDFComm.FResultcount<1 then %>
						<li>
							<p class="no-data ct">해당 게시물이 없습니다.<br /><br /></p>
						</li>
					<%else

						dim arrUserid, bdgUid, bdgBno
						'사용자 아이디 모음 생성(for Badge)
						for ix = 0 to clsDFComm.FResultcount-1
							arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(clsDFComm.FCommentList(ix).FUserID) & "''"
						next
	
						'뱃지 목록 접수(순서 랜덤)
						Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")

						dim nextCnt		'다음페이지 게시물 수
						if (clsDFComm.FTotalCount-(clsDFComm.FPageSize*clsDFComm.FCurrPage)) < clsDFComm.FPageSize then
							nextCnt = (clsDFComm.FTotalCount-(clsDFComm.FPageSize*clsDFComm.FCurrPage))
						else
							nextCnt = clsDFComm.FPageSize
						end if
		
						for ix=0 to clsDFComm.FResultcount-1 %>
						<li>
							<p class="num"><% = (clsDFComm.FTotalCount - (clsDFComm.FPageSize * clsDFComm.FPCount))- ix %>
								<% If clsDFComm.FCommentList(ix).FDevice <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
							<div class="replyCont">
								<p>
								<%
									if Not(clsDFComm.FCommentList(ix).FComment="" or isNull(clsDFComm.FCommentList(ix).FComment)) then
										arrComm = split(clsDFComm.FCommentList(ix).FComment,"||,||")
										Response.Write arrComm(0)
										'URL이 존재하고 본인 또는 STAFF가 접속해있다면 링크 표시
										if Ubound(arrComm)>0 then
											if trim(arrComm(1))<>"" and (GetLoginUserLevel=7 or clsDFComm.FCommentList(ix).FUserID=GetLoginUserID) then
												'Response.Write "<br /><strong>URL: </strong><a href='" & ChkIIF(left(trim(arrComm(1)),4)="http","","http://") & arrComm(1) & "' target='_blank'>" & arrComm(1) & "</a>"
											end if
										end if
									end if
								%>
								</p>
								<p class="tPad05">
									<% if ((GetLoginUserID = clsDFComm.FCommentList(ix).Fuserid) or (GetLoginUserID = "10x10")) and (clsDFComm.FCommentList(ix).Fuserid<>"") then %>
									<span class="button btS1 btWht cBk1"><a href="" onClick="DelComments('<% = clsDFComm.FCommentList(ix).FID %>'); return false;">삭제</a></span>
									<% End If %>
								</p>
								<div class="writerInfo">
									<p><% = FormatDate(clsDFComm.FCommentList(ix).FRegDate,"0000.00.00") %> <span class="bar">/</span> <% = printUserId(clsDFComm.FCommentList(ix).FUserID,2,"*") %></p>
									<p class="badge">
										<%=getUserBadgeIcon(clsDFComm.FCommentList(ix).FUserID,bdgUid,bdgBno,3)%>
									</p>
								</div>
							</div>
						</li>
						<% next %>
					<% end if %>
					</ul>
					<div class="btnWrap ct tPad15">
						<span class="button btM2 btRed cWh1 w30p"><a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/play/popComment.asp?view=w&contentsidx=<%=vContentsIdx%>'); return false;">쓰기</a></span>
						<span class="button btM2 btRedBdr cRd1 w30p"><a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/play/popComment.asp?view=l&contentsidx=<%=vContentsIdx%>'); return false;">전체보기</a></span>
					</div>
				</div>
			</div>
			<% set clsDFComm = nothing %>
			<!--// 댓글 리스트 -->

			<form name="frmact" method="post" action="/apps/appCom/wish/web2014/play/lib/dozfcomment.asp" style="margin:0px;" target="iframeDB">
			<input type="hidden" name="sM" value="D">
			<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
			<input type="hidden" name="masterid" value="<%= vContentsIdx %>">
			<input type="hidden" name="id" value="">
			<input type="hidden" name="uid" value="">
			<input type="hidden" name="iCC" value="<%=iComCurrentPage%>">
			<input type="hidden" name="tx_comment" value="">
			<input type="hidden" name="returnurl" value="/apps/appCom/wish/web2014/play/playDesignFingers.asp?idx=<%=vIdx%>&contentsidx=<%=vContentsIdx%>&comm=o">
			</form>
			<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0" style="display:block;"></iframe>

			<div class="bgLine"></div>

			<!-- RECENT CONTENT -->
			<!-- #include virtual="/apps/appCom/wish/web2014/play/incRecentContents.asp" -->
			<!--// RECENT CONTENT -->
			<div id="tempdiv" style="display:none" ></div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
<% If requestCheckVar(Request("comm"),1) = "o" Then %>
<script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
<% End If %>
<% If instr(uAgent,"ipod")>0 or instr(uAgent,"iphone")>0 or instr(uAgent,"ipad")>0 Then %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height-webview.js"></script>
<% elseif instr(uAgent,"android")>0 then %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
<% Else %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
<% End If %>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->