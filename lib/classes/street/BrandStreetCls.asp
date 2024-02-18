<%
'#######################################################
' Description : 브랜드
' History : 2014.09.21 한용민 생성
'#######################################################

Class CStreetItem
	Public FBrandgubun
	Public FSubtopimage
	Public FCatecode
	Public FBgImageURL
	Public FStoryTitle
	Public FStoryContent
	Public FPhilosophyTitle
	Public FPhilosophyContent
	Public FDesignis
	Public FBookmark1SiteName
	Public FBookmark1SiteURL
	Public FBookmark1SiteDetail
	Public FBookmark2SiteName
	Public FBookmark2SiteURL
	Public FBookmark2SiteDetail
	Public FBookmark3SiteName
	Public FBookmark3SiteURL
	Public FBookmark3SiteDetail
	Public FBrandTag
	Public FSamebrand
	Public FIsusing
	Public FSamebrandID
	Public FSocname
	Public FSocname_kor
	public FMakerid
	public Fsoclogo
	public Fdgncomment
	public fidx
	public ftype
	public fregdate
	public fsellyn
	public flimityn
	public flimitno
	public flimitsold
	public fdanjongyn
	public fsellcash
	public fbuycash
	public Fdiv
	public Fhitflg
	public Fnewflg
	public Fsaleflg
	public Fonlyflg
	public fsmileflg
	public fgiftflg
	public Fartistflg
	public Fkdesignflg
	public Ftitleimgurl
	public FRecommendcount
	public FTodayRecommendcount
	public fitemcount
	public FTopbrandcount
	public FRecentTopbrandyn
	public FevtCode
	public FevtName
	public FItemId
	public FItemName
	public FEvalcnt
	public Ficon1Image
	public Ficon2Image
	public FImageMain
	public FImageList
	public FImageSmall
	public FImageBasic
	public flistimage120
	public Fevt_kind
	public Fevt_enddate
	public FCDLarge
	public FCDMid
	public FCDSmall
	public FCateName
	public FDFidx
	public FDFName
	public Fevt_bannerimg
	public Fevt_bannerimg2010
	public Fevt_newest
	public Fevt_bannerlink
	public FSaleYn
	public FOrgPrice
	public FSpecialUserItem
	dim FItemDiv
	public FItemCouponYN
	public Fitemcoupontype
	public Fitemcouponvalue
	public FmaxSaleValue
	public FminSaleValue
	public FCategory
	public fitemarr

	'//베스트브랜드
	public function IsHitBrand()
		IsHitBrand = (Fhitflg="Y")
	end function

	'//뉴브랜드
	public function IsNewBrand()
		IsNewBrand = (Fnewflg="Y")
	end function

	'//찜브랜드
	public function IsZimBrand()
		IsZimBrand = (FRecommendcount>=1000) or (FTodayRecommendcount>=5)
	end function

	'//아티스트브랜드
	public function IsArtistBrand()
		IsArtistBrand = (Fartistflg="Y")
	end function

	'//온리브랜드
	public function IsOnlyBrand()
		IsOnlyBrand = (Fonlyflg="Y")
	end function

	'//케이디자인브랜드
	public function IsKdesignBrand()
		IsKdesignBrand = (Fkdesignflg="Y")
	end function

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public function getTitleImgUrl()
		IF application("Svr_Info") = "Dev" THEN
			getTitleImgUrl = "http://testwebimage.10x10.co.kr/image/brandlogo/" + Ftitleimgurl
		Else
			getTitleImgUrl = "http://webimage.10x10.co.kr/image/brandlogo/" + Ftitleimgurl
		End If
	end function

	'// 세일 상품 여부 '!
	public Function IsSaleItem()
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem)
	end Function

	'//	한정 여부 '!
	public Function IsLimitItem()
			IsLimitItem= (FLimitYn="Y")
	end Function

	'// 신상품 여부 '!
	public Function IsNewItem()
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function

	'// 우수회원샵 상품 여부 '!
	public Function IsSpecialUserItem()
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>0 and uLevel<>5)
	end Function

	public Function getRealPrice()

		getRealPrice = FSellCash


		if (IsSpecialUserItem()) then
			getRealPrice = getSpecialShopItemPrice(FSellCash)
		end if
	end Function

	public Function IsMileShopitem()
		IsMileShopitem = (FItemDiv="82")
	end Function

	public Function getOrgPrice()
		if FOrgPrice=0 then
			getOrgPrice = FSellCash
		else
			getOrgPrice = FOrgPrice
		end if
	end Function

	public Function getSalePro()
		if FOrgprice=0 then
			getSalePro = 0 & "%"
		else
			getSalePro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100) & "%"
		end if
	end Function

	'// 상품 쿠폰 여부  '!
	public Function IsCouponItem()
			IsCouponItem = (FItemCouponYN="Y")
	end Function

	public function IsFreeBeasongCoupon()
		IsFreeBeasongCoupon = Fitemcoupontype="3"
	end function
	'// 쿠폰 적용가
	public Function GetCouponAssignPrice() '!
		if (IsCouponItem) then
			GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
		else
			GetCouponAssignPrice = getRealPrice
		end if
	end Function

	'// 쿠폰 할인가 '?
	public Function GetCouponDiscountPrice()
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				GetCouponDiscountPrice = CLng(Fitemcouponvalue*getRealPrice/100)
			case "2" ''원 쿠폰
				GetCouponDiscountPrice = Fitemcouponvalue
			case "3" ''무료배송 쿠폰
			    GetCouponDiscountPrice = 0
			case else
				GetCouponDiscountPrice = 0
		end Select

	end Function

	public function GetCouponDiscountStr()

		Select Case Fitemcoupontype
			Case "1"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "%"
			Case "2"
				GetCouponDiscountStr = formatNumber(Fitemcouponvalue,0) + "원 할인"
			Case "3"
				GetCouponDiscountStr ="무료배송"
			Case Else
				GetCouponDiscountStr = Fitemcoupontype
		End Select

	end function
end Class

Class CStreet
	public FItemList()
	public FOneItem
	public FpageSize
	public FResultCount
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FScrollCount
	public FPageCount

	public FRectMakerid
	public FRectCDL
	public FRectLang
	public FRectKind
	public Frectchar1
	public Frectchar2
	public FrectchrCd
	public FBrandName
	public FRectTop
	public FRectFlag


	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
	'// 브랜드 정보
	public Sub GetBrandInfo()
		dim sqlStr

		if (FRectMakerid="") then Exit sub

		sqlStr =	"exec db_user.dbo.sp_Ten_BrandStreet_Info '" & FRectMakerid & "'"

		rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic
		'rsget.Open sqlStr,dbget
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		FResultCount = rsget.RecordCount

		set FOneItem = new CStreetItem

		if Not Rsget.Eof then
			FOneItem.FMakerid 			= rsget("userid")
			FOneItem.Fsocname 			= db2html(rsget("socname"))
			FOneItem.Fsocname_kor 		= db2html(rsget("socname_kor"))

			IF rsget("soclogo")<>"" Then
				FOneItem.Fsoclogo	=	"http://webimage.10x10.co.kr/image/brandlogo/" & db2html(rsget("soclogo"))
			Else
				FOneItem.Fsoclogo	=	"http://fiximage.10x10.co.kr/web2008/street/brandimg_blank.gif"
			End IF

			FOneItem.Fdgncomment		= db2html(rsget("dgncomment"))
			FOneItem.Fhitflg			= rsget("hitflg")
			FOneItem.Fnewflg			= rsget("newflg")
			FOneItem.Fsaleflg			= rsget("saleflg")
			FOneItem.Fonlyflg			= rsget("onlyflg")
			FOneItem.Fartistflg			= rsget("artistflg")
			FOneItem.Fkdesignflg			= rsget("kdesignflg")
			FOneItem.Fsamebrand			= rsget("samebrand")
			FOneItem.Frecommendcount		= rsget("recommendcount")
			FOneItem.Ftodayrecommendcount	= rsget("todayrecommendcount")
			FOneItem.FTopbrandcount		= rsget("topbrandcount")
			FOneItem.FRecentTopbrandyn 	= rsget("recenttopbrandyn")
			FOneItem.FevtCode			= rsget("brandDayEvt")
			FOneItem.FevtName			= rsget("brandDayEvtName")
			FOneItem.Ftitleimgurl			= rsget("titleimgurl")
		end if

		rsget.close
	end sub

	'//street/street_brand.asp		'/2014.09.23 한용민 생성
	public Sub GetBrandstreetInfo()
		dim sqlStr

		if (FRectMakerid="") then Exit sub

		sqlStr = "exec db_brand.dbo.sp_Ten_street_Info '" & FRectMakerid & "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		FResultCount = rsget.RecordCount

		set FOneItem = new CStreetItem

		if Not Rsget.Eof then
			FOneItem.FMakerid 			= rsget("userid")
			FOneItem.Fsocname 			= db2html(rsget("socname"))
			FOneItem.Fsocname_kor 		= db2html(rsget("socname_kor"))

			IF rsget("soclogo")<>"" Then
				FOneItem.Fsoclogo	=	"http://webimage.10x10.co.kr/image/brandlogo/" & db2html(rsget("soclogo"))
			Else
				FOneItem.Fsoclogo	=	"http://fiximage.10x10.co.kr/web2008/street/brandimg_blank.gif"
			End IF

			FOneItem.Fdgncomment		= db2html(rsget("dgncomment"))
			FOneItem.Fhitflg				= rsget("hitflg")
			FOneItem.Fnewflg				= rsget("newflg")
			FOneItem.fsmileflg				= rsget("smileflg")
			FOneItem.fgiftflg				= rsget("giftflg")
			FOneItem.Fsaleflg				= rsget("saleflg")
			FOneItem.Fonlyflg				= rsget("onlyflg")
			FOneItem.Fartistflg				= rsget("artistflg")
			FOneItem.Fkdesignflg			= rsget("kdesignflg")
			FOneItem.Frecommendcount		= rsget("recommendcount")
			FOneItem.Ftodayrecommendcount	= rsget("todayrecommendcount")
			FOneItem.fitemcount	= rsget("itemcount")
			FOneItem.Fsamebrand			= rsget("samebrand")
			FOneItem.FTopbrandcount		= rsget("topbrandcount")
			FOneItem.FRecentTopbrandyn 	= rsget("recenttopbrandyn")
			FOneItem.Ftitleimgurl			= rsget("titleimgurl")
			FOneItem.fitemid = rsget("itemid")
			FOneItem.FImageBasic = rsget("basicimage")
			'FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")

			FOneItem.FCatecode				= rsget("catecode")
			FOneItem.FBgImageURL			= rsget("bgImageURL")
			FOneItem.FStoryTitle			= db2html(rsget("StoryTitle"))
			FOneItem.FStoryContent			= db2html(rsget("StoryContent"))
			FOneItem.FPhilosophyTitle		= db2html(rsget("philosophyTitle"))
			FOneItem.FPhilosophyContent		= db2html(rsget("philosophyContent"))
			FOneItem.FDesignis				= db2html(rsget("designis"))
			FOneItem.FBookmark1SiteName		= db2html(rsget("bookmark1SiteName"))
			FOneItem.FBookmark1SiteURL		= db2html(rsget("bookmark1SiteURL"))
			FOneItem.FBookmark1SiteDetail	= db2html(rsget("bookmark1SiteDetail"))
			FOneItem.FBookmark2SiteName		= db2html(rsget("bookmark2SiteName"))
			FOneItem.FBookmark2SiteURL		= db2html(rsget("bookmark2SiteURL"))
			FOneItem.FBookmark2SiteDetail	= db2html(rsget("bookmark2SiteDetail"))
			FOneItem.FBookmark3SiteName		= db2html(rsget("bookmark3SiteName"))
			FOneItem.FBookmark3SiteURL		= db2html(rsget("bookmark3SiteURL"))
			FOneItem.FBookmark3SiteDetail	= db2html(rsget("bookmark3SiteDetail"))
			FOneItem.FBrandTag				= rsget("brandTag")
			FOneItem.FSamebrand				= rsget("samebrand")			
		end if

		rsget.close
	end sub

	'// 브랜드 베스트상품 목록 // /street/street_brand.asp
	public sub GetBrandBestItemList()
		dim sqlStr, i

		'// 목록 접수 //
		sqlStr =	"exec db_user.dbo.sp_Ten_BrandStreet_BestItem " & FpageSize & ",'" & FRectMakerid & "'"

		rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic
		'rsget.Open sqlStr,dbget
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CStreetItem

				FItemList(i).FitemId = rsget("itemid")
				FItemList(i).FImageMain = "http://webimage.10x10.co.kr/image/main/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("mainimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("smallimage")
				FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
				FItemList(i).Ficon1Image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1image")
				FItemList(i).fisusing	= rsget("isusing")
				FItemList(i).fitemname	= db2html(rsget("itemname"))
				FItemList(i).FOrgPrice = rsget("orgprice")
				FItemList(i).FEvalcnt = rsget("evalcnt")
				FItemList(i).fSellYn	= rsget("SellYn")
				FItemList(i).FSaleYn	= rsget("sailyn")
				FItemList(i).fLimitYn	= rsget("LimitYn")
				FItemList(i).fLimitNo	= rsget("LimitNo")
				FItemList(i).fLimitSold	= rsget("LimitSold")
				FItemList(i).fdanjongyn	= rsget("danjongyn")
				FItemList(i).fsellcash	= rsget("sellcash")
				FItemList(i).fbuycash	= rsget("buycash")
				FItemList(i).fbuycash	= rsget("buycash")
				FItemList(i).FItemCouponYN = rsget("itemcouponyn")
				FItemList(i).Fitemcoupontype = rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue = rsget("itemcouponvalue")
				i=i+1
				rsget.moveNext
			loop

		end if
		rsget.Close
	end sub


	'// 브랜드 상품 카테고리 //
	public Sub GetBrandItemCategory()
		dim sqlStr, i

		sqlStr = "exec [db_user].[dbo].sp_Ten_BrandStreet_category '" +  FRectMakerid + "'" + vbcrlf

		rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic
		'rsget.Open sqlStr,dbget
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		FResultCount = rsget.recordcount

		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
		do until rsget.EOF
				set FItemList(i) = new CStreetItem

				 FItemList(i).FCDLarge	= rsget("cdlarge")
				 FItemList(i).FCDMid	= rsget("cdmid")
				 FItemList(i).FCDSmall	= rsget("cdsmall")
				 FItemList(i).FCateName	= rsget("CateName")

				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close

	end sub

	'####### 내카테고리 리스트
	public Function fnBrandList
		'####### 카테고리코드 한개 필드만 받아옴. catecode 값.
		Dim strSql, i

		strSql = "EXECUTE [db_item].[dbo].[sp_Ten_Brandlist_Count_Mobile] '" & FpageSize & "', '" & Frectchar1 & "', '" & Frectchar2 & "', '" & FrectchrCd & "', '" & FRectLang & "', '" & FRectFlag & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close


		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_item].[dbo].[sp_Ten_Brandlist_Mobile] '" & (FpageSize*FCurrPage) & "', '" & Frectchar1 & "', '" & Frectchar2 & "', '" & FrectchrCd & "', '" & FRectLang & "', '" & FRectFlag & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			'response.write strSql

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)

			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CStreetItem

					FItemList(i).Fmakerid				= rsget("userid")
					FItemList(i).Fsocname				= db2html(rsget("socname"))
					FItemList(i).Fsocname_kor			= db2html(rsget("socname_kor"))
					FItemList(i).Fhitflg				= rsget("hitflg")
					FItemList(i).Fnewflg				= rsget("newflg")
					FItemList(i).Fsaleflg				= rsget("saleflg")
					FItemList(i).Fonlyflg				= rsget("onlyflg")
					FItemList(i).Fartistflg				= rsget("artistflg")
					FItemList(i).Fkdesignflg			= rsget("kdesignflg")
					FItemList(i).Frecommendcount		= rsget("recommendcount")
					FItemList(i).Ftodayrecommendcount	= rsget("todayrecommendcount")
					FItemList(i).FImageBasic			= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(Split(rsget("item"),"||")(0)) & "/" &db2html(Split(rsget("item"),"||")(1))
					FItemList(i).FCategory				= rsget("category")

					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Function

	'/street/brandlist.asp		'/2014.09.21 한용민 생성
	public Function fnstreetBrandList
		Dim strSql, i

		strSql = "EXECUTE db_brand.dbo.sp_Ten_street_list_Count '" & FpageSize & "', '" & Frectchar1 & "', '" & Frectchar2 & "', '" & FrectchrCd & "', '" & FRectLang & "', '" & FRectFlag & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'response.write strSql & "<BR>"
		rsget.Open strSql,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close

		if FTotalCount<1 then exit Function

		strSql = "EXECUTE db_brand.dbo.sp_Ten_street_list '" & (FpageSize*FCurrPage) & "', '" & Frectchar1 & "', '" & Frectchar2 & "', '" & FrectchrCd & "', '" & FRectLang & "', '" & FRectFlag & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		
		'response.write strSql & "<BR>"
		rsget.Open strSql,dbget,1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CStreetItem

				FItemList(i).Fmakerid				= rsget("userid")
				FItemList(i).Fsocname				= db2html(rsget("socname"))
				FItemList(i).Fsocname_kor			= db2html(rsget("socname_kor"))
				FItemList(i).Fhitflg				= rsget("hitflg")
				FItemList(i).Fnewflg				= rsget("newflg")
				FItemList(i).fsmileflg				= rsget("smileflg")
				FItemList(i).fgiftflg				= rsget("giftflg")
				FItemList(i).Fsaleflg				= rsget("saleflg")
				FItemList(i).Fonlyflg				= rsget("onlyflg")
				FItemList(i).Fartistflg				= rsget("artistflg")
				FItemList(i).Fkdesignflg			= rsget("kdesignflg")
				FItemList(i).Frecommendcount		= rsget("recommendcount")
				FItemList(i).Ftodayrecommendcount	= rsget("todayrecommendcount")
				FItemList(i).fitemcount	= rsget("itemcount")
				'FItemList(i).FImageBasic			= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(Split(rsget("item"),"||")(0)) & "/" &db2html(Split(rsget("item"),"||")(1))
				FItemList(i).fitemarr				= rsget("itemarr")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Function
end Class

function getbrandstreetorder(order)		'/2014.09.30 한용민 생성
	dim temporder
	
	if order="ctab1" then
		temporder="NEW"
	elseif order="ctab2" then
		temporder="ZZIM"
	elseif order="ctab3" then
		temporder="BEST"
	elseif order="ctab5" then
		temporder="ARTIST"
	elseif order="ctab7" then
		temporder="LOOKBOOK"
	elseif order="ctab8" then
		temporder="INTERVIEW"
	else
		temporder="전체"
	end if

	getbrandstreetorder=temporder
end function

'// 스트리트 브랜드명 검색어 반환
function convertChar(lang, chrCd, byref chr1 , byref chr2)
	select case lang

		'//한글
		case "K"
			select case chrCd
				Case "가": chr1="ㄱ": chr2="ㄴ"
				Case "나": chr1="ㄴ": chr2="ㄷ"
				Case "다": chr1="ㄷ": chr2="ㄹ"
				Case "라": chr1="ㄹ": chr2="ㅁ"
				Case "마": chr1="ㅁ": chr2="ㅂ"
				Case "바": chr1="ㅂ": chr2="ㅅ"
				Case "사": chr1="ㅅ": chr2="ㅇ"
				Case "아": chr1="ㅇ": chr2="ㅈ"
				Case "자": chr1="ㅈ": chr2="ㅊ"
				Case "차": chr1="ㅊ": chr2="ㅋ"
				Case "카": chr1="ㅋ": chr2="ㅌ"
				Case "타": chr1="ㅌ": chr2="ㅍ"
				Case "파": chr1="ㅍ": chr2="ㅎ"
				Case "하": chr1="ㅎ": chr2="힣"
				Case "Ω": chr1="": chr2=""
			end select

		'//영어
		case "E"
			select case chrCd
				Case "A": chr1="A": chr2="A"
				Case "B": chr1="B": chr2="B"
				Case "C": chr1="C": chr2="C"
				Case "D": chr1="D": chr2="D"
				Case "E": chr1="E": chr2="E"
				Case "F": chr1="F": chr2="F"
				Case "G": chr1="G": chr2="G"
				Case "H": chr1="H": chr2="H"
				Case "I": chr1="I": chr2="I"
				Case "J": chr1="J": chr2="J"
				Case "K": chr1="K": chr2="K"
				Case "L": chr1="L": chr2="L"
				Case "M": chr1="M": chr2="M"
				Case "N": chr1="N": chr2="N"
				Case "O": chr1="O": chr2="O"
				Case "P": chr1="P": chr2="P"
				Case "Q": chr1="Q": chr2="Q"
				Case "R": chr1="R": chr2="R"
				Case "S": chr1="S": chr2="S"
				Case "T": chr1="T": chr2="T"
				Case "U": chr1="U": chr2="U"
				Case "V": chr1="V": chr2="V"
				Case "W": chr1="W": chr2="W"
				Case "X": chr1="X": chr2="X"
				Case "Y": chr1="Y": chr2="Y"
				Case "Z": chr1="Z": chr2="Z"
				Case "Σ": chr1="": chr2=""
			end select
	end select
end function


'// 카테고리 코드 > 이름으로 변환
Function getCategoryNameDB(cd1,cd2,cd3)
	Dim SQL

	if cd1<>"" then
		SQL =	"exec db_item.dbo.sp_Ten_category_name '" & cd1 & "', '" & cd2 & "', '" & cd3 & "'"
		'rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic
		'rsget.Open SQL, dbget
		rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

			if NOT(rsget.EOF or rsget.BOF) then
				getCategoryNameDB = db2html(rsget(0))
			else
				getCategoryNameDB = "브랜드 전체"
			end if
		rsget.Close
	else
		getCategoryNameDB = "브랜드 전체"
	end if
End Function

'//카테고리
function drawCDLcategory(boxname, stats )
	dim userquery, tem_str

	response.write "<select  id='select' class='input_category' name='" & boxname & "' onchange='gocategory(this.value);'>"
	response.write "<option value=''"
		if stats ="" then
			response.write " selected"
		end if
	response.write ">카테고리 전체보기</option>"

		userquery = "select code_large ,code_nm ,display_yn ,channel"
		userquery = userquery + " from db_item.dbo.tbl_Cate_large"
		userquery = userquery + " where  code_large<>999 "
		userquery = userquery + " and display_yn ='Y'"

	rsget.Open userquery, dbget, 1
	'response.write userquery&"<br>"

	if not rsget.EOF then
		do until rsget.EOF
			if cstr(stats) = cstr(rsget("code_large")) then
				tem_str = " selected"
			end if
			response.write "<option value='" & rsget("code_large") & "' " & tem_str & ">" & rsget("code_nm") & "</option>"
			tem_str = ""
			rsget.movenext
		loop
	end if
	rsget.close
	response.write "</select>"
End function

'//카테고리
function drawbrandcategory(boxname, stats, makerid)
	dim userquery, tem_str

	'response.write "<select name='" & boxname & "' id='select' class='input_category' onchange='fnSearchCat(this.value);'>"
	response.write "<option value=''"
		if stats ="" then
			response.write " selected"
		end if
	response.write ">카테고리 전체보기</option>"

'''		userquery = "select d.catecode, d.catename, count(i.itemid) as cnt"
'''		userquery = userquery + " from db_item.dbo.tbl_display_cate as d "
'''		userquery = userquery + " inner join db_item.dbo.tbl_display_cate_item as di on d.catecode = Left(di.catecode,3) and di.isDefault = 'y' "
'''		userquery = userquery + " inner join db_item.dbo.tbl_item as i on di.itemid = i.itemid "
'''		userquery = userquery + " where d.depth = '1' and i.makerid = '"&makerid&"' and i.sellyn <> 'N' "
'''		userquery = userquery + " group by d.catecode, d.catename, d.sortNo order by d.sortNo asc"

		userquery = "select i.dispcate1 as catecode , d.catename, count(i.itemid) as cnt "
        userquery = userquery + " from db_item.dbo.tbl_item as i "
        userquery = userquery + " inner join db_item.dbo.tbl_display_cate as d  "
        userquery = userquery + " on d.catecode=i.dispcate1"
        userquery = userquery + " and d.depth=1"
        userquery = userquery + " and i.makerid = '"&makerid&"' "
        userquery = userquery + " and i.sellyn <> 'N' "
        userquery = userquery + " group by i.dispcate1, d.catename, d.sortNo "
        userquery = userquery + " order by d.sortNo asc"

'response.write userquery&"<br>"
	rsget.Open userquery, dbget, 1

	if not rsget.EOF then
		do until rsget.EOF
			if cstr(stats) = cstr(rsget("catecode")) then
				tem_str = " selected"
			end if
			response.write "<option value='" & rsget("catecode") & "' " & tem_str & ">" & rsget("catename") &" ("& rsget("cnt") &")"& "</option>"
			tem_str = ""
			rsget.movenext
		loop
	end if
	rsget.close
	'response.write "</select>"
End function


'// 상품 이미지 경로를 계산하여 반환 //
function GetImageSubFolderByItemid(byval iitemid)
    if (iitemid <> "") then
	    GetImageSubFolderByItemid = Num2Str(CStr(Clng(iitemid) \ 10000),2,"0","R")
	else
	    GetImageSubFolderByItemid = ""
	end if
end function

Function charListBoxall(lang,value)		'//2014.09.30 한용민 생성
	Dim vBody
	If lang = "K" Then
		vBody = vBody & "<option value=""가"" " & CHKIIF(value="가","selected","") & ">가</option>"
		vBody = vBody & "<option value=""나"" " & CHKIIF(value="나","selected","") & ">나</option>"
		vBody = vBody & "<option value=""다"" " & CHKIIF(value="다","selected","") & ">다</option>"
		vBody = vBody & "<option value=""라"" " & CHKIIF(value="라","selected","") & ">라</option>"
		vBody = vBody & "<option value=""마"" " & CHKIIF(value="마","selected","") & ">마</option>"
		vBody = vBody & "<option value=""바"" " & CHKIIF(value="바","selected","") & ">바</option>"
		vBody = vBody & "<option value=""사"" " & CHKIIF(value="사","selected","") & ">사</option>"
		vBody = vBody & "<option value=""아"" " & CHKIIF(value="아","selected","") & ">아</option>"
		vBody = vBody & "<option value=""자"" " & CHKIIF(value="자","selected","") & ">자</option>"
		vBody = vBody & "<option value=""차"" " & CHKIIF(value="차","selected","") & ">차</option>"
		vBody = vBody & "<option value=""카"" " & CHKIIF(value="카","selected","") & ">카</option>"
		vBody = vBody & "<option value=""타"" " & CHKIIF(value="타","selected","") & ">타</option>"
		vBody = vBody & "<option value=""파"" " & CHKIIF(value="파","selected","") & ">파</option>"
		vBody = vBody & "<option value=""하"" " & CHKIIF(value="하","selected","") & ">하</option>"
	ElseIf lang = "E" Then
		vBody = vBody & "<option value=""A"" " & CHKIIF(value="A","selected","") & ">A</option>"
		vBody = vBody & "<option value=""B"" " & CHKIIF(value="B","selected","") & ">B</option>"
		vBody = vBody & "<option value=""C"" " & CHKIIF(value="C","selected","") & ">C</option>"
		vBody = vBody & "<option value=""D"" " & CHKIIF(value="D","selected","") & ">D</option>"
		vBody = vBody & "<option value=""E"" " & CHKIIF(value="E","selected","") & ">E</option>"
		vBody = vBody & "<option value=""F"" " & CHKIIF(value="F","selected","") & ">F</option>"
		vBody = vBody & "<option value=""G"" " & CHKIIF(value="G","selected","") & ">G</option>"
		vBody = vBody & "<option value=""H"" " & CHKIIF(value="H","selected","") & ">H</option>"
		vBody = vBody & "<option value=""I"" " & CHKIIF(value="I","selected","") & ">I</option>"
		vBody = vBody & "<option value=""J"" " & CHKIIF(value="J","selected","") & ">J</option>"
		vBody = vBody & "<option value=""K"" " & CHKIIF(value="K","selected","") & ">K</option>"
		vBody = vBody & "<option value=""L"" " & CHKIIF(value="L","selected","") & ">L</option>"
		vBody = vBody & "<option value=""M"" " & CHKIIF(value="M","selected","") & ">M</option>"
		vBody = vBody & "<option value=""N"" " & CHKIIF(value="N","selected","") & ">N</option>"
		vBody = vBody & "<option value=""O"" " & CHKIIF(value="O","selected","") & ">O</option>"
		vBody = vBody & "<option value=""P"" " & CHKIIF(value="P","selected","") & ">P</option>"
		vBody = vBody & "<option value=""Q"" " & CHKIIF(value="Q","selected","") & ">Q</option>"
		vBody = vBody & "<option value=""R"" " & CHKIIF(value="R","selected","") & ">R</option>"
		vBody = vBody & "<option value=""S"" " & CHKIIF(value="S","selected","") & ">S</option>"
		vBody = vBody & "<option value=""T"" " & CHKIIF(value="T","selected","") & ">T</option>"
		vBody = vBody & "<option value=""U"" " & CHKIIF(value="U","selected","") & ">U</option>"
		vBody = vBody & "<option value=""V"" " & CHKIIF(value="V","selected","") & ">V</option>"
		vBody = vBody & "<option value=""W"" " & CHKIIF(value="W","selected","") & ">W</option>"
		vBody = vBody & "<option value=""X"" " & CHKIIF(value="X","selected","") & ">X</option>"
		vBody = vBody & "<option value=""Y"" " & CHKIIF(value="Y","selected","") & ">Y</option>"
		vBody = vBody & "<option value=""Z"" " & CHKIIF(value="Z","selected","") & ">Z</option>"
		vBody = vBody & "<option value=""Σ"" " & CHKIIF(value="Σ","selected","") & ">etc.</option>"
	End IF

	charListBoxall = vBody
End Function


Sub charListBoxallV16(sLang,sChar,sCallback)		'//2016.05.20; 허진원
	Dim sName, sResult, lp
	dim arrChar
	if sLang="" then sLang="K"
	if sChar="" then sChar="가"

	If sLang = "K" Then
		arrChar = split("가,나,다,라,마,바,사,아,자,차,카,타,파,하",",")
	ElseIf sLang = "E" Then
		arrChar = split("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,Σ",",")
	end if

	for lp=0 to ubound(arrChar)
		sResult = sResult& "		<li " & chkIIF(sChar=arrChar(lp),"class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('" & arrChar(lp) & "');return false;"">" & chkIIF(arrChar(lp)="Σ","etc.",arrChar(lp)) & "</a></li>" & vbCrLf
		if sChar=arrChar(lp) then sName = chkIIF(arrChar(lp)="Σ","etc.",arrChar(lp))
	next

	sResult = "<button type=""button"">" & sName & "</button>" & vbCrLf &_
			"	<div class=""sortNaviV16a"">" & vbCrLf &_
			"	<ul>" & vbCrLf & sResult &_
			"	</ul>" & vbCrLf &_
			"</div>"
	Response.Write sResult
End Sub


Sub FilterListBoxallV16(sFilter,sCallback)		'/2016.05.20; 허진원
	Dim sName, sResult

	if sFilter="ctab1" then
		sName="NEW"
	elseif sFilter="ctab2" then
		sName="ZZIM"
	elseif sFilter="ctab3" then
		sName="BEST"
	elseif sFilter="ctab5" then
		sName="ARTIST"
	elseif sFilter="ctab7" then
		sName="LOOKBOOK"
	elseif sFilter="ctab8" then
		sName="INTERVIEW"
	else
		sName="전체"
	end if

	sResult = "<button type=""button"">" & sName & "</button>" & vbCrLf &_
			"	<div class=""sortNaviV16a"">" & vbCrLf &_
			"	<ul>" & vbCrLf &_
			"		<li " & chkIIF(sFilter="","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('');return false;"">전체</a></li>" & vbCrLf &_
			"		<li " & chkIIF(sFilter="ctab1","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ctab1');return false;"">NEW</a></li>" & vbCrLf &_
			"		<li " & chkIIF(sFilter="ctab3","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ctab3');return false;"">BEST</a></li>" & vbCrLf &_
			"		<li " & chkIIF(sFilter="ctab2","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ctab2');return false;"">ZZIM</a></li>" & vbCrLf &_
			"		<li " & chkIIF(sFilter="ctab5","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ctab5');return false;"">ARTIST</a></li>" & vbCrLf &_
			"	</ul>" & vbCrLf &_
			"</div>"
	Response.Write sResult
end Sub


Function charListBox(lang,value)
	Dim vBody
	If lang = "K" Then
		vBody = vBody & "<option value=""가"" " & CHKIIF(value="가","selected","") & ">가</option>"
		vBody = vBody & "<option value=""나"" " & CHKIIF(value="나","selected","") & ">나</option>"
		vBody = vBody & "<option value=""다"" " & CHKIIF(value="다","selected","") & ">다</option>"
		vBody = vBody & "<option value=""라"" " & CHKIIF(value="라","selected","") & ">라</option>"
		vBody = vBody & "<option value=""마"" " & CHKIIF(value="마","selected","") & ">마</option>"
		vBody = vBody & "<option value=""바"" " & CHKIIF(value="바","selected","") & ">바</option>"
		vBody = vBody & "<option value=""사"" " & CHKIIF(value="사","selected","") & ">사</option>"
		vBody = vBody & "<option value=""아"" " & CHKIIF(value="아","selected","") & ">아</option>"
		vBody = vBody & "<option value=""자"" " & CHKIIF(value="자","selected","") & ">자</option>"
		vBody = vBody & "<option value=""차"" " & CHKIIF(value="차","selected","") & ">차</option>"
		vBody = vBody & "<option value=""카"" " & CHKIIF(value="카","selected","") & ">카</option>"
		vBody = vBody & "<option value=""타"" " & CHKIIF(value="타","selected","") & ">타</option>"
		vBody = vBody & "<option value=""파"" " & CHKIIF(value="파","selected","") & ">파</option>"
		vBody = vBody & "<option value=""하"" " & CHKIIF(value="하","selected","") & ">하</option>"
	ElseIf lang = "E" Then
		vBody = vBody & "<option value=""A"" " & CHKIIF(value="A","selected","") & ">A</option>"
		vBody = vBody & "<option value=""B"" " & CHKIIF(value="B","selected","") & ">B</option>"
		vBody = vBody & "<option value=""C"" " & CHKIIF(value="C","selected","") & ">C</option>"
		vBody = vBody & "<option value=""D"" " & CHKIIF(value="D","selected","") & ">D</option>"
		vBody = vBody & "<option value=""E"" " & CHKIIF(value="E","selected","") & ">E</option>"
		vBody = vBody & "<option value=""F"" " & CHKIIF(value="F","selected","") & ">F</option>"
		vBody = vBody & "<option value=""G"" " & CHKIIF(value="G","selected","") & ">G</option>"
		vBody = vBody & "<option value=""H"" " & CHKIIF(value="H","selected","") & ">H</option>"
		vBody = vBody & "<option value=""I"" " & CHKIIF(value="I","selected","") & ">I</option>"
		vBody = vBody & "<option value=""J"" " & CHKIIF(value="J","selected","") & ">J</option>"
		vBody = vBody & "<option value=""K"" " & CHKIIF(value="K","selected","") & ">K</option>"
		vBody = vBody & "<option value=""L"" " & CHKIIF(value="L","selected","") & ">L</option>"
		vBody = vBody & "<option value=""M"" " & CHKIIF(value="M","selected","") & ">M</option>"
		vBody = vBody & "<option value=""N"" " & CHKIIF(value="N","selected","") & ">N</option>"
		vBody = vBody & "<option value=""O"" " & CHKIIF(value="O","selected","") & ">O</option>"
		vBody = vBody & "<option value=""P"" " & CHKIIF(value="P","selected","") & ">P</option>"
		vBody = vBody & "<option value=""Q"" " & CHKIIF(value="Q","selected","") & ">Q</option>"
		vBody = vBody & "<option value=""R"" " & CHKIIF(value="R","selected","") & ">R</option>"
		vBody = vBody & "<option value=""S"" " & CHKIIF(value="S","selected","") & ">S</option>"
		vBody = vBody & "<option value=""T"" " & CHKIIF(value="T","selected","") & ">T</option>"
		vBody = vBody & "<option value=""U"" " & CHKIIF(value="U","selected","") & ">U</option>"
		vBody = vBody & "<option value=""V"" " & CHKIIF(value="V","selected","") & ">V</option>"
		vBody = vBody & "<option value=""W"" " & CHKIIF(value="W","selected","") & ">W</option>"
		vBody = vBody & "<option value=""X"" " & CHKIIF(value="X","selected","") & ">X</option>"
		vBody = vBody & "<option value=""Y"" " & CHKIIF(value="Y","selected","") & ">Y</option>"
		vBody = vBody & "<option value=""Z"" " & CHKIIF(value="Z","selected","") & ">Z</option>"
	End IF

	charListBox = vBody
End Function

'// 내가 찜한 브랜드 여부
Function getIsMyFavBrand(uid,mkr)
	dim strSQL
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyZzimBrand_cnt] '" & CStr(uid) & "',1,'','" & cStr(mkr) & "'"
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open strSQL, dbget

	if rsget("cnt")>0 then
		getIsMyFavBrand = true
	else
		getIsMyFavBrand = false
	end if
	rsget.Close
end Function

'// 카테고리 Histoty 출력(2014 New Ver.)
function printstreetCategoryHistorymultiNew(code,lastdep,byRef vCateCnt, makerid)
	dim strHistory, strLink, SQL, i, j, StrLogTrack
	j = (len(code)/3)
    
	'히스토리 기본
	strHistory = ""

	i = 0
	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & code & "'))"
	rsget.CursorLocation = adUseClient
	rsget.Open SQL, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j
			
				If i=j AND lastdep = True Then
					strHistory = strHistory & "<p class=""swiper-slide""><span class=""button btS1 btGry2 cWh1""><a href=""/street/pop_street_CategoryList.asp?makerid="& makerid &"&disp=" & Left(code,len(code)-3) & "&backpath=" & Server.URLEncode(CurrURLQ()) & """>"
				Else
					strHistory = strHistory & "<em class=""swiper-slide""><a href=""/street/street_brand.asp?makerid="& makerid &"&disp=" & Left(code,(3*i)) & """>"
				End If
				
				strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
				StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				
				If i=j Then strHistory = strHistory & " ()" End If
				
				If i=j AND lastdep = True Then
					strHistory = strHistory & "</a></span></p>"
				Else
					strHistory = strHistory & "</a></em>"
				End If
			next
		End If
	end if
	
	''logger 
	strHistory = strHistory & "<script language='JavaScript'>var _TRK_PNG='" & StrLogTrack  & "';</script>"
	
	rsget.Close
	vCateCnt = i
	
	'Response.Write strHistory
	printstreetCategoryHistorymultiNew = strHistory
end function


'// 카테고리 총상품수 산출 함수
function getCateListCount(srcFlag,sDiv,sDep,dspCd,arrCt,mkrid,ccd,stcd,atcd,deliT,lDiv,sRect,sExc)
	dim oTotalCnt
	set oTotalCnt = new SearchItemCls
		oTotalCnt.FRectSearchFlag = srcFlag
		oTotalCnt.FRectSearchItemDiv = sDiv
		oTotalCnt.FRectSearchCateDep = sDep
		oTotalCnt.FRectCateCode	= dspCd
		oTotalCnt.FarrCate=arrCt
		oTotalCnt.FRectMakerid	= mkrid
		oTotalCnt.FcolorCode= ccd
		oTotalCnt.FstyleCd= stcd
		oTotalCnt.FattribCd = atcd
		oTotalCnt.FdeliType	= deliT
		oTotalCnt.FListDiv = lDiv
		oTotalCnt.FRectSearchTxt = sRect
		oTotalCnt.FRectExceptText = sExc
		oTotalCnt.FSellScope=SellScope
		oTotalCnt.getTotalCount
		getCateListCount = oTotalCnt.FTotalCount
	set oTotalCnt = Nothing
end function


'// 2016 브랜드 카테고리 선택 상자 (sMaker:브랜드ID, sDisp:전시카테고리, sCallback:콜백함수명)
Sub fnStreetDispCateNaviV16(sMaker,sDisp,sCallback)
	Dim sName, sDepth, sResult, sTmp, lp
	Dim oGrCat

	'// 카테고리 명 접수
	If sDisp = "" Then
		sName = "전체 카테고리"
	Else
		sName = getDisplayCateNameDB(sDisp)
	End If

	'// 카테고리 조회 범위 설정
	if sDisp<>"" then
		sDepth = cStr(len(sDisp)\3)+1			'하위 뎁스
	else
		sDepth = 1
	end if
	if sDepth>3 then sDepth=3

	'// 카테고리별 검색결과
	set oGrCat = new SearchItemCls
		oGrCat.FRectSearchItemDiv = "y"		'기본 카테고리만 SearchItemDiv="y"
		oGrCat.FRectSearchCateDep = "T"		'하위카테고리 모두 검색 SearchCateDep= "T"
		oGrCat.FCurrPage = 1
		oGrCat.FPageSize = 100
		oGrCat.FScrollCount =10
		oGrCat.FListDiv = "brand"
		oGrCat.FRectMakerid = sMaker
		oGrCat.FRectCateCode	= sDisp
		oGrCat.FGroupScope = sDepth	'카테고리 그룹 범위(depth)
		oGrCat.FLogsAccept = False '그룹형은 절대 !!! False
		oGrCat.getGroupbyCategoryList		'//카테고리 접수

	'// 결과 출력
	sResult = "<button type=""button"">" & sName & "</button>" & vbCrLf &_
		"	<div class=""sortNaviV16a" & chkIIF(sDepth>1," depth2","")& """>" & vbCrLf &_
		"	<ul>" & vbCrLf

		'Loop
		If oGrCat.FResultCount>0 Then
			FOR lp = 0 to oGrCat.FResultCount-1

				if Left(Cstr(sDisp),3*sDepth) = Cstr(left(oGrCat.FItemList(lp).FCateCode,sDepth*3)) then
					sTmp = "class=""selected"""
				end if
				sResult = sResult & "<li "&sTmp&"><a href=""#"" onclick=""" & sCallback & "(" & Cstr(left(oGrCat.FItemList(lp).FCateCode,sDepth*3)) &");return false;""><span>"& splitValue(oGrCat.FItemList(lp).FCateName,"^^",(sDepth-1)) &"</span></a></li>"
				sTmp = ""
			Next
		end if

	sResult = sResult & "	</ul>" & vbCrLf &_
		"</div>"
	Response.Write sResult

	set oGrCat = Nothing
End Sub

'// 2017 브랜드 카테고리 선택 상자 (sMaker:브랜드ID, sDisp:전시카테고리, sCallback:콜백함수명)
Sub fnStreetDispCateNaviV17(sMaker,sDisp,sCallback)
	Dim sName, sDepth, sResult, sTmp, lp, strSql
	Dim oGrCat
	Dim sType : sType = "E"
	Dim amplitudeDepth, amplitudemove, amplitudemoveDepth

	'// 카테고리 명 접수
	If sDisp = "" Then
		sName = "전체 카테고리"
	Else
		sName = getDisplayCateNameDB(sDisp)
	End If

	'// 카테고리 조회 범위 설정
	if sDisp<>"" then
		sDepth = cStr(len(sDisp)\3)+1			'하위 뎁스
		amplitudeDepth = cInt(len(sDisp)/3)
	else
		sDepth = 1
		amplitudeDepth = 0
	end If
	
	If Trim(CStr(amplitudeDepth)) = "4" Then
		amplitudemove = "same"
		amplitudemoveDepth = amplitudeDepth
	Else
		amplitudemove = "down"
		amplitudemoveDepth = amplitudeDepth + 1
	End If

	if sDepth>3 then sDepth=3
	if left(sDisp,3)="124" and sDepth>=2 then sDepth=2

	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth' +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'// 카테고리별 검색결과
	set oGrCat = new SearchItemCls
		oGrCat.FRectSearchItemDiv = "y"		'기본 카테고리만 SearchItemDiv="y"
		oGrCat.FRectSearchCateDep = "T"		'하위카테고리 모두 검색 SearchCateDep= "T"
		oGrCat.FCurrPage = 1
		oGrCat.FPageSize = 100
		oGrCat.FScrollCount =10
		oGrCat.FListDiv = "brand"
		oGrCat.FRectMakerid = sMaker
		oGrCat.FRectCateCode	= sDisp
		oGrCat.FGroupScope = sDepth	'카테고리 그룹 범위(depth)
		oGrCat.FLogsAccept = False '그룹형은 절대 !!! False
		oGrCat.getGroupbyCategoryList		'//카테고리 접수

		sResult = 	"	<ul id=""lyrDispCateList"">" & vbCrLf
	
		Select Case sType
			Case "F","E"

				'1Depth는 전체 항목 추가
				if sDepth=1 then
					sResult = sResult & "<li " & chkIIF(sDisp="","class=""on""","") & "><a href=""#"" onclick=""" & sCallback & "('');return false;""><span>전체<span></a></li>" & vbCrLf
				end if

				'최종뎁스 확인
				If sDepth > 1 Then
					strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
					strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
					rsget.Open strSql,dbget,1
					if rsget("cnt")=0 then
						sDepth = sDepth -1
					end if
					rsget.Close
				end if

				'Loop
				If oGrCat.FResultCount>0 Then
					FOR lp = 0 to oGrCat.FResultCount-1
						if Left(Cstr(sDisp),3*sDepth) = Cstr(left(oGrCat.FItemList(lp).FCateCode,sDepth*3)) then
							sTmp = "class=""on"""
						end if
						sResult = sResult & "<li><a href=""#""  "&sTmp&" onclick=""" & sCallback & "(" & Cstr(left(oGrCat.FItemList(lp).FCateCode,sDepth*3)) &");fnAmplitudeEventMultiPropertiesAction('click_brand_productlist_depth', 'brand_id|category_code|category_depth|move_category_code|move_category_depth|move', '"&sMaker&"|"&sDisp&"|"&amplitudeDepth&"|"&Cstr(left(oGrCat.FItemList(lp).FCateCode,sDepth*3))&"|"&amplitudemoveDepth&"|"&amplitudemove&"');return false;"">"& splitValue(oGrCat.FItemList(lp).FCateName,"^^",(sDepth-1)) &"</a></li>"
	'					sResult = sResult & "<li "&sTmp&"><a href=""#"" onclick=""" & sCallback & "(" & Cstr(left(oGrCat.FItemList(lp).FCateCode,sDepth*3)) &");return false;""><span>"& splitValue(oGrCat.FItemList(lp).FCateName,"^^",(sDepth-1)) &"</span></a></li>"
						sTmp = ""
					Next
				end if
	
			Case "S"
				'/// Ajax 사용 (호출 페이지에서 처리: 여기선 내용없음)
		End Select
		sResult = sResult & "	</ul>"' & vbCrLf &_	
	
		Response.Write sResult

	set oGrCat = Nothing
End Sub
%>
