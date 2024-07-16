<% 
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<link rel="stylesheet" type="text/css" href="../stil.css">
</head>

<body topmargin="100px">
<%username=request.form("kullanici_adi")
password=request.form("sifre")%>

<%Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("kayitlar.mdb")%>
<%Set rs = conn.Execute("SELECT * FROM Kullanicilar WHERE username='" & username & "' AND password='" & password & "'")

IF NOT rs.EOF Then
    Response.Write("<script>alert('Giriş Başarılı')</script>")
    Session("aktifKullaniciID") = rs("ID") 
    Response.Write("<script>window.location='game.asp'</script>")
ELSE
    Response.Write("<script>alert('Giris Basarisiz')</script>")
    Response.Write("<script>window.location='index.asp'</script>")
END IF
%>
</body>
</html>