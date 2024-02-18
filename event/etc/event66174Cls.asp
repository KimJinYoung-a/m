<%
'####################################################
' Description :  러브하우스
' History : 2015.09.17 유태욱
'####################################################
Dim userid, g_Contest
userid = GetEncLoginUserID()

function getnowdate()
	dim nowdate

	nowdate = date()
	'nowdate = "2015-04-21"

	getnowdate = nowdate
end function

IF application("Svr_Info") = "Dev" THEN
	g_Contest = "con56"
Else
	g_Contest = "con62"
End If

dim sqlStr, usercnt

sqlStr = " select count(*) as cnt" + vbcrlf
sqlStr = sqlStr + " from [db_event].[dbo].[tbl_contest_entry]" + VbCrlf
sqlStr = sqlStr + " where userid='"& userid &"'"
sqlStr = sqlStr + " and div='"& g_Contest &"'"

'response.write sqlStr &"<br>"
rsget.Open sqlStr,dbget,1
	usercnt = rsget("cnt")
rsget.Close

Class Cevent66174_item
	public Fidx
	public fdiv
	public fuserid
	public FimgFile1
	public FimgFile2
	public FimgFile3
	public FimgFile4
	public FimgFile5
	public Fopt
	public FoptText
	public Fimgcontent
	public Fregdate

end class

class Cevent66174_list
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FRectUserid
	public FRectEventID

	Public Function fnEvent_66174_List
		Dim sqlStr, i, vOrderBy
		
		sqlStr = "SELECT COUNT(A.idx), CEILING(CAST(Count(A.idx) AS FLOAT)/3) FROM [db_event].[dbo].[tbl_contest_entry] AS A" + vbcrlf
		sqlStr = sqlStr + " where userid<>'dd'"
		sqlStr = sqlStr + " and div='"& g_Contest &"'"

		'response.write sqlStr &"<br>"
		rsget.open sqlStr, dbget, 1
		If Not rsget.Eof Then
			FTotalCount = rsget(0)
			FTotalPage = rsget(1)
		End If
		rsget.close

		'// 본문 접수
		sqlStr = "SELECT Top " & Cstr(FPageSize * FCurrPage)
		sqlStr = sqlStr + " idx, div, userid, imgfile1, imgfile2, imgfile3, imgfile4, imgfile5, opt, optText, imgContent, regdate" + VbCrlf
		sqlStr = sqlStr + " from [db_event].[dbo].[tbl_contest_entry]" + VbCrlf
		sqlStr = sqlStr + " where userid<>'dd'" + VbCrlf
		sqlStr = sqlStr + " and div='"& g_Contest &"'"
		sqlStr = sqlStr + " order by idx desc"

'		response.write sqlStr
		rsget.pagesize = FPageSize
		rsget.open sqlStr, dbget, 1

		If (FCurrPage * FPageSize < FTotalCount) Then
			FResultCount = FPageSize
		Else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		End If

		Redim preserve FItemList(FResultCount)
		FPageCount = FCurrPage - 1

	
		i = 0
		If not rsget.EOF Then
			rsget.absolutepage = FCurrPage
			Do until rsget.EOF
				Set FItemList(i) = new Cevent66174_item
				FItemList(i).Fidx 			= rsget("idx")
				FItemList(i).fdiv 			= rsget("div")
				FItemList(i).fuserid 		= rsget("userid")
				FItemList(i).FimgFile1 		= rsget("imgfile1")
				FItemList(i).FimgFile2 		= rsget("imgfile2")
				FItemList(i).FimgFile3 		= rsget("imgfile3")
				FItemList(i).FimgFile4 		= rsget("imgfile4")
				FItemList(i).FimgFile5 		= rsget("imgfile5")
				FItemList(i).Fopt 			= rsget("opt")
				FItemList(i).FoptText 		= rsget("optText")
				FItemList(i).Fimgcontent	= rsget("imgcontent")
				FItemList(i).Fregdate 		= rsget("regdate")
				rsget.movenext
				i = i + 1
			Loop
		End if
		rsget.close
	End Function
end Class
%>