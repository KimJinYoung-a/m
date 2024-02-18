/**
 * jquery 종속
 * 프로토타입
 * 난독 / 압축 uglifyjs .\data-pipeline\pipeline-es5.js -c -m -o .\data-pipeline\pipeline.min.js
 * https://es6console.com/ 트랜스파일
 */
let pp_instance
class DataGen {
    constructor() {
        // 싱글톤
        if (pp_instance) return pp_instance

        // const
        this.KINESIS = "BIS-ACTIVITY-STREAM"
        this.BASE_URL = "https://gqb7it2caj.execute-api.ap-northeast-2.amazonaws.com/prod/streams/"
        this.API_KEY = "7wqxMesqxVa88OpaZEoFb91l1TWwa2ZJ6b5WjOWg"
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
            ds: { identifier: "", path: ["/diarystory2020/", "/diarystory2020/index.asp"], key: "ds" },
        }
        this.A_TARGET_MAP = {
            main: { identifier: "", path: ["/apps/appCom/wish/web2014/today/index.asp", "/apps/appCom/wish/web2014/today/"], key: "main" },
            // search: { identifier: "rect", path: ["/search/search_item.asp"], key: "search" },
            search_main: { identifier: "keyword", path: ["/search/search_result2020.asp"], key: "search_main" },        // 2020 renewaled    
            search: { identifier: "keyword", path: ["/search/search_product2020.asp"], key: "search" },                 // 2020 renewaled
            category_main: { identifier: "", path: ["/category/category_main2020.asp"], key: "category_main" },         // 2020 renewaled
            category: { identifier: "disp", path: ["/category/category_detail2020.asp"], key: "category" },             // 2020 renewaled
            event: { identifier: "eventid", path: ["/apps/appCom/wish/web2014/event/eventmain.asp"], key: "event" },
            brandview: { identifier: "brandid", path: ["/brand_detail2020.asp"], key: "brandview" },                     // 2020 renewaled
            itemview: { identifier: "itemid", path: ["/apps/appCom/wish/web2014/category/category_itemPrd.asp"], key: "itemview" },
            deal: { identifier: "itemid", path: ["/apps/appCom/wish/web2014/deal/deal.asp"], key: "deal" },
            dealview: { identifier: "itemid", path: ["/apps/appCom/wish/web2014/deal/deal_view.asp"], key: "dealview" },
            gnbevent: { identifier: "eventid", path: ["/apps/appcom/wish/web2014/event/gnbeventmain.asp"], key: "gnbevent" },
            new_main: { identifier: "", path: ["/apps/appcom/wish/web2014/list/new/new_summary2020.asp"], key: "new_main" },
            new: { identifier: "", path: ["/apps/appcom/wish/web2014/list/new/new_detail2020.asp"], key: "new" },            
            best_main: { identifier: "", path: ["/apps/appcom/wish/web2014/award/awarditem.asp"], key: "best_main" },
            best: { identifier: "", path: ["/apps/appcom/wish/web2014/award/awarditem.asp"], key: "best" },            
            sale_main: { identifier: "", path: ["/apps/appcom/wish/web2014/list/sale/sale_summary2020.asp"], key: "sale_main" },         // 2020 renewaled
            sale: { identifier: "", path: ["/apps/appcom/wish/web2014/list/sale/sale_detail2020.asp"], key: "sale" },                    // 2020 renewaled
            clearance_main: { identifier: "", path: ["/apps/appcom/wish/web2014/list/clearance/clearance_summary2020.asp"], key: "clearance_main" },
            clearance: { identifier: "", path: ["/apps/appcom/wish/web2014/list/clearance/clearance_detail2020.asp"], key: "clearance" },            
            basket: { identifier: "", path: ["/apps/appCom/wish/web2014/inipay/ShoppingBag.asp"], key: "basket" },
            wish: { identifier: "", path: ["/apps/appCom/wish/web2014/my10x10/mywish/mywish.asp"], key: "wish" },
            ds: { identifier: "", path: ["/apps/appCom/wish/web2014/diarystory2020/", "/apps/appCom/wish/web2014/diarystory2020/index.asp"], key: "ds" },
        }
        this.M_TARGET_MAP = {
            main: { identifier: "", path: ["/", "/index.asp"], key: "main" },
            search: { identifier: "keyword", path: ["/search/search_result2020.asp"], key: "search" },                           // 2020 renewaled
            search: { identifier: "keyword", path: ["/search/search_product2020.asp"], key: "search" },                          // 2020 renewaled
            category_main: { identifier: "", path: ["/category/category_main2020.asp"], key: "category_main" },                  // 2020 renewaled
            category: { identifier: "disp", path: ["/category/category_detail2020.asp"], key: "category" },                      // 2020 renewaled
            event: { identifier: "eventid", path: ["/event/eventmain.asp"], key: "event" },
            gnbevent: { identifier: "eventid", path: ["/subgnb/gnbeventmain.asp"], key: "gnbevent" },
            brand: { identifier: "", path: ["/street/", "/street/index.asp"], key: "brand" },
            brandview: { identifier: "brandid", path: ["/brand_detail2020.asp"], key: "brandview" },                             // 2020 renewaled
            itemview: { identifier: "itemid", path: ["/category/category_itemPrd.asp"], key: "itemview" },
            deal: { identifier: "itemid", path: ["/deal/deal.asp"], key: "deal" },
            dealview: { identifier: "itemid", path: ["/deal/deal_view.asp"], key: "dealview" },
            new_main: { identifier: "", path: ["/apps/appcom/wish/web2014/list/new/new_summary2020.asp"], key: "new_main" },     // 2020 renewaled
            new: { identifier: "", path: ["/apps/appcom/wish/web2014/list/new/new_detail2020.asp"], key: "new" },                // 2020 renewaled
            best_main: { identifier: "", path: ["/list/best/best_summary2020.asp"], key: "best_main" },                          // 2020 renewaled
            best: { identifier: "", path: ["/list/best/best_detail2020.asp"], key: "best" },                                     // 2020 renewaled
            sale_main: { identifier: "", path: ["/list/sale/sale_summary2020.asp"], key: "sale_main" },                          // 2020 renewaled
            sale: { identifier: "", path: ["/list/sale/sale_detail2020.asp"], key: "sale" },                                     // 2020 renewaled
            clearance_main: { identifier: "", path: ["/list/clearance/clearance_summary2020.asp"], key: "clearance_main" },      // 2020 renewaled
            clearance: { identifier: "", path: ["/list/clearance/clearance_detail2020.asp"], key: "clearance" },                 // 2020 renewaled
            basket: { identifier: "", path: ["/inipay/ShoppingBag.asp"], key: "basket" },
            wish: { identifier: "", path: ["/my10x10/mywish/mywish.asp"], key: "wish" },
            ds: { identifier: "", path: ["/diarystory2020/", "/diarystory2020/index.asp"], key: "ds" },
        }

        // 멤버변수
        this.itemId = null
        this.fixeddate = this.getCurrentDate()

        // ==================== 사용자 식별자 ======================
        this.lgseq = null //ggsn
        this.ip = null //user ip address
        this.siseq = null //Session.SessionId
        this.ua = null // user agent

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
        this.pg = null
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
        this.tg = null
            /* 
                - 조회 대상 부가정보         
                딜 상세 = 딜 코드(dealitemid)
                장바구니 = 상품옵션코드
                위시 = 상품옵션코드(*)
                검색 = qs['srm']        
            */
        this.tp = null
            /* 
                - 페이지 번호
                다음 페이지에서만 적는다.
                카테고리, 브랜드스트리트, 검색, 신상품, 할인특가, 클리어런스        
            */
        this.cpg = null
            /*
                - 채널 
                pc = p
                mobile web = m
                app = a
            */
        this.chn = this.getChannel()
            // ==================== 유입 ======================
        this.inflow1 = null // 내부 유입 유형 1
        this.inflow2 = null // 내부 유입 유형 2 
        this.inflow3 = null // 내부 유입 유형 3
        this.inflow4 = null // 내부 유입 유형 4
        this.referer = null // 이전 페이지
        this.rdsite = null // 외부 유입 사이트
        this.source = null // 외부 유입 정보
        this.medium = null // 외부 유입 정보
        this.campaign = null // 외부 유입 정보
        this.qs = decodeURIComponent(window.location.search.replace(/\+/g, " ")) || null //쿼리 스트링        

        // ==================== 기타 ======================
        this.allCookies = Cookies.get()
        this.qsObj = this.getQueryObject()
        this.currentTarget = null
        this.gaParam = this.qsObj['gaparam']
        this.payload = {}
        this.currentTargetMap = null

        this.init()
        pp_instance = this
    }

    setTargetMap() {
        switch (this.chn) {
            case 'w':
                this.currentTargetMap = this.W_TARGET_MAP
                break;
            case 'a':
                this.currentTargetMap = this.A_TARGET_MAP
                break;
            case 'm':
                this.currentTargetMap = this.M_TARGET_MAP
                break;
            default:
                this.currentTargetMap = null
                break;
        }
    }

    /**
     * 모든 쿼리스트링을 obj형태로 가져온다.
     * @param {string} url
     * @returns {Object}
     */
    getQueryObject(url) {
        url = url == null ? window.location.href.toLowerCase() : url.toLowerCase();
        const search = url.substring(url.lastIndexOf("?") + 1);
        let obj = {};
        const reg = /([^?&=]+)=([^?&=]*)/g;
        search.replace(reg, (rs, $1, $2) => {
            const name = decodeURIComponent($1);
            let val = decodeURIComponent($2);
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
    getCookiesWithRE(re) {
        let res
        Object.keys(this.allCookies).forEach((o) => {
            if (re.test(o)) {
                res = this.allCookies[o]
            }
        })
        return res
    }

    /**
     * 현재 시간을 "yyyy-mm-dd hh-MM-ss" 포멧으로 가져온다.
     * @returns {string}
     */
    getCurrentDate() {
        const date = new Date();
        return date.getFullYear() + "-" +
            ("00" + (date.getMonth() + 1)).slice(-2) + "-" +
            ("00" + date.getDate()).slice(-2) + " " +
            ("00" + date.getHours()).slice(-2) + ":" +
            ("00" + date.getMinutes()).slice(-2) + ":" +
            ("00" + date.getSeconds()).slice(-2);
    }

    /**
     * 이름에 해당하는 쿼리스트링을 반환한다.
     * @param {string} name
     * @param {string|undefined} url
     * @returns {string}
     */
    getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        const regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(url);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }

    /**
     * 클라이언트 ip주소를 가져온다. jquery 종속
     * @returns {string} ip address
     */
    getClientIPAddress() {
        return $.getJSON('https://api.ipify.org?format=json')
    }

    /**
     * 스크립트가 실행되는 채널값을 반환한다.
     * @returns {string} a / m / w
     */
    getChannel() {
        let channel
        if (navigator.userAgent.indexOf('tenapp') > -1) {
            channel = "a"
        } else if (window.location.href.indexOf("m.10x10") > -1) {
            channel = "m"
        } else if (window.location.href.indexOf("www.10x10") > -1) {
            channel = "w"
        }
        return channel
    }
    setData() {
        try {
            // let clientIp = null
            // try {
            //     const { ip } = await this.getClientIPAddress()
            //     clientIp = ip
            // } catch (error) {
            //     console.log(error)
            // }
            this.setTargetMap()

            Object.keys(this.currentTargetMap).forEach((o) => {
                this.currentTargetMap[o].path.forEach(p => {
                    if (p.toLowerCase() === window.location.pathname.toLowerCase()) {
                        this.currentTarget = this.currentTargetMap[o]
                    }
                });
            })
            if (!this.currentTarget) return false;

            this.itemId = this.qsObj['itemid']
                // 사용자 식별자
            this.lgseq = this.allCookies['ggsn'] //ggsn
                // this.ip = clientIp //user ip address
            this.siseq = this.getCookiesWithRE(/^ASPSESSIONID[A-Z]+/) //Session.SessionId
            this.ua = navigator.userAgent // user agent          
                // 페이지
            this.pg = this.currentTarget ? this.currentTarget.key : null
            this.tg = this.getTG()
            this.tp = this.getTP()
            this.cpg = this.getCurrentPage()
                // 유입
            this.setInflowData();
            this.referer = decodeURIComponent(document.referrer.replace(/\+/g, " "))
            this.rdsite = this.allCookies['rdsite'] ? decodeURIComponent(this.allCookies['rdsite']) : null
            this.source = this.qsObj['utm_source'] || null
            this.medium = this.qsObj['utm_medium'] || null
            this.campaign = this.qsObj['utm_campaign'] || null
            return true
        } catch (error) {
            console.error(error)
            return false
        }
        // return new Promise((res, rej) => {
        // })
    }
    getTG() {
        let tg = this.currentTarget ? this.filterIdf(this.qsObj[this.currentTarget.identifier]) || null : null

        return tg
    }
    filterIdf(str) {
        if (!str) return null
        const hashLink = "#"
        return str.substr(0, str.indexOf(hashLink) != -1 ? str.indexOf(hashLink) : str.length)
    }
    getTP() {
        let tp = null
        if (this.currentTarget.key === "dealview") {
            tp = this.qsObj['dealitemid']
        }
        return this.filterIdf(tp)
    }
    getCurrentPage() {
        // 카테고리, 브랜드스트리트, 검색, 신상품, 할인특가, 클리어런스
        const pagesWithCpg = ["category", "search", "new", "sale", "clearance", "brandview"]
        let cpg = null

        try {
            if (this.currentTarget) {
                pagesWithCpg.forEach(p => {
                    if (this.currentTarget.key === p) {
                        cpg = this.qsObj['cpg'] || 1
                    }
                });
                if (this.currentTarget.key === "dealview") {
                    cpg = this.qsObj['viewnum']
                }
            }
        } catch (error) {
            console.error(error)
        }

        return cpg || null
    }
    setInflowData() {
        const setInflow = (f1, f2, f3, f4) => {
            this.inflow1 = f1 || null
            this.inflow2 = f2 || null
            this.inflow3 = f3 || null
            this.inflow4 = f4 || null
        }
        let rc1 = null
        let rc2 = null
        if (this.qsObj['rc']) {
            rc1 = this.qsObj['rc'].split('_')[1]
            rc2 = this.qsObj['rc'].split('_')[2]
        }

        if (this.qsObj['prtr']) {
            setInflow('prtr', this.qsObj['prtr'], rc1, rc2)
        } else if (this.qsObj['petr']) {
            setInflow('petr', this.qsObj['petr'])
        } else if (this.qsObj['pctr']) {
            setInflow('pctr', this.qsObj['pctr'], rc1, rc2)
        } else if (this.qsObj['pbtr']) {
            setInflow('pbtr', this.qsObj['pbtr'], rc1, rc2)
        } else if (this.qsObj['rc']) {
            setInflow('rc', rc1, rc2)
        } else if (this.qsObj['gaparam']) {
            setInflow(this.gaParam.split('_')[0], this.gaParam.split('_')[1], this.gaParam.split('_')[2])
        }
    }
    makePayload() {
        const payload = {
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
                    qs: this.qs,
                },
                PartitionKey: this.lgseq
            }
            // console.log('payload: ', payload)
        this.payload = payload
    }
    sendUserActivity() {
        $.ajax({
            type: 'POST',
            url: `${this.BASE_URL}${this.KINESIS}/`,
            data: JSON.stringify(this.payload),
            beforeSend: (xhr) => {
                xhr.setRequestHeader("X-API-Key", this.API_KEY);
                xhr.setRequestHeader("Content-type", "application/json");
            },
            error: (xhr, status, error) => {
                console.error('sending data failed from front pipeline')
            },
            success: (xml) => {
                // console.log('success')
                // console.log(xml)
            },
        });
    }
    handleEvt() {

    }
    setAjaxInterceptor(cb) {
        XMLHttpRequest.prototype.open = (function(open) {
            return function(method, url, async) {
                if (cb != undefined && cb instanceof Function) cb(method, url);
                open.apply(this, arguments);
            };
        })(XMLHttpRequest.prototype.open)
    }
    setInterceptorOnPage() {
        if (this.chn == "w" && this.currentTarget.key == "deal") {
            this.setAjaxInterceptor((method, url) => {
                if (url.toLowerCase().indexOf('act_itemprd_pop.asp') > -1) {
                    try {
                        this.payload.Data.pg = 'dealview'
                        this.payload.Data.qs = decodeURIComponent((url.substring(url.lastIndexOf("?") + 1)).replace(/\+/g, " ")) || null
                        this.payload.Data.tg = this.filterIdf(this.getQueryObject(url).itemid)
                        this.sendUserActivity()
                    } catch (error) {
                        console.error(error)
                    }
                }
            })
        }
    }
    init() {
        window.setTimeout(() => {
            if (!this.setData()) return false
            this.setInterceptorOnPage()
            this.makePayload()
            this.sendUserActivity()
        }, 0)

        // this.setData().then((res) => {
        //     this.makePayload()
        //     this.sendUserActivity()
        // }).catch((rej) => {
        //     if (rej === "not target page") return false
        // })
    }
}

const dg1 = new DataGen()