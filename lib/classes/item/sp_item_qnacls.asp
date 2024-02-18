<%

class CItemQnaSubItem

	public FID
	public FUserid
	public Fmakerid
	public Fcdl
	public Fusername
	public FTitle
	public FContents
	public FReplytitle
	public FReplycontents
	public FReplyuser
	public Fregdate
	public FBrandName
	public Freplydate

	public FItemID
	public Flistimage
	public FItemName
	public FSellcash

	public FUserLevel

	public Femailok
	public Fusermail
	public Fsmsok
	public Fuserhp

	'비밀 qna 추가 2017-05-04 이종화
	public Fsecretyn

	Private Sub Class_Terminate()

	End Sub

	public sub Class_Initialize()

	end sub

	public function IsReplyOk()
		if IsNULL(Freplydate) then
			IsReplyOk = false
		else
			IsReplyOk = true
		end if
	end function

	public function ReplyYN()
		if IsNULL(Freplydate) then
			ReplyYN = "단변대기"
		else
			ReplyYN = "답변완료"
		end if
	end function

	public function ReplyYNImage()
		if IsNULL(Freplydate) then
			ReplyYNImage = "/images/no.gif"
		else
			ReplyYNImage = "/images/yes.gif"
		end if
	end function


	public function ReplyColor()
		if IsNULL(Freplydate) then
			ReplyColor = "#0066FF"
		else
			ReplyColor = "#C80708"
		end if
	end function



end Class

Class CItemQna
	public FItemList()
	public FResultCount
	public FPageSize
	public FCurrpage
	public FTotalCount
	public FTotalPage
	public FScrollCount
    
    public FReplyCount
    
	public FRectItemID
	public FRectCDL
    public FRectUserID

    public FRectMakerID
    
	public FRectId
	public FOneItem
    public FRectReplyYN
    
	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FResultCount  = 0
		FTotalCount = 0
		FPageSize = 12
		FCurrpage = 1
		FScrollCount = 10
	End Sub

	Private Sub Class_Terminate()

	End Sub
    
    public sub GetMyItemQnaList()
        dim sqlStr,i
        sqlStr = "select count(id) as cnt, sum(Case when replydate is Not NULL then 1 else 0 end ) as replyCount from [db_cs].[dbo].tbl_my_item_qna"
        sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and isusing ='Y'"
        if FRectReplyYN="Y" then
            sqlStr = sqlStr + " and replydate is Not NULL"
        elseif FRectReplyYN="N" then
            sqlStr = sqlStr + " and replydate is NULL"
        end if
        if FRectId<>"" then	sqlStr = sqlStr + " and id=" & FRectId

        rsget.Open sqlStr, dbget, 1
		    FTotalCount = rsget("cnt") 
		    FReplyCount = rsget("replyCount") 
		rsget.Close
        
        sqlStr = "select top " + CStr(FPageSize*FCurrPage) 
        sqlStr = sqlStr + " q.*, IsNull(q.smsok, '') as smsok, IsNull(q.userhp, '') as userhp, i.itemname, (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid, i.sellcash, i.brandname, i.listimage"
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_my_item_qna q"
        sqlStr = sqlStr + " join [db_item].[dbo].tbl_item i "
        sqlStr = sqlStr + "  on q.itemid=i.itemid"
        sqlStr = sqlStr + " where q.userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and q.isusing ='Y'"
        
        if FRectReplyYN="Y" then
            sqlStr = sqlStr + " and replydate is Not NULL"
        elseif FRectReplyYN="N" then
            sqlStr = sqlStr + " and replydate is NULL"
        end if
        if FRectId<>"" then	sqlStr = sqlStr + " and id=" & FRectId
        sqlStr = sqlStr + " order by q.id desc"
        
        rsget.pagesize = FPageSize
        
        rsget.Open sqlStr, dbget, 1
		 FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CItemQnaSubItem

				FItemList(i).FID = rsget("id")
				FItemList(i).FItemID = rsget("itemid")
				FItemList(i).FUserid = rsget("userid")
				FItemList(i).Fmakerid = rsget("makerid")
				FItemList(i).FCdl = rsget("cdl")
				FItemList(i).Fusername = db2html(rsget("username"))
				FItemList(i).FContents = db2html(rsget("contents"))
				FItemList(i).FTitle = chrbyte(FItemList(i).FContents,80,"Y")

				FItemList(i).FReplyuser = rsget("replyuser")

				FItemList(i).FReplycontents = db2html(rsget("replycontents"))
				FItemList(i).FReplytitle = chrbyte(FItemList(i).FReplycontents,40,"Y")

				FItemList(i).Fregdate = rsget("regdate")
				FItemList(i).FBrandName = db2html(rsget("brandname"))
				FItemList(i).FReplydate = rsget("replydate")
				
				FItemList(i).Fitemname = db2html(rsget("itemname"))
				FItemList(i).Fmakerid  = rsget("makerid")
				FItemList(i).Fsellcash = rsget("sellcash")
				FItemList(i).Fbrandname= db2html(rsget("brandname"))
				FItemList(i).Flistimage= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsget("listimage")

				FItemList(i).Femailok 		= db2html(rsget("emailok"))
				FItemList(i).Fusermail 		= db2html(rsget("usermail"))
				FItemList(i).Fsmsok 		= db2html(rsget("smsok"))
				FItemList(i).Fuserhp 		= db2html(rsget("userhp"))

				FItemList(i).Fsecretyn 		= db2html(rsget("secretYN"))

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
        
    End Sub
        
	public sub ItemQnaList()
		dim sqlStr,i

		sqlStr = "exec [db_cs].[dbo].sp_Ten_ItemQna_TCnt @vItemid=" + CStr(FRectItemID) + ""  + vbcrlf

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget
		IF not rsget.eof then
			FTotalCount = rsget("cnt")
		
		End if
		rsget.Close
		
		IF FTotalCount <=0 then
		
			Exit Sub
		End if

		sqlStr = "exec [db_cs].[dbo].[sp_Ten_ItemQna] @vCnt='" +  CStr(FPageSize*FCurrPage) + "',@vItemid=" + Cstr(FRectItemID) + "" + vbcrlf

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CItemQnaSubItem

				FItemList(i).FID = rsget("id")
				FItemList(i).FItemID = rsget("itemid")
				FItemList(i).FUserid = rsget("userid")
				FItemList(i).Fmakerid = rsget("makerid")
				FItemList(i).FCdl = rsget("cdl")
				FItemList(i).Fusername = db2html(rsget("username"))
				FItemList(i).FContents = db2html(rsget("contents"))
				FItemList(i).FTitle = chrbyte(FItemList(i).FContents,80,"Y")

				FItemList(i).FReplyuser = rsget("replyuser")

				FItemList(i).FReplycontents = db2html(rsget("replycontents"))
				FItemList(i).FReplytitle = chrbyte(FItemList(i).FReplycontents,40,"Y")

				FItemList(i).Fregdate = rsget("regdate")
				FItemList(i).FBrandName = db2html(rsget("brandname"))
				FItemList(i).FReplydate = rsget("replydate")

				'비밀글 여부 2017-05-04 이종화 추가
				FItemList(i).Fsecretyn = rsget("secretyn")
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub


	'// 브랜드별 상품문의 목록
	public Sub GetBrandItemQna()
		dim sql,i

		sql = "select count(*) as cnt from [db_cs].[dbo].tbl_my_item_qna" + vbcrlf
		sql = sql + " where makerid = '" + Cstr(FRectMakerID) + "'" + vbcrlf
		sql = sql + " and isusing ='Y'" + vbcrlf
		sql = sql + " and replydate is not null" + vbcrlf

		rsget.Open sql, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.Close

		''최근 10건만 보여줌
		if FTotalCount>10 then FTotalCount=10

		sql = "select top " + CStr(FPageSize*FCurrpage) + " q.id,q.userid,q.itemid,q.makerid,q.username,q.cdl,q.contents,"
		sql = sql + " q.replyuser,q.replycontents,q.regdate, q.brandname, q.replydate, i.listimage "
		sql = sql + " from [db_cs].[dbo].tbl_my_item_qna q" + vbcrlf
		sql = sql + " join [db_item].[dbo].tbl_item i on q.itemid=i.itemid"
		sql = sql + " where q.makerid = '" + Cstr(FRectMakerID) + "'" + vbcrlf
		sql = sql + " and q.isusing ='Y'" + vbcrlf
		sql = sql + " and q.replydate is not null" + vbcrlf
		sql = sql + " order by q.id desc"

		rsget.pagesize = FPageSize
		rsget.Open sql, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CItemQnaSubItem

				FItemList(i).FID = rsget("id")
				FItemList(i).FItemID = rsget("itemid")
				FItemList(i).FUserid = rsget("userid")
				FItemList(i).Fmakerid = rsget("makerid")
				FItemList(i).FCdl = rsget("cdl")
				FItemList(i).Fusername = db2html(rsget("username"))
				FItemList(i).FContents = db2html(rsget("contents"))
				FItemList(i).FTitle = chrbyte(FItemList(i).FContents,80,"Y")

				FItemList(i).FReplyuser = rsget("replyuser")

				FItemList(i).FReplycontents = db2html(rsget("replycontents"))
				FItemList(i).FReplytitle = chrbyte(FItemList(i).FReplycontents,40,"Y")

				FItemList(i).Fregdate = rsget("regdate")
				FItemList(i).FBrandName = db2html(rsget("brandname"))
				FItemList(i).FReplydate = rsget("replydate")

				FItemList(i).Flistimage = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsget("listimage")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end Sub


	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
End Class

%>
