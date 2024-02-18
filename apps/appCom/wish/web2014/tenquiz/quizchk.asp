<%
'####################################################
' Description : 2018 TenQuizCheck
' History : 2018-09-11 최종원 생성
'####################################################
%>
<%  
    dim vQuery, vTestCheck
    vTestCheck = false

'차수 안넘어왔을 시
	If vChasu = "" Then        
		Response.Write "<script>alert('정상적인 경로로 참여해주세요.');location.href='/apps/appCom/wish/web2014/tenquiz/quizmain.asp';</script>"
		Response.End
	End If    

	If IsUserLoginOK() Then
		'// 해당차수 문제풀었는지 확인		
		If tenQuizQuestion.isSolvedQuizChasu(userid, vChasu) Then
			vTestCheck = True               
		End If		
    else
        Response.Write "<script>alert('로그인을 하셔야 참여하실 수 있습니다.');location.href='/apps/appCom/wish/web2014/tenquiz/quizmain.asp';</script>"
        Response.End
	End If    
    
    if nowQuizNumber = 1 Then
        If vTestCheck Then        
            Response.Write "<script>alert('해당일자 퀴즈는 이미 참여하셨습니다.');location.href='/apps/appCom/wish/web2014/tenquiz/quizmain.asp';</script>"
            Response.End
        End If    

        vQuery = " INSERT INTO [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserMasterData] "
        vQuery = vQuery + " (userid, chasu, answercount, userscore, snscheck, registdate, lastupdate) "
        vQuery = vQuery + " VALUES('" & userid & "', '" & vChasu & "', 0, 0, 'N', getdate(), getdate()) "
        dbget.Execute vQuery
    else
		'// 최초 시작 이외에는 반드시 기존 퀴즈 넘버가있어야됨.
		If prevQuizNumber<>"" Then
			'// 지난 퀴즈 넘버가 있기 때문에 기존 퀴즈 진입 내역이 있어야됨
			If Not(vTestCheck) Then
                Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/tenquiz/quizmain.asp';</script>"
                Response.End
			End If

			'// 기존문제 풀었던 내역이 있으면 안됨.(뒤로가기 방지)            
			If tenQuizQuestion.isSolvedQuiz(userid, vChasu, prevQuizNumber) Then					
				Response.Write "<script>alert('이미 풀었던 문제입니다.');location.href='/apps/appCom/wish/web2014/tenquiz/quizmain.asp';</script>"
				Response.End					
			End If

			'// 마지막으로 풀었던 문제와 현재 푼 문제의 시간값이 러프하게 12초 이상 차이나면 튕겨냄
			'vQuery = "SELECT TOP 1 regdate FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' ORDER BY detailidx desc "
			'rsget.CursorLocation = adUseClient
			'rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			'	If Not(rsget.bof Or rsget.eof) Then
			'		If datediff("s", rsget("regdate"), now()) >= 12 Then
			'			if now() < "2018-05-08" then
			'				Response.Write "<script>alert('문제풀이 시간이 초과되었습니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
			'				Response.End
			'			Else
			'				Response.Write "<script>alert('문제풀이 시간이 초과되었습니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
			'				Response.End
			'			End If
			'		End If
			'	End If
			'rsget.close

			nowQuizNumber = prevQuizNumber + 1			
			If prevQuizAnswer = prevQuizUserAnswer Then
				tmpUserScore = 1
			Else
				tmpUserScore = 0
			End If
            '유저 퀴즈정보 업데이트
			vQuery = "UPDATE [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserMasterData] SET answercount = answercount + 1, userscore = userscore + "&tmpUserScore&", lastupdate = getdate() WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
			dbget.Execute vQuery
            
			vQuery = "INSERT INTO [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserDetailData](userid, chasu, questionnumber, useranswer, registdate) VALUES('" & userid & "', '" & vChasu & "', '"&prevQuizNumber&"', '"&prevQuizUserAnswer&"', getdate())"
			dbget.Execute vQuery

            If prevQuizNumber = TotalQuestionCount Then        
                'Response.redirect "/apps/appCom/wish/web2014/playing/sub/vol040Result.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate
                Response.redirect "/apps/appCom/wish/web2014/tenquiz/quizresult.asp?TotalQuestionCount="&TotalQuestionCount&"&chasu="&vChasu&"&userid="&userid
                Response.End        
            End If
		Else			
            Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/tenquiz/quizresult.asp';</script>"
            Response.End			
		End If
    end if




%>