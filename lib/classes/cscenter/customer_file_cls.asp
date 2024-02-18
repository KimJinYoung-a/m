<%
'###########################################################
' Description : 고객파일전송관리 클래스
' History : 2019.11.25 한용민 생성
'###########################################################

Class ccsfileitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public fauthidx
	public fuserhp
	public fuserid
	public forderserial
	public fcomment
	public ffileurl1
	public ffileurl2
	public ffileurl3
	public ffileurl4
	public ffileurl5
	public fsmsyn
	public fkakaotalkyn
	public fcertno
	public fisusing
	public fregdate
    public fstatus
end class

class ccsfilelist
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FOneItem

    public frectauthidx
    public frectuserhp
    public frectuserid
    public frectorderserial

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

    ' /cscenter/action/pop_cs_file_send.asp
	public sub getcsfile_one()
		dim sqlStr,i , sqlsearch
		
		if frectauthidx <> "" then
			sqlsearch = sqlsearch & " and authidx ="& frectauthidx &""
		end if

		'데이터 리스트 
		sqlStr = "select top 1" & vbcrlf 
		sqlStr = sqlStr & " authidx,userhp,userid,orderserial,comment,fileurl1,fileurl2,fileurl3,fileurl4" & vbcrlf 
		sqlStr = sqlStr & " ,fileurl5,smsyn,kakaotalkyn,certno,status,isusing,regdate" & vbcrlf 
		sqlStr = sqlStr & " from db_cs.dbo.tbl_customer_filelist with (readuncommitted)" & vbcrlf 
		sqlStr = sqlStr & " where isusing='Y' " & sqlsearch

		'response.write sqlStr &"<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount

		i=0
		if  not rsget.EOF  then

			do until rsget.EOF
				set FOneItem = new ccsfileitem

					FOneItem.fauthidx = rsget("authidx")
					FOneItem.fuserhp = rsget("userhp")
					FOneItem.fuserid = rsget("userid")
					FOneItem.forderserial = rsget("orderserial")
					FOneItem.fcomment = db2html(rsget("comment"))
					FOneItem.ffileurl1 = rsget("fileurl1")
					FOneItem.ffileurl2 = rsget("fileurl2")
					FOneItem.ffileurl3 = rsget("fileurl3")
					FOneItem.ffileurl4 = rsget("fileurl4")
					FOneItem.ffileurl5 = rsget("fileurl5")
					FOneItem.fsmsyn = rsget("smsyn")
					FOneItem.fkakaotalkyn = rsget("kakaotalkyn")
					FOneItem.fcertno = rsget("certno")
                    FOneItem.fstatus = rsget("status")
					FOneItem.fisusing = rsget("isusing")
					FOneItem.fregdate = rsget("regdate")

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

function getstatusname(vstatus)
	dim tmpstatus

	if vstatus="0" then
		tmpstatus="입력대기"
	elseif vstatus="1" then
		tmpstatus="입력완료"
	else
		tmpstatus=""
	end if

	getstatusname=tmpstatus
end function

%>