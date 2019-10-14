class Mino {
    int index, posX, posY;
    int[][] shape;
    color c;

    Mino(MinoConstructor mc) {
        this.index = int(random(1, 8));
        this.shape = mc.getShape(index);
        this.c = mc.getColor(index);
        rotate(int(random(0, 4)));
    }

    public void drawSelf(int size) {
        stroke(0);
        strokeWeight(1);
        fill(c);
        for (int i = 0; i < shape.length; i++) {
            for (int j = 0; j < shape[i].length; j++) {
                if (shape[i][j] != 0)
                    rect(size*(posX+j), size*(posY+i), size, size);
            }
        }
    }

    public void drawSelf(float x, float y, int size) {
        stroke(0);
        strokeWeight(1);
        fill(c);
        for (int i = 0; i < shape.length; i++) {
            for (int j = 0; j < shape[i].length; j++) {
                if (shape[i][j] != 0)
                    rect(x+size*j, y+size*i, size, size);
            }
        }
    }

    public void rotate(int times) {
        int[][] rotShape = new int[4][4];
        if (times < 0) times += 4;
        while (times-- > 0) {
            for (int i = 0; i < shape.length; i++) {
                for (int j = 0; j < shape[i].length; j++)
                    rotShape[i][j] = shape[3 - j][i];
            }
            for (int i = 0; i < shape.length; i++) {
                for (int j = 0; j < shape[i].length; j++)
                    shape[i][j] = rotShape[i][j];
            }
        }
    }

    public int getIndexVal(int x, int y) {
        return shape[y][x];
    }
}
