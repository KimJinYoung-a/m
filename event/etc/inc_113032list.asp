<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 이왕 이렇게 된 거! 코멘트 이벤트
' History : 2021.07.22 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim strSql, arrList, LoginUserid, FCPage, FPSize, intLoop
LoginUserid	= getencLoginUserid()
FCPage = request("currentPage")
FPSize = 10
strSql ="[db_temp].[dbo].[usp_WWW_Event113032_CommentList_Get] ("&FCPage&","&FPSize&")"
rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
IF Not (rsget.EOF OR rsget.BOF) THEN			
    arrList = rsget.GetRows()
END IF	
rsget.close
%>
				<%
					IF isArray(arrList) THEN
						For intLoop = 0 To UBound(arrList,2)
				%>
                        <% if arrList(1,intLoop) = LoginUserid then %>
                        <div class="comment del_on" id="c<%=arrList(0,intLoop)%>">
                        <% else %>
                        <div class="comment del_off">
                        <% end if %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/comment.png?" alt="">
                            <p class="name"><span><%=printUserId(arrList(1,intLoop),2,"*")%></span> 님의 다짐!</p>
                            <div class="resolve">
                                <p>이왕 이렇게 된 거</p>
                                <p><span><%=arrList(2,intLoop)%></span>을/를 <span><%=arrList(3,intLoop)%></span>에</p>
                                <p><span><%=arrList(4,intLoop)%></span> 해볼까</p>
                            </div>
                            <% if arrList(1,intLoop) = LoginUserid then %>
                            <a href="" onclick="fnDelComment(<%=arrList(0,intLoop)%>);return false;" class="delete"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/delete.png?" alt=""></a>
                            <% end if %>
                        </div>
				<%
						Next
					End If
				%>
<!-- #include virtual="/lib/db/dbclose.asp" -->