<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<%
'###########################################################
' Description :  play - ground
' History : 2014-10-30 이종화 생성
'###########################################################
	Dim idx, i, contentsidx, playcode, arrlist
		idx = getNumeric(requestCheckVar(request("idx"),10))
		contentsidx = getNumeric(requestCheckVar(request("contentsidx"),10))

	playcode = 1 '메뉴상단 번호를 지정

	if idx="" then
		response.write "<script type='text/javascript'>alert('그라운드 번호가 없습니다.'); location.history.back();</script>"
		dbget.close() : response.end
	end if
	if contentsidx="" then
		response.write "<script type='text/javascript'>alert('그라운드 상세번호가 없습니다.'); location.history.back();</script>"
		dbget.close() : response.end
	end if

	dim oPlayground
	set oPlayground = new CPlay
		oPlayground.frectcontentsidx = contentsidx
		oPlayground.FRectIdx = idx
		oPlayground.FRectType = playcode
		oPlayground.FRectUserID = getloginuserid
		oPlayground.GetRowGroundSub_review()

	dim oPlaygroundItem
	Set oPlaygroundItem = new CPlay
		oPlaygroundItem.frectcontentsidx = contentsidx
		oPlaygroundItem.FPageSize=50
		oPlaygroundItem.FCurrPage=1
		oPlaygroundItem.getPlayGrounditem()

	dim oplaydetail
	set oplaydetail = new CPlay
		oplaydetail.FPageSize = 1
		oplaydetail.FRectIdx = idx
		oplaydetail.fnPlaydetail_one

	If idx <> "" Then
		Call fnViewCountPlus(idx)
	End If
%>
<%'페이스북용 메타태그 %>
<meta property="og:title" content="<%=oplaydetail.FOneItem.ftitle%>"/>
<meta property="og:description" content="<%=oplaydetail.FOneItem.ftitle%>"/>
<meta property="og:type" content="website"/>
<meta property="og:url" content="http://m.10x10.co.kr/play/playGround.asp?idx=<%=idx%>&contentsidx=<%=contentsidx%>"/>
<meta property="og:image" content="<%=oplaydetail.FOneItem.flistimg%>"/>
<link rel="image_src" href="<%=oplaydetail.FOneItem.flistimg%>"/>
<%'페이스북용 메타태그 %>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content ground bgGry" id="contentArea">
				<div class="playCont">
					<span class="type" onclick="location.href='/play/index.asp?type=<%= playcode %>'; return false;">GROUND</span>
					<p class="tit"><strong><%= oplaydetail.FOneItem.ftitle %></strong><span><%=oplaydetail.FOneItem.Fviewno%>&nbsp;<%=oplaydetail.FOneItem.Fviewnotxt%></span></p>
					<p id="mywish<%=oPlayground.FOneItem.Fsubidx%>" class="circleBox wishView <%=chkiif(oPlayground.FOneItem.Fchkfav > 0 ,"wishActive","")%>" <% If getloginuserid <> "" Then %>onclick="TnAddPlaymywish('<%=playcode%>','<%=oPlayground.FOneItem.Fsubidx%>','<%=oplaydetail.FOneItem.Fviewno %>');"<% Else %>onclick="jsChklogin_mobile('','<%=Server.URLencode(CurrURLQ())%>');"<% End If %>><span>찜하기</span></p>
				</div>
				<div class="groundSection">
					<div class="groundCont">
					<% If oPlayground.FOneItem.Fmo_exec_check = "1" Or oPlayground.FOneItem.Fmo_exec_check = "" Or isnull(oPlayground.FOneItem.Fmo_exec_check) Then %>
						<%=oPlayground.FOneItem.Fmo_contents%>
					<% else %>
						<% If checkFilePath(server.mappath(oPlayground.FOneItem.Fmo_contents)) Then %>
						<% server.execute(oPlayground.FOneItem.Fmo_contents)%>
						<% Else %>
						<%=oPlayground.FOneItem.Fmo_contents%>
						<% End If %>
					<% End If %>
					</div>
				</div>

				<% if oPlaygroundItem.fresultcount>0 then %>
				<div class="inner10">
					<h2 class="tit02 tMar30"><span>관련 상품</span></h2>
					<div class="pdtListWrap">
						<ul class="pdtList">
							<% for i = 0 to oPlaygroundItem.fresultcount -1 %>
							<li onclick="" <% if oPlaygroundItem.FItemList(i).IsSoldOut then %>class='soldOut'<% end if %>>									
								<div class="pPhoto">
									<% if oPlaygroundItem.FItemList(i).IsSoldOut then %><p><span><em>품절</em></span></p><% end if %>
									<img src="<%= oPlaygroundItem.FItemList(i).FImageicon1 %>" onclick="TnGotoProduct('<%=oPlaygroundItem.FItemList(i).FItemid%>'); return false;" alt="<%= chrbyte(oPlaygroundItem.FItemList(i).FItemName,30,"Y") %>">
								</div>
								<div class="pdtCont">
									<p class="pBrand" onclick="TnGotoProduct('<%=oPlaygroundItem.FItemList(i).FItemid%>'); return false;"><%= oPlaygroundItem.FItemList(i).Fsocname %></p>
									<p class="pName" onclick="TnGotoProduct('<%=oPlaygroundItem.FItemList(i).FItemid%>'); return false;"><%= chrbyte(oPlaygroundItem.FItemList(i).FItemName,30,"Y") %></p>
									<p class="pPrice" onclick="TnGotoProduct('<%=oPlaygroundItem.FItemList(i).FItemid%>'); return false;">
										<%
											IF oPlaygroundItem.FItemList(i).IsSaleItem or oPlaygroundItem.FItemList(i).isCouponItem Then
												If  oPlaygroundItem.FItemList(i).getRealPrice <> oPlaygroundItem.FItemList(i).FSellCash then
													IF oPlaygroundItem.FItemList(i).IsSaleItem then
										%>
													<%=FormatNumber(oPlaygroundItem.FItemList(i).getRealPrice,0) %>원
										<%
													End If
													IF oPlaygroundItem.FItemList(i).IsCouponItem then
										%>
													<%= FormatNumber(oPlaygroundItem.FItemList(i).GetCouponAssignPrice,0)%>원
										<%
													End If
												Else
										%>
													<%= FormatNumber(oPlaygroundItem.FItemList(i).GetCouponAssignPrice,0)%>원
										<%
												End If
											ELSE
										%>
												<%= FormatNumber(oPlaygroundItem.FItemList(i).FSellCash,0)%>원
										<%
											End If
										%>								
									</p>
								</div>
							</li>
							<% next %>	
						</ul>
					</div>
				</div>
				<% end if %>

				<div class="inner10">
					<ul class="tagList">
						<%=fngetTagList(playcode, contentsidx, "mobile") %>
					</ul>
				</div>

				<!-- RECENT CONTENT -->
				<!-- #include virtual="/play/incRecentContents.asp" -->
				<!--// RECENT CONTENT -->
				<div id="tempdiv" style="display:none" ></div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<script>
function jsevtlogin(){
	if(confirm("로그인 후에 응모하실 수 있습니다.")) {
		self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
	}
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){

	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
		src: imageurl,
		width: width,
		height: height
		},
		webButton: {
			text: '10x10 바로가기',
			url: linkurl
		}
	});
}
</script>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
</body>
</html>
<%
set oPlayground=nothing
set oPlaygroundItem=nothing
set oplaydetail=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->