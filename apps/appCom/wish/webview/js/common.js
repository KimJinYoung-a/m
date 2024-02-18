var console = window.console || {log:function(){}}; 

$(function(){
	$('.form-actions.highlight').prev().css({'margin-bottom':50});
	$(window).on('resize', function(){
		var wh = $('body').innerHeight();
		var h = $('.wrapper').height();
		console.log(wh, h);
		if ( wh >= h   ) {
			$('.form-actions.highlight').css({'position':'fixed','bottom':0,'left':0, 'width':'100%'});
			
		} else {
			$('.form-actions.highlight').css({'position':'static','bottom':0,'left':0, 'width':'100%'});
		}
	});
	$(window).trigger('resize');


	$('.toggle').each(function(){
		var toggle = $(this);
		$('button', this).on('click', function(){
			$('button', toggle).removeClass('active');
			$(this).addClass('active');
			var val = $(this).attr('value');
			$('input[type="hidden"]', toggle).val(val);
			return false;
		});
	});



    $('.show-toggle-box').on('click', function(){
        $('.icon-arrow-up-down', this).toggleClass('down');
        var target = $(this).attr('target');
        if ( $('.icon-arrow-up-down', this).hasClass('down')) {            
            $(target).hide();
        } else {
            $(target).show();
        }
        return false;
    });

    $('.show-toggle-box').each(function(){
    	if ( $(this).attr('closed') == 'true') {
    		$(this).trigger('click');
    	}
    });

	$('.amount-selector').each(function(){
		var amount = $('.amount', this);
		var val = parseInt(amount.val());

	});

	// modal
	$('.btn-show-modal').on('click', function(){
		var target = $(this).attr('href');
		$(target).fadeIn();
		$('body').css({'overflow':'hidden'});
		return false;
	});

	$('.btn-hide-modal').on('click', function(){
		var target = $(this).attr('href');
		$(target).fadeOut();
		$('body').css({'overflow':'auto'});
		clearInterval(loop);
		loop = null;
		return false;
	});

	$('.modal .btn-close').on('click', function(){
		var target = $(this).attr('href');
		$(target).fadeOut();
		$('body').css({'overflow':'auto'});
		clearInterval(loop);
		loop = null;
		return false;
	});

	// Footer button control
	$("#footer .btn-back").click(function(e){
		e.preventDefault();
		history.back();
	});
	/*
	$("#footer .btn-top").click(function(e){
		e.preventDefault();
		$('html, body').animate({scrollTop:0}, 'fast');
	});
	*/
	$('.btn-top').hide();
	$(window).scroll(function(){
		var vSpos = $(window).scrollTop();
		var docuH = $(document).height() - $(window).height();
		if (vSpos > 10){
			$('.btn-top').show();
		} else {
			$('.btn-top').hide();
		}
	});

	$(document)
    .on('focus', 'input, textarea', function(e) {
        $('body').addClass('fixfixed');
    })
    .on('blur', 'input, textarea', function(e) {
        $('body').removeClass('fixfixed');
    });
});

//상품후기 쓰기
function AddEval(OrdSr,itID,OptCd){	
	location.href = '/apps/appCom/wish/webview/my10x10/goodsUsingWrite.asp?orderserial=' + OrdSr + '&itemid=' + itID + '&optionCD=' + OptCd + '';
}

//문자열의 공백여부 체크
function jsChkBlank(str)
{
    if (str == "" || str.split(" ").join("") == ""){
        return true;
	}
    else{
        return false;
	}
}

function jsChkNumber(value) {
	var temp = new String(value)
		
	if(temp.search(/\D/) != -1) {
		return false;
	}
		return true;	
}

function IsDigit(v){
	for (var j=0; j < v.length; j++){
		if ((v.charAt(j) * 0 == 0) == false){
			return false;
		}
	}
	return true;
}

function GetByteLength(val){
 	var real_byte = val.length;
 	for (var ii=0; ii<val.length; ii++) {
  		var temp = val.substr(ii,1).charCodeAt(0);
  		if (temp > 127) { real_byte++; }
 	}

   return real_byte;
}

document.addEventListener('touchmove', function (e) { 
	if ( $('.modal .modal-body').length > 0 ) {
		e.preventDefault(); 
	} else {
	}
}, false);

/*
purpose : 이메일 주소의 유효여부 체크
input : 이메일 주소
return : 올바르면 true, 올바르지 않으면 false
remark : 주소에 @가 포함되어 있는지, 또는 두번이상 포함되지는 않았는지 확인
*/

function check_form_email(email)
{

	var pos;


	pos = email.indexOf('@');

	if (pos < 0)				//@가 포함되어 있지 않음
		return(false);
	else
		{
		pos = email.indexOf('@', pos + 1)
		if (pos >= 0)			//@가 두번이상 포함되어 있음
			return(false);
		}


	pos = email.indexOf('.');

	if (pos < 0)				//@가 포함되어 있지 않음
		return false;


	return(true);

}

// 폼 필수 필드 유효성 체크
function validField(obj, msg, len)
{
	if (obj.length > 1)
	{
		if (obj[0].type == "radio" || obj[0].type == "checkbox")
		{
			var chk = 0;
			for (var i = 0; i < obj.length; i++)
				if (obj[i].checked)
					chk++;

			if (chk==0)
			{
				if (obj[0].type == "checkbox")
					alert("" + msg + " 하나 이상 체크해주세요.");
				else
					alert("" + msg + " 체크해주세요.");

				obj[0].focus();
				return false;
			}
		}
		else if (obj.type == "select-one")
		{
			if(obj.value=="") 
			{
				alert("" + msg + " 선택해주세요.");
				obj.focus();
				return false;
			}
		}
	}
	else if (obj.type == "radio" || obj.type == "checkbox")
	{
		if (obj.checked==false)
		{
			alert("" + msg + " 체크해주세요.");
			obj.focus();
			return false;
		}
	}
	else
	{
		if(Trim(obj.value) == "") 
		{
			alert("" + msg + " 입력해주세요.");
			obj.focus();
			return false;
		}
		if (len)
		{
			if (returnByte(obj.value) > len)
			{
				alert("" + msg + " 한글기준 "+parseInt(len/2)+"자, 영문기준 "+len+"자 이내로 해주세요.");
				obj.focus();
				return false;
			}
		}
	}

	return true;
}
// Trim
function Trim(v)
{
	return v.replace(/^(\s+)|(\s+)$/g, "");
}

//로그인 여부 확인(쿠키)
function islogin() {
	if(getCookie('uinfo')) {
		return "True";
	} else {
		return "False";
	}
}

// 쿠키를 가져온다
function getCookie(name){
 var nameOfCookie = name + "=";
 var x = 0;

 while ( x <= document.cookie.length )
 {
  var y = (x+nameOfCookie.length);
  if ( document.cookie.substring( x, y ) == nameOfCookie ) {
   if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
   endOfCookie = document.cookie.length;
   return unescape( document.cookie.substring( y, endOfCookie ) );
  }

  x = document.cookie.indexOf( " ", x ) + 1;

  if ( x == 0 )
   break;
 }
 return "";
}

function checkAsc(val)
{
	var regexp = /^[#.,~)(/\'\"_A-Za-z0-9 @-]*$/i;

	if(!regexp.test(val))
		return false;
	else
		return true;
}

// 필드값 리턴, type이나 length에 따라 달라짐
function getValue(obj)
{
	var ret = "";
	if (obj.length > 1)
	{
		if (obj[0].type == "radio" || obj[0].type == "checkbox")
		{
			for (var i = 0; i < obj.length; i++)
				if (obj[i].checked)
					if (ret=="")
						ret = obj[i].value;
					else
						ret += "," + obj[i].value;
		}
		else if (obj.type == "select-one")
			ret = obj.value;
	}
	else
		ret = obj.value;

	return ret;
}

// 필드값 세팅
function setValue(obj,val) 
{
	if (obj.length > 1)
	{
		if (obj[0].type == "radio" || obj[0].type == "checkbox")
		{
			for (i=0;i<obj.length;i++)
				if (obj[i].value == val)	// 밸류값과 동일하면 checked
					obj[i].checked = true;
		}
		else if (obj.type == "select-one")
			obj.value = val;
		else
			alert("필드 중복!!");
	}
	else
		obj.value = val;
}

// for radio button checked Index
function getCheckedIndex(comp){
    var i =0;
    for( var i = 0 ; i <comp.length;  i++){
        if(comp[i].checked) return i;
    }
    return -1;
}