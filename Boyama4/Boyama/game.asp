<% 
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"

Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("kayitlar.mdb")



%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html" charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" href="style/style.css">
    <title>Oyun</title>
  
</head>

<body>
    <div class="field">
        <canvas id="userCanvas"></canvas>
        <div id="game-panel">
            <div id="new-game">
                <p><% EnIyiOyuncu() %><p>
                <p>Kullanıcı: <%= KullaniciAdiGetir() %></p>
                <p>Önceki Puan: <%= KullaniciPuaniniGetir() %></p>
                <button class="game-panel-buttons" onClick="start_level()">Başla</button>
                <button class="game-panel-buttons" onClick="show_scoreboard()">Puan Tablosu</button>
            </div>
            <div id="game-over">
                <p id="total_score">Toplam Skor: 500</p>
                <button class="game-panel-buttons" onClick="next_level()">Sonraki Bölüm</button>
            </div>
        </div>
        <div id="scoreboard" style="display:none;">
            <h2>Puan Tablosu</h2>
          <%
            Dim rs, sql, conn

            ' Veritabanı bağlantısı oluştur (bu kısımda conn nesnesinin zaten oluşturulmuş ve açık olduğunu varsayıyorum)
            ' conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("veritabani.mdb")

            sql = "SELECT Kullanicilar.username, Puanlar.puan " & _
            "FROM Kullanicilar " & _
            "INNER JOIN Puanlar ON Kullanicilar.ID = Puanlar.userID " & _
            "ORDER BY Puanlar.puan DESC"

            Set rs = conn.Execute(sql)

          %>
        <ol type="1" start="1">
        <%
        Do Until rs.EOF
        Response.Write "<li>" & rs("username") & ": " & rs("puan") & "</li>"
        rs.MoveNext
    Loop
rs.Close
Set rs = Nothing
%>
</ul>

            <button class="game-panel-buttons" onClick="hide_scoreboard()">Geri Dön</button>
        </div>
        <canvas id="originalCanvas"></canvas>
        <div id="timer">100</div>
        <div class="tools" id="tools">
            <button onClick="undo_last()" type="button" class="button">Geri Al</button>
            <button onClick="clear_canvas()" type="button" class="button">Temizle</button>
            <div onClick="changeColor(this)" class="color-field" style="background: red;"></div>
            <div onClick="changeColor(this)" class="color-field" style="background: blue;"></div>
            <div onClick="changeColor(this)" class="color-field" style="background: green;"></div>
            <div onClick="changeColor(this)" class="color-field" style="background: yellow;"></div>
            <input onInput="draw_color = this.value" type="color" class="color-picker">
            <input type="range" min="1" max="100" class="pen-range" id="pen-range" onInput="draw_width = this.value">
        </div>
    </div>
   <script src="scripts/main.js"></script>
</body>
<%
Function KullaniciAdiGetir()
    Set rs = conn.Execute("SELECT * FROM Kullanicilar WHERE ID=" & Session("aktifKullaniciID") & "")
    If Not rs.EOF Then
        KullaniciAdiGetir = rs("username")
    Else
        KullaniciAdiGetir = "Bulunamadi"
    End If
    rs.Close
    Set rs = Nothing
End Function

Function KullaniciPuaniniGetir()
    Set rs = conn.Execute("SELECT puan FROM Puanlar WHERE userID=" & Session("aktifKullaniciID") & "")
    If Not rs.EOF Then
        KullaniciPuaniniGetir = rs("puan")
    Else
        KullaniciPuaniniGetir = 0
    End If
    rs.Close
    Set rs = Nothing
End Function

Function EnIyiOyuncu()

    Dim rs, maxPuan, maxPuanYapanKullanici

      Dim sql
  sql = "SELECT * FROM Puanlar"

    Set rs = conn.Execute(sql)


    maxPuan = 0
    maxPuanYapanKullaniciID = ""

    If Not rs.EOF Then
        While Not rs.EOF
            If rs("puan") > maxPuan Then
                maxPuan = rs("puan")
                maxPuanYapanKullaniciID = rs("userID")
            End If
            rs.MoveNext
        Wend
    Else
        Response.Write("Puanlar Yok")
        Exit Function
    End If

    rs.Close
    Set rs = Nothing

    sql_kullanici = "SELECT username FROM Kullanicilar WHERE ID = " & maxPuanYapanKullaniciID
    Set rs = conn.Execute(sql_kullanici)


    If Not rs.EOF Then
        Response.Write("En Iyi Oyuncu<br>" & rs("username") & "<br>Puan : " & maxPuan)
    Else
        Response.Write("Kullanıcı bilgisi bulunamadı.")
    End If

    rs.Close
    Set rs = Nothing

End Function
%>
</html>
