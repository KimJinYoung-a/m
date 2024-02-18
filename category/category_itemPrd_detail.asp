<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%

    if (request("itemid")<>"") then  ''2017/06/13 ¼öÁ¤
        Response.redirect "http://m.10x10.co.kr/category/category_itemPrd.asp?itemid="&request("itemid")
        Response.End
    else
	    Response.redirect "http://m.10x10.co.kr"
	    Response.End
    end if

%>