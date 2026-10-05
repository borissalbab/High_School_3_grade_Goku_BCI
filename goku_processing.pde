import processing.serial.*;

PImage[] gokuImages = new PImage[4]; // 오공1~오공4
float smoothAttention = 0;
float displayedAttention = 0;

Serial tgamPort;
int[] packet = new int[256];
int idx = 0;
boolean readingPacket = false;

int attention = 0;
int signalQuality = 200;
int betaPower = 0;

void setup() {
  fullScreen();  // 전체 화면으로 설정
  println("[포트 목록]");
  printArray(Serial.list());

  try {
    tgamPort = new Serial(this, "COM4", 57600);
    tgamPort.buffer(1);
  } catch (Exception e) {
    println("⚠️ 시리얼 포트 열기 실패: " + e.getMessage());
  }

  for (int i = 0; i < gokuImages.length; i++) {
    String fileName = "오공" + (i + 1) + ".png";
    gokuImages[i] = loadImage(fileName);
    if (gokuImages[i] == null) {
      println("❌ 이미지 로딩 실패: " + fileName);
    }
  }
}

void draw() {
  if (tgamPort != null) {
    while (tgamPort.available() > 0) {
      serialEvent(tgamPort);
    }
  }

  smoothAttention = lerp(smoothAttention, attention, 0.1);
  displayedAttention = lerp(displayedAttention, smoothAttention, 0.2);

  float normAttention = constrain(displayedAttention / 100.0, 0, 1);
  float stage = normAttention * (gokuImages.length - 1);
  int baseIndex = floor(stage);
  int nextIndex = min(baseIndex + 1, gokuImages.length - 1);
  float blendAmount = stage - baseIndex;

  PImage blended = blendImages(gokuImages[baseIndex], gokuImages[nextIndex], blendAmount);
  image(blended, 0, 0, width, height); // 전체 화면에 맞게 이미지 출력

  // 텍스트 표시
  fill(255);
  textSize(32);
  text("Attention: " + int(displayedAttention), 30, 50);
  text("Signal Quality: " + signalQuality, 30, 90);
}

PImage blendImages(PImage imgA, PImage imgB, float alpha) {
  PImage result = createImage(imgA.width, imgA.height, RGB);
  imgA.loadPixels();
  imgB.loadPixels();
  result.loadPixels();

  for (int i = 0; i < imgA.pixㅂels.length; i++) {
    color cA = imgA.pixels[i];
    color cB = imgB.pixels[i];

    int r = int(lerp(red(cA), red(cB), alpha));
    int g = int(lerp(green(cA), green(cB), alpha));
    int b = int(lerp(blue(cA), blue(cB), alpha));

    result.pixels[i] = color(r, g, b);
  }

  result.updatePixels();
  return result;
}

boolean isReliableAttention(int attention, int signalQ, int beta) {
  return signalQ <= 50 &&
         attention >= 0 && attention <= 100 &&
         abs(attention - scaleBetaToAttention(beta)) < 30;
}

int scaleBetaToAttention(int betaPower) {
  return constrain((int)(betaPower / 600.0), 0, 100);
}

void serialEvent(Serial p) {
  int inByte = p.read() & 0xFF;

  if (!readingPacket) {
    if (inByte == 0xAA && packet[0] == 0xAA) {
      idx = 0;
      packet[idx++] = inByte;
      readingPacket = true;
    } else {
      packet[0] = inByte;
    }
  } else {
    if (idx < packet.length) {
      packet[idx++] = inByte;
      int payloadLength = packet[2];
      if (idx == 3 + payloadLength + 1) {
        parseTGAM(packet, 3, payloadLength);
        idx = 0;
        readingPacket = false;
      }
    } else {
      println("⚠️ 패킷 길이 초과. 패킷 무시 후 초기화됨");
      idx = 0;
      readingPacket = false;
    }
  }
}

void parseTGAM(int[] data, int start, int length) {
  int i = start;
  while (i < start + length) {
    int code = data[i++];
    if (code == 0x02) {
      signalQuality = data[i++];
    } else if (code == 0x04) {
      int val = data[i++];
      if (val >= 0 && val <= 100) attention = val;
    } else if (code == 0x83) {
      int len = data[i++];
      if (len == 24) {
        i += 4 * 3;
        int lowBeta = (data[i++] << 16) | (data[i++] << 8) | data[i++];
        int highBeta = (data[i++] << 16) | (data[i++] << 8) | data[i++];
        betaPower = lowBeta + highBeta;
        println("▶ Beta Power (low+high): " + betaPower);
        i += 8 * 3 - 6 * 3;
      } else {
        i += len;
      }
    } else if (code >= 0x80) {
      int len = data[i++];
      i += len;
    } else {
      i++;
    }
  }
}
