<%
dim currentDate : currentDate = date()
dim wallPaperArr, i
dim testDate 
testDate = request("testdate")

if testDate <> "" then
    currentDate = Cdate(testDate) 
end if

sqlstr = "           SELECT A.EVT_CODE "  + vbcrlf
sqlstr = sqlstr & " 	  , A.EVT_NAME  " + vbcrlf
sqlstr = sqlstr & " 	  , ISNULL(B.SUB_OPT2, 0) AS CNT    " + vbcrlf
''sqlstr = sqlstr & " 	  , EVT_FORWARD_MO  " + vbcrlf
sqlstr = sqlstr & "    FROM DB_EVENT.DBO.TBL_EVENT AS A WITH(NOLOCK) " + vbcrlf
sqlstr = sqlstr & "   LEFT JOIN DB_EVENT.DBO.TBL_EVENT_SUBSCRIPT B WITH(NOLOCK) ON A.EVT_CODE = B.EVT_CODE       " + vbcrlf
sqlstr = sqlstr & "    AND B.SUB_OPT3 IS NULL and B.userid='' " + vbcrlf
''sqlstr = sqlstr & "   INNER JOIN DB_EVENT.DBO.TBL_EVENT_DISPLAY C WITH(NOLOCK) ON A.EVT_CODE = C.EVT_CODE    " + vbcrlf
sqlstr = sqlstr & "   WHERE A.EVT_KIND = 33   " + vbcrlf
sqlstr = sqlstr & "   AND A.EVT_USING = 'Y'   " + vbcrlf
sqlstr = sqlstr & "   AND A.EVT_STARTDATE <= '"& currentDate &"' " + vbcrlf
sqlstr = sqlstr & "   ORDER BY A.EVT_CODE DESC " + vbcrlf

rsget.CursorLocation = adUseClient
rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
if not rsget.EOF then
	wallPaperArr = rsget.getRows()    
end if
rsget.close()   
 
'for i = 0 to uBound(wallPaperArr,2)
'    response.write wallPaperArr(0,i) & "<br>"
'    response.write wallPaperArr(1,i) & "<br>"
'    response.write wallPaperArr(2,i) & "<br>"
'    response.write wallPaperArr(3,i) & "<br>"    
'next
%>
            <%  dim tmpImg, tempEventNameArr, wallpaperName, tmpEventCode
            if IsArray(wallPaperArr) then
                for i = 0 to uBound(wallPaperArr,2)
                    tempEventNameArr = split(wallPaperArr(1, i), "_")                    
                    if Ubound(tempEventNameArr) > 0 then
                        wallpaperName = tempEventNameArr(1)
                    end if                
                    tmpEventCode = wallPaperArr(0,i)                    
            %>
				<li>                
                <%
                    if isapp then
                %>
					<a href="javascript:fnAPPpopupBrowserURL('<%=wallpaperName%>','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=tmpEventCode%>','right','','sc');" onclick="fnAddViewCount(<%=tmpEventCode%>,<%=tmpEventCode%>)">
                <%                 
                    else
                %>
					<a href="/event/eventmain.asp?eventid=<%=tmpEventCode%>" onclick="fnAddViewCount(<%=tmpEventCode%>,<%=tmpEventCode%>)">
                <%  
                    end if
                %>
						<div class="wallpaper-info">
							<div>
								<strong><%=wallpaperName%></strong>
								<p>View <span><%=FormatNumber(wallPaperArr(2,i),0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="띔보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2019/<%=wallPaperArr(0,i)%>/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
            <%                 
                next 
            END IF
            %>
				