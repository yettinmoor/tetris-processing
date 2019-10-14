import java.util.*;

class Game {
    PVector fPos;
    int fWidth, fHeight, fGridWidth, fGridHeight, gridSize;
    int[][] field;

    Stack<Integer> rowsToDelete;

    boolean paused;

    int forceDownTimer, forceDownTimerMax;
    int points, pointsBuffer, pointsOnScreenTimer;

    MinoConstructor mc;
    Mino activeMino, bufferMino;

    Game() {
        fPos = new PVector(width*.05, width*.05);
        fGridWidth = 10;
        fGridHeight = 20;
        gridSize = (int)(.9*height/20);
        fWidth = fGridWidth * gridSize;
        fHeight = fGridHeight * gridSize;

        rowsToDelete = new Stack();

        paused = false;

        forceDownTimer = forceDownTimerMax = 60;
        points = pointsBuffer = pointsOnScreenTimer = 0;

        field = new int[fGridHeight][fGridWidth];
        mc = new MinoConstructor();
        bufferMino = new Mino(mc);
        newMino();
    }

    public void run() {
        background(#030323);
        drawField();
        drawSurrounding();
        if (!rowsToDelete.empty()) {
            deleteRows();
            return;
        }
        if (activeMino == null)
            newMino();
        if (!paused) {
            cleanPointsBuffer();
            if (--forceDownTimer <= 0)
                moveDown();
        }
        activeMino.drawSelf(gridSize);
    }

    /* -1/1 = left/right, 2 = rotate, 0 = down */
    public void moveMino(int dir) {
        if (paused || activeMino == null || !rowsToDelete.empty()) return;
        switch (dir) {
        case 1:
        case -1:
            activeMino.posX += dir;
            if (checkCollide())
                activeMino.posX -= dir;
            break;
        case 0:
            moveDown();
            break;
        case 2:
            activeMino.rotate(1);
            if (checkCollide())
                activeMino.rotate(-1);
            break;
        }
    }

    public void pause() {
        paused = !paused;
    }

    private void cleanPointsBuffer() {
        if (pointsOnScreenTimer-- == 100) {
            points += pointsBuffer;
        } else if (pointsOnScreenTimer <= 0) {
            pointsBuffer = 0;
            pointsOnScreenTimer = 0;
        }
    }

    /* deletes one block at a time (in order to animate row deletion) */
    /* only runs if rowsToDelete is non-empty */
    private void deleteRows() {
        int i = rowsToDelete.peek();
        for (int j = 0; j < fGridWidth; j++) {
            if (field[i][j] != 0) {
                field[i][j] = 0;
                delay(20);
                return;
            }
        }
        rowsToDelete.pop();
        contractRows(i);
        pointsBuffer = 2*pointsBuffer + 100;
        pointsOnScreenTimer = 100;
    }

    /* shifts all rows down after row clear */
    private void contractRows(int startRow) {
        for (int i = startRow; i >= 1; i--)
            field[i] = field[i-1].clone();
    }

    private void moveDown() {
        forceDownTimer = forceDownTimerMax;
        ++activeMino.posY;
        if (checkCollide()) {
            --activeMino.posY;
            freezeMino();
            checkRows();
        }
    }

    private void freezeMino() {
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                if (activeMino.getIndexVal(j, i) == 1)
                    field[activeMino.posY+i][activeMino.posX+j] = activeMino.index;
            }
        }
        activeMino = null;
    }

    private void checkRows() {
        for (int i = fGridHeight - 1; i >= 0; i--) {
            boolean rowFull = true;
            for (int j = 0; j < fGridWidth && rowFull; j++) {
                if (field[i][j] == 0)
                    rowFull = false;
            }
            if (rowFull)
                rowsToDelete.push(i);
        }
    }

    private void newMino() {
        activeMino = bufferMino;
        if (checkCollide())
            gameOver();
        bufferMino = new Mino(mc);
    }

    private boolean checkCollide() {
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                if (activeMino.getIndexVal(j, i) == 0)
                    continue;
                if (activeMino.posX + j < 0
                        || activeMino.posX + j >= fGridWidth
                        || activeMino.posY + i < 0
                        || activeMino.posY + i >= fGridHeight
                        || field[activeMino.posY+i][activeMino.posX+j] != 0)
                    return true;
            }
        }
        return false;
    }

    private void drawField() {
        translate(fPos.x, fPos.y);

        fill(#232323);
        noStroke();
        rect(0, 0, fWidth, fHeight);

        // GRID
        stroke(100);
        strokeWeight(1);
        for (int i = 0; i <= fWidth; i += gridSize)
            line(i, 0, i, fHeight);
        for (int i = 0; i <= fHeight; i += gridSize)
            line(0, i, fWidth, i);

        // FROZEN MINOS
        stroke(0);
        for (int i = 0; i < fGridHeight; i++) {
            for (int j = 0; j < fGridWidth; j++) {
                if (field[i][j] != 0) {
                    fill(mc.getColor(field[i][j]));
                    rect(gridSize*j, gridSize*i, gridSize, gridSize);
                }
            }
        }

        // PAUSED?
        if (paused) {
            fill(#eeeeee);
            textSize(40);
            textAlign(CENTER, CENTER);
            text("PAUSED", fWidth/2, fHeight/2);
        }
    }

    private void drawSurrounding() {
        pushMatrix();
        translate(fWidth, 0);
        textAlign(LEFT, TOP);

        // BUFFER MINO
        stroke(255);
        fill(240, 100, 200);
        rect(width/6-25, 2*fHeight/3-25, 4*gridSize+50, 4*gridSize+50);
        bufferMino.drawSelf(width/6, 2*fHeight/3, gridSize);

        // POINTS
        fill(240, 240, 50);
        textSize(20);
        text(String.format("POINTS: %06d", points), 50, 50);
        if (pointsOnScreenTimer > 0) {
            textSize(30);
            text(String.format("+%d!!", pointsBuffer), 50, 100);
        }

        // TIMER
        stroke(240);
        strokeWeight(2);
        noFill();
        arc(125, 2*fHeight/5, 50, 50,
                0, TWO_PI*(1-(float)forceDownTimer/(float)forceDownTimerMax));
        popMatrix();
    }

    private void gameOver() {
        activeMino.drawSelf(gridSize);
        fill(#e1e2bb);
        textSize(50);
        textAlign(CENTER, CENTER);
        text("GAME OVER!", fWidth/2, fHeight/2);
        noLoop();
    }
}
