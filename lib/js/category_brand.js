//카테고리area 사이즈 다시 잡아주기.
function jsContentAreaReSize()
{
	var bodyHeight = $(window).height();
	var contHeight = $("#contentArea").height();
	var categHeight = $(".categorySection").height();

	if(categHeight > contHeight) {
		if(bodyHeight>categHeight) {
			$(".mainSection").css("min-height", bodyHeight-iFtH+iHdH);
		} else {
			$(".mainSection").css("min-height", categHeight-iFtH+iHdH);
		}
	} else {
		$(".mainSection").css("min-height", bodyHeight-iFtH+iHdH);
	
}
}


//카테고리 리스트 보기.
function ShowCategory(cate1,isend) {
	$.ajax({
			url: "/category/incCategory_cate_ajax.asp?disp="+cate1,
			cache: false,
			success: function(message)
			{
				$("#cateListArea").empty().append(message);

				$('input[id="disp1"]').val(cate1);	//선택된 카테고리 값담아두기.
				
				if(isend != "xxx")
				{
					ShowCategoryList(cate1,'','','',isend);	//이전으로 클릭했을 경우, 오른쪽에 상품 리스트 보이기.
				}
				
				$('body,html').animate({scrollTop:0}, 'fast');
			}
	});
}


//카테고리에 해당된 상품 리스트 보기(오른쪽화면에).
function ShowCategoryList(cate1,page,sort,imgsize,isend)
{
	$.ajax({
			url: "/category/category_list_ajax.asp?disp="+cate1+"&cpg="+page+"&srm="+sort+"&imgsize="+imgsize+"",
			cache: false,
			success: function(message)
			{
				$("#contentArea").empty().append(message);
				try {
					history.pushState({"html":message},"생활감성채널, 텐바이텐","/category/category_list.asp?disp="+cate1+"&cpg="+page+"&srm="+sort+"&imgsize="+imgsize+"");
				} catch(e){}

				$(".twoDepth li").removeClass("selected");
				$("#liCate"+cate1+"").addClass("selected");
				
				$(".floatingBar").remove();
				jsContentAreaReSize();
				
				$('body,html').animate({scrollTop:0}, 'fast');
				
				if(isend == "0")
				{
					jsCategoryTabClose();
				}
			}
	});
}

//카테고리에 해당된 상품 리스트 보기(오른쪽화면에).
function moveCategoryList(cate1,page,sort,imgsize)
{
	location.href="/category/category_list.asp?disp="+cate1+"&cpg="+page+"&srm="+sort+"&imgsize="+imgsize;
}

//1depth 대카테고리 페이지 이동		//2013.12.18 한용민 생성
function moveCategorymain()
{
	location.href="/category/category_main.asp"
}

//1depth 이후 2depth 부터 카테고리 페이지 이동		//2013.12.18 한용민 생성
function moveCategorysub(cate1)
{
	location.href="/category/category_sub.asp?disp="+cate1;
}

//브랜드 카테고리에 상품 리스트 보기
function moveBrandCategoryList(cate1,page,sort,imgsize,makerid)
{
	location.href="/street/street_brand.asp?disp="+cate1+"&cpg="+page+"&srm="+sort+"&imgsize="+imgsize+"&makerid="+makerid;
}


//나의찜브랜드 리스트 보기.
function ShowMyZzimBrand() {
	$.ajax({
			url: "/category/category_mybrandlist_ajax.asp",
			cache: false,
			success: function(message)
			{
				$("#mybrandArea").empty().append(message);
			}
	});
}


//브랜드 or 카테고리div 보기.
function ShowBrand(gb)
{
	if(gb == "1")
	{
		$("#tab1").addClass("current");
		$("#tab2").removeClass("current");
		$("#brandListArea").hide();
		$("#cateListArea").slideDown("fast");
	}
	else
	{
		ShowMyZzimBrand();
		$("#tab1").removeClass("current");
		$("#tab2").addClass("current");
		$("#cateListArea").hide();
		$("#brandListArea").slideDown("fast");
	}
}


//브랜드리스트.
function ShowBrandList(chrCd,Lang,flag,page,imgsize)
{
	$.ajax({
			url: "/street/brandlist_ajax.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize+"",
			cache: false,
			success: function(message)
			{
				$("#contentArea").empty().append(message);
				try {
					history.pushState({"html":message},"생활감성채널, 텐바이텐","/street/brandlist.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize+"");
				} catch(e){}

				$(".floatingBar").remove();
				jsContentAreaReSize();
				jsCategoryTabClose();
				$('body,html').animate({scrollTop:0}, 'fast');
			}
	});
}

//브랜드리스트		//2013.12.18 한용민 생성
function moveShowBrandList(chrCd,Lang,flag,page,imgsize)
{
	top.location.href = "/street/brandlist.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize
}

//브랜드 상세보기.
function ShowBrandDetail(makerid)
{
	top.location.href = "/street/street_brand.asp?makerid="+makerid+"";
}


//나의 찜브랜드 가기.
function GoMyZzimBrand()
{
	top.location.href = "/my10x10/myzzimbrand.asp";
}


// 카테고리탭 클로즈
function jsCategoryTabClose()
{
	$(".mainSection").animate({left:0}, 50, function(){
		//bodyHeight = $(document).height();
		bodyHeight = $(window).height();
		contHeight = $("#contentArea").height();

		$(".categorySection").parent(".heightGrid").removeClass('categoryView');

		if(bodyHeight>contHeight) {
			$(".mainSection").css("min-height", bodyHeight-iFtH);
		} else {
			$(".mainSection").css("min-height", contHeight-iHdH);
		}
		$("#mainBlankCover").hide();
		$(".floatingBar").show();
	});
}