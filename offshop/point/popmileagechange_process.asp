<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
dim userid, refip
dim changrmile, cardno, regshopid
dim ref

userid = getEncLoginUserID
refip = request.ServerVariables("REMOTE_ADDR")
ref = request.ServerVariables("HTTP_REFERER")
changrmile = CLng(request.Form("changrmile"))
cardno = requestCheckVar(request.Form("cardno"),20)
regshopid = Request("regshopid"&cardno&"")

if InStr(ref,"10x10.co.kr/offshop/point/popmileagechange.asp")>0 then

else
	response.write "<script>alert('올바른 접속이 아닙니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

if userid="" then
	response.write "<script>alert('로그인후 사용하세요.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

dim sqlstr,ipoint,pointuserno
set ipoint = new TenPoint
ipoint.FrectUserID = userid
ipoint.FCardNo = cardno
ipoint.getOffShopMileagePop

if (changrmile>ipoint.FOffShopMileage) then
	response.write "<script>alert('마일리지가 충분하지 않습니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
elseif (changrmile < 0) then
	response.write "<script>alert('잘못된 접근입니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if



set ipoint = Nothing

On Error Resume Next
    dbget.BeginTrans

    sqlStr = "insert into [db_shop].[dbo].tbl_total_shop_log" + VbCrlf
    sqlStr = sqlStr + "(CardNo,Point,PointCode,RegShopID,LogDesc)" + VbCrlf
    sqlStr = sqlStr + " values('" + cardno + "'" + VbCrlf
    sqlStr = sqlStr + "," + CStr(changrmile*-1) + "" + VbCrlf
    sqlStr = sqlStr + ",'2'" + VbCrlf
    sqlStr = sqlStr + ",'" + regshopid + "'" + VbCrlf
    sqlStr = sqlStr + ",'온라인마일리지전환')" + VbCrlf
    dbget.Execute sqlStr

    sqlStr = "update [db_shop].[dbo].tbl_total_shop_card" + VbCrlf
    sqlStr = sqlStr + " set point = point-" + CStr(changrmile) + "" + VbCrlf
    sqlStr = sqlStr + " where cardno='" + cardno + "'"  + VbCrlf

    dbget.Execute sqlStr

    sqlStr = "insert into [db_user].[dbo].tbl_mileagelog(userid,mileage,jukyocd,jukyo,deleteyn)"
    sqlStr = sqlStr + " values('" + userid + "'," + vbCrlf
    sqlStr = sqlStr + " " + CStr(changrmile) + " ,81,'오프라인마일리지전환','N')" + vbCrlf
    dbget.Execute sqlStr

    sqlStr = "update [db_user].[dbo].tbl_user_current_mileage"
    sqlStr = sqlStr + " set bonusmileage=bonusmileage + " + CStr(changrmile) + vbCrlf
    sqlStr = sqlStr + " where userid='" + userid + "'"
    dbget.Execute sqlStr


If Err.Number = 0 Then
    dbget.CommitTrans
Else
    dbget.RollBackTrans
    response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n지속적으로 문제가 발생시에는 고객센타에 연락주시기 바랍니다.')</script>"
    response.write "<script>history.back()</script>"
    response.end
End If
on error Goto 0

%>

<script language='javascript'>
	alert('온라인 마일리지로 전환되었습니다.');
	parent.location.replace('/offshop/point/mileagelist.asp');
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->