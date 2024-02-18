<%
CLASS CGiftCardPrdItem

	dim FCardItemID
	dim FCardItemName
	dim FCardInfo
	dim FCardDesc
	dim FCardSellYn
	dim FRegDate
	dim FImageBasic
	dim FImageBasic600		'600px이미지
	dim FImageList
	dim FImageList120
	dim FImageSmall
	dim FIcon1Image
	dim FIcon2Image
	dim FCardSaleYn

	dim FcardOption
	dim FcardOptionName
	dim FcardSellCash
	dim FcardOrgPrice
	dim FoptSellYn
	dim FoptIsUsing


	dim FItemName
	dim FSellcash
	dim FOrgPrice

	dim FNewitem

	dim FMakerID
	dim FBrandName
	dim FBrandName_kor
	dim FBrandLogo
	dim FBrandUsing
	dim FUserDiv

	dim FItemDiv
	dim FMakerName

	dim FMileage
	dim FSourceArea
	dim FDeliverytype

	dim FcdL
	dim FcdM
	dim FcdS
	dim FCateName
	dim FcolorCode
	dim FcolorName

	dim FLimitNo
	dim FLimitSold
	dim fsailprice


	dim FOrderComment
	dim Fdeliverarea
	dim FItemSource
	dim FItemSize
	dim FItemWeight
	dim FdeliverOverseas

	dim Fkeywords
	dim FUsingHTML
	dim FItemContent

	dim Fisusing
	dim FStreetUsing

	dim FReipgodate
	dim FSpecialbrand


	dim Fdgncomment
	dim FDesignerComment

	dim FLimitYn
	dim FSellYn
	dim FItemScore

	dim Fitemgubun

	dim FSaleYn
	dim FTenOnlyYn		'텐바이텐 독점상품여부(2011.04.14)

	dim FEvalcnt
	dim FEvalcnt_Photo
	dim FQnaCnt
	dim FOptionCnt
	dim FAvgDlvDate

	dim FAddimageGubun '?
	dim FAddimageSmall '?
	dim FAddImageType
	dim FAddimage '?
	dim Ffreeprizeyn '?


	dim FReipgoitemyn
	dim FSpecialUserItem

	dim Fitemcouponyn
	dim FItemCouponType
	dim FItemCouponValue
	dim FItemCouponExpire
	dim FCurrItemCouponIdx

	dim FAvailPayType               '결제 방식 지정 0-일반 ,1-실시간(선착순)
	dim FDefaultFreeBeasongLimit    '업체 개별배송시 배송비 무료 적용값
	dim FDefaultDeliverPay		    ' 업체 개별배송시 배송비
	dim FRequireMakeDay				'주문제작상품의 제작 소요일(2011.04.14)

	public FPoints
	public Fuserid
	public Fcontents
	public FImageMain
	public FImageMain2			'상품설명2 이미지 추가(2011.04.14)
	public FlinkURL

	public FCurrRank
	public FLastRank

	public FBRWriteRegdate		'베스트리뷰용
	public FUseGood
	public FUseETC

	Public Function GetImageList()
		if (Left(FImageList, 4) = "http") then
			GetImageList = FImageList
		else
			GetImageList = webImgUrl & FImageList
		end if
	End Function

	Public Function GetImageSmall()
		if (Left(FImageSmall, 4) = "http") then
			GetImageSmall = FImageSmall
		else
			GetImageSmall = webImgUrl & FImageSmall
		end if
	End Function

	'// 신상품 여부 '!
	public Function IsNewItem()
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function

	'// 세일 상품 여부 '!
	public Function IsSaleItem()
	    IsSaleItem = (FCardSaleYn="Y")
	end Function

	'// 판매종료  여부 '!
	public Function IsSoldOut()
		IsSoldOut = (FCardSellYn="N")
	end Function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end CLASS
%>
