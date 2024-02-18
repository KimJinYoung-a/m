<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 이벤트 당첨 안내
' History : 2014.09.29 한용민 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventsbeasongcls.asp" -->
<%
dim id, userid, i, hpArr,hp1,hp2,hp3, phoneArr,phone1,phone2,phone3
	id = requestCheckVar(request("id"),10)

userid = getEncLoginUserID

dim ibeasong
set ibeasong = new CEventsBeasong
	ibeasong.FRectUserID = userid
	ibeasong.FRectId = id
	ibeasong.GetOneWinnerItem

if ibeasong.FResultCount<1 then
	response.write "<script>alert('검색된 내역이 없습니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

if IsNULL(ibeasong.FOneItem.Freqphone) then ibeasong.FOneItem.Freqphone=""
if IsNULL(ibeasong.FOneItem.Freqhp) then ibeasong.FOneItem.Freqhp=""
if IsNULL(ibeasong.FOneItem.Freqzipcode) then ibeasong.FOneItem.Freqzipcode=""

phoneArr = split(ibeasong.FOneItem.Freqphone,"-")
hpArr = split(ibeasong.FOneItem.Freqhp,"-")

if UBound(hpArr)>=0 then hp1 = hpArr(0)
if UBound(hpArr)>=1 then hp2 = hpArr(1)
if UBound(hpArr)>=2 then hp3 = hpArr(2)

if UBound(phoneArr)>=0 then phone1 = phoneArr(0)
if UBound(phoneArr)>=1 then phone2 = phoneArr(1)
if UBound(phoneArr)>=2 then phone3 = phoneArr(2)

Dim vGubun
If ibeasong.FOneItem.Fprizetype = "3" or ibeasong.FOneItem.Fprizetype = "5" Then
	IF ibeasong.FOneItem.FStatus = 0 THEN
		vGubun = "edit"
	Else
        IF ibeasong.FOneItem.Fsongjangno <> "" THEN 
        	vGubun = "view"
        ELSE
        	if DateDiff("d",ibeasong.FOneItem.FreqDeliverDate,date)<-2 then
        		vGubun = "edit"
        	else
        		vGubun = "view"
        	end if
        END IF
	End IF
End If
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css?v=1.2">
<script type='text/javascript'>

function gotowrite(){
	if(document.infoform.username.value == ""){
		alert("당첨자성함을 입력해주세요.");
		document.infoform.username.focus();
	}

	else if(document.infoform.reqname.value == ""){
		alert("받으시는 분의 이름을 입력해주세요.");
		document.infoform.reqname.focus();
	}

	else if(document.infoform.reqphone1.value == "" || document.infoform.reqphone2.value == "" || document.infoform.reqphone3.value == ""){
		alert("받으시는 분의 전화번호를 입력해주세요.");
		document.infoform.reqphone1.focus();
	}

	else if(document.infoform.reqhp1.value == "" || document.infoform.reqhp2.value == "" || document.infoform.reqhp3.value == ""){
		alert("받으시는 분의 핸드폰 번호를 입력해주세요.");
		document.infoform.reqphone1.focus();
	}

	else if(document.infoform.txZip.value == ""){
		alert("받으시는 분의 주소를 입력해주세요.");
		document.infoform.txZip.focus();
	}

	else if(document.infoform.txAddr2.value == ""){
		alert("받으시는 분의 나머지주소를 입력해주세요.");
		document.infoform.reqaddr2.focus();
	}

	else{
		if (confirm('입력 내용이 정확합니까?')){
			document.infoform.submit();
		}
	}
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<!-- #content -->
			<div id="content">
				<div class="inner tPad15">
					<div class="main-title">
						<h1 class="title"><span class="label">이벤트 당첨 배송지 입력</span></h1>
					</div>
					
					<% If vGubun = "view" Then %>
						<!--이벤트당첨 배송지-->
						<div class="input-block">
							<label for="name" class="input-label">이벤트명</label>
							<div class="input-controls ftMid lPad05"><%= ibeasong.FOneItem.Fgubunname %></div>
						</div>
						<div class="input-block">
							<label for="name" class="input-label">당첨상품</label>
							<div class="input-controls ftMid lPad05"><%= ibeasong.FOneItem.FPrizeTitle %></div>
						</div>
						<div class="input-block">
							<label for="name" class="input-label">당첨자 성함</label>
							<div class="input-controls ftMid lPad05"><%= ibeasong.FOneItem.Fusername %></div>
						</div>
						<div class="input-block">
							<label for="name" class="input-label">수령자 성함</label>
							<div class="input-controls ftMid lPad05"><%= ibeasong.FOneItem.Freqname %></div>
						</div>
						<div class="input-block">
							<label for="phone" class="input-label">전화번호</label>
							<div class="input-controls ftMid lPad05"><%= phone1 %>-<%= phone2 %>-<%= phone3 %></div>
						</div>
						<div class="input-block">
							<label for="phone" class="input-label">휴대전화</label>
							<div class="input-controls ftMid lPad05"><%= hp1 %>-<%= hp2 %>-<%= hp3 %></div>
						</div>
						<div class="input-block">
							<label for="zipcode" class="input-label">수령인 주소</label>
							<div class="input-controls ftMid lPad05">
								<%= ibeasong.FOneItem.Freqzipcode %>-<%= ibeasong.FOneItem.Freqzipcode2 %>
							</div>
						</div>
						<div class="input-block no-label">
							<label for="address1" class="input-label">상세주소</label>
							<div class="input-controls ftMid lPad05">
								<%= ibeasong.FOneItem.Freqaddress1 %>
							</div>
						</div>
						<div class="input-block no-label">
							<label for="address2" class="input-label">상세주소</label>
							<div class="input-controls ftMid lPad05">
								<%= ibeasong.FOneItem.Freqaddress2 %>
							</div>
						</div>
						<div class="input-block" style="height:150px;">
							<label for="address2" class="input-label" style="height:150px;">기타사항</label>
							<div class="input-controls ftMid lPad05">
								<%= ibeasong.FOneItem.Freqetc %>
							</div>
						</div>
	
						<div class="btnWrap ct topGyBdr tPad15 tMar20">
							<span class="button btM1 btRed cWh1"><a href="#" onclick="history.back(); return false;">확인</a></span>
							<span class="button btM1 btGry2 cWh1"><a href="#" onclick="history.back(); return false;">취소</a></span>
						</div>

					<% ElseIf vGubun = "edit" Then %>
						<!--이벤트당첨 배송지 입력-->
						<form name="infoform" method="post" action="/apps/appCom/wish/web2014/my10x10/myeventmasteredit_process.asp">
						<input type="hidden" name="id" value="<%= id %>">
						<input type="hidden" name="ePC" value="<%=ibeasong.FOneItem.FPCode%>"/>
						<div class="input-block">
							<label for="name" class="input-label">이벤트명</label>
							<div class="input-controls ftMid lPad05"><%= ibeasong.FOneItem.Fgubunname %></div>
						</div>
						<div class="input-block">
							<label for="name" class="input-label">당첨상품</label>
							<div class="input-controls ftMid lPad05"><%= ibeasong.FOneItem.FPrizeTitle %></div>
						</div>
						<div class="input-block">
							<label for="name" class="input-label">당첨자 성함</label>
							<div class="input-controls">
								<input type="text" name="username" value="<%= ibeasong.FOneItem.Fusername %>" class="form full-size">
							</div>
						</div>
						<div class="input-block">
							<label for="name" class="input-label">수령자 성함</label>
							<div class="input-controls">
								<input type="text" name="reqname" value="<%= ibeasong.FOneItem.Freqname %>" class="form full-size">
							</div>
						</div>
						<div class="input-block">
							<label for="phone" class="input-label">전화번호</label>
							<div class="input-controls phone">
								<div><input type="tel" name="reqphone1" maxlength="3" value="<%= phone1 %>" /></div>
								<div><input type="tel" name="reqphone2" maxlength="4" value="<%= phone2 %>" /></div>
								<div><input type="tel" name="reqphone3" maxlength="4" value="<%= phone3 %>" /></div>
							</div>
						</div>
						<div class="input-block">
							<label for="phone" class="input-label">휴대전화</label>
							<div class="input-controls phone">
								<div><input type="tel" name="reqhp1" maxlength="3" value="<%= hp1 %>" /></div>
								<div><input type="tel" name="reqhp2" maxlength="4" value="<%= hp2 %>" /></div>
								<div><input type="tel" name="reqhp3" maxlength="4" value="<%= hp3 %>" /></div>
							</div>
						</div>
						<div class="input-block">
							<label for="zipcode" class="input-label">수령인 주소</label>
							<div class="input-controls zipcode">
								<div class="w60p"><input type="text" name="txZip" value="<%= Trim(ibeasong.FOneItem.Freqzipcode) %>" readonly class="form full-size" /></div>
								<button onclick="TnFindZipNew('infoform',''); return false;" class="btn type-c btn-findzipcode side-btn">우편번호검색</button>
							</div>
						</div>
						<div class="input-block no-label">
							<label for="address1" class="input-label">상세주소</label>
							<div class="input-controls">
								<input type="text" name="txAddr1" value="<%= ibeasong.FOneItem.Freqaddress1 %>" readonly id="address1" class="form full-size" />
							</div>
						</div>
						<div class="input-block no-label">
							<label for="address2" class="input-label">상세주소</label>
							<div class="input-controls">
								<input type="text" name="txAddr2" value="<%= ibeasong.FOneItem.Freqaddress2 %>" maxlength="80" id="address2" class="form full-size" />
							</div>
						</div>
						<div class="input-block" style="height:150px;">
							<label for="address2" class="input-label" style="height:150px;">기타사항</label>
							<div class="input-controls" style="height:150px;">
								<textarea name="reqetc" class="form full-size"><%= ibeasong.FOneItem.Freqetc %></textarea>
							</div>
						</div>
	
						<div class="btnWrap ct topGyBdr tPad15 tMar20">
							<span class="button btM1 btRed cWh1">
								<a href="#" onclick="<% if (ibeasong.FOneItem.IsSended) then %>alert('발송된 내역은 수정 하실 수 없습니다.'); return false;<% else %>gotowrite(); return false;<% end if %>">
								확인</a></span>
							<span class="button btM1 btGry2 cWh1"><a href="#" onclick="history.back(); return false;">취소</a></span>
						</div>
						</form>
					<% end if %>
				</div>
			</div>
			<!-- #content -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>

<%
set ibeasong = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->