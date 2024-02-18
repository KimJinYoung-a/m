<%
'###########################################################
' Description : my10x10 mymain.asp
' History : 2017-11-13 이종화 생성
'###########################################################
Class CMyMainItem
	public Fgubun
	public Fcount
	Public FOrderSerial
	Public FOrderItemNames
	Public FOrderitemCount

	Public Fitemid
	Public Fitemname
	Public Fbasicimage
	Public Fsellcash
	Public Forgprice
	Public Fsailyn
	Public FitemcouponYN
	Public Fitemcouponvalue
	Public Fitemcoupontype
end Class

Class CMyMain
    public FItemList()
	Public FOneItem
	public FResultCount
	public FTotalCount

	public FRectUserID
	public FRectOrderSerial

	public Sub GetMyinfoCount()
	    dim sqlStr , i

	    if FRectUserID<>"" then
	        sqlStr = " exec [db_my10x10].[dbo].[sp_Ten_My10x10_countInfo] '" & FRectUserID & "'"
        else
            sqlStr = " exec [db_my10x10].[dbo].[sp_Ten_My10x10_countInfo_guest] '" & FRectOrderserial & "'"
        end If
        
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		rsget.Open sqlStr,dbget,1

		FTotalcount = rsget.Recordcount
		FResultcount = FTotalcount

        redim preserve FItemList(FTotalcount)
		i=0
        if Not rsget.Eof then
			do until rsget.Eof
				set FItemList(i) = new CMyMainItem
				FItemList(i).Fgubun         = rsget("gubun")
				FItemList(i).Fcount			= rsget("TotalCnt")
				i = i + 1
				rsget.movenext
			loop
		end if
		rsget.close
    end Sub

	public Sub GetMyDeliveryTop1()
	    dim sqlStr , i

		sqlStr = "select top 1 m.orderserial, m.regdate,m.ipkumdiv, m.ipkumdate "
		sqlStr = sqlStr & " ,(select count(d.idx) from [db_order].[dbo].tbl_order_detail d where m.orderserial=d.orderserial and d.itemid<>0 and d.itemid <> 100 and d.cancelyn<>'Y') as itemcount"
		sqlStr = sqlStr & " ,(select max(d.itemname) from [db_order].[dbo].tbl_order_detail d where m.orderserial=d.orderserial and d.itemid<>0 and d.itemid <> 100 and d.cancelyn<>'Y') as itemnames"
		sqlStr = sqlStr & " ,(select max(d.beasongdate) from [db_order].[dbo].tbl_order_detail d where m.orderserial=d.orderserial and d.itemid<>0 and d.itemid <> 100 and d.cancelyn<>'Y' and datediff(day,d.beasongdate,getdate()) < 3 ) as beasongdate"
		sqlStr = sqlStr & " from [db_order].[dbo].tbl_order_master m"
		if FRectUserID<>"" then
		    sqlStr = sqlStr & " where m.userid='"& FRectUserID &"'"
		else
		    sqlStr = sqlStr & " where m.orderserial='"& FRectOrderserial &"'"
	    end If

		sqlStr = sqlStr & " and m.sitename='10x10' and m.ipkumdiv >= 7 and m.cancelyn='N'  "
		sqlStr = sqlStr & " and (m.userDisplayYn is null or m.userDisplayYn='Y') "
		sqlStr = sqlStr & "	and (select max(d.beasongdate) from [db_order].[dbo].tbl_order_detail d where m.orderserial=d.orderserial and d.itemid<>0 and d.itemid <> 100 and d.cancelyn<>'Y' and datediff(day,d.beasongdate,getdate()) < 3 ) is not null "
		sqlStr = sqlStr & " order by m.idx desc "

		rsget.Open sqlStr,dbget,1

		set FOneItem = new CMyMainItem

		if Not Rsget.Eof Then
			FOneItem.FOrderSerial		= rsget("orderserial")
			FOneItem.FOrderItemNames	= db2html(rsget("itemnames")) 
			FOneItem.FOrderitemCount	= rsget("itemcount")
		end If
		
		rsget.Close

    end Sub


	Public Sub My10x10MywishTop10()
		dim sqlStr , i

		sqlStr = ""
		sqlStr = sqlStr & " SELECT top 12 A.itemid , B.basicimage , B.sellCash , B.orgPrice , B.sailyn , B.itemcouponYn , B.itemcouponvalue , B.itemcoupontype , B.itemname "
		sqlStr = sqlStr & " FROM db_my10x10.dbo.tbl_myfavorite A with(readuncommitted)"
		sqlStr = sqlStr & "	inner join db_item.dbo.tbl_item B with(readuncommitted)"
		sqlStr = sqlStr & " ON A.itemid = B.itemid "
		sqlStr = sqlStr & " WHERE A.userid='"& FRectUserID &"'  "		
		sqlStr = sqlStr & "	And A.userid is not null "
		sqlStr = sqlStr & " ORDER BY A.regdate DESC "

'		Response.write sqlStr

		rsget.Open sqlStr,dbget,1

		FTotalcount = rsget.Recordcount
		FResultcount = FTotalcount

        redim preserve FItemList(FTotalcount)
		i=0
        if Not rsget.Eof then
			do until rsget.Eof
				set FItemList(i) = new CMyMainItem
				FItemList(i).Fitemid         = rsget("itemid")
				FItemList(i).Fbasicimage     = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
				FItemList(i).Fsellcash       = rsget("sellCash")
				FItemList(i).Forgprice       = rsget("orgPrice")
				FItemList(i).Fsailyn         = rsget("sailyn")
				FItemList(i).FitemcouponYN   = rsget("itemcouponYn")
				FItemList(i).Fitemcouponvalue= rsget("itemcouponvalue")
				FItemList(i).Fitemcoupontype = rsget("itemcoupontype")
				FItemList(i).Fitemname		 = rsget("itemname")

				i = i + 1
				rsget.movenext
			loop
		end if
		rsget.close

	End Sub
end Class
%>
