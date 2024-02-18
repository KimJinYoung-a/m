<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
	Response.Charset="UTF-8"
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : [2015 FW 웨딩] 모바일 main 하단 랜덤 아이템
' History : 2015-09-15 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
	'// 지정된 상품들 중 1개 랜덤 출력 (2015.08.07 허진원)
	dim renloop, evtcode
	dim arrItemid(29), arrItemDsc(29)
	dim itemid, dmINM, dmCp, dmIMg, dmPrc, dmDsc
	dim itmLink

	'// 날짜별 분기
	if date<="2015-09-30" then
		evtcode = "66154"
		arrItemid(0) = 1273621 		: arrItemDsc(0) = "스프링무드 4인용 식탁세트 SP"
		arrItemid(1) = 1342803 		: arrItemDsc(1) = "고운 오크 네스팅 테이블"
		arrItemid(2) = 1313955 		: arrItemDsc(2) = "플러그-S 퀸사이즈 침대 C-타입"
		arrItemid(3) = 1050512 		: arrItemDsc(3) = "리니어 화장대"
		arrItemid(4) = 141809 		: arrItemDsc(4) = "스칸딕디자인 NC6 4인 식탁세트"
		arrItemid(5) = 1116421 		: arrItemDsc(5) = "데일리라잇 장스탠드(4color)"
		arrItemid(6) = 1278974 		: arrItemDsc(6) = "Choco Light 초코라이트"
		arrItemid(7) = 884073 		: arrItemDsc(7) = "미피 램프"
		arrItemid(8) = 882139 		: arrItemDsc(8) = "화이트 마르니 우드 스탠드"
		arrItemid(9) = 1343201 		: arrItemDsc(9) = "마카롱 방수시계 Macaron Clock"
		arrItemid(10) = 1259936 	: arrItemDsc(10) = "원목 스탠드거울"
		arrItemid(11) = 1096290 	: arrItemDsc(11) = "KEEP CALM AND CARRY ON 무소음벽시계"
		arrItemid(12) = 1199977 	: arrItemDsc(12) = "인테리어액자 13P"
		arrItemid(13) = 833528 		: arrItemDsc(13) = "드라이 플라워 디퓨져"
		arrItemid(14) = 1351014 	: arrItemDsc(14) = "마일드 암막 커튼(아이보리)"
		arrItemid(15) = 1271810 	: arrItemDsc(15) = "브리티시 그레이 러그"
		arrItemid(16) = 1345658 	: arrItemDsc(16) = "워싱소프트 엣지 모노라인 차렵이불세트 Q"
		arrItemid(17) = 1116961 	: arrItemDsc(17) = "딥슬립 차콜 침구세트 Q"
		arrItemid(18) = 1347796 	: arrItemDsc(18) = "베키아 워싱 옐로우 침구 Q"
		arrItemid(19) = 589447	 	: arrItemDsc(19) = "Grand Kaffe duo 커피메이커"
		arrItemid(20) = 1304285 	: arrItemDsc(20) = "쿄토쿠사 4인 식기세트 28P"
		arrItemid(21) = 1314696 	: arrItemDsc(21) = "베이직 에이프런"
		arrItemid(22) = 1048512 	: arrItemDsc(22) = "마메종 툴스 도기 후라이팬 S"
		arrItemid(23) = 1245012 	: arrItemDsc(23) = "노르딕 플로랄 머그와 플레이트 래머킨 12P"
		arrItemid(24) = 1222208 	: arrItemDsc(24) = "14파이 클로젯 메탈행거"
		arrItemid(25) = 1340911 	: arrItemDsc(25) = "커먼굿 3종 선물세트"
		arrItemid(26) = 1342777 	: arrItemDsc(26) = "Multi Black Basket"
		arrItemid(27) = 1354671 	: arrItemDsc(27) = "칠판 우드박스"
		arrItemid(28) = 1115385 	: arrItemDsc(28) = "Soil Tooth Brush Stand"
	else
		evtcode = "66534"
		arrItemid(0) = 1320514		: arrItemDsc(0) = "포포 3인용 소파_그레이"
		arrItemid(1) = 1340654		: arrItemDsc(1) = "코코로N 4인 식탁세트 / 벤치, 의자"
		arrItemid(2) = 1317429		: arrItemDsc(2) = "알토 1600 AV장식장 ALDR06"
		arrItemid(3) = 1260092		: arrItemDsc(3) = "캔빌리지 원형수납장 A2-32"
		arrItemid(4) = 1356613		: arrItemDsc(4) = "니즈 레트로 화장대 G +스툴세트"
		arrItemid(5) = 77691		: arrItemDsc(5) = "플로우 스프링 장스탠드"
		arrItemid(6) = 1133677		: arrItemDsc(6) = "SMILES SWITCH LED LIGHT"
		arrItemid(7) = 1314389		: arrItemDsc(7) = "디바제 빈티지조명"
		arrItemid(8) = 661700		: arrItemDsc(8) = "포토그래퍼 장스탠드"
		arrItemid(9) = 1351363		: arrItemDsc(9) = "clean 물방울 유리병"
		arrItemid(10) = 680185		: arrItemDsc(10) = "블루밍 가든 벽시계/디자인시계"
		arrItemid(11) = 1259936		: arrItemDsc(11) = "소프시스 원목 스탠드거울"
		arrItemid(12) = 256712		: arrItemDsc(12) = "포토월 갤러리프레임 10P세트"
		arrItemid(13) = 833528		: arrItemDsc(13) = "드라이 플라워 디퓨져"
		arrItemid(14) = 1342303		: arrItemDsc(14) = "브라운 쇼콜라티에 레이스+암막커튼"
		arrItemid(15) = 1358993		: arrItemDsc(15) = "워싱내츄럴콜렉션 토미차렵이불 퀼트풀세트 Q"
		arrItemid(16) = 1311178		: arrItemDsc(16) = "엠보바스 발매트"
		arrItemid(17) = 1347815		: arrItemDsc(17) = "드라이로즈 프리미엄 워싱린넨 침구세트(Q)"
		arrItemid(18) = 1360764		: arrItemDsc(18) = "NEW퍼피 극세사담요(아이보리)"
		arrItemid(19) = 81330		: arrItemDsc(19) = "칼리타 핸드밀"
		arrItemid(20) = 1018845		: arrItemDsc(20) = "마메종 툴스 퐁듀 세트"
		arrItemid(21) = 1281251		: arrItemDsc(21) = "루이스앞치마+주방장갑 세트"
		arrItemid(22) = 1207330		: arrItemDsc(22) = "Polrans Bowl 13cm"
		arrItemid(23) = 1252691		: arrItemDsc(23) = "BSW 요거맘 요거트 메이커"
		arrItemid(24) = 1291331		: arrItemDsc(24) = "천연 세탁세제 라벤더(Lavender)"
		arrItemid(25) = 1349818		: arrItemDsc(25) = "화이트 Storage box - 04. 18개 셋트 구성"
		arrItemid(26) = 497764		: arrItemDsc(26) = "일렉트로룩스 다이나미카 청소기 ZS320"
		arrItemid(27) = 1315266		: arrItemDsc(27) = "[1+1] 커플 퓨어라인거실화"
		arrItemid(28) = 976751		: arrItemDsc(28) = "Guest Toothbrush Set 게스트 칫솔 세트"

	end if

	randomize
	renloop=int(Rnd*(ubound(arrItemid)))

	itemid = arrItemid(renloop)
	dmCp = arrItemDsc(renloop)

	'// 상품 링크
	if isApp then
		itmLink = "fnAPPpopupProduct('" & itemid & "');"
	else
		itmLink = "parent.location.href='/category/category_itemPrd.asp?itemid=" & itemid & "';"
	End If

	// 상품 정보 접수
	dim oItem
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount>0 then
		dmINM = oItem.Prd.FItemName
		''dmIMg = oItem.Prd.FImageBasic
		dmIMg = getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false")
		dmPrc = oItem.Prd.getRealPrice
		IF oItem.Prd.IsSaleItem Then
			dmDsc = oItem.Prd.getSalePro
		End IF
	end if
	set oItem = Nothing
%>
<div class="pPhoto" onclick="<%=itmLink%>;return false;"><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></div>
<p class="pName"><%=dmCp%></p>
<p class="pPrice"><%=formatNumber(dmPrc,0)%>원 <% if dmDsc<>"" then %><span class="cRd1">[<%=dmDsc%>]</span><% end if %></p>
<a href="eventmain.asp?eventid=<%=evtcode%>" onclick="goEventLink('<%=evtcode%>');return false;" class="btnMore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66144/btn_more.png" alt="more"></a>

<!-- #include virtual="/lib/db/dbclose.asp" -->