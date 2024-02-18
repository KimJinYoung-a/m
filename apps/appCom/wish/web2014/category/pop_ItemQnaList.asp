<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 상품문의 / 목록
' History : 2015-02-13 허진원
'####################################################

	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)
	Dim page : page = RequestCheckVar(request("cpg"),10)
	dim mode : mode = RequestCheckVar(request("mode"),2)
	dim idx : idx = getNumeric(requestCheckVar(request("id"),8))
	if page="" then page=1

	if itemid="" or itemid="0" then
		Call Alert_Return("상품번호가 없습니다.")
		dbget.Close(): response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_Return("잘못된 상품번호입니다.")
		dbget.Close(): response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end If

	'// 쓰기모드로 진입시 로그인 확인
	if mode="wr" and (Not IsUserLoginOK) then
		dim checklogin_backpath
	  	dim strBackPath, strGetData, strPostData	
	   		strBackPath 	= request.ServerVariables("URL")
	   		strGetData  	= request.ServerVariables("QUERY_STRING")
	   
	        checklogin_backpath = "backpath="+ server.URLEncode(strBackPath) + "&strGD=" +  server.URLEncode(strGetData) + "mode=wr"
			response.redirect "/apps/appCom/wish/web2014/login/login.asp?vType=G&" + checklogin_backpath
'			Response.redirect "/login/login.asp?" + checklogin_backpath
	       dbget.Close:  response.end
	end if

	dim LoginUserid, usermail
	LoginUserid = getLoginUserid()
	usermail = GetLoginUserEmail()

	'// 상품 기본 정보 접수
	dim oItem
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_Return("존재하지 않는 상품입니다.")
		dbget.Close(): response.End
	end if

	if oItem.Prd.Fisusing="N" then
		Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
		dbget.Close(): response.End
	end if

	'상품문의 접수(수정시)
	dim emailok, smsok, userhp, contents ,secretYN
	if idx<>"" then
		dim myitemqna
		set myitemqna = new CItemQna
		myitemqna.FPageSize = 1
		myitemqna.FCurrpage = 1
		myitemqna.FRectUserID = LoginUserid
		myitemqna.FRectId = idx
    	myitemqna.GetMyItemQnaList
    	If myitemqna.FResultCount>0 Then
    		emailok = myitemqna.FItemList(0).Femailok
    		usermail = myitemqna.FItemList(0).Fusermail
    		smsok = myitemqna.FItemList(0).Fsmsok
    		userhp = myitemqna.FItemList(0).Fuserhp
    		contents = myitemqna.FItemList(0).FContents
			secretYN = myitemqna.FItemList(0).FsecretYN
    	else
			Call Alert_Return("없거나 삭제된 문의입니다.")
			dbget.Close(): response.End
    	end if
    	set myitemqna = Nothing
	end if

	'//상품 문의
	Dim oQna, i
	set oQna = new CItemQna

	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0) Then
		oQna.FRectItemID = itemid
		oQna.FPageSize = 10
		oQna.FCurrpage = page
		oQna.ItemQnaList
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: 상품 문의</title>
<script type="text/javascript">
function fnGoQnaPage(page) {
	self.location.href="pop_ItemQnaList.asp?itemid=<%=itemid%>&cpg="+page;
}

function fnGoQnaTab(mode) {
	if(mode=="wr") {
	<%
		If Not(IsUserLoginOK) Then
			Response.Write "calllogin();" & vbCrLf
			Response.Write "return false;" & vbCrLf
		else
	%>
		$("#cmtWrite").show();
		$("#cmtView").hide();
		$(".tabNav li").removeClass("current").eq(0).addClass("current");
		$("#lytFltBar").show();
	<%
		End If
	%>
	} else {
		$("#cmtWrite").hide();
		$("#cmtView").show();
		$(".tabNav li").removeClass("current").eq(1).addClass("current");
		$("#lytFltBar").hide();
	}
}

function fnQnaActionSet() {
	$(".qnaList li .a").hide();
	$(".qnaList li").each(function(){
		if ($(this).children(".a").length > 0) {
			$(this).children('.q').addClass("isA");
		}
	});

	$(".qnaList li .q").click(function(){
		$(".qnaList li .a").hide();
		if($(this).next().is(":hidden")){
			$(this).parent().children('.a').show();
		}else{
			$(this).parent().children('.a').hide();
		};
	});
}

// 상품 문의 등록
function GotoItemQnA(){
		var frm = document.qnaform;

		if((frm.emailok.checked)&&(!validEmail(frm.usermail))){
			return false;
		}

//		if((frm.smsok.checked)&&(frm.userhp.value=="")){
//			alert("답변SMS를 받기 위해선 핸드폰 번호를 적어주셔야 합니다.");
//			frm.userhp.focus();
//			return false;
//		}

		if(frm.contents.value.length < 1){
			alert("내용을 적어주셔야 합니다.");
			frm.contents.focus();
			return false;
		}

		if(confirm("상품에 대해 문의 하시겠습니까?")){
			frm.action = "/apps/appcom/wish/web2014/my10x10/doitemqna.asp";
			frm.submit();
			return true;
		} else {
			return false;
		}
}

// 상품 문의 수정
function modiItemQna(idx) {
	location.href="/category/pop_itemQnAList.asp?itemid=<%=itemid%>&mode=wr&id="+idx;
}
// 상품 문의 삭제
function delItemQna(idx){
	if(confirm("상품문의를 삭제 하시겠습니까?")){
		location.href="/apps/appcom/wish/web2014/my10x10/doitemqna.asp?id="+idx+"&itemid=<%=itemid%>&mode=del";
	}
}

$(function(){
	$(".tabContent").hide();
	$(".tabContent").eq(<%=chkIIF(mode="wr","0","1")%>).show();

	fnQnaActionSet();
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="bgGry">
				<div class="qnaPdt">
					<div class="pPhoto">
						<% if oItem.Prd.IsSoldOut then %><p><span><em>품절</em></span></p><% end if %>
						<img src="<%=getThumbImgFromURL(oItem.Prd.FImageBasic,286,286,"true","false")%>" alt="<%= Replace(oItem.Prd.FItemName,"""","") %>" />
					</div>
					<div class="pdtCont">
						<p class="pBrand"><%= oItem.Prd.FBrandName %></p>
						<p class="pName"><%= oItem.Prd.FItemName %></p>
						<p class="pPrice tMar10">
							<% = FormatNumber(oItem.Prd.getRealPrice,0) %>원
							<% If oItem.Prd.IsSaleItem Then %>
							<span class="cRd1">[<% = oItem.Prd.getSalePro %>]</span>
							<% end if %>
						</p>
					</div>
				</div>
	
				<div class="inner5 tMar15 cmtCont">
					<div class="tab01 noMove">
						<ul class="tabNav tNum2">
							<li <%=CHKIIF(mode="wr","class=""current""","")%>><a href="#" onclick="fnGoQnaTab('wr'); return false;"><%=chkIIF(idx="","쓰기","수정")%><span></span></a></li>
							<li <%=CHKIIF(mode<>"wr","class=""current""","")%>><a href="#" onclick="fnGoQnaTab(''); return false;">전체보기<span></span></a></li>
						</ul>
						<div class="tabContainer box1">
						<!-- 쓰기 -->
							<div id="cmtWrite" class="tabContent" <%=CHKIIF(mode="wr","","style=""display:none;""")%>>
							<form name="qnaform" method="post">
							<input type="hidden" name="id" value="<%=idx%>">
							<input type="hidden" name="itemid" value="<% = itemid %>">
							<input type="hidden" name="cdl" value="<%= oItem.Prd.FcdL %>">
							<input type="hidden" name="qadiv" value="02">
							<input type="hidden" name="mode" value="<%=chkIIF(idx="","write","modi")%>">
							<input type="hidden" name="userid" value="<%= LoginUserid %>">
							<input type="hidden" name="UserName" value="<%= GetLoginUserName %>" >
								<div class="qnaWrite" style="margin-top:0; padding-top:0; border-top:none;">
									<textarea name="contents" class="w100p tMar10" cols="30" rows="8" title="문의내용 작성" placeholder="문의하실 내용을 입력하세요."><%=contents%></textarea>
									<div class="overHidden tPad10">
										<p class="ftLt w35p tMar10"><input type="checkbox" id="receiveMail" name="emailok" value="Y" <%=chkIIF(emailok="Y","checked='checked'","")%>/> <label for="receiveMail"><strong class="fs12">답변메일 받기</strong></label></p>
										<p class="ftLt lPad10" style="width:65%;"><input type="email" class="w100p" name="usermail" value="<% = usermail %>" maxlength="128" /></p>
									</div>
<!-- 									<div class="overHidden tPad10"> -->
<!-- 										<p class="ftLt w35p tMar10"><input type="checkbox" id="receivSMS" name="smsok" value="Y" <%=chkIIF(smsok="Y","checked='checked'","")%>/> <label for="receivSMS"><strong class="fs12">답변SMS 받기</strong></label></p> -->
<!-- 										<p class="ftLt lPad10" style="width:65%;"><input type="tel" class="w100p" name="userhp" value="<% = userhp %>" maxlength="14" /></p> -->
<!-- 									</div> -->
									<div class="tMar20">
										<p><input type="checkbox" id="lock" name="secretYN" value="Y" <%=chkiif(secretYN="Y","checked","")%>/> <label for="lock"><strong class="fs12">비밀글로 문의하기</strong></label></p>
									</div>									
									<ul class="notiList tMar15">
										<li>주문 후 주문/배송/취소 등에 관한 문의는 <a href="#" onclick="fnAPPpopupBrowserURL('<%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp'); return false;" class="cBl1 txtLine">마이텐바이텐 &gt; 1:1상담</a>을 이용해주시기 바랍니다.</li>
										<li>고객님이 작성하신 문의 및 답변은 <a href="#" onclick="fnAPPpopupBrowserURL('상품Q&amp;A','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/myitemqna.asp'); return false;" class="cBl1 txtLine">마이텐바이텐 &gt; 상품 Q&A</a> 에서도 확인이 가능합니다.</li>
										<li>상품과 관련없는 문의는 강제 삭제 될 수 있습니다.</li>
									</ul>
								</div>
							</form>
							</div>
						<!--// 쓰기 -->
	
						<!-- 전체보기 -->
							<div id="cmtView" class="tabContent prdDetailCont" <%=CHKIIF(mode="wr","style=""display:none;""","")%>>
							<% if oQna.FResultCount = 0 then %>
								<div class="noDataBox">
									<p class="noDataMark"><span>!</span></p>
									<p class="tPad05">등록된 상품문의가 없습니다.</p>
								</div>
							<% else %>
								<ul class="qnaListV16a">
								<% for i = 0 to oQna.FResultCount - 1 %>
									<li>
										<div class="q">
											<% if oQna.FItemList(i).Fsecretyn="Y" and LoginUserid <> oQna.FItemList(i).FUserid then %>
											<div><i class="icon lock"></i> 비밀글입니다.</div>
											<% Else %>
											<div><% If oQna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock"></i> <% End If %> <% = nl2br(oQna.FItemList(i).FContents) %></div>
											<% End If %>
											<p class="writer"><%= printUserId(oQna.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oQna.FItemList(i).FRegdate, "0000.00.00") %></p>
											<% if (LoginUserid<>"") and (LoginUserid=oQna.FItemList(i).FUserid) then %>
											<p class="btnWrap">
												<% IF Not(oQna.FItemList(i).IsReplyOk) THEN %><span class="button btS2 btWht cBk1"><a href="" onclick="modiItemQna('<%= oQna.FItemList(i).Fid %>');return false;">수정</a></span><% end if %>
												<span class="button btS2 btWht cBk1"><a href="" onclick="delItemQna('<%= oQna.FItemList(i).Fid %>');return false">삭제</a></span>
											</p>
											<% end if %>
										</div>
										<% IF oQna.FItemList(i).IsReplyOk THEN %>
										<div class="a">
											<% if oQna.FItemList(i).Fsecretyn="Y" and LoginUserid <> oQna.FItemList(i).FUserid then %>
											<div><i class="icon lock"></i> 비밀글입니다.</div>
											<% Else %>
											<div><% If oQna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock"></i> <% End If %> <%= nl2br(oQna.FItemList(i).FReplycontents) %></div>
											<% End If %>
										</div>
										<% end if %>
									</li>
								<% next %>
								</ul>
								<div class="tPad20">
								<%=fnDisplayPaging_New(page,oQna.FTotalCount,oQna.FPageSize,4,"fnGoQnaPage")%>
								</div>
							<% End If %>
							</div>
						<!-- // 전체보기 -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="lytFltBar" class="floatingBar" <%=chkIIF(mode="wr","","style=""display:none;""")%>>
			<div class="btnWrap">
				<div style="display:block;"><span class="button btB1 btRed cWh1 w100p"><input type="button" value="<%=chkIIF(idx="","등록","수정")%>" onclick="GotoItemQnA();" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%
	set oItem =	Nothing
	set oQna =	Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->