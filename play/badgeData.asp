<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<style type="text/css">
  table tr td{    
    border: 1px solid #444444;
  }
</style>
<%
    dim eCode, sd
    dim result, i
    dim SqlStr

    eCode = request("eCode")
    sd    = request("sd")
        
    SqlStr = " select "
    SqlStr = SqlStr & " 	replace(replace(convert(varchar(max), c.evtcom_txt), char(10), ''), char(13),'') as cmt "
    SqlStr = SqlStr & " 	, c.userid  "
    SqlStr = SqlStr & " 	,case when l.userlevel = 0 then 'white' "
    SqlStr = SqlStr & " 		 when l.userlevel = 1 then 'red'    "
    SqlStr = SqlStr & " 		 when l.userlevel = 2 then 'vip'    "
    SqlStr = SqlStr & " 		 when l.userlevel = 3 then 'vip gold'   "
    SqlStr = SqlStr & " 		 when l.userlevel = 4 then 'vvip'	    "
    SqlStr = SqlStr & " 		 when l.userlevel = 7 then 'staff'			 	    "
    SqlStr = SqlStr & " 	end as userlevel    "
    SqlStr = SqlStr & " 	, c.evtcom_regdate  "
    SqlStr = SqlStr & " 	,Case   "
    SqlStr = SqlStr & " 		When left(n.juminno,1)='0' Then 2019-Cast('20' + left(n.juminno,2) as int)  "
    SqlStr = SqlStr & " 		Else 2019-Cast('19' + left(n.juminno,2) as int)	    "
    SqlStr = SqlStr & " 	end as age  "
    SqlStr = SqlStr & " 	,(select count(*) FROM [db_event].[dbo].[tbl_event_prize] as p WHERE p.evt_winner = n.userid) as wincnt     "
    SqlStr = SqlStr & " 	,(select top 1 evt_regdate FROM [db_event].[dbo].[tbl_event_prize] as p WHERE p.evt_winner = n.userid order by evt_regdate desc) as windate     "
    SqlStr = SqlStr & " 	,(select top 1 regdate from db_order.dbo.tbl_order_master as m where m.userid = n.userid and m.userid <> '' and m.ipkumdiv>3  AND m.jumundiv<>9 AND m.cancelyn='N' and m.sitename = '10x10' and m.userid <> '') buydate 	    "
    SqlStr = SqlStr & " from    "
    SqlStr = SqlStr & " db_event.dbo.tbl_event_comment as c with (nolock)   "
    SqlStr = SqlStr & " inner join db_user.dbo.tbl_user_n as n with (nolock)    "
    SqlStr = SqlStr & " on c.userid = n.userid  "
    SqlStr = SqlStr & " inner join db_user.dbo.tbl_logindata as l with (nolock) "
    SqlStr = SqlStr & " on c.userid = l.userid  "
    SqlStr = SqlStr & " outer apply (select count(*) as evttotcnt from db_event.dbo.tbl_event_subscript where userid = c.userid) as nn  "
    SqlStr = SqlStr & " outer apply (select count(*) as evttotcnt from db_event.dbo.tbl_event_comment where userid = c.userid) as nc    "
    SqlStr = SqlStr & " where c.evt_code = '"& eCode &"' and evtcom_using = 'Y'   "
    SqlStr = SqlStr & "   and c.evtcom_regdate between '"& sd &"' and getdate()   "
    SqlStr = SqlStr & " order by c.evtcom_regdate asc   "


    rsget.CursorLocation = adUseClient
    rsget.Open SqlStr, dbget, adOpenForwardOnly, adLockReadOnly
    
    if not rsget.EOF then
        result = rsget.getRows()	
    end if
    rsget.close		    
%>
<table>    
<%
    if isArray(result) then 
        for i=0 to uBound(result,2) 
        %>        
            <tr>
                <td><%=result(0,i)%></td>
                <td><%=result(1,i)%></td>
                <td><%=result(2,i)%></td>
                <td><%=result(3,i)%></td>
                <td><%=result(4,i)%></td>
                <td><%=result(5,i)%></td>
                <td><%=result(6,i)%></td>
                <td><%=result(7,i)%></td>                
            </tr>        
        <%
        next 
    end if 
%>
</table>