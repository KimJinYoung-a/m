<%
'###########################################################
'	History	:  2020.07.03 한용민 생성
'	Description : 개인정보 클래스
'###########################################################

class CprivateItem
    public fcompany_name

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class Cprivate
	public FItemList()
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FPCount

	public Sub Getprivate_partner_companyList()
		dim sql, i

		sql = "select count(t.company_name) as cnt "
        sql = sql & " from (" & vbcrlf
        sql = sql & "   select g.company_name" & vbcrlf
        sql = sql & "   from db_partner.dbo.tbl_partner_group g with (readuncommitted)" & vbcrlf
        sql = sql & "   join db_partner.dbo.tbl_partner p with (readuncommitted)" & vbcrlf
        sql = sql & "   	on g.groupid=p.groupid" & vbcrlf
        sql = sql & "   	and p.isusing='Y'" & vbcrlf
        sql = sql & "   	and isnull(p.U_margin,0)>0" & vbcrlf
        sql = sql & "   join db_user.dbo.tbl_user_c c with (readuncommitted)" & vbcrlf
        sql = sql & "   	on p.id = c.userid" & vbcrlf
        sql = sql & "   	and c.userdiv='02'" & vbcrlf
        sql = sql & "   	and c.isusing='Y'" & vbcrlf
        sql = sql & "   	and c.streetusing='Y'" & vbcrlf
        sql = sql & "   where g.company_no not in ('211-87-00620')" & vbcrlf      ' 텐바이텐 제외
        sql = sql & "   group by g.company_name" & vbcrlf
        sql = sql & " ) as t" & vbcrlf

        'response.write FTotalCount & "<Br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sql, dbget, adOpenForwardOnly, adLockReadOnly
		    FTotalCount = rsget("cnt")
		rsget.close

        if FTotalCount<1 then exit Sub

        sql = "select top " + CStr(FPageSize * FCurrPage) + " g.company_name" & vbcrlf
        sql = sql & " from db_partner.dbo.tbl_partner_group g with (readuncommitted)" & vbcrlf
        sql = sql & " join db_partner.dbo.tbl_partner p with (readuncommitted)" & vbcrlf
        sql = sql & " 	on g.groupid=p.groupid" & vbcrlf
        sql = sql & " 	and p.isusing='Y'" & vbcrlf
        sql = sql & " 	and isnull(p.U_margin,0)>0" & vbcrlf
        sql = sql & " join db_user.dbo.tbl_user_c c with (readuncommitted)" & vbcrlf
        sql = sql & " 	on p.id = c.userid" & vbcrlf
        sql = sql & " 	and c.userdiv='02'" & vbcrlf
        sql = sql & " 	and c.isusing='Y'" & vbcrlf
        sql = sql & " 	and c.streetusing='Y'" & vbcrlf
        sql = sql & " where g.company_no not in ('211-87-00620')" & vbcrlf      ' 텐바이텐 제외
        sql = sql & " group by g.company_name" & vbcrlf
        sql = sql & " order by g.company_name asc" & vbcrlf

        'response.write FTotalCount & "<Br>"
		rsget.pagesize = FPageSize
		rsget.CursorLocation = adUseClient
		rsget.Open sql, dbget, adOpenForwardOnly, adLockReadOnly

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		if (FResultCount<1) then FResultCount=0

		FPCount = FCurrPage - 1
		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CprivateItem

				FItemList(i).fcompany_name           = db2html(rsget("company_name"))

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end sub

	Private Sub Class_Initialize()
		redim preserve FItemList(0)

		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0
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