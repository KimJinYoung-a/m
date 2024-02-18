(function() {
	addEventListener("load", function(event)
	{
		setTimeout(preloadImages, 0);
	}, false);

	addEventListener("click", function(event)
	{
		var link = findParent(event.target, "a");
		if (link)
		{
			function unselect() { link.removeAttribute("selected"); }
			
			if (link.href && link.hash && link.hash != "#" && !link.target)
			{
				link.setAttribute("selected", "true");
				location.href = link.href;
				setTimeout(unselect, 500);
			}
			else if (link.target == "_replace")
			{
				link.setAttribute("selected", "progress");
				MoreListView(link.href, "GET", link, unselect);
			}
			else if (link.title == "_justRep") {
				ReplacePageView(link.href, "GET", $("#"+link.target), unselect);
				setTimeout(function(){window.scrollTo(0, 1);}, 100);
			}
			else if (link.target == "_webapp" || link.title == "_webapp")
			{
				link.setAttribute("selected", "progress");
				location.href = link.href;
				setTimeout(unselect, 500);
			}
			else if (link.title == "noLink")
			{
				return;
			}
			else
				return;
			
			event.preventDefault();		   
		}
	}, true);

	function findParent(node, localName)
	{
		while (node && (node.nodeType != 1 || node.localName.toLowerCase() != localName))
			node = node.parentNode;
		return node;
	}

	function preloadImages()
	{
		var preloader = document.createElement("div");
		preloader.id = "preloader";
		document.body.appendChild(preloader);
	}

	// 목록내용 더 보기
	function MoreListView(aLink,mthd,pLink,cb) {
		// jQuery Ajax 결과 실행
		var strRst = $.ajax({
			type: mthd,
			url: aLink,
			dataType: "html",
			async: false
		}).responseText;

		var frag = document.createElement("div");
		frag.innerHTML = strRst;
	
		if (pLink)
			replaceElementWithFrag(pLink, frag);
		if (cb)
			setTimeout(cb, 1000, true);
	}

	// 현재 페이지 내용 바꾸기(Ajax)
	function ReplacePageView(aLink,mthd,pLink,cb) {
		// jQuery Ajax 결과 실행
		var strRst = $.ajax({
			type: mthd,
			url: aLink,
			dataType: "html",
			async: false
		}).responseText;

		pLink.html(strRst);
		if (cb)
			setTimeout(cb, 1000, true);
	}

	function replaceElementWithFrag(replace, frag)
	{
		var page = replace.parentNode;
		var parent = replace;
		page.removeChild(parent);
	    var docNode;
		while (frag.firstChild) {
			docNode = page.appendChild(frag.firstChild);
	    }
	}

})();
