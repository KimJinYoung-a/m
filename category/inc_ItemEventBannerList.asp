<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<%
	'카테고리 목록 1Depth에만 카테고리 이벤트 목록 출력
	if len(vDisp)=3 then

		Dim cShopchance, arrEBList, vEBName, vEBTag, vEBLink, vEBIcon, vEBIcoCnt
		Dim intLoop
		vEBIcoCnt = 0		'이벤트 아이콘수

		'이벤트 데이터 가져오기
		set cShopchance = new ClsShoppingChance
		cShopchance.FCPage 			= 1		'현재페이지
		cShopchance.FPSize 			= 3		'페이지 사이즈
		cShopchance.FSCategory 		= vDisp 	'제품 카테고리 대분류
		cShopchance.FEScope 		= 2				'view범위: 10x10
		cShopchance.FselOp	 		= "2"			'이벤트정렬
		cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
		arrEBList = cShopchance.fnGetBannerList	'배너리스트 가져오기
		set cShopchance = nothing

		IF isArray(arrEBList) THEN
%>
<section class="multiBnrV15a">
	<div class="swiper-container">
		<div class="swiper-wrapper">
		<%
			For intLoop =0 To UBound(arrEBList,2)
				IF arrEBList(6,intLoop)="I" and arrEBList(7,intLoop)<>"" THEN '링크타입 체크
					vEBLink = "location.href='" & arrEBList(7,intLoop) & "';"
				ELSE
					vEBLink = "javascript:TnGotoEventMain('" & arrEBList(0,intLoop) & "');"
				END IF
				
				'//이벤트 명
				If arrEBList(11,intLoop) Or arrEBList(13,intLoop) Then
					if ubound(Split(arrEBList(10,intLoop),"|"))> 0 Then
						vEBName = cStr(Split(arrEBList(10,intLoop),"|")(0))
						vEBTag = trim(cStr(Split(arrEBList(10,intLoop),"|")(1)))

						'할인이나 쿠폰시 아이콘
						if vEBTag<>"" then
							If arrEBList(11,intLoop) Or (arrEBList(11,intLoop) And arrEBList(13,intLoop)) then
								vEBIcon = vEBIcon & " <em class=""icoSaleRed"">" & vEBTag & "</em>"
								vEBIcoCnt = vEBIcoCnt + 1
							ElseIf arrEBList(13,intLoop) Then
								vEBIcon = vEBIcon & " <em class=""icoSaleGrn"">" & vEBTag & "</em>"
								vEBIcoCnt = vEBIcoCnt + 1
							End If
						End If
					Else
						vEBName = arrEBList(10,intLoop)
					end If
				Else
					vEBName = arrEBList(10,intLoop)
				End If 
				vEBName = Replace(db2html(vEBName),"[☆2015 다이어리]","")
		
				'추가 아이콘
				If arrEBList(12,intLoop) and vEBIcoCnt<2 Then vEBIcon = vEBIcon & " <em class=""icoGift"">GIFT</em>": vEBIcoCnt = vEBIcoCnt + 1
				If arrEBList(18,intLoop) and vEBIcoCnt<2 Then vEBIcon = vEBIcon & " <em class=""icoPart"">참여</em>": vEBIcoCnt = vEBIcoCnt + 1
				If arrEBList(15,intLoop) and vEBIcoCnt<2 Then vEBIcon = vEBIcon & " <em class=""icoGift"">1+1</em>":vEBIcoCnt = vEBIcoCnt + 1
		%>
			<div class="swiper-slide">
				<a href="<%=vEBLink%>">
					<p class="desc">
						<strong><%=vEBName & vEBIcon%></strong>
						<span><%=db2html(arrEBList(23,intLoop))%></span>
					</p>
					<img src="<%=getThumbImgFromURL(arrEBList(24,intLoop),600,270,"true","false")%>" alt="이벤트 배너" />
				</a>
			</div>
		<%
				vEBTag = ""
				vEBLink = ""
				vEBIcon = ""'
				vEBIcoCnt = 0
			Next
		%>
		</div>
		<div class="swiper-pagination"></div>
	</div>
</section>
<script type="text/javascript">
	var swiperILEB = new Swiper('.multiBnrV15a .swiper-container', {
		pagination:'.swiper-pagination',
		paginationClickable:true,
		autoplay:3500,
		speed:900,
		resizeReInit:true,
		calculateHeight:true,
		loop:true,
		onTouchEnd:function(swiper) {
			swiper.startAutoplay()
		}
	});
</script>
<%
		end if
	end if
%>