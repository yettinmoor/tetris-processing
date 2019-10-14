class MinoConstructor {
    color[] c;
    int[][][] shapes;

    MinoConstructor() {
        c = new color[] {
            #99aacc, #a1bb39, #22ff66, #ffea10,
            #ef33ee, #11aaff, #ee4422,
        };

        shapes = new int[][][] {
            { {0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}, },
            { {0, 0, 1, 0}, {0, 0, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, },
            { {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, },
            { {0, 0, 0, 0}, {0, 1, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, },
            { {0, 0, 1, 0}, {0, 1, 1, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}, },
            { {0, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 1, 0}, {0, 0, 0, 0}, },
            { {0, 0, 1, 0}, {0, 1, 1, 0}, {0, 0, 1, 0}, {0, 0, 0, 0}, },
        };
    }

    color getColor(int index) {
        return c[index - 1];
    }

    int[][] getShape(int index) {
        int[][] ret = new int[4][4];
        for (int i = 0; i < ret.length; i++)
            ret[i] = shapes[index - 1][i].clone();
        return ret;
    }
}
