<%
'#######################################################
' Discription : cate_event // cache DB경유
' History : 2015-09-21 이종화 생성 + gnbcode
'#######################################################

	Dim scType, sCategory, sCateMid, vIsMine
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	Dim cMktbanner , arrMktevt , mPageSize , MktCnt
	Dim eName , catecodeList , gnbname

	gaParam = "&gaparam=catemain_d" '//GA 체크 변수

	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	'파라미터값 받기 & 기본 변수 값 세팅
	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		= requestCheckVar(Request("ismine"),1)
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류

	iCurrpage 	= 1	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

	'데이터 가져오기 '//gnbcode , gnbname
	set cShopchance = new ClsShoppingChance
		cShopchance.Fgnbcode = gcode
		catecodeList = cShopchance.fnGetGnbcode	'catecode 가져오기
		cShopchance.fnGetgnbname
		gnbname		= cShopchance.Fgname	'gnbname 가져오기
	set cShopchance = Nothing

	IF isArray(catecodeList) Then '//검색용 전시 카테고리 취합
		For k = 0 To ubound(catecodeList,2)
			If k = 0 then
				sCategory = catecodeList(0,k)
			else
				sCategory = sCategory & "," & catecodeList(0,k)
			End If 
		Next 
	Else
		sCategory = ""
	End If 

	iPageSize = 10	'이벤트 배너
	iPerCnt = 1		'보여지는 페이지 간격

	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 		= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCategory 		= Trim(sCategory) 	'제품 카테고리 대분류
	cShopchance.FEScope 		= 2				'view범위: 10x10
	cShopchance.FselOp	 		= 2				'이벤트정렬 --0 신규순 2 인기순
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	cShopchance.Fdevice			= "M"			'DEVICE
	arrList = cShopchance.fnGetCateBannerList	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 				'배너리스트 총 갯수

	set cShopchance = Nothing
	
	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수

%>
<h2 class="title titleLine"><span><%=gnbname%> EVENT</span></h2>
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
	
	IF isArray(arrList) THEN %>
	<ul class="evtListV15">
		<%
		For intLoop =0 To UBound(arrList,2)
			IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
				vLink = "fnAPPpopupEvent_URL('" & arrList(7,intLoop) & "');"
			ELSE
				vLink = "fnAPPpopupEvent('" & arrList(0,intLoop) & "'); return false;"
			END IF

			If arrList(12,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
			If arrList(18,intLoop) AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
			If arrList(15,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
		%>
			<li onclick="<%=vLink%>" class="<%=chkiif(datediff("D",arrList(3,intLoop),Date()+4) > 0,"hurryUpV15","")%>">
				<div class="evtPhotoV15"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt="<%=db2html(arrList(10,intLoop))%>" /></div>
				<dl>
					<dt>											
						<%	'//이벤트 명 할인이나 쿠폰시
							If arrList(11,intLoop) Or arrList(13,intLoop) Then
								if ubound(Split(arrList(10,intLoop),"|"))> 0 Then
									If arrList(11,intLoop) Or (arrList(11,intLoop) And arrList(13,intLoop)) then
										eName	= cStr(Split(arrList(10,intLoop),"|")(0)) &" <span style=color:red>"&cStr(Split(arrList(10,intLoop),"|")(1))&"</span>"
									ElseIf arrList(13,intLoop) Then
										eName	= cStr(Split(arrList(10,intLoop),"|")(0)) &" <span style=color:green>"&cStr(Split(arrList(10,intLoop),"|")(1))&"</span>"
									End If 			
								Else
									eName = arrList(10,intLoop)
								end If
							Else
								eName = arrList(10,intLoop)
							End If 
						%>
						<%=Replace(db2html(eName),"[☆2015 다이어리]","")%>
						<%=vIcon%>
					</dt>
					<dd><%=db2html(arrList(23,intLoop))%></dd>
				</dl>
			</li>
		<%
			vLink = ""
			vIcon = ""
			Next
		%>
	</ul>
<% End If %>
<div class="btnMoreV15a"><a href="" onclick="fnAPPpopupEventMain();return false;"><%=gnbname%> 기획전 더보기</a></div>
<div class="btnEvtAllV15a"><a href="" onclick="fnAPPpopupEventMain();return false;"><i>기획전 전체보기</i></a></div>