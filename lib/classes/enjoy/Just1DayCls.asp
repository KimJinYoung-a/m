<%
'#######################################################
'	History	: 2008.04.07 허진원 생성
'	Description : 저스트원데이 클래스
'#######################################################

'#============================#
'# 클래스 아이템 선언         #
'#============================#
CLASS CJustOneDayItem
	public Fsolar_date		'양력일자
	public FJustDate		'상품오픈일자
	public Fholiday			'휴일여부 (0:평일, 1:토요일, 2:휴일)
	public Fweek			'요일 (월~일)
	public Fitemid			'상품코드
	public Fitemname		'상품명
	public Fmakerid			'브랜드ID
	public Fbrandname		'브랜드명
	public Flistimage		'목록이미지 (100*100)
	public Flistimage120	'목록이미지 (120*120)
	public Flistimage150	'목록이미지 (150*150)
	public FbasicImage		'기본이미지 (400*400)
	public Fjust1dayImg1	'저스트원데이 별도 이미지1

	public ForgPrice		'상품 원판매가
	public FsalePrice		'상품 할인가
	public justSalePrice	'저스트원데이 할인가
	public FjustDesc		'상품 간략 설명
	public FlimitYn			'한정여부
	public FlimitNo			'한정 수량
	public FlimitSold		'한정판매 수량
	public FLimitDispYn		'한정 표시여부
	public Foptioncnt		'제품옵션수
	public FSellYn			'상품판매여부
	public FPreDay			'이전날 상품
	public FNextDay			'다음날 상품

	private sub Class_initialize()
	End Sub

	private Sub Class_terminate()
	End Sub
End Class


'#============================#
'# 목록/내용 접수             #
'#============================#
CLASS CJustOneDay
	public FResultCount

	public FRectDate
	Public FRectItemId
	public FItemList()

	Private Sub Class_Initialize()
		FResultCount = 0
	End Sub

	Private Sub Class_Terminate()
	End Sub


	'// 저스트원데이 캘린더 목록 접수 //
	Public sub GetJustOneDayCalendar()
		dim i

		'커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'저장프로시저 실행
		rsget.Open "exec db_sitemaster.dbo.sp_Ten_Just1Day_Calander '" & FRectDate & "'", dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CJustOneDayItem

				FItemList(i).Fsolar_date	= rsget("solar_date")
				FItemList(i).FJustDate		= trim(rsget("JustDate"))
				FItemList(i).Fholiday		= rsget("holiday")
				FItemList(i).Fweek			= rsget("week")
				FItemList(i).Fitemid		= rsget("itemid")
				FItemList(i).Flistimage		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).Flistimage120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub

	'// 저스트원데이 상품 상세 내용 접수 //
	Public sub GetJustOneDayItemInfo()

		'커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'저장프로시저 실행
		rsget.Open "exec db_sitemaster.dbo.sp_Ten_Just1Day_iteminfo '" & FRectDate & "', '"&FRectItemId&"'", dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		
		if  not rsget.EOF  then
			set FItemList(0) = new CJustOneDayItem

			FItemList(0).FJustDate		= rsget("JustDate")
			FItemList(0).ForgPrice		= rsget("orgPrice")
			FItemList(0).FsalePrice		= rsget("sellCash")
			FItemList(0).justSalePrice	= rsget("justSalePrice")
			FItemList(0).FjustDesc		= db2html(rsget("justDesc"))
			FItemList(0).FlimitYn		= rsget("limitYn")
			FItemList(0).FlimitNo		= rsget("limitNo")
			FItemList(0).FlimitSold		= rsget("limitSold")
			FItemList(0).FLimitDispYn	= rsget("LimitDispYn")
			FItemList(0).FbasicImage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicImage")
			FItemList(0).Flistimage		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
			FItemList(0).Flistimage120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
			FItemList(0).Flistimage150  = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon2image")
			If Not isNull(rsget("img1")) AND rsget("img1") <> "" Then
				FItemList(0).Fjust1dayImg1	= webImgUrl & "/just1day/" + rsget("img1")
			Else
				FItemList(0).Fjust1dayImg1	= ""
			End If
			FItemList(0).Fmakerid		= rsget("makerid")
			FItemList(0).Fbrandname		= db2html(rsget("brandname"))
			FItemList(0).Fitemid		= rsget("itemid")
			FItemList(0).Fitemname		= db2html(rsget("itemname"))
			FItemList(0).Foptioncnt		= rsget("optioncnt")
			FItemList(0).FSellYn		= rsget("SellYn")
		end if

		rsget.Close
	end sub


	'// 저스트원데이 이전날, 다음날 날짜 //
	Public sub GetJustOneDayPreNextDay()

		'커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'저장프로시저 실행
		rsget.Open "exec db_sitemaster.dbo.sp_Ten_Just1Day_PreNextDay '" & FRectDate & "'", dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		
		if  not rsget.EOF  then
			set FItemList(0) = new CJustOneDayItem

			If Not isNull(rsget("preday")) Then
				FItemList(0).FPreDay		= rsget("preday")
			End If
			If Not isNull(rsget("nextday")) Then
				FItemList(0).FNextDay		= rsget("nextday")
			End If
		end if

		rsget.Close
	end sub


End Class

'// 시간을 타이머용으로 변환
Function GetTranTimer(tt)
	if (tt="" or isNull(tt)) then Exit Function
	GetTranTimer = Num2Str(Year(tt),4,"0","R") & Num2Str(Month(tt),2,"0","R") & Num2Str(Day(tt),2,"0","R") &_
					Num2Str(Hour(tt),2,"0","R") & Num2Str(Minute(tt),2,"0","R") & Num2Str(Second(tt),2,"0","R")
end Function

%>
