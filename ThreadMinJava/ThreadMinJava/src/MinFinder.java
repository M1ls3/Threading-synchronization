import java.util.Random;
class MinFinder extends Thread {
    private final int startIndex;
    private final int finishIndex;
    private final ArrClass arrClass;

    public MinFinder(int startIndex, int finishIndex, ArrClass arrClass) {
        this.startIndex = startIndex;
        this.finishIndex = finishIndex;
        this.arrClass = arrClass;
    }

    @Override
    public void run() {
        int min = arrClass.arr[startIndex];
        int index = startIndex;
        for (int i = startIndex + 1; i < finishIndex; i++) {
            if (arrClass.arr[i] < min) {
                min = arrClass.arr[i];
                index = i;
            }
        }
        arrClass.updateMin(min, index);
    }
}
