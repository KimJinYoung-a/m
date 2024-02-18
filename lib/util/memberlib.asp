<%

function checkidexist(userid)
    dim sql

    sql = "select top 1 userid from [db_user].[dbo].tbl_logindata where userid = '" + userid + "'"
    rsget.Open sql,dbget,1

    checkidexist = (not rsget.EOF)

    rsget.close

    sql = "select userid from [db_user].[dbo].tbl_deluser where userid = '" + userid + "'"
	rsget.Open sql, dbget, 1
	checkidexist = checkidexist or (Not rsget.Eof)
	rsget.Close
end function

function checkspecialpass(target)
    dim buf, result, index

    index = 1
    do until index > len(target)
            buf = mid(target, index, cint(1))
            if (buf="'") or (buf="`") then
                    checkspecialpass = true
                    exit function
            else
                    result = false
            end if
            index = index + 1
    loop
    checkspecialpass = false
end function

function checkspecialchar(target)
    dim buf, result, index

    index = 1
    do until index > len(target)
            buf = mid(target, index, cint(1))
            if (lcase(buf) >= "a" and lcase(buf) <= "z") then
                    result = false
            elseif (buf >= "0" and buf <= "9") then
                    result = false
            else
                    checkspecialchar = true
                    exit function
            end if
            index = index + 1
    loop
    checkspecialchar = false
end function

function checkjuminnoexist(juminno01, juminno02)
    dim sql

    if ((juminno01 + "-" + juminno02) = "730418-1037825") then
            checkjuminnoexist = false
            exit function
    end if

    if ((juminno01 + "-" + juminno02) = "731013-1041421") then
            checkjuminnoexist = false
            exit function
    end if

    sql = "select top 1 userid from [db_user].[dbo].tbl_user_n where jumin1 = '" + juminno01 + "' and Enc_jumin2='" + Md5(juminno02) + "'"
    rsget.Open sql,dbget,1
    if  not rsget.EOF  then
            rsget.Movefirst
            checkjuminnoexist = true
            rsget.close
            exit function
    end if
    rsget.close
    
    
    'sql = "select top 1 userid from [db_user].[dbo].tbl_user_c where socno = '" + juminno01 + "-" + juminno02 + "'"
    'rsget.Open sql,dbget,1
    'if  not rsget.EOF  then
    '        rsget.Movefirst
    '        checkjuminnoexist = true
    '        rsget.close
    '        exit function
    'end if
    'rsget.close
    checkjuminnoexist = false
end function


'==============================================================================
function membercheck(userid, userpass)
    dim sql

    if ((userid = "") or (userpass = "")) then
            membercheck = 1
    else
            sql = "select top 1 userid, userpass, Enc_userpass, Enc_userpass64 from [db_user].[dbo].tbl_logindata where userid = '" + userid + "'"
            rsget.Open sql,dbget,1
            if  not rsget.EOF  then
                    rsget.Movefirst
                    ''if (Md5(userpass) = rsget("Enc_userpass")) then
                    if (SHA256(Md5(userpass)) = rsget("Enc_userpass64")) then
                    		userid = rsget("userid")
                            membercheck = 0
                    else
                            membercheck = 2
                    end if
            else
                    membercheck = 3
            end if
            rsget.close
    end if
end function

function DEL_membercheckin(userid)
    dim sql, sqlput
    dim dbuserid, userdiv, userlevel, cnt, birthday, username, usermail
	dim memexists

    sql = "select top 1 userdiv, userlevel, lastlogin, counter as cnt from [db_user].[dbo].tbl_logindata where userid = '" + userid + "'"
    rsget.Open sql,dbget,1
    if  not rsget.EOF  then
        userdiv = rsget("userdiv")
        userlevel = rsget("userlevel")
        cnt = cint(rsget("cnt")) + 1
        memexists = true
    end if
    rsget.close

    if (userdiv = "01") or (userdiv = "99")  then
        sql = "select top 1 userid, birthday, username, usermail from [db_user].[dbo].tbl_user_n where userid = '" + userid + "'"
    else
        'sql = "select top 1 convert(varchar, birthday, 111) as birthday, username from tbl_user_c where userid = '" + userid + "'"
        sql = "select top 1 userid, birthday, socname as username, socmail as usermail from [db_user].[dbo].tbl_user_c where userid = '" + userid + "'"
    end if

    rsget.Open sql,dbget,1
    if  not rsget.EOF  then
        dbuserid = rsget("userid")
        birthday = rsget("birthday")
        username = rsget("username")
        usermail = rsget("usermail")
    end if
    rsget.close

    if memexists then
    	dim lastrefip
		lastrefip = Left(request.ServerVariables("REMOTE_ADDR"),32)

        sqlput = "update [db_user].[dbo].tbl_logindata set counter=" & cnt & ", lastlogin = getdate(), lastrefip='" + lastrefip + "' where userid='" & userid & "'"
        rsget.Open sqlput,dbget,1
    end if

    session("userid") = trim(dbuserid)
    session("username") = trim(username)
    session("usermail") = trim(usermail)
	session("userlevel") = trim(userlevel)

    response.Cookies("uinfo").domain = "10x10.co.kr"

	response.Cookies("uinfo")("userid") = trim(dbuserid)
	response.Cookies("uinfo")("username") = db2html(trim(username))
	response.Cookies("uinfo")("useremail") = db2html(trim(usermail))
	response.Cookies("uinfo")("userdiv") = userdiv
	response.Cookies("uinfo")("userlevel") = userlevel

    ''session("userdiv") = userdiv
    ''session("birthday") = trim(birthday)
end function


function ConvertChar2MyHex(orgstr)
	dim orgChar, encHex
	orgChar = Array ("0","1","2","3","4","5","6","7","8","9", "_" _
				 ,"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z" _
				 ,"-","/",":"," " _
				 ,"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z" _
				 )

	encHex	= Array ("10","11","12","13","14","15","16","17","18","19","20" _
				 ,"21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46" _
				 ,"47","48","49","50" _
				 ,"51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76" _
				 )

	dim i, ch, n, olen, j
	olen = ubound(orgChar)

	n = Len(orgstr)
    For i=1 To n
    	ch = Mid(orgstr, i, 1)
    	for j=0 to olen-1
    		if Asc(orgChar(j))=Asc(ch) then
    			ConvertChar2MyHex = ConvertChar2MyHex & encHex(j)
    			exit for
    		end if
    	next

	next
end function

function strTimestamp(time1)
   strTimestamp = dateDiff("s", "1970-01-01", time1)
end function

sub getDbTime(login_time,otimestamp)
	dim sqlStr, dbtime, dbtimestamp
	sqlStr = "select convert(varchar(19),getdate(),20) as logintime"

	rsget.Open sqlStr,dbget,1
	    dbtime = rsget("logintime")
	    dbtimestamp = strTimestamp(dbtime)
	rsget.Close

	login_time = Right(replace(dbtime,":",""),6)
	otimestamp = dbtimestamp
end sub

function EncValue()

end function

function DecValue()

end function

%>

