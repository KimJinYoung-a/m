<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  위시 메이트 리스트
' History : 2014.09.23 원승현 생성
'####################################################
%>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	Dim vTargetUserid : vTargetUserid = requestCheckVar(request("uid"),200)

	'// vUserId Decoding
	vTargetUserid = tenDec(vTargetUserid)


	Dim vErrBackLocationUrl, WishMatchingCnt, oDoc

	vErrBackLocationUrl = "/apps/appcom/wish/web2014/my10x10/myWish/mywish.asp?ucid="&Server.Urlencode(tenEnc(vTargetUserid))

	If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
		PageSize="10"
	End If

	If Trim(CurrPage)="" Or Len(Trim(CurrPage))=0 Then
		CurrPage = "0"
	End If


'// 위시 매치 카운트
Set oDoc = new CAutoWish
	oDoc.FuserID = getEncLoginUserID()
	oDoc.FTargetUserID = vTargetUserid
	oDoc.GetWishMatchingCnt
		WishMatchingCnt = oDoc.FchkResult
Set oDoc = Nothing
%>
<script>
var isloading=true;
var rCheck=false;
$(function() {
	// 저장된 해쉬 값을 불러와 셋팅
	 if(document.location.hash)
	 {
		var str_hash = document.location.hash;
		str_hash = str_hash.replace("#","");
		var varr_curpage=str_hash.split("^");
		var vTsn=varr_curpage[0];
		var vPsz=varr_curpage[1];
		$("#cpg2").val("0");
		$("#psz2").val(vPsz);		
		getWishList2();
		$('body, html').delay(500).animate({ scrollTop: vTsn }, 50);
	 }
	else
	{
		getWishList();

	}
	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 200){
          if (isloading==false){
            isloading=true;
			var pg = $("#popularfrm input[name='cpg']").val();
			pg++;
			$("#popularfrm input[name='cpg']").val(pg);
            setTimeout("getWishList()",200);
          }
      }
    });
});


function getWishList() {

	var str=$.ajax({
		type:"GET",
		url:"inc_mateSelectList.asp",
		data:$("#popularfrm").serialize(),
		dataType:"text",
		async:false
	}).responseText;

	if(str!="") {
    	if($("#popularfrm input[name='cpg']").val()=="0") {
        	//내용 넣기
        	$('#mateListInc').html(str);
		} else {
			$('#mateListInc').append(str);
		}
		isloading=false;
	} else {
    	$(window).unbind("scroll");


	}
}

function getWishList2() {

	var str=$.ajax({
		type:"POST",
		url:"inc_mateSelectList2.asp",
		data:$("#popularfrm2").serialize(),
		dataType:"text",
		async:false
	}).responseText;

	if(str!="") {
    	if($("#popularfrm input[name='cpg2']").val()=="0") {
        	//내용 넣기
        	$('#mateListInc').html(str);
		} else {
			$('#mateListInc').append(str);
		}
		isloading=false;
	} else {
    	$(window).unbind("scroll");
	}
}

$("#Hlink").live("click", function(e) {

	var tpsz;

	tpsz = (Number($("#cpg").val())+1)*Number($("#psz").val());

	document.location.hash=document.body.scrollTop+"^"+tpsz

});

</script>
<body>
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=CurrPage%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
	<input type="hidden" name="utid" id="utid" value="<%=vTargetUserid%>">
</form>

<form id="popularfrm2" name="popularfrm2" method="post" style="margin:0px;">
	<input type="hidden" name="cpg2" id="cpg2" value="<%=CurrPage%>" />
	<input type="hidden" name="psz2" id="psz2" value="<%=PageSize%>">
	<input type="hidden" name="utid2" id="utid2" value="<%=vTargetUserid%>">
</form>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="wishMate">
				<p class="total"><em class="cRd1"><%=WishMatchingCnt%>개</em>상품이 메이트 되었습니다.</p>
				<ul class="mateList" id="mateListInc"></ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
