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
            alert('품절된 옵션은 구매하실 수 없습니다.');
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
                alert('품절된 옵션은 구매하실 수 없습니다.');
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
        frm.action = "/apps/appCom/wish/webview/inipay/shoppingbag_process.asp?tp=pop";
        frm.target = "iiBagWin";
        frm.submit();
    }else{
		frm.mode.value = "DO1";
        frm.target = "_self";
    	frm.action="/apps/appCom/wish/webview/inipay/shoppingbag_process.asp";
    	frm.submit();
    }

}

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavorite(iitemid){
    jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=%2Fapps%2FappCom%2Fwish%2Fwebview%2Finipay%2FShoppingBag%2Easp');
    return;
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
			jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=AddFavItems&bagarray=' + ArrayFavItemID + '&backurl=%2Fapps%2FappCom%2Fwish%2Fwebview%2Finipay%2FShoppingBag%2Easp');
			return;
		}
	}
}

// 제작문구 수정
function TnEditItemRequire(iid,ocd){
    jsOpenModal('/apps/appCom/wish/webview/inipay/Pop_EditItemRequire.asp?itemid=' + iid + '&itemoption=' + ocd);
    return;
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
		return false;
	}
	document.frmF.submit();
}
