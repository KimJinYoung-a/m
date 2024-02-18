<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 이벤트 당첨 안내
' History : 2014-09-01 이종화 
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventsbeasongcls.asp" -->
<%
dim id, userid
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

dim i

dim hpArr,hp1,hp2,hp3
dim phoneArr,phone1,phone2,phone3

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
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<title>10x10: 이벤트 당첨 배송지 입력</title>
	<script type='text/javascript'>
	function searchzip(type){
		window.open('/lib/searchzip.asp?target=' + type, 'searchzip', '');
	}

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
			document.infoform.txZip1.focus();
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
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="prevPage">
					<a href="javascript:history.back(-1);"><em class="elmBg">이전으로</em></a>
				</div>
				<!--마이텐바이텐-->
				<div id="my2">
					<div id="my2Tit">
						<h2>이벤트 당첨 배송지 입력</h2>
					</div>
					<% If vGubun = "view" Then %>
					<!--이벤트당첨 배송지-->
					<div id="myevent">
						<div id="myshipInfo">
							<dl>
								<dt>이벤트명</dt>
								<dd><%= ibeasong.FOneItem.Fgubunname %></dd>
								<dt>당첨상품</dt>
								<dd><%= ibeasong.FOneItem.FPrizeTitle %>&nbsp;</dd>
								<dt>당첨자 성함</dt>
								<dd><%= ibeasong.FOneItem.Fusername %></dd>
								<dt>수령인 성함</dt>
								<dd><%= ibeasong.FOneItem.Freqname %></dd>
								<dt>전화번호</dt>
								<dd><%= phone1 %>-<%= phone2 %>-<%= phone3 %></dd>
								<dt>휴대전화</dt>
								<dd><%= hp1 %>-<%= hp2 %>-<%= hp3 %></dd>
								<dd class="line"></dd>
								<dt>수령인 주소</dt>
								<dd>
									<p class="tMar05"><%= ibeasong.FOneItem.Freqzipcode %>-<%= ibeasong.FOneItem.Freqzipcode2 %></p>
									<p class="tMar05"><%= ibeasong.FOneItem.Freqaddress1 %>&nbsp;<%= ibeasong.FOneItem.Freqaddress2 %></p>
								</dd>
								<dd class="line"></dd>
								<dt class="etc">기타사항</dt>
								<dd class="etc"><%= ibeasong.FOneItem.Freqetc %></dd>
							</dl>
						</div>
						<div class="btnArea">
							<span class="btn btn1 redB w90B"><a href="javascript:history.back();">확인</a></span>
						</div>
					</div>
					<!--이벤트당첨 배송지 입력-->
					<% ElseIf vGubun = "edit" Then %>
					<form name="infoform" method="post" action="/my10x10/myeventmasteredit_process.asp">
					<input type="hidden" name="id" value="<%= id %>">
					<input type="hidden" name="ePC" value="<%=ibeasong.FOneItem.FPCode%>"/>
					<div id="myevent">
						<div id="myshipInfo">
							<dl>
								<dt>이벤트명</dt>
								<dd><%= ibeasong.FOneItem.Fgubunname %></dd>
								<dt>당첨상품</dt>
								<dd><%= ibeasong.FOneItem.FPrizeTitle %>&nbsp;</dd>
								<dt>당첨자 성함</dt>
								<dd><input name="username" type="text" class="text" style="width:80%" value="<%= ibeasong.FOneItem.Fusername %>" /></dd>
								<dt>수령인 성함</dt>
								<dd><input name="reqname" type="text" class="text" style="width:80%" value="<%= ibeasong.FOneItem.Freqname %>" /></dd>
								<dt>전화번호</dt>
								<dd>
									<input name="reqphone1" type="tel" class="text" style="width:20%" maxlength="3" value="<%= phone1 %>"/>
									 - 
									<input name="reqphone2" type="tel" class="text" style="width:20%" maxlength="4" value="<%= phone2 %>"/>
									 - 
									<input name="reqphone3" type="tel" class="text" style="width:20%" maxlength="4" value="<%= phone3 %>"/>
								</dd>
								<dt>휴대전화</dt>
								<dd>
									<input name="reqhp1" type="tel" class="text" style="width:20%" maxlength="3" value="<%= hp1 %>"/>
									 - 
									<input name="reqhp2" type="tel" class="text" style="width:20%" maxlength="4" value="<%= hp2 %>"/>
									 - 
									<input name="reqhp3" type="tel" class="text" style="width:20%" maxlength="4" value="<%= hp3 %>"/>
								</dd>
								<dd class="line"></dd>
								<dt>수령인 주소</dt>
								<dd class="fs16">
									<p>
										<input name="txZip" id="txZip" type="text"  value="<%= Trim(ibeasong.FOneItem.Freqzipcode) %>" readonly class="text" style="width:60px;" />
										<span class="btn btn3 gryB w80B"><a href="" onclick="TnFindZipNew('infoform',''); return false;">우편번호 찾기</a></span>
									</p>
									<p class="tMar05"><input name="txAddr1" id="txAddr1" type="text" class="text" style="width:80%" value="<%= ibeasong.FOneItem.Freqaddress1 %>" readonly></p>
									<p class="tMar05"><input name="txAddr2" id="txAddr2" type="text" class="text" style="width:80%" value="<%= ibeasong.FOneItem.Freqaddress2 %>" maxlength="80"></p>
								</dd>
								<dd class="line"></dd>
								<dt class="etc">기타사항</dt>
								<dd class="etc"><textarea name="reqetc" cols="40" rows="5" class="postinput" style="width:97%; height:60px;"><%= ibeasong.FOneItem.Freqetc %></textarea></dd>
							</dl>
						</div>
						<div class="btnArea">
							<span class="btn btn1 redB w90B"><a href="<% if (ibeasong.FOneItem.IsSended) then %>javascript:alert('발송된 내역은 수정 하실 수 없습니다.');<% else %>javascript:gotowrite();<% end if %>">확인</a></span>
							<span class="btn btn1 gryB w90B"><a href="javascript:history.back();">취소</a></span>
						</div>
					</div>
					</form>
					<% End If %>
				</div>
			</div>
			<!-- //content area -->
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
set ibeasong = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

