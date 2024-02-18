<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/hotkeywordbnr/HotKeywordBnrCls.asp" -->
<%
Function AddZero(Str)
	IF len(Str)=1 Then
		AddZero="0"&Str
	Else
		AddZero=Str
	End IF
End Function
%>
<%
	dim testdate, hotkeyBnrObj, bnrList(), i, isClose	
	dim exDate, tmpContentType, tmpImg, imgDate
	dim todayDate
	todayDate = date()
	isClose = false

	dim hotkey_gaparam
		hotkey_gaparam = "today_round_"

	testdate = request("testdate")	

	if testdate <> "" then
		todayDate = cdate(testdate)
	end if

	Redim preserve bnrList(6)

	For i = 0 To ubound(bnrList) - 1 
		set bnrList(i) = new HotKeywordBnrCls 
	Next

	Select Case todayDate
		Case "2018-12-11":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 89109
			bnrList(0).contentDesc = "6공 다이어리"
			'2
			bnrList(1).contentType = 2
			bnrList(1).contentCode = 2150945
			bnrList(1).contentDesc = "차대표의 귀걸이"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 90957
			bnrList(2).contentDesc = "에어팟 A to Z"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 90822
			bnrList(3).contentDesc = "장갑 베스트"
			'5
			bnrList(4).contentType = 2
			bnrList(4).contentCode = 2168433
			bnrList(4).contentDesc = "텐텐 단독 판매"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 90405
			bnrList(5).contentDesc = "BT21 신상"
		Case "2018-12-12":
			'1
			bnrList(0).contentType = 2
			bnrList(0).contentCode = 1839857
			bnrList(0).contentDesc = "10개 추가 증정"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 90867
			bnrList(1).contentDesc = "인☆ #감성"
			'3
			bnrList(2).contentType = 2
			bnrList(2).contentCode = 2171665
			bnrList(2).contentDesc = "발목에 시선집중"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 90691
			bnrList(3).contentDesc = "이번 주말엔 이거"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 90999
			bnrList(4).contentDesc = "리즈 갱신템"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91104
			bnrList(5).contentDesc = "오늘만 1+1"
		Case "2018-12-13":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 90806
			bnrList(0).contentDesc = "금주의 베스트"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91009
			bnrList(1).contentDesc = "황민현's Pick"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91120
			bnrList(2).contentDesc = "구매욕구 폭발"
			'4
			bnrList(3).contentType = 2
			bnrList(3).contentCode = 2133863
			bnrList(3).contentDesc = "몸짱 소방관 달력"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91038
			bnrList(4).contentDesc = "지금 사면 최저가"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 90819
			bnrList(5).contentDesc = "마리몬드 단독"
		Case "2018-12-14":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91152
			bnrList(0).contentDesc = "댕냥이 인싸템"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 90692
			bnrList(1).contentDesc = "쉽고 빠른 뜨개질"
			'3
			bnrList(2).contentType = 2
			bnrList(2).contentCode = 2101063
			bnrList(2).contentDesc = "달력 말고 일력"
			'4
			bnrList(3).contentType = 2
			bnrList(3).contentCode = 2176672
			bnrList(3).contentDesc = "SNS 핫떡"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 89421
			bnrList(4).contentDesc = "흔들흔들~뜨뜻!"
			'6
			bnrList(5).contentType = 2
			bnrList(5).contentCode = 2077593
			bnrList(5).contentDesc = "스누피 양털자켓"
		Case "2018-12-15", "2018-12-16":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91179
			bnrList(0).contentDesc = "홈파티 준비"
			'2
			bnrList(1).contentType = 2
			bnrList(1).contentCode = 2181122
			bnrList(1).contentDesc = "아임닭 럭키박스"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 90692
			bnrList(2).contentDesc = "쉽고 빠른 뜨개질"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 90911
			bnrList(3).contentDesc = "감성 저격 주얼리"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 89421
			bnrList(4).contentDesc = "흔들흔들~뜨뜻!"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91152
			bnrList(5).contentDesc = "댕냥이 인싸템"
		Case "2018-12-17":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91202
			bnrList(0).contentDesc = "디즈니 혜자템"
			'2
			bnrList(1).contentType = 2
			bnrList(1).contentCode = 1591433
			bnrList(1).contentDesc = "사무실에 엉뜨"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91197
			bnrList(2).contentDesc = "남친 선물 추천"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91247
			bnrList(3).contentDesc = "연차내고 떠나자"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91007
			bnrList(4).contentDesc = "홈메이드 뱅쇼"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 90807
			bnrList(5).contentDesc = "요리 치트키"
		Case "2018-12-18":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91213
			bnrList(0).contentDesc = "올해는 내가 산타"
			'2
			bnrList(1).contentType = 2
			bnrList(1).contentCode = 2183278
			bnrList(1).contentDesc = "이런 테이블 봤어?"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91303
			bnrList(2).contentDesc = "달력/스티커 증정"
			'4
			bnrList(3).contentType = 2
			bnrList(3).contentCode = 774875
			bnrList(3).contentDesc = "고양이가 좋아해"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91123
			bnrList(4).contentDesc = "다꾸 신박템 등장"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 90741
			bnrList(5).contentDesc = "조카 선물은 이거!"
		Case "2018-12-19":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91317
			bnrList(0).contentDesc = "스크래치 특가"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91124
			bnrList(1).contentDesc = "꿈꾸던 화장대"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 90814
			bnrList(2).contentDesc = "선착순 담요 증정"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 90946
			bnrList(3).contentDesc = "DIY 인생 트리"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91261
			bnrList(4).contentDesc = "1mm 히터"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91284
			bnrList(5).contentDesc = "다꾸 고수 추천"
		Case "2018-12-20":
			'1
			bnrList(0).contentType = 2
			bnrList(0).contentCode = 2188483
			bnrList(0).contentDesc = "한정판 Keds"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91281
			bnrList(1).contentDesc = "무료배송+사은품"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91349
			bnrList(2).contentDesc = "진혁's 초이스"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91361
			bnrList(3).contentDesc = "인기 Top 조명"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 90914
			bnrList(4).contentDesc = "파티 필수 푸드"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91332
			bnrList(5).contentDesc = "22칸의 발견"
		Case "2018-12-21":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91297
			bnrList(0).contentDesc = "최저가 X 최저가"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91288
			bnrList(1).contentDesc = "뷰라벨 핸드크림"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 90651
			bnrList(2).contentDesc = "For. 커플"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 90502
			bnrList(3).contentDesc = "항상 감사합니다"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91357
			bnrList(4).contentDesc = "아직 고민중?"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91326
			bnrList(5).contentDesc = "해돋이 여행 준비"
		Case "2018-12-22", "2018-12-23":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91233
			bnrList(0).contentDesc = "아임웰 무료배송"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91288
			bnrList(1).contentDesc = "뷰라벨 핸드크림"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91365
			bnrList(2).contentDesc = "방한마스크 특가"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91294
			bnrList(3).contentDesc = "정리력 ↑"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91357
			bnrList(4).contentDesc = "아직 고민중?"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91291
			bnrList(5).contentDesc = "X-mas 베스트"
		Case "2018-12-24", "2018-12-25":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91155
			bnrList(0).contentDesc = "선물천재 추천"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91359
			bnrList(1).contentDesc = "똑똑한 여행준비"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91225
			bnrList(2).contentDesc = "형광등 귀걸이"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 90748
			bnrList(3).contentDesc = "인☆ 갬성"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91070
			bnrList(4).contentDesc = "양말은 늘 부족해"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91010
			bnrList(5).contentDesc = "와사비 티라미수"
		Case "2018-12-26":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91358
			bnrList(0).contentDesc = "초특가 다꾸템"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 90691
			bnrList(1).contentDesc = "밤의 숲 수놓기"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91283
			bnrList(2).contentDesc = "디즈니 독점상품"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91461
			bnrList(3).contentDesc = "독보적인 귀여움"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91450
			bnrList(4).contentDesc = "폭신폭신 부츠"
			'6
			bnrList(5).contentType = 2
			bnrList(5).contentCode = 2174961
			bnrList(5).contentDesc = "튤립 1인 소파"
		Case "2018-12-27":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91370
			bnrList(0).contentDesc = "꽃길만 걸어요"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91312
			bnrList(1).contentDesc = "가성비 Top 시계"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 90932
			bnrList(2).contentDesc = "청소는 아이템빨"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91145
			bnrList(3).contentDesc = "2019 버킷리스트"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91353
			bnrList(4).contentDesc = "이게 이불이라고?"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91356
			bnrList(5).contentDesc = "수저도 남다르게"
		Case "2018-12-28":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91511
			bnrList(0).contentDesc = "진리의 닥터마틴"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91008
			bnrList(1).contentDesc = "이걸 왜 몰랐지?"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91335
			bnrList(2).contentDesc = "새해엔 관리 시작"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91513
			bnrList(3).contentDesc = "핫팩은 이게 최고"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91201
			bnrList(4).contentDesc = "케이블을 앙~"
			'6
			bnrList(5).contentType = 2
			bnrList(5).contentCode = 2187471
			bnrList(5).contentDesc = "취향저격 컬러감"
		Case "2018-12-29", "2018-12-30":
			'1
			bnrList(0).contentType = 2
			bnrList(0).contentCode = 2186786
			bnrList(0).contentDesc = "Wish 급상승"
			'2
			bnrList(1).contentType = 2
			bnrList(1).contentCode = 2143141
			bnrList(1).contentDesc = "퍼프 살균기"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91335
			bnrList(2).contentDesc = "새해엔 관리 시작"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91513
			bnrList(3).contentDesc = "핫팩은 이게 최고"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91441
			bnrList(4).contentDesc = "캣&독 DAY"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91314
			bnrList(5).contentDesc = "겨울양말 준비 끝"
		Case "2018-12-31", "2019-01-01":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91521
			bnrList(0).contentDesc = "유니크한 케이스"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 90739
			bnrList(1).contentDesc = "방이 넓어져요"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91245
			bnrList(2).contentDesc = "적게 먹고 싶다면"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91455
			bnrList(3).contentDesc = "프리미엄 보석함"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91525
			bnrList(4).contentDesc = "가성비 甲"
			'6
			bnrList(5).contentType = 2
			bnrList(5).contentCode = 2191118
			bnrList(5).contentDesc = "동물 머리가 쏙~"
		Case "2019-01-02":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91506
			bnrList(0).contentDesc = "캘린더 1+1"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91529
			bnrList(1).contentDesc = "누군가의 인생템"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 91337
			bnrList(2).contentDesc = "다신 살 안찔래"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91453
			bnrList(3).contentDesc = "너의 이름은?"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91375
			bnrList(4).contentDesc = "파로마! 파로마!"
			'6
			bnrList(5).contentType = 2
			bnrList(5).contentCode = 2143141
			bnrList(5).contentDesc = "퍼프 살균기"
		Case "2019-01-03":
			'1
			bnrList(0).contentType = 1
			bnrList(0).contentCode = 91600
			bnrList(0).contentDesc = "토이 BEST"
			'2
			bnrList(1).contentType = 1
			bnrList(1).contentCode = 91545
			bnrList(1).contentDesc = "한정 럭키박스"
			'3
			bnrList(2).contentType = 1
			bnrList(2).contentCode = 90232
			bnrList(2).contentDesc = "수족냉증 극복"
			'4
			bnrList(3).contentType = 1
			bnrList(3).contentCode = 91537
			bnrList(3).contentDesc = "겨울 패션 마침표"
			'5
			bnrList(4).contentType = 1
			bnrList(4).contentCode = 91569
			bnrList(4).contentDesc = "사무실 인싸템"
			'6
			bnrList(5).contentType = 1
			bnrList(5).contentCode = 91522
			bnrList(5).contentDesc = "단독특가 시계"
		case else
			isClose = true
	end Select

	imgDate = AddZero(Month(todayDate)) & AddZero(Day(todayDate))

dim tempYear
	tempYear = "2018"
	if todayDate >= cdate("2019-01-01") then
		tempYear = "2019"
	end if
%>
<% if not isClose then %>
			<section class="hotkey-list">
				<ul>
				<% 
				for i = 0 to ubound(bnrList) - 1 
					if bnrList(i).contentType = 1 then
						tmpContentType = "event"
					else
						tmpContentType = "product"
					end if
					tmpImg = "http://webimage.10x10.co.kr/fixevent/event/"& tempYear &"/today/"&imgDate&"/m/img_hotkey_0"&i+1&".jpg?v=1.07"
				%>
					<li>
						<% if isapp = 1 then %>
							<% if bnrList(i).contentType = 1 then %>
								<a href="javascript:void(0)" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=i+1%>|<%=tmpContentType%>|<%=bnrList(i).contentCode%>', function(bool){if(bool) {fnAPPpopupAutoUrl('/event/eventmain.asp?eventid=<%=bnrList(i).contentCode%>&gaparam=<%=hotkey_gaparam & i+1%>');}});return false;">						
							<% else %>
								<a href="javascript:void(0)" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=i+1%>|<%=tmpContentType%>|<%=bnrList(i).contentCode%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=bnrList(i).contentCode%>&gaparam=<%=hotkey_gaparam & i+1%>');}});return false;">																
							<% end if %>						
						<% else %>		
							<% if bnrList(i).contentType = 1 then %>
								<a href="/event/eventmain.asp?eventid=<%=bnrList(i).contentCode%>&gaparam=<%=hotkey_gaparam & i+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=i+1%>|<%=tmpContentType%>|<%=bnrList(i).contentCode%>');">								
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=bnrList(i).contentCode%>&gaparam=<%=hotkey_gaparam & i+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=i+1%>|<%=tmpContentType%>|<%=bnrList(i).contentCode%>');">
							<% end if %>																
						<% end if %>											
							<div class="thumb-area"><div class="thumbnail"><img src="<%=tmpImg%>" alt="" /></div></div>
							<div class="desc"><%=bnrList(i).contentDesc%></div>
						</a>
					</li>
				<% next %>	
				</ul>
			</section>		
<% end if %>