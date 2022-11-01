<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">
    <script>
        // O 날짜 설정
        $(function() {
            // set default dates
            let start = new Date();
            start.setDate(start.getDate() - 20);
            // set end date to max one year period:
            let end = new Date(new Date().setYear(start.getFullYear() + 1));
            // o set searchDate
            $('#datepicker').datepicker({
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
            });
            // o set searchRangeDate
            $('#fromDate').datepicker({
                startDate: start.setDate(start.getDate()-365),
                endDate: end.setDate(start.getDate()+365),
                minDate: "-10d",
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
                // update "toDate" defaults whenever "fromDate" changes
            })
            $('#toDate').datepicker({
                startDate: start.setDate(start.getDate()-365),
                endDate: end.setDate(start.getDate()+365),
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
            })
            $('#fromDate').on("change", function() {
                //when chosen from_date, the end date can be from that point forward
                var startVal = $('#fromDate').val();
                $('#toDate').data('datepicker').setStartDate(startVal);
            });
            $('#toDate').on("change", function() {
                //when chosen end_date, start can go just up until that point
                var endVal = $('#toDate').val();
                $('#fromDate').data('datepicker').setEndDate(endVal);
            });

        });
    </script>
    <style>
        .fromToDate {
            display: inline-block;
            margin-bottom: 7px;
        }

        #searchCustomerBox {
            display: none;
            margin-bottom: 7px;
        }

        #datepicker {
            margin-bottom: 7px;
        }

        .button1 {
            background-color: #dc3170;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            border-radius: 3px;
        }
        .button2 {
            background-color: #3daff3;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            border-radius: 3px;
        }

        /*aggrid 헤더 가운데 정렬하는거*/

        .ag-header-cell-label {
            justify-content: center;
        }
        .ag-cell-value {
            padding-left: 50px;
        }
    </style>
</head>
<body>
<article class="delivery">
    <div class="delivery__Title" style="color: black">
        <h5>💰 매출</h5>
        <b>매출 기간 검색</b>
        <div>

            <label for="searchByPeriodRadio">
            </label>

            <input type="hidden" name="searchCondition" value="searchByDate" id="searchByPeriodRadio" checked>


        </div>
        <form autocomplete="off">

            <select name='searchCustomerBox' id='searchCustomerBox' style='width: 152px; height:26px;'>
            </select>
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                      style="text-align: center">
            </div>
            &nbsp;&nbsp; <div class="button1" type="button" id="deliveryButton">&nbsp&nbsp;매출 조회&nbsp;&nbsp;</div>
               <div class="button2" type="button" id="deliveryListButton">&nbsp;&nbsp;거래명세서 발급&nbsp;&nbsp;</div>
        </form>





    </div>

</article>
<article class="contractGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
    </div>
</article>

<script>
    const myGrid = document.querySelector("#myGrid");
    const myGrid2 = document.querySelector("#myGrid2");
    const searchByPeriodRadio = document.querySelector("#searchByPeriodRadio");     // 기간검색
    // const searchByCustomerRadio = document.querySelector("#searchByCustomerRadio"); // 거래처검색
    const searchCustomerBox = document.querySelector("#searchCustomerBox");
    const fromToDate = document.querySelector(".fromToDate");
    const startDatePicker = document.querySelector("#fromDate"); //  시작일자
    const endDatePicker = document.querySelector("#toDate");     //  종료일자
    const deliverableContractSearchBtn = document.querySelector("#deliverableContractSearchButton"); // 납품 가능 수주 조회
    const deliverableContractDetailBtn = document.querySelector("#deliverableContractDetailButton"); // 납품 가능 상세 조회
    const deliveryBtn = document.querySelector("#deliveryButton");                                     // 납품
    const deliveryListBtn = document.querySelector("#deliveryListButton");                             // 거래명세서

    // O setup the grid after the page has finished loading
    document.addEventListener('DOMContentLoaded', () => {
        getCustomerCode(); // 거래처 select태그 세팅
        new agGrid.Grid(myGrid, deliverableContractGridOptions);
        new agGrid.Grid(myGrid2, deliverableDetailGridOptions);
    })

    // 기간 검색, 거래처 검색 ==============================================
    searchByPeriodRadio.addEventListener("click", () => {
        fromToDate.style.display = "inline-block";
        searchCustomerBox.style.display = "none";
    });
    // searchByCustomerRadio.addEventListener("click", () => {
    //     searchCustomerBox.style.display = "inline-block";
    //     fromToDate.style.display = "none";
    // });
    const getCustomerCode = () => {
        getListData("CL-01");
        setTimeout(() => {
            let data = jsonData;
            let target = searchCustomerBox;
            for (let index of data.detailCodeList) {
                let node = document.createElement("option");
                node.value = index.detailCode;
                let textNode = document.createTextNode(index.detailCodeName);
                node.appendChild(textNode);
                target.appendChild(node);
            }
        }, 100)
    }
    // ===============================================================
    // O deliverableContract Grid 첫번째 그리드
    let deliverableContractColumn = [

        {headerName: "수주일자", field: "contractDate",
            headerCheckboxSelection: true,
            headerCheckboxSelectionFilteredOnly: true,
            checkboxSelection: true},

        {headerName: '수주일련번호', field: "contractNo",
            width: 200,
            headerCheckboxSelection: false,
            headerCheckboxSelectionFilteredOnly: true,
            suppressRowClickSelection: true,},

        {headerName: "납품날짜", field: "deliveryDate",
            checkboxSelection: false,},


        {headerName: "거래처명", field: "customerName",},


        {headerName: "매출액", field: "sumPrice"},
        {headerName: "순수익 (마진40%)", field: "netIncome"},
        {headerName: "비고", field: "description", editable : true,}
];

    // o 첫번째 그리드 옵션들
    let deliverableContractRowData = [];
    let deliverableContractGridOptions = {
        columnDefs: deliverableContractColumn,
        rowSelection: 'multiple',
        rowData: deliverableContractRowData,
        getRowNodeId: function(data) {
            return data.contractNo;
        },
        defaultColDef: {editable: false, resizable : true},
        overlayNoRowsTemplate: "수주 가능 리스트가 없습니다.",
        onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
            event.api.sizeColumnsToFit();
        },
        onGridSizeChanged: function(event) {
            event.api.sizeColumnsToFit();
        },
        getRowStyle: function (param) {
            return {'text-align': 'center'};
        },
        getSelectedRowData() {
            let selectedNodes = this.api.getSelectedNodes();
            let selectedData = selectedNodes.map(node => node.data);
            return selectedData;
        }
    }


 // =========================매출 조회 버튼 선언 =========================

    const deliverableContract = (searchCondition, startDate, endDate) => {

        deliverableContractGridOptions.api.setRowData();

        ableContractInfo = {"searchCondition":searchCondition,"startDate":startDate,"endDate":endDate};
        ableContractInfo=encodeURI(JSON.stringify(ableContractInfo));
        let xhr = new XMLHttpRequest();

        xhr.open('GET', "${pageContext.request.contextPath}/sales/SalesStatus"
            + "?method=getSalesStatus"
            + "&ableContractInfo=" + ableContractInfo,
            true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        console.log("//////여기/////"+xhr)
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                txt = JSON.parse(txt);

                if (txt.gridRowJson == "") {
                    Swal.fire("알림", "조회 가능 리스트가 없습니다.", "info");
                    return;
                } else if (txt.errorCode < 0) {
                    Swal.fire("알림", txt.errorMsg, "error");
                    return;
                }        console.log(xhr+"여기용")


                deliverableContractGridOptions.api.setRowData(txt.gridRowJson);
            }
        }
    }
    ///////////////// 매출 조회 버튼 클릭메서드 ///////////////////
    deliveryBtn.addEventListener("click", () => {
        let searchCondition = (searchByPeriodRadio.checked) ? searchByPeriodRadio.value : searchByCustomerRadio.value;
        let startDate = "";
        let endDate = "";
        console.log(endDate+"여기");
        if (searchCondition == 'searchByDate') {
            if (startDatePicker.value == "" || endDatePicker.value == "") {
                Swal.fire("입력", "시작일과 종료일을 입력하십시오.", "info");
                return
            } else {
                startDate = startDatePicker.value;
                endDate = endDatePicker.value;
            }
        } else if (searchCondition == 'searchByCustomer'){
            customerCode = searchCustomerBox.value;
        }
        deliverableContract(searchCondition, startDate, endDate);
    });



    ///////////////////// 거래명세서 클릭시 Customer_Report DB 이동 /////////////////////

    deliveryListBtn.addEventListener("click", () => {
        let ableContractInfo = JSON.stringify(deliverableContractGridOptions.getSelectedRowData());
        console.log(ableContractInfo);
        ableContractInfo = encodeURI(ableContractInfo);
        // deliverableContractGridOptions.api.setRowData([]);


        let xhr = new XMLHttpRequest();
        xhr.open('GET', "${pageContext.request.contextPath}/sales/CustomerReport"
            + "?method=getCustomerReport"
            + "&ableContractInfo=" + ableContractInfo
            ,true);
        xhr.setRequestHeader('Accept', 'application/json');
        let txt2=xhr.responseText;
        console.log(txt2);
        xhr.send();
        console.log("//////여기2/////"+xhr)
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                txt = JSON.parse(txt);

                if (txt.gridRowJson == "") {
                    Swal.fire("알림", "조회 가능 리스트가 없습니다.", "info");
                    return;
                } else if (txt.errorCode < 0) {
                    Swal.fire("알림", txt.errorMsg, "error");
                    return;
                }

                deliverableContractGridOptions.api.setRowData(txt.gridRowJson);
            }
        }
        // 클릭시 거래명세서 출력함
        location.href = "http://localhost:8075/webroot/decision/view/report?viewlet=DeliveryReport%252FWorkBook1.cpt"
    })

</script>
</body>
</html>