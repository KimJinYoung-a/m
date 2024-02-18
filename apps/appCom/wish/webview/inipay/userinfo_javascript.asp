	<script>
	$(function() {
		$('.orderListOpen').click(function(){
			$(this).parent().toggleClass('closeToggle');
			$(this).parent().parent().next().toggle();
			return false;
		});
		$('.openBtn').click(function(){
			$(this).toggleClass('closeToggle');
			$(this).next().toggle();
			return false;
		});

		$("input[name='rRange']:checked").parent().parent().parent().children('a').attr('closed','false');

	    $('.show-toggle-box').each(function(){
			if ( $(this).attr('closed') == 'false') {
				$(this).trigger('click');
			}
		});

		$('.accrodian dt').click(function(){
			if($(this).parent().children('dd').is(":hidden")){
				$('.accrodian dd').hide();
				$('.accrodian').removeClass('open');
				$(this).parent().children('dd').show();
				$(this).parent().addClass('open');
			}else{

				$(this).parent().children('dd').hide();
				$(this).parent().removeClass('open');
			};
		});

		$('.payMethod > span > input').click(function(){
			$('.inputView').hide();
			$("div[class='inputView'][id='"+'input'+$(this).attr("id")+"']").toggle();
		});


		//셀렉트 박스
		$("#chgmyaddr").change(function(){
			var frm = document.frmorder;

			frm.reqname.value	= $(this).children("option:selected").attr("tReqname");
			frm.txAddr1.value		= $(this).children("option:selected").attr("tTxAddr1");
			frm.txAddr2.value	 	= $(this).children("option:selected").attr("tTxAddr2");

			<% if IsForeignDlv Then %>
			// 해외배송정보
			var tel	= $(this).children("option:selected").attr("tReqPhone").split("-");
			frm.reqphone1.value	= tel[0];
			frm.reqphone2.value	= tel[1];
			frm.reqphone3.value	= tel[2];
			frm.reqphone4.value	= tel[3];

			frm.reqemail.value	= $(this).children("option:selected").attr("tReqemail");
			frm.emsZipCode.value	= $(this).children("option:selected").attr("tReqZipcode");

			if (frm.emsCountry)
			{
				frm.emsCountry.value	= $(this).children("option:selected").attr("tCountryCode");
				frm.countryCode.value	= $(this).children("option:selected").attr("tCountryCode");
				frm.emsAreaCode.value	= $(this).children("option:selected").attr("tEmsAreaCode");

				emsBoxChange(frm.emsCountry);
			}

			<% else %>

			// 국내배송정보
			var tel	= $(this).children("option:selected").attr("tReqPhone").split("-");
			frm.reqphone1.value	= tel[0];
			frm.reqphone2.value	= tel[1];
			frm.reqphone3.value	= tel[2];

			var hp	= $(this).children("option:selected").attr("tReqHp").split("-");
			frm.reqhp1.value	= hp[0];
			frm.reqhp2.value	= hp[1];
			frm.reqhp3.value	= hp[2];

			var zip	= $(this).children("option:selected").attr("tReqZipcode").split("-");
			frm.txZip1.value	= zip[0];
			frm.txZip2.value	= zip[1];

			<% end if %>

		});
	});
	</script>
	<script>
	var ChkErrMsg;

	// 플러그인 설치(확인)
	//StartSmartUpdate();

	function check_form_email(email){
		var pos;
		pos = email.indexOf('@');
		if (pos < 0){				//@가 포함되어 있지 않음
			return(false);
		}else{

			pos = email.indexOf('@', pos + 1)
			if (pos >= 0)			//@가 두번이상 포함되어 있음
				return(false);
		}


		pos = email.indexOf('.');

		if (pos < 0){				//@가 포함되어 있지 않음
			return false;
		}
		return(true);
	}


	function copyDefaultinfo(comp){
		var frm = document.frmorder;

		$("#addressOption1").removeClass("active");
		$("#addressOption2").removeClass("active");
		$("#addressOption3").removeClass("active");

		if (comp=="O"){
			$("#addressOption1").addClass("active");

			frm.reqname.value=frm.buyname.value;

			frm.reqphone1.value=frm.buyphone1.value;
			frm.reqphone2.value=frm.buyphone2.value;
			frm.reqphone3.value=frm.buyphone3.value;

			frm.reqhp1.value=frm.buyhp1.value;
			frm.reqhp2.value=frm.buyhp2.value;
			frm.reqhp3.value=frm.buyhp3.value;

			if (frm.buyZip1){
				frm.txZip1.value = frm.buyZip1.value;
				frm.txZip2.value = frm.buyZip2.value;
				frm.txAddr1.value = frm.buyAddr1.value;
				frm.txAddr2.value = frm.buyAddr2.value;
			}

		}else if (comp=="N" || comp=="R"){
			if(comp=="N"){
				$("#addressOption3").addClass("active");
			}else{
				$("#addressOption2").addClass("active");
			}
			frm.reqname.value = "";
			frm.reqphone1.value = "";
			frm.reqphone2.value = "";
			frm.reqphone3.value = "";
			frm.reqhp1.value = "";
			frm.reqhp2.value = "";
			frm.reqhp3.value = "";
			frm.txZip1.value = "";
			frm.txZip2.value = "";
			frm.txAddr1.value = "";
			frm.txAddr2.value = "";
		}else if (comp=="M"){     //해외주소New
			frm.reqname.value = "";
			frm.reqphone1.value = "";
			frm.reqphone2.value = "";
			frm.reqphone3.value = "";
			frm.reqphone4.value = "";

			frm.reqemail.value = "";
			frm.emsZipCode.value = "";

			frm.txAddr1.value = "";
			frm.txAddr2.value = "";
		}else if (comp=="F"){
			PopSeaAddress();
		}else if (comp=="P"){
			PopOldAddress();
		}

		if (comp=="R" || comp=="M")
		{
			document.getElementById("myaddress").style.display = "";
		}else{
			document.getElementById("myaddress").style.display = "none";
		}

	}

	function copyinfo(comp){
		var frm = document.frmorder;

		if (comp.checked==true){
			frm.reqname.value=frm.buyname.value;

			frm.reqphone1.value=frm.buyphone1.value;
			frm.reqphone2.value=frm.buyphone2.value;
			frm.reqphone3.value=frm.buyphone3.value;

			frm.reqhp1.value=frm.buyhp1.value;
			frm.reqhp2.value=frm.buyhp2.value;
			frm.reqhp3.value=frm.buyhp3.value;
		}else{
			frm.reqname.value="";

			frm.reqphone1.value="";
			frm.reqphone2.value="";
			frm.reqphone3.value="";

			frm.reqhp1.value="";
			frm.reqhp2.value="";
			frm.reqhp3.value="";
		};

	}

	function checkArmiDlv(){
		var reTest = new RegExp('사서함');
		return reTest.test(document.frmorder.txAddr2.value);

	}

	function searchzip(frmName){
		var popwin = window.open('/lib/searchzip.asp?target=' + frmName, 'searchzip10', 'width=460,height=250,scrollbars=yes,resizable=yes');
		popwin.focus();
	}

	function PopOldAddress(){
		var popwin = window.open('/my10x10/MyAddress/popMyAddressList.asp','popMyAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
		popwin.focus();
	}

	function PopSeaAddress(){
		var popwin = window.open('/my10x10/MyAddress/popSeaAddressList.asp','popSeaAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
		popwin.focus();
	}

	var popupMobileWindow;
	function PopMobileOrder(paymethod){
		/*
		// mobilians
		if(popupMobileWindow == undefined)
		{
			if(paymethod == "400")
			{
				popupMobileWindow = window.open('/inipay/mobile/step1.asp','popupMobileWindow','');
				popupMobileWindow.focus();
			}
		}
		else
		{
			try{
				if(paymethod == "400")
				{
					popupMobileWindow.location.href = "/inipay/mobile/step1.asp";
					popupMobileWindow.focus();
				}
				else
				{
					popupMobileWindow.close();
					popupMobileWindow = null;
				}
			}
			catch(e){
				if(paymethod == "400")
				{
					popupMobileWindow = window.open('/inipay/mobile/step1.asp','popupMobileWindow','');
					popupMobileWindow.focus();
				}
			}
		}
		*/

		// uplus
		/*
		if(paymethod == "400"){
			document.LGD_FRM.LGD_BUYER.value = document.frmorder.buyname.value;
			document.LGD_FRM.LGD_PRODUCTINFO.value = document.frmorder.mobileprdtnm.value;
			document.LGD_FRM.LGD_AMOUNT.value = document.frmorder.mobileprdprice.value;
			document.LGD_FRM.LGD_BUYEREMAIL.value = document.frmorder.buyemail.value;
			document.LGD_FRM.LGD_BUYERPHONE.value = document.frmorder.buyhp1.value + "" + document.frmorder.buyhp2.value + "" + document.frmorder.buyhp3.value;
			document.LGD_FRM.action="/inipay/xpay/payreq_crossplatform.asp"
			document.LGD_FRM.target="LGD_PAYMENTWINDOW_TOP_IFRAME";

			//setDisableComp();
			document.getElementById('LGD_PAYMENTWINDOW_TOP').style.display = "";
			document.LGD_FRM.isAx.value="";
			document.LGD_FRM.submit();
		}
        */
	}

	function setDisableComp(){
		var f=document.frmorder;
		if (f.rdDlvOpt){
			for(i=0;i<f.rdDlvOpt.length;i++) {
				cnj_var = f.rdDlvOpt[i];
				cnj_var.disabled = true;
			}
		}
		if (f.Tn_paymethod){
			for(i=0;i<f.Tn_paymethod.length;i++) {
				cnj_var = f.Tn_paymethod[i];
				cnj_var.disabled = true;
			}
		}
		if (f.itemcouponOrsailcoupon){
			for(i=0;i<f.itemcouponOrsailcoupon.length;i++) {
				cnj_var = f.itemcouponOrsailcoupon[i];
				cnj_var.disabled = true;
			}
		}
		if (f.sailcoupon){
			f.sailcoupon.disabled = true;
		}
		//disable_click();
	}

	function CheckPayMethod(comp){
		if (!CheckForm(document.frmorder))
		{
			for(var i=0;i<frmorder.Tn_paymethod.length;i++) {
				frmorder.Tn_paymethod[i].checked = false;
			}
			return;
		}

		var paymethod = comp.value;

		if (paymethod=="110") paymethod="100";

		if(paymethod == "400")
		{
			//$("html, body").animate({ scrollTop: 0 }, 600);

			//mobileiframe.document.location.href = "/inipay/mobile/step1.asp";
			//PopMobileOrder(paymethod);
			document.getElementById("paymethod_desc1_7").style.display = "none";
			document.getElementById("paymethod_desc1_100").style.display = "none";
			document.getElementById("paymethod_desc1_400").style.display = "block";
			document.getElementById("nextbutton1").style.display = "block";
		}
		else if(paymethod == "7")
		{
			//PopMobileOrder(paymethod);
			document.getElementById("paymethod_desc1_7").style.display = "block";
			document.getElementById("paymethod_desc1_100").style.display = "none";
			document.getElementById("paymethod_desc1_400").style.display = "none";
			document.getElementById("nextbutton1").style.display = "block";
		}
		else if(paymethod == "100")
		{
			//PopMobileOrder(paymethod);
			document.getElementById("paymethod_desc1_7").style.display = "none";
			document.getElementById("paymethod_desc1_400").style.display = "none";
			document.getElementById("paymethod_desc1_100").style.display = "block";
			document.getElementById("nextbutton1").style.display = "block";
		}

		<% if (Not IsCyberAccountEnable) then %>
		if (paymethod=='7'){
			alert('현재 가상계좌 오류로 가상계좌는 발급되지 않으며 아래 선택한 텐바이텐 계좌로 입금해 주시기 바랍니다..');
		}
		<% end if %>

		<% if IsTicketOrder then %>
		if (paymethod=='7'){
			alert('티켓상품은 무통장 입금 마감일이 티켓예약 익일 24:00까지 입니다. 이점 양해해 주시기 바랍니다.');
		}
		<% end if %>
	}

	function popansim(){
		var popwin;
		popwin = window.open('http://www.inicis.com/popup/C_popup/popup_C_02.html','popansim','scrollbars=yes,resizable=yes,width=620,height=600')
	}

	function popisp(){
		var popispwin;
		popispwin = window.open('http://www.10x10.co.kr/inipay/isp/isp.htm','popisp','scrollbars=yes,resizable=yes,width=580,height=600')
	}

	function popGongIn(){
		var popwin;
		popwin = window.open('http://www.inicis.com/popup/C_popup/popup_C_01.html','popGongIn','scrollbars=yes,resizable=yes,width=620,height=600')
	}

	function CheckForm(frm){
		//var paymethod = frm.Tn_paymethod[getCheckedIndex(frm.Tn_paymethod)].value;

		if (frm.buyname.value.length<1){
			alert('주문자 명을 입력하세요.');
			frm.buyname.focus();
			return false;
		}

		if ((frm.buyphone1.value.length<1)||(!IsDigit(frm.buyphone1.value))){
			alert('주문자 전화번호를 입력하세요.');
			frm.buyphone1.focus();
			return false;
		}

		if ((frm.buyphone2.value.length<1)||(!IsDigit(frm.buyphone2.value))){
			alert('주문자 전화번호를 입력하세요.');
			frm.buyphone2.focus();
			return false;
		}

		if ((frm.buyphone3.value.length<1)||(!IsDigit(frm.buyphone3.value))){
			alert('주문자 전화번호를 입력하세요.');
			frm.buyphone3.focus();
			return false;
		}


		if ((frm.buyhp1.value.length<1)||(!IsDigit(frm.buyhp1.value))){
			alert('주문자 핸드폰번호를 입력하세요.');
			frm.buyhp1.focus();
			return false;
		}

		if ((frm.buyhp2.value.length<1)||(!IsDigit(frm.buyhp2.value))){
			alert('주문자 핸드폰번호를 입력하세요.');
			frm.buyhp2.focus();
			return false;
		}

		if ((frm.buyhp3.value.length<1)||(!IsDigit(frm.buyhp3.value))){
			alert('주문자 핸드폰번호를 입력하세요.');
			frm.buyhp3.focus();
			return false;
		}

		if (frm.buyemail_Pre.value.length<1){
			alert('주문자 이메일 주소를 입력하세요.');
			frm.buyemail_Pre.focus();
			return false;
		}
		if (frm.buyemail_Bx.value.length<4){
			if (!check_form_email(frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value)){
				alert('주문자 이메일 주소가 올바르지 않습니다.');
				frm.buyemail_Tx.focus();
				return false;
			}
		}

		if (frm.buyemail_Bx.value.length<4){
			frm.buyeremail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value;
			frm.buyemail.value   = frm.buyeremail.value;
		}else{
			frm.buyeremail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Bx.value;
			frm.buyemail.value   = frm.buyeremail.value;
		}


		// 수령인
		if (frm.reqname.value.length<1){
			alert('수령인 명을 입력하세요.');
			frm.reqname.focus();
			return false;
		}


		<% if (IsForeignDlv) then %>
		if (frm.emsCountry.value.length<1){
			alert('배송 국가를 선택하세요.');
			frm.emsCountry.focus();
			return false;
		}

		if (frm.emsZipCode.value.length<1){
			alert('우편번호를 입력하세요.');
			frm.emsZipCode.focus();
			return false;
		}

		//필수인지 확인.
		if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
			alert('수령인 전화번호를 입력하세요.');
			frm.reqphone3.focus();
			return false;
		}

		if ((frm.reqphone4.value.length<1)||(!IsDigit(frm.reqphone4.value))){
			alert('수령인 전화번호를 입력하세요.');
			frm.reqphone4.focus();
			return false;
		}


		if (frm.txAddr1.value.length<1){
			alert('수령지 도시 및 주를  입력하세요.');
			frm.txAddr1.focus();
			return false;
		}

		if (frm.txAddr2.value.length<1){
			alert('수령지 상세 주소를  입력하세요.');
			frm.txAddr2.focus();
			return false;
		}

		//영문 체크
		if (!checkAsc(frm.reqname.value)){
			alert('영문으로 입력해 주세요.');
			frm.reqname.focus();
			return;
		}

		if (!checkAsc(frm.reqemail.value)){
			alert('영문으로 입력해 주세요.');
			frm.reqemail.focus();
			return;
		}

		if (!checkAsc(frm.emsZipCode.value)){
			alert('영문으로 입력해 주세요.');
			frm.emsZipCode.focus();
			return;
		}

		if (!checkAsc(frm.txAddr2.value)){
			alert('영문으로 입력해 주세요.');
			frm.txAddr2.focus();
			return;
		}

		if (!checkAsc(frm.txAddr1.value)){
			alert('영문으로 입력해 주세요.');
			frm.txAddr1.focus();
			return;
		}

		if (!frm.overseaDlvYak.checked){
			alert('해외배송 약관에 동의 하셔야 주문 가능합니다.');
			frm.overseaDlvYak.focus();
			return;
		}

		<% else %>
		if ((frm.reqphone1.value.length<1)||(!IsDigit(frm.reqphone1.value))){
			alert('수령인 전화번호를 입력하세요.');
			frm.reqphone1.focus();
			return false;
		}

		if ((frm.reqphone2.value.length<1)||(!IsDigit(frm.reqphone2.value))){
			alert('수령인 전화번호를 입력하세요.');
			frm.reqphone2.focus();
			return false;
		}

		if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
			alert('수령인 전화번호를 입력하세요.');
			frm.reqphone3.focus();
			return false;
		}

		if ((frm.reqhp1.value.length<1)||(!IsDigit(frm.reqhp1.value))){
			alert('수령인 핸드폰번호를 입력하세요.');
			frm.reqhp1.focus();
			return false;
		}

		if ((frm.reqhp2.value.length<1)||(!IsDigit(frm.reqhp2.value))){
			alert('수령인 핸드폰번호를 입력하세요.');
			frm.reqhp2.focus();
			return false;
		}

		if ((frm.reqhp3.value.length<1)||(!IsDigit(frm.reqhp3.value))){
			alert('수령인 핸드폰번호를 입력하세요.');
			frm.reqhp3.focus();
			return false;
		}

		<% if Not(IsRsvSiteOrder) then %>
	    try{
			if ((frm.txZip1.value.length<1)||(frm.txZip2.value.length<1)||(frm.txAddr1.value.length<1)){
				alert('수령지 주소를  입력하세요.');
				return false;
			}

			if (frm.txAddr2.value.length<1){
				alert('수령지 상세 주소를  입력하세요.');
				frm.txAddr2.focus();
				return false;
			}
		} catch (e) {}
		<% end if %>

		<% end if %>


		//플라워 관련
		<% if (oshoppingbag.IsFixDeliverItemExists) then %>

		var oyear = <%= yyyy %>;
		var omonth = <%= mm %>;
		var odate = <%= dd %>;
		var ohours = <%= hh %>;
		var MinTime = <%= tt %>;


		//Date함수는 0월부터 시작
		var reqDate = new Date(frm.yyyy.value,frm.mm.value-1,frm.dd.value,frm.tt.value);
		var nowDate = new Date(oyear,omonth-1,odate,ohours);
		var nextDay = new Date(oyear,omonth-1,odate,24);
		var fixDate = new Date(oyear,omonth-1,odate,MinTime);



		if (frm.fromname!=undefined){
			if (frm.fromname.value.length<1){
				alert('플라워 메세지 보내는 분 정보를 입력하세요.');
				frm.fromname.focus();
				return false;
			}
		}

		if (nowDate>reqDate){
			alert("지난 시간은 선택하실 수 없습니다.");
			frm.tt.focus();
			return false;
		}else if (fixDate>reqDate){
			alert("상품준비 시간이 최소 <%=oshoppingbag.getFixDeliverOrderLimitTime-1 &"-"& oshoppingbag.getFixDeliverOrderLimitTime%>시간입니다!\n좀더 넉넉한 시간을 선택해주세요!");
			frm.tt.focus();
			return false;
		}

		<% end if %>

		frm.gift_code.value="";
		frm.gift_kind_option.value="";
		frm.gift_kind_option.value="";

		<% if (OpenGiftExists) then %>
		//사은품 관련 추가
		var vgift_code = "";
		var vgiftkind_code = "";
		var vgift_kind_option = "";
		var openRdCnt = 0;
		if (frm.rRange){
			if (frm.rRange.length){
				for(var i=0;i<frm.rRange.length;i++){
					if (!frm.rRange[i].disabled) openRdCnt++;

					if (frm.rRange[i].checked){

						vgift_code     = frm.rGiftCode[i].value;
						vgiftkind_code = frm.rRange[i].value;

						if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
							var comp = eval("document.frmorder.gOpt_" + frm.rRange[i].value);
							if (comp.type!="hidden"){
								if (comp.value ==""){
									alert('사은품 옵션을 선택하세요');
									comp.focus();
									return false;
									//if (!confirm('사은품 옵션을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
									//    comp.focus();
									//    return false;
									//}
								}else if (comp.options[comp.selectedIndex].id =="S"){
									alert('품절된 옵션은 선택 불가 합니다.');
									comp.focus();
									return false;
								}


								vgift_kind_option = comp[comp.selectedIndex].value;
							}else{
								vgift_kind_option = comp.value;

							}

						}
					}
				}

			}else{
				if (!frm.rRange.disabled) openRdCnt++;
				if (frm.rRange.checked){
					vgift_code     = frm.rGiftCode.value;
					vgiftkind_code = frm.rRange.value;
					if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
						var comp = eval("frmorder.gOpt_" + frm.rRange.value);
						if (comp.type!="hidden"){
							if (comp.value ==""){
								alert('사은품 옵션을 선택하세요');
								comp.focus();
								return false;

								//if (!confirm('사은품 옵션을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
								//    comp.focus();
								//    return false;
								//}
							}else if (comp.options[comp.selectedIndex].id =="S"){
								alert('품절된 옵션은 선택 불가 합니다.');
								comp.focus();
								return false;
							}

							vgift_kind_option = comp[comp.selectedIndex].value;
						}else{
							vgift_kind_option = comp.value;
						}
					}
				}
			 }
		}

		frm.gift_code.value=vgift_code;
		frm.giftkind_code.value=vgiftkind_code;
		frm.gift_kind_option.value=vgift_kind_option;

		//사은품을 선택 안한경우
		if ((openRdCnt>0)&&(vgift_code=="")){
			if (!confirm('사은품을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
				return false;
			}
		}

		<% end if %>

        <% if (DiaryOpenGiftExists) then %>
        //다이어리 사은품 관련 추가
		var dgift_code = "";
		var dgiftkind_code = "";
		var dgift_kind_option = "";
		var openRdCnt = 0;
		if (frm.dRange){
			if (frm.dRange.length){
				for(var i=0;i<frm.dRange.length;i++){
					if (!frm.dRange[i].disabled) openRdCnt++;

					if (frm.dRange[i].checked){

						dgift_code     = frm.dtGiftCode[i].value;
						dgiftkind_code = frm.dRange[i].value;

						if (eval("document.frmorder.gOpt_" + frm.dRange[i].value)){
							var comp = eval("document.frmorder.gOpt_" + frm.dRange[i].value);
							if (comp.type!="hidden"){
								if (comp.value ==""){
									alert('사은품 옵션을 선택하세요');
									comp.focus();
									return false;
								}else if (comp.options[comp.selectedIndex].id =="S"){
									alert('품절된 옵션은 선택 불가 합니다.');
									comp.focus();
									return false;
								}
								dgift_kind_option = comp[comp.selectedIndex].value;
							}else{
								dgift_kind_option = comp.value;
							}
						}
					}
				}

			}else{
				if (!frm.dRange.disabled) openRdCnt++;
				if (frm.dRange.checked){
					dgift_code     = frm.dtGiftCode.value;
					dgiftkind_code = frm.dRange.value;
					if (eval("document.frmorder.gOpt_" + frm.dRange.value)){
						var comp = eval("frmorder.gOpt_" + frm.dRange.value);
						if (comp.type!="hidden"){
							if (comp.value ==""){
								alert('사은품 옵션을 선택하세요');
								comp.focus();
								return false;
							}else if (comp.options[comp.selectedIndex].id =="S"){
								alert('품절된 옵션은 선택 불가 합니다.');
								comp.focus();
								return false;
							}

							dgift_kind_option = comp[comp.selectedIndex].value;
						}else{
							dgift_kind_option = comp.value;
						}
					}
				}
			 }
		}

		frm.dGiftCode.value=dgift_code;
		//frm.giftkind_code.value=vgiftkind_code;
		//frm.gift_kind_option.value=vgift_kind_option;

		//사은품을 선택 안한경우
		//if ((openRdCnt>0)&&(dgift_code=="")){
		//	if (!confirm('사은품을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
		//		return false;
		//	}
		//}
		<% end if %>

		<% if (FALSE) and (DiaryOpenGiftExists) then %>
		//다이어리 사은품 관련 추가
		var dgMaxVal = <%=DiaryGiftCNT %>;
		var ttlDiVal = 0;
		var diAlldisable = true;

		if (frm.DiNo){
			for (var i=0;i<frm.DiNo.length;i++){
				if (frm.DiNo_disable[i].value=="Y"){
					frm.DiNo[i].value=0;
				}else{
					diAlldisable=false;
					ttlDiVal=ttlDiVal+frm.DiNo[i].value*1;
				}

			}

			if ((!diAlldisable)&&(ttlDiVal!=dgMaxVal)){
				alert('다이어리 사은품 증정가능수량 : '+dgMaxVal + '\n\n다이어리 사은품 선택수량 : '+ttlDiVal +'\n\n사은품을 더 선택해 주세요.');
				return false;
			}
		}

		<% end if %>

		return true;
	}

    <% if (isTenLocalUser) then %>
    var ilocalConfirmd = false;
    function fnTenLocalUserOrdCountCheck(){
        var frm = document.baguniFrm;
        var maxEa = 3;
        if (frm.itemea.length){
            for(var i=0;i<frm.itemea.length;i++){
            	if (frm.itemea[i].value*1>maxEa){
            	    return false;
            	}
            }
        }else{
            if (frm.itemea.value*1>maxEa){
                return false;
            }

        }

        return true;
    }

    function fnTenLocalUserConfirm(){
        //var popwin=window.open('popLocalUserConfirm.asp','enLocalUserConfirm','width=460,height=360,scrollbars=yes,resizable=yes')
        //popwin.focus();
        jsOpenModal('popLocalUserConfirm.asp')
    }

    function authPs(){
        ilocalConfirmd = true;
        setTimeout("PayNext(document.frmorder,'');",500);
    }
    <% end if %>


    var iclicked = false;

	function PayNext(frm, iErrMsg){
	//alert('잠시 결제 점검중입니다.');
	//return;

		if(frm.price.value*1>0) {
			var countpaymethod = 0;
			var numpaymethod = frm.Tn_paymethod.length;

			for(i=0; i<numpaymethod; i++)
			{
				if(frm.Tn_paymethod[i].checked == true)
				{
					countpaymethod += 1;
				}
			}
			if(countpaymethod == 0)
			{
				alert("결제수단을 선택하세요!");
				return;
			}

			if (frm.Tn_paymethod.length){
				var paymethod = frm.Tn_paymethod[getCheckedIndex(frm.Tn_paymethod)].value;
			}else{
				var paymethod = frm.Tn_paymethod.value;
			}
		}

		if (iErrMsg){
			alert(iErrMsg);
			return;
		}

		// 0원결제 (마일리지, 예치금 또는 Gift카드 사용시)
		if (frm.price.value*1==0){
			paymethod = "000";
		}

		//Check Default Form
		if (!CheckForm(frm)){
			return;
		}

		// APP쿠폰 확인
		if(frm.itemcouponOrsailcoupon[2].checked){
			frm.sailcoupon[0].value=frm.appcoupon.value;
		} else {
			frm.sailcoupon[0].value="";
		}

        <% if (isTenLocalUser)and(isTenLocalUserOrderCheck) then %>
        //직원 SMS 인증
        if ((frm.itemcouponOrsailcoupon[0].checked)&&(frm.sailcoupon.value.length>0)){
            var compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;
            var icoupontype  = compid.substr(0,1);
            var icouponvalue = compid.substr(2,255);

            if (((icoupontype*1==1)&&(icouponvalue*1>=20))||((icoupontype*1==2)&&(icouponvalue*1>=10000))){
                //if (!fnTenLocalUserOrdCountCheck()) {
                //    alert('직원쿠폰 구매시 한번에 최대 3개로 수량을 제한합니다.');
                //    return; //수량체크
                //}

                <% if session("tnsmsok")<>"ok" then %>
                if (!ilocalConfirmd){
                    alert('직원 SMS 인증을 시작합니다.');
                    fnTenLocalUserConfirm();
                    return;
                }
                <% end if %>
            }
        }

        <% end if %>

		//신용카드
		if ((paymethod=="100")||(paymethod=="110")){
			//alert('현재 BC, 국민카드등 ISP 결제를 이용한 카드결제가 장애로 인해 지연되고 있습니다. \n\n가능한 다른 카드를 이용 부탁드립니다.');

			if (frm.price.value<1000){
				alert('신용카드 최소 결제 금액은 1000원 이상입니다.');
				return;
			}

			if (paymethod=="110"){
				frm.gopaymethod.value = "onlyocbplus";
			}else{
				frm.gopaymethod.value = "onlycard";
			}

			frm.buyername.value = frm.buyname.value;

			frm.buyertel.value = frm.buyhp1.value + "-" + frm.buyhp2.value + frm.buyhp3.value;

			if (frm.itemcouponOrsailcoupon[1].checked){
				frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
			}else{
				frm.checkitemcouponlist.value = "";
			}

			frm.action = "<%=M_SSLUrl%>/inipay/card/order_temp_save.asp";
			frm.submit();

            /*
			document.errReport.spendmileage.value = frm.spendmileage.value;
			document.errReport.couponmoney.value = frm.couponmoney.value;
			document.errReport.spendtencash.value = frm.spendtencash.value;
			document.errReport.spendgiftmoney.value = frm.spendgiftmoney.value;
			document.errReport.price.value = frm.price.value;
			document.errReport.sailcoupon.value = frm.sailcoupon.value;
			document.errReport.checkitemcouponlist.value = frm.checkitemcouponlist.value;
			document.errReport.submit();
			*/
		}


		//실시간 이체

		//All@

		//모바일
		if (paymethod=="400")
		{
			if(document.frmorder.mobileprdprice.value > 300000){
				alert("휴대폰결제는 결제 최대 금액이 30만원 이하 입니다.");
				return;
			}else if(document.frmorder.mobileprdprice.value <100){
				alert("휴대폰결제는 결제 최소 금액은 100원 이상입니다.");
				return;
			}else{
				if (frm.itemcouponOrsailcoupon[1].checked){
					frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
				}else{
					frm.checkitemcouponlist.value = "";
				}

    			//PopMobileOrder(paymethod);
    			//document.getElementById("paymethod_desc1_7").style.display = "none";
    			//document.getElementById("paymethod_desc1_100").style.display = "none";
    			//document.getElementById("paymethod_desc1_400").style.display = "block";
    			//document.getElementById("nextbutton1").style.display = "none";
			}

			frm.action = "<%=M_SSLUrl%>/inipay/xpay/order_temp_save_submit.asp";
			frm.submit();
		}

		//무통장
		if (paymethod=="7"){
			if (frm.acctno.value.length<1){
				alert('입금하실 은행을 선택하세요. \r\n문자 메세지로 안내해 드립니다.');
				frm.acctno.focus();
				return;
			}

			if (frm.acctname.value.length<1){
				alert('입금자성명을 입력하세요..');
				frm.acctname.focus();
				return;
			}

			if (frm.price.value<0){
				alert('무통장입금 최소 결제 금액은 0원 이상입니다.');
				return;
			}else if (frm.price.value*1==0){
				alert('쿠폰 또는 마일리지 사용으로 결제금액이 0원인 경우 주문 후 고객센터로 연락바랍니다.');
			}

			// 현금영수증 신청
			if (frm.cashreceiptreq!=undefined){
				if (frm.cashreceiptreq.checked){
				   if (frm.useopt[0].checked){
						if (!checkCashreceiptSSN(0,frm.cashReceipt_ssn)){
							return false;
						}
				   }

				   if (frm.useopt[1].checked){
						if (!checkCashreceiptSSN(1,frm.cashReceipt_ssn)){
							return false;
						}
				   }
				}
			}


			// 전자보증서 발급에 필요한 추가 정보 입력 검사 (추가 2006.6.13; 시스템팀 허진원)
			if (frm.reqInsureChk!=undefined){
				if ((frm.reqInsureChk.value=="Y")&&(frm.reqInsureChk.checked)){
					/*
					if(!frm.insureSsn1.value||frm.insureSsn1.value.length<6) {
						alert("전자보증서 발급에 필요한 주민등록번호를 입력해주십시요.\n※ 주민등록번호 첫째자리는 6자리입니다.");
						frm.insureSsn1.focus();
						return;
					}

					if(!frm.insureSsn2.value||frm.insureSsn2.value.length<7) {
						alert("전자보증서 발급에 필요한 주민등록번호를 입력해주십시요.\n※ 주민등록번호 둘째자리는 7자리입니다.");
						frm.insureSsn2.focus();
						return;
					}
					*/
					if(!frm.insureBdYYYY.value||frm.insureBdYYYY.value.length<4||(!IsDigit(frm.insureBdYYYY.value))) {
						alert("전자보증서 발급에 필요한 생일의 년도를 입력해주십시요.");
						frm.insureBdYYYY.focus();
						return;
					}
					if(!frm.insureBdMM.value) {
						alert("전자보증서 발급에 필요한 생일의 월을 선택해주십시요.");
						frm.insureBdMM.focus();
						return;
					}
					if(!frm.insureBdDD.value) {
						alert("전자보증서 발급에 필요한 주문고객님의 생일을 선택해주십시요.");
						frm.insureBdDD.focus();
						return;
					}
					if(!frm.insureSex[0].checked&&!frm.insureSex[1].checked)
					{
						alert("전자보증서 발급에 필요한 주문고객님의 성별을 선택해주십시요.");
						return;
					}

					if(frm.agreeInsure[1].checked)
					{
						alert("전자보증서 발급에 필요한 개인정보이용에 동의를 하지 않으시면 전자보증서를 발급할 수 없습니다.");
						return;
					}
				}
			}

			var ret = confirm('주문 하시겠습니까?');
			if (ret){
				if (frm.itemcouponOrsailcoupon[1].checked){
					frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
				}else{
					frm.checkitemcouponlist.value = "";
				}

				frm.target = "";
				frm.action = "/inipay/AcctResult.asp";
				frm.submit();
			}

		}

		// 0원결제.
		if (paymethod=="000"){
			if (frm.price.value<0){
				alert('최소 결제 금액은 0원 이상입니다.');
				return;
			}

			var ret = confirm('결제하실 금액은 0원입니다. \n\n주문 하시겠습니까?');
			if (ret){
				if (frm.itemcouponOrsailcoupon[1].checked){
					frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
				}else{
					frm.checkitemcouponlist.value = "";
				}

				frm.target = "";
				frm.action = "/inipay/AcctResult.asp";
				frm.submit();
			}
		}
	}


	function getCheckedIndex(comp){
		var i =0;
		for( var i = 0 ; i <comp.length;  i++){
			if(comp[i].checked) return i;
		}
		return -1;
	}

	function enable_click(){
		document.frmorder.clickcontrol.value = "enable"
		nextbutton1.style.display = "";
		//nextbutton2.style.display = "none";
	}

	function disable_click(){
		document.frmorder.clickcontrol.value = "disable";
		nextbutton1.style.display = "none";
		//nextbutton2.style.display = "";
	}

	function defaultCouponSet(comp){
		var frm = document.frmorder;

		if (comp.value=="I"){
			RecalcuSubTotal(comp);
		}else if (comp.value=="S"){
			RecalcuSubTotal(frm.sailcoupon);
	   }else if (comp.value=="M"){
			RecalcuSubTotal(frm.appcoupon);
	   }else if (comp.value=="K"){
			RecalcuSubTotal(frm.kbcardsalemoney);
		}
	}


	function RecalcuSubTotal(comp){
		var frm = document.frmorder;
		var spendmileage = 0;
		var spendtencash = 0;
		var spendgiftmoney = 0;
		var itemcouponmoney = 0;
		var couponmoney  = 0;

		var availtotalMile = <%= availtotalMile %>;
		var availtotalTenCash = <%= availtotalTenCash %>;
		var availTotalGiftMoney = <%= availTotalGiftMoney %>;

		var emsprice     = 0;

		<% if (IsForeignDlv) then %>
		var totalbeasongpay= 0;
		var tenbeasongpay= 0;
		<% else %>
		var totalbeasongpay= <%= oshoppingbag.GetOrgBeasongPrice %>;
		var tenbeasongpay= <%= oshoppingbag.getTenDeliverItemBeasongPrice %>;
		<% end if %>

		var subtotalprice  = <%= subtotalprice %>;
		var fixprice  = <%= subtotalprice %>;

		// 상품 합계금액
		var itemsubtotal   = <%= oshoppingbag.GetTotalItemOrgPrice %>;

		// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
		var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

		//보너스 쿠폰인지 상품쿠폰인지여부.
		var ItemOrSailCoupon = "";
		var compid;

		//KB카드 할인
		var kbcardsalemoney = 0;

		spendmileage = frm.spendmileage.value*1;
		spendtencash = frm.spendtencash.value*1;
		spendgiftmoney = frm.spendgiftmoney.value*1;
		itemcouponmoney = frm.itemcouponmoney.value*1;
		couponmoney     = frm.couponmoney.value*1;

		// 보너스 쿠폰
		if (comp.name=="sailcoupon"){
			ItemOrSailCoupon = "S";
			frm.itemcouponOrsailcoupon[0].checked = true;
			frm.appcoupon.value="";

			compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

			coupontype  = compid.substr(0,1);
			couponvalue = compid.substr(2,255);

			if (coupontype=="0"){
				alert('적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.');
				frm.sailcoupon.value=""
				couponmoney = 0;
			}else if (coupontype=="1"){
				// % 보너스쿠폰
				//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
				couponmoney = parseInt(getPCpnDiscountPrice(couponvalue));

				// 추가 할인 불가 상품이 있을경우
				if (couponmoney*1==0){
					alert('추가 할인되는 상품이 없습니다.\n\n(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
					frm.sailcoupon.value=""
					couponmoney = 0;
				}else if ((itemsubtotal*1-<%= oshoppingbag.GetMileageShopItemPrice %>)!=duplicateSailAvailItemTotal){
					alert( '(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
				}
			}else if(coupontype=="2"){
				// 금액 보너스 쿠폰
				couponmoney = couponvalue*1;
			}else if(coupontype=="3"){
				//배송비 쿠폰.
				couponmoney = tenbeasongpay;
				<% if (IsForeignDlv) then %>
				if (tenbeasongpay==0){
					alert('해외 배송이므로 추가 할인되지 않습니다.');
					frm.sailcoupon.value=""
				}
				<% elseif (IsArmyDlv) then %>
				if (tenbeasongpay==0){
					alert('군부대 배송비는 추가 할인되지 않습니다.');
					frm.sailcoupon.value=""
				}
				<% else %>
				if (tenbeasongpay==0){
					alert('무료 배송이므로 추가 할인되지 않습니다.(텐바이텐 배송비만 할인적용가능)');
					frm.sailcoupon.value=""
				}
				<% end if %>
			}else{
				//미선택
				couponmoney = 0;
			}

            if(coupontype=="2"){
                couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
                if (couponmoney*1<1){
                    alert('추가 할인되는 상품이 없습니다.\n\n일부 추가할인 불가상품은 추가할인이 제외되거나 브라우져 새로고침 후 다시시도하시기 바랍니다..');
                    frm.sailcoupon.value=""
                    couponmoney = 0;
                }else{
                    var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                    altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                    altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                    altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                    alert(altMsg);

                }
            }

			//원 상품대보다 보너스 쿠폰 금액이 많은경우 = 원상품액 (배송비쿠폰은 제외)
			if ((couponmoney*1>itemsubtotal*1)&&(coupontype!="3")){
				couponmoney = itemsubtotal*1;
			}

			itemcouponmoney = 0;

			AssignItemCoupon(false);

			<% if (DiaryOpenGiftExists) then %>
    		frm.fixpriceTenItm.value = getCpnDiscountTenPrice(coupontype,couponvalue)
    		<% end if %>
		}

		// APP모바일 쿠폰
		if (comp.name=="appcoupon"){
			ItemOrSailCoupon = "M";
			frm.itemcouponOrsailcoupon[2].checked = true;
			frm.sailcoupon.value="";

			compid = frm.appcoupon[frm.appcoupon.selectedIndex].id;

			coupontype  = compid.substr(0,1);
			couponvalue = compid.substr(2,255);

			if (coupontype=="0"){
				alert('적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.');
				frm.appcoupon.value=""
				couponmoney = 0;
			}else if (coupontype=="1"){
				// % 보너스쿠폰
				//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
				couponmoney = parseInt(getPCpnDiscountPrice(couponvalue));

				// 추가 할인 불가 상품이 있을경우
				if (couponmoney*1==0){
					alert('추가 할인되는 상품이 없습니다.\n\n(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
					frm.appcoupon.value=""
					couponmoney = 0;
				}else if ((itemsubtotal*1-<%= oshoppingbag.GetMileageShopItemPrice %>)!=duplicateSailAvailItemTotal){
					alert( '(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
				}
			}else if(coupontype=="2"){
				// 금액 보너스 쿠폰
				couponmoney = couponvalue*1;
			}else if(coupontype=="3"){
				//배송비 쿠폰.
				couponmoney = tenbeasongpay;
				<% if (IsForeignDlv) then %>
				if (tenbeasongpay==0){
					alert('해외 배송이므로 추가 할인되지 않습니다.');
					frm.appcoupon.value=""
				}
				<% elseif (IsArmyDlv) then %>
				if (tenbeasongpay==0){
					alert('군부대 배송비는 추가 할인되지 않습니다.');
					frm.appcoupon.value=""
				}
				<% else %>
				if (tenbeasongpay==0){
					alert('무료 배송이므로 추가 할인되지 않습니다.(텐바이텐 배송비만 할인적용가능)');
					frm.appcoupon.value=""
				}
				<% end if %>
			}else{
				//미선택
				couponmoney = 0;
			}

            if(coupontype=="2"){
                couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
                if (couponmoney*1<1){
                    alert('추가 할인되는 상품이 없습니다.\n\n일부 추가할인 불가상품은 추가할인이 제외되거나 브라우져 새로고침 후 다시시도하시기 바랍니다..');
                    frm.appcoupon.value=""
                    couponmoney = 0;
                }else{
                    var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                    altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                    altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                    altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                    alert(altMsg);

                }
            }

			//원 상품대보다 보너스 쿠폰 금액이 많은경우 = 원상품액 (배송비쿠폰은 제외)
			if ((couponmoney*1>itemsubtotal*1)&&(coupontype!="3")){
				couponmoney = itemsubtotal*1;
			}

			itemcouponmoney = 0;

			AssignItemCoupon(false);

			<% if (DiaryOpenGiftExists) then %>
    		frm.fixpriceTenItm.value = getCpnDiscountTenPrice(coupontype,couponvalue)
    		<% end if %>
		}

		if (comp.name=="itemcouponOrsailcoupon"){
			ItemOrSailCoupon = "I";
			frm.itemcouponOrsailcoupon[1].checked = true;
			frm.sailcoupon.value="";

			couponmoney = 0;
			itemcouponmoney = AssignItemCoupon(true);

			<% if (IsItemFreeBeasongCouponExists) then %>
				itemcouponmoney = itemcouponmoney*1 + tenbeasongpay*1;
			<% end if %>
		}

		//KBCardMall
		if (frm.kbcardsalemoney){
			kbcardsalemoney = frm.kbcardsalemoney.value*1;
		}
		emsprice     = frm.emsprice.value*1;

		if (!IsDigit(frm.spendmileage.value)){
			frm.spendmileage.value = 0;
			alert('마일리지는 숫자만 가능합니다.');
			frm.spendmileage.value = 0;
		}

		if (spendmileage>availtotalMile){
			alert('사용 가능한 최대 마일리지는' + availtotalMile + ' Point 입니다.');
			frm.spendmileage.value = availtotalMile;

		}

		if (!IsDigit(frm.spendtencash.value)){
			frm.spendtencash.value = 0;
			alert('예치금 사용은 숫자만 가능합니다.');
			frm.spendtencash.value = 0;
		}

		if (!IsDigit(frm.spendgiftmoney.value)){
			frm.spendgiftmoney.value = 0;
			alert('Gift카드 사용은 숫자만 가능합니다.');
			frm.spendgiftmoney.value = 0;
		}

		if (spendtencash>availtotalTenCash){
			alert('사용 가능한 최대 예치금은' + availtotalTenCash + ' 원 입니다.');
			frm.spendtencash.value = availtotalTenCash;
		}

		if (spendgiftmoney>availTotalGiftMoney){
			alert('사용 가능한 Gift카드 잔액은' + availTotalGiftMoney + ' 원 입니다.');
			frm.spendgiftmoney.value = availTotalGiftMoney;

		}

		spendmileage = frm.spendmileage.value*1;
		spendtencash = frm.spendtencash.value*1;
		spendgiftmoney = frm.spendgiftmoney.value*1;

		if (spendmileage>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1)){
			alert('결제 하실 금액보다 마일리지를 더 사용하실 수 없습니다. 사용가능 마일리지는 ' + (itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1) + ' Point 입니다.');
			frm.spendmileage.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1;
			spendmileage = frm.spendmileage.value*1;
		}

		if (spendtencash>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1)){
			alert('결제 하실 금액보다 예치금을 더 사용하실 수 없습니다. 사용가능 예치금 ' + (itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1) + ' 원 입니다.');
			frm.spendtencash.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1;
			spendtencash = frm.spendtencash.value*1;
		}

		if (spendgiftmoney>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1)){
			alert('결제 하실 금액보다 Gift카드를 더 사용하실 수 없습니다. 사용가능 Gift카드 잔액은 ' + (itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1) + ' 원 입니다.');
			frm.spendgiftmoney.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1;
			spendgiftmoney = frm.spendgiftmoney.value*1;
		}

		fixprice = itemsubtotal*1 + totalbeasongpay*1 + itemcouponmoney*-1 + couponmoney*-1 + emsprice*1;
		subtotalprice = itemsubtotal*1 + totalbeasongpay*1 + spendmileage*-1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendtencash*-1 + emsprice*1+ spendgiftmoney*-1;

		<% if (IsForeignDlv) then %>
		document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice*1);
		<% end if %>

		document.getElementById("DISP_SPENDMILEAGE").innerHTML = plusComma(spendmileage*-1);
		document.getElementById("DISP_SPENDTENCASH").innerHTML = plusComma(spendtencash*-1);
		document.getElementById("DISP_SPENDGIFTMONEY").innerHTML = plusComma(spendgiftmoney*-1);

		document.getElementById("DISP_ITEMCOUPON_TOTAL").innerHTML = plusComma(itemcouponmoney*-1);
		document.getElementById("DISP_SAILCOUPON_TOTAL").innerHTML = plusComma(couponmoney*-1);
		if (document.getElementById("DISP_KBCARDSALE_TOTAL")) document.getElementById("DISP_KBCARDSALE_TOTAL").innerHTML = plusComma(kbcardsalemoney*-1);

		//document.getElementById("DISP_FIXPRICE").innerHTML = plusComma(fixprice*1);  //2013-04-12 리뉴얼때 빠짐
		document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(subtotalprice*1);
		document.frmorder.mobileprdprice.value = subtotalprice*1;

		//할인금액 토탈
		document.getElementById("DISP_SAILTOTAL").innerHTML = plusComma((couponmoney*-1)+(itemcouponmoney*-1)+(spendmileage*-1)+(spendtencash*-1)+(spendgiftmoney*-1));


		frm.itemcouponmoney.value = itemcouponmoney*1;
		frm.couponmoney.value = couponmoney*1;
		frm.price.value= subtotalprice*1;
		frm.fixprice.value= fixprice*1;

		CheckGift(false);

		if (subtotalprice==0){
			document.getElementById("i_paymethod").style.display = "none";
		}else{
			if (document.getElementById("i_paymethod").style.display=="none"){
				document.getElementById("i_paymethod").style.display = "block";
			}
		}
	}

	function RecalcuSubTotalOnly(comp){
		var frm = document.frmorder;
		var spendmileage = 0;
		var spendtencash = 0;
		var spendgiftmoney = 0;
		var itemcouponmoney = 0;
		var couponmoney  = 0;

		var availtotalMile = <%= availtotalMile %>;
		var availtotalTenCash = <%= availtotalTenCash %>;
		var availTotalGiftMoney = <%= availTotalGiftMoney %>;

		var emsprice     = 0;

		<% if (IsForeignDlv) then %>
		var totalbeasongpay= 0;
		var tenbeasongpay= 0;
		<% else %>
		var totalbeasongpay= <%= oshoppingbag.GetOrgBeasongPrice %>;
		var tenbeasongpay= <%= oshoppingbag.getTenDeliverItemBeasongPrice %>;
		<% end if %>

		var subtotalprice  = <%= subtotalprice %>;
		var fixprice  = <%= subtotalprice %>;

		// 상품 합계금액
		var itemsubtotal   = <%= oshoppingbag.GetTotalItemOrgPrice %>;

		// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
		var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

		//보너스 쿠폰인지 상품쿠폰인지여부.
		var ItemOrSailCoupon = "";
		var compid;

		//KB카드 할인
		var kbcardsalemoney = 0;

		spendmileage = frm.spendmileage.value*1;
		spendtencash = frm.spendtencash.value*1;
		spendgiftmoney = frm.spendgiftmoney.value*1;
		itemcouponmoney = frm.itemcouponmoney.value*1;
		couponmoney     = frm.couponmoney.value*1;

		// 보너스 쿠폰
		if (comp.name=="sailcoupon"){
			ItemOrSailCoupon = "S";
			frm.itemcouponOrsailcoupon[0].checked = true;
			frm.appcoupon.value="";

			compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

			coupontype  = compid.substr(0,1);
			couponvalue = compid.substr(2,255);

			if (coupontype=="0"){
				frm.sailcoupon.value=""
				couponmoney = 0;
			}else if (coupontype=="1"){
				// % 보너스쿠폰
				couponmoney = parseInt(getPCpnDiscountPrice(couponvalue));

				// 추가 할인 불가 상품이 있을경우
				if (couponmoney*1==0){
					frm.sailcoupon.value=""
					couponmoney = 0;
				}
			}else if(coupontype=="2"){
				// 금액 보너스 쿠폰
				couponmoney = couponvalue*1;
			}else if(coupontype=="3"){
				//배송비 쿠폰.
				couponmoney = tenbeasongpay;
				<% if (IsForeignDlv) then %>
				if (tenbeasongpay==0){
					frm.sailcoupon.value=""
				}
				<% elseif (IsArmyDlv) then %>
				if (tenbeasongpay==0){
					frm.sailcoupon.value=""
				}
				<% else %>
				if (tenbeasongpay==0){
					frm.sailcoupon.value=""
				}
				<% end if %>
			}else{
				//미선택
				couponmoney = 0;
			}

            if(coupontype=="2"){
                couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
                if (couponmoney*1<1){
                    frm.sailcoupon.value=""
                    couponmoney = 0;
                }
            }

			//원 상품대보다 보너스 쿠폰 금액이 많은경우 = 원상품액 (배송비쿠폰은 제외)
			if ((couponmoney*1>itemsubtotal*1)&&(coupontype!="3")){
				couponmoney = itemsubtotal*1;
			}

			itemcouponmoney = 0;

			AssignItemCoupon(false);

			<% if (DiaryOpenGiftExists) then %>
    		frm.fixpriceTenItm.value = getCpnDiscountTenPrice(coupontype,couponvalue)
    		<% end if %>
		}

		// APP모바일 쿠폰
		if (comp.name=="appcoupon"){
			ItemOrSailCoupon = "M";
			frm.itemcouponOrsailcoupon[2].checked = true;
			frm.sailcoupon.value="";

			compid = frm.appcoupon[frm.appcoupon.selectedIndex].id;

			coupontype  = compid.substr(0,1);
			couponvalue = compid.substr(2,255);

			if (coupontype=="0"){
				frm.appcoupon.value=""
				couponmoney = 0;
			}else if (coupontype=="1"){
				// % 보너스쿠폰
				couponmoney = parseInt(getPCpnDiscountPrice(couponvalue));

				// 추가 할인 불가 상품이 있을경우
				if (couponmoney*1==0){
					frm.appcoupon.value=""
					couponmoney = 0;
				}
			}else if(coupontype=="2"){
				// 금액 보너스 쿠폰
				couponmoney = couponvalue*1;
			}else if(coupontype=="3"){
				//배송비 쿠폰.
				couponmoney = tenbeasongpay;
				<% if (IsForeignDlv) then %>
				if (tenbeasongpay==0){
					frm.appcoupon.value=""
				}
				<% elseif (IsArmyDlv) then %>
				if (tenbeasongpay==0){
					frm.appcoupon.value=""
				}
				<% else %>
				if (tenbeasongpay==0){
					frm.appcoupon.value=""
				}
				<% end if %>
			}else{
				//미선택
				couponmoney = 0;
			}

            if(coupontype=="2"){
                couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
                if (couponmoney*1<1){
                    frm.appcoupon.value=""
                    couponmoney = 0;
                }
            }

			//원 상품대보다 보너스 쿠폰 금액이 많은경우 = 원상품액 (배송비쿠폰은 제외)
			if ((couponmoney*1>itemsubtotal*1)&&(coupontype!="3")){
				couponmoney = itemsubtotal*1;
			}

			itemcouponmoney = 0;

			AssignItemCoupon(false);

			<% if (DiaryOpenGiftExists) then %>
    		frm.fixpriceTenItm.value = getCpnDiscountTenPrice(coupontype,couponvalue)
    		<% end if %>
		}

		if (comp.name=="itemcouponOrsailcoupon"){
			ItemOrSailCoupon = "I";
			frm.itemcouponOrsailcoupon[1].checked = true;
			frm.sailcoupon.value="";

			couponmoney = 0;
			itemcouponmoney = AssignItemCoupon(true);

			<% if (IsItemFreeBeasongCouponExists) then %>
				itemcouponmoney = itemcouponmoney*1 + tenbeasongpay*1;
			<% end if %>
		}

		//KBCardMall
		if (frm.kbcardsalemoney){
			kbcardsalemoney = frm.kbcardsalemoney.value*1;
		}
		emsprice     = frm.emsprice.value*1;

		if (!IsDigit(frm.spendmileage.value)){
			frm.spendmileage.value = 0;
			frm.spendmileage.value = 0;
		}

		if (spendmileage>availtotalMile){
			frm.spendmileage.value = availtotalMile;
		}

		if (!IsDigit(frm.spendtencash.value)){
			frm.spendtencash.value = 0;
		}

		if (!IsDigit(frm.spendgiftmoney.value)){
			frm.spendgiftmoney.value = 0;
		}

		if (spendtencash>availtotalTenCash){
			frm.spendtencash.value = availtotalTenCash;
		}

		if (spendgiftmoney>availTotalGiftMoney){
			frm.spendgiftmoney.value = availTotalGiftMoney;

		}

		spendmileage = frm.spendmileage.value*1;
		spendtencash = frm.spendtencash.value*1;
		spendgiftmoney = frm.spendgiftmoney.value*1;

		if (spendmileage>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1)){
			frm.spendmileage.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1;
			spendmileage = frm.spendmileage.value*1;
		}

		if (spendtencash>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1)){
			frm.spendtencash.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1;
			spendtencash = frm.spendtencash.value*1;
		}

		if (spendgiftmoney>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1)){
			frm.spendgiftmoney.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1;
			spendgiftmoney = frm.spendgiftmoney.value*1;
		}

		fixprice = itemsubtotal*1 + totalbeasongpay*1 + itemcouponmoney*-1 + couponmoney*-1 + emsprice*1;
		subtotalprice = itemsubtotal*1 + totalbeasongpay*1 + spendmileage*-1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendtencash*-1 + emsprice*1+ spendgiftmoney*-1;

		<% if (IsForeignDlv) then %>
		document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice*1);
		<% end if %>

		document.getElementById("DISP_SPENDMILEAGE").innerHTML = plusComma(spendmileage*-1);
		document.getElementById("DISP_SPENDTENCASH").innerHTML = plusComma(spendtencash*-1);
		document.getElementById("DISP_SPENDGIFTMONEY").innerHTML = plusComma(spendgiftmoney*-1);

		document.getElementById("DISP_ITEMCOUPON_TOTAL").innerHTML = plusComma(itemcouponmoney*-1);
		document.getElementById("DISP_SAILCOUPON_TOTAL").innerHTML = plusComma(couponmoney*-1);
		if (document.getElementById("DISP_KBCARDSALE_TOTAL")) document.getElementById("DISP_KBCARDSALE_TOTAL").innerHTML = plusComma(kbcardsalemoney*-1);

		document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(subtotalprice*1);
		document.frmorder.mobileprdprice.value = subtotalprice*1;

		//할인금액 토탈
		document.getElementById("DISP_SAILTOTAL").innerHTML = plusComma((couponmoney*-1)+(itemcouponmoney*-1)+(spendmileage*-1)+(spendtencash*-1)+(spendgiftmoney*-1));


		frm.itemcouponmoney.value = itemcouponmoney*1;
		frm.couponmoney.value = couponmoney*1;
		frm.price.value= subtotalprice*1;
		frm.fixprice.value= fixprice*1;

		CheckGift(false);

		if (subtotalprice==0){
			document.getElementById("i_paymethod").style.display = "none";
		}else{
			if (document.getElementById("i_paymethod").style.display=="none"){
				document.getElementById("i_paymethod").style.display = "block";
			}
		}
	}

	function chkCouponDefaultSelect(comp){

		var frm = document.frmorder;
		var couponmoney  = 0;

		// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
		var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

		//보너스 쿠폰인지 상품쿠폰인지여부.
		var ItemOrSailCoupon = "";
		var compid;

		couponmoney     = frm.couponmoney.value*1;

		if (comp.name=="sailcoupon"){
			ItemOrSailCoupon = "S";
			frm.itemcouponOrsailcoupon[0].checked = true;
			frm.appcoupon.value="";

			compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

			coupontype  = compid.substr(0,1);
			couponvalue = compid.substr(2,255);

			if (coupontype=="0"){
				// 적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.
				frm.sailcoupon.value="";
				couponmoney = 0;
			}else if (coupontype=="1"){
				// % 보너스쿠폰
				couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);

				// 추가 할인 불가 상품이 있을경우
				if (couponmoney*1==0){
					//추가 할인되는 상품이 없습니다.
					frm.sailcoupon.value="";
					couponmoney = 0;
				}
			}

		} else if (comp.name=="appcoupon"){
			ItemOrSailCoupon = "M";
			frm.itemcouponOrsailcoupon[2].checked = true;
			frm.sailcoupon.value="";

			compid = frm.appcoupon[frm.appcoupon.selectedIndex].id;

			coupontype  = compid.substr(0,1);
			couponvalue = compid.substr(2,255);

			if (coupontype=="0"){
				// 적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.
				frm.appcoupon.value="";
				couponmoney = 0;
			}else if (coupontype=="1"){
				// % 보너스쿠폰
				couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);

				// 추가 할인 불가 상품이 있을경우
				if (couponmoney*1==0){
					//추가 할인되는 상품이 없습니다.
					frm.appcoupon.value="";
					couponmoney = 0;
				}
			}
		}
		RecalcuSubTotalOnly(comp);
	}


	function giftOptEnable(comp){
		<% if (OpenGiftExists) then %>
			<% for i=0 to oOpenGift.FResultCount-1 %>
			if (document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>){
				document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>.disabled = true;
				document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>.selectedIndex=0;
			}
			<% next %>
		<% end if %>

		if (eval("document.frmorder.gOpt_" + comp.value)){
			eval("document.frmorder.gOpt_" + comp.value).disabled = false;
		}
	}

	function giftOptChange(comp){
		if (comp.options[comp.selectedIndex].id=="S"){
			alert('품절된 옵션은 선택 불가합니다.');
			comp.selectedIndex=0;
			comp.focus();
			return;
		}
	}

	function CheckGift(isFirst){
		var frm = document.frmorder;
		var fixprice = frm.fixprice.value*1;
		var availCnt = 0;
		var ischked = 0;
		if (frm.rRange){
			if (frm.rRange.length){
				for(var i=0;i<frm.rRange.length;i++){
					if (fixprice*1>=frm.rRange[i].id*1){
						frm.rRange[i].disabled = false;
						//default chk tenDlv
						if (frm.rGiftDlv[i].value=="N"){
							if (isFirst){
								frm.rRange[i].checked = true;
								 giftOptEnable(frm.rRange[i]);
								ischked = 1;
							}else{
								if (frm.rRange[i].checked) ischked = 1;
							}
						}

						if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
							eval("document.frmorder.gOpt_" + frm.rRange[i].value).disabled = false;

						}

						availCnt++;
					}else{
						frm.rRange[i].disabled = true;
						frm.rRange[i].checked = false;
						if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
							eval("document.frmorder.gOpt_" + frm.rRange[i].value).disabled = true;
						}
					}
				}
			}else{
				if (fixprice*1>=frm.rRange.id*1){
					frm.rRange.disabled = false;
					if (isFirst){
						frm.rRange.checked = true;
						giftOptEnable(frm.rRange);
						ischked = 1;
					}else{
						if (frm.rRange.checked) ischked = 1;
					}

					if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
						eval("document.frmorder.gOpt_" + frm.rRange.value).disabled = false;
					}
					availCnt++;
				}else{
					frm.rRange.disabled = true;
					frm.rRange.checked = false;
					if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
						eval("document.frmorder.gOpt_" + frm.rRange.value).disabled = true;
					}
				}
			}

			//When NoChecked Check Last
			if (ischked!=1){
				if (frm.rRange.length){
					for(var i=0;i<frm.rRange.length;i++){
						if (frm.rRange[i].disabled!=true){
							frm.rRange[i].checked = true;
							giftOptEnable(frm.rRange[i]);
						}
					}
				}else{
					frm.rRange.checked = true;
					giftOptEnable(frm.rRange);
				}
			}
		}

		//20121012
		checkDiaryGift(isFirst);
	}

	function plusComma(num){
		if (num < 0) { num *= -1; var minus = true}
		else var minus = false

		var dotPos = (num+"").split(".")
		var dotU = dotPos[0]
		var dotD = dotPos[1]
		var commaFlag = dotU.length%3

		if(commaFlag) {
			var out = dotU.substring(0, commaFlag)
			if (dotU.length > 3) out += ","
		}
		else var out = ""

		for (var i=commaFlag; i < dotU.length; i+=3) {
			out += dotU.substring(i, i+3)
			if( i < dotU.length-3) out += ","
		}

		if(minus) out = "-" + out
		if(dotD) return out + "." + dotD
		else return out
	}

    function AssignBonusCoupon(bool,icoupontype,icouponvalue){
        var iasgnCouponMoney = 0;
        if ((icoupontype=="2")&&(icouponvalue*1>0)){
            $.ajax({
        		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&jumunDiv=<%=jumunDiv%>",
        		cache: false,
        		async: false,
        		success: function(message) {
        			iasgnCouponMoney = message;
        		}
        	});
        }
        return iasgnCouponMoney;
    }

	function AssignItemCoupon(bool){
		var itemcouponmoney = 0 ;
		var frm = document.baguniFrm;

		if (frm.distinctkey.length==undefined){
			if ((bool)&&(frm.curritemcouponidxflag.value!="")){
				itemcouponmoney = frm.couponsailpriceflag.value * 1;
				//document.all["HTML_itemcouponcost_0"].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag.value) + " <font color='#777777'>원</font>";
				//document.all["HTML_itemcouponcostsum_0"].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10'> " + plusComma(frm.itemcouponsellpriceflag.value*1*frm.itemea.value*1) + " <font color='#777777'>원</font>";
			}else{
				//document.all["HTML_itemcouponcost_0"].innerHTML = "";
				//document.all["HTML_itemcouponcostsum_0"].innerHTML = "";
			}
		}else{
			for (var i=0;i<frm.distinctkey.length;i++){
				if ((bool)&&(frm.curritemcouponidxflag[i].value!="")){
					itemcouponmoney = itemcouponmoney + frm.couponsailpriceflag[i].value * 1;
					distinctkey = frm.distinctkey[i].value;
					//document.all["HTML_itemcouponcost_" + distinctkey].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag[i].value) + " <font color='#777777'>원</font>";
					//document.all["HTML_itemcouponcostsum_" + distinctkey].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag[i].value*1*frm.itemea[i].value*1) + " <font color='#777777'>원</font>";

				}else{
					distinctkey = frm.distinctkey[i].value;
					//document.all["HTML_itemcouponcost_" + distinctkey].innerHTML = "";
					//document.all["HTML_itemcouponcostsum_" + distinctkey].innerHTML = "";
				}
			}
		}

		return itemcouponmoney;
	}

	function getPCpnDiscountPrice(icouponvalue){
		var pcouponmoney = 0 ;
		var frm = document.baguniFrm;
		if (frm.distinctkey.length==undefined){
			pcouponmoney = parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
		}else{
			for (var i=0;i<frm.distinctkey.length;i++){
				pcouponmoney = pcouponmoney*1 + parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
			}
		}

		return pcouponmoney;
	}

    function getCpnDiscountTenPrice(icoupontype, icouponvalue){
        var frm = document.baguniFrm;
        var dval = <%=TenDlvItemPriceCpnAssign%>;
        var cval = 0
        var udExsists = false;

        if (icoupontype=='1'){
            if (frm.distinctkey.length==undefined){
                if ((frm.dtypflag.value=="1")||(frm.dtypflag.value=="4")){
                    cval = frm.isellprc.value*1*frm.itemea.value*1 - parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
                }
            }else{
                for (var i=0;i<frm.distinctkey.length;i++){
                    if ((frm.dtypflag[i].value=="1")||(frm.dtypflag[i].value=="4")){
                        cval = cval*1 + frm.isellprc[i].value*1*frm.itemea[i].value*1 - parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
                    }
                }
            }

            return cval;

        }else if (icoupontype=='2'){
            if (frm.distinctkey.length==undefined){
                if ((frm.dtypflag.value!="1")&&(frm.dtypflag.value!="4")){
                    udExsists = true
                }
            }else{
                for (var i=0;i<frm.distinctkey.length;i++){
                   if ((frm.dtypflag[i].value!="1")&&(frm.dtypflag[i].value!="4")){
                    udExsists = true;
                    break;
                   }
                }
            }
            if (udExsists){
                return dval;
            }else{
                return dval*1-icouponvalue*1;
                alert(icouponvalue)
            }
        }else{
            return dval;
        }
    }

	//function showInsureDetail(comp){
	//	if (comp.checked){
	//		document.getElementById("insure_detail").style.display = "inline";
	//	}else{
	//		document.getElementById("insure_detail").style.display = "none";
	//	}
	//}
	//
	//function showCashReceptDetail(comp){
	//	if (comp.checked){
	//		document.getElementById("cashReceipt_detail").style.display = "inline";
	//	}else{
	//		document.getElementById("cashReceipt_detail").style.display = "none";
	//	}
	//}

	function showCashReceptSubDetail(comp){
		if (comp.value=="0"){
			//document.getElementById("cashReceipt_subdetail1").style.display = "inline";
			//document.getElementById("cashReceipt_subdetail2").style.display = "none";
		}else{
			//document.getElementById("cashReceipt_subdetail1").style.display = "none";
			//document.getElementById("cashReceipt_subdetail2").style.display = "inline";
		}
	}

	function emsBoxChange(comp){
		var frm = comp.form;
		var iMaxWeight = 30000;  //(g)
		var totalWeight = <%= oshoppingbag.getEmsTotalWeight %>;
		var contryName = '';

		if (comp.value==''){
			frm.countryCode.value = '';
			frm.emsAreaCode.value = '';
			document.getElementById("divEmsAreaCode").innerHTML = "1";
			contryName = frm.countryCode.text;
		}else{
			frm.countryCode.value = comp.value;

			//for firefox
			frm.emsAreaCode.value = comp[comp.selectedIndex].id.substr(0,1);
			iMaxWeight = comp[comp.selectedIndex].id.substr(2,255);
			//frm.emsAreaCode.value = comp[comp.selectedIndex].iAreaCode;
			//iMaxWeight = comp[comp.selectedIndex].iMaxWeight;
			document.getElementById("divEmsAreaCode").innerHTML = frm.emsAreaCode.value;
			contryName = comp[comp.selectedIndex].text;
		}


		//iMaxWeight 체크
		if (totalWeight>iMaxWeight){
			alert('죄송합니다. ' + contryName + ' 최대 배송 가능 중량은 ' + iMaxWeight + ' (g)입니다.');
			comp.value='';
			//return;
		}

		//가격 계산.
		calcuEmsPrice(frm.emsAreaCode.value);

	}

	function calcuEmsPrice(emsAreaCode){
		//divEmsPrice
		var emsprice = 0;

		var _emsAreaCode = new Array(<%= oemsPrice.FResultCount %>);
		var _emsPrice = new Array(<%= oemsPrice.FResultCount %>);

		<% for i=0 to oemsPrice.FResultCount-1 %>
			_emsAreaCode[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsAreaCode %>';
			_emsPrice[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsPrice %>';
		<% next %>

		for (var i=0;i<_emsAreaCode.length;i++){
			if (_emsAreaCode[i]==emsAreaCode){
				emsprice = _emsPrice[i];
				break;
			}
		}

		document.getElementById("divEmsPrice").innerHTML = plusComma(emsprice);
		document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice);

		document.frmorder.emsprice.value = emsprice;
		RecalcuSubTotal(document.frmorder.emsprice);
	}

	function popEmsApplyGoCondition(){
		var nation = 'GR';
		if (document.frmorder.countryCode.value!='') nation = document.frmorder.countryCode.value;

		jsOpenModal("http://ems.epost.go.kr:8080/front.EmsApplyGoCondition.postal?nation=" + nation + "");
	}

	function popEmsCharge(){
		var areaCode = '';
		if (document.frmorder.emsAreaCode.value!='') areaCode = document.frmorder.emsAreaCode.value;
		if (areaCode=='undefined') areaCode='';

		if (areaCode==''){
			alert('국가를 먼저 선택 하세요.');
			document.frmorder.emsCountry.focus();
			return;
		}
		jsOpenModal("popEmsCharge.asp?areaCode=" + areaCode + "");
	}


	function checkCashreceiptSSN(opttype,ssncomp){
		if (opttype==0){
			if(ssncomp.value.length !=10 && ssncomp.value.length !=11 && ssncomp.value.length !=18){
				alert("올바른 휴대폰 번호 10자리(11자리) 또는 현금영수증카드 번호를 입력하세요.");
				ssncomp.focus();
				return false;
			} else if(ssncomp.value.length == 11 ||ssncomp.value.length == 10 ){
				var obj = ssncomp.value;
				if (obj.substring(0,3)!= "011" && obj.substring(0,3)!= "017" && obj.substring(0,3)!= "016" && obj.substring(0,3)!= "018" && obj.substring(0,3)!= "019" && obj.substring(0,3)!= "010")
				{
					alert("올바른 휴대폰 번호 10자리(11자리)를 입력하세요. ");
					ssncomp.focus();
					return false;
				}

				var chr1;
				for(var i=0; i<obj.length; i++){

						chr1 = obj.substr(i, 1);
						if( chr1 < '0' || chr1 > '9') {
						alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
						ssncomp.focus();
						return false;
					}
				}
			} else if(ssncomp.value.length == 18 ){
				var obj = ssncomp.value;
				var chr1;
				for(var i=0; i<obj.length; i++){
						chr1 = obj.substr(i, 1);
						if( chr1 < '0' || chr1 > '9') {
						alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
						ssncomp.focus();
						return false;
					}
				}
			}
		}

		if (opttype==1){
			if(ssncomp.value.length !=10  && ssncomp.value.length !=11 && ssncomp.value.length !=18){
				alert("올바른 사업자등록번호 10자리, 현금영수증카드 13자리 또는 휴대폰 번호 10자리(11자리)를 입력하세요.");
				ssncomp.focus();
				return false;
			} else if(ssncomp.value.length == 10 && ssncomp.value.substring(0,1)!= "0"){
				var vencod = ssncomp.value;
				var sum1 = 0;
				var getlist =new Array(10);
				var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
				for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
				for(var i=0; i<9; i++) { sum1 += getlist[i]*chkvalue[i]; }
				sum1 = sum1 + parseInt((getlist[8]*5)/10);
				sidliy = sum1 % 10;
				sidchk = 0;
				if(sidliy != 0) { sidchk = 10 - sidliy; }
				else { sidchk = 0; }
				if(sidchk != getlist[9]) {
					alert("올바른 사업자 번호를 입력하시기 바랍니?¤. ");
					ssncomp.focus();
					return false;
				}
				else
				{
					//alert("number ok");
					//return;
				}

			}
			else if(ssncomp.value.length == 11 ||ssncomp.value.length == 10 )
			{
				var obj = ssncomp.value;
				if (obj.substring(0,3)!= "011" && obj.substring(0,3)!= "017" && obj.substring(0,3)!= "016" && obj.substring(0,3)!= "018" && obj.substring(0,3)!= "019" && obj.substring(0,3)!= "010")
				{
					alert("실제 번호를 입력하시지 않아 실행에 실패하였습니다. 다시 입력하시기 바랍니다. ");
					ssncomp.focus();
					return false;
				}

				var chr;
				for(var i=0; i<obj.length; i++){
					chr = obj.substr(i, 1);
					if( chr < '0' || chr > '9') {
						alert("실제 번호를 입력하시지 않아 실행에 실패하였습니다. 다시 입력하시기 바랍니다. ");
						ssncomp.focus();
						return false;
					}
				}
		   } else if(ssncomp.value.length == 18 ){
				var obj = ssncomp.value;
				var chr1;
				for(var i=0; i<obj.length; i++){
						chr1 = obj.substr(i, 1);
						if( chr1 < '0' || chr1 > '9') {
						alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
						ssncomp.focus();
						return false;
					}
				}
			}
		}
		return true;
	}

	function fnChgKakaoSend() {
		var frm = document.frmorder;
		if(frm.chkKakaoSend.checked) {
			if(frm.buyhp1.value!=frm.buyhp1.getAttribute("default")||frm.buyhp2.value!=frm.buyhp2.getAttribute("default")||frm.buyhp3.value!=frm.buyhp3.getAttribute("default")) {
				if(confirm("카카오톡으로 받기는 인증을 한 휴대번호인 경우에만 가능합니다.\n인증받으신 번호로 수정하시겠습니까?")) {
					frm.buyhp1.value=frm.buyhp1.getAttribute("default");
					frm.buyhp2.value=frm.buyhp2.getAttribute("default");
					frm.buyhp3.value=frm.buyhp3.getAttribute("default");
					frm.buyhp1.readOnly=true;
					frm.buyhp2.readOnly=true;
					frm.buyhp3.readOnly=true;
				} else {
					frm.chkKakaoSend.checked=false;
				}
			} else {
				frm.buyhp1.readOnly=true;
				frm.buyhp2.readOnly=true;
				frm.buyhp3.readOnly=true;
			}
		} else {
			frm.buyhp1.readOnly=false;
			frm.buyhp2.readOnly=false;
			frm.buyhp3.readOnly=false;
		}
	}

	function fnChkKakaoHp(fm) {
		if(fm.readOnly) {
			alert("주문정보 카카오톡으로 받기 선택 해제를 하셔야 휴대번호 수정이 가능합니다.");
		}
	}

	function UpDnDiaryGift(i,n){
		var frm = document.frmorder;
		var pVal = 0;
		var ttlDiVal = 0;
		var dgMaxVal = <%=DiaryGiftCNT %>;
		var comp=null;

		if (frm.DiNo[i]){
			comp=frm.DiNo[i];
			if (frm.DiNo_disable[i].value!="Y"){
				pVal = comp.value*1;
				comp.value=comp.value*1+n*1;

				if (comp.value*1<1) comp.value=0;

				if (comp.value*1>dgMaxVal){
					comp.value=dgMaxVal;
					alert('받으실 사은품수량 '+dgMaxVal+'개를 초과할 수 없습니다.');
					return;
				}
			}else{
				comp.value=0;
			}
		}

		if (frm.DiNo.length){
			ttlDiVal=0;
			for (var i=0;i<frm.DiNo.length;i++){
				ttlDiVal = ttlDiVal + frm.DiNo[i].value*1;
			}

			if ((n*1>0)&&(ttlDiVal>dgMaxVal)){
				for (var i=0;i<frm.DiNo.length;i++){
					if (comp!=frm.DiNo[i]){
						if (frm.DiNo[i].value*1>=n*1){
							frm.DiNo[i].value=frm.DiNo[i].value*1-n*1;
							break;
						}
					}
				}
			}
			ttlDiVal=0;
			for (var i=0;i<frm.DiNo.length;i++){
				ttlDiVal = ttlDiVal + frm.DiNo[i].value*1;
			}
		}

		if (document.getElementById("HTML_DiaryGiftSelCNT")){
			document.getElementById("HTML_DiaryGiftSelCNT").innerHTML = plusComma(ttlDiVal*1);
		}

	}

    function checkDiaryGift(isFirst){
        var frm = document.frmorder;
		var availCnt = 0;
		var ischked = 0;
		var TenDlvItemPrice = 0;

		if (frm.TenDlvItemPrice){
			frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnNotAssign%>;
			if (frm.itemcouponOrsailcoupon[1].checked){
				frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnAssign%>;
			}else{
                frm.TenDlvItemPrice.value=frm.fixpriceTenItm.value;
            }

			TenDlvItemPrice = frm.TenDlvItemPrice.value;
		}

		if (frm.dRange){
			if (frm.dRange.length){
				for(var i=0;i<frm.dRange.length;i++){
					if (TenDlvItemPrice*1>=frm.dRange[i].id*1){
						frm.dRange[i].disabled = false;
						//default chk tenDlv
						if (frm.dGiftDlv[i].value=="N"){
							if (isFirst){
								frm.dRange[i].checked = true;
								 giftOptEnable(frm.dRange[i]);
								ischked = 1;
							}else{
								if (frm.dRange[i].checked) ischked = 1;
							}
						}

						availCnt++;
					}else{
						frm.dRange[i].disabled = true;
						frm.dRange[i].checked = false;
					}
				}
			}else{
				if (TenDlvItemPrice*1>=frm.dRange.id*1){
					frm.dRange.disabled = false;
					if (isFirst){
						frm.dRange.checked = true;
						giftOptEnable(frm.dRange);
						ischked = 1;
					}else{
						if (frm.dRange.checked) ischked = 1;
					}

					availCnt++;
				}else{
					frm.dRange.disabled = true;
					frm.dRange.checked = false;
				}
			}

			//When NoChecked Check Last
			if (ischked!=1){
				if (frm.dRange.length){
					for(var i=0;i<frm.dRange.length;i++){
						if (frm.dRange[i].disabled!=true){
							frm.dRange[i].checked = true;
							giftOptEnable(frm.dRange[i]);
						}
					}
				}else{
					frm.dRange.checked = true;
					giftOptEnable(frm.dRange);
				}
			}
		}
	}

	function checkDiaryGift_OLD(isFirst){
		var frm = document.frmorder;
		var dgMaxVal = <%=DiaryGiftCNT %>;
		var TenDlvItemPrice = 0;

		if (frm.TenDlvItemPrice){
			frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnNotAssign%>;
			if (frm.itemcouponOrsailcoupon[1].checked){
				frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnAssign%>;
			}

			TenDlvItemPrice = frm.TenDlvItemPrice.value;
		}

		if (document.getElementById("HTML_TenDlvItemPrice")){
			document.getElementById("HTML_TenDlvItemPrice").innerHTML = plusComma(TenDlvItemPrice*1);
		}

		//When NoChecked Check Last

		if (frm.DiNo){
			for (var i=0;i<frm.DiNo.length;i++){
				if (TenDlvItemPrice*1>=frm.dRange[i].value*1){
					frm.DiNo_disable[i].value="N";
					frm.DiNo[i].style.backgroundColor="#FFFFFF";
				}else{
					frm.DiNo_disable[i].value="Y";
					frm.DiNo[i].style.backgroundColor="#EFEFEF";
					frm.DiNo[i].value=0;
				}
			}
		}

		if ((isFirst)&&(frm.DiNo)){

			for (var i=0;i<frm.DiNo.length;i++){

				if (frm.DiNo_disable[frm.DiNo.length-i-1].value!="Y"){
					frm.DiNo[frm.DiNo.length-i-1].value=dgMaxVal*1;

					break;
				}
			}
		}

	}


	//주소찾기
	function searchzipBuyer(tmpurl){
		jsOpenModal(tmpurl);
	}

	//현장수령 선택시 주소입력
	function chgRSVSel(chk){
		var frm = document.frmorder;
		if(chk=="R") {
			$("#lyRSVAddr").hide();
			$("#lyRSVCmt").hide();
			$("#myaddress").hide();
			$("#lyRsvDec").show();

			frm.reqname.value=frm.buyname.value;
	
			frm.reqphone1.value=frm.buyphone1.value;
			frm.reqphone2.value=frm.buyphone2.value;
			frm.reqphone3.value=frm.buyphone3.value;
	
			frm.reqhp1.value=frm.buyhp1.value;
			frm.reqhp2.value=frm.buyhp2.value;
			frm.reqhp3.value=frm.buyhp3.value;
	
	        frm.txZip1.value = "";
	        frm.txZip2.value = "";
	        frm.txAddr1.value = "";
	        frm.txAddr2.value = "";
	        frm.comment.value = "현장수령";
		} else {
			$("#lyRSVAddr").show();
			$("#lyRSVCmt").show();
			$("#lyRsvDec").hide();
			frm.comment.value = "";
		}
	}

	</script>