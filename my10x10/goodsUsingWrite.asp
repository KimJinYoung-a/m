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
'			2017-07-12 이종화 수정 - UI  교체 및 이미지 미리 등록 하기 추가
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
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<%
'해더 타이틀
strHeadTitleName = "상품후기 작성"

dim userid,orderserial,itemid,ItemOption,EvaluatedYN,userlevel , refer, orderidx

userid	= getEncLoginUserID
userlevel= GetLoginUserLevel
itemID	= requestCheckVar(request("itemid"),10)
itemoption	= requestCheckVar(request("optionCD"),4)
orderserial = requestCheckVar(request("orderserial"),20)
orderidx = requestCheckVar(request("OrderIDX"),10)
refer  = request.ServerVariables("HTTP_REFERER")

'//이미지 업로드 관련
Dim encUsrId, tmpTx, tmpRn

Randomize()
tmpTx = split("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z",",")
tmpRn = tmpTx(int(Rnd*26))
tmpRn = tmpRn & tmpTx(int(Rnd*26))
	encUsrId = tenEnc(tmpRn & userid)
'//이미지 업로드 관련

Dim gaparam 

If InStr(refer,"/category/") > 0 Then
	gaparam = "mob_review_itemdetail"
ElseIf InStr(refer,"/my10x10/") > 0 Then
	gaparam = "mob_review_my10x10"
ElseIf InStr(refer,"/my10x10/order/") > 0 Then
	gaparam = "mob_review_orderlist"
End If 

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
If Len(orderserial)>11 Then
EvList.getEvaluatedOffShopItem	 ''/오프라인 후기 검사
Else
EvList.getEvaluatedItem	 ''/기존 후기 있는지 검사
End If

if EvList.FResultCount < 1 then '// 없으면 
	If Len(orderserial)>11 Then
	EvList.getNotEvaluatedOffShopItem	 '// 6개월 이내에 오프샵 주문한것중 후기 안쓴것 검사
	Else
	EvList.getNotEvaluatedItem	 '// 6개월 이내에 주문한것중 후기 안쓴것 검사
	End If
end if

if EvList.FResultCount < 1 then '최근 3개월 이내 구매 상품 중 후기 안쓴 상품이 없으면 - 퇴짜
	
	response.write "<script>alert('최근 3개월 이내에 구매한 상품만 상품후기 작성이 가능합니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end

end if

'/상품고시관련 상품후기 제외 상품
dim Eval_excludeyn : Eval_excludeyn="N"
	Eval_excludeyn=getEvaluate_exclude_Itemyn(itemid)

'// 해당 상품의 1depth 코드, makerid를 가져온다.
Dim strsql, vMakerid, vDisp
strsql = "Select top 1 itemid, makerid, dispcate1 From [db_item].[dbo].tbl_item with(nolock) Where itemid='"&itemID&"' "
rsget.Open strsql,dbget,1
IF Not rsget.Eof Then
	vMakerid = rsget("makerid")
	vDisp = rsget("dispcate1")
Else
	vMakerid = ""
	vDisp = ""
End If
rsget.close	
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 상품후기 쓰기</title>
<script type="text/javascript" src="/lib/js/jquery.form.min.js"></script> 
<script type="text/javascript">
	function SubmitForm(frm)
	{
		<% if Eval_excludeyn="N" then %>
		if (frm.usedcontents.value == "") {
				alert("상품평을 적어주세요.");
				frm.usedcontents.focus();
				return;
		} 

	    if (!chktext(frm.usedcontents.value,'10')) {
            alert("연속된 문자는 사용할 수 없습니다.");
            frm.usedcontents.focus();
            return;
	    }

		if (frm.usedcontents.value.length<10) {
			   alert("상품평은 최소 10자 이상 입력해주세요.");
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

			if(typeof qg !== "undefined"){
                let appier_review_submitted_data = {
                    "review_rating" : parseInt($("#totPnt").val())
                    //, "category_code" : ""
                    //, "category_name_depth1" : ""
                    //, "category_name_depth2" : ""
                    , "brand_name" : "<%= EvList.FEvalItem.FMakerName %>"
                    , "brand_id" : "<%=EvList.FEvalItem.FMakerID%>"
                    , "product_id" : "<%=EvList.FEvalItem.FItemID%>"
                    , "product_name" : "<%=EvList.FEvalItem.FItemname%>"
                    , "review_body" : $("textarea[name=usedcontents]").val()
                    , "price" : "<%=EvList.FEvalItem.FItemCost%>"
                };

                qg("event", "review_submitted", appier_review_submitted_data);
            }

			setTimeout(function(){
				frm.submit();
			},500);
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


// 업로드 파일 확인 및 처리
function jsCheckUpload() {
	if($("#fileupload").val()!="") {
		$("#fileupmode").val("upload");

		$('#ajaxform').ajaxSubmit({
			//보내기전 validation check가 필요할경우
			beforeSubmit: function (data, frm, opt) {
				if(!(/\.(jpg|jpeg|png)$/i).test(frm[0].upfile.value)) {
					alert("JPG,PNG 이미지파일만 업로드 하실 수 있습니다.");
					$("#fileupload").val("");
					return false;
				}
			},
			//submit이후의 처리
			success: function(responseText, statusText){
				fnAmplitudeEventMultiPropertiesAction('click_my_review_files','','');
				var resultObj = JSON.parse(responseText)

				if(resultObj.response=="fail") {
					alert(resultObj.faildesc);
				} else if(resultObj.response=="ok") {
					//파일 집어 넣기
					var $file_len = $(".fileList").find('input').length;
					var $files = $(".fileList").find('input');
					var $file_idx;
					
					for (i = 0 ; i < $file_len ; i++ ){
						if (!$files.eq(i).val()){
							$files.eq(i).val(resultObj.fileurl);
							$file_idx = i;
							break;
						}
					}

					$(".fileList .thumbnail").eq($file_idx).show();//껍데기 보여주기
					$(".fileList .thumbnail").find('img').eq($file_idx).hide().attr("src",resultObj.fileurl+"?"+Math.floor(Math.random()*1000)).fadeIn("fast");//파일 치환
					$(".fileList .file").eq($file_idx).hide();//해당 위치 찾아가기
				} else {
					alert("처리중 오류가 발생했습니다.\n" + responseText);
				}
				$("#fileupload").val("");
			},
			//ajax error
			error: function(err){
				alert("ERR: " + err.responseText);
				$("#fileupload").val("");
			}
		});
	}
}

// 물리적인 파일 삭제 처리
function jsDelImg(v){
	if(confirm("이미지를 삭제하시겠습니까?\n\n※ 파일이 완전히 삭제되며 복구 할 수 없습니다.")){
		var delimg = $(".fileList").find('input').eq(v).val(); //삭제할 이미지
		$("#filepre").val(delimg);//form에 넣고
		$("#fileupmode").val("delete");
		$('#ajaxform').ajaxSubmit({
			//보내기전
			beforeSubmit: function (data, frm, opt) {

			},
			//submit이후의 처리
			success: function(responseText, statusText){
				var resultObj = JSON.parse(responseText)

				if(resultObj.response=="fail") {
					alert(resultObj.faildesc);
				} else if(resultObj.response=="ok") {
					$(".fileList").find('input').eq(v).val(""); //공백 값 넣기

					$(".fileList .thumbnail").eq(v).hide();//껍데기 안보이게하기
					$(".fileList .thumbnail").find('img').eq(v).hide().attr("src","").fadeIn("fast");
					$("#filepre").val("");
					$(".fileList .file").eq(v).show();//해당 위치 찾아가기
				} else {
					alert("처리중 오류가 발생했습니다.\n" + responseText);
				}

			},
			//ajax error
			error: function(err){
				alert("ERR: " + err.responseText);
			}
		});
	}
}
</script>
</head>
<body>
<% '// 상품 후기 분기 상단 Bar 분리 처리 %>
<% If InStr(refer,"/category/") > 0 Then %>
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
		<div class="header">
			<h1>상품후기</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="location.replace('<%=wwwUrl%>/category/category_itemPrd.asp?itemid=<%=itemid%>'); return false;">닫기</button></p>
		</div>
<% Else %>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
<% End If %>
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="reviewFoamV17">
					<fieldset>
						<form name="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/doevaluatewithimage_mobile_new.asp?gaparam=<%=gaparam%>">
							<input type="hidden" name="idx" value="<%= EvList.FEvalItem.Fidx %>" />
							<input type="hidden" name="gubun" value="<%= EvList.FEvalItem.FGubun%>" />
							<input type="hidden" name="itemid" value="<%= EvList.FEvalItem.FItemID %>" />
							<input type="hidden" name="itemoption" value="<%= EvList.FEvalItem.FitemOption %>" />
							<input type="hidden" name="orderserial" value="<%= EvList.FEvalItem.FOrderSerial %>" />
							<input type="hidden" name="orderidx" value="<%= orderidx %>" />
							<input type="hidden" name="chkp5yn" value="Y" />
							<div class="pdtListV15a">
								<div class="thumbnail"><img src="<%= EvList.FEvalItem.FBasicImage %>" alt="<%= EvList.FEvalItem.FItemName %>" /></div>
								<div class="pdtCont">
									<div class="pdtInfo">
										<p class="pBrand">[<%= EvList.FEvalItem.FMakerName %>]</p>
										<p class="pName"><%= EvList.FEvalItem.FItemName %></p>
										<input type="hidden" name="itemoptNm" value="<%= EvList.FEvalItem.FOptionName %>" />
										<!-- <% if EvList.FEvalItem.FOptionName<>"" then %>
										<p class="option">옵션 : <%= EvList.FEvalItem.FOptionName %></p>
										<% end if %> -->
										<p class="pPrice"><strong><%= FormatNumber(EvList.FEvalItem.FItemCost,0) %></strong>원</p>
									</div>
								</div>
							</div>

							<div class="starRating">
								<p>별을 터치하여 별점을 매겨주세요.</p>
								<div class="score">
									<a href="" onClick="fnAmplitudeEventMultiPropertiesAction('click_my_review_star','star','1'); setStar('1'); return false;"><span id="star1"></span></a>
									<a href="" onClick="fnAmplitudeEventMultiPropertiesAction('click_my_review_star','star','2'); setStar('2'); return false;"><span id="star2"></span></a>
									<a href="" onClick="fnAmplitudeEventMultiPropertiesAction('click_my_review_star','star','3'); setStar('3'); return false;"><span id="star3"></span></a>
									<a href="" onClick="fnAmplitudeEventMultiPropertiesAction('click_my_review_star','star','4'); setStar('4'); return false;"><span id="star4"></span></a>
									<a href="" onClick="fnAmplitudeEventMultiPropertiesAction('click_my_review_star','star','5'); setStar('5'); return false;"><span id="star5"></span></a>
									<input type="hidden" id="totPnt" name="totPnt" value="<% if isNull(EvList.FEvalItem.FTotalPoint) or EvList.FEvalItem.FTotalPoint = "" then response.write "5" Else response.write EvList.FEvalItem.FTotalPoint End if %>">
									<input type="hidden" id="funPnt" name="funPnt" value="<% if isNull(EvList.FEvalItem.FPoint_fun) or EvList.FEvalItem.FPoint_fun = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_fun End if %>">
									<input type="hidden" id="dgnPnt" name="dgnPnt" value="<% if isNull(EvList.FEvalItem.FPoint_dgn) or EvList.FEvalItem.FPoint_dgn = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_dgn End if %>">
									<input type="hidden" id="PrcPnt" name="PrcPnt" value="<% if isNull(EvList.FEvalItem.FPoint_prc) or EvList.FEvalItem.FPoint_prc = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_prc End if %>">
									<input type="hidden" id="stfPnt" name="stfPnt" value="<% if isNull(EvList.FEvalItem.FPoint_stf) or EvList.FEvalItem.FPoint_stf = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_stf End if %>">
								</div>
							</div>

							<%
							'//상품고시관련 상품후기 제외 상품이 아닐경우
							if Eval_excludeyn="N" then
							%>
							<div class="textarea">
								<% If Date() >= "2020-04-03" And Date() <= "2020-04-12" Then %>
								<textarea title="상품 후기 작성" cols="50" rows="5" name="usedcontents" placeholder="상품 후기를 작성하시면 마일리지 100p가 적립되며 포토 후기 작성 시 500p가 적립됩니다."><%= EvList.FEvalItem.FUesdContents %></textarea>
								<% Else %>
								<textarea title="상품 후기 작성" cols="50" rows="5" name="usedcontents" placeholder="상품 후기를 작성하시면 마일리지 100p가 적립됩니다."><%= EvList.FEvalItem.FUesdContents %></textarea>
								<% End If %>
							</div>
								<% if EvList.FEvalItem.FOptionName<>"" then %>
								<div class="itemOption">
									<h2>상품 옵션</h2>
									<div class="group">
										<span><input type="radio" onclick=fnAmplitudeEventMultiPropertiesAction('click_my_review_options','options','public'); id="open" class="frmRadioV16" name="useOpt" value="Y" checked/> <label for="open">공개</label></span>
										<span><input type="radio" onclick=fnAmplitudeEventMultiPropertiesAction('click_my_review_options','options','private'); id="hidden" class="frmRadioV16" name="useOpt" value="N"/> <label for="hidden">비공개</label></span>
									</div>
								</div>
								<% end if %>
							<div class="fileAttach">
								<div class="hgroup">
									<h2>사진 첨부</h2>
									<p>3장까지 첨부 가능</p>
								</div>
								<div class="fileList">
									<ul>
										<li>
											<input type="hidden" name="file1" value="<%=EvList.FEvalItem.getImageUrl1%>" />
											<%'!-- for dev msg : 사진 등록 전 --%>
											<div class="file" style="<%=chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"","display:none;")%>">
												<label for="fileupload" class="btnUpload">사진 등록</label>
											</div>

											<%'!-- for dev msg : 사진 등록 후 --%>
											<div class="thumbnail" style="<%=chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"display:none;","")%>">
												<img id="lyrBnrImg" src="<%=chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"",EvList.FEvalItem.getImageUrl1)%>"/>
												<button type="button" class="btn-del" onclick="jsDelImg('0');">삭제</button>
											</div>
										</li>
										<li>
											<input type="hidden" name="file2" value="<%=EvList.FEvalItem.getImageUrl2%>" />
											<%'!-- for dev msg : 사진 등록 전 --%>
											<div class="file" style="<%=chkIIF(EvList.FEvalItem.Flinkimg2="" or isNull(EvList.FEvalItem.Flinkimg2),"","display:none;")%>">
												<label for="fileupload" class="btnUpload">사진 등록</label>
											</div>

											<%'!-- for dev msg : 사진 등록 후 --%>
											<div class="thumbnail" style="<%=chkIIF(EvList.FEvalItem.Flinkimg2="" or isNull(EvList.FEvalItem.Flinkimg2),"display:none;","")%>">
												<img id="lyrBnrImg" src="<%=chkIIF(EvList.FEvalItem.Flinkimg2="" or isNull(EvList.FEvalItem.Flinkimg2),"",EvList.FEvalItem.getImageUrl2)%>"/>
												<button type="button" class="btn-del" onclick="jsDelImg('1');">삭제</button>
											</div>
										</li>
										<li>
											<input type="hidden" name="file3" value="<%=EvList.FEvalItem.getImageUrl3%>" />
											<%'!-- for dev msg : 사진 등록 전 --%>
											<div class="file" style="<%=chkIIF(EvList.FEvalItem.Flinkimg3="" or isNull(EvList.FEvalItem.Flinkimg3),"","display:none;")%>">
												<label for="fileupload" class="btnUpload">사진 등록</label>
											</div>

											<%'!-- for dev msg : 사진 등록 후 --%>
											<div class="thumbnail" style="<%=chkIIF(EvList.FEvalItem.Flinkimg3="" or isNull(EvList.FEvalItem.Flinkimg3),"display:none;","")%>">
												<img id="lyrBnrImg" src="<%=chkIIF(EvList.FEvalItem.Flinkimg3="" or isNull(EvList.FEvalItem.Flinkimg3),"",EvList.FEvalItem.getImageUrl3)%>"/>
												<button type="button" class="btn-del" onclick="jsDelImg('2');">삭제</button>
											</div>
										</li>
									</ul>
								</div>
							</div>
							<% Else %>
							<div class="textarea">
								<p>본 상품은 건강식품 및 의료기기에 해당되는<br /> 상품으로 고객 상품평 이용이 제한됩니다.<br /> (만족도 평가를 이용바랍니다.)</p>
							</div>
							<input type="hidden" name="file1" value="">
							<input type="hidden" name="file2" value="">
							<input type="hidden" name="file3" value="">
							<% End If %>

							<div class="btnGroup">
								<span class="button btB1 btRed cWh1 w100p"><input type="button" value="등록하기" onClick="fnAmplitudeEventMultiPropertiesAction('click_my_review_regist','',''); SubmitForm(this.form); return false;"/></span>
							</div>
							<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
						</form>
						<!-- 이미지 업로드 Form -->
						<form name="frmUpload" id="ajaxform" action="<%=staticImgUpUrl%>/common/simpleCommonImgUploadProc.asp" method="post" enctype="multipart/form-data" style="display:none; height:0px;width:0px;">
						<input type="file" name="upfile" id="fileupload" onchange="jsCheckUpload();" accept="image/*" />
						<input type="hidden" name="mode" id="fileupmode" value="upload">
						<input type="hidden" name="div" value="SB">
						<input type="hidden" name="tuid" value="<%=encUsrId%>">
						<input type="hidden" name="itemid" value="<%= EvList.FEvalItem.FItemID %>">
						<input type="hidden" name="prefile" id="filepre" value="">
						</form>
						<!-- 이미지 업로드 Form -->
					</fieldset>
				</div>
			</div>
			<% if isNull(EvList.FEvalItem.FTotalPoint) <> True AND EvList.FEvalItem.FTotalPoint <> "" then %>
			<script>setStar('<%=EvList.FEvalItem.FTotalPoint%>');</script>
			<% else %>
			<script>setStar('5');</script>
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