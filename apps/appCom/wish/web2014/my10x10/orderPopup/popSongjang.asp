<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 반품송장입력
'	History	:  2018.10.18 원승현 생성
'#######################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<%


Dim mode	: mode = req("mode","")

Dim CsAsID	: CsAsID = req("asId","")

Dim songjangDiv	: songjangDiv = req("songjangDiv","")
Dim songjangNo	: songjangNo  = req("songjangNo","")
Dim sendSongjangNo	: sendSongjangNo  = req("sendSongjangNo","")

If mode = "SONGJANG" Then

	dim mycslist
	set mycslist = new CCSASList
	mycslist.FRectCsAsID = CsAsID

	if IsUserLoginOK() then
		mycslist.FRectUserID = getEncLoginUserID()
		mycslist.InputSongjangNo songjangDiv, songjangNo
	elseif IsGuestLoginOK() then
		mycslist.FRectOrderserial = GetGuestLoginOrderserial()
		mycslist.InputSongjangNo songjangDiv, songjangNo
	end if
	Set mycslist = Nothing

	response.write "<script>" & vbCrLf
	response.write "alert('등록되었습니다.');" & vbCrLf
	response.write "location.href='/my10x10/order/order_csdetail.asp?CsAsID="&CsAsID&"';" & vbCrLf
	response.write "</script>" & vbCrLf
	dbget.close()	:	response.End
End If



Sub drawSelectBoxDeliverCompany(selectBoxName,selectedId)
   dim tmp_str,query1
   %><select class="select" name="<%=selectBoxName%>">
     <option value='' <%if selectedId="" then response.write " selected"%>>선택</option><%
   query1 = " select top 100 divcd,divname from [db_order].[dbo].tbl_songjang_div where isUsing='Y' "
   query1 = query1 + " order by divcd"
   rsget.Open query1,dbget,1

   if  not rsget.EOF  then
       rsget.Movefirst

       do until rsget.EOF
           if Trim(Lcase(selectedId)) = Trim(Lcase(rsget("divcd"))) then
               tmp_str = " selected"
           end if
           response.write("<option value='"&rsget("divcd")&"' "&tmp_str&">" & "" & replace(db2html(rsget("divname")),"'","") &  "</option>")
           tmp_str = ""
           rsget.MoveNext
       loop
   end if
   rsget.close
   response.write("</select>")
End Sub
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type='text/javascript'>
function jsSubmit()
{
	var frm = document.frmWrite;
	var sendSongjangNo = "<%= sendSongjangNo %>";

	if (!frm.songjangDiv.value)
	{
		alert("택배회사를 선택해 주세요.");
		frm.songjangDiv.focus();
		return;
	}
	if (!frm.songjangNo.value || frm.songjangNo.value.length < 8)
	{
		alert("송장번호를 입력해 주세요.");
		frm.songjangNo.focus();
		return;
	}

	// 공백제거
	frm.songjangNo.value = frm.songjangNo.value.replace(/\s/g, "");

	if ((sendSongjangNo.length >= 8) && (sendSongjangNo == frm.songjangNo.value)) {
		alert("상품배송시의 송장번호를 입력하셨습니다.\n\n반품을 하시면서 받으신 [반품 송장번호] 를 입력하세요.");
		frm.songjangNo.focus();
		return;
	}

	frm.submit();
}
</script></head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content" id="contentArea">
            <div class="returnWrap">
                <div class="regDlvrMsg">
                    <p class="fs1-1r">반품하신 운송장 정보를 등록해주세요.</p>
                </div>

                <div class="userInfoEidt inner10">
                    <form name="frmWrite" action="/apps/appCom/wish/web2014/my10x10/orderpopup/popSongjang.asp">
						<input type="hidden" name="mode" value="SONGJANG">
						<input type="hidden" name="asId" value="<%=CsAsID%>">
                        <fieldset>
                        <legend>반품 운송장 등록</legend>
                            <dl class="infoInput">
                                <dt><label for="receiver">택배사</label></dt>
                                <dd>
                                    <%Call drawSelectBoxDeliverCompany("songjangDiv",songjangDiv)%>
                                </dd>
                            </dl>
                            <dl class="infoInput">
                                <dt><label for="invoiceNumber">운송장 번호</label></dt>
                                <dd><input type="text" name="songjangNo" id="invoiceNumber" value="<%=songjangNo%>" style="width:100%;" /></dd>
                            </dl>

                            <div class="btnWrap">
                                <div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onClick="fnCloseModal();">취소</button></span></div>
                                <div class="ftLt w50p"><span class="button btB1 btRed cWh1 w100p"><button type="submit" onClick="jsSubmit();return false;">확인</button></span></div>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->