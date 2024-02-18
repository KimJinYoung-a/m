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
			$('.pdtOptBox').show();
			var optH = $('.pdtOptBox').outerHeight();
			$('.floatingBar .inner').css('padding-top',optH);
			$('.floatingWrap').show();
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
				$('.pdtOptBox').show();
				var optH = $('.pdtOptBox').outerHeight();
				$('.floatingBar .inner').css('padding-top',optH);
				$('.floatingWrap').show();
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
			$('.pdtOptBox').show();
			var optH = $('.pdtOptBox').outerHeight();
			$('.floatingBar .inner').css('padding-top',optH);
			$('.floatingWrap').show();
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
        frm.action = "/apps/appCom/between/inipay/shoppingbag_process.asp?tp=pop";
        frm.mode.value="add";
        frm.target = "iiBagWin";
        frm.submit();
    }else{
        frm.target = "_self";
        frm.mode.value="DO1";
    	frm.action="/apps/appCom/between/inipay/shoppingbag_process.asp";
    	frm.submit();
    }

}


// 제작문구 수정
function TnEditItemRequire(iid,ocd){
    jsOpenModal('/apps/appCom/between/inipay/Pop_EditItemRequire.asp?itemid=' + iid + '&itemoption=' + ocd);
    return;
}


function editRequire(frm, itemea){
    var detailArr='';
	if (frm.requiredetailedit!=undefined){
        
		if (frm.requiredetailedit.value.length<1){
			alert('주문 제작 상품 문구를 작성해 주세요.');
			frm.requiredetailedit.focus();
			return false;
		}
		
		if(GetByteLength(frm.requiredetailedit.value)>255){
			alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
			frm.requiredetailedit.focus();
			return false;
		}
	}
	else
	{
	    if(itemea>1)
	    {
	        for (i=0;i<itemea;i++){
			
				if (eval("frm.requiredetailedit" + i).value.length<1){
					alert('주문 제작 상품 문구를 작성해 주세요.');
					eval("frm.requiredetailedit" + i).focus();
					return false;
				}
			
	            if(GetByteLength(eval("frm.requiredetailedit" + i).value)>255){
	    			alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
	    			eval("frm.requiredetailedit" + i).focus();
	    			return false;
	    		}
			
	            detailArr = detailArr + eval("frm.requiredetailedit" + i).value+'||';
	           
	        }
	        
	        if(GetByteLength(detailArr)>1024){
				alert('문구 입력합계는 한글 최대 512자 까지 가능합니다.');
				frm.requiredetailedit1.focus();
				return false;
			}
        }
	}


	if (confirm('수정 하시겠습니까?')){
	    frm.mode.value = "edit";
		frm.submit();
	}
	else
	{
		return false;
	}
}

