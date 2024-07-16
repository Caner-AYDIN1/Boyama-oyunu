// <canvas>, web tarayıcılarında dinamik grafikler çizmek için kullanılan bir HTML5 öğesidir.
// JavaScript kullanarak resimler, animasyonlar ve interaktif grafikler oluşturmak için ideal bir araçtır.
// getContext('2d') metoduyla çizim yapılır ve resim manipülasyonları (döndürme, ölçekleme) yapılabilir.
// Kullanıcı etkileşimleri (fare, dokunmatik) ile etkileşimli web uygulamaları ve oyunlar geliştirmek için idealdir.


const userCanvas = document.getElementById("userCanvas");
const originalCanvas = document.getElementById("originalCanvas");
const game_panel = document.getElementById("game-panel");
const timer = document.getElementById("timer");
const tools = document.getElementById("tools");
const new_game_panel = document.getElementById("new-game");
const game_over_panel = document.getElementById("game-over");
const scoreboard = document.getElementById("scoreboard");

// Kullanıcı canvas'inin boyutunu ayarlıyoruz.
userCanvas.width = 540;
userCanvas.height = 750;
// Orijinal canvas'in boyutunu ayarlıyoruz.
originalCanvas.width = 540;
originalCanvas.height = 750;

// Orijinal canvas'in arka planını belirliyoruz.
let original_context = originalCanvas.getContext("2d");
let original_start_background_color = "rgba(0, 0, 0, 0)";
original_context.fillStyle = original_start_background_color;
original_context.fillRect(0, 0, originalCanvas.width, originalCanvas.height);

// Kullanıcı canvas'inin arka planını belirliyoruz.
let context = userCanvas.getContext("2d");
let start_background_color = "rgba(0, 0, 0, 0)";
context.fillStyle = start_background_color;


context.fillRect(0, 0, userCanvas.width, userCanvas.height);
// Oyun durumu kontrolü için değişken.
let is_game_over = true;

// Zamanlayıcı ve sayacın başlangıç değerleri.
let countDownTime = 5;
let timerCountDown = 5;

// Başlangıç seviye indeksi ve çizim araçları.
let levelIndex = 1;
let draw_color = "black";
let draw_width = "50";
let is_drawing = false;

// Geri alma (undo) özelliği için değişkenler.
let restore_array = [];
let index = -1;

// Renk değiştirme işlevi.
function changeColor(element) {
    draw_color = element.style.background;
}
// Kullanıcı etkileşimleri için event listener'lar.
userCanvas.addEventListener("touchstart", start, false);
userCanvas.addEventListener("touchmove", draw, false);
userCanvas.addEventListener("mousedown", start, false);
userCanvas.addEventListener("mousemove", draw, false);

userCanvas.addEventListener("touchend", stop, false);
userCanvas.addEventListener("mouseup", stop, false);
userCanvas.addEventListener("mouseout", stop, false);

// Çizim işlemleri için başlangıç, çizim ve durdurma fonksiyonları.
function start(event) {
    if (!is_game_over) {
        is_drawing = true;
        context.beginPath();
        context.moveTo(event.clientX - userCanvas.offsetLeft, event.clientY - userCanvas.offsetTop);
        event.preventDefault();
    }
}

function draw(event) {
    if (!is_game_over) {
        if (is_drawing) {
            context.lineTo(event.clientX - userCanvas.offsetLeft, event.clientY - userCanvas.offsetTop);
            context.strokeStyle = draw_color;
            context.lineWidth = draw_width;
            context.lineCap = "round";
            context.lineJoin = "round";
            context.stroke();
        }
        event.preventDefault();
    }
}

function stop(event) {
    if (!is_game_over) {
        if (is_drawing) {
            context.stroke();
            context.closePath();
            is_drawing = false;
        }
        event.preventDefault();
        if (event.type != "mouseout") {
            restore_array.push(context.getImageData(0, 0, userCanvas.width, userCanvas.height));
            index += 1;
        }
    }
}
// Canvas'i temizleme fonksiyonu.
function clear_canvas() {
    context.fillStyle = start_background_color;
    context.clearRect(0, 0, userCanvas.width, userCanvas.height);
    context.fillRect(0, 0, userCanvas.width, userCanvas.height);
    restore_array = [];
    index = -1;
}
// Geri alma  fonksiyonu.
function undo_last() {
    if (index <= 0) {
        clear_canvas();
    } else {
        index -= 1;
        restore_array.pop();
        context.putImageData(restore_array[index], 0, 0);
    }
}
// Seviye başlatma fonksiyonu.
function start_level() {
    userCanvas.style.backgroundImage = `url('images/colored/${levelIndex}.png')`;
    userCanvas.style.display = "flex";
    game_panel.style.display = "none";
    tools.style.display = "flex";
    is_game_over = false;
    const interval = setInterval(change_Background_Image, 5000);
    start_time = Date.now();
    countdown();
}
// Arka plan resmini değiştirme fonksiyonu.
function change_Background_Image() {
    userCanvas.style.backgroundImage = `url('images/normal/${levelIndex}.png')`;
}
// Geri sayım fonksiyonu.
function countdown() {
    if (countDownTime > 0) {
        timer.style.display = "block";
        setTimeout(countdown, 1000);
        timer.innerHTML = countDownTime;
        countDownTime -= 1;
    } else {
        timer.style.display = "none";
        countDownTime = 5;
        game_panel.style.display = "none";
        show_tools();
        countdown_game();
    }
}
// Oyun süresini gösterme ve seviye bitirme fonksiyonu.
function countdown_game() {
    timer.innerHTML = timerCountDown;
    if (timerCountDown > 0) {
        timer.style.display = "flex";
        setTimeout(countdown_game, 1000);
    } else {
        timer.style.display = "none";
        timerCountDown = 300;//saniye ayarlama kısmıdır.
        level_over();
    }
    timerCountDown -= 1;
}
// Çizim araçlarını gösterme fonksiyonu.
function show_tools() {
    tools.style.visibility = "visible";
}
// Kullanıcı tarafından yapılan renk farkını hesaplama fonksiyonu.
function calculateColorDiff(originalColor, userColor) {
    const rDiff = Math.abs(originalColor.r - userColor.r);
    const gDiff = Math.abs(originalColor.g - userColor.g);
    const bDiff = Math.abs(originalColor.b - userColor.b);
    return Math.sqrt(rDiff * rDiff + gDiff * gDiff + bDiff);
}
// Kullanıcının toplam renk skorunu hesaplama fonksiyonu.
function calculateColorScore() {
    let totalColorDiff = 0;
    const originalImageData = original_context.getImageData(0, 0, originalCanvas.width, originalCanvas.height);
    const userImageData = context.getImageData(0, 0, userCanvas.width, userCanvas.height);
    const pixelData = originalImageData.data;
    const userPixelData = userImageData.data;

    for (let i = 0; i < pixelData.length; i += 4) {
        const originalColor = {
            r: pixelData[i],
            g: pixelData[i + 1],
            b: pixelData[i + 2]
        };
        const userColor = {
            r: userPixelData[i],
            g: userPixelData[i + 1],
            b: userPixelData[i + 2]
        };
        totalColorDiff += calculateColorDiff(originalColor, userColor);
    }

    const colorScore = 162 -  Math.ceil(totalColorDiff / (pixelData.length / 4));
    return colorScore;
}
// Seviye bitirme fonksiyonu.
function level_over() {
    is_game_over = true;
    timer.style.display = "none";
    tools.style.display = "none";
    new_game_panel.style.display = "none";
    game_over_panel.style.display = "flex";
    game_panel.style.display = "flex";
    // Orijinal resmi ekrana yüklüyoruz.
    const image = new Image();
    image.onload = function () {
        original_context.drawImage(image, 0, 0);
        let score = calculateColorScore();
        if(score < 0) score = 0;
        show_score(score);// Skoru gösteriyoruz.
        save_score(score);// Skoru kaydediyoruz.
    };
    image.src = `images/colored/${levelIndex}.png`// Orijinal resmin yolunu belirtiyoruz.
    originalCanvas.style.display = "flex";// Orijinal canvas'i görünür yapıyoruz.
}
// Skoru gösterme fonksiyonu.
function show_score(score) {
    document.getElementById("total_score").innerText = score;
}
// Bir sonraki seviyeye geçme fonksiyonu.
function next_level() {
    if(levelIndex < 5){
        originalCanvas.style.display = "none";
        clear_canvas();
        levelIndex += 1;
        start_level();
    }
    else{
        alert("Oyun Bitti !");
        window.location(index.asp);
    }
}
// Skor tablosunu gösterme fonksiyonu.
function show_scoreboard() {
    scoreboard.style.display = "block";
    game_panel.style.display = "none";
}
// Skor tablosunu gizleme fonksiyonu.
function hide_scoreboard() {
    scoreboard.style.display = "none";
    game_panel.style.display = "block";
}
// Skoru sunucuya kaydetme fonksiyonu.
function save_score(score){
     // Konsola kayıt mesajı yazdırıyoruz
    console.log("Skor kaydedildi 1");
  // XMLHttp isteği oluşturuyoruz.
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "skorKaydet.asp", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
            // Başarılı bir şekilde tamamlandığında yapılacak işlemler buraya yazılır.
        }
    };
    xhr.send("score=" + score); // Skor verisini gönderiyoruz.


    console.log("Skor kaydedildi");
}
