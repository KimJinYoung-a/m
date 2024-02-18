<%@ language=vbscript %>
<% option explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/apps/nateon/lib/nateon_alarmClass.asp"-->
<%
'' from cs splash admin

        dim sql,discountrate,subtotalprice
        dim mailfrom, mailto, mailtitle, mailcontent,buyemail,buyname, userid
		dim orderserial, buyhp, siteflag

        buyemail = request.form("buyemail")
        buyname = request.form("buyname")
		orderserial = request.form("orderserial")
		buyhp = request.form("buyhp")


		if(orderserial="") then
            response.write("주문번호가 넘어오지 않았습니다. 어드민을 다시받으세요.")
            response.end
        end if

        sql = "select top 1 userid, buyname, buyhp, buyemail from [db_order].[dbo].tbl_order_master"
        sql = sql + " where orderserial='" + orderserial + "'"
        sql = sql + " and sitename<>'academy'"
        sql = sql + " order by idx desc"

        rsget.Open sql,dbget,1
        if Not rsget.Eof then
        	userid = db2html(rsget("userid"))
        	buyname = db2html(rsget("buyname"))
        	buyhp = db2html(rsget("buyhp"))
        	buyemail = db2html(rsget("buyemail"))
        end if
        rsget.close


        if(buyemail="") then
            response.write("주문자 이메일이 없습니다.")
            response.end
        end if

        if(buyname="") then
            response.write("주문자 이름이 없습니다.")
            response.end
        end if

        if(buyhp="") then
            response.write("주문자 핸드폰이 없습니다.")
            response.end
        end if

        dim osms
        set osms = new CSMSClass
        osms.SendAcctIpkumOkMsg buyhp,orderserial
        set osms = Nothing

        mailcontent = sendmailbankok(buyemail,buyname,orderserial)

        response.write "S_OK"

	'//네이트온 결제알림(166) 확인 및 발송
	on error resume next
	if Not(userid="" or isNull(userid)) then
		Call NateonAlarmCheckMsgSend(userid,166,orderserial)
	end if
	on error goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->