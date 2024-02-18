"use strict";

var _createClass = function() {
    function defineProperties(target, props) {
        for (var i = 0; i < props.length; i++) {
            var descriptor = props[i];
            descriptor.enumerable = descriptor.enumerable || false;
            descriptor.configurable = true;
            if ("value" in descriptor) descriptor.writable = true;
            Object.defineProperty(target, descriptor.key, descriptor);
        }
    }
    return function(Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; };
}();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var pp_instance = void 0;

var DataGen = function() {
    function DataGen() {
        _classCallCheck(this, DataGen);

        // 싱글톤
        if (pp_instance) return pp_instance;

        // const
        this.KINESIS = "BIS-ACTIVITY-STREAM";
        this.BASE_URL = "https://gqb7it2caj.execute-api.ap-northeast-2.amazonaws.com/prod/streams/";
        this.API_KEY = "7wqxMesqxVa88OpaZEoFb91l1TWwa2ZJ6b5WjOWg";
        this.W_TARGET_MAP = {
            main: { identifier: "", path: ["/", "/index.asp"], key: "main" },
            search: { identifier: "rect", path: ["/search/search_result.asp"], key: "search" },
            category: { identifier: "disp", path: ["/shopping/category_list.asp", "/shopping/category_main.asp"], key: "category" },
            event: { identifier: "eventid", path: ["/event/eventmain.asp"], key: "event" },
            brand: { identifier: "", path: ["/street/", "/street/index.asp"], key: "brand" },
            brandview: { identifier: "makerid", path: ["/street/street_brand_sub06.asp"], key: "brandview" },
            itemview: { identifier: "itemid", path: ["/shopping/category_prd.asp"], key: "itemview" },
            deal: { identifier: "itemid", path: ["/deal/deal.asp"], key: "deal" },
            // dealview: {identifier: "", path: ""},
            new: { identifier: "", path: ["/shoppingtoday/shoppingchance_newitem.asp"], key: "new" },
            best: { identifier: "", path: ["/award/awardlist.asp"], key: "best" },
            sale: { identifier: "", path: ["/shoppingtoday/shoppingchance_saleitem.asp"], key: "sale" },
            clearance: { identifier: "", path: ["/clearancesale/", "/clearancesale/index.asp"], key: "clearance" },
            basket: { identifier: "", path: ["/inipay/shoppingbag.asp"], key: "basket" },
            wish: { identifier: "", path: ["/my10x10/mywishlist.asp"], key: "wish" },
            ds: { identifier: "", path: ["/diarystory2020/", "/diarystory2020/index.asp"], key: "ds" }
        };
        this.A_TARGET_MAP = {
            main: { identifier: "", path: ["/apps/appCom/wish/web2014/today/index.asp", "/apps/appCom/wish/web2014/today/"], key: "main" },
            // search: { identifier: "rect", path: ["/search/search_item.asp"], key: "search" },
            category: { identifier: "disp", path: ["/apps/appCom/wish/web2014/category/category_main.asp"], key: "category" },
            event: { identifier: "eventid", path: ["/apps/appCom/wish/web2014/event/eventmain.asp"], key: "event" },
            brand: { identifier: "", path: ["/apps/appCom/wish/web2014/street/", "/apps/appCom/wish/web2014/street/index.asp"], key: "brand" },
            // brandview: { identifier: "makerid", path: ["/apps/appCom/wish/web2014/street/street_brand.asp"], key: "brandview" },
            itemview: { identifier: "itemid", path: ["/apps/appCom/wish/web2014/category/category_itemPrd.asp"], key: "itemview" },
            deal: { identifier: "itemid", path: ["/apps/appCom/wish/web2014/deal/deal.asp"], key: "deal" },
            dealview: { identifier: "itemid", path: ["/apps/appCom/wish/web2014/deal/deal_view.asp"], key: "dealview" },
            gnbevent: { identifier: "eventid", path: ["/apps/appcom/wish/web2014/event/gnbeventmain.asp"], key: "gnbevent" },
            new: { identifier: "", path: ["/apps/appcom/wish/web2014/newitem/newitem.asp"], key: "new" },
            best: { identifier: "", path: ["/apps/appcom/wish/web2014/award/awarditem.asp"], key: "best" },
            sale: { identifier: "", path: ["/apps/appcom/wish/web2014/sale/saleitem.asp"], key: "sale" },
            clearance: { identifier: "", path: ["/apps/appcom/wish/web2014/clearancesale/", "/apps/appcom/wish/web2014/clearancesale/index.asp"], key: "clearance" },
            basket: { identifier: "", path: ["/apps/appCom/wish/web2014/inipay/ShoppingBag.asp"], key: "basket" },
            wish: { identifier: "", path: ["/apps/appCom/wish/web2014/my10x10/mywish/mywish.asp"], key: "wish" },
            ds: { identifier: "", path: ["/apps/appCom/wish/web2014/diarystory2020/", "/apps/appCom/wish/web2014/diarystory2020/index.asp"], key: "ds" }
        };
        this.M_TARGET_MAP = {
            main: { identifier: "", path: ["/", "/index.asp"], key: "main" },
            search: { identifier: "rect", path: ["/search/search_item.asp"], key: "search" },
            category: { identifier: "disp", path: ["/category/category_list.asp", "/category/category_main.asp"], key: "category" },
            event: { identifier: "eventid", path: ["/event/eventmain.asp"], key: "event" },
            gnbevent: { identifier: "eventid", path: ["/subgnb/gnbeventmain.asp"], key: "gnbevent" },
            brand: { identifier: "", path: ["/street/", "/street/index.asp"], key: "brand" },
            brandview: { identifier: "makerid", path: ["/street/street_brand.asp"], key: "brandview" },
            itemview: { identifier: "itemid", path: ["/category/category_itemPrd.asp"], key: "itemview" },
            deal: { identifier: "itemid", path: ["/deal/deal.asp"], key: "deal" },
            dealview: { identifier: "itemid", path: ["/deal/deal_view.asp"], key: "dealview" },
            new: { identifier: "", path: ["/shoppingtoday/shoppingchance_newitem.asp"], key: "new" },
            best: { identifier: "", path: ["/award/awarditem.asp"], key: "best" },
            sale: { identifier: "", path: ["/shoppingtoday/shoppingchance_saleitem.asp"], key: "sale" },
            clearance: { identifier: "", path: ["/clearancesale/", "/clearancesale/index.asp"], key: "clearance" },
            basket: { identifier: "", path: ["/inipay/ShoppingBag.asp"], key: "basket" },
            wish: { identifier: "", path: ["/my10x10/mywish/mywish.asp"], key: "wish" },
            ds: { identifier: "", path: ["/diarystory2020/", "/diarystory2020/index.asp"], key: "ds" }
        };

        // 멤버변수
        this.itemId = null;
        this.fixeddate = this.getCurrentDate();

        // ==================== 사용자 식별자 ======================
        this.lgseq = null; //ggsn
        this.ip = null; //user ip address
        this.siseq = null; //Session.SessionId
        this.ua = null; // user agent

        // ==================== 페이지 ======================
        /* 
            - 페이지 구분
            메인 = main
            검색 = search
            카테고리 메인 = category
            이벤트 = event
            브랜드 스트리트 = brand
            상품 상세 = itemview
            딜 = deal
            딜 상세 = dealview
            gnb 이벤트메인 = gnbevent
            신상품 = new
            베스트셀러 = best
            할인특가 = sale
            클리어런스 = clearance
            장바구니 = basket
            위시 = wish
            다이어리 스토리 = ds
        */
        this.pg = null;
        /* 
        - 조회 대상 식별자
        검색 = 검색 키워드
        카테고리 메인 = 카테고리 코드(disp)
        이벤트 = 이벤트 코드
        브랜드 스트리트 = 브랜드 아이디
        상품 상세 = 상품 코드
        딜 = 딜 코드
        딜 상세 = 상품 코드
        gnb 이벤트메인 = 이벤트 코드
        장바구니 = 상품코드
        위시 = 상품코드
        */
        this.tg = null;
        /* 
            - 조회 대상 부가정보         
            딜 상세 = 딜 코드(dealitemid)
            장바구니 = 상품옵션코드
            위시 = 상품옵션코드(*)
            검색 = qs['srm']        
        */
        this.tp = null;
        /* 
            - 페이지 번호
            다음 페이지에서만 적는다.
            카테고리, 브랜드스트리트, 검색, 신상품, 할인특가, 클리어런스        
        */
        this.cpg = null;
        /*
            - 채널 
            pc = p
            mobile web = m
            app = a
        */
        this.chn = this.getChannel();
        // ==================== 유입 ======================
        this.inflow1 = null; // 내부 유입 유형 1
        this.inflow2 = null; // 내부 유입 유형 2 
        this.inflow3 = null; // 내부 유입 유형 3
        this.inflow4 = null; // 내부 유입 유형 4
        this.referer = null; // 이전 페이지
        this.rdsite = null; // 외부 유입 사이트
        this.source = null; // 외부 유입 정보
        this.medium = null; // 외부 유입 정보
        this.campaign = null; // 외부 유입 정보
        this.qs = decodeURIComponent(window.location.search.replace(/\+/g, " ")) || null; //쿼리 스트링        

        // ==================== 기타 ======================
        this.allCookies = Cookies.get();
        this.qsObj = this.getQueryObject();
        this.currentTarget = null;
        this.gaParam = this.qsObj['gaparam'];
        this.payload = {};
        this.currentTargetMap = null;

        this.init();
        pp_instance = this;
    }

    _createClass(DataGen, [{
        key: "setTargetMap",
        value: function setTargetMap() {
            switch (this.chn) {
                case 'w':
                    this.currentTargetMap = this.W_TARGET_MAP;
                    break;
                case 'a':
                    this.currentTargetMap = this.A_TARGET_MAP;
                    break;
                case 'm':
                    this.currentTargetMap = this.M_TARGET_MAP;
                    break;
                default:
                    this.currentTargetMap = null;
                    break;
            }
        }

        /**
         * 모든 쿼리스트링을 obj형태로 가져온다.
         * @param {string} url
         * @returns {Object}
         */

    }, {
        key: "getQueryObject",
        value: function getQueryObject(url) {
            url = url == null ? window.location.href.toLowerCase() : url.toLowerCase();
            var search = url.substring(url.lastIndexOf("?") + 1);
            var obj = {};
            var reg = /([^?&=]+)=([^?&=]*)/g;
            search.replace(reg, function(rs, $1, $2) {
                var name = decodeURIComponent($1);
                var val = decodeURIComponent($2);
                val = String(val);
                obj[name] = val;
                return rs;
            });
            return obj;
        }

        /**
         * 정규식에 매치되는 값을 가진 쿠키를 반환한다.
         * @param {string} 정규식
         * @returns {string} 매치한값
         */

    }, {
        key: "getCookiesWithRE",
        value: function getCookiesWithRE(re) {
            var _this = this;

            var res = void 0;
            Object.keys(this.allCookies).forEach(function(o) {
                if (re.test(o)) {
                    res = _this.allCookies[o];
                }
            });
            return res;
        }

        /**
         * 현재 시간을 "yyyy-mm-dd hh-MM-ss" 포멧으로 가져온다.
         * @returns {string}
         */

    }, {
        key: "getCurrentDate",
        value: function getCurrentDate() {
            var date = new Date();
            return date.getFullYear() + "-" + ("00" + (date.getMonth() + 1)).slice(-2) + "-" + ("00" + date.getDate()).slice(-2) + " " + ("00" + date.getHours()).slice(-2) + ":" + ("00" + date.getMinutes()).slice(-2) + ":" + ("00" + date.getSeconds()).slice(-2);
        }

        /**
         * 이름에 해당하는 쿼리스트링을 반환한다.
         * @param {string} name
         * @param {string|undefined} url
         * @returns {string}
         */

    }, {
        key: "getParameterByName",
        value: function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(url);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        /**
         * 클라이언트 ip주소를 가져온다. jquery 종속
         * @returns {string} ip address
         */

    }, {
        key: "getClientIPAddress",
        value: function getClientIPAddress() {
            return $.getJSON('https://api.ipify.org?format=json');
        }

        /**
         * 스크립트가 실행되는 채널값을 반환한다.
         * @returns {string} a / m / w
         */

    }, {
        key: "getChannel",
        value: function getChannel() {
            var channel = void 0;
            if (navigator.userAgent.indexOf('tenapp') > -1) {
                channel = "a";
            } else if (window.location.href.indexOf("m.10x10") > -1) {
                channel = "m";
            } else if (window.location.href.indexOf("www.10x10") > -1) {
                channel = "w";
            }
            return channel;
        }
    }, {
        key: "setData",
        value: function setData() {
            var _this2 = this;

            try {
                // let clientIp = null
                // try {
                //     const { ip } = await this.getClientIPAddress()
                //     clientIp = ip
                // } catch (error) {
                //     console.log(error)
                // }
                this.setTargetMap();

                Object.keys(this.currentTargetMap).forEach(function(o) {
                    _this2.currentTargetMap[o].path.forEach(function(p) {
                        if (p.toLowerCase() === window.location.pathname.toLowerCase()) {
                            _this2.currentTarget = _this2.currentTargetMap[o];
                        }
                    });
                });
                if (!this.currentTarget) return false;

                this.itemId = this.qsObj['itemid'];
                // 사용자 식별자
                this.lgseq = this.allCookies['ggsn']; //ggsn
                // this.ip = clientIp //user ip address
                this.siseq = this.getCookiesWithRE(/^ASPSESSIONID[A-Z]+/); //Session.SessionId
                this.ua = navigator.userAgent; // user agent          
                // 페이지
                this.pg = this.currentTarget ? this.currentTarget.key : null;
                this.tg = this.getTG();
                this.tp = this.getTP();
                this.cpg = this.getCurrentPage();
                // 유입
                this.setInflowData();
                this.referer = decodeURIComponent(document.referrer.replace(/\+/g, " "));
                this.rdsite = this.allCookies['rdsite'] ? decodeURIComponent(this.allCookies['rdsite']) : null;
                this.source = this.qsObj['utm_source'] || null;
                this.medium = this.qsObj['utm_medium'] || null;
                this.campaign = this.qsObj['utm_campaign'] || null;
                return true;
            } catch (error) {
                console.error(error);
                return false;
            }
            // return new Promise((res, rej) => {
            // })
        }
    }, {
        key: "getTG",
        value: function getTG() {
            var tg = this.currentTarget ? this.filterIdf(this.qsObj[this.currentTarget.identifier]) || null : null;

            return tg;
        }
    }, {
        key: "filterIdf",
        value: function filterIdf(str) {
            if (!str) return null;
            var hashLink = "#";
            return str.substr(0, str.indexOf(hashLink) != -1 ? str.indexOf(hashLink) : str.length);
        }
    }, {
        key: "getTP",
        value: function getTP() {
            var tp = null;
            if (this.currentTarget.key === "dealview") {
                tp = this.qsObj['dealitemid'];
            }
            return this.filterIdf(tp);
        }
    }, {
        key: "getCurrentPage",
        value: function getCurrentPage() {
            var _this3 = this;

            // 카테고리, 브랜드스트리트, 검색, 신상품, 할인특가, 클리어런스
            var pagesWithCpg = ["category", "search", "new", "sale", "clearance", "brandview"];
            var cpg = null;

            try {
                if (this.currentTarget) {
                    pagesWithCpg.forEach(function(p) {
                        if (_this3.currentTarget.key === p) {
                            cpg = _this3.qsObj['cpg'] || 1;
                        }
                    });
                    if (this.currentTarget.key === "dealview") {
                        cpg = this.qsObj['viewnum'];
                    }
                }
            } catch (error) {
                console.error(error);
            }

            return cpg || null;
        }
    }, {
        key: "setInflowData",
        value: function setInflowData() {
            var _this4 = this;

            var setInflow = function setInflow(f1, f2, f3, f4) {
                _this4.inflow1 = f1 || null;
                _this4.inflow2 = f2 || null;
                _this4.inflow3 = f3 || null;
                _this4.inflow4 = f4 || null;
            };
            var rc1 = null;
            var rc2 = null;
            if (this.qsObj['rc']) {
                rc1 = this.qsObj['rc'].split('_')[1];
                rc2 = this.qsObj['rc'].split('_')[2];
            }

            if (this.qsObj['prtr']) {
                setInflow('prtr', this.qsObj['prtr'], rc1, rc2);
            } else if (this.qsObj['petr']) {
                setInflow('petr', this.qsObj['petr']);
            } else if (this.qsObj['pctr']) {
                setInflow('pctr', this.qsObj['pctr'], rc1, rc2);
            } else if (this.qsObj['pbtr']) {
                setInflow('pbtr', this.qsObj['pbtr'], rc1, rc2);
            } else if (this.qsObj['rc']) {
                setInflow('rc', rc1, rc2);
            } else if (this.qsObj['gaparam']) {
                setInflow(this.gaParam.split('_')[0], this.gaParam.split('_')[1], this.gaParam.split('_')[2]);
            }
        }
    }, {
        key: "makePayload",
        value: function makePayload() {
            var payload = {
                StreamName: this.KINESIS,
                Data: {
                    fixeddate: this.fixeddate,
                    lgseq: this.lgseq,
                    // ip: this.ip,
                    siseq: this.siseq,
                    ua: this.ua,
                    pg: this.pg,
                    tg: this.tg,
                    tp: this.tp,
                    cpg: this.cpg,
                    chn: this.chn,
                    inflow1: this.inflow1,
                    inflow2: this.inflow2,
                    inflow3: this.inflow3,
                    inflow4: this.inflow4,
                    referer: this.referer,
                    rdsite: this.rdsite,
                    source: this.source,
                    medium: this.medium,
                    campaign: this.campaign,
                    qs: this.qs
                },
                PartitionKey: this.lgseq
            };
            // console.log('payload: ', payload)
            this.payload = payload;
        }
    }, {
        key: "sendUserActivity",
        value: function sendUserActivity() {
            var _this5 = this;

            $.ajax({
                type: 'POST',
                url: "" + this.BASE_URL + this.KINESIS + "/",
                data: JSON.stringify(this.payload),
                beforeSend: function beforeSend(xhr) {
                    xhr.setRequestHeader("X-API-Key", _this5.API_KEY);
                    xhr.setRequestHeader("Content-type", "application/json");
                },
                error: function error(xhr, status, _error) {
                    console.error('sending data failed from front pipeline');
                },
                success: function success(xml) {
                    // console.log('success')
                    // console.log(xml)
                }
            });
        }
    }, {
        key: "handleEvt",
        value: function handleEvt() {}
    }, {
        key: "setAjaxInterceptor",
        value: function setAjaxInterceptor(cb) {
            XMLHttpRequest.prototype.open = function(open) {
                return function(method, url, async) {
                    if (cb != undefined && cb instanceof Function) cb(method, url);
                    open.apply(this, arguments);
                };
            }(XMLHttpRequest.prototype.open);
        }
    }, {
        key: "setInterceptorOnPage",
        value: function setInterceptorOnPage() {
            var _this6 = this;

            if (this.chn == "w" && this.currentTarget.key == "deal") {
                this.setAjaxInterceptor(function(method, url) {
                    if (url.toLowerCase().indexOf('act_itemprd_pop.asp') > -1) {
                        try {
                            _this6.payload.Data.pg = 'dealview';
                            _this6.payload.Data.qs = decodeURIComponent(url.substring(url.lastIndexOf("?") + 1).replace(/\+/g, " ")) || null;
                            _this6.payload.Data.tg = _this6.filterIdf(_this6.getQueryObject(url).itemid);
                            _this6.sendUserActivity();
                        } catch (error) {
                            console.error(error);
                        }
                    }
                });
            }
        }
    }, {
        key: "init",
        value: function init() {
            var _this7 = this;

            window.setTimeout(function() {
                if (!_this7.setData()) return false;
                _this7.setInterceptorOnPage();
                _this7.makePayload();
                _this7.sendUserActivity();
            }, 0);

            // this.setData().then((res) => {
            //     this.makePayload()
            //     this.sendUserActivity()
            // }).catch((rej) => {
            //     if (rej === "not target page") return false
            // })
        }
    }]);

    return DataGen;
}();

var dg1 = new DataGen();