<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Kakao 도서 검색</title>
</head>

<body>
<h4>📚 물류 도서 검색 📚</h4>
<input id="bookName" value="물류"  type="text">
<button id="search">검색</button>

<p id="book"></p>
<script src="https://code.jquery.com/jquery-3.4.1.js"
        integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
<script>
    $(document).ready(function () {
        $("#search").click(function () {

            $.ajax({
                method: "GET",
                url: "https://dapi.kakao.com/v3/search/book?target=title",
                data: { query: $("#bookName").val() },
                headers: { Authorization: "KakaoAK 266da29ea8b86e737adfa1e7d4dfcb9f" }
            })
                .done(function (msg) {
                    $("#book").empty();
                    for(i=0;i<10;i++)
                    {
                        console.log(msg.documents[i].title);
                        console.log(msg.documents[i].thumbnail);
                        console.log(msg);

                        $("#book").append("<img src= '" + msg.documents[i].thumbnail + "'/>");
                        $("#book").append("<strong>" + msg.documents[i].title + "</strong><br/>");


                    }

                });
        });
    });
</script>
</body>

</html>