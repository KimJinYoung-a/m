<%
'###########################################################
' Description :  기프트Talk 신규등록
' History : 2015.02.10 유태욱 생성
'###########################################################
%>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
		<div class="content bgGry" id="contentArea">
			<div class="writeTalk">
				<div class="noti">
					<ul>
						<li>1가지 상품 선택 시 찬성반대 투표가 가능합니다.</li>
						<li>2가지 상품 선택 시 양자택일이 가능합니다.</li>
						<li>글 삭제는 취소 버튼을 이용해주시면 됩니다.</li>
						<li>&quot;빠른 상품추가&quot; 이용 시 상품검색, 위시상품 선택이 가능합니다.</li>
					</ul>
				</div>
				<div id="field">
					<form action="">
						<fieldset>
							<div class="add caseA">
								<div class="item">
									<a href="" onclick="fnAPPopenerJsCallClose('goitemReturn()'); return false;"><strong><span></span>빠른 상품추가</strong></a>
								</div>
							</div>
							<textarea cols="60" rows="5" title="질문내용 작성" placeholder="">GIFT TALK 내용을 100자 이내로 작성해주세요.
(관련 없는 글은 관리자에 의해 삭제 될 수 있습니다.)</textarea>
							<div class="limited"><span>1</span>/100</div>
							<p class="report">
								<strong>※ 문의사항은 1:1 문의하기를 이용해주세요.</strong>
								<span class="button btS2 cWh1"><a href="" onclick="fnAPPpopupBrowserURL('1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp'); return false;">1:1 문의하기</a></span>
							</p>
						</fieldset>
						<div class="floatingBar">
							<div class="btnWrap bNum2">
								<div class="ftBtn"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="<% If vTalkIdx="" Then %>if(confirm('창을 닫으시면 내용이 모두 지워 집니다.')){ closeTalkDiv();}<%else%>goBack('/category/category_itemprd.asp?itemid=<%=vItemID%>');<% End If %>">취소</button></span></div>
								<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" onclick="javascript:alert('상품 및 내용을 입력 하셔야 합니다.'); return false;" value="등록"></span></div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		<div id="modalLayer" style="display:none;"></div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	/* 톡 내용 입력시 글자수 카운팅 */
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