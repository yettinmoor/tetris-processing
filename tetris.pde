Game g;

void setup() {
    size(500, 500);
    g = new Game();
}

void draw() {
    g.run();
}

void keyPressed() {
    switch (key) {
    case 'h':
        g.moveMino(-1);
        break;
    case 'l':
        g.moveMino(1);
        break;
    case 'j':
        g.moveMino(0);
        break;
    case 'k':
        g.moveMino(2);
        break;
    case ' ':
        g.pause();
        break;
    }
}
