<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 최근 본 상품 
' History : 2017-05-12 원승현 
'		  : 2018-09-03 최종원 히스토리 상품 리스트에 장바구니 버튼 추가
'####################################################

	Dim referer, refip, i, myTodayShopping, sqlStr
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
		Response.End
	end If

	'// 로그인시에만 사용가능
	If not(IsUserLoginOK()) Then
		Response.Write "<script>alert('로그인이 필요한 서비스 입니다.');return false;</script>"
		Response.End
	End If



	Dim vTypeItem, vTypeEvt, vTypeMkt, vTypeBrand, vTypeRect, vMaxId, vStdnum, vPageSize, vPlatForm, lp, vOldRegDate, vMode, dItemId, dEvtCode, dRect, dRegdate, vUserid, dType
	Dim dChkCnt, dRtnCnt, evtNameSplit
	dim adultChkFlag, linkUrl

	'// list 관련
	vTypeItem = requestCheckVar(request("Rtypeitem"),10)
	vTypeEvt = requestCheckVar(request("Rtypeevt"),10)
	vTypeMkt = requestCheckVar(request("Rtypemkt"),10)
	vTypeBrand = requestCheckVar(request("Rtypebrand"),10)
	vTypeRect = requestCheckVar(request("Rtyperect"),10)
	vMaxId = requestCheckVar(request("Rmaxid"),10)
	vStdnum = requestCheckVar(request("Rstdnum"),10)
	vPageSize = requestCheckVar(request("Rpagesize"),10)
	vPlatForm = requestCheckVar(request("Rplatform"),10)
	vOldRegDate = requestCheckVar(request("ROldRegDate"),10)
	vMode = requestCheckVar(request("Rmode"),10)
	vUserid = tenDec(requestCheckVar(request("RUserId"),500))

	'// 삭제 관련
	dType =  requestCheckVar(request("DType"),10)
	dItemId =  requestCheckVar(request("DItemId"),30)
	dEvtCode =  requestCheckVar(request("DEvtCode"),30)
	dRect =  requestCheckVar(request("DRect"),50)
	dRegdate =  requestCheckVar(request("DRegdate"),15)


	'// 회원확인
	If vUserid <> getEncLoginUserId Then
		Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
		Response.End
	End If

	If Trim(vMode)="list" Then


		'// 모든값을 false로 하였을경우 컨텐츠가 없습니다를 띄운다.
		If Trim(vTypeItem) = "false" And Trim(vTypeEvt) = "false" And Trim(vTypeMkt) = "false" And Trim(vTypeBrand) = "false" And Trim(vTypeRect) = "false" Then
			response.write "<div class='nodata recent'>"
			response.write "		<p>히스토리가 없습니다.</p>"
			response.write "		<a href='' onclick='callmain();return false;' class='btnV16a btnRed2V16a'>쇼핑하러 가기</a>"
			response.write "</div>"
			Response.End
		end if

		Dim myRecentView, oldRegdate
		Set myRecentView = new CTodayShopping
		myRecentView.FRecttypeitem        = vTypeItem
		myRecentView.FRecttypeevt        = vTypeEvt
		myRecentView.FRecttypemkt     = vTypeMkt
		myRecentView.FRecttypebrand   = vTypeBrand
		myRecentView.FRecttyperect   = vTypeRect
		myRecentView.FRectUserid   = vUserid
		myRecentView.FRectmaxid   = vMaxId
		myRecentView.FRectstdnum   = vStdnum
		myRecentView.FRectpagesize   = vPageSize
		myRecentView.FRectplatform   = vPlatForm
		if vUserid<>"" then
			myRecentView.GetMyViewRecentViewList
		end If

%>

		<%' for dev msg : timeline 하루 묶음 입니다. %>
		<%' for dev msg :15일간의기록을 최근확인순으로노출 %>
		<% If myRecentView.FResultCount>0 Then %>
			<% 
			For lp=0 To myRecentView.FResultCount-1 								
				linkUrl = replace(Request.ServerVariables("PATH_INFO"), "act_recentview.asp","myrecentview.asp") & "?" & "adtprdid=" & myRecentView.FItemList(lp).FItemId
				adultChkFlag = session("isAdult") <> true and myRecentView.FItemList(lp).FadultType = 1																																			
			%>
				<% If vOldRegDate <> Trim(Left(myRecentView.FItemList(lp).FRegdate, 10)) Then %>
					<% If Trim(Left(oldRegdate, 10)) <> Trim(Left(myRecentView.FItemList(lp).FRegdate, 10)) Then %>
						<%' for dev msg : 1일전~3일전:문장으로표기. -그이후데이터는년/월/일로표기. 오늘은 본 컨텐츠는 날짜 표시 안됩니다. %>
						<% If Datediff("d", Now(), myRecentView.FItemList(lp).FRegdate) < 0 Then %>
							<% If Datediff("d", Now(), myRecentView.FItemList(lp).FRegdate) < -3 Then %>
								<div class="time" id="timeheadVal<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><%=Left(myRecentView.FItemList(lp).FRegdate, 4)&"."&Mid(myRecentView.FItemList(lp).FRegdate, 6, 2)&"."&Mid(myRecentView.FItemList(lp).FRegdate, 9, 2)%></div>
							<% Else %>
								<div class="time" id="timeheadVal<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><%=Datediff("d", Now(), myRecentView.FItemList(lp).FRegdate)*-1%><span>일전</span></div>
							<% End If %>
						<% End If %>
					<% End If %>
				<% End If %>


				<% Select Case Trim(myRecentView.FItemList(lp).Ftype) %>
					<% Case "item" %>
						<div class="section item" id="div<%=myRecentView.FItemList(lp).FIdx%>">
							<div class="inner">
								<% If myRecentView.FItemList(lp).FSellyn="N" Then %>
									<a href="" onclick="return false;">
								<% Else %>
									<% if adultChkFlag then %>										
										<a href="javascript:confirmAdultAuth('<%=Server.URLencode(linkUrl)%>', '<%=chkiif(IsUserLoginOK, "true", "false")%>');">
									<% else %>
										<a href="" onclick="fnAPPpopupProduct_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=myRecentView.FItemList(lp).FItemId%>&amp;gaparam=recentview_product_1');return false;">
									<% end if %>																		
								<% End If %>
									<%' for dev msg : alt값 상품명으로 달면 중복 인거 같아서 alt=""으로 처리해주세요 %>
									<div class="thumbnail">
										<img src="<%=myRecentView.FItemList(lp).FImageicon1%>" alt="" />
										<% if adultChkFlag then %>
										<div class="adult-hide">
											<p>19세 이상만<br>구매 가능한 상품입니다</p>
										</div>					
										<% end if %>												
									</div>
									<div class="desc">
										<span class="label">상품</span>
										<div class="name"><%=myRecentView.FItemList(lp).FItemName%></div>
										<div class="price">
											<% IF myRecentView.FItemList(lp).IsSaleItem Then %>
												<% IF myRecentView.FItemList(lp).IsSaleItem Then %>
													<s><% = FormatNumber(myRecentView.FItemList(lp).getOrgPrice,0) %></s> <b><% = FormatNumber(myRecentView.FItemList(lp).getRealPrice,0) %>원</b> <span class="cRd1">[<% = myRecentView.FItemList(lp).getSalePro %>]</span></p>
												<% End IF %>
											<% Else %>
												<b>
													<%
														If myRecentView.FItemList(lp).getRealPrice <> "" Then 
															response.write FormatNumber(myRecentView.FItemList(lp).getRealPrice, 0)
														End If
													%>
												</b>
												<% if myRecentView.FItemList(lp).IsMileShopitem then %>
													 Point
												<% else %>
													 원
												<% end if %>
											<% End if %>								
										</div>
									</div>
									<% If myRecentView.FItemList(lp).FSellyn="N" Then %>
										<p class="soldout">판매종료된 상품입니다</p>
									<% ElseIf myRecentView.FItemList(lp).IsSoldOut() Then %>
										<p class="soldout">일시품절된 상품입니다</p>
									<% End If %>
								</a>
								<button type="button" class="btnDel" onclick="btnDelCk(this, 'div<%=myRecentView.FItemList(lp).FIdx%>');" dt="<%=Trim(myRecentView.FItemList(lp).Ftype)%>" dit="<%=myRecentView.FItemList(lp).FItemId%>" devt="<%=myRecentView.FItemList(lp).Fevtcode%>" drect="<%=myRecentView.FItemList(lp).Frect%>" dregd="<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><span>삭제</span></button>								
							</div>
						</div>
					<% Case "brand" %>
						<div class="section brand" id="div<%=myRecentView.FItemList(lp).FIdx%>">
							<div class="inner">
								<% If myRecentView.FItemList(lp).FBrandUsing="N" Then %>
									<a href="" onclick="return false;">
								<% Else %>
									<a href="" onclick="fnAPPpopupBrand('<%=myRecentView.FItemList(lp).Fmakerid%>');return false;">
								<% End If %>
									<span class="label">브랜드</span>
									<div class="name"><%=myRecentView.FItemList(lp).FBrandName%></div>
									<% If myRecentView.FItemList(lp).FBrandUsing="N" Then %>
											<p class="soldout">판매종료된 브랜드입니다</p>
									<% End If %>
								</a>
								<button type="button" class="btnDel" onclick="btnDelCk(this, 'div<%=myRecentView.FItemList(lp).FIdx%>');" dt="<%=Trim(myRecentView.FItemList(lp).Ftype)%>" dit="<%=myRecentView.FItemList(lp).FItemId%>" devt="<%=myRecentView.FItemList(lp).Fevtcode%>" drect="<%=myRecentView.FItemList(lp).Frect%>" dregd="<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><span>삭제</span></button>
							</div>
						</div>

					<% Case "planevt" %>
						<div class="section exhibition" id="div<%=myRecentView.FItemList(lp).FIdx%>">
							<div class="inner">
								<% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then%>
									<a href="" onclick="return false;">
								<% Else %>
									<% If Trim(myRecentView.FItemList(lp).FevtUsingApp)="True" Then %>
										<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=myRecentView.FItemList(lp).Fevtcode%>&amp;gaparam=recentview_planevt_1');return false;">
									<% Else %>
										<% If myRecentView.FItemList(lp).FevtUsingPc="True" And myRecentView.FItemList(lp).FevtUsingMw="True" Then %>
											<a href="" onclick="alert('텐바이텐 PC나 텐바이텐 모바일에서만 볼 수 있는 기획전 입니다.');return false;">
										<% ElseIf myRecentView.FItemList(lp).FevtUsingPc="False" And myRecentView.FItemList(lp).FevtUsingMw="True" Then %>
											<a href="" onclick="alert('텐바이텐 모바일에서만 볼 수 있는 기획전 입니다.');return false;">
										<% ElseIf myRecentView.FItemList(lp).FevtUsingPc="True" And myRecentView.FItemList(lp).FevtUsingMw="False" Then %>
											<a href="" onclick="alert('텐바이텐 PC에서만 볼 수 있는 기획전 입니다.');return false;">
										<% End If %>
									<% End If %>
								<% End If %>
									<span class="label">기획전</span>
									<div class="name">
										<span class="word <% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then%>end<% End If %>">
											<%
												If myRecentView.FItemList(lp).Fevtname <> "" Then
													evtNameSplit = Split(myRecentView.FItemList(lp).Fevtname,"|")
													response.write evtNameSplit(0)
												End If
											%>
										</span>
										<% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then %>
											 <span class="tag">END</span>
										<% ElseIf Datediff("d", Now(), Left(myRecentView.FItemList(lp).Fevtenddate, 10)) = 0 Then %>
											 <span class="tag">오늘까지</span>
										<% ElseIf Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) > 0 Then %>
											<% If Datediff("d", Now(), Left(myRecentView.FItemList(lp).Fevtenddate, 10)) < 4 Then %>
												 <span class="tag">D-<%=Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate)%></span>
											<% End If %>
										<% End If %>
									</div>
									<% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then%>
										<p class="soldout">종료된 기획전입니다</p>
									<% End If %>
								</a>
								<button type="button" class="btnDel" onclick="btnDelCk(this, 'div<%=myRecentView.FItemList(lp).FIdx%>');" dt="<%=Trim(myRecentView.FItemList(lp).Ftype)%>" dit="<%=myRecentView.FItemList(lp).FItemId%>" devt="<%=myRecentView.FItemList(lp).Fevtcode%>" drect="<%=myRecentView.FItemList(lp).Frect%>" dregd="<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><span>삭제</span></button>
							</div>
						</div>

					<% Case "mktevt" %>
						<div class="section event" id="div<%=myRecentView.FItemList(lp).FIdx%>">
							<div class="inner">
								<% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then%>
									<a href="" onclick="return false;">
								<% Else %>
									<% If Trim(myRecentView.FItemList(lp).FevtUsingApp)="True" Then %>
										<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=myRecentView.FItemList(lp).Fevtcode%>&amp;gaparam=recentview_planevt_1');return false;">
									<% Else %>
										<% If myRecentView.FItemList(lp).FevtUsingPc="True" And myRecentView.FItemList(lp).FevtUsingMw="True" Then %>
											<a href="" onclick="alert('텐바이텐 PC나 텐바이텐 모바일에서만 볼 수 있는 이벤트 입니다.');return false;">
										<% ElseIf myRecentView.FItemList(lp).FevtUsingPc="False" And myRecentView.FItemList(lp).FevtUsingMw="True" Then %>
											<a href="" onclick="alert('텐바이텐 모바일에서만 볼 수 있는 이벤트 입니다.');return false;">
										<% ElseIf myRecentView.FItemList(lp).FevtUsingPc="True" And myRecentView.FItemList(lp).FevtUsingMw="False" Then %>
											<a href="" onclick="alert('텐바이텐 PC에서만 볼 수 있는 이벤트 입니다.');return false;">
										<% End If %>
									<% End If %>
								<% End If %>
									<span class="label">이벤트</span>
									<%' for dev msg : 종료된 이벤트에는 클래스명 end 넣어주세요 %>
									<div class="name">
										<span class="word <% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then%>end<% End If %>">
											<%
												If myRecentView.FItemList(lp).Fevtname <> "" Then
													evtNameSplit = Split(myRecentView.FItemList(lp).Fevtname,"|")
													response.write evtNameSplit(0)
												End If
											%>
										</span>
										<% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then %>
											 <span class="tag">END</span>
										<% ElseIf Datediff("d", Now(), Left(myRecentView.FItemList(lp).Fevtenddate, 10)) = 0 Then %>
											 <span class="tag">오늘까지</span>
										<% ElseIf Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) > 0 Then %>
											<% If Datediff("d", Now(), Left(myRecentView.FItemList(lp).Fevtenddate, 10)) < 4 Then %>
												 <span class="tag">D-<%=Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate)%></span>
											<% End If %>
										<% End If %>
									</div>
									<% If Datediff("d", Now(), myRecentView.FItemList(lp).Fevtenddate) < 0 Or myRecentView.FItemList(lp).Fevtstate="9" Then%>
										<p class="soldout">종료된 이벤트입니다</p>
									<% End If %>
								</a>
								<button type="button" class="btnDel" onclick="btnDelCk(this, 'div<%=myRecentView.FItemList(lp).FIdx%>');" dt="<%=Trim(myRecentView.FItemList(lp).Ftype)%>" dit="<%=myRecentView.FItemList(lp).FItemId%>" devt="<%=myRecentView.FItemList(lp).Fevtcode%>" drect="<%=myRecentView.FItemList(lp).Frect%>" dregd="<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><span>삭제</span></button>
							</div>
						</div>
					<% Case "rect" %>
						<div class="section searchword" id="div<%=myRecentView.FItemList(lp).FIdx%>">
							<div class="inner">
								<a href="" onclick="fnAPPpopupSearch('<%=myRecentView.FItemList(lp).Frect%>');return false;">
									<span class="label">검색어</span>
									<div class="name"><%=myRecentView.FItemList(lp).Frect%></div>
								</a>
								<button type="button" class="btnDel" onclick="btnDelCk(this, 'div<%=myRecentView.FItemList(lp).FIdx%>');" dt="<%=Trim(myRecentView.FItemList(lp).Ftype)%>" dit="<%=myRecentView.FItemList(lp).FItemId%>" devt="<%=myRecentView.FItemList(lp).Fevtcode%>" drect="<%=myRecentView.FItemList(lp).Frect%>" dregd="<%=Trim(Left(myRecentView.FItemList(lp).FRegdate, 10))%>"><span>삭제</span></button>
							</div>
						</div>
				<% End Select %>
				<% oldRegdate = Trim(Left(myRecentView.FItemList(lp).FRegdate, 10)) %>
			<% Next %>
			||<%=oldRegdate%>
		<% Else %>
			<%
				If vStdnum = "1" Then
					response.write "<div class='nodata recent'>"
					response.write "		<p>히스토리가 없습니다.</p>"
					response.write "		<a href='' onclick='callmain();return false;' class='btnV16a btnRed2V16a'>쇼핑하러 가기</a>"
					response.write "</div>"
				End If
			%>
		<% End If %>
		<%
			set myRecentView = Nothing
		%>
	<% ElseIf vMode="Del" Then %>
		<%
			If Trim(dType)="" Then
				Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
				Response.End
			End If
			If Trim(dRegdate)="" Then
				Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
				Response.End
			End If

			Select Case Trim(dType)
				Case "item"
					sqlStr = "select count(idx) "
					sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
					sqlStr = sqlStr + " where userid = '"&vUserid&"' And type='item' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And itemid='"&dItemId&"' "
					rsEVTget.Open sqlStr,dbEVTget,1
						dChkCnt = rsEVTget(0)
					rsEVTget.close

					If dChkCnt > 0 Then
						sqlStr = " Delete From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] "
						sqlStr = sqlStr & " Where userid='"&vUserid&"' And type='item' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And itemid='"&dItemId&"' "
						dbEVTget.execute sqlStr
					Else
						Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
						Response.End
					End If

				Case "planevt"
					sqlStr = "select count(idx) "
					sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
					sqlStr = sqlStr + " where userid = '"&vUserid&"' And type='planevt' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And evtcode='"&dEvtCode&"' "
					rsEVTget.Open sqlStr,dbEVTget,1
						dChkCnt = rsEVTget(0)
					rsEVTget.close

					If dChkCnt > 0 Then
						sqlStr = " Delete From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] "
						sqlStr = sqlStr & " Where userid='"&vUserid&"' And type='planevt' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And evtcode='"&dEvtCode&"' "
						dbEVTget.execute sqlStr
					Else
						Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
						Response.End
					End If

				Case "mktevt"
					sqlStr = "select count(idx) "
					sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
					sqlStr = sqlStr + " where userid = '"&vUserid&"' And type='mktevt' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And evtcode='"&dEvtCode&"' "
					rsEVTget.Open sqlStr,dbEVTget,1
						dChkCnt = rsEVTget(0)
					rsEVTget.close

					If dChkCnt > 0 Then
						sqlStr = " Delete From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] "
						sqlStr = sqlStr & " Where userid='"&vUserid&"' And type='mktevt' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And evtcode='"&dEvtCode&"' "
						dbEVTget.execute sqlStr
					Else
						Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
						Response.End
					End If

				Case "brand"
					sqlStr = "select count(idx) "
					sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
					sqlStr = sqlStr + " where userid = '"&vUserid&"' And type='brand' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And rect='"&Trim(dRect)&"' "
					rsEVTget.Open sqlStr,dbEVTget,1
						dChkCnt = rsEVTget(0)
					rsEVTget.close

					If dChkCnt > 0 Then
						sqlStr = " Delete From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] "
						sqlStr = sqlStr & " Where userid='"&vUserid&"' And type='brand' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And rect='"&Trim(dRect)&"' "
						dbEVTget.execute sqlStr
					Else
						Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
						Response.End
					End If

				Case "rect"
					sqlStr = "select count(idx) "
					sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
					sqlStr = sqlStr + " where userid = '"&vUserid&"' And type='rect' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And rect='"&Trim(dRect)&"' "
					rsEVTget.Open sqlStr,dbEVTget,1
						dChkCnt = rsEVTget(0)
					rsEVTget.close

					If dChkCnt > 0 Then
						sqlStr = " Delete From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] "
						sqlStr = sqlStr & " Where userid='"&vUserid&"' And type='rect' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' And rect='"&Trim(dRect)&"' "
						dbEVTget.execute sqlStr
					Else
						Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
						Response.End
					End If

			Case Else
				Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
				Response.End
			End Select

			sqlStr = "select count(idx) "
			sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
			sqlStr = sqlStr + " where userid = '"&vUserid&"' And convert(varchar(10), regdate, 120) = '"&dRegdate&"' "
			rsEVTget.Open sqlStr,dbEVTget,1
				dRtnCnt = rsEVTget(0)
			rsEVTget.close

			response.write dRtnCnt&"||"&dRegdate
			Response.End
		%>
	<% Else %>
		<%
			Response.Write "<script>alert('잘못된 접속입니다.');return false;</script>"
			Response.End
		%>
	<% End If %>
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->