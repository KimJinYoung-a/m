<%
'####### 코너 구분값(cate) #######
'
'	1 : PLAYLIST♬
'	2 : !NSPIRATION
'	21 : !NSPIRATION DESIGH
'	22 : !NSPIRATION STYLE
'	3 : AZIT&
'// 2017.06.01 원승현 azit comma 스타일 추가
'	31 : AZIT&Comma
'	4 : THING.
'	41 : THING. THING
'	42 : THING. ThingThing
'	43 : THING. 배경화면
'	5 : COMMA,
'	6 : HOWHOW?
'
'############################
'####### 이미지 구분값 #######
'
'	1 : 리스트이미지(직사각형)
'	2 : playlist 컨텐츠 이미지
'	3 : playlist 연결배너 PC 이미지
'	4 : inspiration design 컨텐츠 이미지
'	5 : inspiration style 컨텐츠 이미지
'	6 : azit Mo 컨텐츠 이미지
'	7 : azit 장소 이미지
'	8 : thingthing 롤링 이미지
'	9 : 배경화면 Mo 컨텐츠 이미지
'	10 : 배경화면 QR 이미지(저장된이미지링크만)
'	11 : 리스트이미지(정사각형)
'	12 : comma 컨텐츠 PC 상단 이미지
'	13 : comma 컨텐츠 Mo 상단 이미지
'	14 : comma 컨텐츠(에디터) 이미지
'	15 : comma 연결배너 PC 이미지
'	16 : comma 연결배너 Mo 이미지
'	17 : howhow 컨텐츠(에디터) 이미지
'	18 : playlist 연결배너 Mo 이미지
'	19 : azit PC 컨텐츠 이미지
'	20 : 배경화면 PC 컨텐츠 이미지
'	21 : thingthing 연결배너 PC 이미지
'	22 : thingthing 연결배너 Mo 이미지
'// 2017.06.01 원승현 azit comma 스타일 추가
'	23 : comma 컨텐츠 PC 상단 이미지
'	24 : comma 컨텐츠 Mo 상단 이미지
'	25 : comma 컨텐츠(에디터) 이미지
'	26 : comma 연결배너 PC 이미지
'	27 : comma 연결배너 Mo 이미지
'
'############################
Class CPlayItem
	public Fmidx
	public Fdidx
	public Ftitle
	public Ftitlestyle
	public Fcate
	public Fcatename
	public Fstartdate
	public Fimgurl
	public Fsubcopy
	public Fcontents
	public FisExec
	public Fexecfile
	public Fbgcolor
	public Ficonimg
	public Fstate
	public Fdirecter
	public Fvideourl
	public Fbannsub
	public Fbanntitle
	public Fbannbtntitle
	public Fbannbtnlink
	public Fgroupnum
	public Faddress
	public Faddrlink
	public Ftype
	public Fcomm_title
	public Fcomment1
	public Fcomment2
	public Fcomment3
	public FtagSDate
	public FtagEDate
	public FCate1precomm1
	public FCate1precomm2
	public FCate1precomm3
	public FCa1Idx
	public FCa1ComUserID
	public FCa1ComDevice
	public FCa1ComRegdate
	public FCate1VideoOrigin
	public FCate1RewardCopy
	public FCate3EntryCont
	public FCate3EntrySDate
	public FCate3EntryEDate
	public FCate3AnnounDate
	public FCate3Notice
	public FCate3EntryMethod
	public FCa3Idx
	public FCa3ComUserID
	public FCa3ComDevice
	public FCa3ComRegdate
	public FCate42EntrySDate
	public FCate42EntryEDate
	public FCate42AnnounDate
	public FCate42Notice
	public FCate42WinnerTxt
	public FCate42WinnerValue
	public FCate42Entrycopy
	public FCate42Badgetag	''2017-07-17 유태욱 추가
	public FCa42Idx
	public FCa42EntUserID
	public FCa42EntVal
	public FCa42EntDevice
	public FCa42EntRegdate
	public FViewCnt_W
	public FViewCnt_M
	public FViewCnt_A
	public Fistagview
	public Ftag_sdate
	public Ftag_edate
	public Ftag_announcedate


	'// 할인율 '!
	public Function getSalePro()
		if FOrgprice=0 then
			getSalePro = 0 & "%"
		else
			getSalePro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100) & "%"
		end if
	end Function

	'// 무료 배송 여부 '?
	public Function IsFreeBeasong()
		if (getRealPrice()>=getFreeBeasongLimitByUserLevel()) then
			IsFreeBeasong = true
		else
			IsFreeBeasong = false
		end if

		if (FDeliverytype="2") or (FDeliverytype="4") or (FDeliverytype="5") then
			IsFreeBeasong = true
		end if

		''//착불 배송은 무료배송이 아님
		if (FDeliverytype="7") then
		    IsFreeBeasong = false
		end if
	end Function

	'// 무료 배송 쿠폰 여부 '?
	public function IsFreeBeasongCoupon()
		IsFreeBeasongCoupon = Fitemcoupontype="3"
	end function

	' 사용자 등급별 무료 배송 가격  '?
	public Function getFreeBeasongLimitByUserLevel()
		dim ulevel

		''쇼핑에서는 사용자레벨에 상관없이 3만 / 업체 개별배송 5만 장바구니에서만 체크
		if (FDeliverytype="9") then
		    If (IsNumeric(FDefaultFreeBeasongLimit)) and (FDefaultFreeBeasongLimit<>0) then
		        getFreeBeasongLimitByUserLevel = FDefaultFreeBeasongLimit
		    else
		        getFreeBeasongLimitByUserLevel = 50000
		    end if
		else
		    getFreeBeasongLimitByUserLevel = 30000
		end if

	end Function

	'// 상품 쿠폰 내용
	public function GetCouponDiscountStr() '!
		Select Case Fitemcoupontype
			Case "1"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "%"
			Case "2"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "원"
			Case "3"
				GetCouponDiscountStr ="무료배송"
			Case Else
				GetCouponDiscountStr = Fitemcoupontype
		End Select
	end function

	'// 쿠폰 적용가
	public Function GetCouponAssignPrice() '!
		if (IsCouponItem) then
			GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
		else
			GetCouponAssignPrice = getRealPrice
		end if
	end Function

	'// 쿠폰 할인가
	public Function GetCouponDiscountPrice() '?
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

	'// 원 판매 가격
	public Function getOrgPrice() '!
		if FOrgPrice=0 then
			getOrgPrice = FSellCash
		else
			getOrgPrice = FOrgPrice
		end if
	end Function

	'// 세일포함 실제가격
	public Function getRealPrice() '!
		getRealPrice = FSellCash

		if (IsSpecialUserItem()) then
			getRealPrice = getSpecialShopItemPrice(FSellCash)
		end if
	end Function

	'// 우수회원샵 상품 여부
	public Function IsSpecialUserItem() '!
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>0 and uLevel<>5)
	end Function

 	public Function IsSaleItem() '!
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem)
	end Function

 	'// 상품 쿠폰 여부
	public Function IsCouponItem() '!
			IsCouponItem = (FItemCouponYN = "Y")
	end Function

    public function GetImageUrl()
        if (IsNULL(fimagepath) or (fimagepath = "")) then
            GetImageUrl = ""
        else
			IF application("Svr_Info") = "Dev" THEN
				GetImageUrl = "http://testimgstatic.10x10.co.kr/diary/main/" & fimagepath
			Else
				GetImageUrl = "http://imgstatic.10x10.co.kr/diary/main/" & fimagepath
			End If
        end if
    end function

	public Function IsSoldOut()
		'isSoldOut = (FSellYn="N")
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function

	'//	한정 여부 '!
	public Function IsLimitItem()
			IsLimitItem= (FLimitYn="Y")
	end Function

	'// 신상품 여부 '!
	public Function IsNewItem()
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function

	'// 재입고 상품 여부
	public Function isReipgoItem()
		isReipgoItem = (datediff("d",FReIpgoDate,now())<= 14)
	end Function

	'//일시품절 여부 '2008/07/07 추가 '!
	public Function isTempSoldOut()
		isTempSoldOut = (FSellYn="S")
	end Function

	'// 마일리지샵 아이템 여부 '!
	public Function IsMileShopitem()
		IsMileShopitem = (FItemDiv="82")
	end Function

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class
			
Class CPlay
	public FItemList()
	public FItemOne
	public FOneItem
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FImgArr
	public FItemArr
	public FPlayAzipList
	public FPlayThiThiWinList
	public FPlayThiThiEntCnt
	public FPlayThiThiEntList
	public FRectIsMain
	public FRectMIdx
	public FRectDIdx
	public FRectUsing
	public FRectStartdate
	public FRectState
	public FRectTop
	public FRectCate
	public FRectDevice
	public FRectIsMine


	Private Sub Class_Initialize()
		FCurrPage = 1
		FTotalPage = 0
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		FRectDevice = "m"
	End Sub
	Private Sub Class_Terminate()
	End Sub


	public Function fnPlayMainVolList()
		dim sqlStr, i

		sqlStr = "SELECT TOP " & FPageSize & " m.midx, m.volnum, m.title, m.mo_bgcolor FROM [db_giftplus].[dbo].[tbl_play_master] as m "
		sqlStr = sqlStr & "WHERE m.startdate < " & FRectStartdate & " and m.state = '" & FRectState & "' "
		sqlStr = sqlStr & "ORDER BY m.volnum DESC, m.startdate DESC"
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		
		FResultCount = rsget.RecordCount
		if (FResultCount<1) then FResultCount=0
		FTotalCount = FResultCount

		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnPlayMainVolList = rsget.getRows()
		END IF
		rsget.Close
    End Function
    
    
	public Function fnPlayMainCornerList()
		dim sqlStr, i

		If Not FRectIsMain Then
			sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_MainCornerCount] '" & FRectTop & "', '" & FRectMIdx & "', '" & FRectStartdate & "', '" & FRectState & "', '" & FRectCate & "'"
			'response.write sqlStr & "<br>"
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
			
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FTotalCount 	= rsget(0)
				FTotalPage	= rsget(1)
			END IF
			rsget.Close
			
			if FTotalCount < 1 then exit function
		END IF
		

		'### d.didx, d.title, d.cate, ca.catename, d.startdate, imgurl, d.mo_bgcolor, d.iconimg, d.titlestyle
		sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_MainCornerList] '" & FRectTop & "', '" & FRectMIdx & "', '" & FRectStartdate & "', '" & FRectState & "', '" & FRectCate & "', '" & FRectDevice & "'"
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		

		If FRectIsMain Then
			rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnPlayMainCornerList = rsget.getRows()
			END IF
		Else
			rsget.Open sqlStr,dbget,1
			
			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

			if (FResultCount<1) then FResultCount=0

			redim preserve FItemList(FResultCount)
			
			i=0
			IF Not (rsget.EOF OR rsget.BOF) THEN
				rsget.absolutepage = FCurrPage
				do until rsget.EOF
					set FItemList(i) = new CPlayItem

					FItemList(i).Fdidx		= rsget("didx")
					FItemList(i).Ftitle		= db2html(rsget("title"))
					FItemList(i).Ftitlestyle	= db2html(rsget("titlestyle"))
					FItemList(i).Fcate		= rsget("cate")
					FItemList(i).Fcatename	= rsget("catename")
					FItemList(i).Fstartdate	= rsget("startdate")
					FItemList(i).Fimgurl		= rsget("imgurl")
					FItemList(i).Fbgcolor		= rsget("mo_bgcolor")
					FItemList(i).Ficonimg		= rsget("iconimg")
					FItemList(i).Fistagview	= rsget("istagview")
					FItemList(i).Ftag_sdate	= rsget("tag_sdate")
					FItemList(i).Ftag_edate	= rsget("tag_edate")
					FItemList(i).Ftag_announcedate = rsget("tag_announcedate")

					rsget.movenext
					i=i+1
				loop
			END IF
		END IF
		rsget.Close
    End Function

	
	public Sub sbPlayCornerDetail()
		dim sqlStr, addsql

		sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_CornerDetail] '" & FRectDIdx & "','" & FRectStartdate & "','" & FRectState & "'"
		'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		FResultCount = rsget.RecordCount

		set FOneItem = new CPlayItem

		if Not rsget.Eof then

			FOneItem.Fcate		= rsget("cate")
			'FOneItem.Fcatename	= rsget("catename")
			FOneItem.Ftitle		= db2html(rsget("title"))
			FOneItem.Ftitlestyle	= db2html(rsget("titlestyle"))
			FOneItem.Fsubcopy		= db2html(rsget("subcopy"))
			FOneItem.Fstartdate	= rsget("startdate")
			FOneItem.Fcontents	= db2html(rsget("mo_contents"))
			FOneItem.FisExec		= rsget("mo_isExec")
			FOneItem.Fexecfile	= rsget("mo_execfile")
			FOneItem.Fbgcolor		= rsget("mo_bgcolor")
			FOneItem.FViewCnt_W	= rsget("viewcnt_w")
			FOneItem.FViewCnt_M	= rsget("viewcnt_m")
			FOneItem.FViewCnt_A	= rsget("viewcnt_a")
			FOneItem.FtagSDate	= rsget("tag_sdate")
			FOneItem.FtagEDate	= rsget("tag_edate")
			FOneItem.Ftag_announcedate = rsget("tag_announcedate")

		end if
		rsget.Close
		
		'### 이미지 모두 받아옴. 받아서 따로 처리.
		sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_ImageList] '" & FRectDIdx & "' "
		'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if Not rsget.Eof then
			FImgArr = rsget.getRows()
		end if
		rsget.Close
	end Sub
	
	
	public Sub sbPlayPlaylistDetail()
		dim sqlStr, addsql

		sqlStr = "SELECT * FROM [db_giftplus].[dbo].[tbl_play_playlist] WHERE didx = '" & FRectDIdx & "'"
		'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		FResultCount = rsget.RecordCount

		set FOneItem = new CPlayItem
		if Not rsget.Eof then
			FOneItem.Fdirecter 	= rsget("directer")
			FOneItem.Ftype 		= rsget("type")
			FOneItem.Fvideourl	= rsget("videourl")
			FOneItem.Fcomm_title	= rsget("comm_title")
			FOneItem.Fcomment1	= rsget("comment1")
			FOneItem.Fcomment2	= rsget("comment2")
			FOneItem.Fcomment3	= rsget("comment3")
			FOneItem.FCate1precomm1	= rsget("precomm1")
			FOneItem.FCate1precomm2	= rsget("precomm2")
			FOneItem.FCate1precomm3	= rsget("precomm3")
			FOneItem.FCate1VideoOrigin = rsget("videoorigin")
			FOneItem.FCate1RewardCopy = rsget("rewardcopy")
		end if
		rsget.Close
	end Sub
	
	
	public Sub sbPlayPlaylistComment()
		dim sqlStr, addsql, i
		
		If FRectIsMine = "o" Then
			addsql = " and userid = '" & getEncLoginUserID() & "'"
		End If
		
		sqlStr = "select count(idx), CEILING(CAST(Count(idx) AS FLOAT)/" & FRectTop & ") AS totPg from [db_giftplus].[dbo].[tbl_play_playlist_comment] "
		sqlStr = sqlStr & "where didx = '" & FRectDIdx & "' " & addsql
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if Not rsget.Eof then
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		end if
		rsget.Close
		
		If FTotalCount > 0 Then
			sqlStr = "select Top " & FRectTop & " idx, userid, comment1, comment2, comment3, device, regdate from [db_giftplus].[dbo].[tbl_play_playlist_comment] "
			sqlStr = sqlStr & "where didx = '" & FRectDIdx & "' " & addsql & " ORDER BY idx Desc "
			rsget.CursorLocation = adUseClient
			rsget.pagesize = FPageSize
			rsget.Open sqlStr,dbget,1
			
			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

			if (FResultCount<1) then FResultCount=0

			redim preserve FItemList(FResultCount)
			
			i=0
			IF Not (rsget.EOF OR rsget.BOF) THEN
				rsget.absolutepage = FCurrPage
				do until rsget.EOF
					set FItemList(i) = new CPlayItem

					FItemList(i).FCa1Idx			= rsget("idx")
					FItemList(i).FCa1ComUserID	= rsget("userid")
					FItemList(i).Fcomment1		= rsget("comment1")
					FItemList(i).Fcomment2		= rsget("comment2")
					FItemList(i).Fcomment3		= rsget("comment3")
					FItemList(i).FCa1ComDevice	= rsget("device")
					FItemList(i).FCa1ComRegdate	= rsget("regdate")

					rsget.movenext
					i=i+1
				loop
			END IF
			rsget.Close
		END IF
	end Sub

	
	public Sub sbPlayAzitDetail()
		dim sqlStr, addsql
		
		sqlStr = "select groupnum, isNull(title,'') as imgurl, isNull(address,'') as linkurl, isNull(addrlink,'') as addrlink "
		sqlStr = sqlStr & "from [db_giftplus].[dbo].[tbl_play_azit] where didx = '" & FRectDIdx & "' "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if Not rsget.Eof then
			FPlayAzipList = rsget.getRows()
		end if
		rsget.Close
		
		sqlStr = "select * from [db_giftplus].[dbo].[tbl_play_azit_entry] where didx = '" & FRectDIdx & "' "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		
		set FOneItem = new CPlayItem
		if Not rsget.Eof then
			FOneItem.FCate3EntryCont  = db2html(rsget("entry_content"))
			FOneItem.FCate3EntrySDate = rsget("entry_sdate")
			FOneItem.FCate3EntryEDate = rsget("entry_edate")
			FOneItem.FCate3AnnounDate = rsget("announce_date")
			FOneItem.FCate3Notice	 = db2html(rsget("notice"))
			FOneItem.FCate3EntryMethod = rsget("entry_method")
		end if
		rsget.Close
	end Sub
	
	
	public Sub sbPlayAzitComment()
		dim sqlStr, addsql, i
		
		If FRectIsMine = "o" Then
			addsql = " and userid = '" & getEncLoginUserID() & "'"
		End If
		
		sqlStr = "select count(idx), CEILING(CAST(Count(idx) AS FLOAT)/" & FRectTop & ") AS totPg from [db_giftplus].[dbo].[tbl_play_azit_comment] "
		sqlStr = sqlStr & "where didx = '" & FRectDIdx & "' " & addsql
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if Not rsget.Eof then
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		end if
		rsget.Close
		
		If FTotalCount > 0 Then
			sqlStr = "select Top " & FRectTop & " idx, userid, comment1, comment2, device, regdate from [db_giftplus].[dbo].[tbl_play_azit_comment] "
			sqlStr = sqlStr & "where didx = '" & FRectDIdx & "' " & addsql & " ORDER BY idx Desc "
			rsget.CursorLocation = adUseClient
			rsget.pagesize = FPageSize
			rsget.Open sqlStr,dbget,1
			
			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

			if (FResultCount<1) then FResultCount=0

			redim preserve FItemList(FResultCount)
			
			i=0
			IF Not (rsget.EOF OR rsget.BOF) THEN
				rsget.absolutepage = FCurrPage
				do until rsget.EOF
					set FItemList(i) = new CPlayItem

					FItemList(i).FCa3Idx			= rsget("idx")
					FItemList(i).FCa3ComUserID	= rsget("userid")
					FItemList(i).Fcomment1		= rsget("comment1")
					FItemList(i).Fcomment2		= rsget("comment2")
					FItemList(i).FCa3ComDevice	= rsget("device")
					FItemList(i).FCa3ComRegdate	= rsget("regdate")

					rsget.movenext
					i=i+1
				loop
			END IF
			rsget.Close
		END IF
	end Sub
	
	
	public Sub sbPlayThingThingDetail()
		dim sqlStr, addsql, i
		
		sqlStr = "select * from [db_giftplus].[dbo].[tbl_play_thingthing] where didx = '" & FRectDIdx & "' "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		
		set FOneItem = new CPlayItem
		if Not rsget.Eof then
			FOneItem.FCate42EntrySDate = rsget("entry_sdate")
			FOneItem.FCate42EntryEDate = rsget("entry_edate")
			FOneItem.FCate42AnnounDate = rsget("announce_date")
			FOneItem.FCate42WinnerTxt  = rsget("winnertxt")
			FOneItem.FCate42WinnerValue = rsget("winnervalue")
			FOneItem.FCate42Notice	 = db2html(rsget("notice"))
			FOneItem.FCate42Entrycopy = db2html(rsget("entrycopy"))
			FOneItem.FCate42Badgetag = db2html(rsget("badgetag"))
		end if
		rsget.Close
		

		If FOneItem.FCate42AnnounDate <> "" Then	'### 당첨일 이후 사용
			If CDate(FOneItem.FCate42AnnounDate) <= date() Then
				sqlStr = "select winnervalue from [db_giftplus].[dbo].[tbl_play_thingthing_winlist] where didx = '" & FRectDIdx & "' "
				rsget.CursorLocation = adUseClient
				rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
				if Not rsget.Eof then
					FPlayThiThiWinList = rsget.getRows()
				end if
				rsget.Close
			End If
		End If
	end Sub
	
	
	public Sub sbPlayThingThingComment()
		dim sqlStr, addsql, i
		
		If FRectIsMine = "o" Then
			addsql = " and userid = '" & getEncLoginUserID() & "'"
		End If
		
		sqlStr = "select count(idx), CEILING(CAST(Count(idx) AS FLOAT)/" & FRectTop & ") AS totPg from [db_giftplus].[dbo].[tbl_play_thingthing_entry] "
		sqlStr = sqlStr & "where didx = '" & FRectDIdx & "' " & addsql
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if Not rsget.Eof then
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		end if
		rsget.Close
		
		If FTotalCount > 0 Then
			sqlStr = "select Top " & FRectTop & " idx, userid, entryvalue, device, regdate from [db_giftplus].[dbo].[tbl_play_thingthing_entry] "
			sqlStr = sqlStr & "where didx = '" & FRectDIdx & "' " & addsql & " ORDER BY idx Desc "
			rsget.CursorLocation = adUseClient
			rsget.pagesize = FPageSize
			rsget.Open sqlStr,dbget,1
			
			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

			if (FResultCount<1) then FResultCount=0

			redim preserve FItemList(FResultCount)
			
			i=0
			IF Not (rsget.EOF OR rsget.BOF) THEN
				rsget.absolutepage = FCurrPage
				do until rsget.EOF
					set FItemList(i) = new CPlayItem

					FItemList(i).FCa42Idx			= rsget("idx")
					FItemList(i).FCa42EntUserID	= rsget("userid")
					FItemList(i).FCa42EntVal		= rsget("entryvalue")
					FItemList(i).FCa42EntDevice	= rsget("device")
					FItemList(i).FCa42EntRegdate	= rsget("regdate")

					rsget.movenext
					i=i+1
				loop
			END IF
			rsget.Close
		END IF
	end Sub
	
	
	public Sub sbPlayCommaDetail()
		dim sqlStr, addsql

		sqlStr = "SELECT directer FROM [db_giftplus].[dbo].[tbl_play_comma] WHERE didx = '" & FRectDIdx & "'"
		'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		FResultCount = rsget.RecordCount

		set FOneItem = new CPlayItem
		if Not rsget.Eof then
			FOneItem.Fdirecter = rsget("directer")
		end if
		rsget.Close
	end Sub
	
	
	public Sub sbPlayHowhowDetail()
		dim sqlStr, addsql

		sqlStr = "SELECT videourl, bannsub, banntitle, bannbtntitle, bannbtnlink FROM [db_giftplus].[dbo].[tbl_play_howhow] WHERE didx = '" & FRectDIdx & "'"
		'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		FResultCount = rsget.RecordCount

		set FOneItem = new CPlayItem
		if Not rsget.Eof then
			FOneItem.Fvideourl 		= rsget("videourl")
			FOneItem.Fbannsub			= rsget("bannsub")
			FOneItem.Fbanntitle 		= rsget("banntitle")
			FOneItem.Fbannbtntitle 	= rsget("bannbtntitle")
			FOneItem.Fbannbtnlink	= rsget("bannbtnlink")
		end if
		rsget.Close
	end Sub

	
	public Function fnPlayItemList()
		dim sqlStr, i

		'### d.didx, d.title, d.cate, ca.catename, d.startdate, imgurl
		sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_ItemList] '" & FRectDIdx & "'"
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		
		i=0
		IF Not (rsget.EOF OR rsget.BOF) THEN
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("listimage")
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("listimage120")
				FItemList(i).FIcon1Image  = "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("icon1image")
				FItemList(i).FIcon2Image  = "http://webimage.10x10.co.kr/image/icon2/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("icon2image")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))
				FItemList(i).Fitemdiv		= rsget("itemdiv")
				FItemList(i).FSellCash 		= rsget("sellcash")
				FItemList(i).FOrgPrice 		= rsget("orgprice")
				FItemList(i).FSellyn 		= rsget("sellyn")
				FItemList(i).FSaleyn 		= rsget("sailyn")
				FItemList(i).FLimityn 		= rsget("limityn")
				FItemList(i).FLimitNo      = rsget("limitno")
				FItemList(i).FLimitSold    = rsget("limitsold")
				FItemList(i).FItemcouponyn 	= rsget("itemcouponyn")
				FItemList(i).FItemCouponValue 	= rsget("itemCouponValue")
				FItemList(i).FItemCouponType 	= rsget("itemCouponType")
				FItemList(i).FEvalCnt 	= rsget("evalcnt")
				'FItemList(i).FfavCount 	= rsget("favcount")
               FItemList(i).FOptionCnt = rsget("optioncnt")

				i=i+1
				rsget.moveNext
			loop
		END IF
		rsget.Close
    End Function
    
    
    public Function fnPlayDownloadList()
    	dim sqlStr, i
		sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_DownList] '" & FRectDIdx & "','" & FRectDevice & "' "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if Not rsget.Eof then
			fnPlayDownloadList = rsget.getRows()
		end if
		rsget.Close
	End Function
    
    
	public Function fnPlayCornerMoreList()
		dim sqlStr, i

		'd.didx, d.title, imgurl
		sqlStr = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_CornerMoreList] '" & FRectTop & "','" & FRectStartdate & "','" & FRectState & "','" & FRectCate & "','" & FRectDIdx & "'"
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnPlayCornerMoreList = rsget.getRows()
		END IF
		rsget.Close
    End Function
	

	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function
	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function
	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class


Function fnClassNameToCate(c)
	Dim vName
	SELECT CASE c
		Case "1" : vName = "Playlist"
		Case "2" : vName = "Inspiration"
		Case "21" : vName = "Inspiration"
		Case "22" : vName = "Inspiration"
		Case "3" : vName = "Azit"
		'// 2017.06.01 원승현 azit comma 스타일 추가
		Case "31" : vName = "AzitComma"
		Case "4" : vName = "Thing"
		Case "41" : vName = "Thing"
		Case "42" : vName = "Thing"
		Case "43" : vName = "Thing"
		Case "5" : vName = "Comma"
		Case "6" : vName = "Howhow"
		Case "" : vName = "All"
	End SELECT
	
	fnClassNameToCate = vName
End Function


Function fnListCateName(c,v)
	Dim vName
	If c <> "" Then
		If Left(c,1) = "2" OR Left(c,1) = "4" Then
			vName = Split(v,"||")(0)
		Else
			vName = v
		End IF
	End IF
	
	fnListCateName = vName
End Function


Function fnPlayImageSelect(arr,ca,gb,v)
'### 온니 1개인 경우. sortno 가 없는 경우.
	Dim i, vValue
	'select idx, cate, gubun, isNull(imgurl,'') as imgurl, isNull(linkurl,'') as linkurl, imagecopy, sortno 
	IF isArray(arr) THEN
		For i =0 To UBound(arr,2)
			If CStr(ca) = CStr(arr(1,i)) and CStr(gb) = CStr(arr(2,i)) Then
				If v = "i" Then	'### 이미지
					vValue = arr(3,i)
				ElseIf v = "l" Then	'### 링크
					vValue = arr(4,i)
				ElseIf v = "c" Then	'### 카피
					vValue = db2html(arr(5,i))
				End If
				Exit For
			End IF
		Next
	End If
	fnPlayImageSelect = vValue
End Function


Function fnPlayImageSelectSortNo(arr,ca,gb,v,gn,sn)
'### gb가 여러개인 경우. sortno 가 지정 된 경우.
	Dim i, vValue
	'select idx, cate, gubun, isNull(imgurl,'') as imgurl, isNull(linkurl,'') as linkurl, imagecopy, sortno , groupnum
	IF isArray(arr) THEN
		'response.write UBound(arr,2)
		For i =0 To UBound(arr,2)
			If CStr(ca) = CStr(arr(1,i)) and CStr(gb) = CStr(arr(2,i)) and CStr(gn) = CStr(arr(7,i)) and CStr(sn) = CStr(arr(6,i)) Then
				If v = "i" Then	'### 이미지
					vValue = arr(3,i)
				ElseIf v = "l" Then	'### 링크
					vValue = arr(4,i)
				ElseIf v = "c" Then	'### 카피
					vValue = db2html(arr(5,i))
				End If
				Exit For
			End IF
		Next
	End If
	fnPlayImageSelectSortNo = vValue
End Function


Function fnPlayAzitSelect(arr,gn,v)
	Dim i, vValue
	'select groupnum, isNull(title,'') as title, isNull(address,'') as address, isNull(addrlink,'') as addrlink
	IF isArray(arr) THEN
		For i =0 To UBound(arr,2)
			If CStr(gn) = CStr(arr(0,i)) Then
				vValue = arr(v,i)
				Exit For
			End IF
		Next
	End If
	fnPlayAzitSelect = vValue
End Function


Function fnPlayViewCount(i,d)
	Dim vQuery
	If i <> "" AND d <> "" Then
		vQuery = "EXEC [db_giftplus].[dbo].[sp_Ten_Play_ViewCount] '" & i & "','" & d & "'"
		dbget.Execute vQuery
	End If
End Function


Function fnPlayingCateVer2(gubun,code)
	Dim vTemp
	If gubun = "topname" Then
		SELECT CASE code
			Case "41", "42", "43" : vTemp = "THING."
			'// 2017.06.01 원승현 azit comma 스타일 추가
			Case "3", "1", "31" : vTemp = "TALK"
			Case "21", "22", "5", "6" : vTemp = "!NSPIRATION"
		END SELECT
	ElseIf gubun = "topcode" Then
		SELECT CASE code
			Case "41", "42", "43" : vTemp = "thing"
			'// 2017.06.01 원승현 azit comma 스타일 추가
			Case "3", "1", "31" : vTemp = "talk"
			Case "21", "22", "5", "6" : vTemp = "inspi"
		END SELECT
	ElseIf gubun = "topcopy" Then
		SELECT CASE code
			Case "thing", "41", "42", "43" : vTemp = "사물에 대한 다양한 시각"
			'// 2017.06.01 원승현 azit comma 스타일 추가
			Case "talk", "3", "1", "31" : vTemp = "크리에이터의 아트웍"
			Case "inspi", "21", "22", "5", "6" : vTemp = "감성 공유 & TALK"
		END SELECT
	End If
	fnPlayingCateVer2 = vTemp
End Function


Function fnClassNameToNewCate(c)
	Dim vName
	SELECT CASE c
		Case "thing" : vName = "Thing"
		Case "talk" : vName = "Talk"
		Case "inspi" : vName = "Inspiration"
		Case Else vName = "All"
	End SELECT
	
	fnClassNameToNewCate = vName
End Function
%>