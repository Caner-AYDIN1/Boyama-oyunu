<% 
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Kullanıcı Girişi</title>
    <style>
        /* CSS kodu buraya eklenecek */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
        }

        .register-container {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 50px;
            width: 300px;
            display: flex;
            flex-direction: column;
            align-items: center; /* İçerikleri yatayda ortalar */
        }

        .register-container h2 {
            margin-bottom: 20px;
        }

        .register-container form {
            display: flex;
            flex-direction: column;
            width: 100%;
            align-items: center; /* Form elemanlarını yatayda ortalar */
        }

        .register-container input[type="text"],
        .register-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box; /* Kenarlık ve dolgu dahil tüm genişliği kullan */
        }

        .register-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px; /* Butonun yukarıdaki alan ile arasına boşluk eklendi */
        }

        .register-container input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .register-container a {
        display: inline-block;
        width: 260px;
        padding: 10px 20px;
        background-color: #007bff;
        border: none;
        border-radius: 5px;
        color: white;
        text-decoration: none; /* Link altı çizgiyi kaldır */
        margin-top: 10px;
        font-size: 16px;
        text-align: center;
    }

    .register-container a:hover {
        background-color: #0056b3;
    }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Kullanıcı Girişi</h2>
    <form method="post" action="girisYap.asp">
        <input type="text" name="kullanici_adi" placeholder="Kullanıcı Adı" required>
        <input type="password" name="sifre" placeholder="Şifre" required>
        <input type="submit" value="Giriş Yap">
        <a href="kayitFormu.asp">Üye Ol</a>
</div>
    </form>
    
</body>
</html>
