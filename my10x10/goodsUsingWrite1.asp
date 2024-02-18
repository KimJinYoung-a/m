<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 상품후기 리스트
' History : 2014-09-01 이종화 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "상품후기 작성"

dim userid,orderserial,itemid,ItemOption,EvaluatedYN,userlevel

userid	= "sthwang89"
userlevel= "3"
itemID	= "1336275"
itemoption	= "0011"
orderserial = "15102373784"


if itemid ="" or orderserial ="" then 
	response.redirect("/my10x10/goodsUsing.asp")
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
	response.write "<script>history.back();</script>"
	response.end

end if

'/상품고시관련 상품후기 제외 상품
dim Eval_excludeyn : Eval_excludeyn="N"
	Eval_excludeyn=getEvaluate_exclude_Itemyn(itemid)
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 상품후기 쓰기</title>
	<script type="text/javascript">
	function delimage(ifile){
		document.getElementById(ifile).value = "";
	}

	function SubmitForm(frm)
	{
		<% if Eval_excludeyn="N" then %>
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
		<% end if %>

		if (confirm("입력사항이 정확합니까?") == true){
			$("#regbtn").hide();
			$("#lyLoading").show();
			frm.submit();
		}
	}

	function setStar(pt)
	{
		$(".score span").removeClass("on");

		if(1 > pt)
		{
			return false;
		}
		else
		{
			for (var a=0; a<=pt; a++)
			{
				$("#star"+a).addClass('on');
			}
		}

		$('input[id="totPnt"]').val(pt);
		$('input[id="funPnt"]').val(pt);
		$('input[id="dgnPnt"]').val(pt);
		$('input[id="PrcPnt"]').val(pt);
		$('input[id="stfPnt"]').val(pt);
	}
	</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content myReview" id="contentArea">
				<!--<h2 class="tit01 tMar20 lMar10">상품 후기 작성</h2>-->
				<div class="inner10">
					<ul class="cpNoti" style="border:0;">
						<li>상품 후기를 작성하시면 100point가 적립되며 배송정보 [출고완료]이후부터 작성하실 수 있습니다.</li>
					</ul>
					<form name="FrmGoodusing" method="post" action="<%=staticImgUrl%>/linkweb/doevaluatewithimage_mobile.asp" EncType="multipart/form-data">
					<input type="hidden" name="idx" value="<%= EvList.FEvalItem.Fidx %>" />
					<input type="hidden" name="gubun" value="<%= EvList.FEvalItem.FGubun%>" />
					<input type="hidden" name="itemid" value="<%= EvList.FEvalItem.FItemID %>" />
					<input type="hidden" name="itemoption" value="<%= EvList.FEvalItem.FitemOption %>" />
					<input type="hidden" name="orderserial" value="<%= EvList.FEvalItem.FOrderSerial %>" />
					<div class="reviewWrite">
						<div class="pdtWrap">
							<p class="pic"><img src="<%= EvList.FEvalItem.FBasicImage %>" alt="<%= EvList.FEvalItem.FItemName %>" /></p>
							<div class="pdtInfo">
								<p class="pBrand">[<%= EvList.FEvalItem.FMakerName %>]</p>
								<p class="pName"><%= EvList.FEvalItem.FItemName %></p>
								<% if EvList.FEvalItem.FOptionName<>"" then %>
								<input type="hidden" name="itemoptNm" value="<%= EvList.FEvalItem.FOptionName %>" />
								<p class="option">옵션 : <%= EvList.FEvalItem.FOptionName %></p>
								<% end if %>
								<p class="pPrice"><strong><%= FormatNumber(EvList.FEvalItem.FItemCost,0) %></strong>원</p>
							</div>
						</div>

						<%
						'//상품고시관련 상품후기 제외 상품이 아닐경우
						if Eval_excludeyn="N" then
						%>
							<div><textarea name="usedcontents" cols="30" rows="5" class="w100p enterTxt"><%= EvList.FEvalItem.FUesdContents %></textarea></div>
							<% if EvList.FEvalItem.FOptionName<>"" then %>
							<dl class="pdtOption">
								<dt>상품 옵션</dt>
								<dd>
									<p>
										<span><input type="radio" id="open" name="useOpt" value="Y" checked /> <label for="open">공개</label></span>
										<span class="lPad05"><input type="radio" id="hidden" name="useOpt" value="N" /> <label for="hidden">비공개</label></span>
									</p>
								</dd>
							</dl>
							<% end if %>
							<div class="addImage">
								<p><input name="file1" id="file1" type="file" /> <button class="btnDel" onClick="delimage('file1');return false;">파일 삭제</button></p>
								<% if EvList.FEvalItem.Flinkimg1<>"" then %>
								<span class="pic">
									<img src="<%= EvList.FEvalItem.getLinkImage1 %>" alt="" />
									<input type="checkbox" name="file1_del" id="delImg01" /> <label for="delImg01">등록된 이미지 삭제</label>
								</span>
								<% end if %>
							</div>
							<div class="addImage">
								<p><input name="file2" id="file2" type="file" /> <button class="btnDel" onClick="delimage('file2');return false;">파일 삭제</button></p>
								<% if EvList.FEvalItem.Flinkimg2<>"" then %>
								<span class="pic">
									<img src="<%= EvList.FEvalItem.getLinkImage2 %>" alt="" />
									<input type="checkbox" name="file2_del" id="delImg02" /> <label for="delImg02">등록된 이미지 삭제</label>
								</span>
								<% end if %>
							</div>
							<p class="addTip"><span>*</span> 포토후기는 최대 2장의 이미지를 첨부하실 수 있습니다.</p>
						<%
						'//상품고시관련 상품후기 제외 상품일 경우
						else
						%>
							<div class="ct fs12 cGy2 tMar30 lh12">본 상품은 건강식품 및 의료기기에 해당되는<br />상품으로 고객 상품평 이용이 제한되며,<br />만족도 평가만 가능합니다.</div>
							<input type="hidden" name="file1" value="">
							<input type="hidden" name="file2" value="">
						<% end if %>

						<div class="starRating">
							<div class="score">
								<a href="" onClick="setStar('1'); return false;"><span id="star1"></span></a>
								<a href="" onClick="setStar('2'); return false;"><span id="star2"></span></a>
								<a href="" onClick="setStar('3'); return false;"><span id="star3"></span></a>
								<a href="" onClick="setStar('4'); return false;"><span id="star4"></span></a>
								<input type="hidden" id="totPnt" name="totPnt" value="<% if isNull(EvList.FEvalItem.FTotalPoint) or EvList.FEvalItem.FTotalPoint = "" then response.write "4" Else response.write EvList.FEvalItem.FTotalPoint End if %>">
								<input type="hidden" id="funPnt" name="funPnt" value="<% if isNull(EvList.FEvalItem.FPoint_fun) or EvList.FEvalItem.FPoint_fun = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_fun End if %>">
								<input type="hidden" id="dgnPnt" name="dgnPnt" value="<% if isNull(EvList.FEvalItem.FPoint_dgn) or EvList.FEvalItem.FPoint_dgn = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_dgn End if %>">
								<input type="hidden" id="PrcPnt" name="PrcPnt" value="<% if isNull(EvList.FEvalItem.FPoint_prc) or EvList.FEvalItem.FPoint_prc = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_prc End if %>">
								<input type="hidden" id="stfPnt" name="stfPnt" value="<% if isNull(EvList.FEvalItem.FPoint_stf) or EvList.FEvalItem.FPoint_stf = "" then response.write "4" Else response.write EvList.FEvalItem.FPoint_stf End if %>">
							</div>
							<p>별을 터치하여 별점을 매겨주세요.</p>
						</div>
						<span id="regbtn" class="button btB1 btRed cWh1 w100p"><a href="" onClick="SubmitForm(FrmGoodusing); return false;">등록하기</a></span>
						<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
					</div>
					</form>
				</div>
			</div>
			<% if isNull(EvList.FEvalItem.FTotalPoint) <> True AND EvList.FEvalItem.FTotalPoint <> "" then %>
			<script>setStar('<%=EvList.FEvalItem.FTotalPoint%>');</script>
			<% else %>
			<script>setStar('4');</script>
			<% end if %>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% Set EvList = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->