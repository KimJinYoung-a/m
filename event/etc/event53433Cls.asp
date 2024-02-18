<%
'####################################################
' Description : 텐텐 앱으로 떠나는 나만의 여름휴가
' History : 2014.07.10 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-07-16"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21235
	Else
		evt_code   =  53433
	End If
	
	getevt_code = evt_code
end function

Class Cls50277
	public FItemgubun
	public FTotCnt
	public FItemArr
	public FCategoryPrdList()

	Private Sub Class_Initialize()
		redim preserve FCategoryPrdList(0)
		FTotCnt = 0
		FItemArr = ""
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public Function fnGetEventItem
		Dim sqlStr, sqlsearch, sqlorder, arrItem, intI

		sqlsearch = sqlsearch & " and i.itemid in (1062995,1087939,1048426,889080,1083791,1035580,1087961,1072854,1060949,622676,986831,1067910,1068304,876282,1085016,1084926)"
		sqlorder = sqlorder & " order by i.itemid desc"
		
		sqlStr = "SELECT top 20"
		sqlStr = sqlStr & " i.itemid, i.itemname, i.sellcash,i.orgprice"
		sqlStr = sqlStr & " ,(Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid"
		sqlStr = sqlStr & " ,i.brandname, i.listimage,i.listimage120, i.smallImage, i.sellyn, i.sailyn, i.limityn,i.limitno, i.limitsold,i.regdate,i.reipgodate"
		sqlStr = sqlStr & " ,itemcouponYn, itemCouponValue, itemCouponType, i.evalCnt, i.itemScore, icon1image, i.icon2image, '', i.itemdiv "
		sqlStr = sqlStr & " ,case i.limityn when 'Y' then case when ((i.limitno-i.limitsold)<=0) then '2' else '1' end Else '1' end as lsold "
		sqlStr = sqlStr & " ,i.basicimage, i.basicimage600, isnull(c.favcount,0) as favcount"
		sqlStr = sqlStr & " FROM [db_item].[dbo].tbl_item as i"
		sqlStr = sqlStr & " LEFT JOIN [db_item].[dbo].[tbl_item_contents] AS c"
		sqlStr = sqlStr & " 	ON i.itemid = c.itemid "
		sqlStr = sqlStr & " WHERE i.isusing='Y' and i.sellyn in ('Y','S')" & sqlsearch & sqlorder

		'response.write sqlStr &"<Br>"
		rsget.Open sqlStr,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrItem = rsget.GetRows()
		END IF
		rsget.close

		IF isArray(arrItem) THEN
			FTotCnt = Ubound(arrItem,2)
			redim preserve FCategoryPrdList(FTotCnt)

			For intI = 0 To FTotCnt
			set FCategoryPrdList(intI) = new CCategoryPrdItem
				FCategoryPrdList(intI).FItemID       = arrItem(0,intI)
				IF intI =0 THEN
				FItemArr = 	FCategoryPrdList(intI).FItemID
				ELSE
				FItemArr = FItemArr&","&FCategoryPrdList(intI).FItemID
				END IF
				FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))

				FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
				FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
				FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
				FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))

				FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
				FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
				FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
				FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
				FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)

				FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
				FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)

                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
				FCategoryPrdList(intI).FItemCouponValue= arrItem(17,intI)
				FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)

				FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
				FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)

				FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
				FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
				FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
				FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
				FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
				FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
				FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)
				FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
				FCategoryPrdList(intI).FImageBasic600 = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(27,intI)
				FCategoryPrdList(intI).FfavCount	= arrItem(28,intI)

			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function

End Class

function getusercell(userid)
	dim sqlstr, tmpusercell
	
	if userid="" then
		getusercell=""
		exit function
	end if
	
	sqlstr = "select top 1 n.usercell"
	sqlstr = sqlstr & " from db_user.dbo.tbl_user_n n"
	sqlstr = sqlstr & " where n.userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpusercell = rsget("usercell")
	else
		tmpusercell = ""
	END IF
	rsget.close
	
	getusercell = tmpusercell
end function
%>