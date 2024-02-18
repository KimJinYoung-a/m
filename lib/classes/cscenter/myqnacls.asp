<%
'###########################################################
' Description : 1:1 상담 클래스
' History : 2015.05.27 이상구 생성
'###########################################################
%>
<%
'id, userid, username, orderserial, qadiv, title, usermail, emailok, contents, regdate, replyuser, replytitle, replycontents, replydate, isusing
Class CMyQNAItem
	public Fid
	public Fuserid
	public Fusername
	public Forderserial
	public Fqadiv
	public Ftitle
	public Fusermail
	public Femailok
	public Fcontents
	public Fregdate
	public Freplyuser
	public Freplytitle
	public Freplycontents
	public Freplydate
	public Fisusing
	public Fextsitename
	public Fuserphone
    public FUserLevel
    public Fmd5Key
    public FEvalPoint
	Public FitemID
	Public Fcomm_cd
	Public Fcomm_name
	Public Fcomm_group
	Public Fcomm_isDel
	Public Fcomm_color
	Public Fsortno
	Public Fdispyn
	public fqadivname
	public FOS
	public FOSetc

    public function IsReplyOk()
        IsReplyOk = Not IsNULL(Freplydate)
    end function
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class CMyQNA
    public FItemList()
    public FOneItem
	public FResultCount
	public FPageSize
	public FCurrpage
	public FTotalCount
	public FTotalPage
	public FScrollCount

	public FRectUserID
	public FRectOrderSerial
	public FRectReplyYN
	public FRectExtSitename
    public FIDBefore
	public FIDAfter
	public frectcomm_isdel
	public frectdispyn

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

	'//1:1 상담 내역 보여주기
    public Sub GetMyQnaList()
		Dim i, strSql, objRs
		Dim paramInfo

		if (FRectUserID<>"") then
		    paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
    			,Array("@PageSize"		, adInteger	, adParamInput	,		, FPageSize)	_
    			,Array("@CurrPage"		, adInteger	, adParamInput	,		, FCurrPage) _
    			,Array("@userID"		, adVarchar	, adParamInput	, 32	, FRectUserID) _
    		)

    		strSql = "db_cs.dbo.sp_Ten_MyQnaListByUserID"
		elseif (FRectOrderSerial<>"") then
    		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
    			,Array("@PageSize"		, adInteger	, adParamInput	,		, FPageSize)	_
    			,Array("@CurrPage"		, adInteger	, adParamInput	,		, FCurrPage) _
    			,Array("@orderSerial"	, adVarchar	, adParamInput	, 11	, FRectOrderSerial) _
    		)

    		strSql = "db_cs.dbo.sp_Ten_MyQnaListByOrderserial"
        else
            FTotalCount = 0
            FResultCount= 0
            exit sub
    	end if

		Call fnExecSPReturnRSOutput(strSql, paramInfo)

		FTotalCount = CDbl(GetValue(paramInfo, "@RETURN_VALUE"))	' 토탈카운트
		FtotalPage  = Int ( (FTotalCount - 1) / FPageSize ) + 1
		If FTotalCount = 0 Then	FtotalPage = 1

		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				redim preserve FItemList(i)
				set FItemList(i) = new CMyQNAItem

				FItemList(i).Fid             = rsget("id")
                FItemList(i).Fuserid         = rsget("userid")
                FItemList(i).Fusername       = db2html(rsget("username"))
                FItemList(i).Forderserial    = rsget("orderserial")
                FItemList(i).Fqadiv          = rsget("qadiv")
                FItemList(i).Ftitle          = db2html(rsget("title"))
                FItemList(i).Fusermail       = db2html(rsget("usermail"))
                FItemList(i).Femailok        = rsget("emailok")
                FItemList(i).Fcontents       = db2html(rsget("contents"))
                FItemList(i).Fregdate        = rsget("regdate")
                FItemList(i).Freplyuser      = rsget("replyuser")
                FItemList(i).Freplytitle     = db2html(rsget("replytitle"))
                FItemList(i).Freplycontents  = db2html(rsget("replycontents"))
                FItemList(i).Freplydate      = rsget("replydate")
                FItemList(i).Fisusing        = rsget("isusing")
                FItemList(i).Fextsitename    = rsget("extsitename")
                FItemList(i).FUserLevel      = rsget("userlevel")
				FItemList(i).Fmd5Key			= rsget("MD5KEY")
				FItemList(i).FEvalPoint			= rsget("EvalPoint")
				FItemList(i).fqadivname		 = db2html(rsget("qadivname"))

				i=i+1
				rsget.moveNext
			loop
		end if
		FResultCount = i
		rsget.Close
	end Sub

	' 등록, 삭제, 점수주기
    Public Function FrontProcData(ByVal mode)
		Dim ErrCode, ErrMsg

		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@mode"			, adVarchar	, adParamInput	, 10	, mode)	_
			,Array("@userid"		, adVarchar	, adParamInput	, 32	, FoneItem.Fuserid) _
			,Array("@userlevel"		, adInteger	, adParamInput	, 4		, FoneItem.Fuserlevel) _
			,Array("@username"		, adVarWChar, adParamInput	, 32	, FoneItem.Fusername) _
			,Array("@id"			, adInteger	, adParamInput	, 4		, FoneItem.Fid) _
			,Array("@qadiv"			, adChar	, adParamInput	, 2		, FoneItem.Fqadiv) _
			,Array("@title"			, adVarWChar, adParamInput	, 128	, FoneItem.Ftitle) _
			,Array("@contents"		, adVarWChar, adParamInput	, 8000	, FoneItem.Fcontents) _
			,Array("@usermail"		, adVarchar	, adParamInput	, 128	, FoneItem.Fusermail) _
			,Array("@emailok"		, adChar	, adParamInput	, 1		, FoneItem.Femailok) _
			,Array("@itemid"		, adInteger	, adParamInput	, 4		, FoneItem.Fitemid) _
			,Array("@orderserial"	, adVarchar	, adParamInput	, 32	, FoneItem.Forderserial) _
			,Array("@MD5KEY"		, adVarchar	, adParamInput	, 32	, FoneItem.FMD5KEY) _
			,Array("@EvalPoint"		, adTinyint	, adParamInput	, 1		, FoneItem.FEvalPoint) _
			,Array("@extsitename"	, adVarchar	, adParamInput	, 32	, FoneItem.Fextsitename) _
			,Array("@userphone"		, adVarchar	, adParamInput	, 32	, FoneItem.Fuserphone) _
			,Array("@orderDetailIDX", adInteger	, adParamInput	, 4		, 0) _
			,Array("@device", adChar	, adParamInput	, 1		, "M") _
			,Array("@OS"		, adVarWChar	, adParamInput	, 16		, FoneItem.FOS) _
			,Array("@OSetc", adVarWChar	, adParamInput	, 30	, FoneItem.FOSetc) _
		)

		strSql = "db_cs.dbo.sp_Ten_MyQnaProc_New"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드
		FrontProcData = ErrCode
	End Function

	'//my10x10/qna/myqnawrite.asp		'/2016.03.25 한용민 생성
	Public Sub getqadiv_list()
		Dim sqlStr, i, addsql

		if frectcomm_isdel<>"" then
			addsql = addsql & " and c.comm_isdel='"& frectcomm_isdel &"'" & vbCrLf
		end if
		if frectdispyn<>"" then
			addsql = addsql & " and c.dispyn='"& frectdispyn &"'" & vbCrLf
		end if

		sqlStr = "SELECT TOP " & CStr(FPageSize*FCurrPage) & vbCrLf
		sqlStr = sqlStr & " c.comm_cd, c.comm_name, c.comm_group, c.comm_isDel, c.comm_color, c.sortno, c.dispyn" & vbCrLf
		sqlStr = sqlStr & " from [db_cs].[dbo].[tbl_cs_comm_code] c" & vbCrLf
		sqlStr = sqlStr & " where left(comm_group,3)='D00' " & addsql
		sqlStr = sqlStr & " order by comm_group asc, sortno asc"

		'response.write sqlStr & "<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount
		FTotalCount = FResultCount
		Redim preserve FItemList(FResultCount)
		i = 0
		If not rsget.EOF Then
			rsget.absolutepage = FCurrPage
			Do until rsget.EOF
				Set FItemList(i) = new CMyQNAItem

					FItemList(i).fcomm_cd = rsget("comm_cd")
					FItemList(i).fcomm_name = db2html(rsget("comm_name"))
					FItemList(i).fcomm_group = rsget("comm_group")
					FItemList(i).fcomm_isDel = rsget("comm_isDel")
					FItemList(i).fcomm_color = rsget("comm_color")
					FItemList(i).fsortno = rsget("sortno")
					FItemList(i).fdispyn = rsget("dispyn")

				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.Close
	End Sub

	'/사용안함(DB화 시킴) 용만
	Public Function code2name(byval v)
        if (v = "00") then
                code2name = "배송문의"
        elseif (v = "01") then
                code2name = "주문문의"
        elseif (v = "02") then
                code2name = "상품문의"
        elseif (v = "03") then
                code2name = "재고문의"
        elseif (v = "04") then
                code2name = "취소문의"
        elseif (v = "05") then
                code2name = "환불문의"
        elseif (v = "06") then
                code2name = "교환문의"
        elseif (v = "07") then
                code2name = "AS문의"
        elseif (v = "08") then
                code2name = "이벤트문의"
        elseif (v = "09") then
                code2name = "증빙서류문의"
        elseif (v = "10") then
                code2name = "시스템문의"
        elseif (v = "11") then
                code2name = "회원제도문의"
        elseif (v = "12") then
                code2name = "회원정보문의"
        elseif (v = "13") then
                code2name = "당첨문의"
        elseif (v = "14") then
                code2name = "반품문의"
        elseif (v = "15") then
                code2name = "결제문의"
        elseif (v = "16") then
                code2name = "오프라인문의"
        elseif (v = "17") then
                code2name = "쿠폰마일리지문의"
        elseif (v = "18") then
                code2name = "결제방법문의"
        elseif (v = "20") then
                code2name = "기타문의"
        elseif (v = "21") then
                code2name = "아이띵소문의"
        elseif (v = "22") then
                code2name = "이벤트문의"
        elseif (v = "23") then
                code2name = "사은품문의"
        else
                code2name = ""
        end if
	end Function

end Class
%>
