import java.util.Random;

class ArrClass {
    private final int dim;
    private final int threadNum;
    public int[] arr;
    private int minIndex;
    private int minValue = Integer.MAX_VALUE;

    public ArrClass(int dim, int threadNum) {
        this.dim = dim;
        this.threadNum = threadNum;
        arr = new int[dim];
        Random rnd = new Random();
        for(int i = 0; i < dim; i++){
            arr[i] = rnd.nextInt(10000000); // Fill up array
        }
        arr[rnd.nextInt(dim)] = -1 * rnd.nextInt(10000000);
    }

    public synchronized void updateMin(int min, int index) {
        if (min < minValue) {
            minValue = min;
            minIndex = index;
        }
    }

    public void threadMin() {
        int partSize = dim / threadNum;
        MinFinder[] threads = new MinFinder[threadNum];
        for (int i = 0; i < threadNum; i++) {
            int start = i * partSize;
            int end = (i == threadNum - 1) ? dim : (i + 1) * partSize;
            threads[i] = new MinFinder(start, end, this);
            threads[i].start();
        }

        try {
            for (MinFinder thread : threads) {
                thread.join();
            }
        }
        catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Min value: [" + minIndex + "] = " + minValue);
    }
}

