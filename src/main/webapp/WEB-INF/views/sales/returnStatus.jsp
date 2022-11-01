<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
        // O setting datapicker
        $(function () {
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
                startDate: start,
                endDate: end,
                minDate: "-10d",
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
                // update "toDate" defaults whenever "fromDate" changes
            })
            $('#toDate').datepicker({
                startDate: start,
                endDate: end,
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
            })
            $('#fromDate').on("change", function () {
                //when chosen from_date, the end date can be from that point forward
                var startVal = $('#fromDate').val();
                $('#toDate').data('datepicker').setStartDate(startVal);
            });
            $('#toDate').on("change", function () {
                //when chosen end_date, start can go just up until that point
                var endVal = $('#toDate').val();
                $('#fromDate').data('datepicker').setEndDate(endVal);
            });

        });
    </script>
    <style>
        .fromToDate {
            margin-bottom: 7px;
        }

        .button1 {
            background-color: #506FA9;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 17px;
            border-radius: 3px;
            margin-bottom: 10px;
        }
        .button2 {
            background-color: #dc3170;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 17px;
            border-radius: 3px;
            margin-bottom: 10px;
        }
        .button3 {
            background-color: #506FA9;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 17px;
            padding-bottom: 4px;
            padding-top: 4px;
            border-radius: 3px;
            margin-bottom: 20px;
        }
        @media (min-width: 768px) {
            .modal-xl {
                width: 90%;
                max-width:1200px;
            }
        }
        /*헤더 여백주기*/
        .ag-header-cell-label {
            justify-content: center;
        }
        .ag-cell-value {
            padding-left: 50px;
        }
    </style>
</head>
<body>
<article class="contract">
    <div class="contract__Title">
        <h5>📦 반품 등록</h5>
        <div style="color: black;">
            <b>납품 날짜</b><br/>
        </div>

        <form autocomplete="off">
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                      style="text-align: center">
                &nbsp;&nbsp;&nbsp;&nbsp;<div class="button1" type="button" id="contractCandidateSearchButton">&nbsp;&nbsp;반품 가능 조회&nbsp;&nbsp;</div>
                <div class="button2" type="button" id="ReturnRegistersButton" >&nbsp;&nbsp;반품 등록&nbsp;&nbsp;</div>
            </div>

        </form>


        <input type="hidden" button id="mpsModalBtn"></div>
    </div>
</article>
<article class="contractMpsGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
    </div>
</article>
<br>
<br>
<div>
    <h5>📦 반품 목록 &nbsp;&nbsp;<div class="button3" type="button" id="returnListSearchButton">&nbsp;&nbsp;반품 내역 조회&nbsp;&nbsp;</div> </h5>
</div>
<article class="salesMpsGrid">
    <div align="center" class="ss">
        <div id="myGrid2" class="ag-theme-balham" style="height:30vh;width:auto;"></div>
    </div>
</article>

<div class="modal fade" id="mpsModal" role="dialog">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">MPS LIST</h5>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="mpsGrid" class="ag-theme-balham" style="height:600px;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<script>
    const myGrid = document.querySelector("#myGrid");
    const myGrid2 = document.querySelector("#myGrid2");
    const searchByDateRadio = document.querySelector("#searchByDateRadio");
    const startDatePicker = document.querySelector("#fromDate");
    const endDatePicker = document.querySelector("#toDate");


    // O customerList Grid
    let returnColumn = [
        {headerName: "납품번호", field: "deliveryNO", suppressSizeToFit: true, headerCheckboxSelection: true,
            headerCheckboxSelectionFilteredOnly: true,
            checkboxSelection: true, width: 200
        },
        {headerName: "납품일자", field: "deliveryDate", width: 250 },
        {
            headerName: "반품일자", field: "returnDate", editable: true, cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "YYYY-MM-DD";}
                return '📅 ' + params.value;
            }, cellEditor: 'datePicker1'
        },
        {headerName: "거래처명", field: "customerName" },
        {headerName: "품목이름", field: "itemName"},
        {headerName: "반품수량 ", field: "returnUnit", width: 130},
        {headerName: "반품단가", field: "returnUnitPrice", width: 200},
        {headerName: "반품총단가", field: "returnSumPrice"},

        {headerName: "비고", field: "description", editable: true, hide: false, width: 200},
    ];
    // event.colDef.field
    let rowData= [];
    let contractReturnRowNode;

    // 첫번째 그리드옵션
    let returnGridOptions = {
        defaultColDef: {
            // flex: 1,
            minWidth: 100,
            resizable: true,
        },
        columnDefs: returnColumn,
        rowSelection: 'multiple',
        rowData: rowData,
        getRowNodeId: function (data) {
            return data.contractDetailNo;
        },
        defaultColDef: {editable: false, resizable : true},
        overlayNoRowsTemplate: "반품 가능한 리스트가 없습니다.",
        onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
            event.api.sizeColumnsToFit();
        },
        onGridSizeChanged: function (event) {
            event.api.sizeColumnsToFit();
        },

        onRowClicked: function(event) {
            console.log(event.data);
            contractReturnRowNode = event;
        },
        getSelectedRowData() {
            let selectedNodes = this.api.getSelectedNodes();
            let selectedData = selectedNodes.map(node => node.data);
            return selectedData;
        },
        components: {
            datePicker1: getDatePicker("returnDate"),

        }
    }
    // 두번째 그리드 옵션
    let returnListGridOptions = {
        defaultColDef: {
            flex: 1,
            minWidth: 100,
            resizable: true,
        },
        columnDefs: returnColumn,
        rowSelection: 'multiple',
        rowData: rowData,
        getRowNodeId: function (data) {
            return data.contractDetailNo;
        },
        defaultColDef: {editable: false, resizable : true},
        overlayNoRowsTemplate: "반품 가능한 리스트가 없습니다.",
        onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
            event.api.sizeColumnsToFit();
        },
        onGridSizeChanged: function (event) {
            event.api.sizeColumnsToFit();
        },
        onCellEditingStarted: (event) => {
        },
        onRowClicked: function(event) {
            console.log(event.data);
            contractReturnRowNode = event;
        },
        getSelectedRowData() {
            let selectedNodes = this.api.getSelectedNodes();
            let selectedData = selectedNodes.map(node => node.data);
            return selectedData;
        },
        components: {
            datePicker1: getDatePicker("mpsPlanDate"),
            datePicker2: getDatePicker("scheduledEndDate")
        }
    }
    //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ납품 등록가능 조회ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


    const contractCandidateSearchBtn = document.querySelector("#contractCandidateSearchButton");

    contractCandidateSearchBtn.addEventListener("click", () => {
        // o contractDate or dueDateOfContract

        let startDate = startDatePicker.value;
        let endDate = endDatePicker.value;
        // o detect error
        if (startDate == "" || endDate == "") {
            Swal.fire("입력", "시작일자와 종료일자를 입력하셔야합니다.", "info");
            return;
        }
        console.log(startDate);
        console.log(endDate);
        // o reset Grid
        returnGridOptions.api.setRowData([]);
        // o ajax
        let xhr = new XMLHttpRequest();
        xhr.open('GET', "${pageContext.request.contextPath}/sales/returnableList"
            + "?method=getReturnList"
            // + "&searchCondition=" + searchCondition
            + "&startDate=" + startDate
            + "&endDate=" + endDate,
            true);

        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        console.log(xhr+"xhr")
        console.log(xhr);
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                txt = JSON.parse(txt);
                console.log(txt);
                let gridRowJson = txt.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
                if (gridRowJson == "") {
                    swal.fire("반품 가능 수주가 없습니다.");
                    return;
                }
                console.log(gridRowJson);
                gridRowJson.map((unit, idx) => {
                    unit.description = unit.description == null ? "" : unit.description
                    unit.planClassification = unit.planClassification == null ? "수주상세" : unit.planClassification
                    console.log(unit);
                    returnGridOptions.api.updateRowData({add: [unit]});
                });
            }
        }

    });


    /////////////////////////////////////////반품등록 클릭 작업중///////////////////////////////////////////


    const returnBtn = document.querySelector("#ReturnRegistersButton");

    returnBtn.addEventListener("click", () => {

        let ableContractInfo = JSON.stringify(returnListGridOptions.getSelectedRowData());
        console.log(ableContractInfo+"ableContractInfo");
        ableContractInfo = encodeURI(ableContractInfo);
        // deliverableContractGridOptions.api.setRowData([]);


        let xhr = new XMLHttpRequest();
        xhr.open('GET', "${pageContext.request.contextPath}/sales/returnList"
            + "?method=getReturnList"
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

                returnListGridOptions.api.setRowData(txt.gridRowJson);
            }
        }
    })


    // O getDataPicker
    function getDatePicker(paramFmt) {
        let _this = this;
        _this.fmt = "yyyy-mm-dd";


        // function to act as a class
        function Datepicker() {
        }
        Datepicker.prototype.init = function (params) {
            // create the cell
            this.autoclose = true;
            this.eInput = document.createElement('input');
            this.eInput.style.width = "100%";
            this.eInput.style.border = "0px";
            this.cell = params.eGridCell;
            this.oldWidth = this.cell.style.width;
            this.cell.style.width = this.cell.previousElementSibling.style.width;
            this.eInput.value = params.value;
            console.log(paramFmt);
            // Setting startDate and endDate
            let _startDate = new Date();
            let _endDate;
            let year = _startDate.getFullYear();              //yyyy
            let month = (1 + _startDate.getMonth());          //M
            month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
            let day = _startDate.getDate();                   //d
            day >= 10 ? day : '0' + day;          //day 두자리로 저장
            _startDate = year + '' + month + '' + day;
            _endDate = _startDate
            console.log(contractReturnRowNode);
            if (paramFmt == "scheduledEndDate") {
                _endDate = contractReturnRowNode.data.dueDateOfContract;
                console.log(_endDate);
            }

            $(this.eInput).datepicker({
                startDate: _startDate,
                endDate: _endDate,
                dateFormat: _this.fmt
            }).on('change', function () {
                returnGridOptions.api.stopEditing();
                $(".datepicker-container").hide();
            });
        };
        // gets called once when grid ready to insert the element
        Datepicker.prototype.getGui = function () {
            return this.eInput;
        };

        // focus and select can be done after the gui is attached
        Datepicker.prototype.afterGuiAttached = function () {
            this.eInput.focus();
            console.log(this.eInput.value);
        };

        // returns the new value after editing
        Datepicker.prototype.getValue = function () {
            console.log(this.eInput);
            return this.eInput.value;
        };

        // any cleanup we need to be done here
        Datepicker.prototype.destroy = function () {
            returnGridOptions.api.stopEditing();
        };
        return Datepicker;
    }
    // O setup the grid after the page has finished loading
    document.addEventListener('DOMContentLoaded', () => {
        new agGrid.Grid(myGrid, returnGridOptions);
        new agGrid.Grid(myGrid2, returnListGridOptions);
    })
</script>
</body>
</html>