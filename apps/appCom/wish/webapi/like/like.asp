<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description : 좋아요 api
' History : 2019-10-31 최종원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/like/LikeCls.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%    
	Response.ContentType = "application/json"
	response.charset = "utf-8"
    dim httpMethod, oJson
    dim likeObj, likeId, likeSubId, likeCnt, userid, contentsSubId

	Set oJson = jsObject()
    httpMethod = Request.Servervariables("REQUEST_METHOD")

    likeId  = request("likeId")
    contentsSubId  = request("contentsSubId")
    likeCnt  = request("likeCnt")
    userid		= getencLoginUserid()

	if Not(IsUserLoginOK) Then
		oJson("response") = "loginerr"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if	

    if httpMethod = "POST" Then
    'log데이터
        set likeObj = new LikeCls
        likeObj.likeId = likeId
        likeObj.contentsSubId = contentsSubId
        likeObj.likeCnt = likeCnt
        likeObj.userid = userid
        likeObj.execPlusLike()

        if likeObj.totalResult Then
	    	oJson("response") = "ok"	    	
	    	oJson.flush
	    	Set oJson = Nothing
	    	dbget.close() : Response.End        
        else 
	    	oJson("response") = "err"
	    	oJson("faildesc") = "오류가 발생하였습니다."
	    	oJson.flush
	    	Set oJson = Nothing
	    	dbget.close() : Response.End                
        end if
    end if
%>
