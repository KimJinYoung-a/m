<%
'###############################################
' PageName : WCMSCls.asp
' Discription : 사이트 메인 관리 클래스
' History : 2013.04.04 허진원 : 생성
'###############################################

'===============================================
'// 클래스 아이템 선언
'===============================================
Class CCMSMainItem
    public FmainIdx
    public FtplIdx
    public FmainStartDate
    public FmainEndDate
    public FmainTitle
    public FmainTitleYn
    public FmainSortNo
    public FmainTimeYN
    public FmainIcon
    public FmainSubNum
    public FmainExtDataCd
    public FmainIsPreOpen
    public FmainIsUsing
    public FmainModiDate

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub

	public Function IsExpired()
		if datediff("h",FmainEndDate,now)>=0 or FmainIsUsing="N" then
			IsExpired = true
		else
			IsExpired = false
		end if
	End Function

end Class 

Class CCMSSubItem
    public FsubIdx
    public FmainIdx
    public FmainStartDate
    public FmainEndDate
    public FsubImage1
    public FsubImage2
    public FsubLinkUrl
    public FsubText1
    public FsubText2
    public FsubItemid
    public FsubVideoUrl
    public FsubBGColor
    public FsubImageDesc
    public FsubSortNo

    public Fitemname
    public FOrgprice
    public FSellCash
    public FitemSaleYn
    public FitemLimitYn
    public FitemRegdate
    public FItemCouponYN
    public Fitemcoupontype
    public Fitemcouponvalue

    public FImageList
    public FImageicon1
    public FImageBasic

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub

	'# 등록이미지 Full URL
	public Function getImageUrl(iNo)
		Select Case iNo
			Case 1, "1"
				if Not(FsubImage1="" or isNull(FsubImage1)) then
					getImageUrl = staticImgUrl & "/wcms" & FsubImage1
				end if
			Case 2, "2"
				if Not(FsubImage2="" or isNull(FsubImage2)) then
					getImageUrl = staticImgUrl & "/wcms" & FsubImage2
				end if
		end Select
	End Function

	'// 세일 상품 여부
	public Function IsSaleItem() 
	    IsSaleItem = chkIIF(FitemSaleYn="Y","Y","N")
	end Function

	'//	한정 여부
	public Function IsLimitItem() 
		IsLimitItem= chkIIF(FitemLimitYn="Y","Y","N")
	end Function
	
	'// 신상품 여부
	public Function IsNewItem() 
		if Not(FitemRegdate="" or isNull(FitemRegdate)) then
			IsNewItem =	chkIIF(datediff("d",FitemRegdate,now())<= 14,"Y","N")
		else
			IsNewItem = "N"
		end if
	end Function

	'// 상품 쿠폰 여부
	public Function IsCouponItem()
		IsCouponItem = chkIIF(FItemCouponYN="Y","Y","N")
	end Function

	'//사은품 증정 여부
	Public Function isGiftItem()
		dim tmpSQL,i
		dim blnTF
		if Not(FsubItemid="" or FsubItemid=0 or isNull(FsubItemid)) then
			tmpSQL = "Execute [db_item].[dbo].[sp_Ten_GiftExists] @vItemid = " & FsubItemid
			rsget.CursorLocation = adUseClient
			rsget.CursorType=adOpenStatic
			rsget.Locktype=adLockReadOnly
			rsget.Open tmpSQL, dbget,2

			If Not rsget.EOF Then
				blnTF 	= "Y"
			ELSE
				blnTF 	= "N"
			End if
			rsget.close
		else
			blnTF 	= "N"
		end if

		isGiftItem = blnTF
	End Function

	'// 할인가 (쿠폰할인 포함)
	public Function getSalePrice() 
		getSalePrice = FSellCash

		if IsCouponItem="Y" then
			getSalePrice = getSalePrice - GetCouponDiscountPrice
		end if
	end Function

	'// 할인율 '
	public Function getSalePro() 
		if Not(FOrgprice="" or isNull(FOrgprice)) then
			if FOrgprice=0 then
				getSalePro = 0 & "%"
			else
				'getSalePro = CLng((FOrgPrice-FSellCash)/FOrgPrice*100) & "%"
				getSalePro = CLng((FOrgPrice-getSalePrice)/FOrgPrice*100) & "%"
			end if
		end if
	end Function

	'// 쿠폰 할인가
	public Function GetCouponDiscountPrice() 
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				GetCouponDiscountPrice = CLng(Fitemcouponvalue*FOrgPrice/100)
			case "2" ''원 쿠폰
				GetCouponDiscountPrice = CLng(Fitemcouponvalue)
			case "3" ''무료배송 쿠폰
			    GetCouponDiscountPrice = 0
			case else
				GetCouponDiscountPrice = 0
		end Select

	end Function

end Class 



'===============================================
'// CMS 클래스
'===============================================
Class CCMSContent
    public FOneItem
    public FItemList()

	public FResultCount
    
    public FRectSiteDiv
    public FRectPageDiv
    public FRectTplIdx
    public FRectMainIdx
    public FRectSubIdx
    public FRectDateTerm
    public FRectIsUsing
    public FRectSelDate

	'------------------------------------------------
	'-- 메인페이지 정보 관련
	'------------------------------------------------
    '# 페이지정보 목록
	public Sub GetMainPageList()
		dim sqlStr, addSql, i

		'추가조건
		addSql = " Where mainIsUsing='Y' and mainStat=7 "
		if FRectSiteDiv<>"" then addSql = addSql & " and t.siteDiv='" & FRectSiteDiv & "'"
		if FRectPageDiv<>"" then addSql = addSql & " and t.pageDiv='" & FRectPageDiv & "'"
		if FRectTplIdx<>"" then addSql = addSql & " and m.tplIdx='" & FRectTplIdx & "'"
		if FRectDateTerm<>"" then addSql = addSql & " and dateadd(d," & FRectDateTerm & ",getdate()) between m.mainStartDate and m.mainEndDate "
		if FRectMainIdx<>"" then addSql = addSql & " and m.mainIdx in (" & FRectMainIdx & ") "

		'목록 접수
        sqlStr = "Select m.*, t.tplName "
        sqlStr = sqlStr & "From [db_sitemaster].[dbo].tbl_cms_mainInfo as m "
        sqlStr = sqlStr & "	join [db_sitemaster].[dbo].tbl_cms_template as t "
        sqlStr = sqlStr & "		on m.tplIdx=t.tplIdx "
        sqlStr = sqlStr & addSql
        sqlStr = sqlStr & " order by m.mainSortNo asc, m.mainIdx desc"

		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			Do until rsget.eof
				set FItemList(i) = new CCMSMainItem

	            FItemList(i).FmainIdx			= rsget("mainIdx")
	            FItemList(i).FtplIdx			= rsget("tplIdx")
	            FItemList(i).FmainStartDate		= rsget("mainStartDate")
	            FItemList(i).FmainEndDate		= rsget("mainEndDate")
	            FItemList(i).FmainTitle			= rsget("mainTitle")
	            FItemList(i).FmainTitleYn		= rsget("mainTitleYn")
	            FItemList(i).FmainSortNo		= rsget("mainSortNo")
	            FItemList(i).FmainTimeYN		= rsget("mainTimeYN")
	            FItemList(i).FmainIcon			= rsget("mainIcon")
	            FItemList(i).FmainSubNum		= rsget("mainSubNum")
	            FItemList(i).FmainExtDataCd		= rsget("mainExtDataCd")
	            FItemList(i).FmainIsPreOpen		= rsget("mainIsPreOpen")
	            FItemList(i).FmainIsUsing		= rsget("mainIsUsing")
	            if Not(rsget("mainLastModiDate")="" or isNull(rsget("mainLastModiDate"))) then
	            	FItemList(i).FmainModiDate		= rsget("mainLastModiDate")
	            else
	            	FItemList(i).FmainModiDate		= rsget("mainRegDate")
	            end if

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub


	'------------------------------------------------
	'-- 소재정보 관련
	'------------------------------------------------
    '# 소재정보 목록
	public Sub GetMainSubItem()
		dim sqlStr, addSql, i

		'추가조건
		addSql = "Where s.mainIdx='" & FRectMainIdx & "'"
		addSql = addSql & " and s.subIsUsing='Y' "
		if FRectDateTerm<>"" then addSql = addSql & " and dateadd(d," & FRectDateTerm & ",getdate()) between m.mainStartDate and m.mainEndDate "

		'목록 접수
        sqlStr = "Select s.*, orgprice, sellCash, i.sailyn, i.limitYn, i.regdate, i.itemcouponYn, i.itemcoupontype, i.itemcouponvalue "
        sqlStr = sqlStr & "	,i.itemname, i.ListImage, i.icon1image, i.basicimage "
        sqlStr = sqlStr & "From [db_sitemaster].[dbo].tbl_cms_subInfo as s "
        sqlStr = sqlStr & "	join [db_sitemaster].[dbo].tbl_cms_mainInfo as m "
        sqlStr = sqlStr & "		on s.mainIdx=m.mainIdx "
        sqlStr = sqlStr & "	left join db_item.dbo.tbl_item as i "
        sqlStr = sqlStr & "		on s.subItemid=i.itemid "
        sqlStr = sqlStr & "			and i.itemid<>0 "
        sqlStr = sqlStr & addSql
        sqlStr = sqlStr & " order by s.subSortNo asc, s.subIdx desc"
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		webImgUrl = "http://webimage.10x10.co.kr"
		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			Do until rsget.eof
				set FItemList(i) = new CCMSSubItem

	            FItemList(i).FsubIdx			= rsget("subIdx")
	            FItemList(i).FmainIdx			= rsget("mainIdx")
	            FItemList(i).FsubImage1			= rsget("subImage1")
	            FItemList(i).FsubImage2			= rsget("subImage2")
	            FItemList(i).FsubLinkUrl		= rsget("subLinkUrl")
	            FItemList(i).FsubText1			= rsget("subText1")
	            FItemList(i).FsubText2			= rsget("subText2")
	            FItemList(i).FsubItemid			= rsget("subItemid")
	            FItemList(i).FsubVideoUrl		= rsget("subVideoUrl")
	            FItemList(i).FsubBGColor		= rsget("subBGColor")
	            FItemList(i).FsubImageDesc		= rsget("subImageDesc")
	            FItemList(i).FsubSortNo			= rsget("subSortNo")

	            FItemList(i).Fitemname			= null2blank(rsget("itemname"))
	            FItemList(i).FOrgprice			= null2blank(rsget("orgprice"))
	            FItemList(i).FSellCash			= null2blank(rsget("sellCash"))
	            FItemList(i).FitemSaleYn		= null2blank(rsget("sailyn"))
	            FItemList(i).FitemLimitYn		= null2blank(rsget("limitYn"))
	            FItemList(i).FitemRegdate		= null2blank(rsget("regdate"))
	            FItemList(i).FItemCouponYN		= null2blank(rsget("itemcouponYn"))
	            FItemList(i).Fitemcoupontype	= null2blank(rsget("itemcoupontype"))
	            FItemList(i).Fitemcouponvalue	= null2blank(rsget("itemcouponvalue"))

	            FItemList(i).FImageList			= chkIIF(Not(rsget("ListImage")="" or isNull(rsget("ListImage"))),webImgUrl & "/image/list/" & GetImageSubFolderByItemid(FItemList(i).FsubItemid) & "/" & rsget("ListImage"),"")
	            FItemList(i).FImageicon1		= chkIIF(Not(rsget("ListImage")="" or isNull(rsget("ListImage"))),webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(FItemList(i).FsubItemid) & "/" & rsget("icon1image"),"")
	            FItemList(i).FImageBasic		= chkIIF(Not(rsget("ListImage")="" or isNull(rsget("ListImage"))),webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(FItemList(i).FsubItemid) & "/" + rsget("basicimage"),"")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub



	'------------------------------------------------
	'-- 이벤트 메인정보 관련
	'------------------------------------------------
    '# 소재정보 목록
	public Sub GetEventMainItem()
		dim sqlStr, addSql, i

		'추가조건
		addSql = "Where m.tplIdx=11"			'이벤트 메인 템블릿코드 (11)
		addSql = addSql & " and m.mainIsUsing='Y' "
		addSql = addSql & " and m.mainStat=7 "
		addSql = addSql & " and s.subIsUsing='Y' "

		if FRectSelDate<>"" then
			addSql = addSql & " and dateadd(d,5,'" & FRectSelDate & "')>=mainStartDate "
			addSql = addSql & " and '" & FRectSelDate & "'<=mainEndDate "
		else
			addSql = addSql & " and dateadd(d,5,getdate())>=mainStartDate "
			addSql = addSql & " and getdate()<=mainEndDate "
		end if

		'목록 접수
        sqlStr = "Select mainStartDate, mainEndDate, subImage1, subLinkUrl, subBgColor, subImageDesc "
        sqlStr = sqlStr & "from db_sitemaster.dbo.tbl_cms_mainInfo as m "
        sqlStr = sqlStr & "	join db_sitemaster.dbo.tbl_cms_subinfo as s "
        sqlStr = sqlStr & "		on m.mainidx=s.mainidx "
        sqlStr = sqlStr & addSql
        sqlStr = sqlStr & " order by m.mainSortNo, s.subSortNo, m.mainIdx desc, s.subIdx desc"
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			Do until rsget.eof
				set FItemList(i) = new CCMSSubItem

	            FItemList(i).FsubImage1			= rsget("subImage1")
	            FItemList(i).FsubLinkUrl		= rsget("subLinkUrl")
	            FItemList(i).FsubBGColor		= rsget("subBGColor")
	            FItemList(i).FsubImageDesc		= rsget("subImageDesc")
				FItemList(i).FmainStartDate		= rsget("mainStartDate")
				FItemList(i).FmainEndDate		= rsget("mainEndDate")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub


	'------------------------------------------------
	'-- 클래스 기본설정 및 기타 함수
	'------------------------------------------------

    Private Sub Class_Initialize()
		redim  FItemList(0)
		FResultCount      = 0
	End Sub

	Private Sub Class_Terminate()
    End Sub
end Class 
%>