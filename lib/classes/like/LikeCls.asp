<%
Class LikeCls

    public totalResult

'master 데이터
    public likeId
    public contentsId
    public contentsKind
    public contents_name    
    public maxLike

'log데이터    
    public contentsSubId
    public userid
    public likeCnt
    public refip

'좋아요 로그 삽입
    public sub execPlusLike()
        if chkValidation() then
            totalResult = false
            exit sub
        end if
        '데이터 초기화
        getLikeMasterData()
        '맥스 좋아요 체크
        setLikeCnt()
        '로그 삽입
        insertLog()
        totalResult = true
    end sub

    private sub getLikeMasterData()
		dim sqlstr 

        sqlStr = sqlStr &  " select contents_id, max_like   "& vbcrlf
        sqlStr = sqlStr &  "   from DB_EVENT.DBO.TBL_LIKE_MASTER with(nolock)  "& vbcrlf
        sqlStr = sqlStr &  "  where id = '"& likeId &"'"& vbcrlf
		
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			contentsId = rsget("contents_id")
			maxLike   = rsget("max_like")
		end if
		rsget.close
    end sub

	'좋아요 로그 삽입
	private sub insertLog()
		dim sqlStr 
        if likeCnt = 0 or likeCnt = "" then exit sub
        sqlStr = sqlStr &  " insert into DB_EVENT.DBO.TBL_LIKE_LOG( " & vbcrlf
        sqlStr = sqlStr &  " like_Id " & vbcrlf
        sqlStr = sqlStr &  " , contents_sub_id " & vbcrlf
        sqlStr = sqlStr &  " , userid " & vbcrlf
        sqlStr = sqlStr &  " , like_cnt " & vbcrlf
        sqlStr = sqlStr &  " , refip " & vbcrlf
        sqlStr = sqlStr &  " , regdate " & vbcrlf
        sqlStr = sqlStr &  " )values( " & vbcrlf
        sqlStr = sqlStr &  " '" & likeId & "' " & vbcrlf
        sqlStr = sqlStr &  " , '"& contentsSubId &"' " & vbcrlf
        sqlStr = sqlStr &  " , '"& userid &"' " & vbcrlf
        sqlStr = sqlStr &  " , '"& likeCnt &"' " & vbcrlf
        sqlStr = sqlStr &  " , '"& refip &"' " & vbcrlf
        sqlStr = sqlStr &  " , getdate() " & vbcrlf
        sqlStr = sqlStr &  " ) " & vbcrlf
        
		dbget.execute sqlStr
	end sub

	'max좋아요 체크
	private sub setLikeCnt()
		dim result, sqlstr, userLikeCnt, computedCnt
		result = false		

        sqlStr = sqlStr & "SELECT sum(like_cnt) as cnt "& vbcrlf
        sqlStr = sqlStr & "    FROM DB_EVENT.DBO.TBL_LIKE_LOG with(nolock) "& vbcrlf
        sqlStr = sqlStr & "where like_id = '"& likeId &"' "& vbcrlf
        sqlStr = sqlStr & "    and contents_sub_id = '"& contentsSubId &"' "& vbcrlf
        sqlStr = sqlStr & "    and userid = '" & userid & "' "& vbcrlf
		
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			userLikeCnt = rsget("cnt")
		end if	
		rsget.close

        computedCnt = chkMaxLike(userLikeCnt, likeCnt, maxLike)        
        likeCnt = computedCnt
	end sub

    public function chkMaxLike(orgLikeCount, addLikeCnt, maxCnt)
        dim result        
        
        if orgLikeCount > maxCnt then
            result = 0
        elseif orgLikeCount + addLikeCnt > maxCnt then
            result = maxCnt - orgLikeCount
        Else
            result = addLikeCnt
        end if

        chkMaxLike = result
    end function

	private function chkValidation()
		dim result
		result = false

		if (likeId = "") or (contentsSubId = "") or (userid = "") or (likeCnt = "") then			
			result = true
			chkValidation = result
		end if
	end function

    Private Sub Class_Initialize()	
		refip = Request.ServerVariables("REMOTE_ADDR")	
        totalResult = false
	End Sub	
	Private Sub Class_Terminate()
    End Sub	

end Class
%>
