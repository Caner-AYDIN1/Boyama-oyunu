<%
Response.CodePage = 1254
Response.Charset = "ISO-8859-9"

' Session'dan kullanıcı ID'sini al
Dim userID
userID = Session("aktifKullaniciID")

' Formdan gelen veriyi al
Dim score
score = Request.Form("score")

' Kullanıcı ID'sinin geçerli olup olmadığını kontrol et
If IsEmpty(userID) Or IsNull(userID) Or userID = "" Then
    Response.Write "Hata: Geçersiz kullanıcı ID'si."
Else
    ' Veritabanı bağlantısı oluştur
    Dim conn, sql, rs
    Set conn = Server.CreateObject("ADODB.Connection")
    conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("kayitlar.mdb")

    ' Kullanıcının mevcut puanı olup olmadığını kontrol et
    sql = "SELECT * FROM Puanlar WHERE userID = " & userID
    Set rs = conn.Execute(sql)

    If Not rs.EOF Then
        ' Mevcut puan var, güncelle
        sql = "UPDATE Puanlar SET puan = " & score & " WHERE userID = " & userID
    Else
        ' Mevcut puan yok, ekle
        sql = "INSERT INTO Puanlar (userID, puan) VALUES (" & userID & ", " & score & ")"
    End If

    ' Sorguyu çalıştır
    On Error Resume Next
    conn.Execute sql

    If Err.Number = 0 Then
        Response.Write "Skor basariyla kaydedildi."
    Else
        Response.Write "Hata oluştu: " & Err.Description
        Err.Clear
    End If

    ' Recordset ve bağlantıyı kapat
    rs.Close
    Set rs = Nothing
    conn.Close
    Set conn = Nothing
End If
%>
