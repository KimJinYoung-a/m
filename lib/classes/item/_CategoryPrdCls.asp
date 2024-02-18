<%

CLASS CatePrdCls

	Private Sub Class_Initialize()
		'FCurrPage =1
		'FPageSize = 10
		'FTotalPage = 1
		'FResultCount = 0
		'FScrollCount = 10
		'FTotalCount =0
	End Sub

	Private Sub Class_Terminate()
	End Sub

	dim Prd
	dim FADD
	dim FResultCount
	dim itEvtImg
	dim FItem
	dim FCaptureExist
	dim Frectmakerid

	Public Sub GetItemData(ByVal iid)


		dim strSQL

		strSQL = "execute [db_item].[dbo].sp_Ten_CategoryPrd @vItemID ='" & CStr(iid) & "'"

		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open strSQL, dbget

		set Prd = new CCategoryPrdItem

		if  not rsget.EOF  then

			FResultCount = 1
			rsget.Movefirst

				Prd.FItemid    	= rsget("Itemid")  '상품 코드
				Prd.FcdL		= rsget("Cate_large")
				Prd.FcdM		= rsget("Cate_mid")
				Prd.FcdS		= rsget("Cate_small")
				Prd.FcateCode	= rsget("catecode")

				Prd.FMakerid 		= rsget("makerid") '업체 아이디(표시 브랜드)
				Prd.FOrgMakerID		= rsget("orgmakerid") '업체 아이디(원브랜드)

				Prd.Fitemname 			= db2html(rsget("itemname")) '상품명
				Prd.FMakerName 		= db2html(rsget("makername")) 	'제조사
				Prd.FOrgprice			= rsget("orgprice")		'원가
				Prd.FItemDiv 			= rsget("itemdiv")		'상품 속성
				Prd.FMileage				= rsget("mileage")	'마일리지
				Prd.FSellCash 			= rsget("sellcash")		'판매가
				Prd.FLimitNo      = rsget("limitno")			'한정수량
				Prd.FLimitSold      = rsget("LimitSold")		'한정판매수량
				Prd.FKeyWords		= db2html(rsget("keyWords"))
				Prd.Fdeliverarea		= rsget("deliverarea")
				Prd.FSpecialUserItem = rsget("specialuseritem")
				Prd.FReipgodate			= rsget("reipgodate")
				Prd.FDeliverytype		= rsget("deliverytype")
				Prd.FEvalCnt					= rsget("evalcnt")
				Prd.FEvalCnt_photo		= rsget("evalCnt_photo")
				Prd.FOptionCnt				= rsget("optioncnt")
				Prd.FQnaCnt					= rsget("qnaCnt")
				Prd.FAvgDlvDate					= rsget("AvgDlvDate")
				Prd.FItemSource 			= db2html(rsget("itemsource"))
				Prd.FSourceArea 			= db2html(rsget("sourcearea"))
				Prd.FItemSize 				= db2html(rsget("itemsize"))
				Prd.FCurrItemCouponIdx 		= rsget("curritemcouponidx")
				Prd.FitemWeight				= rsget("itemWeight")
				Prd.FdeliverOverseas 		= rsget("deliverOverseas")


				Prd.FisUsing				= rsget("isUsing")
				Prd.FSellYn					= rsget("sellyn")
				Prd.FSaleYn					= rsget("sailyn")
				Prd.FLimitYn 				= rsget("limityn")
				Prd.FLimitDispYn			= rsget("limitdispyn")
				Prd.FItemCouponYN		= rsget("itemcouponyn")
				Prd.FItemCouponType 	=	rsget("itemcoupontype")
				Prd.FItemCouponValue	= rsget("itemcouponvalue")
				Prd.FUsingHTML				= rsget("usinghtml")
				Prd.FTenOnlyYn			= rsget("tenOnlyYn")

				Prd.FDesignerComment	= db2html(Trim(rsget("designercomment")))
				Prd.FItemContent 		= db2html(rsget("itemcontent"))
				Prd.FOrderComment		= db2html(Trim(rsget("ordercomment")))

				Prd.FAvailPayType		= rsget("AvailPayType")

				Prd.FImageMain 		= "http://webimage.10x10.co.kr/image/main/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("mainimage")
				Prd.FImageMain2		= "http://webimage.10x10.co.kr/image/main2/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("mainimage2")
				Prd.FImageMain3		= "http://webimage.10x10.co.kr/image/main3/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("mainimage3")
				Prd.FImageList 		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("listimage")
				Prd.FImageList120 	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("listimage120")
				Prd.FImageSmall 		= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("smallimage")
				
				If isNull(rsget("basicimage600")) OR rsget("basicimage600") = "" Then
					If isNull(rsget("basicimage")) OR rsget("basicimage") = "" Then
						Prd.FImageBasic 	= ""						
					Else
						If Prd.FItemDiv="21" Then
						Prd.FImageBasic 		= "http://webimage.10x10.co.kr/image/basic/" + rsget("basicimage")
						Else
						Prd.FImageBasic 		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("basicimage")
						End If
					end if
				Else
					If Prd.FItemDiv="21" Then
					Prd.FImageBasic 		= "http://webimage.10x10.co.kr/image/basic600/" + rsget("basicimage600")
					Else
					Prd.FImageBasic 		= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("basicimage600")
					End If
				End If

				If Not(isNull(rsget("maskimage")) OR rsget("maskimage") = "") Then
					Prd.FImageMask 	= "http://webimage.10x10.co.kr/image/mask/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("maskimage")
				end if

				Prd.FImageBasicIcon 	= "http://webimage.10x10.co.kr/image/basicicon/" + GetImageSubFolderByItemid(Prd.FItemid) + "/C" + rsget("basicimage")
				Prd.FImageMaskIcon 	= "http://webimage.10x10.co.kr/image/maskicon/" + GetImageSubFolderByItemid(Prd.FItemid) + "/C" + rsget("maskimage")
				'Prd.FImageicon2 		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("icon2image")
				Prd.FRegdate 			= rsget("regdate")
				Prd.FBrandName	= db2Html(rsget("brandname"))
				Prd.FBrandName_kor	= db2Html(rsget("BrandName_Kor"))
				IF rsget("brandlogo")<>"" Then
					Prd.FBrandLogo	=	"http://webimage.10x10.co.kr/image/brandlogo/" & db2html(rsget("brandlogo"))
				Else
					Prd.FBrandLogo	=	"http://fiximage.10x10.co.kr/web2008/street/brandimg_blank.gif"
				End IF
				Prd.FSpecialbrand = rsget("specialbrand") '상품문의 접수 여부
				Prd.FStreetUsing = rsget("streetusing") '브랜드 스트리트 사용 여부
				Prd.FBrandUsing = rsget("BrandUsing")			'브랜드 사용 여부
				Prd.Fuserdiv = rsget("userdiv")			'브랜드 구분
				Prd.FDefaultFreeBeasongLimit = rsget("DefaultFreeBeasongLimit")
				Prd.FDefaultDeliverPay = rsget("defaultDeliverPay")
				'Prd.Fdgncomment	= db2html(rsget("dgncomment"))	' 업체 코멘트

				Prd.ForderMinNum	= rsget("orderMinNum")	' 최소 구매수량
				Prd.ForderMaxNum	= rsget("orderMaxNum")	' 최대 구매수량

				Prd.FsafetyYN				= rsget("safetyYN")	' 안전인증대상
				Prd.FsafetyDiv				= rsget("safetyDiv")	' 안전인증구분 '10 ~ 50
				Prd.FsafetyNum			= rsget("safetyNum")	' 안전인증번호
				
				Prd.FisJust1day			= rsget("isJust1Day")	'금일의 Just 1day 상품 여부
				Prd.FFavCount			= rsget("favcount")
				Prd.FPojangOk			= rsget("pojangok")		'선물포장 가능 여부

				Prd.Ftestercnt			= rsget("testercnt")	'테스터이벤트 코멘트 카운트

				prd.FreserveItemTp		= rsget("reserveItemTp")	'단독(예약)배송 상품 여부
				
				prd.FPoints				= rsget("TotalPoint")

				If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then '텐텐 기본이미지
					Prd.Ftentenimage	= "http://webimage.10x10.co.kr/image/tenten/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("tentenimage")
					Prd.Ftentenimage50	= "http://webimage.10x10.co.kr/image/tenten50/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("tentenimage50")
					Prd.Ftentenimage200	= "http://webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("tentenimage200")
					Prd.Ftentenimage400	= "http://webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("tentenimage400")
					Prd.Ftentenimage600	= "http://webimage.10x10.co.kr/image/tenten600/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("tentenimage600")
					Prd.Ftentenimage1000	= "http://webimage.10x10.co.kr/image/tenten1000/" + GetImageSubFolderByItemid(Prd.FItemid) + "/" + rsget("tentenimage1000")
				End If
		else
			FResultCount = 0
		end if

		rsget.close

	End Sub


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
						If vImage = "" OR isNull(vImage) Then
							FADD(i).FIsExistAddimg = False
						Else
							FADD(i).FIsExistAddimg = True
						End If
					'// 추가되는 영역(원승현 2016-05-09)
					ElseIf ArrRows(1,i)="2" Then
						FADD(i).FAddimage 			= "http://webimage.10x10.co.kr/item/contentsimage/" & GetImageSubFolderByItemid(itemid) & "/" & vImage
						If vImage = "" OR isNull(vImage) Then
							FADD(i).FIsExistAddimg = False
						Else
							FADD(i).FIsExistAddimg = True
						End If
					Else
						FADD(i).FAddimage 			= "http://webimage.10x10.co.kr/image/add" & Cstr(FADD(i).FAddimageGubun) & "/" & GetImageSubFolderByItemid(itemid) & "/" & vImage
					End IF

				next
			end if
	End Sub

	Public Sub getImageColorList(byval itemid)
			dim strSQL,ArrRows,i

			strSQL = "exec [db_item].[dbo].[sp_Ten_itemColor_itemImage_list] " & CStr(itemid)

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

					FADD(i).FcolorCode	= ArrRows(1,i)
					FADD(i).FImageBasic	= "http://webimage.10x10.co.kr/color/basic/" & GetImageSubFolderByItemid(itemid) & "/" & ArrRows(2,i)
					FADD(i).FcolorName	= ArrRows(3,i)

				next
			end if
	End Sub

	Public Function getDiaryEvt(byval itid)
		dim strSQL,tmpHTML
		tmpHTML =""

		strSQL =" SELECT TOP 10 A.evt_code , A.Evt_name , evt_startDate , evt_EndDate , A.evt_state , A.evt_Using , Evt_Template , Evt_mainimg , Evt_html "&_
				" FROM db_event.dbo.tbl_event A "&_
				" JOIN db_event.dbo.tbl_event_display B "&_
				" 	on A.evt_code = B.evt_code "&_
				" JOIN db_event.dbo.tbl_eventitem C "&_
				" 	on A.evt_code= C.evt_code "&_
				" WHERE C.itemid="& itid & " " &_
				" and A.evt_state=7 and A.evt_kind=17 and A.evt_using ='Y' and B.evt_LinkType='I'"&_
				" and getdate() between evt_startdate and dateadd(day,1,evt_enddate ) "
		'response.write strSQL
		rsget.open strSQL, dbget,2
		IF Not rsget.EOF Then

			Do Until rsget.EOF
				tmpHTML= tmpHTML & "<div align='center' style='padding: 5 0 0 0;'>"
				IF rsget("Evt_Template") =5 Then
					IF rsget("Evt_html")<>"" Then
						tmpHTML = tmpHTML & rsget("Evt_html")
					End IF
				ELSE
					IF trim(rsget("Evt_mainimg"))<>"" and not isNull(rsget("Evt_mainimg")) Then
						tmpHTML = tmpHTML & "<img src="""& rsget("Evt_mainimg") &"""  border=""0"">"
					End IF
				End IF
				tmpHTML = tmpHTML & "</div>"
				rsget.MoveNext
			Loop

		End IF

		rsget.Close
		getDiaryEvt= tmpHTML

	End Function

	'//1+1 사은품 증정 여부
	Public Function getGiftExists(itemid)

		dim tmpSQL,i
		dim blnTF

		tmpSQL = "Execute [db_item].[dbo].[sp_Ten_GiftExists] @vItemid = " & itemid

			rsget.CursorLocation = adUseClient
			rsget.CursorType=adOpenStatic
			rsget.Locktype=adLockReadOnly
			rsget.Open tmpSQL, dbget,2

			If Not rsget.EOF Then
				blnTF 	= true
			ELSE
				blnTF 	= false
			End if
			rsget.close

			getGiftExists = blnTF

	End Function

	'// 타겟쿠폰 내용 접수
	Public Sub getTargetCoupon(byval cpid, byval iid)
		dim strSQL
		strSQL = "exec [db_item].[dbo].[sp_Ten_checkTargetcoupon] " & cpid & ", " & iid
		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open strSQL, dbget
		if Not(rsget.EOF) then
			Prd.FCurrItemCouponIdx	= cpid
			Prd.FItemCouponYN		= "Y"
			Prd.FItemCouponType 	= rsget("itemcoupontype")
			Prd.FItemCouponValue	= rsget("itemcouponvalue")
		end if
		rsget.Close
	end Sub

	'// 상품 설명 new 버전 2012 - 이종화
	Public Sub getItemAddExplain(byval itemid)
			dim strSQL,ArrRows,i

			strSQL = "exec [db_item].[dbo].[sp_Ten_CategoryPrd_AddExplain] " & CStr(itemid)
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

			redim  FItem(FResultCount)

				For i=0 to FResultCount-1
					Set FItem(i) = new CCategoryPrdItem

					FItem(i).FInfoname		= ArrRows(0,i)
					FItem(i).FInfoContent	= ArrRows(1,i)
					FItem(i).FinfoCode		= ArrRows(2,i)

				next
			end if
	End Sub

	'브랜드 공지(2017-02-03 유태욱)
	Public Sub GetBrandNoticeData
		dim strSQL,ArrRows,i

		if Frectmakerid <> "" then
			strSQL = "exec [db_board].[dbo].[sp_Ten_Brand_notice] '"&Frectmakerid&"' "
'			response.write strSQL

			dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"ITBN",strSQL,180)
	        if (rsMem is Nothing) then Exit Sub
	        if  not rsMem.EOF  then
				ArrRows 	= rsMem.GetRows
			end if
			rsMem.Close

			if isArray(ArrRows) then
				FResultCount = Ubound(ArrRows,2) + 1
				redim  FItem(FResultCount)

				For i=0 to FResultCount-1
					Set FItem(i) = new CCategoryPrdItem
					FItem(i).FBrandNoticeGubun	= ArrRows(0,i)
					FItem(i).FBrandNoticeTitle	= ArrRows(1,i)
					FItem(i).FBrandNoticeText	= ArrRows(2,i)
				next
			ELSE
				FResultCount = 0
				exit sub
			end if
		end if
	End Sub

	'// 비트윈 카테고리 베스트
	Public Function getBetweenCateBest(byval vdisp, ByVal itemid)
		dim strSQL,tmpHTML, i
		tmpHTML =""
		i=0

		strSQL = " Select top 3 A.itemid, A.sortNo, A.isDefault, A.chgItemname, A.regdate, A.isdisplay, A.CateCode, "&_
				" (Select top 1 catename From db_etcmall.dbo.tbl_between_cate Where catecode = A.catecode) as catename, "&_
				" B.makerid, B.BrandName, B.cate_large, B.cate_mid, B.cate_small, B.itemdiv, B.itemGubun, B.itemname, B.sellcash, "&_
				" B.orgprice, B.SellYn, B.isUsing, B.limitYn, B.sailYn, B.LimitNo, B.LimitSold, B.EvalCnt, B.EvalCnt_photo, "&_
				" B.OptionCnt, B.ItemCouponYn, B.CurrItemCouponIdx, B.ItemCouponType, B.ItemcouponValue, B.icon1image, "&_
				" B.BasicImage, B.deliverytype, B.specialuseritem, B.listimage, B.smallimage, B.listimage120, B.icon2image, "&_
				" A.rctsellcnt, B.itemscore "&_
				" From db_etcmall.dbo.tbl_between_cate_item A "&_
				" inner join db_item.dbo.tbl_item B on A.itemid = B.itemid "&_
				" Where A.isdisplay = 'Y' And B.IsUsing='Y' And B.sellYn='Y' And B.sellcash >= 5000 And A.itemid not in ('"&itemid&"')"
				If Trim(vdisp) = "107" Then
					strSQL = strSQL & " And B.sailYN = 'Y' "
				Else
					strSQL = strSQL & " And A.CateCode = '"&vdisp&"' "
				End If
				strSQL = strSQL & " Order By B.itemscore desc "
				'// 위에 정렬부분을 비트윈 오픈 초기엔 텐바이텐 기준 인기상품 갯수로 가져오다가 어느정도 히스토리가 쌓이면 
				'// 비트윈 rctsellcnt 기준으로 변경해야됨(2014.04.24)

		'response.write strSQL

		dim FCateBetList(3)
		rsget.open strSQL, dbget,2
		IF Not rsget.EOF Then
			Do Until rsget.EOF
					set FCateBetList(i) = new CCategoryPrdItem
					FCateBetList(i).FItemID       = rsget("itemid")
					If Trim(db2html(rsget("chgItemname")))="" Then
						FCateBetList(i).FItemName     = db2html(rsget("itemname"))
					Else
						FCateBetList(i).FItemName     = db2html(rsget("chgItemname"))
					End If


					FCateBetList(i).FSellcash     = rsget("sellcash")
					FCateBetList(i).FSellYn       = rsget("sellyn")
					FCateBetList(i).FLimitYn      = rsget("limityn")
					FCateBetList(i).FLimitNo      = rsget("limitno")
					FCateBetList(i).FLimitSold    = rsget("limitsold")
					FCateBetList(i).Fitemgubun    = rsget("itemgubun")
					FCateBetList(i).FDeliverytype = rsget("deliverytype")
					FCateBetList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FCateBetList(i).FItemCouponValue	= rsget("ItemCouponValue")

					FCateBetList(i).Fevalcnt = rsget("evalcnt")
					FCateBetList(i).Fitemcouponyn = rsget("itemcouponyn")

					FCateBetList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCateBetList(i).FItemID) + "/" + rsget("smallimage")
					FCateBetList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCateBetList(i).FItemid) + "/" + rsget("BasicImage"),"300","300","true","false")
					FCateBetList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCateBetList(i).FItemid) + "/" + rsget("listimage120")
					FCateBetList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FCateBetList(i).FItemid) + "/" + rsget("icon1image")
					FCateBetList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCateBetList(i).FItemid) + "/" + rsget("icon2image")
					FCateBetList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCateBetList(i).FItemid) + "/" + rsget("BasicImage")

					FCateBetList(i).FMakerID = rsget("makerid")
					FCateBetList(i).fbrandname = db2html(rsget("brandname"))
					FCateBetList(i).FRegdate = rsget("regdate")

					FCateBetList(i).FSaleYn    = rsget("sailyn")
					FCateBetList(i).FOrgPrice   = rsget("orgprice")
					FCateBetList(i).FSpecialuseritem = rsget("specialuseritem")
					FCateBetList(i).Fevalcnt = rsget("evalcnt")
					FCateBetList(i).FbetCateCd = rsget("CateCode")
					FCateBetList(i).FbetCateNm = rsget("catename")

					tmpHTML = tmpHTML & " <li> "

					If FCateBetList(i).IsSoldOut Then		
						tmpHTML = tmpHTML & "		<div class='soldout'> "
					Else
						If FCateBetList(i).isSaleItem Then					
							tmpHTML = tmpHTML & "		<div class='sale'> "
						Else
							tmpHTML = tmpHTML & "		<div> "							
						End If
					End If
					tmpHTML = tmpHTML & "  		<a href='category_itemPrd.asp?itemid="&FCateBetList(i).FItemID&"&dispCate="&vDisp&"'> "
					tmpHTML = tmpHTML & " 				<p class='pdtPic'><img src='"&FCateBetList(i).FImageList&"' alt='"&FCateBetList(i).FItemName&"' /></p>"
					tmpHTML = tmpHTML & " 				<p class='pdtName'>"&FCateBetList(i).FItemName&"</p> "
					If FCateBetList(i).IsSaleItem Then
						IF FCateBetList(i).IsSaleItem Then
							tmpHTML = tmpHTML & " 	<p class='price'>"&FormatNumber(FCateBetList(i).getRealPrice,0)&"원</p> "
						End IF
					Else
						tmpHTML = tmpHTML & " 	<p class='price'>"&FormatNumber(FCateBetList(i).getRealPrice,0)&"원</p> "
					End If
					If FCateBetList(i).isSaleItem Then					
						tmpHTML = tmpHTML & "	<p class='pdtTag saleRed'>"&FCateBetList(i).getSalePro&"</p>"
					End If
					If FCateBetList(i).IsSoldOut Then
						tmpHTML = tmpHTML & "	<p class='pdtTag soldOut'>품절</p>"
					End If
					tmpHTML = tmpHTML & " 			</a> "
					tmpHTML = tmpHTML & " 		</div> "
					tmpHTML = tmpHTML & " 	</li> "
				i = i+1
				rsget.MoveNext
			Loop
		End IF

		rsget.Close
		getBetweenCateBest= tmpHTML

	End Function

	Public Sub sbDetailCaptureViewCount(byval iid)
		dim strSQL
		strSQL = "exec [db_contents].[dbo].[sp_Ten_ItemDetailCaptureView] '" & iid & "'"
		rsget.CursorLocation = adUseClient
		rsget.Open strSQL, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.EOF) then
			FCaptureExist = rsget(0)
			if (rsget(1)<1100) then FCaptureExist=0 ''컨텐츠 길이가 1만=7천=>3천 미만이면 원래 컨텐츠를 표시 '2017-06-27 3000 => 1100
		end if
		rsget.Close
	end Sub

    Public function sbDetailCaptureViewImages(byval iitemid)
        dim strSQL
        strSQL = "exec [db_contents].[dbo].[sp_Ten_ItemDetail_Capture_Images] " & iitemid & ""
		rsget.CursorLocation = adUseClient
		rsget.Open strSQL, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.EOF) then
			sbDetailCaptureViewImages = rsget.getRows
		end if
		rsget.Close
		
	end function	

	'### 상품상세설명 동영상
	Public Function fnGetItemVideos(byval itemid, ByVal vgubun)
		dim strSQL, vCount
		strSQL = " SELECT TOP 1 videogubun, videotype, videourl, videowidth, videoheight, videofullurl FROM [db_item].[dbo].[tbl_item_videos] WHERE videogubun='"&vgubun&"' And itemid = '" & itemid & "'"
		'response.write strSQL
		rsget.open strSQL, dbget
		set Prd = new CCategoryPrdItem
		if  not rsget.EOF  then
			FResultCount = 1
			rsget.Movefirst
				Prd.FvideoUrl    	= rsget("videourl")
				Prd.FvideoWidth		= rsget("videowidth")
				Prd.FvideoHeight	= rsget("videoheight")
				Prd.Fvideogubun		= rsget("videogubun")
				Prd.FvideoType		= rsget("videotype")
				Prd.FvideoFullUrl	= rsget("videofullurl")
		Else
			FResultCount = 0
		End IF
		rsget.Close

	End Function


	'상품 판매 매장 목록
	Public Function GetSellOffShopList(itemid,minStock)
		dim strSQL

		if minStock="" then minStock=3

		if itemid <> "" then
			strSQL = "exec [db_summary].[dbo].[sp_Ten_getShopList_by_item] "&itemid&", " & minStock &" "
'			response.write strSQL

			dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"ITSHOP",strSQL,5*60)
	        if (rsMem is Nothing) then Exit Function
	        if  not rsMem.EOF  then
				GetSellOffShopList	= rsMem.GetRows
			end if
			rsMem.Close
			
		end if
	End Function

	'// 제품 안전 인증 정보 - 정태훈 (2017-12-06)
	Public Sub getItemSafetyCert(byval itemid)
			dim strSQL,ArrRows,i

			strSQL = "exec [db_item].[dbo].[usp_WWW_Item_SafetyCert_Get] " & CStr(itemid)
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

			redim  FItem(FResultCount)

				For i=0 to FResultCount-1
					Set FItem(i) = new CCategoryPrdItem

					FItem(i).FSafetyYN		= ArrRows(0,i)
					FItem(i).FcertNum		= ArrRows(1,i)
					FItem(i).FcertDiv			= ArrRows(2,i)
					FItem(i).FcertUid			= ArrRows(3,i)
					FItem(i).FsafetyDiv		= ArrRows(4,i)

				next
			end if
	End Sub

End Class

''APP 용 캡쳐 이미지 존재여부 체크
function fnIsItemDtlCaptureExists(iitemid)
    dim strSQL, captureExists, capheight
    fnIsItemDtlCaptureExists = false
    
    strSQL = "exec [db_contents].[dbo].[sp_Ten_ItemDetailCaptureGetOne] " & iitemid & ""
	rsget.CursorLocation = adUseClient
	rsget.Open strSQL, dbget, adOpenForwardOnly, adLockReadOnly
	If Not(rsget.EOF) then
		captureExists = rsget("captureExists")
		capheight = rsget("capheight")
		
		if (capheight>=3000) then fnIsItemDtlCaptureExists=true
	end if
	rsget.Close
	
end function

'//상품후기 총점수 %로 환산
function fnEvalTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/5)
				Else
					vTmp = ((Round(t,2) * 100)/5)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvalTotalPointAVG = vTmp
end function
%>