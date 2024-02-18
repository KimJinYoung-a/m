<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/gnbevent/shoppingchanceCls_B_chuseok2021.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/event/mktevtbannerCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'// 2021년 추석관련 기획전 리스트
'// 종료 후 삭제 예정

'session.codepage=65001
	'// pc일경우 m -> pc 리다이렉트
	Dim redirect_url : redirect_url = fnRedirectToPc()
	If redirect_url <> "" Then
		dbget.close()
		Response.redirect redirect_url & "/shoppingtoday/shoppingchance_allevent.asp?gaparam=main_menu_event"
		Response.end
	End If

	Dim scType, scTypegb, sCategory, sCateMid, vIsMine, ddayicon
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop, fixBanner
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	Dim cMktbanner , sqlStr , arrMktevt , mPageSize , MktCnt
	Dim eName, eNameredsale, eNamegreensale, addTag, ip

	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		= requestCheckVar(Request("ismine"),1)

	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

'	strHeadTitleName = "기획전"

	'파라미터값 받기 & 기본 변수 값 세팅
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	scTypegb 		= requestCheckVar(Request("scTgb"),10) '마케팅이벤트/기획전 이벤트 분류 2016-05-02 유태욱
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "2"
	End if

	If scTypegb = "" then		''planevt - 기획전 , mktevt - 마케팅 이벤트
		scTypegb = "planevt"
	end if

	IF iCurrpage = "" THEN	iCurrpage = 1

	iPageSize = 15  '이벤트 배너
	iPerCnt = 4		'보여지는 페이지 간격

	mPageSize = CInt(iPageSize/5) '//마케팅 배너

	'배너 데이터 가져오기 2015-06-11 이종화 추가
	Dim i , gubun , mktimg , m_eventid , a_eventid , isurl
	reDim vHtml(10)
	set cMktbanner = new CEvtMktbanner
	cMktbanner.FPageSize	=	mPageSize '//5개당 1개 노출
	cMktbanner.FCurrPage	=	iCurrpage
	cMktbanner.Fdevice		=	"M"
	If scTypegb = "mktevt" then
		cMktbanner.Fevtgubun		=	2
	else
		cMktbanner.Fevtgubun		=	1
	end if
	cMktbanner.GetMktBannerList()
	MktCnt		= cMktbanner.FResultCount

	If MktCnt > 0 Then
		FOR i=0 to cMktbanner.FResultCount-1
			gubun				= cMktbanner.FItemList(i).Fgubun
			mktimg				= cMktbanner.FItemList(i).Fmktimg
			m_eventid			= cMktbanner.FItemList(i).Fm_eventid
			a_eventid			= cMktbanner.FItemList(i).Fa_eventid

			if m_eventid = 70670 then
				if scTypegb = "planevt" then
					isurl = "/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt"
				elseif scTypegb = "mktevt" then
					isurl = "/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt"
				else
					isurl = "/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt"
				end if
			else
				isurl = "/event/eventmain.asp?eventid="& m_eventid
			end if

			vHtml(i) = "<li class='ad-bnr'><a href="""" onclick=""location.href='"& isurl &"';return false;"" ><div class=""thumbnail""><img src="""&mktimg&""" alt="""" /></div></a></li>"
		Next
	End If
	Set cMktbanner = Nothing

	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 			= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCTypegb		= scTypegb    	'이벤트구분(기획전,마케팅)
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 			= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	cShopchance.FFixEvtCode		= ChkIif(Application("Svr_Info")="Dev","88994","116585")		'상단고정 이벤트코드
	arrList = cShopchance.fnGetBannerList("N")	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 			'배너리스트 총 갯수
	fixBanner = cShopchance.fnGetTopFixBanner
	set cShopchance = nothing

	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">

function jsGoPage(iP){
	document.frmSC.iC.value = iP;
	document.frmSC.action = "all_event_chuseok2021.asp";
	document.frmSC.submit();
}

function jsIsMine(a,b){
<% If IsUserLoginOK() Then %>
	document.frmSC.iC.value = 1;
	document.frmSC.ismine.value = a;
	document.frmSC.scTgb.value = b;
	document.frmSC.action = "all_event_chuseok2021.asp";
	document.frmSC.submit();
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

function jsSelOp(a){ //이벤트정렬
	document.frmSC.iC.value = 1;
	document.frmSC.selOP.value = a;
	document.frmSC.action = "all_event_chuseok2021.asp";
	document.frmSC.submit();
}

function changeCate(d){
	document.frmSC.iC.value = 1;
	document.frmSC.disp.value = d;
	document.frmSC.action = "all_event_chuseok2021.asp";
	document.frmSC.submit();
}

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_all_event_chuseok2021.asp?scTgb=<%=scTypegb%>&scT=<%=scType%>&disp=<%=sCategory%>&selOP=<%=selOp%>&ismine=<%=vIsMine%>&iC="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});
</script>
</head>
<body class="default-font body-main"><%' for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. %>
<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<!-- exhibition/event list -->
		<section id="exhibitionList" class="exhibition-list">
			<h2 class="hidden"><%=CHKIIF(scTypegb="planevt","기획전","이벤트")%></h2>
			<% if vIsMine = "o" then %>
				<ul class="commonTabV16a">
					<li class="<%=chkiif(scTypegb="planevt","current","")%>" name="tab01" onClick="jsIsMine('o','planevt'); return false;" style="width:50%;">기획전</li>
					<li class="<%=chkiif(scTypegb="mktevt","current","")%>" name="tab02" onClick="jsIsMine('o','mktevt'); return false;" style="width:50%;">이벤트</li>
				</ul>
			<% else %>
				<% If scTypegb <> "bw" Then '//슈퍼루키(브랜드위크) 없을때만 노출 %>
					<div class="sortingbar">
						<div class="option-left">
							<p class="total"><b><%= iTotCnt %></b>건</p>
						</div>

						<div class="option-right">
							<div class="styled-selectbox styled-selectbox-default">
								<select class="select" onchange="changeCate(this.value);" title="카테고리 선택옵션">
									<% if scTypegb = "mktevt" then %>
										<option selected="selected" value="">전체</option>
										<option value="">마케팅 이벤트</option>
									<% else %>
										<%=DrawSelectBoxDispCategory(sCategory,"1") %>
									<% end if %>
								</select>
							</div>
							<div class="styled-selectbox styled-selectbox-default">
								<select class="select" onchange="jsSelOp(this.value);" title="정렬 선택옵션">
									<option <%=CHKIIF(selOp="0","selected='selected'","")%>  value="0" >신규순</option>
									<% if scTypegb = "planevt" then %>
										<option <%=CHKIIF(selOp="2","selected='selected'","")%> value="2" >인기순</option>
									<% end if %>
									<option <%=CHKIIF(selOp="1","selected='selected'","")%> value="1">마감임박순</option>
									<option <%=CHKIIF(selOp="3","selected='selected'","")%> value="3">할인율순</option>
								</select>
							</div>
						</div>
					</div>
				<% end if %>
			<% end if %>


			<%
			'### 배열번호
			' 0 ~ 7  : A.evt_code, B.evt_bannerimg, A.evt_startdate, A.evt_enddate, A.evt_kind, B.brand,B.evt_LinkType ,B.evt_bannerlink '
			' 8		 : ,(Case When A.evt_kind=13 Then (Select top 1 itemid from [db_event].[dbo].[tbl_eventitem] where evt_code=A.evt_code order by itemid desc) else 0 end) as itemid '
			' 9 ~ 20 : , B.evt_bannerimg_mo, A.evt_name, B.issale, B.isgift, B.iscoupon, B.isOnlyTen, B.isoneplusone, B.isfreedelivery, B.isbookingsell, B.iscomment, B.etc_itemid, A.evt_subcopyK '
			'21		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select isNull(basicimage600,'''') from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage600 '
			'22		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select basicimage from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage '
			'23	~ 24 : , A.evt_subname, B.evt_mo_listbanner '

			Dim vLink, vIcon , vRnum
			vRnum = 0

			IF isArray(arrList) Or isArray(fixBanner) THEN %>
			<div class="list-card type-align-left">
				<ul id="lyrEvtList">
				<%
					IF isArray(fixBanner) THEN
						if fixBanner(4,0) = "13" Then '//상품이벤트 일경우
							vLink = "TnGotoProduct('" & fixBanner(8,0) & "');"
						Else '// 그외에
							IF fixBanner(6,0)="I" and fixBanner(7,0)<>"" THEN '링크타입 체크
								vLink = "location.href='" & fixBanner(7,0) & "';"
							ELSE
								vLink = "TnGotoEventMain('" & fixBanner(0,0) & "');"
							END IF
						End If

						eName = ""
						eNameredsale = ""

						'//이벤트 명 할인이나 쿠폰시
						If fixBanner(11,0) Or fixBanner(13,0) Then
							if ubound(Split(fixBanner(10,0),"|"))> 0 Then
								If fixBanner(11,0) Or (fixBanner(11,0) And fixBanner(13,0)) then
									eName	= cStr(Split(fixBanner(10,0),"|")(0))
									eNameredsale	= cStr(Split(fixBanner(10,0),"|")(1))
								ElseIf fixBanner(13,0) Then
									eName	= cStr(Split(fixBanner(10,0),"|")(0))
									eNameredsale	= cStr(Split(fixBanner(10,0),"|")(1))
								End If
							Else
								eName = fixBanner(10,0)
								eNameredsale	= ""
							end If
						Else
							eName = fixBanner(10,0)
							eNameredsale	= ""
						End If

						ddayicon = datediff("d",fixBanner(3,0),date)
						dim saleCper

						If fixBanner(17,0) Then vIcon = " <em class=""color-blue"">예약</em>" End IF
						If fixBanner(26,0) Then vIcon = " <em class=""color-blue"">후기</em>" End IF
						If fixBanner(18,0) Then vIcon = " <em class=""color-blue"">코멘트</em>" End IF
						If fixBanner(14,0) Then vIcon = " <em class=""color-blue"">단독</em>" End IF
						If fixBanner(15,0) Then vIcon = " <em class=""color-blue"">1+1</em>" End IF
						If fixBanner(12,0) Then vIcon = " <em class=""color-blue"">기프트</em>" End IF
						If fixBanner(13,0) <> 0 Then
							saleCper = fixBanner(27,0)
							vIcon = " <em class=""color-green"">쿠폰</em>"
						end if

						if vIsMine <> "o" then
							'// 마케팅 배너 삽입 2015-06-11 이종화
							If scTypegb <> "bw" and 0 > 0 Then  '// 2017-04-17 브랜드 위크 일때 노출 안함
								If 0 Mod 5 = 0 Then
									Response.write vHtml(vRnum)
									vRnum = vRnum + 1
								End If
							End If
						end if

						'20210819 리스트 태그 추가(정태훈)
						addTag = ""
						if fixBanner(29,0) <> "" or not(isnull(fixBanner(29,0))) then
							if ubound(Split(fixBanner(29,0),",")) > 0 Then
								addTag = addTag & "<ul class='list-tag'>"
								for ip = 0 to ubound(Split(fixBanner(29,0),","))
									if ip > 5 then exit for
									addTag = addTag & "<li><a href='/search/search_product2020.asp?keyword="& Split(fixBanner(29,0),",")(ip) &"'>#"& Split(fixBanner(29,0),",")(ip) &"</a></li>"
								next 
								addTag = addTag & "</ul>"
							end if 
						end if
				%>
					<li class="<%=chkiif(fixBanner(28,0)<>"","has-vod","")%>">
						<a href="" onclick="<%=vLink%> return false;">
							<div class="thumbnail"><img src="<%=chkiif(fixBanner(24,0)="",fixBanner(25,0),fixBanner(24,0))%>" alt="" /></div>
							<div class="desc">
								<p>
									<b class="headline"><span class="ellipsis" style="width:<%=chkiif(fixBanner(11,0) and eNameredsale <> "","80%","100%")%>;"><%=Replace(stripHTML(db2html(eName)),"[☆2015 다이어리]","")%></span> <% IF fixBanner(11,0) and eNameredsale <> "" THEN %><b class="discount color-red"><%=eNameredsale%></b><% end if %></b>
									<span class="subcopy"><% if vIcon <> "" then %><span class="label label-color"><%=vIcon%></span><% end if %><%=stripHTML(db2html(fixBanner(23,0)))%></span>
								</p>
								<%=addTag%>
							</div>
						</a>
					</li>
				<%
					vLink = ""
					vIcon = ""
					End If
				%>
				<%
				IF isArray(arrList) Then
				For intLoop =0 To UBound(arrList,2)

					if arrList(4,intLoop) = "13" Then '//상품이벤트 일경우
						vLink = "TnGotoProduct('" & arrList(8,intLoop) & "');"
					Else '// 그외에
						IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
							vLink = "location.href='" & arrList(7,intLoop) & "';"
						ELSE
							vLink = "TnGotoEventMain('" & arrList(0,intLoop) & "');"
						END IF
					End If

					eName = ""
					eNameredsale = ""

					'//이벤트 명 할인이나 쿠폰시
					If arrList(11,intLoop) Or arrList(13,intLoop) Then
						if ubound(Split(arrList(10,intLoop),"|"))> 0 Then
							If arrList(11,intLoop) Or (arrList(11,intLoop) And arrList(13,intLoop)) then
								eName	= cStr(Split(arrList(10,intLoop),"|")(0))
								eNameredsale	= cStr(Split(arrList(10,intLoop),"|")(1))
							ElseIf arrList(13,intLoop) Then
								eName	= cStr(Split(arrList(10,intLoop),"|")(0))
								eNameredsale	= cStr(Split(arrList(10,intLoop),"|")(1))
							End If
						Else
							eName = arrList(10,intLoop)
							eNameredsale	= ""
						end If
					Else
						eName = arrList(10,intLoop)
						eNameredsale	= ""
					End If

					ddayicon = datediff("d",arrList(3,intLoop),date)

					If arrList(17,intLoop) Then vIcon = " <em class=""color-blue"">예약</em>" End IF
					If arrList(26,intLoop) Then vIcon = " <em class=""color-blue"">후기</em>" End IF
					If arrList(18,intLoop) Then vIcon = " <em class=""color-blue"">코멘트</em>" End IF
					If arrList(14,intLoop) Then vIcon = " <em class=""color-blue"">단독</em>" End IF
					If arrList(15,intLoop) Then vIcon = " <em class=""color-blue"">1+1</em>" End IF
					If arrList(12,intLoop) Then vIcon = " <em class=""color-blue"">기프트</em>" End IF
'					If Not(arrList(27,intLoop)="" or isNull(arrList(27,intLoop))) Then
					If arrList(13,intLoop) <> 0 Then
						saleCper = arrList(27,intLoop)
'						vIcon = " <em class=""color-green"">쿠폰"&saleCper&"</em>"
						vIcon = " <em class=""color-green"">쿠폰</em>"
		'						If arrList(11,intLoop) Then vIcon = " <em class=""color-green"">쿠폰"&saleCper&"</em>" End IF
					end if

'					If ddayicon < 1 and ddayicon > -4 Then
'						if ddayicon = 0 then
'							vIcon = "<b class=""grey""><span><i>오늘<br/>까지</i></span></b>"
'						else
'							vIcon = "<b class=""grey""><span><i>D"&ddayicon&"</i></span></b>"
'						End If
'					End IF

					'If arrList(11,intLoop) Then vIcon = "" End IF
					'If arrList(13,intLoop) Then vIcon = "" End IF
					'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF

					if vIsMine <> "o" then
						'// 마케팅 배너 삽입 2015-06-11 이종화
						If scTypegb <> "bw" and intLoop > 0 Then  '// 2017-04-17 브랜드 위크 일때 노출 안함
							If intLoop Mod 5 = 0 Then
								Response.write vHtml(vRnum)
								vRnum = vRnum + 1
							End If
						End If
					end if

					'20210819 리스트 태그 추가(정태훈)
					addTag = ""
					if arrList(29,intLoop) <> "" or not(isnull(arrList(29,intLoop))) then
						if ubound(Split(arrList(29,intLoop),",")) > 0 Then
							addTag = addTag & "<ul class='list-tag'>"
							for ip = 0 to ubound(Split(arrList(29,intLoop),","))
								if ip > 5 then exit for
								addTag = addTag & "<li><a href='/search/search_product2020.asp?keyword="& Split(arrList(29,intLoop),",")(ip) &"'>#"& Split(arrList(29,intLoop),",")(ip) &"</a></li>"
							next 
							addTag = addTag & "</ul>"
						end if 
					end if
				%>
					<li class="<%=chkiif(arrList(28,intLoop)<>"","has-vod","")%>">
						<a href="" onclick="<%=vLink%> return false;">
							<div class="thumbnail"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt="" /></div>
							<div class="desc">
								<p>
									<b class="headline"><span class="ellipsis" style="width:<%=chkiif(arrList(11,intLoop) and eNameredsale <> "","80%","100%")%>;"><%=Replace(stripHTML(db2html(eName)),"[☆2015 다이어리]","")%></span> <% IF arrList(11,intLoop) and eNameredsale <> "" THEN %><b class="discount color-red"><%=eNameredsale%></b><% end if %></b>
									<span class="subcopy"><% if vIcon <> "" then %><span class="label label-color"><%=vIcon%></span><% end if %><%=stripHTML(db2html(arrList(23,intLoop)))%></span>
								</p>
								<%=addTag%>
							</div>
						</a>
						<%	'// 5개 마다 노출
							'If intLoop Mod 5 = 0 And scTypegb="planevt" Then
							'	Response.write fngetListItemHtml(arrList(0,intLoop))
							'End If
						%>
					</li>
				<%
				vLink = ""
				vIcon = ""
				Next
				End If
				%>
				</ul>
			</div>
			<% Else %>
				<% if scTypegb = "planevt" then %>
					<div class="emptyMsgV16a emptyExhtV16a">
						<div>
							<p><%=chkIIF(vIsMine="o","진행중인 관심 기획전이 없습니다.","진행중인 기획전이 없습니다.")%></p>
						</div>
					</div>
				<% else %>
					<div class="emptyMsgV16a emptyEvtV16a">
						<div>
							<p><%=chkIIF(vIsMine="o","진행중인 관심 이벤트가 없습니다.","진행중인 이벤트가 없습니다.")%></p>
						</div>
					</div>
				<% end if %>
			<% End If %>

			<form name="frmSC" method="get" action="all_event_chuseok2021.asp" style="margin:0px;">
			<input type="hidden" name="scTgb" value="<%=scTypegb%>">
			<input type="hidden" name="iC" >
			<input type="hidden" name="scT" value="<%=scType%>">
			<input type="hidden" name="disp" value="<%=sCategory%>">
			<input type="hidden" name="selOP" value="<%=selOP%>">
			<input type="hidden" name="ismine" value="<%=vIsMine%>">
			<input type="hidden" name="gnbflag" value="1">
			</form>
		</section>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->