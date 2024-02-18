<%
'#######################################################
'	History	: 2014.08.28 원승현 생성
'	Description : 직방 저스트 원 데이 클래스
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
	public FImageMask		'마스크이미지?
	Public FSmallimage		'스몰이미지?
	public Fjust1dayImg1	'저스트원데이 별도 이미지1 (아이콘)
	public Fjust1dayImg2	'저스트원데이 별도 이미지2
	public Fjust1dayImg3	'저스트원데이 별도 이미지3
	public Fjust1dayImg4	'저스트원데이 별도 이미지4
	Public FOutPutImgUrl1 'json으로 넘겨줄 상품 이미지 메인
	Public FOutPutImgUrl2 'json으로 넘겨줄 상품 이미지 디테일
	Public FcontentImgUrl	'상세이미지URL

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
	public FItemList()

	Private Sub Class_Initialize()
		FResultCount = 0
	End Sub

	Private Sub Class_Terminate()
	End Sub

	dim FADD


	'// 저스트원데이 캘린더 목록 접수 //
	Public sub GetJustOneDayCalendar()
		dim i

		'커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'저장프로시저 실행
		rsget.Open "exec db_etcmall.dbo.sp_Ten_Just1Day_Calander_jikbang '" & FRectDate & "'", dbget
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
				FItemList(i).Fitemname		= db2html(rsget("itemname"))
				FItemList(i).Flistimage		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).Flistimage120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
'				FItemList(i).Fjust1dayImg1	= webImgUrl & "/just1day/" + rsget("img1")

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
		rsget.Open "exec db_etcmall.dbo.sp_Ten_Just1Day_iteminfo_jikbang '" & FRectDate & "'", dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		
		if  not rsget.EOF  then
			set FItemList(0) = new CJustOneDayItem
			FItemList(0).FcontentImgUrl	= rsget("contentImgUrl")
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

			If Not(isNull(rsget("maskimage")) OR rsget("maskimage") = "") Then
				FItemList(0).FImageMask 	= "http://webimage.10x10.co.kr/image/mask/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("maskimage")
			end If
			
'			If Not isNull(rsget("img1")) AND rsget("img1") <> "" Then FItemList(0).Fjust1dayImg1	= webImgUrl & "/just1day/" + rsget("img1")
'			If Not isNull(rsget("img2")) AND rsget("img2") <> "" Then FItemList(0).Fjust1dayImg2	= webImgUrl & "/just1day/" + rsget("img2")
'			If Not isNull(rsget("img3")) AND rsget("img3") <> "" Then FItemList(0).Fjust1dayImg3	= webImgUrl & "/just1day/" + rsget("img3")
'			If Not isNull(rsget("img4")) AND rsget("img4") <> "" Then FItemList(0).Fjust1dayImg4	= webImgUrl & "/just1day/" + rsget("img4")
			FItemList(0).FOutPutImgUrl1		= rsget("OutPutImgUrl1")
			FItemList(0).FOutPutImgUrl2		= rsget("OutPutImgUrl2")
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
		rsget.Open "exec db_etcmall.dbo.sp_Ten_Just1Day_PreNextDay_jikbang '" & FRectDate & "'", dbget
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


	'// 추가 이미지 가져오기
	Public Sub getAddImage(byval itemid)
			dim strSQL,ArrRows,i, vImage

			strSQL = "exec [db_item].[dbo].sp_Ten_CategoryPrd_AddImage @vItemid =" & CStr(itemid)

			rsget.CursorLocation = adUseClient
			rsget.CursorType=adOpenStatic
			rsget.Locktype=adLockReadOnly
			rsget.Open strSQL, dbget

			If Not rsget.EOF Then
				ArrRows 	= rsget.GetRows
			End if
			rsget.close

			if isArray(ArrRows) then

			FResultCount = Ubound(ArrRows,2) + 1

			redim  FADD(FResultCount)

				For i=0 to FResultCount-1
					Set FADD(i) = new CCategoryPrdItem
					FADD(i).FAddimageGubun	= ArrRows(0,i)
					FADD(i).FAddImageType	= ArrRows(1,i)
					
					If isNull(ArrRows(3,i)) OR ArrRows(3,i) = "" Then
						vImage = ArrRows(2,i)
					Else
						vImage = ArrRows(3,i)
					End IF
					
					IF ArrRows(1,i)="1" Then
						FADD(i).FAddimage 			= "http://webimage.10x10.co.kr/item/contentsimage/" & GetImageSubFolderByItemid(itemid) & "/" & vImage
					Else
						FADD(i).FAddimage 			= "http://webimage.10x10.co.kr/image/add" & Cstr(FADD(i).FAddimageGubun) & "/" & GetImageSubFolderByItemid(itemid) & "/" & vImage
					End IF

				next
			end if
	End Sub


	'// 이전 1day 상품 가져오기
	Public Sub getPrev1DayProduct()

        dim i, pItemArr, strSql

		i=0

		'// 추천상품 목록접수
		strSql = " Select A.JustDate, A.orgPrice, B.sellCash, A.justSalePrice, A.justDesc, B.limitYn, B.limitNo "
		strSql = strSql & "	, B.limitSold, B.basicImage, B.listimage "
		strSql = strSql & "	,(Case When isNull(B.frontMakerid,'')='' then B.makerid else B.frontMakerid end) as makerid "
		strSql = strSql & "	, B.brandname, A.itemid, B.itemname, B.optioncnt, B.sellyn, B.listimage120, B.icon2image "
		strSql = strSql & "	, isnull(B.LimitDispYn,'Y') as LimitDispYn, B.maskimage, B.smallImage "
		strSql = strSql & "	From db_etcmall.dbo.tbl_jikbang_oneDay A "
		strSql = strSql & "	inner join db_item.dbo.tbl_item B on A.itemid = B.itemid "
		strSql = strSql & "	Where A.JustDate < convert(varchar(10), getdate(), 120) "
		strSql = strSql & "	order by A.JustDate desc "
		rsget.Open strSql, dbget, 1
		
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		If Not rsget.EOF Then
			
			Do Until rsget.EOF
				Set FItemList(i) = new CJustOneDayItem

				FItemList(i).FJustDate		= rsget("JustDate")
				FItemList(i).ForgPrice		= rsget("orgPrice")
				FItemList(i).FsalePrice		= rsget("sellCash")
				FItemList(i).justSalePrice	= rsget("justSalePrice")
				FItemList(i).FjustDesc		= db2html(rsget("justDesc"))
				FItemList(i).FlimitYn		= rsget("limitYn")
				FItemList(i).FlimitNo		= rsget("limitNo")
				FItemList(i).FlimitSold		= rsget("limitSold")
				FItemList(i).FLimitDispYn	= rsget("LimitDispYn")
				FItemList(i).FbasicImage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicImage")
				FItemList(i).Flistimage		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).Flistimage120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
				FItemList(i).Flistimage150  = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon2image")
				FItemList(i).FSmallimage  = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("smallimage")

				If Not(isNull(rsget("maskimage")) OR rsget("maskimage") = "") Then
					FItemList(i).FImageMask 	= "http://webimage.10x10.co.kr/image/mask/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("maskimage")
				end If
				
	'			If Not isNull(rsget("img1")) AND rsget("img1") <> "" Then FItemList(0).Fjust1dayImg1	= webImgUrl & "/just1day/" + rsget("img1")
	'			If Not isNull(rsget("img2")) AND rsget("img2") <> "" Then FItemList(0).Fjust1dayImg2	= webImgUrl & "/just1day/" + rsget("img2")
	'			If Not isNull(rsget("img3")) AND rsget("img3") <> "" Then FItemList(0).Fjust1dayImg3	= webImgUrl & "/just1day/" + rsget("img3")
	'			If Not isNull(rsget("img4")) AND rsget("img4") <> "" Then FItemList(0).Fjust1dayImg4	= webImgUrl & "/just1day/" + rsget("img4")

				FItemList(i).Fmakerid		= rsget("makerid")
				FItemList(i).Fbrandname		= db2html(rsget("brandname"))
				FItemList(i).Fitemid		= rsget("itemid")
				FItemList(i).Fitemname		= db2html(rsget("itemname"))
				FItemList(i).Foptioncnt		= rsget("optioncnt")
				FItemList(i).FSellYn		= rsget("SellYn")


				i = i + 1
			rsget.movenext
			Loop

		End If
		rsget.Close
	End Sub


End Class

'// 시간을 타이머용으로 변환
Function GetTranTimer(tt)
	if (tt="" or isNull(tt)) then Exit Function
	GetTranTimer = Num2Str(Year(tt),4,"0","R") & Num2Str(Month(tt),2,"0","R") & Num2Str(Day(tt),2,"0","R") &_
					Num2Str(Hour(tt),2,"0","R") & Num2Str(Minute(tt),2,"0","R") & Num2Str(Second(tt),2,"0","R")
End Function


%>
