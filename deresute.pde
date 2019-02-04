import http.requests.*;
import java.util.Arrays;
import java.util.List;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.time.Instant;
PFont myFont, smallFont;

String gameID = "", status = "入力を待っています";
String Pname = "名無し", comment = "よろしくお願いします！";
int PLv = 999, PRP = 9999, fan, album, commu ;
Date cDate = new Date(0), lDate = new Date(0);
NumberFormat numFormat = NumberFormat.getNumberInstance();

void setup() {
  size(600, 400);
  background(250, 250, 250);
  frameRate(30);
  if (Arrays.asList(PFont.list()).contains("游ゴシック Medium")) {
    myFont = createFont("游ゴシック Medium", 20, true);
    smallFont = createFont("游ゴシック Medium", 15, true);
  } else {
    myFont = createFont("YuGothic", 20, true);
    smallFont = createFont("YuGothic", 15, true);
  }
}

void draw() {
  background(250, 250, 250);
  fill(255);
  rect(20, 74, 560, 38);
  fill(0);

  textFont(myFont);
  text("ゲームIDを入力してください", 20, 37);
  text(gameID, 25, 100);
  text(Pname + "Ｐ", 80, 145);

  textFont(smallFont);
  text("Enterキーで取得を開始します", 20, 62);
  text("✕", 560, 99);
  text(status, 20, 385);
  text("Lv" + PLv, 20, 143);
  text("PRP" + PRP, 510, 143);
  text(comment, 20, 173);

  text("ゲーム開始日:" + new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss").format(cDate), 20, 220);
  text("最終ログイン:" + new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss").format(lDate), 20, 245);
  text("合計ファン数:" + numFormat.format(fan) + "人", 20, 270);
  text("アルバム登録数:" + album, 20, 295);
  text("コミュ達成数:" + commu, 20, 320);

  line(20, 190, 580, 190);
}

void keyPressed() {
  if ( keyCode == 10 ) {
    status = "データを取得しています...";
    getData(gameID);
    return;
  }
  gameID = gameID + key;
}

void mouseClicked(){
  gameID = "";
}
void getData(String gameID) {
  status = "データを取得しています...";
  GetRequest get = new GetRequest("https://deresute.me/"+gameID+"/json");
  try {
    get.send();
    JSONObject result = parseJSONObject(get.getContent());
    status = "取得が完了しました";
    comment = result.getString("comment");
    Pname = result.getString("name");
    PLv = result.getInt("level");
    PRP = result.getInt("prp");
    fan = result.getInt("fan");
    cDate = Date.from( Instant.ofEpochSecond( result.getInt("creation_ts") ) );
    lDate = Date.from( Instant.ofEpochSecond( result.getInt("last_login_ts") ) );
    album = result.getInt("album_no");
    commu = result.getInt("commu_no");
  }
  catch (RuntimeException e) {
    status = "データを取得できませんでした";
    println(e);
  }
}
