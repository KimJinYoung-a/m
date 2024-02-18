<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset ="UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
''response.write "["&GetLoginUserID&"]."
'' 쿠키관련 .. 쿠키를 함 구어줘야? // 2014/03/21 imgstatic에서 쿠키가 않먹음 ==> 앱의 문제 m.10x10.co.kr 만 쿠키를 구었음 .10x10.co.kr 로 구우라고 전달
'''response.Cookies("uinfo").domain = "10x10.co.kr"

dim userid,orderserial,itemid,ItemOption,EvaluatedYN,userlevel

userid	= GetLoginUserID
userlevel= GetLoginUserLevel
itemID	= requestCheckVar(request("itemid"),10)
itemoption	= requestCheckVar(request("optionCD"),4)
orderserial = requestCheckVar(request("orderserial"),20)


if itemid ="" or orderserial ="" then
	response.redirect("/apps/appcom/wish/webview/my10x10/goodsUsing.asp")
	'Response.Write "<script language='javascript'>self.close();</script>"
	response.end
end if

dim EvList
set EvList = new CEvaluateSearcher
EvList.FRectUserID = Userid
EvList.FRectEvaluatedYN=EvaluatedYN
EvList.FRectItemID=itemID
EvList.FRectOrderSerial=OrderSerial
EvList.FRectOption=ItemOption
EvList.getEvaluatedItem	 ''/기존 후기 있는지 검사

if EvList.FResultCount < 1 then '// 없으면
	EvList.getNotEvaluatedItem	 '// 3개월 이내에 주문한것중 후기 안쓴것 검사
end if

if EvList.FResultCount < 1 then '최근 3개월 이내 구매 상품 중 후기 안쓴 상품이 없으면 - 퇴짜

	response.write "<script>alert('최근 3개월 이내에 구매한 상품만 상품후기 작성이 가능합니다.');</script>"
	response.write "<script>self.close();</script>"
	response.end

end if

strPageTitle = "생활감성채널, 텐바이텐 > 상품후기 쓰기"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
function delimage(ifile) {
	document.getElementById(ifile).value = "";
}

function SubmitForm(frm) {
	if (frm.usedcontents.value == "") {
			alert("상품평을 적어주세요.");
			frm.usedcontents.focus();
			return;
	}

	if (frm.usedcontents.value.length>10000) {
		   alert("상품평은 10000자 이내로 작성해 주세요");
		   frm.usedcontents.focus();
		   return;
	}

	if (confirm("입력사항이 정확합니까?") == true) { frm.submit(); }
}

$(function(){
	$("#usedcontents").focus();

	$('.stars a').removeClass('active');
	var i=0, chkPt=$('#totPnt').val();
	$('.stars a').each(function(){
		if(i<chkPt) {
			$(this).addClass('active');
		}
		i++;
	});
});
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">상품 후기 등록</span></h1>
                </div>
            </div>
            <div class="well type-b">
                <ul class="txt-list">
                    <li>상품후기를 작성하시면 100point 가 적립되며 배송정보 [출고완료] 이후부터 작성하실 수 있습니다. </li>
                </ul>
            </div>
            <div class="inner">
                <div class="bordered-box filled">
                    <div class="product-info gutter">
                        <div class="product-img">
                            <img src="<%= EvList.FEvalItem.FImageList100 %>" alt="<%= EvList.FEvalItem.FItemName %>">
                        </div>
                        <div class="product-spec">
                            <p class="product-brand">[<%= EvList.FEvalItem.FMakerName %>] </p>
                            <p class="product-name"><%= EvList.FEvalItem.FItemName %></p>
							<% If EvList.FEvalItem.FOptionName <> "" Then %>
                            <p class="product-option">옵션 : <%= EvList.FEvalItem.FOptionName %></p>
							<% End If %>
                        </div>
                        <div class="price">
                            <strong><%= FormatNumber(EvList.FEvalItem.FItemCost,0) %></strong>원
                        </div>
                    </div>
                </div>
            </div>

			<form name="FrmGoodusing" method="post" action="<%=staticImgUrl%>/linkweb/doevaluatewithimage_mobile.asp" EncType="multipart/form-data" onsubmit="return false;">
			<input type="hidden" name="idx" value="<%= EvList.FEvalItem.Fidx %>" />
			<input type="hidden" name="gubun" value="<%= EvList.FEvalItem.FGubun%>" />
			<input type="hidden" name="itemid" value="<%= EvList.FEvalItem.FItemID %>" />
			<input type="hidden" name="itemoption" value="<%= EvList.FEvalItem.FitemOption %>" />
			<input type="hidden" name="orderserial" value="<%= EvList.FEvalItem.FOrderSerial %>" />
			<input type="hidden" id="totPnt" name="totPnt" value="<% if isNull(EvList.FEvalItem.FTotalPoint) or EvList.FEvalItem.FTotalPoint = "" then response.write "4" Else response.write EvList.FEvalItem.FTotalPoint End if %>">
			<input type="hidden" id="funPnt" name="funPnt" value="<% if isNull(EvList.FEvalItem.FPoint_fun) or EvList.FEvalItem.FPoint_fun = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_fun End if %>">
			<input type="hidden" id="dgnPnt" name="dgnPnt" value="<% if isNull(EvList.FEvalItem.FPoint_dgn) or EvList.FEvalItem.FPoint_dgn = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_dgn End if %>">
			<input type="hidden" id="PrcPnt" name="PrcPnt" value="<% if isNull(EvList.FEvalItem.FPoint_prc) or EvList.FEvalItem.FPoint_prc = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_prc End if %>">
			<input type="hidden" id="stfPnt" name="stfPnt" value="<% if isNull(EvList.FEvalItem.FPoint_stf) or EvList.FEvalItem.FPoint_stf = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_stf End if %>">
			<input type="hidden" id="apps" name="apps" value="apps">
            <div class="inner">
                <textarea name="usedcontents" id="usedcontents" cols="30" rows="10" placeholder="상품후기를 입력해주세요. " class="form bordered" style="height:160px;"><%= EvList.FEvalItem.FUesdContents %></textarea>
                <div class="diff"></div>
                <em class="em" style="margin:5px 0;">* 포토후기는 최대 2장의 이미지를 첨부하실 수 있습니다.</em>
                <ul class="files">
                    <li><input type="file" name="file1" id="file1" class="form bordered full-size"><!-- <a href="javascript:delimage('file1');" >삭제</a> --></li>
                    <li><input type="file" name="file2" id="file2" class="form bordered full-size"><!-- <a href="javascript:delimage('file2');" >삭제</a> --></li>
                </ul>
                <div class="clear"></div>
                <div class="diff-10"></div>
                <div class="rating t-c">
                    <div class="stars">
                        <a href="#">★</a>
                        <a href="#">★</a>
                        <a href="#">★</a>
                        <a href="#">★</a>
                    </div>
                    <small>별을 터치하여 별점을 매겨주세요. </small>
                </div>
<script>
    $('.stars a').each(function(index){
        $(this).on('click', function(){
            $('.stars a').addClass('active');
            $('.stars a:gt('+index+')').removeClass('active');
            var rate = index+1;
            console.log(rate);

			$('#totPnt').attr("value",rate);
			$('#funPnt').attr("value",rate);
			$('#dgnPnt').attr("value",rate);
			$('#PrcPnt').attr("value",rate);
			$('#stfPnt').attr("value",rate);
			return false;
        });
    });
</script>
            </div>
            <div class="form-actions highlight">
                <div class="two-btns">
                    <div class="col"><button class="btn type-b" onclick="SubmitForm(this.form);">등록</button></div>
                    <div class="col"><button class="btn type-a" onclick="location.href='/apps/appcom/wish/webview/my10x10/goodsusing.asp'">취소</button></div>
                </div>
                <div class="clear"></div>
            </div>
            </form>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">

        </footer><!-- #footer -->

    </div><!-- wrapper -->

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>



<% Set EvList = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->