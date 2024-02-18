<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 테스터후기 작성
' History : 2016-01-11 원승현 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_tester_evaluatesearchercls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "테스터후기 작성"

dim userid, itemid, EvaluatedYN, cdL, userlevel, vIdx, vECode, vPCode

userid	= getEncLoginUserID
userlevel= GetLoginUserLevel
vIdx = requestCheckVar(request("idx"),10)
vECode = requestCheckVar(request("ecode"),10)
vPCode = requestCheckVar(request("pcode"),10)
itemID	= requestCheckVar(request("itemid"),10)
cdl		= requestCheckVar(request("cdl"),3)

'####### 작성된 글이 있는지 체크 #######
Dim ClsCheck, vCheck
Set ClsCheck = new CEvaluateSearcher
	ClsCheck.FRectUserID = Userid
	ClsCheck.FRectItemID = itemID
	ClsCheck.FECode = vECode
	ClsCheck.FPCode = vPCode
	ClsCheck.getIsTesterEvaluatedWrite()
	vCheck = ClsCheck.Fgubun
Set ClsCheck = nothing

If vCheck <> "x" Then
	If vCheck = "o" Then
		If vIdx = "" Then
			Response.Write "<script language='javascript'>alert('등록하신 글이 있습니다.');self.close();</script>"
			dbget.close() : response.end
		End IF
	Else
		Response.Write "<script language='javascript'>alert('잘못된 경로입니다.');self.close();</script>"
		dbget.close() : response.end
	End If
End If
'####### 작성된 글이 있는지 체크 #######

dim EvList
set EvList = new CEvaluateSearcher
	EvList.FIdx = vIdx
	EvList.FRectUserID = Userid
	EvList.FRectItemID = itemID
	EvList.FECode = vECode
	EvList.FPCode = vPCode
	EvList.getEvaluatedItem

if EvList.FResultCount < 1 then
	response.write "<script>alert('잘못된 접근입니다.');self.close();</script>"
	dbget.close() : response.end
end If

Dim vImgURL
vImgURL = staticImgUrl & "/testgoodsimage/" & GetImageSubFolderByItemid(itemID) & "/"

dim iandOrIos, iappVer, vProcess
iappVer = getAppVerByAgent(iandOrIos)
if (iandOrIos="a") then
    if (FnIsAndroidKiKatUp) then
        if (iappVer>="1.48") then
            ''신규 업노드
            vProcess = "A"
        else
            ''어플리케이션 1.48 이상 버전업이 필요하다.
            vProcess = "I"
        end if
    else
        '' 기존
        vProcess = "I"
    end if
else
    ''기존.
    vProcess = "I"
end if

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
	<script type="text/javascript">

	function SubmitForm(frm)
	{
		if (frm.usedcontents.value == ""||frm.usedcontents.value=="총평" ) {
				alert("총평을 적어주세요.");
				frm.usedcontents.focus();
				return;
		}

		if (frm.usedcontents.value.length>10000) {
			   alert("상품평은 10000자 이내로 작성해 주세요");
			   frm.usedcontents.focus();
			   return;
		}

		if (frm.usegood.value == ""||frm.usegood.value=="이런 점 좋았어요" ) {
				alert("이런 점 좋았어요를 적어주세요.");
				frm.usegood.focus();
				return;
		}

		if (frm.usegood.value.length>10000) {
			   alert("이런 점 좋았어요는 10000자 이내로 작성해 주세요");
			   frm.usegood.focus();
			   return;
		}

		if (frm.useetc.value == ""||frm.useetc.value=="특이한 점과 이용 Tip" ) {
				alert("특이한 점과 이용 Tip을 적어주세요.");
				frm.useetc.focus();
				return;
		}

		if (frm.useetc.value.length>10000) {
			   alert("특이한 점과 이용 Tip은 10000자 이내로 작성해 주세요");
			   frm.useetc.focus();
			   return;
		}


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

	function TxtClearVal(tform)
	{
		if ($("#"+tform).val()=="총평"||$("#"+tform).val()=="이런 점 좋았어요"||$("#"+tform).val()=="특이한 점과 이용 Tip")
		{
			$("#"+tform).val("");
		}
	}

	function TxtReturnClearVal(tform)
	{
		if ($("#"+tform).val()=="")
		{
			if (tform=="testerComment")
			{
				$("#"+tform).val("총평");
			}
			if (tform=="testerGood")
			{
				$("#"+tform).val("이런 점 좋았어요");
			}
			if (tform=="testerSpecial")
			{
				$("#"+tform).val("특이한 점과 이용 Tip");
			}
		}
	}


	var _selComp;
	var _no;

	function fnAPPuploadImage(comp, no) {
		_selComp = comp;
		_no = no;

		var paramname = comp.name;
		var upurl = "<%=staticImgUrl%>/linkweb/test_doevaluatewithimage_android_onlyimageupload.asp?itemid=<%=itemID%>&paramname="+paramname;
		if (no=="1"){
			callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish1});
		}else if(no=="2"){
			callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish2});
		}
		return false;
	}

	function _appUploadFinish(ret,ino){
	   //alert("["+ino+"]");
		if (_selComp){
			_selComp.value=ret.name;
			$('#imgspan'+ino).empty();
			$('#imgspan'+ino).html('<img src="<%=vImgURL%>'+ret.name+'" height="42" alt="" />');
		}
	}

	function appUploadFinish1(ret){
		_appUploadFinish(ret,1);
	}

	function appUploadFinish2(ret){
	   _appUploadFinish(ret,2);
	}

	function jsDelImage(a){
		$('#file'+a).val('');
		$('#imgspan'+a).empty();
		$('#imgspan'+a).text('이미지를 선택해주세요.');
	}
	</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content myReview" id="contentArea">
			<h2 class="hidden">테스터 후기 쓰기</h2>
			<div class="inner10">
				<ul class="cpNoti" style="border:0;">
					<li>테스터 후기와 상관 없는 판매 관련이나 홍보글은 사전통보 없이 관리자에 의해 삭제 될 수 있습니다.</li>
				</ul>
				<% If vProcess="A" then %>
					<form name="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/do_test_evaluatewithimage_app.asp"  onsubmit="return false;">
				<% Else %>
					<form name="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data" onsubmit="return false;">
				<% End If %>
				<input type="hidden" name="returnfolder" value="web2014" />
				<input type="hidden" name="idx" value="<%= EvList.FEvalItem.Fidx %>" />
				<input type="hidden" name="itemid" value="<%= EvList.FEvalItem.FItemID %>" />
				<input type="hidden" name="evtprize_code" value="<%=vPCode%>" />
				<input type="hidden" name="evt_code" value="<%=vECode%>" />
				<input type="hidden" id="apps" name="apps" value="apps">
				<input type="hidden" name="chkp5yn" value="Y" />

				<div class="reviewWrite">
					<div class="pdtWrap">
						<p class="pic"><img src="<%= EvList.FEvalItem.FImageIcon2 %>" alt="<%= EvList.FEvalItem.FItemName %>" /></p>
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

					<div>
						<textarea id="testerComment" name="usedcontents" cols="30" rows="5" class="w100p enterTxt" onfocus="TxtClearVal('testerComment');return false;" onfocusout="TxtReturnClearVal('testerComment');return false;"><% If EvList.FEvalItem.FUesdContents="" Then %>총평<% Else %><%=EvList.FEvalItem.FUesdContents%><% End If %></textarea>
					</div>
					<div>
						<textarea id="testerGood" name="usegood" cols="30" rows="5" class="w100p enterTxt" onfocus="TxtClearVal('testerGood');return false;" onfocusout="TxtReturnClearVal('testerGood');return false;"><% If EvList.FEvalItem.FUseGood="" Then %>이런 점 좋았어요<% Else %><%=EvList.FEvalItem.FUseGood%><% End If %></textarea>
					</div>
					<div>
						<textarea id="testerSpecial" name="useetc" cols="30" rows="5" class="w100p enterTxt" onfocus="TxtClearVal('testerSpecial');return false;" onfocusout="TxtReturnClearVal('testerSpecial');return false;"><% If EvList.FEvalItem.FUseETC="" then %>특이한 점과 이용 Tip<% Else %><%=EvList.FEvalItem.FUseETC%><% End If %></textarea>
					</div>
					<div>
						<input type="text" id="blogUrl" name="myblog" class="w100p enterTxt" value="<% If EvList.FEvalItem.FMyBlog <> "" Then %><%=EvList.FEvalItem.FMyBlog %><% Else %>http://<% End If %>" />
					</div>
					<p class="addTip bPad10"><span>*</span> 테스터 후기를 내 블로그에 포스팅한 분은 주소를 남겨주세요.</p>


					<% If vProcess="A" Then %>
						<div class="addImage">
							<p>
								<input type="hidden" name="file1" id="file1" value="">
								<button class="selectFile" onClick="fnAPPuploadImage(this.form.file1, '1');">파일선택</button>
								<span class="pic" id="imgspan1">이미지를 선택해주세요.</span>
								<button class="btnDel" onClick="jsDelImage('1'); return false;">파일 삭제</button>
							</p>
							<% if EvList.FEvalItem.Flinkimg1<>"" then %>
							<span class="pic">
								<img src="<%= EvList.FEvalItem.getLinkImage1 %>" alt="" />
								<input type="checkbox" name="file1_del" id="delImg01" /> <label for="delImg01">등록된 이미지 삭제</label>
							</span>
							<% end if %>
						</div>
						<div class="addImage">
							<p>
								<input type="hidden" name="file2" id="file2" value="">
								<button class="selectFile" onClick="fnAPPuploadImage(this.form.file2, '2');">파일선택</button>
								<span class="pic" id="imgspan2">이미지를 선택해주세요.</span>
								<button class="btnDel" onClick="jsDelImage('2'); return false;">파일 삭제</button>
							</p>
							<% if EvList.FEvalItem.Flinkimg2<>"" then %>
							<span class="pic">
								<img src="<%= EvList.FEvalItem.getLinkImage2 %>" alt="" />
								<input type="checkbox" name="file2_del" id="delImg02" /> <label for="delImg02">등록된 이미지 삭제</label>
							</span>
							<% end if %>
						</div>
					<% Else %>
						<div class="addImage">
							<p><input name="file1" id="file1" type="file" /> <button class="btnDel" onClick="jsDelImage('1');return false;"> <button class="btnDel" onClick="delimage('file1');return false;">파일 삭제</button></p>
							<% if EvList.FEvalItem.Flinkimg1<>"" then %>
								<span class="pic"><img src="<%= EvList.FEvalItem.getLinkImage1 %>" alt="" />
									<input type="checkbox" name="file1_del" id="delImg01" /> <label for="delImg01">등록된 이미지 삭제</label>
								</span>
							<% End If %>
						</div>

						<div class="addImage">
							<p><input name="file2" id="file2" type="file" /> <button class="btnDel" onClick="jsDelImage('2');return false;">파일 삭제</button></p>
							<% if EvList.FEvalItem.Flinkimg2<>"" then %>
								<span class="pic">
									<img src="<%= EvList.FEvalItem.getLinkImage2 %>" alt="" />
									<input type="checkbox" name="file2_del" id="delImg02" /> <label for="delImg02">등록된 이미지 삭제</label>
								</span>
							<% end if %>
						</div>
					<% End If %>
					<p class="addTip"><span>*</span> 포토후기는 최대 2장의 이미지를 첨부하실 수 있습니다.</p>

					<div class="starRating">
						<div class="score">
							<a href="" onClick="setStar('1'); return false;"><span id="star1"></span></a>
							<a href="" onClick="setStar('2'); return false;"><span id="star2"></span></a>
							<a href="" onClick="setStar('3'); return false;"><span id="star3"></span></a>
							<a href="" onClick="setStar('4'); return false;"><span id="star4"></span></a>
							<a href="" onClick="setStar('5'); return false;"><span id="star5"></span></a>
							<input type="hidden" id="totPnt" name="totPnt" value="<% if isNull(EvList.FEvalItem.FTotalPoint) or EvList.FEvalItem.FTotalPoint = "" then response.write "5" Else response.write EvList.FEvalItem.FTotalPoint End if %>">
							<input type="hidden" id="funPnt" name="funPnt" value="<% if isNull(EvList.FEvalItem.FPoint_fun) or EvList.FEvalItem.FPoint_fun = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_fun End if %>">
							<input type="hidden" id="dgnPnt" name="dgnPnt" value="<% if isNull(EvList.FEvalItem.FPoint_dgn) or EvList.FEvalItem.FPoint_dgn = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_dgn End if %>">
							<input type="hidden" id="PrcPnt" name="PrcPnt" value="<% if isNull(EvList.FEvalItem.FPoint_prc) or EvList.FEvalItem.FPoint_prc = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_prc End if %>">
							<input type="hidden" id="stfPnt" name="stfPnt" value="<% if isNull(EvList.FEvalItem.FPoint_stf) or EvList.FEvalItem.FPoint_stf = "" then response.write "5" Else response.write EvList.FEvalItem.FPoint_stf End if %>">
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
	</div>
</div>
</body>
</html>
<% Set EvList = Nothing %>
<%
function getAppVerByAgent(byref iosOrAnd)
    dim agnt : agnt =  Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    dim pos1 : pos1 = Instr(agnt,"tenapp ")
    dim buf
    dim retver : retver=""
    getAppVerByAgent = retver

    if (pos1<1) then exit function
    buf = Mid(agnt,pos1,255)

    iosOrAnd = MID(agnt,pos1 + LEN("tenapp "),1)
    getAppVerByAgent = Trim(MID(agnt,pos1 + LEN("tenapp ")+1,4))
end function

function FnIsAndroidKiKatUp()
    dim iiAgent : iiAgent= Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    FnIsAndroidKiKatUp = (InStr(iiAgent,"android 4.4")>0)
    FnIsAndroidKiKatUp = FnIsAndroidKiKatUp or (InStr(iiAgent,"android 5")>0) or (InStr(iiAgent,"android 6")>0) or (InStr(iiAgent,"android 7")>0)

end function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->