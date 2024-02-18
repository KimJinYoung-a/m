
<!-- #include virtual="/lib/util/commlib.asp" -->
<%

if ((Not IsUserLoginOK) and (request.cookies("shoppingbag")("isguestorderflag") = "")) then    
    '// 2009.04.15  정윤정 수정. post data 값 추가
	dim checklogin_backpath
  	dim strBackPath, strGetData, strPostData	
   		strBackPath 	= request.ServerVariables("URL")
   		strGetData  	= request.ServerVariables("QUERY_STRING")
   		strPostData 	= fnMakePostData 'post data를 get string 형태로 변경
   	      
    ''장바구니 쿠키로 변경
    if (request.Form("itemid")<>"") and (request.Form("itemoption")<>"") and (request.Form("itemea")<>"") then 
        response.Cookies("shoppingbag").domain = "10x10.co.kr"
        response.Cookies("shoppingbag")("r_itemid")     = request.Form("itemid")
        response.Cookies("shoppingbag")("r_itemoption") = request.Form("itemoption")
        response.Cookies("shoppingbag")("r_itemea")     = request.Form("itemea")
    elseif (request.Form("mode")="arr") and (request.Form("bagarr")<>"") then
        response.Cookies("shoppingbag").domain = "10x10.co.kr"
        response.Cookies("shoppingbag")("r_bagarr")     = request.Form("bagarr")
    end if
    
	if (request.Form("requiredetail")<>"") then 
	    response.Cookies("shoppingbag").domain = "10x10.co.kr"
        response.Cookies("shoppingbag")("req_" + CStr(request.Form("itemid")) + CStr(request.Form("itemoption"))) = request.Form("requiredetail")
	end if
	 
	checklogin_backpath = "backpath="+ server.URLEncode(strBackPath) + "&strGD=" +  server.URLEncode(strGetData) + "&strPD="+  server.URLEncode(strPostData)   

	response.redirect "/login/login.asp?vType=B&" + checklogin_backpath
    	dbget.Close: response.end
end if

%> 