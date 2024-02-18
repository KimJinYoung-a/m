<!-- #include virtual="/lib/util/commlib.asp" -->
<%    
if (Not IsUserLoginOK) then
'// 2008.06.25 정윤정 수정. post data 값 추가
	dim checklogin_backpath
  	dim strBackPath, strGetData, strPostData	
   		strBackPath 	= request.ServerVariables("URL")
   		strGetData  	= request.ServerVariables("QUERY_STRING")
   		strPostData 	= fnMakePostData 'post data를 get string 형태로 변경
   
        checklogin_backpath = "backpath="+ server.URLEncode(strBackPath) + "&strGD=" +  server.URLEncode(strGetData) + "&strPD="+  server.URLEncode(strPostData)
		'// 히스토리 페이지에서 로그인 체크시 하단에 비회원 주문조회를 띄우기 위해 작업(기획서에 표기된 대로 작업함 2020.03.30)
		If instr(lcase(strBackPath),"myrecentview.asp") > 0 Then
			Response.redirect "/login/login.asp?vType=G&" + checklogin_backpath
		Else
			Response.redirect "/login/login.asp?" + checklogin_backpath
		End If
       dbget.Close:  response.end
end if

%> 