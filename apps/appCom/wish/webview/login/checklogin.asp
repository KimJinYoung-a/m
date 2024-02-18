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
		'Response.redirect "/apps/appCom/wish/webview/login/login.asp?" + checklogin_backpath
		response.write "<script type='text/javascript'>"
		response.write "	location.href='/apps/appCom/wish/webview/login/login.asp?"& checklogin_backpath &"';"
		response.write "</script>"
		response.end
end if

%> 