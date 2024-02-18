<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : TenQuiz 답안페이지
' History : 2018-09-12 최종원 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/tenquiz/TenQuizCls.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->		
<%
dim i, j, x, vIsAdmin, vChasu, userid, vUserid
dim TotalQuestionCount, userScore, answerFlagClass, isSolvedQuizFlag, isTimeout, productEvtNum

dim questionType, questionNumber, question, questionType1Image1, questionType1Image2, questionType1Image3, questionType1Image4, questionExample1, questionExample2, type2TextExample1, type2TextExample2, type2TextExample3, type2TextExample4
dim questionExample3, questionExample4, answer, registDate, lastUpDate, IsUsing, NumOfType1Image, type1imageArr(), type2textExampleArr(), questionExampleArr()

dim userQuestionNumber, questionAnswer, userQuestionAnswer, result, questionClass

dim tenQuizQuestions, userQuizDataObj
set tenQuizQuestions = new TenQuiz
set userQuizDataObj = new TenQuiz

vChasu = request("chasu")
userid = GetEncLoginUserID()
vUserid = request("userid")

If vChasu = "" Then    
    Response.Write "<script>alert('잘못된 접속입니다.');location.href='/apps/appCom/wish/web2014/tenquiz/quizmain.asp';</script>"
    Response.End
End If

if vUserid <> "" then
    userid = vUserid
end if	

tenQuizQuestions.FRectChasu = vChasu
tenQuizQuestions.FRectUserId = userid
tenQuizQuestions.GetQuestionList()
tenQuizQuestions.GetUserMasterData()
isSolvedQuizFlag = tenQuizQuestions.isSolvedQuiz(userid, vChasu, "")
productEvtNum = tenQuizQuestions.getProductEvtNum(vChasu)

userQuizDataObj.FRectChasu = vChasu
userQuizDataObj.FRectUserId = userid
userQuizDataObj.GetUserAnswerList()

userScore   = tenQuizQuestions.FoneItem.FMuserScore

tenQuizQuestions.GetOneQuiz()

TotalQuestionCount = tenQuizQuestions.FoneItem.FTotalQuestionCount

%>
<script type="text/javascript">
$(function(){
	var position = $('.tenquiz-result').offset();
	$('html,body').animate({ scrollTop : position.top },300);
});
</script>
</head>
<body class="default-font body-sub">
	<!-- contents -->
	<div id="content" class="content tenquiz-result">
         <div class="topic">
         <% if userScore ="" then  %>
            <h2><img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/tit_result_2.png" alt="TEN QUIZ" /></h2>
         <% else %>
            <h2><img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/tit_result_1.png" alt="TEN QUIZ" /></h2>
            <div class="history"><span><%=TotalQuestionCount%>문제 중<em><%=userScore%>점</em></span></div> 
         <% end if %>            
            <p class="date"><%=FormatNumber(mid(vChasu,5 ,2),0) & "월 " & FormatNumber(mid(vChasu,7 ,2),0) & "일"%></p>
        </div>
        <ol class="q-list">
            <!-- 정답일 경우 answerY 오답일경우 answerN -->
            <%
            for i=0 to tenQuizQuestions.FTotalCount-1  
                '유저 정답정보
                userQuestionNumber    =  userQuizDataObj.FItemList(i).FAquestionNumber
                questionAnswer        =  userQuizDataObj.FItemList(i).FAanswer
                userQuestionAnswer    =  userQuizDataObj.FItemList(i).FAuserAnswer
                result                =  userQuizDataObj.FItemList(i).FAresult            

                '문항정보
                questionType          =  tenQuizQuestions.FItemList(i).FItype
                questionNumber        =  tenQuizQuestions.FItemList(i).FIquestionNumber        
                question              =  tenQuizQuestions.FItemList(i).FIquestion    
                questionType1Image1   =  tenQuizQuestions.FItemList(i).FIquestionType1Image1            
                questionType1Image2   =  tenQuizQuestions.FItemList(i).FIquestionType1Image2            
                questionType1Image3   =  tenQuizQuestions.FItemList(i).FIquestionType1Image3            
                questionType1Image4   =  tenQuizQuestions.FItemList(i).FIquestionType1Image4            
                questionExample1      =  tenQuizQuestions.FItemList(i).FIquestionExample1            
                questionExample2      =  tenQuizQuestions.FItemList(i).FIquestionExample2            
                questionExample3      =  tenQuizQuestions.FItemList(i).FIquestionExample3            
                questionExample4      =  tenQuizQuestions.FItemList(i).FIquestionExample4       
                type2TextExample1      =  tenQuizQuestions.FItemList(i).FItype2TextExample1            
                type2TextExample2      =  tenQuizQuestions.FItemList(i).FItype2TextExample2           
                type2TextExample3      =  tenQuizQuestions.FItemList(i).FItype2TextExample3            
                type2TextExample4      =  tenQuizQuestions.FItemList(i).FItype2TextExample4                   
                answer                =  tenQuizQuestions.FItemList(i).FIanswer
                NumOfType1Image       =  tenQuizQuestions.FItemList(i).FINumOfType1Image

                'timeout 문제 분기처리
                isTimeout = chkIIF(userQuestionAnswer = -1, true, false)

                redim preserve type1imageArr(4)      
                redim preserve questionExampleArr(4)      

                questionExampleArr(0) = questionExample1
                questionExampleArr(1) = questionExample2
                questionExampleArr(2) = questionExample3
                questionExampleArr(3) = questionExample4

                if isSolvedQuizFlag then
                    answerFlagClass =  chkIIF(result, " answerY", " answerN") 
                else
                    answerFlagClass = ""
                end if

                if questionType = 1 then  
                    type1imageArr(0) = questionType1Image1
                    type1imageArr(1) = questionType1Image2
                    type1imageArr(2) = questionType1Image3
                    type1imageArr(3) = questionType1Image4               
            %>
            <li id="q<%=questionNumber%>" class="q<%=questionNumber%> typeA-<%=NumOfType1Image%> <%=answerFlagClass%>">
                <div class="txt">
                    <p><%=Num2Str(questionNumber,2,"0","R")%>. <%=question%></p>
                    <%= chkIIF(isTimeout,"<i>Time Over</i>" ,"")%>
                </div>                
                <div class="image-cont">                
                    <% For j=0 To numOfType1Image - 1 %>
                    <div class="thumbnail"><img src="<%=type1imageArr(j)%>" alt="" /></div>        
                    <% Next %>                                                
                </div>
                <div class="answer">
                    <!-- 내가 선택한 답 my 클래스 / 정답 correct 클래스-->
                    <% 
                    for x=0 to 3
                        if result = "o" then 
                            if x+1 = userQuestionAnswer then 
                                questionClass = "my"
                            else
                                questionClass = ""
                            end if
                        else
                            if x+1 = questionAnswer then 
                                questionClass = "correct"
                            elseif x+1 = userQuestionAnswer then
                                questionClass = "my"
                            else
                                questionClass = ""    
                            end if                                                                                                                
                        end if
                    %>
                    <div class="choice <%=questionClass%>">
                        <span><%=questionExampleArr(x)%></span>
                    </div>                        
                    <% next %>
                </div>  
            </li>
            <% 
            else
                redim preserve type2textExampleArr(4)   
                type2textExampleArr(0) = type2TextExample1
                type2textExampleArr(1) = type2TextExample2
                type2textExampleArr(2) = type2TextExample3
                type2textExampleArr(3) = type2TextExample4               
             %>
            <li id="q<%=questionNumber%>" class="q<%=questionNumber%> typeB<%=answerFlagClass%>">
                <div class="txt">
                    <p><%=Num2Str(questionNumber,2,"0","R")%>. <%=question%></p>
                    <%= chkIIF(isTimeout,"<i>Time Over</i>" ,"")%>
                </div>                
                <div class="answer">
                    <!-- 내가 선택한 답 my 클래스 / 정답 correct 클래스-->
                    <% 
                    for x=0 to 3
                        if result = "o" then 
                            if x+1 = userQuestionAnswer then 
                                questionClass = "my"
                            else
                                questionClass = ""
                            end if
                        else
                            if x+1 = questionAnswer then 
                                questionClass = "correct"
                            elseif x+1 = userQuestionAnswer then
                                questionClass = "my"
                            else
                                questionClass = ""    
                            end if                                                                                                                
                        end if
                    %>
                    <div class="choice <%=questionClass%>">
                        <div class="thumbnail"><img src="<%=questionExampleArr(x)%>" alt="" /></div>
                        <span><%=type2textExampleArr(x)%></span>
                    </div>
                    <% next %>   
                </div>
            </li>            
            <% end if %>
            <% next %>
        </ol>
        <%' 문제에 나온 상품 보러가기%>
        <a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=productEvtNum%>');"><img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/img_bnr_item_2.png" alt="문제에 나온 상품 보러 가기 " /></a>        
	</div>    
	<!-- //contents -->	
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->    
</body>
</html>
