

function fnDealItemOptionView(itemid,itemprice,itemname){
	$('input[name="itemid"]').val(itemid);
	$('input[name="itemPrice"]').val(itemprice);
	$('input[name="itemName"]').val(itemname);
	$('#itembtn').empty();
	$('#itembtn').append(itemname);
	$('#itembtn').removeClass("on");
	$.ajax({
		url: "/deal/act_item_option.asp?itemid="+itemid,
		cache: false,
		async: false,
		success: function(message) {
			if(message.substr(0,10)=="notoption=") {
				//옵션이 없을시 간이바구니 바로 생성
				$('#opbtn').hide();
				$("#lyDropdown").hide();
				hCalcSB("f");
				var minmax = message.substr(10,message.length);
				var myArray = minmax.split('|');
				var min = myArray[0];
				var max = myArray[1];
				fnTempShoppingBagSelect('', itemid, '0000', 0,'','',min,max);
				//$('#opbtn').attr("disabled",true);
				//$('#opbtn').empty().append("옵션이 없는 상품입니다.");
				//$('#opbtn').removeClass("on");					
			} else {
				$("#lyDropdown").hide();
				$('#opbtn').show();
				hCalcSB("f");
				$str = $(message);
				$('#opbtn').empty().append("옵션을 선택해주세요.");
				$('#opbtn').removeClass("disableClick");
				$('#oplist li').remove();
				$('#oplist').append($str);
				$('#opbtn').attr("disabled",false);
			}
		}
	});
	
}

//높이값 계산
function hCalcSB(v) {
	var optH = $('.itemOptV16a').outerHeight();
	var optH2 = $('.itemoption').outerHeight();
	var optH3 = $('#lySpBagList').outerHeight();
	var optH4 = $('.rqtxt').outerHeight();

	if (v == 'f'){
		$('.itemOptV16a').css('height',parseInt(optH2+optH3+optH4)+'px');
		floatScroll.onResize();
	}else{ // 옵션없을경우
		$('.itemOptV16a').css('height','auto');
	}
	floatScroll.onResize();
}

function fnTempShoppingBagSelect(opSelNm, itemid, opSelCd, optAddPrc, opSoldout, itemdiv, minnum, maxnum){
	var minCnt=parseInt(minnum);
	var maxCnt=parseInt(maxnum);
	var opLimit	= parseInt(maxnum);
	var itemPrc = $('input[name="itemPrice"]').val()*1;
	var itemName = $('input[name="itemName"]').val();
	var itemCnt=1;
	// 본상품 제한수량 계산
	if($("#itemRamainLimit").val()>0) {
		if($("#itemRamainLimit").val()<opLimit) opLimit=parseInt($("#itemRamainLimit").val());
	}
	//품절처리
	if(opSoldout) {
		alert("품절된 옵션은 선택하실 수 없습니다.");
		return;
	}
	// 옵션이 없으면 추가하지 않음
	//if(opSelCd==""||opSelCd=="0000")  return;

	// 중복 옵션 처리
	var chkDpl = false;
	$("#lySpBagList").find("li").each(function () {
		if($(this).find("[name='optItemid']").val()==itemid&&$(this).find("[name='optCd']").val()==opSelCd) {
			chkDpl=true;
		}
	});
	if(chkDpl)
	{
		$("#lyDropdownOpt").hide();
	}
	else{
		// 간이 장바구니 내용 작성
		var sAddItem='';
		sAddItem += '<li>';
		sAddItem += '<div class="optContV16a">';
		sAddItem += '<p>'+ itemName + '</p>';
		if(opSelNm!=""){
			sAddItem += '<p>옵션 : ' + opSelNm + '</p>';
		}
		sAddItem += '</div>';
		sAddItem += '<div class="optQuantityV16a">';
		sAddItem += '<p class="odrNumV16a">';
		sAddItem += "<button type='button' class='btnV16a minusQty'>감소</button>";
		sAddItem += '<input type="text" value="1" id="optItemEa" name="optItemEa" readonly />';
		sAddItem += "<button type='button' class='btnV16a plusQty'>증가</button>";
		sAddItem += '</p>';
		sAddItem += '<p class="rt">' + plusComma((itemPrc+optAddPrc)*itemCnt) + '</p>';
		sAddItem += '<p class="lPad1r del"><button type="button" class="btnV16a btnOptDelV16a">옵션 삭제</button></p>';
		sAddItem += '</div>';
		sAddItem += '<input type="hidden" name="optItemid" value="'+ (itemid) +'" />';
		sAddItem += '<input type="hidden" name="optCd" value="'+ opSelCd +'" />';
		sAddItem += '<input type="hidden" name="optItemPrc" value="'+ (itemPrc+optAddPrc) +'" />';
		if(itemdiv=="06") {
			sAddItem += "<div class='rqtxt onlyTxt'><div class='txtBoxV16a current'><textarea name='optRequire' id='optRequire' placeholder='[문구입력란] 문구를 입력해 주세요!'></textarea></div></div>";
			sAddItem += "<input type='hidden' name='requiredetail' value=''>";
		} else {
			sAddItem += "<input type='hidden' name='optRequire' value=''>";
		}
		sAddItem += '</li>';
		//alert(sAddItem);
		// 간이바구니에 추가
		$("#lySpBagList").prepend(sAddItem);

		// 스피너 변환
		$("#optItemEa").numSpinner2016({min:minCnt, max:maxCnt, step:1, value:itemCnt});

		// 간이바구니표시
		if($("#lySpBagList").find("li").length>0) {

			// 개별삭제
			//$('#lySpBagList .del').css('cursor', 'pointer');
			$('#lySpBagList .del').unbind("click");
			$('#lySpBagList .del').click(function(e) {
				e.preventDefault();
				var di = $(this).closest("li").index();
				$("#lySpBagList").find("li").eq(di).remove();

				//간이바구니 표시 확인
				if($("#lySpBagList").find("li").length<=0) {
					//장바구니 // 바로구매 disabled
					$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",true);
					$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",true);
					//높이값 계산
					hCalcSB('d');
				} else {
					//높이값 계산
					hCalcSB('f');
				}
				// 총금액 합계 계산
				FnSpCalcTotalPrice();
			});

			// 간이 바구니 주문수량 변경
			$('#lySpBag input[name="optItemEa"]').keyup(function() {
				FnSpCalcTotalPrice();
			});

			// 간이 바구니 스피너 액션
			$('#lySpBagList .odrNumV16a .btnV16a').click(function() {
				FnSpCalcTotalPrice();
			});

			// 총금액 합계 계산
			FnSpCalcTotalPrice();

			//장바구니 // 바로구매 disabled
			$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
			$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);

			// 선택창 옵션 초기화
			$('.itemoption select[name="item_option"]').val("");
			$('#opbtn').empty();
			$('#opbtn').append(opSelNm);
			$('#itembtn').removeClass("on");
			$('#opbtn').addClass("on");
			$("#lyDropdownOpt").hide();
			//높이값 계산
			hCalcSB('f');
		} else {
			//높이값 계산
			hCalcSB('f');
		}
	}
}

//간이장바구니 총 합계금액 계산
function FnSpCalcTotalPrice() {
	var isSpOpt = $("#lySpBagList li").length>0	// 간이바구니 옵션여부

	// 총금액 합계 계산
	var spTotalPrc = 0;
	$("#lySpBagList").find("li").each(function () {
		spTotalPrc = spTotalPrc + ($(this).find("[name='optItemPrc']").val()*$(this).find("[name='optItemEa']").val());
		$(this).find(".rt").html(plusComma($(this).find("[name='optItemPrc']").val()*$(this).find("[name='optItemEa']").val())+"원"); //개별 합계
	});

	$("#spTotalPrc").html(plusComma(spTotalPrc));
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

function fnsbagly(v) {
	if (v=="x"){
		$("#sbaglayerx").show();
		$("#alertBoxV17a").show();
	}else if(v=="o"){
		$("#sbaglayero").show();
		$("#alertBoxV17a").show();
	}
	setTimeout(function() {
		$("#alertBoxV17a").fadeOut(1000);
	}, 2500);
}

//간이바구니 -> 장바구니
function FnAddShoppingBag(bool) {
	var frm = document.sbagfrm;
	var aFrm = document.BagArrFrm;
	
	var optCode = "0000";
	var isOpt = $('#opttag input[name="item_option"]').length>0		// 옵션	여부
	var isSpOpt = $("#lySpBagList li").length>0	// 간이바구니 옵션여부
	var sAddBagArr = "";

	if(!isOpt) {
		//일반 상품 검사
		frm.itemoption.value = optCode;

		for (var j=0; j < frm.itemea.value.length; j++){
			if (((frm.itemea.value.charAt(j) * 0 == 0) == false)||(frm.itemea.value==0)){
				alert('수량은 숫자만 가능합니다.');
				frm.itemea.focus();
				return;
			}
		}
	}

	// 간이바구니 사용 상품 검사
	if(isOpt&&!isSpOpt) {
		alert('선택된 상품이 없습니다.');
		$('html, body').animate({scrollTop:$(".itemoption").prev().offset().top-10}, 'fast');
		return;
	}

	// 간이바구니 변환
	if(isSpOpt) {
		$("#lySpBagList").find("li").each(function () {
			sAddBagArr += $(this).find("[name='optItemid']").val() + ",";
			sAddBagArr += $(this).find("[name='optCd']").val() + ",";
			sAddBagArr += $(this).find("[name='optItemEa']").val() + ",";
			sAddBagArr += $(this).find("[name='optRequire']").val() + "|";
		});
	}

	if (bool==true){
		if(sAddBagArr=="") {
			frm.mode.value = "add";
			frm.action = "/inipay/shoppingbag_process.asp?tp=pop";
			frm.target = "iiBagWin";
			frm.submit();
		} else {
			aFrm.mode.value = "arr";
			aFrm.bagarr.value = sAddBagArr;
			aFrm.action = "/inipay/shoppingbag_process.asp?tp=pop";
			aFrm.target = "iiBagWin";
			aFrm.submit();
		}
	}else{
		//즉시 구매하기
		if(sAddBagArr=="") {
			frm.mode.value = "DO1";
			frm.target = "_self";
			frm.action="/inipay/shoppingbag_process.asp";
			frm.submit();
		} else {
			aFrm.mode.value = "DO2";
			aFrm.target = "_self";
			aFrm.bagarr.value = sAddBagArr;
			aFrm.action = "/inipay/shoppingbag_process.asp";
			aFrm.submit();
		}
	}

	// 장바구니 facebook 픽셀 스크립트 추가
	if (typeof fbq == 'function') { 
		fbq('track', 'AddToCart',{content_ids:'['+frm.itemid.value+']',content_type:'product'});
	}
}

function confirmAdultAuth(cPath){
	if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
		var url = '/login/login_adult.asp?backpath='+ cPath;
		location.href = url;
	}
}