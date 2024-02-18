<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim scType, sCategory, sCateMid, vIsMine
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		= requestCheckVar(Request("ismine"),1)
	
	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

	'파라미터값 받기 & 기본 변수 값 세팅
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	IF iCurrpage = "" THEN	iCurrpage = 1


	iPageSize = 15
	iPerCnt = 4		'보여지는 페이지 간격


	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 		= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 		= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	arrList = cShopchance.fnGetBannerList	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 			'배너리스트 총 갯수
	set cShopchance = nothing

	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: EVENT</title>
<script type="text/javascript">
function jsGoPage(iP){
	document.frmSC.iC.value = iP;
	document.frmSC.action = "shoppingchance_allevent.asp";
	document.frmSC.submit();
}

function jsIsMine(a){
<% If IsUserLoginOK() Then %>
	document.frmSC.iC.value = 1;
	document.frmSC.ismine.value = a;
	document.frmSC.action = "shoppingchance_allevent.asp";
	document.frmSC.submit();
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

function jsSelOp(a){ //이벤트정렬
	document.frmSC.iC.value = 1;
	document.frmSC.selOP.value = a;
	document.frmSC.action = "shoppingchance_allevent.asp";
	document.frmSC.submit();
}

function changeCate(d){
	document.frmSC.iC.value = 1;
	document.frmSC.disp.value = d;
	document.frmSC.action = "shoppingchance_allevent.asp";
	document.frmSC.submit();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content evtMain" id="contentArea">
				<div class="inner5">
					<div class="btnCouponbook"><span><a href="/shoppingtoday/couponshop.asp"><em>쿠폰북</em></a></span></div>

					<div class="sorting">
					<% If vIsMine = "o" Then %>
						<p class="all disabled">
							<select name="disp" class="selectBox" title="카테고리 선택" disabled>
								<%=DrawSelectBoxDispCategory(sCategory,"1") %>
							</select>
						</p>
						<p><span class="button"><a href="" onClick="document.frmSC.ismine.value=''; jsSelOp('0'); return false;">신규순</a></span></p>
						<p><span class="button"><a href="" onClick="document.frmSC.ismine.value=''; jsSelOp('2'); return false;">인기순</a></span></p>
						<p<%=CHKIIF(vIsMine="o"," class=selected","")%>><span class="button myEvt"><a href="" onClick="jsIsMine('<%=CHKIIF(vIsMine="o","","o")%>'); return false;"><em>MY</em></a></span></p>
					<% Else %>
						<p class="all">
							<select name="disp" class="selectBox" title="카테고리 선택" onChange="changeCate(this.value)">
								<%=DrawSelectBoxDispCategory(sCategory,"1") %>
							</select>
						</p>
						<p<%=CHKIIF(selOp="0"," class=selected","")%>><span class="button"><a href="" onClick="jsSelOp('0'); return false;">신규순</a></span></p>
						<p<%=CHKIIF(selOp="2"," class=selected","")%>><span class="button"><a href="" onClick="jsSelOp('2'); return false;">인기순</a></span></p>
						<p<%=CHKIIF(vIsMine="o"," class=selected","")%>><span class="button myEvt"><a href="" onClick="jsIsMine('<%=CHKIIF(vIsMine="o","","o")%>'); return false;"><em>MY</em></a></span></p>
					<% End If %>
					</div>

					<%	
						'### 배열번호
						' 0 ~ 7  : A.evt_code, B.evt_bannerimg, A.evt_startdate, A.evt_enddate, A.evt_kind, B.brand,B.evt_LinkType ,B.evt_bannerlink '
						' 8		 : ,(Case When A.evt_kind=13 Then (Select top 1 itemid from [db_event].[dbo].[tbl_eventitem] where evt_code=A.evt_code order by itemid desc) else 0 end) as itemid '
						' 9 ~ 20 : , B.evt_bannerimg_mo, A.evt_name, B.issale, B.isgift, B.iscoupon, B.isOnlyTen, B.isoneplusone, B.isfreedelivery, B.isbookingsell, B.iscomment, B.etc_itemid, A.evt_subcopyK '
						'21		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select isNull(basicimage600,'''') from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage600 '
						'22		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select basicimage from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage '
						'23	~ 24 : , A.evt_subname, B.evt_mo_listbanner '

						Dim vLink, vIcon
						
						IF isArray(arrList) THEN %>
						<ul class="evtList">
							<%
							For intLoop =0 To UBound(arrList,2)
								IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
									vLink = "location.href='" & arrList(7,intLoop) & "';"
								ELSE
									vLink = "javascript:TnGotoEventMain('" & arrList(0,intLoop) & "');"
								END IF
								

								If arrList(12,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
								If arrList(18,intLoop) AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
								If arrList(15,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
								
								'If arrList(11,intLoop) Then vIcon = "" End IF
								'If arrList(13,intLoop) Then vIcon = "" End IF
								'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF
							%>
								<li onclick="<%=vLink%>">
									<div class="pic"><img src="<%=arrList(24,intLoop)%>" alt="<%=db2html(arrList(10,intLoop))%>" /></div>
									<dl>
										<dt>
											<%=Replace(db2html(arrList(10,intLoop)),"[☆2015 다이어리]","")%>
											<%=vIcon%>
										</dt>
										<dd><%=db2html(arrList(23,intLoop))%></dd>
									</dl>
								</li>
							<%
								vLink = ""
								vIcon = ""
								Next %>
						</ul>
					 <% Else %>
					<div class="tMar20">
						<div class="noData">
						<%=chkIIF(vIsMine="o","<p>등록된 관심 이벤트가 없습니다.</p>","<p>진행중인 이벤트가 없습니다.</p>")%>
						</div>
					</div>
					<% End If %>
					
					<%= fnDisplayPaging_New(iCurrpage, iTotCnt, iPageSize, iPerCnt,"jsGoPage") %>
					<form name="frmSC" method="get" action="shoppingchance_allevent.asp" style="margin:0px;">
					<input type="hidden" name="iC" >
					<input type="hidden" name="scT" value="<%=scType%>">
					<input type="hidden" name="disp" value="<%=sCategory%>">
					<input type="hidden" name="selOP" value="<%=selOP%>">
					<input type="hidden" name="ismine" value="<%=vIsMine%>">
					</form>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>