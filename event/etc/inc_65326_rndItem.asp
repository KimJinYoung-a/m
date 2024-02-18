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
' Description : vacance for mobile & app
' History : 2015-07-01 이종화 생성
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
	dim renloop
	dim arrItemid(30), arrItemDsc(30)
	dim itemid, dmINM, dmCp, dmIMg, dmPrc, dmDsc
	dim itmLink

	'// 날짜별 분기
	if date<="2015-08-13" then
		arrItemid(0) = 1288880 	: arrItemDsc(0) = "신학기 준비의 정석, 백팩 마련!"
		arrItemid(1) = 1319698 	: arrItemDsc(1) = "시간 엄수는 필수!"
		arrItemid(2) = 1146524 	: arrItemDsc(2) = "새 출발, 첫 걸음"
		arrItemid(3) = 1044261 	: arrItemDsc(3) = "개강 첫주는 원래 클러치잖아요"
		arrItemid(4) = 1303462 	: arrItemDsc(4) = "개강여신 어렵지 않아요"
		arrItemid(5) = 1147503 	: arrItemDsc(5) = "나는 파우치도 A+"
		arrItemid(6) = 1296740 	: arrItemDsc(6) = "다 잘될거야! 주문을 외울 것!"
		arrItemid(7) = 1248348 	: arrItemDsc(7) = "도서관에서 사뿐 사뿐!"
		arrItemid(8) = 1331710 	: arrItemDsc(8) = "신학기에 충실한 데일리아이템"
		arrItemid(9) = 1331290 	: arrItemDsc(9) = "공부는 환경이 중요해요! "
		arrItemid(10) = 1161092 	: arrItemDsc(10) = "손에 착착 감기니 문제가 술술! "
		arrItemid(11) = 1327414 	: arrItemDsc(11) = "미니언이 알려주는 만점 노하우!"
		arrItemid(12) = 1156240 	: arrItemDsc(12) = "교수님 말 다 씹어먹을거야."
		arrItemid(13) = 1045179 	: arrItemDsc(13) = "공부가 하고 싶어지는 간지펜"
		arrItemid(14) = 1201881 	: arrItemDsc(14) = "예쁜 노트 미리 GET 해놓자."
		arrItemid(15) = 1269477 	: arrItemDsc(15) = "집중이 안될 땐, 꾹꾹 마사지!"
		arrItemid(16) = 863241 	: arrItemDsc(16) = "밤새 공부한 사실은, 일급비밀!"
		arrItemid(17) = 1003965 	: arrItemDsc(17) = "졸릴 땐 조금 쉬었다 하자."
		arrItemid(18) = 1303825 	: arrItemDsc(18) = "바른자세로 오래 버티기."
		arrItemid(19) = 1074410 	: arrItemDsc(19) = "사먹지 말고, 물은 꼭 들고 다니자."
		arrItemid(20) = 1157043 	: arrItemDsc(20) = "숨막히는 도서관에서의 오아시스!"
		arrItemid(21) = 1162776 	: arrItemDsc(21) = "조모임 필수품 USB"
		arrItemid(22) = 1275430 	: arrItemDsc(22) = "가방은 없어도 노트북은 들고다녀."
		arrItemid(23) = 1273376 	: arrItemDsc(23) = "심플한 책꽂이의 정석"
		arrItemid(24) = 1235113 	: arrItemDsc(24) = "당신의 컬러는 무엇인가요?"
		arrItemid(25) = 767481 	: arrItemDsc(25) = "공부하고 싶어지는 접이식 테이블"
		arrItemid(26) = 1245129 	: arrItemDsc(26) = "앉고 싶은 책상 만들기!"
		arrItemid(27) = 1266609 	: arrItemDsc(27) = "2개 같은 1개, 듀얼 백팩"
		arrItemid(28) = 1269158 	: arrItemDsc(28) = "에어컨 빵빵한 도서관 준비물!"
		arrItemid(29) = 1276268 	: arrItemDsc(29) = "4학년의 포스!"
	elseif date>="2015-08-14" and date<="2015-08-18" then
		arrItemid(0) = 689632 	: arrItemDsc(0) = "첫주부터 지각하면 쓰나"
		arrItemid(1) = 662523 	: arrItemDsc(1) = "천 가방에 작별을 고하다"
		arrItemid(2) = 1033124 	: arrItemDsc(2) = "백팩도 더욱 스타일리쉬하게"
		arrItemid(3) = 1326907 	: arrItemDsc(3) = "전공 서적이 쏙!"
		arrItemid(4) = 1189231 	: arrItemDsc(4) = "짐 많은 신학기, 보조백은 필수!"
		arrItemid(5) = 1259781 	: arrItemDsc(5) = "등교길이 가벼워지는 스니커즈!"
		arrItemid(6) = 1329944 	: arrItemDsc(6) = "필기의 여왕! 넉넉하게 담아봐요."
		arrItemid(7) = 1308513 	: arrItemDsc(7) = "많이 넣되, 스타일도 놓칠 수 없다."
		arrItemid(8) = 1243638 	: arrItemDsc(8) = "전공책 안 꾸밀거에요?"
		arrItemid(9) = 1130596 	: arrItemDsc(9) = "이거 하나면 다른 필통 필요 없어."
		arrItemid(10) = 1234111 	: arrItemDsc(10) = "어른들의 알림장이라고나 할까!"
		arrItemid(11) = 1209806 	: arrItemDsc(11) = "정리의 습관이 성적을 만든다."
		arrItemid(12) = 910820 	: arrItemDsc(12) = "노트 3권으로 한학기 완성하기."
		arrItemid(13) = 879585 	: arrItemDsc(13) = "숫자클립이라 더 편해요."
		arrItemid(14) = 1138908 	: arrItemDsc(14) = "활용도 만점 센스 메모잇"
		arrItemid(15) = 1327480 	: arrItemDsc(15) = "1교시 바쁜아침, 원터치 블러 팩트!"
		arrItemid(16) = 1331866 	: arrItemDsc(16) = "야작도 두렵지 않다!"
		arrItemid(17) = 1303825 	: arrItemDsc(17) = "바른자세로 오래 버티기."
		arrItemid(18) = 1003971 	: arrItemDsc(18) = "자도 자도 피곤하지요?"
		arrItemid(19) = 1330189 	: arrItemDsc(19) = "시원~하게 공부하세요."
		arrItemid(20) = 1180838 	: arrItemDsc(20) = "기분전환엔 케이스가 딱!"
		arrItemid(21) = 1280328 	: arrItemDsc(21) = "CC 끼리 같이 충전!"
		arrItemid(22) = 1153596 	: arrItemDsc(22) = "저 학생 참 스마트 하구만!"
		arrItemid(23) = 1112585 	: arrItemDsc(23) = "침대 위, 노트북 테이블로 딱!"
		arrItemid(24) = 153787 	: arrItemDsc(24) = "클래식한 스터디룸에 안성맞춤"
		arrItemid(25) = 130594 	: arrItemDsc(25) = "책상과 함께, 내 학점도 밝혀요!"
		arrItemid(26) = 1203703 	: arrItemDsc(26) = "구름이 시간을 알려줄게요."
		arrItemid(27) = 1318672 	: arrItemDsc(27) = "각도조절 책상은 역시 달라요."
		arrItemid(28) = 1328302 	: arrItemDsc(28) = "좋은 대학 다니는 언니 포스"
		arrItemid(29) = 1327750 	: arrItemDsc(29) = "ㅇㅇ대 여신 김텐텐.jpg"
	elseif date>="2015-08-19" then
		arrItemid(0) = 1317087 	: arrItemDsc(0) = "지각방지 뜀박질엔 크로스로 매기!"
		arrItemid(1) = 1329135 	: arrItemDsc(1) = "이번 학기는 내가 슈퍼스타!"
		arrItemid(2) = 1318071 	: arrItemDsc(2) = "이번 학기, 가방은 너만 믿는다!"
		arrItemid(3) = 653546 	: arrItemDsc(3) = "학생에게 최적화된 가방."
		arrItemid(4) = 1221396 	: arrItemDsc(4) = "지치지 않도록, 가벼운 가방!"
		arrItemid(5) = 1291781 	: arrItemDsc(5) = "행운의 기운을 몰고 다니자!"
		arrItemid(6) = 1213034 	: arrItemDsc(6) = "신학기 준비의 정석, 백팩 마련!"
		arrItemid(7) = 1248348 	: arrItemDsc(7) = "도서관에서 사뿐 사뿐!"
		arrItemid(8) = 1053091 	: arrItemDsc(8) = "필기가 예뻐져요!"
		arrItemid(9) = 642534 	: arrItemDsc(9) = "밤에도 열공하는 그대를 위해"
		arrItemid(10) = 898233 	: arrItemDsc(10) = "많을수록 좋은 북마크"
		arrItemid(11) = 1243691 	: arrItemDsc(11) = "졸업할 때까지 쓸 수 있는 펜"
		arrItemid(12) = 1249773 	: arrItemDsc(12) = "아이디어가 많은 당신에게 추천"
		arrItemid(13) = 1065785 	: arrItemDsc(13) = "필기와 스마트폰 터치를 한 번에."
		arrItemid(14) = 1161092 	: arrItemDsc(14) = "손에 착착 감기니 문제가 술술!"
		arrItemid(15) = 1269477 	: arrItemDsc(15) = "집중이 안될 땐, 꾹꾹 마사지!"
		arrItemid(16) = 295139 	: arrItemDsc(16) = "교수님! 저 또렷히 보고있어요!"
		arrItemid(17) = 1003971 	: arrItemDsc(17) = "자도 자도 피곤하지요?"
		arrItemid(18) = 1299741 	: arrItemDsc(18) = "엉덩이에 땀이 안차요."
		arrItemid(19) = 1286350 	: arrItemDsc(19) = "아이스커피와 브레이크 타임"
		arrItemid(20) = 1246002 	: arrItemDsc(20) = "추억이 곧 남는것."
		arrItemid(21) = 893610 	: arrItemDsc(21) = "각오하고 제출하세요."
		arrItemid(22) = 1305609 	: arrItemDsc(22) = "샤방한 랩탑파우치"
		arrItemid(23) = 912373 	: arrItemDsc(23) = "정리가 착착, 감각적인 철제서랍"
		arrItemid(24) = 1330217 	: arrItemDsc(24) = "새 출발, 첫 걸음"
		arrItemid(25) = 420853 	: arrItemDsc(25) = "시간을 알려주는 나무"
		arrItemid(26) = 1018483 	: arrItemDsc(26) = "아이의 개성이 가득, 유니크 백팩!"
		arrItemid(27) = 1266609 	: arrItemDsc(27) = "2개 같은 1개, 듀얼 백팩"
		arrItemid(28) = 1320224 	: arrItemDsc(28) = "선배, 밥사주세요!"
		arrItemid(29) = 1278967 	: arrItemDsc(29) = "몸이 편해야, 공부가 잘되쥬!"
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
<a href="" class="inner" onclick="<%=itmLink%>;return false;">
	<figure><img src="<%=dmIMg%>" alt="<%=replace(dmINM,"""","")%>" /></figure>
	<p class="pName"><%=dmCp%></p>
	<p class="pPrice"><%=formatNumber(dmPrc,0)%>원 <% if dmDsc<>"" then %><span class="cRd1">[<%=dmDsc%>]</span><% end if %></p>
</a>
<!-- #include virtual="/lib/db/dbclose.asp" -->