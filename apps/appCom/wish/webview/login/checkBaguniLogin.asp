
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
	
	''안드로이드 로그인시 쿠키 날리는 이유로 파라메터로 처리(비회원 장바구니 담은 후 로그인시)//2014/06/16
    if (request.Cookies("shoppingbag")("GSSN")<>"") then
        checklogin_backpath = checklogin_backpath + "&gstGSSN="+server.URLEncode(request.Cookies("shoppingbag")("GSSN"))
    end if
    ''//2014/06/16
	response.redirect "/apps/appcom/wish/webview/login/login.asp?vType=B&" + checklogin_backpath
	response.end
end if

%> 