// 장바구니에 상품을 담기
function TnAddShoppingBag(bool){
    var frm = document.sbagfrm;
    var optCode = "0000";

    var MOptPreFixCode="Z";

    if (!frm.itemea.value){
		alert('장바구니에 넣을 수량을 입력해주세요.');
		frm.itemea.focus();
		return;
	} else {
	    for (var j=0; j < frm.itemea.value.length; j++){
	        if (((frm.itemea.value.charAt(j) * 0 == 0) == false)||(frm.itemea.value==0)){
	    		alert('수량은 숫자만 가능합니다.');
	    		frm.itemea.focus();
	    		return;
	    	}
	    }
	}

    if (!frm.item_option){
        //옵션 없는경우

    }else if (!frm.item_option[0].length){
        //단일 옵션
        if (frm.item_option.value.length<1){
            alert('옵션을 선택 하세요.');
            frm.item_option.focus();
            return;
        }

        if (frm.item_option.options[frm.item_option.selectedIndex].id=="S"){
            //alert('품절된 옵션은 구매하실 수 없습니다.');
            frm.item_option.focus();
            return;
        }

        optCode = frm.item_option.value;
    }else{
        //이중 옵션 경우

        for (var i=0;i<frm.item_option.length;i++){
            if (frm.item_option[i].value.length<1){
                alert('옵션을 선택 하세요.');
                frm.item_option[i].focus();
                return;
            }

            if (frm.item_option[i].options[frm.item_option[i].selectedIndex].id=="S"){
                //alert('품절된 옵션은 구매하실 수 없습니다.');
                frm.item_option[i].focus();
                return;
            }

            if (i==0){
                optCode = MOptPreFixCode + frm.item_option[i].value.substr(1,1);
            }else if (i==1){
                optCode = optCode + frm.item_option[i].value.substr(1,1);
            }else if (i==2){
                optCode = optCode + frm.item_option[i].value.substr(1,1);
            }
        }

        if (optCode.length==2){
            optCode = optCode + "00";
        }

        if (optCode.length==3){
            optCode = optCode + "0";
        }
    }

    frm.itemoption.value = optCode;

    if (frm.requiredetail){
		if (frm.requiredetail.value == "문구를 입력해 주세요."){
			frm.requiredetail.value = "";
		}

		if (frm.requiredetail.value.length<1){
			alert('주문 제작 상품 문구를 작성해 주세요.');
			frm.requiredetail.focus();
			return;
		}

		if(GetByteLength(frm.requiredetail.value)>255){
			alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
			frm.requiredetail.focus();
			return;
		}
	}

    if (bool==true){
        frm.mode.value = "add";
        frm.action = "/inipay/shoppingbag_process.asp?tp=pop";
        frm.target = "iiBagWin";
        frm.submit();
    }else{
		frm.mode.value = "DO1";			//바로구매 (모바일웹 - 상품/장바구니 겸용)
        frm.target = "_self";
    	frm.action="/inipay/shoppingbag_process.asp";
    	frm.submit();
    }

	// 장바구니 facebook 픽셀 스크립트 추가
	if (typeof fbq == 'function') { 
		fbq('track', 'AddToCart',{content_ids:'['+frm.itemid.value+']',content_type:'product'});
	}
}

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavorite(iitemid){
    self.location='/my10x10/popMyFavorite.asp?mode=add&itemid=' + iitemid;
}

// 관심 품목 담기 -- 다수 선택 가능
function TnAddFavoriteList(){
	var ArrayFavItemID='';
	var chkbx = document.getElementsByName('chkbxFav');

	for (var i=0;i<chkbx.length;i++) {
			if (chkbx[i].checked){
				ArrayFavItemID=ArrayFavItemID  + ',' + chkbx[i].value;
			}
	}

	if (ArrayFavItemID.length < 1){
			alert('하나 이상 상품을 선택해 주세요');
			return;
	}	else	 {
			if (confirm('관심품목에 추가하시겠습니까?')){

			var FavWin = window.open('/my10x10/popMyFavorite.asp?mode=AddFavItems&bagarray=' + ArrayFavItemID ,'FavWin','width=380,height=300,scrollbars=no,resizable=no');
			FavWin.focus();
			}

	}

}

function editRequire(frm, itemea){
    var detailArr='';

	if (frm.requiredetailedit != undefined) {
		if (frm.requiredetailedit.value.length < 1) {
			alert('주문 제작 상품 문구를 작성해 주세요.');
			frm.requiredetailedit.focus();
			return false;
		}

		if(GetByteLength(frm.requiredetailedit.value) > 500) {
			alert('문구 입력은 최대 250자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + frm.requiredetailedit.value.length);
			frm.requiredetailedit.focus();
			return false;
		}
	} else {
	    if(itemea > 1) {
	        for (var i = 0; i < itemea; i++) {
				var obj = eval("frm.requiredetailedit" + i);

				if (obj.value.length < 1) {
					alert('주문 제작 상품 문구를 작성해 주세요.');
					obj.focus();
					return false;
				}

	            if (GetByteLength(obj.value) > 500) {
	    			alert('문구 입력은 최대 250자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + obj.value.length);
	    			obj.focus();
	    			return false;
	    		}

	            detailArr = detailArr + obj.value + '||';
	        }

	        if(GetByteLength(detailArr) > 800) {
				alert('문구 입력합계는 최대 400자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + detailArr.length);
				frm.requiredetailedit0.focus();
				return false;
			}
        }
	}

	if (confirm('수정 하시겠습니까?') == true) {
	    frm.mode.value = "edit";
		frm.submit();
	} else {
		return false;
	}
}


function TnWishList(sUrl){
	var f = $('input:radio[name="selfidx"]:checked').val();

	if(f == undefined)
	{
		alert("저장할 위시 폴더를 선택하세요.");
		return;
	}

	var frm = document.frmW;
	frm.backurl.value = sUrl;
	frm.fidx.value = f;
	frm.submit();
}

function jsAddFolder(){
	if(document.all.addFolder.style.display=="block"){
		document.all.addFolder.style.display="none";
	}else{
	document.all.addFolder.style.display="block";
	document.frmF.sFN.focus();
}
}

function jsSubmitFolder(){
	if(!jsChkNull("text",document.frmF.sFN,"폴더명을 입력해주세요")){
		document.frmF.sFN.focus();
		return;
	}
	document.frmF.submit();
}

$(function(){
	//초기 구동 
	//fnSelCalculate(); // 주석처리 in shoppingbag 에서 호출
});

// 장바구니 선택 재계산
function fnSelCalculate() {
	var vTotItemCnt=0, vTotItemEa=0, vTotItemPrc=0, vTotDlvPrc=0, vTotMilePrc=0, vTotItemMile=0, vTotCheckCoupon=0;
	var aDlvLmt = new Array();
	$(".cartV16a li input[name='chk_item']:enabled").each(function(){
		var itemprc=0, itemea=0, itemcnt=0, mileprc=0, itemMile=0, mtypflag="", dtypflag="", prcUnit="원";
		var lastitemprc = 0;
		var soldout="N", cDlvFree=false;
		var couponcheck=false;

		var parentsLi = $(this).closest("li");
		dtypflag = parentsLi.find("input[name='dtypflag']").val();
		mtypflag = parentsLi.find("input[name='mtypflag']").val();
		soldout = parentsLi.find("input[name='soldoutflag']").val();
		couponcheck = parentsLi.find("input[name='couponcheck']").val();
		if(mtypflag=="m") prcUnit="Pt";

		if($(this).prop("checked")) {
			itemprc = parseInt(parentsLi.find("input[name='ifinalprc']").val());
			lastitemprc = parseInt(parentsLi.find("input[name='isellprc']").val());
			itemea = parseInt(parentsLi.find("input[name='itemea']").val());
			itemMile = parseInt(parentsLi.find("input[name='imileage']").val());
			if(!itemprc) itemprc=0; if(!itemea) itemea=0;
	
			if(mtypflag=="m") mileprc = itemprc;
			if(dtypflag=="2" || dtypflag=="4") cDlvFree=true;
			if(couponcheck=="True") vTotCheckCoupon++;

			vTotItemPrc += (itemprc * itemea) - mileprc;
			vTotItemEa += itemea;
			vTotMilePrc += mileprc;
			vTotItemMile += itemMile;
			vTotItemCnt++;
			itemcnt++;
		}

		// 상품당합계 출력
		parentsLi.find(".itemSubTotPrc").html(plusComma(parseInt(parentsLi.find("input[name='ifinalprc']").val()) * parseInt(parentsLi.find("input[name='itemea']").val())));

		// 정책별 기준 취합
		var vMix = $(this).attr("mix");
		var vGrpDlvLmt = $("#grpDlvLmt"+vMix).val();
		var vGrpDlvPrc = $("#grpDlvPrc"+vMix).val();
		var cNew = -1;
		for(var i in aDlvLmt) {
			cNew = -1;
			if(aDlvLmt[i][0]==vMix) {
				cNew = i;
				break;
			}
		}
		if(cNew<0) {
			if((vMix==3 || vMix>6) && cDlvFree) vGrpDlvLmt=0;			// 텐배 및 업체조건 배송중 배송비무료가 있으면 배송기준 0원
			aDlvLmt.push([vMix,(itemprc * itemea),(mileprc * itemea),itemcnt,vGrpDlvLmt,vGrpDlvPrc,(lastitemprc * itemea)]);
		} else {
			aDlvLmt[cNew][1] = aDlvLmt[cNew][1]+(itemprc * itemea);		// 상품가합
			aDlvLmt[cNew][2] = aDlvLmt[cNew][2]+(mileprc * itemea);		// 마일리지 상품가합
			aDlvLmt[cNew][3] += itemcnt;								// 상품수(종류)
			if((vMix==3 || vMix>6) && cDlvFree) aDlvLmt[cNew][4]=0;		// 텐배 및  업체조건 배송중 배송비무료가 있으면 배송기준 0원
			aDlvLmt[cNew][6] = aDlvLmt[cNew][6]+(lastitemprc * itemea)  // 판매가합
		}
	});
	// 정책별 합계 출력
	for(var i in aDlvLmt) {
		vTotDlvPrc += fnPrintGroupTotal(aDlvLmt[i][0],aDlvLmt[i][1],aDlvLmt[i][2],aDlvLmt[i][3],aDlvLmt[i][4],aDlvLmt[i][5],aDlvLmt[i][6]);
	}
	// 해외배송시 해외배송비
	if($("#iemsPrice").val()) {
		if(vTotItemPrc>0) {
			vTotDlvPrc = parseInt($("#iemsPrice").val());
		} else {
			vTotDlvPrc = 0;
		}
	}
    
    if ((document.baguniFrm)&&(document.baguniFrm.iquickDlvPrice)){
        vTotDlvPrc = parseInt($("#iquickDlvPrice").val());
    }
    
	// 체크박스 수량 변경
	$("#chkSelItem").next("span").html("전체선택("+$("input[name='chk_item']:checked").length+"/"+$("input[name='chk_item']:enabled").length+")");

	var vPrtStr="";
	
	// 플로팅바 내용
	vPrtStr = '<span class="tMar0-3r fs1-1r">총 ' + vTotItemCnt + '개</span>';
	vPrtStr += '<span class="tMar0-5r">';
	vPrtStr += '	<strong>' + plusComma(vTotItemPrc+vTotDlvPrc) + '</strong>원';
	if(vTotMilePrc>0) {
		vPrtStr += '	+ <em class="cABl1V16a">' + plusComma(vTotMilePrc) + 'P</em>';
	}
	vPrtStr += '</span>';

	$("#lyrTotalSummary").html(vPrtStr);

	// 총 상품합계
	vPrtStr = '<dl class="infoArrayV16a">';
	vPrtStr += '	<dt>총 상품금액 (' + vTotItemCnt + '개)</dt>';
	vPrtStr += '	<dd>' + plusComma(vTotItemPrc) + '원</dd>';
	vPrtStr += '</dl>';
	vPrtStr += '<dl class="infoArrayV16a">';
	if($("#iemsPrice").val()) {
		vPrtStr += '	<dt>해외 배송비 (전체상품)</dd>';
		vPrtStr += '	<dd id="sp_emsPriceTTL">' + plusComma(vTotDlvPrc) + '원</dd>';
	} else {
		vPrtStr += '	<dt>총 배송비</dd>';
		vPrtStr += '	<dd>' + plusComma(vTotDlvPrc) + '원</dd>';
	}
	vPrtStr += '</dl>';
	$("#lyrTotalItem").html(vPrtStr);

	// 총 주문액
	vPrtStr = '<dl class="infoArrayV16a">';
	vPrtStr += '	<dt>총 주문금액</dt>';
	vPrtStr += '	<dd>' + plusComma(vTotItemPrc+vTotDlvPrc) + '원</em></dd>';
	vPrtStr += '</dl>';
	if(vTotMilePrc>0) {
		vPrtStr += '<dl class="infoArrayV16a">';
		vPrtStr += '	<dt>총 마일리지샵 금액</dt>';
		vPrtStr += '	<dd>' + plusComma(vTotMilePrc) + 'P</dd>';
		vPrtStr += '</dl>';
	}
	if(vTotItemMile>0) {
		vPrtStr += '<p class="overHidden fs1-1r cMGy1V16a">';
		if(vTotCheckCoupon>0){
			vPrtStr += '	<span class="ftLt">상품 쿠폰 적용시</span>';
		}
		vPrtStr += '	<span class="ftRt">(적립 마일리지 ' + plusComma(vTotItemMile) + 'P)</span>';
		vPrtStr += '</p>';
	}
	$("#lyrTotalOrder").html(vPrtStr);
}

// 그룹별 소계 출력
function fnPrintGroupTotal(vMix,vTotal,vMile,vCnt,vLimit,vDlv,vOrgtotal) {
	var vDlvTot=0, vPrtStr="";

	if((vOrgtotal)>0 && (vOrgtotal-vMile)<vLimit) {
		vDlvTot += parseInt(vDlv);
	} else if(vMix=="1" && vCnt>0) {
		vDlvTot += parseInt(vDlv);
	}

	if(vMix=="3") {
	    if (document.baguniFrm.iquickDlvPrice){
            vDlvTot = parseInt($("#iquickDlvPrice").val());
        }
		vPrtStr += '<p>';
		vPrtStr += '상품 <span class="cBk1V16a">' + plusComma(vTotal-vMile) + '</span>원';
		vPrtStr += ' + 배송 <span class="cBk1V16a">' + plusComma(vDlvTot) + '</span>원';
		vPrtStr += ' = <strong><span class="fs1-9r cRd1V16a">' + plusComma(vTotal+vDlvTot-vMile) + '</span>원</strong>';
		vPrtStr += '</p>';
		if(vMile>0) {
			vPrtStr += '<p>마일리지샵 상품합계 <span class="cBk1V16a">' + plusComma(vMile) + '</span>P</p>';
		}
	} else if(vMix=="6") {
		vPrtStr += '<p>';
		vPrtStr += '상품 <span class="cBk1V16a">' + plusComma(vTotal) + '</span>원';
		vPrtStr += ' + 배송비 <span class="cBk1V16a">착불 부과</span>';
		vPrtStr += ' = <strong><span class="fs1-9r cRd1V16a">' + plusComma(vTotal+vDlvTot) + '</span>원</strong>';
		vPrtStr += '</p>';
	} else {
		vPrtStr += '<p>';
		vPrtStr += '상품 <span class="cBk1V16a">' + plusComma(vTotal) + '</span>원';
		vPrtStr += ' + 배송 <span class="cBk1V16a">' + plusComma(vDlvTot) + '</span>원';
		vPrtStr += ' = <strong><span class="fs1-9r cRd1V16a">' + plusComma(vTotal+vDlvTot) + '</span>원</strong>';
		vPrtStr += '</p>';
	}

	// 그룹합 출력
	$("#grpTot"+vMix).html(vPrtStr);

	return vDlvTot;	// 총 배송비 반환
}

//2017_mo_플로팅 이종화 작성
$(function(){
	//floating contents
	$('.dropBox ul li').click(function(){
		//클릭 이벤트시 값 + 텍스트를 넣는 스크립트
		var optindex = $(this).closest("ul").index();
		var optval = $(this).attr('value2');
		var opttext = $(this).text();

		//single
		var optlimit = $(this).attr('limitea');
		var optsoldout = $(this).attr('soldout');
		var optAddPrice = $(this).attr("addPrice");

		var $item_opt = $('#opttag input[name="item_option"]'); //옵션
		var optlength = $item_opt.length-1; //ul태그 길이 - 1 (index 를 맞추기 위한)

		$item_opt.each(function(index){
			if (optindex+optlength == $(this).index()){
				//값을 집어 넣는다
				$(this).val(optval);
				$(this).attr('ref',opttext);
				
			}

			// 상위 depth 값을 선택 할경우 하위 옵션 값은 초기화
			if ($(this).index() > optindex+optlength){
				$(this).val('');
			}
		});

		var $item_txt = $('#opttag a'); //텍스트
		var temptxt;
		var tmpidx; //값 집어 넣는 index
		$item_txt.each(function(index){
			if (optindex-1 == $(this).index()){
				//값을 집어 넣는다
				$(this).text(opttext);
				tmpidx = $(this).index();
			}else{
				// 상위 depth 값을 선택 할경우 하위 옵션 값은 초기화
				if ($(this).index() > optindex-1){
					temptxt = $(this).attr('ref'); //기본 text 
					$(this).text(temptxt);
				}
			}
		});

		$("#lyDropdown").hide();
		//클릭 이벤트시 값 + 텍스트를 넣는 스크립트
		
		//이중옵션이상 품절 체크
		CheckMultiOption2017(tmpidx);
		//이중옵션이상 품절 체크

		var optCnt = $("#opttag a").length; //옵션 갯수
		var optSel = 0;
		var itemid = $('input[name="itemid"]').val();
		var itemPrc = $('input[name="itemPrice"]').val()*1;
		var itemCnt = $('input[name="itemea"]').val()*1;
		var optAddPrc = 0;
		var optCd = [];

		// Present상품일경우는 간이바구니 사용안함
		if($('input[name="isPresentItem"]').val()=="True") return;
		// 스페셜 항공권 상품일경우는 간이바구니 사용안함
		if($('input[name="IsSpcTravelItem"]').val()=="True") return;

		$('#opttag input[name="item_option"]').each(function () {
			optCd[optSel] = $(this).val();
			var opSelCd = optCd[optSel];
			var opSelNm = $(this).attr('ref');
			var optMSel = -1;
			var opSoldout = false;
			var opLimit	= 500;

			if(optCd[optSel]!=""&&optCd[optSel]!="0000") optSel++;

			//포커싱
			if (optCnt > 1){
				$('.txtBoxV16a').removeClass('current');
				if(optSel == 1){ // 다중옵션
					$('#'+optSel).attr('disabled', false);
					$('.itemoption #opttag a').removeClass('on');
					$('.itemoption #opttag a[id="1"]').addClass('on');
				}else if (optSel == 2){
					$('#'+optSel).attr('disabled', false);
					$('.itemoption #opttag a').removeClass('on');
					$('.itemoption #opttag a[id="2"]').addClass('on');
				}else if (optSel == 3){
					$('#'+optSel).attr('disabled', false);
					$('.itemoption #opttag a').removeClass('on');
				}else{
					$('.itemoption #opttag a').removeClass('on');
					$('.itemoption #opttag a:first').addClass('on');
				}
			}else{ //단일옵션
				$('.itemoption #opttag a').removeClass('on');
			}

			//옵션이 모두 선택 됐을 때 간이바구니에 넣는다
			if(optSel==optCnt) {
				if(optCnt>1) {
					// 이중옵션일 때 내용 접수
					for(i=0;i<Mopt_Code.length;i++){
						if(optCnt==2) {
							if(Mopt_Code[i].substr(1,1)==optCd[0].substr(1,1)&&Mopt_Code[i].substr(2,1)==optCd[1].substr(1,1)) {
								optMSel = i;
							}
						} else if(optCnt==3) {
							if(Mopt_Code[i].substr(1,1)==optCd[0].substr(1,1)&&Mopt_Code[i].substr(2,1)==optCd[1].substr(1,1)&&Mopt_Code[i].substr(3,1)==optCd[2].substr(1,1)) {
								optMSel = i;
							}
						}
					}
					if(optMSel>=0) {
						opSelCd = Mopt_Code[optMSel];
						opSelNm = Mopt_Name[optMSel];
						optAddPrc = Mopt_addprice[optMSel]*1;
						if(optAddPrc>0) opSelNm+="("+plusComma(optAddPrc)+"원 추가)";
						if(Mopt_LimitEa[optMSel]>0) opLimit = parseInt(Mopt_LimitEa[optMSel]);

						if(Mopt_S[optMSel]) opSoldout=true;
					} else {
						opSoldout = true;
					}
				} else {
					// 단일옵션일 때
					optAddPrc = optAddPrice*1;
					if(!optAddPrc) optAddPrc=0;
					if(optlimit>0) opLimit=parseInt(optlimit);
					if(optsoldout=="Y") opSoldout = true;
				}

				// 본상품 제한수량 계산
				if($("#itemRamainLimit").val()>0) {
					if($("#itemRamainLimit").val()<opLimit) opLimit=parseInt($("#itemRamainLimit").val());
				}

				opSelNm = opSelNm.replace(/\(한정.*?\)/g,''); //한정구문 제거

				//품절처리
				if(opSoldout) {
					//alert("품절된 옵션은 선택하실 수 없습니다.");
					
					//품절 옵션 선택시 input _ a Tag 초기화
					var soldidx = $(this).index();
					var $item_opt = $('#opttag input[name="item_option"]'); //옵션
					var optlength = $item_opt.length;

					$item_opt.each(function(index){
						if (soldidx == $(this).index()){
							//값을 집어 넣는다
							$(this).val('');
						}
					});

					var $item_txt = $('#opttag a'); //텍스트
					var temptxt;
					$item_txt.each(function(index){
						if (optindex-1 == $(this).index()){
							//값을 집어 넣는다
							temptxt = $(this).attr('ref'); //기본 text 
							$(this).text(temptxt);
							$(this).addClass('on'); //포커스클래스
						}
					});
					//품절 옵션 선택시 input _ a Tag 초기화
					return true;
				}

				// 옵션이 없으면 추가하지 않음
				if(opSelCd==""||opSelCd=="0000")  return;

				// 중복 옵션 처리
				var chkDpl = false;
				$("#lySpBagList").find("li").each(function () {
					if($(this).find("[name='optItemid']").val()==itemid&&$(this).find("[name='optCd']").val()==opSelCd) {
						chkDpl=true;
					}
				});
				if(chkDpl) return;

				//문구 입력란 focus효과
				$('.txtBoxV16a').addClass('current');

				// 간이 장바구니 내용 작성
				var sAddItem="";
				sAddItem += "<li>";
				sAddItem += "	<div class='optContV16a'>";
				sAddItem += "		<p>옵션 : " + opSelNm + "</p>";
			
				if($(".requiredetail").has("#requiredetail").length) {
						sAddItem += " <div class='requiretxt'>";
					if($("#requiredetail").val()) {
						sAddItem += "		<p>주문제작문구 : " + $("#requiredetail").val().replace(/</g,"＜").replace(/>/g,"＞").replace("\r\n","<br/>").replace("\n","<br/>") + "</p>";
					}
						sAddItem += " </div>";
				}

				sAddItem += "   </div>";
				sAddItem += "   <div class='optQuantityV16a'>";
				sAddItem += "		<p class='odrNumV16a'>";
				sAddItem += "			<button type='button' class='btnV16a minusQty'>감소</button>";
				sAddItem += "			<input id='optItemEa' name='optItemEa' type='text' value='1' readonly/>";
				sAddItem += "			<button type='button' class='btnV16a plusQty'>증가</button>";
				sAddItem += "		</p>";
				sAddItem += "		<p class='rt'>" + plusComma((itemPrc+optAddPrc)*itemCnt) + "원</p>";
				sAddItem += "		<p class='lPad1r'><button type='button' class='btnV16a btnOptDelV16a del'>옵션 삭제</button></p>";
				sAddItem += "	</div>";
				sAddItem += "<input type='hidden' name='optItemid' value="+ (itemid) +" >";
				sAddItem += "<input type='hidden' name='optCd' value="+ opSelCd +" >";
				sAddItem += "<input type='hidden' name='optItemPrc' value="+ (itemPrc+optAddPrc) +" >";
				if($(".requiredetail").has("#requiredetail").length) {
					sAddItem += "<input type='hidden' name='optRequire' value="+ $("#requiredetail").val().replace(/,/g,"，").replace(/\|/g,"｜").replace(/</g,"＜").replace(/>/g,"＞") +">";
				} else {
					sAddItem += "<input type='hidden' name='optRequire' value=''>";
				}
				sAddItem += "</li>";

				// 문구입력을 받는 상품일 경우 옵션 선택전에 문구 입력을 해야됨
				if($(".requiredetail").has("#requiredetail").length) {

					$('.txtBoxV16a').addClass('current'); //포커싱 이동
					$("#tmpopt").empty().append(sAddItem);
					$("#tmpopLimit").empty().text(opLimit);
					$("#tmpitemCnt").empty().text(itemCnt);
				}else{
					//장바구니 // 바로구매 disabled
					$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
					$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);

					//초기화					
					$('.itemoption #opttag a').removeClass('on');
					$('.itemoption #opttag a:first').addClass('on');

					//추가 장바구니
					FnAddProc(sAddItem,opLimit,itemCnt);
				}
			}
		});
	});
});

//주문상품 확인 버튼 
function requireTxt(){
	var itemid = $('input[name="itemid"]').val();
	var optCnt = $('#opttag input[name="item_option"]').length;
	var optSel = 0;
	var optCd = [];

	if (optCnt > 0){//옵션 상품이 있을경우
		//확인 버튼 삭제후 문구란 클래스 제거
		$('.txtBoxV16a').removeClass('current');

		$('#opttag input[name="item_option"]').each(function () {
			optCd[optSel] = $(this).val();
			var opSelCd = optCd[optSel];
			var optMSel = -1;
			var opSoldout = false;
			var opLimit	= 500;

			if(optCd[optSel]!=""&&optCd[optSel]!="0000"){
				optSel++;
			}else{
				alert("상품옵션을 선택해 주세요.");
				return false;
			}

			if(optSel==optCnt) {

				var tmphtml = $("#tmpopt");
				var tmpitemCnt = $("#tmpitemCnt").text();

				if(optCnt>1) {
					// 이중옵션일 때 내용 접수
					for(i=0;i<Mopt_Code.length;i++){
						if(optCnt==2) {
							if(Mopt_Code[i].substr(1,1)==optCd[0].substr(1,1)&&Mopt_Code[i].substr(2,1)==optCd[1].substr(1,1)) {
								optMSel = i;
							}
						} else if(optCnt==3) {
							if(Mopt_Code[i].substr(1,1)==optCd[0].substr(1,1)&&Mopt_Code[i].substr(2,1)==optCd[1].substr(1,1)&&Mopt_Code[i].substr(3,1)==optCd[2].substr(1,1)) {
								optMSel = i;
							}
						}
					}
					if(optMSel>=0) {
						opSelCd = Mopt_Code[optMSel];
						if(Mopt_LimitEa[optMSel]>0) opLimit = parseInt(Mopt_LimitEa[optMSel]);
					} 
				} 
			
				//중복 체크 검사
				var chkDpl = false;
				$("#lySpBagList").find("li").each(function () {
					if($(this).find("[name='optItemid']").val()==itemid&&$(this).find("[name='optCd']").val()==opSelCd) {
						chkDpl=true;
					}
				});
				if(chkDpl) return;
				
				//문구 체크
				if(!$("#requiredetail").val()) {
					alert("주문제작문구를 입력해 주세요");
					//옵션이 없는 경우 클래스 추가
					$('.itemoption select').removeClass('current');
					$('.txtBoxV16a').addClass('current');
					$("#requiredetail").focus();
					return false;
				}else{
					if(GetByteLength($("#requiredetail").val())>255){
						alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
						$('.txtBoxV16a').addClass('current');
						$("#requiredetail").focus();
						return;
					}

					if (tmphtml.html() !="" && tmpopLimit !="" && tmpitemCnt !=""){
						if($(".requiredetail").has("#requiredetail").length) {
							if($("#requiredetail").val()) {
								tmphtml.find(".requiretxt").html('<p>주문제작문구 : ' + $("#requiredetail").val().replace(/</g,"＜").replace(/>/g,"＞").replace("\r\n","<br/>").replace("\n","<br/>") + '</p>');
								tmphtml.find("[name='optRequire']").val($("#requiredetail").val().replace(/,/g,"，").replace(/\|/g,"｜").replace(/</g,"＜").replace(/>/g,"＞"));
							}
						}

						//장바구니 // 바로구매 disabled
						$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
						$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);

						//옵션 첫번째 클래스 추가
						$('.itemoption select:first').addClass('current');

						//추가 장바구니
						FnAddProc(tmphtml.html(),opLimit,tmpitemCnt);
					}
				}
			}
		});
	}
}

function chkopt(){
	var optCnt = $('.itemoption input[name="item_option"]').length;
	var optSel = 0;
	var optCd = [];

	$('.itemoption input[name="item_option"]').each(function () {
		optCd[optSel] = $(this).val();
		var opSelCd = optCd[optSel];

		if(optCd[optSel]!=""&&optCd[optSel]!="0000"){
			optSel++;
		}else{
			$('#requiredetail').blur();
			alert("상품옵션 선택후 입력해 주세요.");
			return false;
		}
	});

	if(optSel==optCnt) {
		$('#requiredetail').focus();
	}
}

//추가 장바구니
function FnAddProc(v,m,icnt){
	
	var sAddItem = v; // html
	var opLimit = m; //옵션 리미트
	var itemCnt = icnt; // 아이템카운트

	// 간이바구니에 추가
	//console.log(sAddItem);
	$("#lySpBagList").prepend(sAddItem);

	// 스피너 변환
	$("#optItemEa").numSpinner2016({min:1,max:opLimit,step:1,value:itemCnt});

	// 간이바구니표시
	if($("#lySpBagList").find("li").length>0) {
		// 개별삭제
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
				hCalc('d');
			} else {
				//높이값 계산
				hCalc('f');
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

		// 선택창 옵션 초기화
		if($(".requiredetail").has("#requiredetail").length) {
			$("#requiredetail").val("");			
		}

		//높이값 계산
		hCalc('f');
	} else {
		//높이값 계산
		hCalc('f');
	}

	// 선택창 옵션 초기화
	var $item_opt = $('#opttag a'); //옵션
	$item_opt.each(function(index){
		$(this).text($(this).attr('ref'));
	});
	
	//포커스
	$("#opttag a:first").addClass('on');

	//layer 안보이게
	$('#1,#2').attr('disabled', true);
}

//높이값 계산
function hCalc(v) {
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

function confirmAdultAuth(cPath){
	if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
		var url = '/login/login_adult.asp?backpath='+ cPath;
		location.href = url;
	}else{
		history.back();
	}
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

	if(aFrm.giftnotice.value=="True")//사은품 소진 확인 메세지
	{
		alert("1+1 사은품 증정이 종료되었습니다.");
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