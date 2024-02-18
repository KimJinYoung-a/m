<%
Class cthanks10x10_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public fidx
	public fuserid
	public ftitle
	public fimage
	public fimage_path
	public fcontents
	public fisusing
	public fevt_code
	public freg_date
	public fcomment
	public fisusing_del
	public fgubun
	public fisusing_display
	public fconfirm_regdate
	
end class

class cthanks10x10_list
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FsearchFlag
	
	public frectevent_limit
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub
	
	'// 컬쳐스테이션 고마워텐바이텐 페이지 리스트 /culturestation/culturestation_thanks10x10.asp
	public sub fthanks10x10_list()
		dim sqlStr, addSql, i
		if FsearchFlag="my" then
			addSql = " and a.userid='" & GetLoginUserID & "'"
		Else
			addSql = " and a.userid<>'" & GetLoginUserID & "'"
		end if

		'총 갯수 구하기
		sqlStr = "select count(a.idx) as cnt" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10 a" + vbcrlf
		sqlStr = sqlStr & " left join db_culture_station.dbo.tbl_thanks_10x10_comment b"
		sqlStr = sqlStr & " on a.idx = b.idx"	
		sqlStr = sqlStr & " where a.isusing_del = 'N' and a.isusing_display = 'Y'" + addSql + vbcrlf

		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
		
		'데이터 리스트
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & " a.isusing_del ,a.idx ,a.userid, a.contents, a.isusing_display, a.reg_date" + vbcrlf
		sqlStr = sqlStr & " , isnull(b.comment,'') as comment , a.gubun , b.confirm_regdate" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10 a" + vbcrlf
		sqlStr = sqlStr & " left join db_culture_station.dbo.tbl_thanks_10x10_comment b"
		sqlStr = sqlStr & " on a.idx = b.idx"
		sqlStr = sqlStr & " where a.isusing_del = 'N' and a.isusing_display = 'Y'" + addSql + vbcrlf
		sqlStr = sqlStr & " order by a.idx Desc" + vbcrlf

		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new cthanks10x10_oneitem
	
				FItemList(i).fidx = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).fisusing_display = rsget("isusing_display")
				FItemList(i).fisusing_del = rsget("isusing_del")
				FItemList(i).freg_date = rsget("reg_date")
				FItemList(i).fcomment = db2html(rsget("comment"))
				FItemList(i).fgubun = rsget("gubun")				
				FItemList(i).fconfirm_regdate = rsget("confirm_regdate")													
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end Sub

	public sub fthanks10x10_mylist()
		dim sqlStr, addSql, i
		if FsearchFlag="my" then
			addSql = " and a.userid='" & GetLoginUserID & "'"
		end if

		'데이터 리스트
		sqlStr = "select a.isusing_del ,a.idx ,a.userid, a.contents, a.isusing_display, a.reg_date" + vbcrlf
		sqlStr = sqlStr & " , isnull(b.comment,'') as comment , a.gubun , b.confirm_regdate" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10 a" + vbcrlf
		sqlStr = sqlStr & " left join db_culture_station.dbo.tbl_thanks_10x10_comment b"
		sqlStr = sqlStr & " on a.idx = b.idx"
		sqlStr = sqlStr & " where a.isusing_del = 'N'" + addSql + vbcrlf
		sqlStr = sqlStr & " order by a.idx Desc" + vbcrlf

		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.recordcount
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.EOF
				set FItemList(i) = new cthanks10x10_oneitem
				FItemList(i).fidx = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).fisusing_display = rsget("isusing_display")
				FItemList(i).fisusing_del = rsget("isusing_del")
				FItemList(i).freg_date = rsget("reg_date")
				FItemList(i).fcomment = db2html(rsget("comment"))
				FItemList(i).fgubun = rsget("gubun")				
				FItemList(i).fconfirm_regdate = rsget("confirm_regdate")													
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	''''////메인페이지 고마워텐바이텐 배너2개	/culturestation/culturestation.asp
	public sub fthanks10x10_banner()		
		dim sqlStr,i		

		sqlStr = "select"
			if frectevent_limit <> "" then
			sqlStr = sqlStr & " top "& frectevent_limit &"" + vbcrlf			
			end if			
		sqlStr = sqlStr & " idx, userid, contents, reg_date , gubun" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10" + vbcrlf
		sqlStr = sqlStr & " where isusing_display='Y' and isusing_del = 'N'" + vbcrlf
		sqlStr = sqlStr & " order by idx Desc" + vbcrlf

		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		ftotalcount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			do until rsget.EOF
				set FItemList(i) = new cthanks10x10_oneitem
	
				FItemList(i).fidx = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).freg_date = rsget("reg_date")
				FItemList(i).fgubun = rsget("gubun")				
												
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub
		

	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function

end class
%>