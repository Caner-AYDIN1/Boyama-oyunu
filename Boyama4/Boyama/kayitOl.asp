<% 
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
    <meta charset="ISO-8859-9">
	<title>Untitled</title>
	<link rel="stylesheet" type="text/css" href="../stil.css">
</head>

<body topmargin="100px">
<%username=request.form("new_username")
password=request.form("new_password")
confirm_password=request.form("confirm_password")

IF password <> confirm_password Then
    Response.Write ("<script>alert('sifre Eslesmiyor')</script>")
    Response.Write("<script>window.location='kayitFormu.asp'</script>")
ELSE
    Set conn = Server.CreateObject("ADODB.Connection")
    conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("kayitlar.mdb")
    Set rs_check = conn.Execute("SELECT * FROM Kullanicilar WHERE username='" & username & "'")
    If Not rs_check.EOF Then
        Response.Write ("<script>alert('Bu kullanici adi mevcut')</script>")
        Response.Write("<script>window.location='kayitFormu.asp'</script>")
    ELSE
        conn.Execute("INSERT INTO Kullanicilar (username, [password]) VALUES ('" & username & "', '" & password & "')")
        Response.Write ("<script>alert('Kayit Basarili')</script>")
        Response.Write("<script>window.location='index.asp'</script>")
    END IF
END IF
%>
</body>
</html>