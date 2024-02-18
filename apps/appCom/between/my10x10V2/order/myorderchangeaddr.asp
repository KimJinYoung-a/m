<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% 
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  비트윈 배송지정보 변경
' History : 2014.04.23 이종화 생성
'			2016.08.11 한용민 수정			
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/sp_myordercls.asp" -->
<%
	dim orderserial , userid
	orderserial  = requestCheckvar(request("orderserial"),11)
	userid       = fnGetUserInfo("tenSn")

	dim myorder
	set myorder = new CMyOrder
		myorder.FRectOrderserial = orderserial
		myorder.FRectUserID = userid
		myorder.GetOneOrder

	dim IsWebEditEnabled
	IsWebEditEnabled = myorder.FOneItem.IsWebOrderInfoEditEnable

	if (Not IsWebEditEnabled) then
		response.write "<script>alert('주문/배송정보 수정 가능 상태가 아닙니다. - 고객센터로 문의해 주세요.'); history.back();</script>"
		dbget.close()	:	response.End
	end If
	
	Dim cmtno

	If myorder.FOneItem.Fcomment = "" Then
		cmtno = ""
	ElseIf myorder.FOneItem.Fcomment = "부재 시 경비실에 맡겨주세요" Then
		cmtno = "1"
	ElseIf myorder.FOneItem.Fcomment = "핸드폰으로 연락바랍니다" Then
		cmtno = "2"
	ElseIf myorder.FOneItem.Fcomment = "배송 전 연락바랍니다" Then
		cmtno = "3"
	Else
		cmtno = "4"
	End If 

%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
	function CheckNSubmit(frm){
		if (confirm('수정 하시겠습니까?')){
			frm.submit();
		}
    }

	function chgcmt(v){
		if (v == 1){
			$("#comment").attr("value","부재 시 경비실에 맡겨주세요");
		}else if (v == 2){
			$("#comment").attr("value","핸드폰으로 연락바랍니다");
		}else if (v == 3){
			$("#comment").attr("value","배송 전 연락바랍니다");
		}else if (v == 4){
			$("#comment").attr("value","<%=myorder.FOneItem.Fcomment%>");
		}else{
			$("#comment").attr("value","");
		}
	}

	function isNum()
	{ 
		var frm = document.frmorder;
		val = frm.itemid.value;
		new_val = "";

		for(i=0;i<val.length;i++) {
			char = val.substring(i,i+1);
			if(char<'0' || char>'9') {
				frm.itemid.value = new_val;
				return;
			} else {
				new_val = new_val + char;
			}
		}
	}
</script>
</head>
<body>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<!-- include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">배송지정보 변경</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 <%=orderserial%>]</strong>
				</div>
			</div>

			<form name="frmorder" method="post" action="EditOrderInfo_process.asp">
			<input type="hidden" name="orderserial" value="<%= orderserial %>">
			<fieldset>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>배송지 정보입력</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="recipient">받으시는 분</label></th>
						<td>
							<input type="text" id="recipient" name="reqname" value="<%= myorder.FOneItem.Freqname %>" />
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td>
							<div class="address">
								<div class="row zipcodeField">
									<div class="cell">
										<input type="text" title="우편번호" name="txZip" maxlength="7" value="<%= myorder.FOneItem.Freqzipcode %>" ReadOnly />
									</div>
									<div class="optional">
										<span class="btn02 btw"><a href="#" onclick="jsOpenPopup('/apps/appCom/between/lib/pop_searchzipNew.asp?target=frmorder');">우편번호 찾기</a></span>
									</div>
								</div>
								<div class="basics"><input type="text" title="기본주소" name="txAddr1" value="<%= myorder.FOneItem.Freqzipaddr %>" readonly/></div>
								<div class="detailed"><input type="text" title="상세주소" name="txAddr2" value="<%= myorder.FOneItem.Freqaddress %>" maxlength="100"/></div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td>
							<input type="text" title="휴대전화 앞자리" name="reqhp1" style="width:23%;" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",0) %>" onkeydown="isNum();"/>
							<span class="symbol">-</span>
							<input type="text" title="휴대전화 가운데자리" name="reqhp2" style="width:23%;" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",1) %>" onkeydown="isNum();"/>
							<span class="symbol">-</span>
							<input type="text" title="휴대전화 뒷자리" name="reqhp3" style="width:23%;" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",2) %>" onkeydown="isNum();"/>
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td>
							<input type="text" title="전화번호 앞자리" name="reqphone1" style="width:23%;" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",0) %>" onkeydown="isNum();"/>
							<span class="symbol">-</span>
							<input type="text" title="전화번호 가운데자리" name="reqphone2" style="width:23%;" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",1) %>" onkeydown="isNum();"/>
							<span class="symbol">-</span>
							<input type="text" title="전화번호 뒷자리" name="reqphone3" style="width:23%;" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",2) %>" onkeydown="isNum();"/>
						</td>
					</tr>
					<tr>
						<th scope="row">배송시 유의사항</th>
						<td>
							<div class="row deliveryField">
								<div class="cell">
									<select title="배송시 유의사항 메시지 선택" onchange="chgcmt(this.value);">
										<option value="" <%=chkiif(cmtno="","selected","")%>>선택</option>
										<option value="1" <%=chkiif(cmtno="1","selected","")%>>부재 시 경비실에 맡겨주세요</option>
										<option value="2" <%=chkiif(cmtno="2","selected","")%>>핸드폰으로 연락바랍니다</option>
										<option value="3" <%=chkiif(cmtno="3","selected","")%>>배송 전 연락바랍니다</option>
										<option value="4" <%=chkiif(cmtno="4","selected","")%>>직접입력</option>
									</select>
								</div>
								<div class="optional">
									<input type="text" title="배송시 유의사항" name="comment" id="comment" value="<%=chkiif(cmtno="4",myorder.FOneItem.Fcomment,"") %>" maxlength="100" />
								</div>
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>

				<div class="btnArea">
					<input type="button" value="수정" class="btn02 btw btnBig full" onClick="CheckNSubmit(this.form);"/>
			</fieldset>
			</form>
			<div id="modalCont" class="lyrPopWrap boxMdl midLyr" style="display:none;"></div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
	set myorder = Nothing
%>