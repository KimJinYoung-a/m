<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/cs_giftcard_ordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardImageCls.asp" -->
<%
	'해더 타이틀
	strHeadTitleName = "주문취소"
	
	Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
	Dim myorder, userid, i, giftorderserial, vGubun
	vGubun = requestCheckVar(request("gb"),1)
	userid = getEncLoginUserID()
	giftorderserial = requestCheckvar(request("giftorderserial"),15)
	
	IF vGubun = "" Then vGubun = "1" End If
	
	'==============================================================================
	dim oGiftOrder
	
	set oGiftOrder = new cGiftCardOrder
	
	if (giftorderserial <> "") then
		oGiftOrder.FRectGiftOrderSerial = giftorderserial
	
		if (IsUserLoginOK()) then
			oGiftOrder.getCSGiftcardOrderDetail
		end if
	end if
	
	
	
	
	'==============================================================================
	dim ErrMsg
	
	if (oGiftOrder.FResultCount = 0) or (oGiftOrder.FOneItem.Fuserid <> userid) then
		ErrMsg = "잘못된 접속입니다."
	else
		if (oGiftOrder.FOneItem.Fcancelyn <> "N") then
			ErrMsg = "취소된 주문입니다."
		end if
	
		if (oGiftOrder.FOneItem.Fjumundiv = "7") then
			ErrMsg = "Gift카드가 이미 등록되었습니다. 취소할 수 없습니다."
		end if
	
		if (oGiftOrder.FOneItem.FAccountdiv <> "7") and (oGiftOrder.FOneItem.FAccountdiv <> "100") and (oGiftOrder.FOneItem.FAccountdiv <> "20") then
			ErrMsg = "취소할 수 없습니다.\n\n오류정보 : 잘못된 결제정보"
		end if
	end if
	
	if (ErrMsg <> "") then
	    response.write "<script type='text/javascript'>alert('" + CStr(ErrMsg) + "');</script>"
	    response.write "<script type='text/javascript'>location.href='/my10x10/giftcard/giftcardOrderlist.asp';</script>"
	    dbget.close()	:	response.End
	end if
	
	
	
	'==============================================================================
	dim returnmethod, returnmethodstring, refundrequire, refundstatus
	
	if (oGiftOrder.FOneItem.FAccountdiv = "7") and (oGiftOrder.FOneItem.Fipkumdiv < "4") and (oGiftOrder.FOneItem.Fipkumdiv >= "2") then
		'결제이전 취소
		returnmethod		= "R000"
		returnmethodstring	= "환불없음"
		refundstatus		= "무통장 결제 전, 전체 취소(환불없음)"
		refundrequire 		= "0"
	elseif (oGiftOrder.FOneItem.FAccountdiv = "7") and (oGiftOrder.FOneItem.Fipkumdiv >= "4") and (oGiftOrder.FOneItem.Fipkumdiv <> "9") then
		'결제이전 취소
		returnmethod		= "R007"
		returnmethodstring	= "무통장환불"
		refundstatus		= "무통장 결제 후, 전체 취소"
		refundrequire 		= oGiftOrder.FOneItem.Fsubtotalprice
	elseif (oGiftOrder.FOneItem.FAccountdiv = "20") then
		'실시간이체 취소
		returnmethod		= "R020"
		returnmethodstring	= "실시간이체 취소"
		refundstatus		= returnmethodstring
		refundrequire 		= oGiftOrder.FOneItem.Fsubtotalprice
	elseif (oGiftOrder.FOneItem.FAccountdiv = "100") then
		'결제이전 취소
		returnmethod		= "R100"
		returnmethodstring	= "신용카드 취소"
		refundstatus		= returnmethodstring
		refundrequire 		= oGiftOrder.FOneItem.Fsubtotalprice
	else
		ErrMsg = "취소할 수 없습니다.\n\n오류정보 : 잘못된 결제정보"
	
	    response.write "<script type='text/javascript'>alert('" + CStr(ErrMsg) + "');</script>"
	    response.write "<script type='text/javascript'>location.href='/my10x10/giftcard/giftcardOrderlist.asp';</script>"
	    dbget.close()	:	response.End
	end if

	'designid에 해당하는 이미지 가져오기

	dim GiftCardImageClsObj, imageUrl 	

	set GiftCardImageClsObj = new GiftCardImageCls
	imageUrl = GiftCardImageClsObj.getCardImageUrl(oGiftOrder.FOneItem.FdesignId)

	if imageUrl = "" then
		imageUrl = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png"
	end if			
%>
<script type="text/javascript">
$(function(){
	setTimeout("fnAPPchangPopCaption('기프트카드 주문취소')",100);
});

function jsGiftCardTab(g){
	$(".tabNavV15a > li").removeClass("current");
	$(".tabNavV15a > li").eq(g-1).addClass("current");
	
	$("#gctab1").hide();
	$("#gctab2").hide();
	$("#gctab3").hide();
	$("#gctab4").hide();
	$("#gctab"+g+"").show();
}

function AllCancelProc(frm){
    var returnmethod;

    returnmethod = frm.returnmethod.value;

    //무통장 환불
    if (returnmethod=="R007"){
    	jsGiftCardTab('4');
    	
        if (frm.rebankname.value.length<1){
            alert('환불 받으실 은행을 선택하세요');
            frm.rebankname.focus();
            return
        }

        if (frm.rebankaccount.value.length<8){
            alert('환불 받으실 계좌를 입력하세요');
            frm.rebankaccount.focus();
            return
        }

        if (!IsDigit(frm.rebankaccount.value)){
            alert('계좌번호는 숫자만 가능합니다');
            frm.rebankaccount.focus();
            return
        }

        if (frm.rebankownername.value.length<1){
            alert('예금주를 입력하세요.');
            frm.rebankownername.focus();
            return
        }

    }

    if (confirm('주문을 취소 하시겠습니까?')){
        frm.submit();
    }
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<div class="content myGiftcardV15a" id="contentArea">
			<div class="giftcardDetailV15a inner10">
				<div class="orderSummary box5">
					<%=formatDate(oGiftOrder.FOneItem.Fregdate,"0000.00.00")%> <span>|</span> 주문번호(<%= giftorderserial %>)
					<div class="tMar10"><strong class="cGy1"><%= refundstatus %></strong></div>
				</div>
				<div class="tab02">
					<ul class="tabNavV15a tNum4">
						<li <%=CHKIIF(vGubun="1","class='current'","")%>><a href="" onClick="jsGiftCardTab('1'); return false;">주문카드</a></li>
						<li <%=CHKIIF(vGubun="2","class='current'","")%>><a href="" onClick="jsGiftCardTab('2'); return false;">구매자</a></li>
						<li <%=CHKIIF(vGubun="3","class='current'","")%>><a href="" onClick="jsGiftCardTab('3'); return false;">결제정보</a></li>
						<li <%=CHKIIF(vGubun="4","class='current'","")%>><a href="" onClick="jsGiftCardTab('4'); return false;">환불</a></li>
					</ul>
				</div>
				<div id="gctab1" class="section" style="display:<%=CHKIIF(vGubun="1","block","none")%>;">
					<h2 class="hidden">주문카드</h2>
					<div class="giftcardViewV15a">
						<div class="giftcardPrice">
							<img src="http://fiximage.10x10.co.kr/m/2016/giftcard/tit_10x10_giftcard.png" alt="10X10 GIFT CARD" />
							<b><%= FormatNumber(oGiftOrder.FOneItem.Fsubtotalprice, 0) %></b><span>원</span>
						</div>
						<%
							'이미지 노출 영역												
							Dim vCardImg
							'이미지 가져오는 방식 변경 2019-01-14
							'구매(보낸) 날짜가 소스 수정날짜보다 이르다면 이전에 사용하던 로직 사용
							if FormatDateTime(oGiftOrder.FOneItem.FsendDate, 2) < "2019-01-14" then
								If oGiftOrder.FOneItem.FUserImage <> "" Then
									Response.Write "<div class=""design designTypeA"">"
									vCardImg = staticImgUrl & oGiftOrder.FOneItem.FUserImage
								Else
									Response.Write "<div class=""design"">"
									If oGiftOrder.FOneItem.FdesignId < 600 Then
										vCardImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png"
									Else
										if Right(CStr(oGiftOrder.FOneItem.FdesignId),2) > 46 then
											vCardImg = "http://fiximage.10x10.co.kr/web2018/giftcard/img_giftcard_type_" & Right(CStr(oGiftOrder.FOneItem.FdesignId),2) & ".png"
										Else
											vCardImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_" & Right(CStr(oGiftOrder.FOneItem.FdesignId),2) & ".png"
										end if								
									End IF
								End IF						
							Else
								If oGiftOrder.FOneItem.FUserImage <> "" Then
									Response.Write "<div class=""design designTypeA"">"
									vCardImg = staticImgUrl & oGiftOrder.FOneItem.FUserImage
								Else
									Response.Write "<div class=""design"">"
									vCardImg = imageUrl								
								End IF						
							end if	
						%>
						<img src="<%=vCardImg%>" alt="" />
						<div class="frame"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/bg_photo_frame.png" alt="" /></div>
						</div>
						<div class="giftcardMsg">
							<%=nl2br(CHKIIF(oGiftOrder.FOneItem.FMMSContent="",oGiftOrder.FOneItem.FemailContent,oGiftOrder.FOneItem.FMMSContent))%>
						</div>
					</div>

					<div class="groupTotal box3 tMar15" style="background-color:#fff;">
						<table>
							<caption>주문카드 정보</caption>
							<tbody>
							<tr>
								<th scope="row">전송상태</th>
								<td><%= oGiftOrder.FOneItem.GetCardStatusName %></td>
							</tr>
							<tr>
								<th scope="row">전송일시</th>
								<td>
								<%
									if oGiftOrder.FOneItem.Fipkumdiv<=3 then
										Response.Write "결제 완료 시 인증번호가 전송됩니다."
									else
										Response.Write replace(replace(oGiftOrder.FOneItem.FsendDate,"-","."),"오","- 오")
									end if
								%>
								</td>
							</tr>
							<%
								if (oGiftOrder.FOneItem.FAccountDiv="7") then
								'// 무통장입금일 경우
							%>
								<tr>
									<th scope="row"><%=chkIIF(oGiftOrder.FOneItem.FIpkumDiv>=4,"구매금액","결제하실 금액")%></th>
									<td class="cRd1"><%=FormatNumber(oGiftOrder.FOneItem.Fsubtotalprice,0)%>원</td>
								</tr>
								<% if (returnmethod = "R000") then %>
								<tr>
									<th scope="row">입금하실 계좌</th>
									<td><%=oGiftOrder.FOneItem.FaccountNo%></td>
								</tr>
								<%	end if %>
							<%
								else
								'// 신용카드일경우
							%>
								<tr>
									<th scope="row">구매금액</th>
									<td class="cRd1"><%=FormatNumber(oGiftOrder.FOneItem.Fsubtotalprice,0)%>원</td>
								</tr>
							<%	end if %>
							</tbody>
						</table>
					</div>
				</div>
				<div id="gctab2" class="section" style="display:<%=CHKIIF(vGubun="2","block","none")%>;">
					<h2 class="hidden">구매자</h2>
					<div class="groupTotal box3 tMar15">
						<table>
							<caption>기프트카드 구매자 정보</caption>
							<tbody>
							<tr>
								<th scope="row">주문하신분</th>
								<td><%=oGiftOrder.FOneItem.Fbuyname%></td>
							</tr>
							<tr>
								<th scope="row">이메일 주소</th>
								<td><%=oGiftOrder.FOneItem.Fbuyemail%></td>
							</tr>
							<tr>
								<th scope="row">전화번호</th>
								<td><%=oGiftOrder.FOneItem.FbuyPhone%></td>
							</tr>
							<tr>
								<th scope="row">휴대폰번호</th>
								<td><%=oGiftOrder.FOneItem.Fbuyhp%></td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div id="gctab3" class="section" style="display:<%=CHKIIF(vGubun="3","block","none")%>;">
					<h2 class="hidden">결제정보</h2>
					<div class="groupTotal box3 tMar15">
						<table>
							<caption>기프트카드 결제정보</caption>
							<tbody>
							<tr>
								<th scope="row">결제방법</th>
								<td><%=oGiftOrder.FOneItem.GetAccountdivName%></td>
							</tr>
							<tr>
								<th scope="row">결제확인일시</th>
								<td><%=chkIIF(oGiftOrder.FOneItem.FIpkumDiv>=4,oGiftOrder.FOneItem.Fipkumdate,"-")%></td>
							</tr>
							<%
								if (oGiftOrder.FOneItem.FAccountDiv="7") then
								'// 무통장입금일 경우
							%>
								<tr>
									<th scope="row"><%=chkIIF(oGiftOrder.FOneItem.FIpkumDiv>=4,"구매금액","결제하실 금액")%></th>
									<td><%=FormatNumber(oGiftOrder.FOneItem.Fsubtotalprice,0)%>원</td>
								</tr>
								<% if (returnmethod = "R000") then %>
								<tr>
									<th scope="row">입금하실 계좌</th>
									<td><%=oGiftOrder.FOneItem.FaccountNo%></td>
								</tr>
								<%	end if %>
							<%
								else
								'// 신용카드일경우
							%>
								<tr>
									<th scope="row">구매금액</th>
									<td><%=FormatNumber(oGiftOrder.FOneItem.Fsubtotalprice,0)%>원</td>
								</tr>
							<%	end if %>
							</tbody>
						</table>
					</div>
				</div>
		        <form name="frmCancel" method="post" action="popGiftCardCancel_process.asp" style="margin:0px;">
		        <input type="hidden" name="giftorderserial" value="<%= giftorderserial %>">
		        <input type="hidden" name="mode" value="cancelorder">
		        <input type="hidden" name="returnmethod" value="<%= returnmethod %>" >
		        <input type="hidden" name="refundrequire" value="<%= refundrequire %>"  >
				<div id="gctab4" class="section" style="display:<%=CHKIIF(vGubun="4","block","none")%>;">
					<h2 class="hidden">환불</h2>
					<div class="groupTotal box3 tMar15" style="background-color:#fff;">
							<fieldset>
							<legend>환불 정보 입력 폼</legend>
								<table>
									<caption>환불 정보</caption>
									<tbody>
									<tr>
										<th scope="row">환불 예정 금액</th>
										<td><%= FormatNumber(refundrequire, 0) %>원</td>
									</tr>
									<tr>
										<th scope="row">환불방법</th>
										<td><%= returnmethodstring %></td>
									</tr>
									<% if (returnmethod = "R007") then %>
									<tr>
										<th scope="row"><label for="bankAccount">환불계좌은행</label></th>
										<td>
											<% Call DrawBankCombo("rebankname","") %>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="accountNo">환불계좌번호</label></th>
										<td>
											<input type="text" name="rebankaccount" id="accountNum" value="" maxlength="20" required placeholder="-를 제외하고 입력해주세요." />
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="accountHolder">환불계좌 예금주</label></th>
										<td>
											<input type="text" name="rebankownername" id="accountHolder" value="" maxlength="16" />
										</td>
									</tr>
									<% end if %>
									</tbody>
								</table>
							</fieldset>
					</div>
					<div class="listBox box5">
						<ul>
							<% if (oGiftOrder.FOneItem.Faccountdiv="7") then %>
								<% if ((oGiftOrder.FOneItem.FAccountdiv = "7") and (oGiftOrder.FOneItem.Fipkumdiv < "4") and (oGiftOrder.FOneItem.Fipkumdiv >= "2")) then %>
									<li>결제 전 주문취소이므로 환불 금액이 존재하지 않습니다.</li>
								<% else %>
									<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력 가능합니다.</li>
									<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있습니다.</li>
									<li>접수 후, 영업일 기준 1~2일 내 등록하신 계좌로 환불되며, 환불 시 문자메시지로 안내해 드립니다.</li>
								<% end if %>
							<% else %>
									<li>결제 후 취소시 신용카드 취소는 카드 승인 취소로 접수되며, 실시간 이체는 이체 취소로 접수됩니다.</li>
									<li>카드 및 실시간 이체 취소는 접수 후 영업일 기준 최대 5일 소요될 수 있습니다.</li>
							<% end if %>

						</ul>
					</div>
				</div>
				</form>
				<div class="section">
					<div class="groupTotalWrap tMar30">
						<h3><span>총 결제금액</span></h3>
						<div class="groupTotal box3 tMar15" style="background-color:#fff;">
							<table>
								<caption>총 결제금액 정보</caption>
								<tbody>
								<tr>
									<th scope="row">총 결제금액</th>
									<td class="cRd1"><%= FormatNumber(oGiftOrder.FOneItem.Fsubtotalprice,0) %>원</td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btnGroupV15a tMar30">
						<div class="button btB1 btRed cWh1 w100p"><button type="button" onclick="AllCancelProc(document.frmCancel); return false;">주문취소</button></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<% Set oGiftOrder = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->