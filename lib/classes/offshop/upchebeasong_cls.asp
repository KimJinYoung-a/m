<%
'###########################################################
' Description : 오프라인 배송
' Hieditor : 2018.02.23 한용민 생성
'###########################################################

class cupchebeasong_item
	public fidx
	public fmasteridx
	public forderno
	public fitemgubun
	public fitemid
	public fitemoption
	public fitemname
	public fitemoptionname
	public fsellprice
	public frealsellprice
	public fsuplyprice
	public fitemno
	public fmakerid
	public fjungsanid
	public fcancelyn
	public fshopidx
	public fitempoint
	public fdiscountKind
	public fdiscountprice
	public fshopbuyprice
	public faddtaxcharge
	public fzoneidx
	public fshopid
	public ftotalsum
	public frealsum
	public fjumundiv
	public fjumunmethod
	public fshopregdate
	public fregdate
	public fspendmile
	public fpointuserno
	public fgainmile
	public ftableno
	public fcashsum
	public fcardsum
	public fGiftCardPaySum
	public fcasherid
	public fCashReceiptNo
	public fCardAppNo
	public fCashreceiptGubun
	public fCardInstallment
	public fIXyyyymmdd
	public fcurrstate
	public fshopname
	public fisupchebeasong
	public fomwdiv
	public fodlvType
	public fipkumdiv
	public fbeadaldiv
	public fbeadaldate
	public fbuyname
	public fbuyphone
	public fbuyhp
	public fbuyemail
	public freqname
	public freqzipcode
	public freqzipaddr
	public freqaddress
	public freqphone
	public freqhp
	public fcomment
	public fipgono
	public frealstock
	public fdetailidx
	public FBaljudate
	public Fsongjangno
	public Fsongjangdiv
	public FMisendReason
	public FMisendState
	public FMisendipgodate
	public Fupcheconfirmdate
	public Fbeasongdate
	public fdetailcancelyn
	public FisSendSMS
	public FisSendEmail
	public FisSendCall
	public FrequestString
	public Fitemlackno
	public FfinishString
	public Fcompany_name
	public Fcompany_tel
	public Fsmallimage
	public Fdefaultbeasongdiv		'배송구분 2:업체배송, 0:매장배송, 1:물류배송
	public Fshopmisend
	public Fupchemisend
	public fdupchestats0
	public fdupchestats2
	public fupchesendsms
	public fshopphone
	public fuserSeq
	public fUserName
	public fOnLineUSerID
	public fshopbeasongD_cancelyn
	public fshopbeasongM_cancelyn
	public fAuthIdx
	public fBeaSongcnt
	public fUserHp
	public fSmsYN
	public fKakaoTalkYN
	public fIsUsing
	public fLastUpdate
	public fregdate_beasong
	public fitemno_beasong
	public fmasteridx_beasong
	public fdetailidx_beasong
	public fcomm_cd
	public fCertNo
	public FImageSmall
	public FImageList
	public FImageBasic
	public Fbrandname
	public FDeliveryName

	Public function getDefaultBeasongDivName()
		if Fdefaultbeasongdiv="0" then
			getDefaultBeasongDivName="매장배송"
		elseif Fdefaultbeasongdiv="1" then
			getDefaultBeasongDivName="물류배송"
		elseif Fdefaultbeasongdiv="2" then
			getDefaultBeasongDivName="업체배송"
		else
			getDefaultBeasongDivName = Fdefaultbeasongdiv
		end if
	end Function

	Public function shopIpkumDivName()
		if Fipkumdiv="1" then
			shopIpkumDivName="배송지입력전"
		elseif Fipkumdiv="2" then
			shopIpkumDivName="배송지입력완료"
		elseif Fipkumdiv="5" then
			shopIpkumDivName="업체통보"
		elseif Fipkumdiv="6" then
			shopIpkumDivName="배송준비"
		elseif Fipkumdiv="7" then
			shopIpkumDivName="일부출고"
		elseif Fipkumdiv="8" then
			shopIpkumDivName="출고완료"
		end if
	end Function

	Public function shopNormalUpcheDeliverState()
		if IsNull(FCurrState) then
			shopNormalUpcheDeliverState = ""
		elseif FCurrState="0" then
			shopNormalUpcheDeliverState = "배송대기"
		elseif FCurrState="2" then
			shopNormalUpcheDeliverState = "업체통보"
		elseif FCurrState="3" then
			shopNormalUpcheDeliverState = "업체확인"
		elseif FCurrState="7" then
			shopNormalUpcheDeliverState = "출고완료"
		else
			shopNormalUpcheDeliverState = ""
		end if
	end Function

	'//배송구분(odlvType) 텐바이텐 배송이냐 업체 배송이냐..
	public function getbeasonggubun()
		if fodlvType = "0" then
			getbeasonggubun = "매장배송"
		elseif fodlvType = "1" then
			getbeasonggubun = "물류배송"
		elseif fodlvType = "4" then
			getbeasonggubun = "텐바이텐무료배송"
		elseif fodlvType = "2" then
			getbeasonggubun = "업체배송"
		elseif fodlvType = "7" then
			getbeasonggubun = "업체착불배송"
		else
			getbeasonggubun = "설정안됨"
		end if

	end function

    public function GetDeliveryName()
        if (Fcurrstate<>"7") then
			GetDeliveryName = ""
			exit function
		end if

        GetDeliveryName = FDeliveryName
    end function

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end class

class cupchebeasong_list
	public FItemList()
	public FOneItem
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FPageCount
	public frectorderNo

	'/my10x10/order/myshoporder.asp
    public Sub fshopjumun_master()
        dim sqlStr ,sqlsearch

		if frectorderNo="" then exit sub

		if frectorderNo<>"" then
			sqlsearch = sqlsearch & " and m.orderno='"& frectorderNo &"'" & vbcrlf
		end if

        sqlStr = "select top 1" & vbcrlf
        sqlStr = sqlStr & " m.shopid, m.OrderNo, m.regdate" & vbcrlf
        sqlStr = sqlStr & " , sc.userhp, sc.smsyn, sc.KakaoTalkYN, sc.CertNo" & vbcrlf
        sqlStr = sqlStr & " from db_shop.dbo.tbl_shopjumun_master m" & vbcrlf
        sqlStr = sqlStr & " left join db_shop.dbo.tbl_shopjumun_sms_cert sc" & vbcrlf
        sqlStr = sqlStr & " 	on m.orderno = sc.orderno" & vbcrlf
        sqlStr = sqlStr & " 	and sc.isusing='Y'" & vbcrlf
        sqlStr = sqlStr & " where m.cancelyn='N' " & sqlsearch

        'response.write sqlStr&"<br>"
        rsget.Open SqlStr, dbget, 1
        ftotalcount = rsget.RecordCount

        set FOneItem = new cupchebeasong_item

        if Not rsget.Eof then
			
			FOneItem.fshopid = rsget("shopid")
			FOneItem.fOrderNo = rsget("OrderNo")
			FOneItem.fregdate = rsget("regdate")
			FOneItem.fuserhp = rsget("userhp")
			FOneItem.fsmsyn = rsget("smsyn")
			FOneItem.fKakaoTalkYN = rsget("KakaoTalkYN")
			FOneItem.fCertNo = rsget("CertNo")

        end if
        rsget.Close
    end Sub

	'//common/offshop/beasong/shopjumun_address.asp
    public Sub fshopjumun_edit()
        dim sqlStr ,sqlsearch

		if frectorderno = "" then exit Sub

		if frectorderno <> "" then
			sqlsearch = sqlsearch & " and m.orderno='"&frectorderno&"'" +vbcrlf
		end if

        sqlStr = "select top 1" & vbcrlf
		sqlStr = sqlStr & " m.masteridx,m.orderno,m.shopid,m.ipkumdiv,m.regdate,m.beadaldiv,m.beadaldate" & vbcrlf
		sqlStr = sqlStr & " ,m.cancelyn,m.buyname,m.buyphone,m.buyhp,m.buyemail,m.reqname,m.reqzipcode" & vbcrlf
		sqlStr = sqlStr & " ,m.reqzipaddr,m.reqaddress,m.reqphone,m.reqhp,m.comment" & vbcrlf
		sqlStr = sqlStr & " ,u.shopname" & vbcrlf
		sqlStr = sqlStr & " from db_shop.dbo.tbl_shopbeasong_order_master m" +vbcrlf
		sqlStr = sqlStr & " left join db_shop.dbo.tbl_shop_user u" +vbcrlf
		sqlStr = sqlStr & " 	on m.shopid = u.userid" +vbcrlf
        sqlStr = sqlStr & " where m.cancelyn='N' " & sqlsearch

        'response.write sqlStr&"<br>"
        rsget.Open SqlStr, dbget, 1
        ftotalcount = rsget.RecordCount

        set FOneItem = new cupchebeasong_item

        if Not rsget.Eof then

			FOneItem.fshopname = rsget("shopname")
			FOneItem.fmasteridx = rsget("masteridx")
			FOneItem.forderno = rsget("orderno")
			FOneItem.fshopid = rsget("shopid")
			FOneItem.fipkumdiv = rsget("ipkumdiv")
			FOneItem.fregdate = rsget("regdate")
			FOneItem.fbeadaldiv = rsget("beadaldiv")
			FOneItem.fbeadaldate = rsget("beadaldate")
			FOneItem.fcancelyn = rsget("cancelyn")
			FOneItem.fbuyname = db2html(rsget("buyname"))
			FOneItem.fbuyphone = rsget("buyphone")
			FOneItem.fbuyhp = rsget("buyhp")
			FOneItem.fbuyemail = db2html(rsget("buyemail"))
			FOneItem.freqname = db2html(rsget("reqname"))
			FOneItem.freqzipcode = rsget("reqzipcode")
			FOneItem.freqzipaddr = db2html(rsget("reqzipaddr"))
			FOneItem.freqaddress = db2html(rsget("reqaddress"))
			FOneItem.freqphone = rsget("reqphone")
			FOneItem.freqhp = rsget("reqhp")
			FOneItem.fcomment = db2html(rsget("comment"))

        end if
        rsget.Close
    end Sub

	'//common/offshop/beasong/shopjumun_address.asp
	public sub fshopbeasong_input()
		dim sqlStr,i ,sqlsearch

		if frectorderno="" then exit sub

		if frectorderno <> "" then
			sqlsearch = sqlsearch & " and m.orderno ='"&frectorderno&"'" +vbcrlf
		end if

		sqlStr = "select top 500" + vbcrlf
		sqlStr = sqlStr & " m.orderno ,m.shopid" +vbcrlf
		sqlStr = sqlStr & " , d.itemgubun, d.itemid, d.itemoption, d.itemname, d.itemoptionname" +vbcrlf
		sqlStr = sqlStr & " ,d.sellprice, d.realsellprice, d.suplyprice, d.makerid, d.itemno" +vbcrlf
		sqlStr = sqlStr & " , bm.regdate as regdate_beasong, bd.masteridx as masteridx_beasong, bd.itemno as itemno_beasong,bd.currstate, bd.isupchebeasong" +vbcrlf
		sqlStr = sqlStr & " , bd.omwdiv, isnull(bd.odlvType,'') as odlvType, bd.detailidx as detailidx_beasong, bd.beasongdate, bd.songjangdiv, bd.songjangno" +vbcrlf
		sqlStr = sqlStr & " , i.smallimage, i.listimage, i.basicimage, c.socname, c.socname_kor, s.divname" +vbcrlf
		sqlStr = sqlStr & " from db_shop.dbo.tbl_shopjumun_master m" +vbcrlf
		sqlStr = sqlStr & " join db_shop.dbo.tbl_shopjumun_detail d" +vbcrlf
		sqlStr = sqlStr & " 	on m.idx = d.masteridx" +vbcrlf
		sqlStr = sqlStr & " 	and m.cancelyn='N' and d.cancelyn='N'" +vbcrlf
		sqlStr = sqlStr & "	left join [db_shop].[dbo].tbl_shopbeasong_order_detail bd" +vbcrlf
		sqlStr = sqlStr & "		on d.idx = bd.orgdetailidx" +vbcrlf
		sqlStr = sqlStr & "		and bd.cancelyn='N'" +vbcrlf
		sqlStr = sqlStr & "	left join [db_shop].[dbo].tbl_shopbeasong_order_master bm" +vbcrlf
		sqlStr = sqlStr & "		on bd.masteridx = bm.masteridx" +vbcrlf
		sqlStr = sqlStr & "		and bm.cancelyn='N'" +vbcrlf
		sqlStr = sqlStr & "	left join db_item.dbo.tbl_item i" +vbcrlf
		sqlStr = sqlStr & "		on d.itemgubun = '10'" +vbcrlf
		sqlStr = sqlStr & "		and d.itemid = i.itemid" +vbcrlf
		sqlStr = sqlStr & "		and i.isusing='Y'" +vbcrlf
		sqlStr = sqlStr & "	left join db_user.dbo.tbl_user_c c" +vbcrlf
		sqlStr = sqlStr & "		on d.makerid = c.userid" +vbcrlf
		'sqlStr = sqlStr & "		and c.isusing='Y'" +vbcrlf
		sqlStr = sqlStr & "	LEFT JOIN db_order.[dbo].tbl_songjang_div s" +vbcrlf
		sqlStr = sqlStr & "		ON bd.songjangdiv = s.divcd " +vbcrlf
		sqlStr = sqlStr & " where bd.masteridx is not null " & sqlsearch
		sqlStr = sqlStr & " order by m.idx desc"

		'response.write sqlStr &"<br>"
		rsget.Open sqlStr,dbget,1

		FTotalCount = rsget.recordcount

		redim preserve FItemList(FTotalCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new cupchebeasong_item

					FItemList(i).fdetailidx_beasong  	= rsget("detailidx_beasong")
					FItemList(i).fmasteridx_beasong  	= rsget("masteridx_beasong")
					FItemList(i).fregdate_beasong  	= rsget("regdate_beasong")
					FItemList(i).forderno  	= rsget("orderno")
					FItemList(i).fitemgubun  	= rsget("itemgubun")
					FItemList(i).fitemid  	= rsget("itemid")
					FItemList(i).fitemoption  	= rsget("itemoption")
					FItemList(i).fitemname  	= db2html(rsget("itemname"))
					FItemList(i).fitemoptionname  	= db2html(rsget("itemoptionname"))
					FItemList(i).fsellprice  	= rsget("sellprice")
					FItemList(i).frealsellprice  	= rsget("realsellprice")
					FItemList(i).fsuplyprice  	= rsget("suplyprice")
					FItemList(i).fitemno_beasong  	= rsget("itemno_beasong")
					FItemList(i).fitemno  	= rsget("itemno")
					FItemList(i).fmakerid  	= rsget("makerid")
					FItemList(i).fcurrstate  	= rsget("currstate")
					FItemList(i).fisupchebeasong  	= rsget("isupchebeasong")
					FItemList(i).fomwdiv  	= rsget("omwdiv")
					FItemList(i).fodlvType  	= rsget("odlvType")

					FItemList(i).fbeasongdate  	= rsget("beasongdate")

					FItemList(i).Fsongjangno  	= rsget("songjangno")
					FItemList(i).Fsongjangdiv  	= rsget("songjangdiv")
					FItemList(i).Fbrandname      = db2html(rsget("socname"))

					if not(rsget("smallimage")="" or isnull(rsget("smallimage"))) then FItemList(i).FImageSmall     = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("smallimage")
					if not(rsget("listimage")="" or isnull(rsget("listimage"))) then FItemList(i).FImageList      = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("listimage")
					if not(rsget("basicimage")="" or isnull(rsget("basicimage"))) then FItemList(i).FImageBasic      = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("basicimage")

					FItemList(i).FDeliveryName	 = rsget("divname")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	Private Sub Class_Initialize()
		redim  FItemList(0)
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

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
%>
