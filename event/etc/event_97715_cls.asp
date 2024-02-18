<%
'####################################################
' Description : 18주년 텐텐데이 클래스
' History : 2019.10.07 한용민 생성
'####################################################

Class Cevent_97715
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount

	public sub fnevent_97715()
		dim sqlStr,i, sqlsearch

        sqlStr = "select e.itemid, e.couponidx as sortNo" & vbcrlf
        sqlStr = sqlStr & " , i.itemname, i.sellcash,i.orgprice" & vbcrlf
        sqlStr = sqlStr & " ,(Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid" & vbcrlf
        'sqlStr = sqlStr & " ,(Case When isNull(i.frontMakerid,'')='' then b.SocName else c2.SocName end) as brandname" & vbcrlf
        sqlStr = sqlStr & " , i.listimage,i.listimage120, i.smallImage, i.sellyn, i.sailyn, i.limityn,i.limitno, i.limitsold,i.regdate,i.reipgodate" & vbcrlf
        sqlStr = sqlStr & " ,itemcouponYn, itemCouponValue, itemCouponType, i.evalCnt, i.itemScore, icon1image, i.icon2image, i.itemdiv" & vbcrlf
        sqlStr = sqlStr & " ,case i.limityn when 'Y' then case when ((i.limitno-i.limitsold)<=0) then '2' else '1' end Else '1' end as lsold" & vbcrlf
        sqlStr = sqlStr & " ,i.basicimage, i.basicimage600" & vbcrlf
        'sqlStr = sqlStr & " , c.favcount" & vbcrlf
        'sqlStr = sqlStr & " ,a.addimage_400" & vbcrlf
        sqlStr = sqlStr & " , (CASE WHEN (orgprice - sellcash) > 0 THEN round((1 - sellcash / orgprice) * 100, 0) WHEN (orgprice - sellcash) <= 0 THEN 0 END) AS SalePercent" & vbcrlf
        sqlStr = sqlStr & " ,i.tentenimage, i.tentenimage50, i.tentenimage200, i.tentenimage400, i.tentenimage600, i.tentenimage1000, i.optioncnt, i.deliverfixday" & vbcrlf
        sqlStr = sqlStr & " ,i.adultType" & vbcrlf
        sqlStr = sqlStr & " from db_temp.[dbo].[tbl_event_etc_yongman] e with (nolock)" & vbcrlf
        sqlStr = sqlStr & " JOIN  [db_item].[dbo].tbl_item as i with (nolock)" & vbcrlf
        sqlStr = sqlStr & "     ON e.itemid = i.itemid" & vbcrlf
		'sqlStr = sqlStr & " LEFT OUTER JOIN [db_item].[dbo].[tbl_item_contents] AS c with (nolock) ON i.itemid = c.itemid" & vbcrlf
		'sqlStr = sqlStr & " LEFT OUTER JOIN [db_item].[dbo].[tbl_item_addimage] AS a with (nolock) ON i.itemid = a.itemid and a.gubun = 1 and a.imgtype = 0" & vbcrlf
		'sqlStr = sqlStr & " LEFT JOIN [db_user].[dbo].tbl_user_c as b with (nolock) on i.makerid=b.userid" & vbcrlf
		'sqlStr = sqlStr & " LEFT JOIN [db_user].[dbo].tbl_user_c as c2 with (nolock) on i.frontMakerid=c2.userid" & vbcrlf
        sqlStr = sqlStr & " where e.isusing='Y' and e.event_code=97715" & vbcrlf
        sqlStr = sqlStr & " order by e.couponidx asc, e.bigo asc" & vbcrlf

		'response.write sqlStr & "<Br>"
		rsget.pagesize = FPageSize
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		ftotalcount = rsget.recordcount
        FResultCount = rsget.recordcount
		' if (FCurrPage * FPageSize < FTotalCount) then
		' 	FResultCount = FPageSize
		' else
		' 	FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		' end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CCategoryPrdItem

                FItemList(i).fsortNo = rsget("sortNo")
                FItemList(i).fitemid = rsget("itemid")
				FItemList(i).FItemName    = db2html(rsget("itemname"))

				FItemList(i).FSellcash    = rsget("sellcash")
				FItemList(i).FOrgPrice   	= rsget("orgprice")
				FItemList(i).FMakerId   	= db2html(rsget("makerid"))
				'FItemList(i).FBrandName  	= db2html(rsget("brandname"))

				FItemList(i).FSellYn      = rsget("sellyn")
				FItemList(i).FSaleYn     	= rsget("sailyn")
				FItemList(i).FLimitYn     = rsget("limityn")
				FItemList(i).FLimitNo     = rsget("limitno")
				FItemList(i).FLimitSold   = rsget("limitsold")

				FItemList(i).FRegdate 		= rsget("regdate")
				FItemList(i).FReipgodate		= rsget("reipgodate")

                FItemList(i).Fitemcouponyn 	= rsget("itemcouponYn")
				FItemList(i).FItemCouponValue	= rsget("itemCouponValue")
				FItemList(i).Fitemcoupontype	= rsget("itemCouponType")

				FItemList(i).Fevalcnt 		= rsget("evalCnt")
				FItemList(i).FitemScore 		= rsget("itemScore")
				FItemList(i).Fitemdiv			= rsget("itemdiv")

				If rsget("itemdiv")="21" Then
                    FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/"& rsget("listimage")
                    FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/"& rsget("listimage120")
                    FItemList(i).FImageSmall		= "http://webimage.10x10.co.kr/image/small/"& rsget("smallImage")
                    FItemList(i).FImageIcon1		= "http://webimage.10x10.co.kr/image/icon1/"& rsget("icon1image")
                    FItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/"& rsget("icon2image")
                    FItemList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/"& rsget("basicimage")
                    If rsget("basicimage600") <> "" Then
                    'FItemList(i).FImageBasic600	= "http://webimage.10x10.co.kr/image/basic/"& rsget("basicimage600")
                    End If
                    FItemList(i).FItemOptionCnt = rsget("optioncnt")
				Else
                    FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage")
                    FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage120")
                    FItemList(i).FImageSmall		= "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("smallImage")
                    FItemList(i).FImageIcon1		= "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon1image")
                    FItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
                    FItemList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage")
                    'FItemList(i).FImageBasic600	= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
				End If
				
				'FItemList(i).FfavCount		= rsget("favcount")

				'If rsget("addimage_400") <> "" then
				'    FItemList(i).FAddImage		= "http://webimage.10x10.co.kr/image/add1/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & db2html(rsget("addimage_400"))
				'End if

				If Not(rsget("tentenimage")="" Or isnull(rsget("tentenimage"))) Then 
					FItemList(i).Ftentenimage	= "http://webimage.10x10.co.kr/image/tenten/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("tentenimage")
					FItemList(i).Ftentenimage50	= "http://webimage.10x10.co.kr/image/tenten50/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("tentenimage50")
					FItemList(i).Ftentenimage200	= "http://webimage.10x10.co.kr/image/tenten200/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("tentenimage200")
					FItemList(i).Ftentenimage400	= "http://webimage.10x10.co.kr/image/tenten400/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("tentenimage400")
					FItemList(i).Ftentenimage600	= "http://webimage.10x10.co.kr/image/tenten600/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("tentenimage600")
					FItemList(i).Ftentenimage1000	= "http://webimage.10x10.co.kr/image/tenten1000/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("tentenimage1000")
				End If

				'// 해외직구배송작업추가
				FItemList(i).FDeliverFixDay		= rsget("deliverfixday") '해외 직구 배송
				FItemList(i).FadultType		= rsget("adultType") '성인

				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	Private Sub Class_Initialize()
		redim  FItemList(0)

	    FResultCount = 0
		FCurrPage =1
		FPageSize = 50
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub
End Class
%>