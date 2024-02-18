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
<!-- #include virtual="/lib/classes/giftcard/giftcard_ordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardImageCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%
	'해더 타이틀
	strHeadTitleName = "주문상세조회"

	Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
	Dim myorder, userid, i, giftorderserial, vGubun, vSendCnt
	vGubun = requestCheckVar(request("gb"),1)
	userid = getEncLoginUserID()
	giftorderserial = requestCheckvar(request("idx"),15)
	
	IF vGubun = "" Then vGubun = "1" End If
	
	set myorder = new cGiftcardOrder
	myorder.FUserID = userid
	myorder.Fgiftorderserial = giftorderserial
	myorder.getGiftcardOrderDetail
	
	
	If myorder.FResultcount > 0 Then
		IsValidOrder = true
	Else
		Response.Write "<script language='javascript'>alert('잘못된 주문번호 입니다.');</script>"
		dbget.close()
		Response.End
	End If
	
	dim returnmethod
	if (myorder.FOneItem.FAccountdiv = "7") and (myorder.FOneItem.Fipkumdiv < "4") and (myorder.FOneItem.Fipkumdiv >= "2") then
		'결제이전 취소
		returnmethod		= "R000"
	elseif (myorder.FOneItem.FAccountdiv = "7") and (myorder.FOneItem.Fipkumdiv >= "4") and (myorder.FOneItem.Fipkumdiv <> "9") then
		'결제이전 취소
		returnmethod		= "R007"
	elseif (myorder.FOneItem.FAccountdiv = "20") then
		'실시간이체 취소
		returnmethod		= "R020"
	elseif (myorder.FOneItem.FAccountdiv = "100") then
		'결제이전 취소
		returnmethod		= "R100"
	end if
	
	vSendCnt = getGiftCardSMSsendcnt(giftorderserial)

	'designid에 해당하는 이미지 가져오기

	dim GiftCardImageClsObj, imageUrl 	

	set GiftCardImageClsObj = new GiftCardImageCls
	imageUrl = GiftCardImageClsObj.getCardImageUrl(myorder.FOneItem.FdesignId)

	if imageUrl = "" then
		imageUrl = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png"
	end if	
%>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	/* layer */
	$("#lyGiftcardUrl").hide();

	$(".giftcardSnsV15a ul li.url a").click(function(){
		$("#lyGiftcardUrl").show();
		$("#mask").show();
		var val = $("#lyGiftcardUrl").offset();
		$("html,body").animate({scrollTop:val.top},200);
	});

	$("#lyGiftcardUrl .btnclose, #mask").click(function(){
		$("#lyGiftcardUrl").hide();
		$("#mask").slideUp();
	});
});

function jsGiftCardTab(g){
	$(".tabNav > li").removeClass("current");
	$(".tabNav > li").eq(g-1).addClass("current");
	
	$("#gctab1").hide();
	$("#gctab2").hide();
	$("#gctab3").hide();
	$("#gctab"+g+"").show();
}

//인증코드 MMS재전송
function CardCodeResend(){
<% If vSendCnt >= 2 Then %>
	alert("메시지 재전송은 2회까지 가능합니다.\n모두 사용하셨습니다.");
	return false;
<% Else %>
	if(confirm("메시지 재전송은 2회까지 가능합니다.\n메시지를 전송하시겠습니까?\n( <%=(2-vSendCnt)%>회 남았습니다 )") == true) {
		frmprt.action = "/my10x10/giftcard/do_GiftCodeResend.asp";
		frmprt.target = "iframeProc";
		frmprt.submit();
	} else {
		return false;
	}
<% End If %>
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content myGiftcardV15a" id="contentArea">
			<div class="giftcardDetailV15a inner10">
				<p class="orderSummary box5"><%=formatDate(myorder.FOneItem.Fregdate,"0000.00.00")%> <span>|</span> 주문번호(<%=giftorderserial%>)</p>
				<div class="tab02">
					<ul class="tabNav tNum3">
						<li <%=CHKIIF(vGubun="1","class='current'","")%>><a href="" onClick="jsGiftCardTab('1'); return false;">주문카드</a></li>
						<li <%=CHKIIF(vGubun="2","class='current'","")%>><a href="" onClick="jsGiftCardTab('2'); return false;">구매자</a></li>
						<li <%=CHKIIF(vGubun="3","class='current'","")%>><a href="" onClick="jsGiftCardTab('3'); return false;">결제정보</a></li>
					</ul>
				</div>
				<span id="gctab1" style="display:<%=CHKIIF(vGubun="1","block","none")%>;">
					<h2 class="hidden">주문카드</h2>

					<div class="giftcardViewV15a">
						<% If myorder.FOneItem.Fcancelyn <> "N" Then %>
						<div class="cancelMsg">
							<p><strong><span>주문이 취소되었습니다.</span></strong></p>
						</div>
						<% End If %>
						<div class="giftcardPrice">
							<img src="http://fiximage.10x10.co.kr/m/2016/giftcard/tit_10x10_giftcard.png" alt="10X10 GIFT CARD" />
							<b><%=FormatNumber(myorder.FOneItem.FcardSellCash,0)%></b><span>원</span>
						</div>
						<%
							'이미지 노출 영역												
							Dim vCardImg
							'이미지 가져오는 방식 변경 2019-01-14
							'구매(보낸) 날짜가 소스 수정날짜보다 이르다면 이전에 사용하던 로직 사용
							if FormatDateTime(myorder.FOneItem.FsendDate, 2) < "2019-01-14" then
								If myorder.FOneItem.FUserImage <> "" Then
									Response.Write "<div class=""design designTypeA"">"
									vCardImg = staticImgUrl & myorder.FOneItem.FUserImage
								Else
									Response.Write "<div class=""design"">"
									If myorder.FOneItem.FdesignId < 600 Then
										vCardImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_05.png"
									Else
										if Right(CStr(myorder.FOneItem.FdesignId),2) > 46 then
											vCardImg = "http://fiximage.10x10.co.kr/web2018/giftcard/img_giftcard_type_" & Right(CStr(myorder.FOneItem.FdesignId),2) & ".png"
										Else
											vCardImg = "http://fiximage.10x10.co.kr/web2015/giftcard/img_giftcard_type_" & Right(CStr(myorder.FOneItem.FdesignId),2) & ".png"
										end if								
									End IF
								End IF						
							Else
								If myorder.FOneItem.FUserImage <> "" Then
									Response.Write "<div class=""design designTypeA"">"
									vCardImg = staticImgUrl & myorder.FOneItem.FUserImage
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
							<%=nl2br(CHKIIF(myorder.FOneItem.FMMSContent="",myorder.FOneItem.FemailContent,myorder.FOneItem.FMMSContent))%>
						</div>
					</div>
					<div class="groupTotal box3 tMar15" style="background-color:#fff;">
						<table>
							<caption>주문카드 정보</caption>
							<tbody>
							<tr>
								<th scope="row">주문상태</th>
								<td>
					            <%
					            	If (myorder.FOneItem.FCancelyn<>"N") Then
					                	Response.Write "취소주문"
					            	Else
					                	Response.Write myorder.FOneItem.GetJumunDivName
					            	End If
					            %>
								</td>
							</tr>
							<tr>
								<th scope="row">전송일시</th>
								<td>
								<%
									if myorder.FOneItem.Fipkumdiv<=3 then
										Response.Write "결제 완료 시 인증번호가 전송됩니다."
									else
										Response.Write replace(replace(myorder.FOneItem.FsendDate,"-","."),"오","- 오")
									end if
								%>
								</td>
							</tr>
							<%
								if (myorder.FOneItem.FAccountDiv="7") then
								'// 무통장입금일 경우
							%>
								<tr>
									<th scope="row"><%=chkIIF(myorder.FOneItem.FIpkumDiv>=4,"구매금액","결제하실 금액")%></th>
									<td class="cRd1"><%=FormatNumber(myorder.FOneItem.Fsubtotalprice,0)%>원</td>
								</tr>
								<% if (returnmethod = "R000") then %>
								<tr>
									<th scope="row">입금하실 계좌</th>
									<td><%=myorder.FOneItem.FaccountNo%></td>
								</tr>
								<%	end if %>
							<%
								else
								'// 신용카드일경우
							%>
								<tr>
									<th scope="row">구매금액</th>
									<td class="cRd1"><%=FormatNumber(myorder.FOneItem.Fsubtotalprice,0)%>원</td>
								</tr>
							<%	end if %>
							</tbody>
						</table>
					</div>
					<% If myorder.FOneItem.Fjumundiv>=3 and myorder.FOneItem.Fjumundiv<7 and myorder.FOneItem.FCancelyn="N" Then
						
						'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
						Dim vTitle, vLink, vPre, vImg
						vTitle = myorder.FOneItem.Fbuyname & "님이 텐바이텐기프트카드를 보내셨습니다."
						vLink = wwwUrl & "/giftcard/view.asp?gc=" & rdmSerialEnc(myorder.FOneItem.FmasterCardCode) & ""
						vImg = vCardImg
						
						dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
						snpTitle = Server.URLEncode(vTitle)
						snpLink = Server.URLEncode(vLink)
						snpImg = Server.URLEncode(vImg)
					%>
					<div class="giftcardSnsV15a">
						<h3><span>기프트카드 재전송</span></h3>
						<ul>
							<li class="sms"><a href="" onclick="CardCodeResend(); return false;"><span></span>SMS</a></li>
							<li class="kakaotalk"><a href="" onClick="fnAPPshareKakao('etc','텐바이텐 기프트카드\n<%=vTitle%>','<%=vLink%>','<%=vLink%>','<%="url="&vLink%>','<%=vImg%>','','','','');return false;"><span></span>카카오톡</a></li>
							<script>
							$(function(){
								//카카오 SNS 공유
								Kakao.init('c967f6e67b0492478080bcf386390fdd');
							
								// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
								Kakao.Link.createTalkLinkButton({
								  //1000자 이상일경우 , 1000자까지만 전송 
								  //메시지에 표시할 라벨
								  container: '#kakaoa',
								  label: '<%=vTitle%>',
								  image: {
									//500kb 이하 이미지만 표시됨
									src: '<%=vImg%>',
									width: '200',
									height: '121'
								  },
								  webButton: {
									text: '기프트카드 등록가기',
									url: '<%=vLink%>'
								  }
								});
							});
							</script>
							<li class="line"><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span></span>라인</a></li>
							<li class="url"><a href="" onClick="return false;"><span></span>URL</a></li>
						</ul>
					</div>
					<div id="lyGiftcardUrl" class="lyGiftcardUrlV15a">
						<fieldset>
							<div class="field">
								<label for="shareUrl">URL을 길게 눌러 전체 선택 후 복사해주세요</label>
								<input type="text" id="shareUrl" value="http://m.10x10.co.kr/giftcard/view.asp?gc=<%=rdmSerialEnc(myorder.FOneItem.FmasterCardCode)%>" />
								<div class="button btB1 btRed cWh1 btnclose"><button type="button">닫기</button></div>
							</div>
						</fieldset>
					</div>
					<div id="mask" style="display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);"></div>
					<% end if %>
				</span>
				<div id="gctab2" class="groupTotal box3 tMar15" style="display:<%=CHKIIF(vGubun="2","block","none")%>;">
					<table>
						<caption>기프트카드 구매자 정보</caption>
						<tbody>
						<tr>
							<th scope="row">주문하신분</th>
							<td><%=myorder.FOneItem.Fbuyname%></td>
						</tr>
						<tr>
							<th scope="row">이메일 주소</th>
							<td><%=myorder.FOneItem.Fbuyemail%></td>
						</tr>
						<tr>
							<th scope="row">전화번호</th>
							<td><%=myorder.FOneItem.FbuyPhone%></td>
						</tr>
						<tr>
							<th scope="row">휴대폰번호</th>
							<td><%=myorder.FOneItem.Fbuyhp%></td>
						</tr>
						</tbody>
					</table>
				</div>
				<div id="gctab3" class="groupTotal box3 tMar15" style="display:<%=CHKIIF(vGubun="3","block","none")%>;">
					<table>
						<caption>기프트카드 결제정보</caption>
						<tbody>
						<tr>
							<th scope="row">결제방법</th>
							<td><%=myorder.FOneItem.GetAccountdivName%></td>
						</tr>
						<tr>
							<th scope="row">결제확인일시</th>
							<td><%=chkIIF(myorder.FOneItem.FIpkumDiv>=4,myorder.FOneItem.Fipkumdate,"-")%></td>
						</tr>
						<%
							if (myorder.FOneItem.FAccountDiv="7") then
							'// 무통장입금일 경우
						%>
							<tr>
								<th scope="row"><%=chkIIF(myorder.FOneItem.FIpkumDiv>=4,"구매금액","결제하실 금액")%></th>
								<td class="cRd1"><%=FormatNumber(myorder.FOneItem.Fsubtotalprice,0)%>원</td>
							</tr>
							<% if (returnmethod = "R000") then %>
							<tr>
								<th scope="row">입금하실 계좌</th>
								<td><%=myorder.FOneItem.FaccountNo%></td>
							</tr>
							<%	end if %>
						<%
							else
							'// 신용카드일경우
						%>
							<tr>
								<th scope="row">구매금액</th>
								<td class="cRd1"><%=FormatNumber(myorder.FOneItem.Fsubtotalprice,0)%>원</td>
							</tr>
						<%	end if %>
						</tbody>
					</table>
				</div>
				<form name="frmprt" method="post" action="" style="margin:0px;">
				<input type="hidden" name="idx" value="<%= giftOrderserial %>">
				</form>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
<iframe src="about:blank" id="iframeProc" name="iframeProc" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</body>
</html>
<% Set myorder = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->