<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">

    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepickerUse.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">

</head>
<body>
<div>
    <h1>거래처 목록</h1>
    <article class="estimateGrid">
        <div align="center">
            <div id="accountData" class="ag-theme-balham" style="height:450px; width:auto; text-align: center;"></div>
        </div>
    </article>


    <script>
        $.ajax({
            url:"/compinfo/customer/allList",
            dataType:"json",
            method:"GET",
            success:(obj)=>{
                estGridOptions.api.setRowData(obj.customer);
            }
        })

        const accoutGrid = document.querySelector("#accountData");

        let estColumn = [
            {headerName: "고객 코드", field: "customerCode"}, // editable: 편집가능한 문자열로 EditText 의 기본 Type , field는 변수명
            {headerName: "직장코드", field: "workplaceCode"},
            {headerName: "고객 이름", field: "customerName"},
            {headerName: "고객유형", field: "customerType"},
            {headerName: "고객CEO", field: "customerCeo"},
            {headerName: "비즈니스 라이선스 번호", field: "businessLicenseNumber"},
            {headerName: "사회보장번호", field: "socialSecurityNumber"},
            {headerName: "고객비즈니스조건", field: "customerBusinessConditions"},
            {headerName: "고객비즈니스아이템", field: "customerBusinessItems"},
            {headerName: "고객우편번호", field: "customerZipCode"},
            {headerName: "고객기본주소", field: "customerBasicAddress"},
            {headerName: "고객 정보 주소", field: "customerDetailAddress"},
            {headerName: "고객전화번호", field: "customerTelNumber"},
            {headerName: "고객 팩스 번호", field: "customerFaxNumber"},
            {headerName: "고객노트", field: "customerNote"},
            {headerName: "생산된 제품", field: "producedProduct"}

        ];

        let estRowData = [];

        // event.colDef.field
        let estGridOptions = {
            columnDefs: estColumn,
            rowSelection: 'single',
            rowData: estRowData,
            onGridReady: function (event) {
                event.api.sizeColumnsToFit();
            }
        }
        document.addEventListener('DOMContentLoaded',()=>{
            new agGrid.Grid(accoutGrid, estGridOptions);
        })
    </script>

    <form action=/compinfo/customer/registerAccount>
        <article class="register">
            <div align="center">
                <div id="registerAccount" class="ag-theme-balham" style="height:100px; width:auto; text-align: center;"></div>
            </div>
        </article>
        <button>추가하기</button>
    </form>
    <button onclick="f">추가하기시작</button>
    <script>
        function f(){
            let i=registerEstColumn.length;

        }

        const registerAccount = document.querySelector("#registerAccount");
        let registerEstColumn = [
            {headerName: "고객 코드", field: "customerCode", editable: true}, // editable: 편집가능한 문자열로 EditText 의 기본 Type , field는 변수명
            {headerName: "직장코드", field: "workplaceCode", editable: true },
            {headerName: "고객 이름", field: "customerName",editable: true},
            {headerName: "고객유형", field: "customerType", editable: true},
            {headerName: "고객CEO", field: "customerCeo", editable: true},
            {headerName: "비즈니스 라이선스 번호", field: "businessLicenseNumber", editable: true},
            {headerName: "사회보장번호", field: "socialSecurityNumber", editable: true},
            {headerName: "고객비즈니스조건", field: "customerBusinessConditions", editable: true},
            {headerName: "고객비즈니스아이템", field: "customerBusinessItems", editable: true},
            {headerName: "고객우편번호", field: "customerZipCode", editable: true},
            {headerName: "고객기본주소", field: "customerBasicAddress", editable: true},
            {headerName: "고객 정보 주소", field: "customerDetailAddress", editable: true},
            {headerName: "고객전화번호", field: "customerTelNumber",editable: true},
            {headerName: "고객 팩스 번호", field: "customerFaxNumber", editable: true},
            {headerName: "고객노트", field: "customerNote", editable: true},
            {headerName: "생산된 제품", field: "producedProduct"}
        ];
        let i=registerEstColumn.length;
        console.log(registerEstColumn);
        let row = { // 버튼을 누르자마자 빈 그리드가 위치 되어지기 때문에 다 공백처리로 빈 값을 넣어놓는다고 볼 수 있다
            registerEstColumn:""    // 견적수량
        };

        let registerOptions = {
            columnDefs: registerEstColumn,
            autoSizeColumn:estColumn,
            rowData: estRowData,
            onGridReady: function (event) {
                event.api.sizeColumnsToFit();
            },
            onGridSizeChanged: function (event) {
                event.api.sizeColumnsToFit();
            }, getRowNodeId: function (data) {
                return data.estimateDate;
            }
        }

        document.addEventListener('DOMContentLoaded',()=>{
            new agGrid.Grid(registerAccount, registerOptions);
        })

    </script>
</div>
</body>
</html>