<%
'###########################################################
' Description :  기프트
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<%
	'### 상품2개 비교하기(A,B)
	If IsUserLoginOK = False Then
		Response.End
	End If

	Dim cTalk2, vTICount2, vTIItemID1, vTIItemID2, vTIItemName1, vTIItemName2, vTIItemImage1, vTIItemImage2, vTIItemMakerID1, vTIItemMakerID2, vTIItemBrandName1, vTIItemBrandName2
	SET cTalk2 = New CGiftTalk
	cTalk2.FRectUserId = GetLoginUserID()
	If vTalkIdx <> "" Then
		cTalk2.FPageSize = 1
		cTalk2.FCurrpage = 1
		cTalk2.FRectTalkIdx = vTalkIdx
		cTalk2.FRectUseYN = "y"
		cTalk2.sbGiftTalkList

		'### 0:good, 1:bad, 2:itemid, 3:itemname, 4:makerid, 5:brandname, 6:listimage, 7:icon1image, 8:icon2image, 9:basicimage, 10:idx
		vItem = cTalk2.FItemList(0).FItem
		vItem = Right(vItem,Len(vItem)-5)

		vContents			= db2html(cTalk2.FItemList(0).FContents)
'		vKey1				= fnTalkModifyKeySetting(cTalk2.FItemList(0).FTag)
		vTIItemID2			= Split(Split(vItem,",item,")(1),"|blank|")(2)
		vTIItemName2		= db2html(Split(Split(vItem,",item,")(1),"|blank|")(3))
		vTIItemImage2		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(vTIItemID2) & "/" & Split(Split(vItem,",item,")(1),"|blank|")(7)
		vTIItemMakerID2		= Split(Split(vItem,",item,")(1),"|blank|")(4)
		vTIItemBrandName2	= db2html(Split(Split(vItem,",item,")(1),"|blank|")(5))
		vTIItemID1			= Split(Split(vItem,",item,")(0),"|blank|")(2)
		vTIItemName1		= db2html(Split(Split(vItem,",item,")(0),"|blank|")(3))
		vTIItemImage1		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(vTIItemID1) & "/" & Split(Split(vItem,",item,")(0),"|blank|")(7)
		vTIItemMakerID1		= Split(Split(vItem,",item,")(0),"|blank|")(4)
		vTIItemBrandName1	= db2html(Split(Split(vItem,",item,")(0),"|blank|")(5))
	Else
		cTalk2.FPageSize = 2
		cTalk2.FRectUserId = GetLoginUserID()
		cTalk2.fnGiftTalkMyItemList

		vTIItemID2			= cTalk2.FItemList(1).FItemID
		vTIItemName2		= cTalk2.FItemList(1).FItemName
		vTIItemImage2		= cTalk2.FItemList(1).FImageIcon1
		vTIItemMakerID2		= cTalk2.FItemList(1).FMakerID
		vTIItemBrandName2	= cTalk2.FItemList(1).FBrandName
		vTIItemID1			= cTalk2.FItemList(0).FItemID
		vTIItemName1		= cTalk2.FItemList(0).FItemName
		vTIItemImage1		= cTalk2.FItemList(0).FImageIcon1
		vTIItemMakerID1		= cTalk2.FItemList(0).FMakerID
		vTIItemBrandName1	= cTalk2.FItemList(0).FBrandName
	End If
	vTICount2 = cTalk2.FTotalCount
	SET cTalk2 = Nothing

'	Dim cTalkkey2
'	SET cTalkkey2 = New CGiftTalk
'	cTalkkey2.FRectUseYN = "y"
'	vArrKey = cTalkkey2.fnGiftTalkKeywordList()
'	SET cTalkkey2 = Nothing

%>
<script type="text/javascript">
<!-- #include file="./inc_Javascript.asp" -->

function talkSubmit(){
	if(talkfrm.contents.value == "" || talkfrm.contents.value == "GIFT TALK 내용을 100자 이내로 작성해주세요.\n(관련 없는 글은 관리자에 의해 삭제 될 수 있습니다."){
	alert("상품에 대한 내용을 작성하세요.");
	talkfrm.contents.value = "";
	talkfrm.contents.focus();
	return;
	}

	if(talkfrm.itemid.value == "" || talkfrm.itemid.value == ","){
		alert("상품을 선택해 주세요.");
		return;
	}
	<% If vTalkIdx <> "" Then %>
		talkfrm.gubun.value = "u";
	<% End If %>

    // 선물의 참견 등록 앰플리튜드 연동
    fnAmplitudeEventMultiPropertiesAction('view_gifttalk', 'click_gifttalk_write', 'Y');

	talkfrm.submit();
}

</script>
</head>
<body class="bgGry">
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
		<div class="header">
			<% If vTalkIdx = "" Then %>
				<h1>GIFT TALK 쓰기</h1>
			<% else %>
				<h1>GIFT TALK 수정</h1>
			<% end if %>
			<p class="btnPopClose"><button class="pButton" onclick="closeTalkDivx();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="writeTalk">
				<div class="noti">
					<ul>
					<% If vTalkIdx = "" Then %>
						<li>1가지 상품 선택 시 찬성반대 투표가 가능합니다.</li>
						<li>2가지 상품 선택 시 양자택일이 가능합니다.</li>
						<li>글 삭제는 취소버튼을 이용해주시면 됩니다.</li>
					<% else %>
						<li>투표가 진행중인 톡은 상품을 수정 하실 수 없습니다.</li>
					<% end if %>
					</ul>
				</div>

				<div id="field">
					<form name="talkfrm" action="/gift/gifttalk/save_giftTalk.asp" method="post" style="margin:0px;" target="iframeproc">
					<input type="hidden" name="talkidx" value="<%=vTalkIdx%>">
					<input type="hidden" name="gubun" value="i">
					<input type="hidden" name="useyn" value="y">
					<input type="hidden" name="keyword" id="keyword" value="A01">
						<fieldset>
							<div class="add caseC">
								<input type="hidden" name="itemid" value="<%=vTIItemID1%>,<%=vTIItemID2%>">
								<div class="item">
									<img src="<%=vTIItemImage1%>" alt="<%=vTIItemName1%>" />
									<em>A</em>
									<% If vTalkIdx = "" Then %>
										<button type="button" class="btnDel" onclick="deleteitem('<%= deleteitem2idx %>'); return false;">삭제</button>
									<% end if %>
								</div>
								<div class="item">
									<img src="<%=vTIItemImage2%>" alt="<%=vTIItemName2%>" />
									<em>B</em>
									<% If vTalkIdx = "" Then %>
										<button type="button" class="btnDel" onclick="deleteitem('<%= deleteitem1idx %>'); return false;">삭제</button>
									<% end if %>
								</div>
							</div>
							<textarea cols="60" rows="5" name="contents" title="질문내용 작성" placeholder=""><% If vContents = "" Then %>GIFT TALK 내용을 100자 이내로 작성해주세요.<%=vbCrLf%>(관련 없는 글은 관리자에 의해 삭제 될 수 있습니다.<% Else Response.Write vContents End If %></textarea>
							<div class="limited"><span>1</span>/100</div>
							<p class="report">
								<strong>※ 문의사항은 1:1 문의하기를 이용해주세요.</strong>
								<span class="button btS2 cWh1"><a href="/my10x10/qna/myqnalist.asp">1:1 문의하기</a></span>
							</p>
						</fieldset>
						<div class="floatingBar">
							<div class="btnWrap bNum2">
								<div class="ftBtn"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="<%If vTalkIdx="" Then %>if(confirm('취소버튼 선택시 내용이 모두 지워 집니다.')){ closeTalkDiv();}<%else%>goBack('/category/category_itemprd.asp?itemid=<%=vItemID%>')<% End If %>; return false;">취소</button></span></div>
								<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" onclick="talkSubmit(); return false;" value="등록"></span></div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- //content area -->
		<div id="modalLayer" style="display:none;"></div>
	</div>
<iframe src="about:blank" name="iframeproc" frameborder="0" width="0" height="0"></iframe>
</div>
<script type="text/javascript">
$(function(){
	/* 글자수 카운팅 */
	$("#field textarea").each(function() {
		var defaultVal = this.value;
		$(this).focus(function() {
			if(this.value == defaultVal){
				this.value = '';
			}
		});
		$(this).blur(function(){
			if(this.value == ''){
				this.value = defaultVal;
			}
		});
	});
	function frmCount(val) {
		var len = val.value.length;
		if (len >= 101) {
			val.value = val.value.substring(0, 100);
		} else {
			$("#field .limited span").text(len);
		}
	}
	$("#field textarea").keyup(function() {
		frmCount(this);
	});
});
</script>
</body>
</html>