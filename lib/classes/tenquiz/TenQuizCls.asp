<%
Class TenQuizObjCls
'퀴즈
	public Fidx							'시퀀스값
	Public Fchasu						'퀴즈별 차수값(해당년도 월일)
	Public FMonthGroup					'월단위로 묶어서 표시됨
	Public FTopTitle					'상단 타이틀 이미지 경로값
	Public FQuizDescription				'텐퀴즈 설명
	Public FBackGroundImage				'텐퀴즈 배경 이미지
	Public FMWBackGroundImage				'모웹 팝업 배경 이미지
	Public FPCWBackGroundImage				'피씨웹 배경이미지
	public FQuestionHintNumber			'힌트 문항번호
	public FTotalMileage				'총 지급 마일리지 금액
	public FQuizStartDate				'시작일		
	public FQuizEndDate					'종료일
	public FTotalQuestionCount			'총 문항 수
	public FStartDescription			'하단 대기중 도전하기 밑에 나오는 설명
	public FAdminRegister				'등록한 스태프 아이디
	public FAdminName					'등록한 스태프 이름
	public FAdminModifyer				'수정한 스태프 아이디
	public FAdminModifyerName			'수정한 스태프 이름
	public FRegistDate					'등록일
    public FLastUpDate					'수정일
	public FQuizStatus					'퀴즈 상태		1: 등록 대기 	2. 오픈 	3. 종료
	public FProductEvtNum				'퀴즈 상태		1: 등록 대기 	2. 오픈 	3. 종료
	public FEndAlertTxt					' 종료 시 버튼 누르면 나오는 텍스트
	public FWaitingAlertTxt				' 대기 시 버튼 누르면 나오는 텍스트

'문항
	public FIidx                      	'시퀀스값
	public FIchasu                    	'퀴즈별 차수값
	public FItype                     	'문제 타입 (1,2,3,4)
	public FIquestionNumber           	'문제번호
	public FIquestion                 	'문항
	public FIquestionType1Image1      	'type1번 이미지 1 경로값
	public FIquestionType1Image2      	'type1번 이미지 2 경로값
	public FIquestionType1Image3      	'type1번 이미지 3 경로값
	public FIquestionType1Image4      	'type1번 이미지 4 경로값
	public FIquestionExample1         	'type1번일 경우 텍스트 type2번일 경우 이미지 경로값
	public FIquestionExample2         	'type1번일 경우 텍스트 type2번일 경우 이미지 경로값
	public FIquestionExample3         	'type1번일 경우 텍스트 type2번일 경우 이미지 경로값
	public FIquestionExample4         	'type1번일 경우 텍스트 type2번일 경우 이미지 경로값
	public FItype2TextExample1         	'type2 텍스트 보기
	public FItype2TextExample2         	'type2 텍스트 보기
	public FItype2TextExample3         	'type2 텍스트 보기
	public FItype2TextExample4         	'type2 텍스트 보기
	public FIanswer                   	'문항의 답안
	public FIregistDate               	'등록일
	public FIlastUpDate               	'수정일
	public FIIsUsing				  	'사용 유무
	public FINumOfType1Image		  	'typ1 1이미지 갯수
 
 '유저 응모결과 총 합 데이터
	public FMidx						'시퀀스값
	public FMchasu						'퀴즈별 차수	
	public FMuserid						'유저 id	
	public FManswerCount				'총 응답 개수		
	public FMuserScore					'총 점수		
	public FMsnsCheck					'sns공유 여부	
	public FMRegistDate					'등록일		
	public FMLastUpDate					'최종 수정일		

'유저 문항 데이터
	public Fuidx						'시퀀스값
	public Fuchasu						'퀴즈별 차수값
	public Fuuserid						'유저 아이디값
	public FuquestionNumber				'문항 번호		
	public FuuserAnswer					'유저가 입력한 답안	
	public FuRegistDate					'등록일	

'유저 답안 데이터
	public FAquestionNumber				'문항번호
	public FAanswer						'문제 답
	public FAuserAnswer					'유저 답
	public FAresult						'결과		

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class TenQuiz
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
       
    
	Public FmonthGroupOption
	Public FQuizStatusOption
	Public FsdtOption
	Public FedtOption
	public FChasuOption
	public FWriterOption
	
	public FRectIdx
	Public FRectSubIdx
	Public FRectChasu
	Public FRectQuestionNumber
	Public FRectUserId
	
    public Sub GetQuizList()
        dim sqlStr, i, sqlWhere

		sqlwhere = ""
		if FmonthGroupOption <> "" then
			sqlWhere = sqlWhere + " and monthgroup='" & FmonthGroupOption & "'"
		end if 

		if FQuizStatusOption <> "" then
			sqlWhere = sqlWhere + " and quizStatus='" & FQuizStatusOption & "'"
		end if 

		if FsdtOption <> "" then
			sqlWhere = sqlWhere +  " and quizStartDate >='" & FsdtOption & "'"
		end if 

		if FedtOption <> "" then
			sqlWhere = sqlWhere +  " and quizStartDate <='" & FedtOption & "'"
		end if 		

		if FChasuOption <> "" then
			sqlWhere = sqlWhere +  " and chasu like '%" & FChasuOption & "%'"
		end if 				

		if FWriterOption <> "" then
			sqlWhere = sqlWhere +  " and adminName like '%" & FWriterOption & "%'"
		end if 				

		sqlStr = " select count(idx) as cnt from [db_sitemaster].[dbo].[tbl_PlayingTenQuizData] "
		sqlStr = sqlStr + " where 1=1 "
		sqlStr = sqlStr + sqlWhere		

        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close
        
        if FTotalCount < 1 then exit Sub
        	
			
        sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " "
		sqlStr = sqlStr + "  idx "
		sqlStr = sqlStr + " , chasu "
		sqlStr = sqlStr + " , monthGroup "
		sqlStr = sqlStr + " , topTitle "
		sqlStr = sqlStr + " , quizDescription "
		sqlStr = sqlStr + " , backGroundImage "
		sqlStr = sqlStr + " , questionHintNumber "
		sqlStr = sqlStr + " , totalMileage "
		sqlStr = sqlStr + " , quizStartDate "
		sqlStr = sqlStr + " , quizEndDate "
		sqlStr = sqlStr + " , totalQuestionCount "
		sqlStr = sqlStr + " , startDescription "
		sqlStr = sqlStr + " , adminRegister "
		sqlStr = sqlStr + " , adminName "
		sqlStr = sqlStr + " , adminModifyer "
		sqlStr = sqlStr + " , adminModifyerName "
		sqlStr = sqlStr + " , registDate "
		sqlStr = sqlStr + " , modifyDate "
		sqlStr = sqlStr + " , quizStatus "
        sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_PlayingTenQuizData "
        sqlStr = sqlStr + " where 1=1 "
		sqlStr = sqlStr + sqlWhere
        
		sqlStr = sqlStr + " order by chasu asc" 

'		response.write sqlStr &"<br>"
		
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new TenQuizObjCls
				
				FItemList(i).Fidx				= rsget("idx")
				FItemList(i).Fchasu				= rsget("chasu")
				FItemList(i).FMonthGroup		= rsget("monthGroup")
				FItemList(i).FTopTitle			= rsget("topTitle")
				FItemList(i).FQuizDescription	= rsget("quizDescription")
				FItemList(i).FBackGroundImage	= rsget("backGroundImage")
				FItemList(i).FQuestionHintNumber= rsget("questionHintNumber")
				FItemList(i).FTotalMileage		= rsget("totalMileage")
				FItemList(i).FQuizStartDate		= rsget("quizStartDate")
				FItemList(i).FQuizEndDate		= rsget("quizEndDate")
				FItemList(i).FTotalQuestionCount= rsget("totalQuestionCount")
				FItemList(i).FStartDescription	= rsget("startDescription")
				FItemList(i).FAdminRegister		= rsget("adminRegister")
				FItemList(i).FAdminName			= rsget("adminName")
				FItemList(i).FAdminModifyer		= rsget("adminModifyer")
				FItemList(i).FAdminModifyerName	= rsget("adminModifyerName")
				FItemList(i).FRegistDate		= rsget("registDate")
				FItemList(i).FLastUpDate		= rsget("modifyDate")
				FItemList(i).FQuizStatus		= rsget("quizStatus")					

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub
    	
	public Sub GetQuestion()
		dim SqlStr
        sqlStr = " Select top 1 idx, chasu, type, questionNumber, question, questionType1Image1, questionType1Image2, questionType1Image3, questionType1Image4 "
		sqlStr = sqlStr & " , type2TextExample1, type2TextExample2, type2TextExample3, type2TextExample4 "
		sqlStr = sqlStr & " , questionExample1, questionExample2, questionExample3, questionExample4, answer, registDate, lastUpDate, isusing, numOfType1Image "
        sqlStr = sqlStr & " From db_sitemaster.dbo.tbl_PlayingTenQuizQuestionData "
        SqlStr = SqlStr & " where chasu='" + CStr(FRectChasu) + "'"
		SqlStr = SqlStr & " and questionNumber='" + CStr(FRectQuestionNumber) + "'"		

'		response.write sqlStr &"<br>"
'		response.end

        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount

        set FOneItem = new TenQuizObjCls

        if Not rsget.Eof then
            FOneItem.FIidx				   = rsget("idx")	
            FOneItem.FIchasu			   = rsget("chasu")	
            FOneItem.FItype				   = rsget("type")
			FOneItem.FIquestionNumber	   = rsget("questionNumber")			
            FOneItem.FIquestion			   = rsget("question")	
            FOneItem.FIquestionType1Image1 = rsget("questionType1Image1")				
            FOneItem.FIquestionType1Image2 = rsget("questionType1Image2")				
			FOneItem.FIquestionType1Image3 = rsget("questionType1Image3")				
			FOneItem.FIquestionType1Image4 = rsget("questionType1Image4")				
			FOneItem.FIquestionExample1	   = rsget("questionExample1")			
			FOneItem.FIquestionExample2	   = rsget("questionExample2")			
			FOneItem.FIquestionExample3	   = rsget("questionExample3")			
			FOneItem.FIquestionExample4	   = rsget("questionExample4")			
			FOneItem.FItype2TextExample1   = rsget("type2TextExample1")			
			FOneItem.FItype2TextExample2   = rsget("type2TextExample2")			
			FOneItem.FItype2TextExample3   = rsget("type2TextExample3")			
			FOneItem.FItype2TextExample4   = rsget("type2TextExample4")					
			FOneItem.FIanswer			   = rsget("answer")	
			FOneItem.FIregistDate		   = rsget("registDate")		
			FOneItem.FIlastUpDate		   = rsget("lastUpDate")
			FOneItem.FIIsUsing			   = rsget("isusing")
			FOneItem.FINumOfType1Image	   = rsget("numOfType1Image")
			
        end if
        rsget.close
	End Sub

    public Sub GetOneQuiz()
        dim sqlStr
        sqlStr = "select top 1 * "
        sqlStr = sqlStr + " from db_sitemaster.dbo.[tbl_PlayingTenQuizData] "
        sqlStr = sqlStr + " where chasu='" + CStr(FRectChasu) + "'"

		'rw sqlStr & "<Br>"
        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount
        
        set FOneItem = new TenQuizObjCls
        
        if Not rsget.Eof Then	
			FOneItem.Fidx				= rsget("idx")
			FOneItem.Fchasu				= rsget("chasu")
			FOneItem.FMonthGroup		= rsget("monthGroup")
			FOneItem.FTopTitle			= rsget("topTitle")
			FOneItem.FQuizDescription	= rsget("quizDescription")
			FOneItem.FBackGroundImage	= rsget("backGroundImage")
			FOneItem.FMWBackGroundImage	= rsget("MWbackGroundImage")
			FOneItem.FPCWBackGroundImage= rsget("PCWbackGroundImage")
			FOneItem.FQuestionHintNumber= rsget("questionHintNumber")
			FOneItem.FTotalMileage		= rsget("totalMileage")
			FOneItem.FQuizStartDate		= rsget("quizStartDate")
			FOneItem.FQuizEndDate		= rsget("quizEndDate")
			FOneItem.FTotalQuestionCount= rsget("totalQuestionCount")
			FOneItem.FStartDescription	= rsget("startDescription")
			FOneItem.FAdminRegister		= rsget("adminRegister")
			FOneItem.FAdminName			= rsget("adminName")
			FOneItem.FAdminModifyer		= rsget("adminModifyer")
			FOneItem.FAdminModifyerName	= rsget("adminModifyerName")
			FOneItem.FRegistDate		= rsget("registDate")
			FOneItem.FLastUpDate		= rsget("modifyDate")		
			FOneItem.FQuizStatus		= rsget("quizStatus")					
			FOneItem.FEndAlertTxt		= rsget("endAlertTxt")					
			FOneItem.FWaitingAlertTxt	= rsget("waitingAlertTxt")					
			
        end If
        
        rsget.Close
    end Sub

	public Function GetNumberOfWinner(chasu, totalscore)
        dim sqlStr

		if chasu="" or isNull(chasu) or totalscore="" or isNull(totalscore) then
			exit Function
		end if
		
        sqlStr = "SELECT count(userid) cnt "
        sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) "
        sqlStr = sqlStr + " where chasu='" + CStr(chasu) + "'"		
		sqlStr = sqlStr + " and userscore=" + CStr(totalscore)

		rsget.Open sqlStr, dbget, 1
		if Not(rsget.EOF or rsget.BOF) then
			GetNumberOfWinner = rsget("cnt")
		end if
        
        rsget.Close
    end function

	public Function GetNumberOfParticipants(chasu)
        dim sqlStr

		if chasu="" or isNull(chasu) then
			exit Function
		end if
		
        sqlStr = "SELECT count(userid) cnt"
        sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) "
        sqlStr = sqlStr + " where chasu='" + CStr(chasu) + "'"					
	
		rsget.Open sqlStr, dbget, 1
		if Not(rsget.EOF or rsget.BOF) then
			GetNumberOfParticipants = rsget("cnt")
		end if
        
        rsget.Close
    end function

	public Function isAdmin(userid)
        dim useradmin
		useradmin = ""		
		if userid = "" then
			exit function
		end if

		if instr(useradmin, userid) <> 0 then
			isAdmin = true
        else
			isAdmin = false
		end if
    end function	
    
	public Function isSolvedQuiz(userid, chasu, prevQuizNumber)
        dim sqlStr		
		
		sqlStr = "SELECT * "
		sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) " 
		sqlStr = sqlStr + " WHERE userid='"&userid&"' And chasu='"&chasu&"'"
		if prevQuizNumber <> "" then
		sqlStr = sqlStr + " and questionnumber='"&prevQuizNumber&"' "
		end if
		
		
		rsget.Open sqlStr, dbget, 1
		If Not(rsget.bof Or rsget.eof) Then					
			isSolvedQuiz = true		
		else
			isSolvedQuiz = false
		End If
		rsget.close		
    end function	

	public Function isSolvedQuizChasu(userid, chasu)
        dim sqlStr		
		
		sqlStr = "SELECT * "
		sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) " 
		sqlStr = sqlStr + " WHERE userid='"&userid&"' And chasu='"&chasu&"'"		
		
		rsget.Open sqlStr, dbget, 1
		If Not(rsget.bof Or rsget.eof) Then					
			isSolvedQuizChasu = true		
		else
			isSolvedQuizChasu = false
		End If
		rsget.close		
    end function	

	public Function getChasuHint(chasu)		
		dim sqlStr, hint

		if chasu = "" then
			exit function
		end if

		sqlStr = "SELECT top 1 questionHintNumber "
		sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizData] WITH (NOLOCK) " 
		sqlStr = sqlStr + " WHERE chasu='"&chasu&"'" 				
		
        rsget.Open sqlStr, dbget, 1
			If Not(rsget.bof Or rsget.eof) Then					
				hint = rsget("questionHintNumber")
			end if			
		rsget.close			

		getChasuHint = hint 
    end function	

	public Function getProductEvtNum(chasu)		
		dim sqlStr, evtNum

		if chasu = "" then
			exit function
		end if

		sqlStr = "SELECT top 1 productEvtNum "
		sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizData] WITH (NOLOCK) " 
		sqlStr = sqlStr + " WHERE chasu='"&chasu&"'" 				
		
        rsget.Open sqlStr, dbget, 1
			If Not(rsget.bof Or rsget.eof) Then					
				evtNum = rsget("productEvtNum")
			end if
		rsget.close			

		getProductEvtNum = evtNum
    end function		

	public Function getNextChasu(chasu)		
		dim sqlStr		
		dim vMonthGroup, i, j, nextChasuIdx, chasuCnt, nextChasu, hint
		dim quizArr()				

		if chasu = "" then
			exit Function
		end if

		vMonthGroup = left(chasu, 6)
        
		sqlStr = "SELECT count(chasu) as cnt"
		sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizData] WITH (NOLOCK) " 
		'sqlStr = sqlStr + " WHERE monthgroup='"&vMonthGroup&"'" 						
		
        rsget.Open sqlStr, dbget, 1
			chasuCnt = rsget("cnt")
		rsget.close						

		redim preserve quizArr(chasuCnt)

		sqlStr = "SELECT chasu "
		sqlStr = sqlStr + " FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizData] WITH (NOLOCK) " 
		'sqlStr = sqlStr + " WHERE monthgroup='"&vMonthGroup&"'" 		
		sqlStr = sqlStr + " order by chasu asc" 		
		
		rsget.Open sqlStr, dbget, 1
		if not rsget.EOF  then
		    i = 0			
			do until rsget.eof				

	            quizArr(i)	= rsget("chasu")            			

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close

		if ubound(quizArr) = 0 then 
			exit Function
		end if
		
		for j=0 to ubound(quizArr)
			if instr(quizArr(j), chasu) <> 0 then				
				nextChasuIdx = j + 1
				nextChasu = quizArr(nextChasuIdx)
				exit for
			end if
		next			

		getNextChasu = nextChasu 

    end function	

    public Sub GetQuestionList()
       dim sqlStr, i

		sqlStr = " select count(idx) as cnt from db_sitemaster.dbo.tbl_PlayingTenQuizquestiondata "
		sqlStr = sqlStr + " where 1=1"
		sqlStr = sqlStr + " and isusing='Y'"

		if FRectChasu <> "" then
		sqlStr = sqlStr + " and chasu='"& FRectChasu &"'"
		end if
		
		'response.write sqlStr &"<br>"
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close
        
        if FTotalCount < 1 then exit Sub
        	
        sqlStr = "Select top " + CStr(FPageSize * FCurrPage) + " "        
		sqlStr = sqlStr & "	idx "
		sqlStr = sqlStr & "	,chasu "
		sqlStr = sqlStr & "	,type "
		sqlStr = sqlStr & "	,questionNumber "
		sqlStr = sqlStr & "	,question "
		sqlStr = sqlStr & "	,questionType1Image1 "
		sqlStr = sqlStr & "	,questionType1Image2 "
		sqlStr = sqlStr & "	,questionType1Image3 "
		sqlStr = sqlStr & "	,questionType1Image4 "
		sqlStr = sqlStr & "	,questionExample1 "
		sqlStr = sqlStr & "	,questionExample2 "
		sqlStr = sqlStr & "	,questionExample3 "
		sqlStr = sqlStr & "	,questionExample4 "
		sqlStr = sqlStr & "	,type2TextExample1 "
		sqlStr = sqlStr & "	,type2TextExample2 "
		sqlStr = sqlStr & "	,type2TextExample3 "
		sqlStr = sqlStr & "	,type2TextExample4 "		
		sqlStr = sqlStr & "	,answer "
		sqlStr = sqlStr & "	,registDate "
		sqlStr = sqlStr & "	,lastUpDate "
		sqlStr = sqlStr & "	,numOfType1Image "		
		sqlStr = sqlStr & " From [db_sitemaster].[dbo].[tbl_PlayingTenQuizquestiondata] "

        sqlStr = sqlStr & "Where 1=1"
		sqlStr = sqlStr & "and isusing='Y'"

		if FRectChasu <> "" then
		sqlStr = sqlStr + " and chasu='"& FRectChasu &"'"
		end if        

		sqlStr = sqlStr + " order by questionNumber asc" 

		'response.write sqlStr &"<br>"
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new TenQuizObjCls
				
				FItemList(i).FIidx					= rsget("idx")
	            FItemList(i).FIchasu				= rsget("chasu")
	            FItemList(i).FItype					= rsget("type")
	            FItemList(i).FIquestionNumber		= rsget("questionNumber")
	            FItemList(i).FIquestion				= rsget("question")
	            FItemList(i).FIquestionType1Image1	= rsget("questionType1Image1")
				FItemList(i).FIquestionType1Image2	= rsget("questionType1Image2")
				FItemList(i).FIquestionType1Image3	= rsget("questionType1Image3")
				FItemList(i).FIquestionType1Image4	= rsget("questionType1Image4")
				FItemList(i).FIquestionExample1		= rsget("questionExample1")
				FItemList(i).FIquestionExample2		= rsget("questionExample2")
				FItemList(i).FIquestionExample3		= rsget("questionExample3")
				FItemList(i).FIquestionExample4		= rsget("questionExample4")
				FItemList(i).FItype2TextExample1	= rsget("type2TextExample1")
				FItemList(i).FItype2TextExample2	= rsget("type2TextExample2")
				FItemList(i).FItype2TextExample3	= rsget("type2TextExample3")
				FItemList(i).FItype2TextExample4	= rsget("type2TextExample4")				
				FItemList(i).FIanswer				= rsget("answer")
				FItemList(i).FIregistDate			= rsget("registDate")
				FItemList(i).FIlastUpDate			= rsget("lastUpDate")
				FItemList(i).FINumOfType1Image		= rsget("numOfType1Image")				

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub

    public Sub GetUserAnswerList()
       dim sqlStr, i

		sqlStr = " select count(1) as cnt  "
		sqlStr = sqlStr + "  from db_sitemaster.dbo.tbl_PlayingTenQuizQuestionData as a 	"
		sqlStr = sqlStr + "  left join db_sitemaster.dbo.tbl_PlayingTenQuizUserDetailData b 	"
		sqlStr = sqlStr + "    on a.chasu =b.chasu 	"
		sqlStr = sqlStr + "   and a.questionNumber = b.questionNumber 	"
		sqlStr = sqlStr + "   and b.userid = '"& FRectUserId &"'	"
		sqlStr = sqlStr + "  where a.chasu = '"& FRectChasu &"'	"	

		'response.write sqlStr &"<br>"
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close
        
        if FTotalCount < 1 then exit Sub

        sqlStr = "Select a.questionNumber "        		
		sqlStr = sqlStr + "	 , a.answer	 	"
		sqlStr = sqlStr + "	 , isnull(b.userAnswer, 0) as userAnswer	"
		sqlStr = sqlStr + "	 , case 	"
		sqlStr = sqlStr + "	 when b.userAnswer = a.answer then 'true'	"		
		sqlStr = sqlStr + "	 else 'false'	 	"
		sqlStr = sqlStr + "	 end as 'result'	"
		sqlStr = sqlStr + "  from db_sitemaster.dbo.tbl_PlayingTenQuizQuestionData as a 	"
		sqlStr = sqlStr + "  left join db_sitemaster.dbo.tbl_PlayingTenQuizUserDetailData b 	"
		sqlStr = sqlStr + "    on a.chasu =b.chasu 	"
		sqlStr = sqlStr + "   and a.questionNumber = b.questionNumber 	"
		sqlStr = sqlStr + "   and b.userid = '"& FRectUserId &"'	"
		sqlStr = sqlStr + "  where a.chasu = '"& FRectChasu &"'	"		
		sqlStr = sqlStr + " order by questionNumber asc" 

		'response.write sqlStr &"<br>"
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		redim preserve FItemList(FTotalCount)
		if  not rsget.EOF  then
		    i = 0			
			do until rsget.eof
				set FItemList(i) = new TenQuizObjCls
				
				FItemList(i).FAquestionNumber		= rsget("questionNumber")
	            FItemList(i).FAanswer				= rsget("answer")
	            FItemList(i).FAuserAnswer			= rsget("userAnswer")
	            FItemList(i).FAresult				= rsget("result")	            	            		

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub

    public Sub GetUserQuizDetailList()
       dim sqlStr, i

		sqlStr = " select count(idx) as cnt from db_sitemaster.dbo.tbl_PlayingTenQuizUserDetailData "
		sqlStr = sqlStr + " where 1=1"		
		
		sqlStr = sqlStr + " and chasu='"& FRectChasu &"'"		
		sqlStr = sqlStr + " and userid='"& FRectUserId &"'"	

		'response.write sqlStr &"<br>"
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close
        
        if FTotalCount < 1 then exit Sub

        sqlStr = "Select top " + CStr(FPageSize * FCurrPage) + " "        
		sqlStr = sqlStr & "	idx "
		sqlStr = sqlStr & "	,chasu "
		sqlStr = sqlStr & "	,userid "
		sqlStr = sqlStr & "	,questionNumber "
		sqlStr = sqlStr & "	,userAnswer "
		sqlStr = sqlStr & "	,registDate "		
		sqlStr = sqlStr & " From [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserDetailData] "

        sqlStr = sqlStr & "Where 1=1"		

		sqlStr = sqlStr + " and chasu='"& FRectChasu &"'"
		sqlStr = sqlStr + " and userid='"& FRectUserId &"'"	

		sqlStr = sqlStr + " order by questionNumber asc" 

		'response.write sqlStr &"<br>"
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new TenQuizObjCls
				
				FItemList(i).Fuidx					= rsget("idx")
	            FItemList(i).Fuchasu				= rsget("chasu")
	            FItemList(i).Fuuserid				= rsget("userid")
	            FItemList(i).FuquestionNumber		= rsget("questionNumber")	            
	            FItemList(i).FuuserAnswer			= rsget("userAnswer")
				FItemList(i).FuRegistDate			= rsget("registDate")				

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub

	public Sub GetUserMasterData()
		dim SqlStr
        sqlStr = " Select top 1 * "		
        sqlStr = sqlStr + " From db_sitemaster.dbo.tbl_PlayingTenQuizUserMasterData "
        SqlStr = SqlStr + " where chasu='" & CStr(FRectChasu) & "'"
		SqlStr = SqlStr + " and userid='" & CStr(FRectUserId) & "'"				

'		response.write sqlStr &"<br>"
'		response.end

        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount

        set FOneItem = new TenQuizObjCls

        if Not rsget.Eof then

		FOneItem.FMidx				= rsget("idx")
		FOneItem.FMchasu			= rsget("chasu")
		FOneItem.FMuserid			= rsget("userid")
		FOneItem.FManswerCount		= rsget("answerCount")		
		FOneItem.FMuserScore		= rsget("userScore")	
		FOneItem.FMsnsCheck			= rsget("snsCheck")	
		FOneItem.FMRegistDate		= rsget("RegistDate")	
		FOneItem.FMLastUpDate		= rsget("LastUpDate")	            
			
        end if
        rsget.close
	End Sub
    
    Private Sub Class_Initialize()
		redim  FItemList(0)

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
